package com.eapproval.approval.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.eapproval.approval.dao.DocumentMapper;
import com.eapproval.approval.vo.DocumentVO;

@Service
public class DocumentService {
	
	@Autowired
	private DocumentMapper documentMapper;
	
	@Transactional
	public int saveDraft(DocumentVO documentVO) {
		documentVO.setStatus("DRAFT"); // 상태값 :대기, 승인 등
		documentVO.setApprovalType("SEQUENTIAL");   // 기본값: 순차 결재
		return documentMapper.insertDocument(documentVO);
	}
	// 리스트 조회
	public List<DocumentVO> getDraftList(Long employeeId){

		return documentMapper.selectDraftList(employeeId);
	}
	
	// 임시저장 1건 조회
	public DocumentVO getDraft( Long docId,Long employeeId) {
		return documentMapper.selectDraft(docId, employeeId);
	}
	@Transactional
	// 임시저장 1건 수정저장
	public int updateDraft(DocumentVO documentVO) {
		return documentMapper.updateDraft(documentVO);
	}
	
}
