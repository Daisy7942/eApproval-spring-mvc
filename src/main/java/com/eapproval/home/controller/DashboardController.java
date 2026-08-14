package com.eapproval.home.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.eapproval.approval.service.DocumentService;
import com.eapproval.employee.vo.EapprovalVO;

@Controller
public class DashboardController {

	@Autowired
	private DocumentService documentService;

	// --- [방식 2] API 연동 (현대적 방식) ---
	@GetMapping(value = "/")
	public String dashboard(HttpServletRequest request, Model model) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		// 내가 결재해야 할 문서 (결재 대기함과 같은 것)
		model.addAttribute("waitDocs", documentService.getPendingList(empId));
		// 내가 올린 문서 전부 (상신함과 같은 것). 상태별 개수는 화면에서 센다
		model.addAttribute("myDocs", documentService.getSubmittedList(empId));

		return "home/dashboard";
	}

	@GetMapping(value = "/forms")
	public String openFormModal() {

		System.out.println("dasdf");
		return "approval/formSelect";

	}

}
