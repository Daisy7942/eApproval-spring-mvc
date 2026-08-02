package com.eapproval.employee.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.eapproval.employee.service.LoginService;


@Controller
public class LoginController {
	

	@Autowired
	private LoginService loginService;

	// --- API 연동  ---
	@GetMapping(value = "/login")
	public String login() {
		return "employee/login";
		
	}	
	
	// --- API 연동  ---
	@PostMapping(value = "/login")
	public String login1(@RequestParam String employeeCode) {
		
		
		boolean check = loginService.checkEmployee(employeeCode);
		
		System.out.println(employeeCode);
		if(check) {
			return "home/dashboard";
		}else {
		
		return "employee/login";
		
		}
	}
	
}
