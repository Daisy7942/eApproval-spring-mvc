package com.eapproval.approval.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.eapproval.approval.dao.DocumentMapper;
import com.eapproval.approval.vo.ApprovalLineVO;
import com.eapproval.approval.vo.DocumentVO;

@Service
public class DocumentService {

	@Autowired
	private DocumentMapper documentMapper;

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
}
