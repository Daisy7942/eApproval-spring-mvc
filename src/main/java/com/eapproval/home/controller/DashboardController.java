package com.eapproval.home.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class DashboardController {

	// --- [방식 2] API 연동 (현대적 방식) ---
	@GetMapping(value = "/")
	public String dashboard() {
		return "home/dashboard";
		
	}	
	
	@GetMapping(value = "/forms")
	public String openFormModal() {
		
		System.out.println("dasdf");
		return "approval/formSelect";
		
	}	
	
}
