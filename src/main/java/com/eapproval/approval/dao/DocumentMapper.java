package com.eapproval.approval.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
	
	
}
