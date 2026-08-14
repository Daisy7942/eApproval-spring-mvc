package com.eapproval.approval.service;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.eapproval.approval.dao.DocumentMapper;
import com.eapproval.approval.vo.ApprovalLineVO;
import com.eapproval.approval.vo.DocumentVO;
import com.eapproval.approval.vo.LeaveSummaryVO;
import com.eapproval.approval.vo.VacationRequestVO;
import com.eapproval.approval.vo.VacationTypeVO;
import com.eapproval.employee.dao.EmployeeMapper;
import com.eapproval.employee.vo.EapprovalVO;

@Service
public class DocumentService {

	@Autowired
	private DocumentMapper documentMapper;

	@Autowired
	private EmployeeMapper employeeMapper;

	// 임시저장
	@Transactional
	public int saveDraft(DocumentVO documentVO) {
		documentVO.setStatus("DRAFT"); // 상태값 :대기, 승인 등
		documentVO.setApprovalType("SEQUENTIAL"); // 기본값: 순차 결재
		return documentMapper.insertDocument(documentVO);
	}

	// 상신
	@Transactional
	public void submitDocument(DocumentVO documentVO) {

		// null 을 먼저 검사 — 리스트가 없으면 isEmpty() 자체가 터진다
		List<ApprovalLineVO> lines = documentVO.getApprovalLine();
		if (lines == null || lines.isEmpty()) {
			throw new IllegalStateException("결재선이 없습니다.");
		}

		if (documentVO.getDocId() == null) {
			documentVO.setStatus("PENDING");
			documentVO.setApprovalType("SEQUENTIAL");// 기본값: 순차 결재
			documentMapper.insertDocument(documentVO);
		} else {
			documentMapper.submitDocument(documentVO);
		}

		// 화면이 보내온 건 approverId 뿐. 나머지는 서버가 채우기
		for (int i = 0; i < lines.size(); i++) {
			ApprovalLineVO line = lines.get(i);
			line.setDocId(documentVO.getDocId());
			line.setApprovalOrder(i + 1);
			line.setApprovalStatus("PENDING");
			line.setApprovalType("APPROVAL");
		}
		documentMapper.insertApprovalLines(lines);

		// 휴가 문서일 때만 vacation_request 에 한 줄 더 넣는다
		if (documentVO.getVacation() != null) {
			VacationRequestVO v = documentVO.getVacation();
			v.setDocId(documentVO.getDocId());
			v.setEmployeeId(documentVO.getEmployeeId());
			v.setDays(calcDays(v));
			v.setStartHalf(nullIfEmpty(v.getStartHalf()));
			v.setEndHalf(nullIfEmpty(v.getEndHalf()));
			documentMapper.insertVacationRequest(v);
		}
	}

	// 근무일 수 세기 (토·일 제외). 공휴일은 표가 없어서 아직 못 뺀다.
	private int countWorkDays(LocalDate from, LocalDate to) {
		LocalDate d = from;
		int n = 0;

		while (!d.isAfter(to)) {
			DayOfWeek w = d.getDayOfWeek();
			if (w != DayOfWeek.SATURDAY && w != DayOfWeek.SUNDAY) {
				n++;
			}
			d = d.plusDays(1);
		}
		return n;
	}

	// 실제 사용 일수. 반차면 0.5 로 친다.
	private BigDecimal calcDays(VacationRequestVO v) {
		int work = countWorkDays(v.getStartDate(), v.getEndDate());

		boolean half = v.getStartHalf() != null && !v.getStartHalf().isEmpty();
		if (half && work == 1) {
			return new BigDecimal("0.5");
		}
		return new BigDecimal(work);
	}

	// 화면에서 온 빈 문자열은 '값 없음'으로 통일한다
	private String nullIfEmpty(String s) {
		return (s == null || s.trim().isEmpty()) ? null : s;
	}

	// 임시저장 리스트 조회
	public List<DocumentVO> getDraftList(Long employeeId) {

		return documentMapper.selectDraftList(employeeId);
	}

	// 임시저장 1건 조회
	public DocumentVO getDraft(Long docId, Long employeeId) {
		return documentMapper.selectDraft(docId, employeeId);
	}

	@Transactional
	// 임시저장 1건 수정저장
	public int updateDraft(DocumentVO documentVO) {
		return documentMapper.updateDraft(documentVO);
	}

	// 임시저장 삭제
	@Transactional
	public int deleteDrafts(List<Long> docIds, Long employeeId) {
		return documentMapper.deleteDrafts(docIds, employeeId);
	}

	// 상신함 리스트 조회
	public List<DocumentVO> getSubmittedList(Long employeeId) {

		return documentMapper.selectSubmittedList(employeeId);
	}

	// 결재대기함 리스트 조회
	public List<DocumentVO> getPendingList(Long employeeId) {

		return documentMapper.selectPendingList(employeeId);
	}

	// 결재완료함 리스트 조회
	public List<DocumentVO> getCompletedList(Long employeeId) {

		return documentMapper.selectCompletedList(employeeId);
	}

	// 추천 상사 결재 라인
	public List<EapprovalVO> recommendApprovalLine(long employeeId, String documentType) {

		int depth = "VACATION".equals(documentType) ? 2 : 0;

		List<EapprovalVO> line = new ArrayList<>();
		long cur = employeeId;
		for (int i = 0; i < depth; i++) {
			EapprovalVO m = employeeMapper.selectManager(cur);
			if (m == null)
				break; // 최고 책임자까지 올라갔으면 멈춤
			line.add(m);
			cur = m.getEmployeeId(); // 다음은 이 사람의 상사
		}
		return line;
	}

	// 문서 상세 1건 조회
	public DocumentVO getDocumentDetail(Long docId, long empId) {

		DocumentVO doc = documentMapper.selectDocumentDetail(docId);
		if (doc == null) {
			throw new IllegalStateException("없는 문서입니다.");
		}

		// 기안자 본인이거나, 결재선에 이름이 올라 있어야 볼 수 있다
		boolean canRead = (doc.getEmployeeId() == empId);
		for (ApprovalLineVO line : doc.getApprovalLine()) {
			if (line.getApproverId() == empId) {
				canRead = true;
				break;
			}
		}
		if (!canRead) {
			throw new IllegalStateException("이 문서를 볼 권한이 없습니다.");
		}
		return doc;
	}

	// 문서 승인
	@Transactional
	public void approve(Long docId, Long empId, String comment) {
		int updated = documentMapper.updateApprovalStatus(docId, empId, "APPROVED", comment);
		if (updated == 0) {
			throw new IllegalStateException("결재 권한이 없거나 이미 처리된 문서입니다.");
		}

		int countPending = documentMapper.countPendingLines(docId);

		if (countPending == 0) {
			documentMapper.updateDocumentStatus(docId, "APPROVED");
			
			 // 휴가 문서이고, 연차에서 깎는 종류일 때만 기안자의 잔여 연차 차감
		    DocumentVO doc = documentMapper.selectDocumentDetail(docId);
		    VacationRequestVO v = doc.getVacation();
		    if (v != null && v.isDeductBalance()) {
		        documentMapper.deductLeave(doc.getEmployeeId(), v.getDays());
		    }

		}
	}

	// 문서 반려
	@Transactional
	public void reject(Long docId, Long empId, String comment) {
		int updated = documentMapper.updateApprovalStatus(docId, empId, "REJECTED", comment);
		if (updated == 0) {
			throw new IllegalStateException("결재 권한이 없거나 이미 처리된 문서입니다.");
		}
		documentMapper.updateDocumentStatus(docId, "REJECTED");

	}

	// vacation 종류 칩 조회
	public List<VacationTypeVO> getVacationTypeList() {

		return documentMapper.selectVacationTypes();
	}
	
	
	
	// 연차 요약 (총부여·사용·대기·잔여)
	public LeaveSummaryVO getLeaveSummary(Long employeeId) {

		LeaveSummaryVO s = documentMapper.selectLeaveSummary(employeeId);

		// 휴가를 한 번도 안 냈으면 행 자체가 안 나와서 null 이 온다
		if (s == null) s = new LeaveSummaryVO();
		if (s.getUsedDays() == null)    s.setUsedDays(BigDecimal.ZERO);
		if (s.getPendingDays() == null) s.setPendingDays(BigDecimal.ZERO);

		BigDecimal remain = employeeMapper.selectRemainLeave(employeeId);
		if (remain == null) remain = BigDecimal.ZERO;

		s.setRemainDays(remain);
		s.setTotalDays(remain.add(s.getUsedDays()));   // BigDecimal 은 + 가 아니라 .add()
		return s;
	}
	
	
	// 내 휴가 신청 내역.  예정/지난
	public Map<String, List<VacationRequestVO>> getMyLeaveList(Long employeeId) {

	    List<VacationRequestVO> all = documentMapper.selectMyLeaveList(employeeId);

	    List<VacationRequestVO> upcoming = new ArrayList<>();
	    List<VacationRequestVO> past     = new ArrayList<>();

	    LocalDate today = LocalDate.now();
	    for (VacationRequestVO v : all) {
	        // 종료일이 어제까지면 지난 휴가, 오늘 이후면 예정
	        if (v.getEndDate() != null && v.getEndDate().isBefore(today)) {
	            past.add(v);
	        } else {
	            upcoming.add(v);
	        }
	    }

	    Map<String, List<VacationRequestVO>> result = new HashMap<>();
	    result.put("upcoming", upcoming);
	    result.put("past", past);
	    return result;
	}

}
