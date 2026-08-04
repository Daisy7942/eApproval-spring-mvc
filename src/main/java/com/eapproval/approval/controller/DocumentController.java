package com.eapproval.approval.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DocumentController {

	@GetMapping("/document/write")
	public String writeForm() {
		System.out.println("요청은옴");
		return "approval/documentForm";
	}
}
