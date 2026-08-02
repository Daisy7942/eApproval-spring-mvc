package com.eapproval.employee.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eapproval.employee.dao.EmployeeMapper;
import com.eapproval.employee.vo.EapprovalVO;

@Service
public class LoginService {

	@Autowired
	private EmployeeMapper employeeMapper;

	public boolean checkEmployee(String employeeCode) {
	

		EapprovalVO eapprovalVO = employeeMapper.selectUserById(employeeCode);
		

		if (eapprovalVO != null) {

			return true;
		} else {
			return false;
		}
	}
}
