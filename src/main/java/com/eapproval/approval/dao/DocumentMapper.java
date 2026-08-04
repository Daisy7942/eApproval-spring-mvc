package com.eapproval.approval.dao;

import org.apache.ibatis.annotations.Mapper;

import com.eapproval.approval.vo.DocumentVO;

@Mapper
public interface DocumentMapper {
	
	int insertDocument(DocumentVO documentVO);
}
