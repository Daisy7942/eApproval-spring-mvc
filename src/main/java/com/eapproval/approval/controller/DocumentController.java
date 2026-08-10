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

	// 결재 페이지 조회(새결재, 재조회)-----------------------------------------
	@GetMapping("/document/write")
	public String writeForm(HttpServletRequest request, Model model, @RequestParam(required = false) Long docId) {
		if (docId == null) {
			return "approval/documentForm";
		} else {
			EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
			long empId = loginUser.getEmployeeId();

			DocumentVO doc = documentService.getDraft(docId, empId);
			model.addAttribute("doc", doc);
			return "approval/documentForm";

		}
	}

	// 새결재 페이지 작성------------------------------------------
	@PostMapping("/document/write")
	public String saveDraft(DocumentVO documentVO, HttpServletRequest request) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");

		long empId = loginUser.getEmployeeId();
		Long docId = documentVO.getDocId();
		documentVO.setEmployeeId(empId);

		if (docId == null) {
			documentService.saveDraft(documentVO);
		} else {
			documentService.updateDraft(documentVO);
		}

		return "approval/saveResult";
	}
	// 상신 -------------------------------------------------------------
	@PostMapping("/document/submit")
	public String submitDocument(DocumentVO documentVO, HttpServletRequest request) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");

		long empId = loginUser.getEmployeeId();
		documentVO.setEmployeeId(empId);


		documentService.submitDocument(documentVO);



		return "approval/saveResult";
	}
	

	// 임시저장목록 조회 ---------------------------------------------
	@GetMapping("/document/drafts")
	public String draftList(HttpServletRequest request, Model model) {
		System.out.println("임시저장조회");
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		List<DocumentVO> draftList = documentService.getDraftList(empId);
		System.out.println(draftList);

		model.addAttribute("draftList", draftList);
		return "approval/draftList";
	}

	// 삭제 -------------------
	@PostMapping("/document/delete")
	public String deleteDrafts(@RequestParam List<Long> docIds, HttpServletRequest request) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");

		long empId = loginUser.getEmployeeId();

		documentService.deleteDrafts(docIds, empId);

		return "redirect:/document/drafts";
	}
}
