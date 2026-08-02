package com.eapproval.employee.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.eapproval.employee.service.LoginService;
import com.eapproval.employee.vo.EapprovalVO;

@Controller
public class LoginController {

	@Autowired
	private LoginService loginService;

	// --- API 연동 , 로그인 페이지 ---
	@GetMapping(value = "/login")
	public String login() {
		return "employee/login";

	}

	// --- API 연동 , 로그인 처리 ---
	@PostMapping(value = "/login")
	public String login(@RequestParam String employeeCode, HttpServletRequest request) {

		EapprovalVO eapprovalVO = loginService.getEmployee(employeeCode);

		System.out.println(employeeCode);
		if (eapprovalVO != null) {
			// 세션에 로그인 사용자 정보 저장
			request.getSession().setAttribute("loginUser", eapprovalVO);

			// 확인용
			Object sessionValue = request.getSession().getAttribute("loginUser");
			System.out.println("세션 데이터: " + sessionValue);

			return "redirect:/";
		} else {
			return "employee/login";

		}
	}

	// 로그아웃
	@GetMapping(value = "/logout")
	public String logout(HttpServletRequest request) {
		// 전달받은 request 객체를 통해 세션을 가져와서 만료(삭제)
		request.getSession().invalidate();
		return "redirect:/login";
	}

}
