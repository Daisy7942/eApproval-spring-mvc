package com.eapproval.approval.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.eapproval.employee.service.EmployeeService;
import com.eapproval.employee.vo.OrgVO;

@Controller
public class ApprovalLineController {

	@Autowired
	private EmployeeService employeeService;
	
	@GetMapping("/approval/line")
	public String approvalLine(Model model) {

		
		List<OrgVO> orgList = employeeService.getOrgTree();

		model.addAttribute("orgList", orgList);

		return "approval/approvalLineForm";	
		
		
	}
}
