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
		int result = documentMapper.insertDocument(documentVO); // 여기서 docId 가 생긴다
		saveApprovalLines(documentVO); // 그래서 이 뒤에 부른다
		saveVacation(documentVO);
		return result;
	}

	// 임시저장은 여러 번 누를 수 있고 상신도 임시저장 위에 얹힌다.
	// INSERT 만 하면 줄이 쌓이므로 항상 지우고 다시 넣는다.
	private void saveApprovalLines(DocumentVO documentVO) {

		// 기존에 등록되어 있던 해당 문서(docId)의 결재선 전체 삭제 (중복 방지)
		documentMapper.deleteApprovalLines(documentVO.getDocId(), documentVO.getEmployeeId());

		// 새로 저장할 결재선 목록 꺼내기
		List<ApprovalLineVO> lines = documentVO.getApprovalLine();
		if (lines == null || lines.isEmpty()) {
			return;
		} // 임시저장은 결재선이 없어도 정상

		// 결재선 객체마다 필요한 정보(문서ID, 순서, 상태 등) 세팅
		for (int i = 0; i < lines.size(); i++) {
			ApprovalLineVO line = lines.get(i);
			line.setDocId(documentVO.getDocId());
			line.setApprovalOrder(i + 1);
			line.setApprovalStatus("PENDING");
			line.setApprovalType("APPROVAL");
		}
		// 완성이 완료된 결재선 목록을 DB에 저장
		documentMapper.insertApprovalLines(lines);
	}

	// 휴가 신청 정보를 지우고 다시 저장 / 이유: 임시저장은 여러번 누를 수 있는데 INSERT 만 하면 줄이 쌓이고,
	// UPDATE 만 하면 첫 저장 때 고칠 행이 없어 0건이 된다. 그래서 지우고 넣는다.
	private void saveVacation(DocumentVO documentVO) {

		// 기존에 작성된 휴가 신청 정보 삭제
		documentMapper.deleteVacationRequest(documentVO.getDocId(), documentVO.getEmployeeId());

		VacationRequestVO v = documentVO.getVacation();
		if (v == null) {
			return;
		} // 휴가 신청서가 아닌 일반 문서면 여기서 끝

		// 휴가 신청 객체에 문서 ID 및 작성자 사원 ID 매핑
		v.setDocId(documentVO.getDocId());
		v.setEmployeeId(documentVO.getEmployeeId());

		// 시작일과 종료일이 모두 존재하는 경우에만 휴가 일수 계산
		if (v.getStartDate() != null && v.getEndDate() != null) {
			v.setDays(calcDays(v));
		}
		v.setStartHalf(nullIfEmpty(v.getStartHalf())); // DB 저장을 위해 null 처리
		v.setEndHalf(nullIfEmpty(v.getEndHalf()));

		documentMapper.insertVacationRequest(v); // 최종저장
	}

	// 상신
	@Transactional
	public void submitDocument(DocumentVO documentVO) {

		// 결재선 존재 유무 검증 / null 을 먼저 검사 — 리스트가 없으면 isEmpty() 자체가 터진다
		List<ApprovalLineVO> lines = documentVO.getApprovalLine();
		if (lines == null || lines.isEmpty()) {
			throw new IllegalStateException("결재선이 없습니다.");
		}

		// 문서 메인 데이터 저장 (신규 vs 임시저장 구분)
		if (documentVO.getDocId() == null) {
			documentVO.setStatus("PENDING"); // 결재'대기'상태로 셋팅
			documentVO.setApprovalType("SEQUENTIAL");// 기본값: 순차 결재
			documentMapper.insertDocument(documentVO); // DB에 새로 저장
		} else {
			documentMapper.submitDocument(documentVO); // 기존 임시저장 문서를 '상신'으로 업데이트
		}

		saveApprovalLines(documentVO); // 결재선 저장

		// 휴가 관련정보를 request테이블에 저장
		// 휴가 문서일 때만 vacation_request 에 한 줄 더 넣는다
		if (documentVO.getVacation() != null) {
			VacationRequestVO v = documentVO.getVacation();
			v.setDocId(documentVO.getDocId());
			v.setEmployeeId(documentVO.getEmployeeId());
			if (v.getReason() == null || v.getReason().trim().isEmpty()) {
				throw new IllegalStateException("휴가 사유를 입력해주세요.");
			}
			if (v.getStartDate() == null || v.getEndDate() == null || v.getStartDate().isAfter(v.getEndDate())) {
				throw new IllegalStateException("휴가 시작일이 종료일보다 늦습니다.");
			}
			v.setDays(calcDays(v)); // 연차 계산해서 세팅
			VacationTypeVO type = documentMapper.selectVacationType(v.getVacationTypeId());
			if (type != null && type.isDeductBalance()) { // 연차가 차감되는 휴가 유형이라면

				// 사용 가능 연차 = (잔여 연차 - 이미 신청되어 대기 중인 연차)
				LeaveSummaryVO s = getLeaveSummary(documentVO.getEmployeeId());
				BigDecimal available = s.getRemainDays().subtract(s.getPendingDays());

				// 신청 일수가 사용 가능 연차보다 크면 예외 발생
				if (v.getDays().compareTo(available) > 0) {
					throw new IllegalStateException("신청 가능한 연차를 넘었습니다.");
				}
			}
		}
		saveVacation(documentVO);
	}

	// 근무일 수 세기 (토·일 제외). 공휴일은 아직...
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

	// 화면에서 온 빈 문자열은 '값 없음'으로 통일
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
		int result = documentMapper.updateDraft(documentVO);
		saveApprovalLines(documentVO);
		saveVacation(documentVO);
		return result;
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

	// 추천 상사 결재 라인 //approval_order로 상사라인은 데이터베이스로 셋팅 해놓았음
	public List<EapprovalVO> recommendApprovalLine(long employeeId, String documentType) {

		int depth = "VACATION".equals(documentType) ? 2 : 0;

		List<EapprovalVO> line = new ArrayList<>(); // 추천 결재자들을 담을 리스트
		long cur = employeeId; // 현재 상사를 찾을 대상 사원 ID (처음엔 '나')
		for (int i = 0; i < depth; i++) {
			EapprovalVO m = employeeMapper.selectManager(cur); // cur 사원의 직속 상사 조회
			if (m == null)
				break; // 최고 책임자까지 올라갔으면 멈춤
			line.add(m); // 찾은 상사를 결재선에 추가
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

		// 문서 DB에서 사원의 연차 사용 및 대기 일수 조회
		LeaveSummaryVO s = documentMapper.selectLeaveSummary(employeeId);

		// 휴가를 한 번도 안 냈으면 행 자체가 안 나와서 null 이 온다
		if (s == null)
			s = new LeaveSummaryVO();

		if (s.getUsedDays() == null)
			s.setUsedDays(BigDecimal.ZERO); // 사용 일수가 없으면 0으로 초기화

		if (s.getPendingDays() == null)
			s.setPendingDays(BigDecimal.ZERO); // 결재 대기 중인 일수가 없으면 0으로 초기화

		// 사원 DB에서 현재 남아있는 연차 잔여 일수 조회
		BigDecimal remain = employeeMapper.selectRemainLeave(employeeId);
		if (remain == null)
			remain = BigDecimal.ZERO; // 잔여 연차가 null이면 0으로 초기화

		// 조회 및 계산된 연차 정보를 VO에 세팅
		s.setRemainDays(remain);
		s.setTotalDays(remain.add(s.getUsedDays())); // BigDecimal 은 + 가 아니라 .add()
		return s;
	}

	// 내 휴가 신청 내역. 예정/지난
	public Map<String, List<VacationRequestVO>> getMyLeaveList(Long employeeId) {

		// DB에서 해당 사원의 전체 휴가 신청 내역 조회
		List<VacationRequestVO> all = documentMapper.selectMyLeaveList(employeeId);

		// 휴가 목록을 담을 리스트 준비
		List<VacationRequestVO> upcoming = new ArrayList<>(); // 예정 또는 진행 중인 휴가
		List<VacationRequestVO> past = new ArrayList<>(); // 이미 종료된 지난 휴가

		LocalDate today = LocalDate.now(); // 오늘날짜구하기

		for (VacationRequestVO v : all) {
			// 종료일(endDate)이 null이 아니고, 오늘 이전(isBefore)에 끝났다면 지난 휴가로 분류, 아니면 예정 (오늘 포함)
			if (v.getEndDate() != null && v.getEndDate().isBefore(today)) {
				past.add(v);
			} else {
				upcoming.add(v);
			}
		}

		// 결과를 "Key-Value" 구조인 Map에 묶어서 반환
		Map<String, List<VacationRequestVO>> result = new HashMap<>();
		result.put("upcoming", upcoming);
		result.put("past", past);
		return result;
	}

}
