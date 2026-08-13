package com.eapproval.approval.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.eapproval.approval.service.DocumentService;
import com.eapproval.approval.vo.LeaveSummaryVO;
import com.eapproval.employee.vo.EapprovalVO;

@Controller
public class LeaveController {

	@Autowired
	private DocumentService documentService;

	// 내 휴가 현황
	@GetMapping("/leave/my")
	public String myLeave(HttpServletRequest request, Model model) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		LeaveSummaryVO summary = documentService.getLeaveSummary(empId);
		model.addAttribute("summary", summary);

		return "leave/leaveMy";
	}
}
