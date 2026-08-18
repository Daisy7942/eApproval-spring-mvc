package com.eapproval.approval.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.eapproval.approval.service.DocumentService;
import com.eapproval.approval.vo.DocumentVO;
import com.eapproval.approval.vo.VacationTypeVO;
import com.eapproval.common.vo.PageVO;
import com.eapproval.employee.vo.EapprovalVO;

@Controller
public class DocumentController {

	@Autowired
	private DocumentService documentService;

	// 결재 페이지 조회(새결재, 임시저장 재조회)-----------------------------------------
	@GetMapping("/document/write")
	public String writeForm(HttpServletRequest request, Model model, @RequestParam(required = false) Long docId,
			String documentType) {

		// 현재 로그인한 사용자의 세션 정보에서 사번(empId) 추출
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		if (docId == null) { // docId가 없으면

			// 추천 결재선(상사 라인)을 조회해서 화면(Model)에 전달
			List<EapprovalVO> recLine = documentService.recommendApprovalLine(empId, documentType);
			model.addAttribute("recLine", recLine);

			// 작성하려는 문서가 '휴가 신청서'인 경우
			if ("VACATION".equals(documentType)) {

				// 휴가 종류 목록(연차, 병가, 반차 등) 조회
				List<VacationTypeVO> vacationTypes = documentService.getVacationTypeList();
				model.addAttribute("vacationTypes", vacationTypes);

				// 로그인한 사용자의 잔여 연차 요약 정보 조회
				model.addAttribute("summary", documentService.getLeaveSummary(empId));

				return "approval/vacationForm"; // 휴가 신청 전용 페이지(JSP)로 이동
			} else {
				return "approval/documentForm";
			} // 새 문서 창으로 이동

			// docId가 이미 있으면 -> [임시저장 문서 재조회 화면]
		} else {

			// DB에서 기존에 임시저장해둔 문서 정보를 불러와서 화면(Model)에 전달
			DocumentVO doc = documentService.getDraft(docId, empId);
			model.addAttribute("doc", doc);

			if ("VACATION".equals(doc.getDocumentType())) {
				model.addAttribute("vacationTypes", documentService.getVacationTypeList());
				model.addAttribute("summary", documentService.getLeaveSummary(empId));
				return "approval/vacationForm";
			}
			return "approval/documentForm"; // 작성 중이던 기존 내용이 채워진 채로 작성 페이지 이동

		}
	}

	// 새결재 페이지 작성------------------------------------------
	@PostMapping("/document/write")
	public String saveDraft(DocumentVO documentVO, HttpServletRequest request, Model model) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");

		long empId = loginUser.getEmployeeId();
		Long docId = documentVO.getDocId();
		documentVO.setEmployeeId(empId);

		if (docId == null) {
			documentService.saveDraft(documentVO);
		} else {
			documentService.updateDraft(documentVO);
		}

		// 저장 성공 후 이동할 목록 URL 설정(팝업 x, 같은탭의 경우)
		// (반려 문서는 REJECTED 상태이므로 임시저장함이 아닌 상신함으로 이동)
		DocumentVO saved = documentService.getDraft(documentVO.getDocId(), empId);
		boolean rejected = saved != null && "REJECTED".equals(saved.getStatus());
		model.addAttribute("nextUrl", rejected ? "/document/submitted" : "/document/drafts");
		return "approval/saveResult";
	}

	// 상신 -------------------------------------------------------------
	@PostMapping("/document/submit")
	public String submitDocument(DocumentVO documentVO, HttpServletRequest request, Model model) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");

		long empId = loginUser.getEmployeeId();
		documentVO.setEmployeeId(empId);

		documentService.submitDocument(documentVO);

		// 팝업이 아니라 같은 탭에서 상신한 경우 saveResult 가 보낼 곳
		model.addAttribute("nextUrl", "/document/submitted");
		return "approval/saveResult";
	}

	// 임시저장목록 조회 ---------------------------------------------
	// page·size·keyword·docType 은 PageVO 가 통째로 받아 준다.
	@GetMapping("/document/drafts")
	public String draftList(HttpServletRequest request, Model model, PageVO pageVO) {
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		// 목록을 자르기 전에 조건에 걸린 게 몇 건인지부터 세야 페이지를 몇 장 그릴지 알 수 있다
		pageVO.setTotal(documentService.getDraftCount(empId, pageVO));

		List<DocumentVO> draftList = documentService.getDraftList(empId, pageVO);

		model.addAttribute("draftList", draftList);
		model.addAttribute("pageVO", pageVO);
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
	public String submittedList(HttpServletRequest request, Model model, PageVO pageVO) {
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		pageVO.setTotal(documentService.getSubmittedCount(empId, pageVO));

		List<DocumentVO> submittedList = documentService.getSubmittedList(empId, pageVO);

		model.addAttribute("submittedList", submittedList);
		model.addAttribute("pageVO", pageVO);
		return "approval/submittedList";
	}

	// 결재 대기 목록 조회 ---------------------------------------------
	@GetMapping("/document/pending")
	public String pendingList(HttpServletRequest request, Model model, PageVO pageVO) {
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		pageVO.setTotal(documentService.getPendingCount(empId, pageVO));

		List<DocumentVO> pendingList = documentService.getPendingList(empId, pageVO);

		model.addAttribute("pendingList", pendingList);
		model.addAttribute("pageVO", pageVO);
		return "approval/pendingList";
	}

	// 결재 완료 목록 조회 ---------------------------------------------
	@GetMapping("/document/completed")
	public String completedList(HttpServletRequest request, Model model, PageVO pageVO) {
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		pageVO.setTotal(documentService.getCompletedCount(empId, pageVO));

		List<DocumentVO> completedList = documentService.getCompletedList(empId, pageVO);

		model.addAttribute("completedList", completedList);
		model.addAttribute("pageVO", pageVO);
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

	// 문서 승인 --------------------------------------------------
	@PostMapping("/document/approve")
	public String approve(@RequestParam Long docId, @RequestParam String comment,
			@RequestParam(required = false) String from, HttpServletRequest request) {
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();
		documentService.approve(docId, empId, comment);
		return "redirect:/document/detail?docId=" + docId + fromParam(from);
	}

	// 문서 반려 --------------------------------------------------
	@PostMapping("/document/reject")
	public String reject(@RequestParam Long docId, @RequestParam String comment,
			@RequestParam(required = false) String from, HttpServletRequest request) {
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();
		documentService.reject(docId, empId, comment);
		return "redirect:/document/detail?docId=" + docId + fromParam(from);
	}

	// 결재 처리 완료 후 이전 목록으로 복귀하기 위한 from 파라미터 검증
	// - 허용 값: wait(결재대기함), done(결재완료함), sent(상신문서함)
	// - 검증되지 않은 임의의 문자열 주입 방지 및 기본값(상신문서함) 이동 오동작 방지
	private String fromParam(String from) {
		if ("wait".equals(from) || "done".equals(from) || "sent".equals(from)) {
			return "&from=" + from;
		}
		return "";
	}

	// 상신 취소 --------------------------------------------------
	@PostMapping("/document/cancel")
	public String cancelSubmission(@RequestParam Long docId, HttpServletRequest request) {
		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();
		documentService.cancelSubmission(docId, empId);
		return "redirect:/document/drafts";
	}

	// IllegalStateException 예외 발생 시 처리해주는 전담 메서드
	@ExceptionHandler(IllegalStateException.class)
	public String handleIllegalState(IllegalStateException e, Model model) {
		model.addAttribute("message", e.getMessage()); // 에러 메시지를 화면에 전달
		return "approval/error"; // 에러 전용 페이지(approval/error.jsp)로 이동
	}

	// 문서수정 — 임시저장으로 되돌린 뒤 작성 화면으로
	@PostMapping("/document/edit")
	public String editDocument(@RequestParam Long docId, HttpServletRequest request) {
	    EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
	    long empId = loginUser.getEmployeeId();
	    documentService.cancelSubmission(docId, empId);
	    return "redirect:/document/write?docId=" + docId;
	}

	// 반려 문서 재상신 작성 화면 진입 (재상신 가능 여부 검증 후 작성 페이지로 리다이렉트)
	// ※ 문서는 REJECTED 상태를 유지하며, 실제 상태 변경(DRAFT/PENDING)은 작성 완료 시 진행됨
	@PostMapping("/document/redraft")
	public String redraftDocument(@RequestParam Long docId, HttpServletRequest request) {
	    EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
	    long empId = loginUser.getEmployeeId();
	    documentService.checkRedraftable(docId, empId);
	    return "redirect:/document/write?docId=" + docId;
	}
}
