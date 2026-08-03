package com.eapproval.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class LoginCheckInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		// TODO Auto-generated method stub

		// getSession(true)-> 세션을 새로 만들고, (false)-> 없으면 null 처리
		HttpSession session = request.getSession(false);

		if (session != null && session.getAttribute("loginUser") != null) {
			return true; // 로그인 되어있음 → 요청 계속 진행
		}

		response.sendRedirect(request.getContextPath() + "/login");
		return false; // 요청 여기서 중단
	}
}
