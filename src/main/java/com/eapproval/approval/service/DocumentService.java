package com.eapproval.approval.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.eapproval.approval.dao.DocumentMapper;
import com.eapproval.approval.vo.ApprovalLineVO;
import com.eapproval.approval.vo.DocumentVO;
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
		
		//화면이 보내온 건 approverId 뿐. 나머지는 서버가 채우기
		for (int i = 0; i < lines.size(); i++) {
		    ApprovalLineVO line = lines.get(i);
		    line.setDocId(documentVO.getDocId());
		    line.setApprovalOrder(i+1);
		    line.setApprovalStatus("PENDING");
		    line.setApprovalType("APPROVAL");
		}
		documentMapper.insertApprovalLines(lines);
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

	//임시저장 삭제
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
	        if (m == null) break;          // 최고 책임자까지 올라갔으면 멈춤
	        line.add(m);
	        cur = m.getEmployeeId();       // 다음은 이 사람의 상사
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
	        if (line.getApproverId() == empId) { canRead = true; break; }
	    }
	    if (!canRead) {
	        throw new IllegalStateException("이 문서를 볼 권한이 없습니다.");
	    }
	    return doc;
	}
}
