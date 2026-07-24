package com.eapproval.web.dao;

import com.eapproval.web.vo.EapprovalVO;

public interface EmployeeMapper {

	EapprovalVO selectUserById(String employee_code);
}
