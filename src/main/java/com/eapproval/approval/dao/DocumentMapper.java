package com.eapproval.approval.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.eapproval.approval.vo.DocumentVO;

@Mapper
public interface DocumentMapper {
	// 저장
	int insertDocument(DocumentVO documentVO);
	// 조회
	List<DocumentVO> selectDraftList(Long employeeId);
}
