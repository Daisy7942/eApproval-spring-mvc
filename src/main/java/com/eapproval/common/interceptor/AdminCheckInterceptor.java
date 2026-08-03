package com.eapproval.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.eapproval.employee.vo.EapprovalVO;

public class AdminCheckInterceptor implements HandlerInterceptor {

	 @Override
     public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
             throws Exception {
		 
		// getSession(true)-> 있으면 기존세션 가져오고 없으면 세션을 새로 만들고, 
		// (false)-> 있으면 기존세션을 가져오고  없으면 null 처리
         HttpSession session = request.getSession(false);
         EapprovalVO loginUser = (session != null) ? (EapprovalVO) session.getAttribute("loginUser") :
 null;

         if (loginUser != null && "ADMIN".equals(loginUser.getRole())) {
             return true;
         }

         response.sendRedirect(request.getContextPath() + "/");
         return false;
     }
 }
