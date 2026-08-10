package com.eapproval.approval.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.eapproval.approval.vo.ApprovalLineVO;
import com.eapproval.approval.vo.DocumentVO;

@Mapper
public interface DocumentMapper {
	// 저장
	int insertDocument(DocumentVO documentVO);
	
	// 조회
	List<DocumentVO> selectDraftList(Long employeeId);
	
	// 수정조회
	DocumentVO selectDraft(@Param("docId") Long docId,  @Param("employeeId") Long employeeId);
	
	// 수정저장
	int updateDraft(DocumentVO documentVO);
	
	// 삭제
	int deleteDrafts(@Param("docIds") List<Long> docIds, @Param("employeeId") Long employeeId);
	
	// 결재선 여러건 저장
	void insertApprovalLines(@Param("lines") List<ApprovalLineVO> lines);
	
	// 상신 : status DRAFT → PENDING 
	int submitDocument(DocumentVO documentVO);
	
	// 상신함 조회
	List<DocumentVO> selectSubmittedList(Long employeeId);
	
	// 결재 대기함 조회
	List<DocumentVO> selectPendingList(Long employeeId);
	
	// 완료함 조회
	List<DocumentVO> selectCompletedList(Long employeeId);
}
