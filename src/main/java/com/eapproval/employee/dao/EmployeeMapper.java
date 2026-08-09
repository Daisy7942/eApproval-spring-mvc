package com.eapproval.employee.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.eapproval.employee.vo.EapprovalVO;
import com.eapproval.employee.vo.OrgVO;

@Mapper
public interface EmployeeMapper {

	EapprovalVO selectUserById(String employee_code);
	
	List<EapprovalVO> selectEmployeesByName(String name);
	
	List<OrgVO> selectOrgTree();
}
