package com.eapproval.employee.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.eapproval.employee.service.EmployeeService;
import com.eapproval.employee.vo.EapprovalVO;

@Controller
public class EmployeeController {
	
	@Autowired
	private EmployeeService employeeService;
	
	@GetMapping("/employee/search")
	public String search(@RequestParam(required=false) String keyword, Model model) {
		if(keyword != null) {
			List<EapprovalVO> empList= employeeService.searchByName(keyword);
			model.addAttribute("empList", empList);
		}
		return "employee/employeeSearch";
	}
}
