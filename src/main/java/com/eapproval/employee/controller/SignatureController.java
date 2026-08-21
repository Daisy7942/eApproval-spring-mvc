package com.eapproval.employee.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.eapproval.employee.service.SignatureService;
import com.eapproval.employee.vo.EapprovalVO;

@Controller
@RequestMapping("/signature")
public class SignatureController {

	@Autowired
	private SignatureService signatureService;

	@GetMapping
	public String signatureForm(HttpServletRequest request, Model model) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		
		//로그인한 직원의 서명 목록, 대표 서명 ID, 최대 등록 가능 개수를 조회하여 뷰로 전달
		model.addAttribute("sigList", signatureService.getMySignatures(empId));
		model.addAttribute("activeSignatureId", signatureService.getActiveSignatureId(empId));
		model.addAttribute("maxSignature", SignatureService.MAX_SIGNATURES);

		return "employee/signatureForm";
	}


	//신규 서명 등록
	@PostMapping("/save")
	public String save(@RequestParam String imageData, HttpServletRequest request,
			RedirectAttributes redirectAttributes) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		try {
			signatureService.addSignature(empId, imageData); //전달받은 이미지 데이터(Base64 등)를 서명으로 등록
		} catch (IllegalStateException e) {
			// 서명 등록 제한 개수를 초과한 경우 에러 메시지 전달
			redirectAttributes.addFlashAttribute("msg", e.getMessage());
		}

		return "redirect:/signature";
	}

	/**
	 * 대표 서명 바꾸기.
	 * 기본 도장 칸은 값이 빈 문자열이라 Long 으로 바로 못 받는다. 문자열로 받아 직접 판별한다.
	 */
	@PostMapping("/select")
	public String select(@RequestParam(required = false) String signatureId, HttpServletRequest request) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		// 빈값("") 또는 null 체크 후 Long 타입 변환 (null이면 기본 도장 선택 의미)
		Long pick = (signatureId == null || signatureId.isEmpty()) ? null : Long.valueOf(signatureId);
		signatureService.chooseSignature(empId, pick);

		return "redirect:/signature";
	}
	
	

	//서명삭제(소프트)
	@PostMapping("/delete")
	public String delete(@RequestParam long signatureId, HttpServletRequest request) {

		EapprovalVO loginUser = (EapprovalVO) request.getSession().getAttribute("loginUser");
		long empId = loginUser.getEmployeeId();

		signatureService.removeSignature(empId, signatureId);

		return "redirect:/signature";
	}

	/**
	 * 서명 이미지 내려주기.
	 * 파일이 프로젝트 밖에 있어 <mvc:resources> 로는 못 열기 때문에 여기서 직접 읽어 보낸다.
	 */
	@GetMapping("/image/{signatureId}")
	@ResponseBody //HTML 화면을 보여주는 게 아니라, 순수 '데이터(파일)'만 응답하겠다는 선언
	public ResponseEntity<byte[]> image(@PathVariable long signatureId) {

		//서비스에게 요청해서 하드디스크의 이미지 파일을 바이트 배열(byte[])로 읽어오기
		byte[] image = signatureService.readImage(signatureId);

		if (image == null) {
			return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND); //'404 Not Found' 에러
		}

		//파일이 잘 있다면? HTTP status 200(성공)과 함께 "이 데이터는 PNG 이미지야!"라고 명시하여 바디에 담아 보내주기
		return ResponseEntity.ok().contentType(MediaType.IMAGE_PNG).body(image);
	}
}
