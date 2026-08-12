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

	// 결재 페이지 조회(새결재, 임시저장 재조회)-----------------------------------------
	@GetMapping("/document/write")
	public String writeForm(HttpServletRequest request, Model model, @RequestParam(required = false) Long docId, String documentType) {
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();
		
		if (docId == null) {
			List<EapprovalVO> recLine = documentService.recommendApprovalLine(empId, documentType);
			model.addAttribute("recLine", recLine);

			return "approval/documentForm"; // ← 새 문서
		} else {

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
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		List<DocumentVO> draftList = documentService.getDraftList(empId);

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
	
	
	
	// 상신 목록 조회 ---------------------------------------------
	@GetMapping("/document/submitted")
	public String submittedList(HttpServletRequest request, Model model) {
	    EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
	    long empId = loginUser.getEmployeeId();

	    List<DocumentVO> submittedList = documentService.getSubmittedList(empId);
	    model.addAttribute("submittedList", submittedList);
	    return "approval/submittedList";
	}
	
	
	// 결재 대기 목록 조회 ---------------------------------------------
	@GetMapping("/document/pending")
	public String pendingList(HttpServletRequest request, Model model) {
	    EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
	    long empId = loginUser.getEmployeeId();

	    List<DocumentVO> pendingList  = documentService.getPendingList(empId);
	    model.addAttribute("pendingList", pendingList );
	    return "approval/pendingList";
	}
	
	
	// 결재 완료 목록 조회 ---------------------------------------------
	@GetMapping("/document/completed")
	public String completedList(HttpServletRequest request, Model model) {
	    EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
	    long empId = loginUser.getEmployeeId();

	    List<DocumentVO> completedList  = documentService.getCompletedList(empId);
	    model.addAttribute("completedList", completedList );
	    return "approval/completedList";
	}
	
	// 문서 상세 조회 ---------------------------------------------
	@GetMapping("/document/detail")
	public String detail(@RequestParam Long docId, HttpServletRequest request, Model model) {
	    EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
	    long empId = loginUser.getEmployeeId();

	    DocumentVO doc = documentService.getDocumentDetail(docId, empId);
	    model.addAttribute("doc", doc);
	    return "approval/documentDetail";
	}
}
