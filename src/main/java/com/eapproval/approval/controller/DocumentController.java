package com.eapproval.approval.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.eapproval.approval.service.DocumentService;
import com.eapproval.approval.vo.DocumentVO;
import com.eapproval.employee.vo.EapprovalVO;

@Controller
public class DocumentController {
	
	@Autowired
	private DocumentService documentService;

	@GetMapping("/document/write")
	public String writeForm() {
		System.out.println("요청은옴");
		return "approval/documentForm";
	}
	
	@PostMapping("/document/write")
	public String saveDraft(DocumentVO documentVO, HttpServletRequest request ) {
		
		System.out.println("저장요청");
		EapprovalVO loginUser = (EapprovalVO)request.getSession().getAttribute("loginUser");
		
		long empId = loginUser.getEmployeeId();
		documentVO.setEmployeeId(empId);
		
		
		documentService.saveDraft(documentVO);
		
		return "approval/saveResult";
	}
}
