package com.eapproval.employee.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eapproval.employee.dao.EmployeeMapper;
import com.eapproval.employee.vo.EapprovalVO;


@Service
public class EmployeeService {

	@Autowired
	private EmployeeMapper employeemapper;

	public List<EapprovalVO> searchByName(String name) {

		return employeemapper.selectEmployeesByName(name);
	}
}