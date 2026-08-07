package com.eapproval.approval.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	
	@GetMapping("/document/drafts")
	public String draftList(HttpServletRequest request ,Model model) {
		System.out.println("임시저장조회");
		EapprovalVO loginUser = (EapprovalVO)request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();
				
		List<DocumentVO> draftList = documentService.getDraftList(empId);
		System.out.println(draftList);
		
		model.addAttribute("draftList", draftList);
		return "approval/draftList";
	}
	
}
