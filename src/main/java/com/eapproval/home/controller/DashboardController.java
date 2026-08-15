package com.eapproval.home.controller;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.eapproval.approval.service.DocumentService;
import com.eapproval.approval.vo.DocumentVO;
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
		List<DocumentVO> waitDocs = documentService.getPendingList(empId);
		// 내가 올린 문서 전부 (상신함과 같은 것). 상태별 개수는 화면에서 센다
		List<DocumentVO> myDocs  = documentService.getSubmittedList(empId);

		model.addAttribute("waitDocs", waitDocs);
		model.addAttribute("myDocs", myDocs);

		// 처리 필요 문서 = 내가 결재할 문서 + 내가 올렸다가 반려된 문서.
		List<DocumentVO> todoDocs = new ArrayList<>(waitDocs);
		for (DocumentVO d : myDocs) {
			if ("REJECTED".equals(d.getStatus())) {
				todoDocs.add(d);
			}
		}

		// 정렬 (오래된것이 위로)
		todoDocs.sort(Comparator.comparing(DocumentVO::getCreatedAt));
		model.addAttribute("todoDocs", todoDocs);

		return "home/dashboard";
	}

	@GetMapping(value = "/forms")
	public String openFormModal() {

		System.out.println("dasdf");
		return "approval/formSelect";

	}

}
