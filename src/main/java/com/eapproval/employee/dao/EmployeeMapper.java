package com.eapproval.employee.dao;

import org.apache.ibatis.annotations.Mapper;

import com.eapproval.employee.vo.EapprovalVO;

@Mapper
public interface EmployeeMapper {

	EapprovalVO selectUserById(String employee_code);
}
