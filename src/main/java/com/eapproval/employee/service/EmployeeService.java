package com.eapproval.employee.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eapproval.employee.dao.EmployeeMapper;
import com.eapproval.employee.vo.EapprovalVO;
import com.eapproval.employee.vo.OrgVO;


@Service
public class EmployeeService {

	@Autowired
	private EmployeeMapper employeeMapper;

	public List<EapprovalVO> searchByName(String name) {

		return employeeMapper.selectEmployeesByName(name);
	}
	
	public List<OrgVO> getOrgTree() {
	    return employeeMapper.selectOrgTree();
	}
}