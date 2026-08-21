<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>eApproval - 로그인</title>
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: "Malgun Gothic", sans-serif;
}

body {
	background: #f4f6f9;
	display: flex;
	align-items: center;
	justify-content: center;
	min-height: 100vh;
}

.login-box {
	background: #fff;
	border: 1px solid #e0e4ea;
	border-radius: 10px;
	padding: 40px 36px;
	width: 360px;
	box-shadow: 0 4px 16px rgba(31, 56, 100, .08);
}

.login-box h1 {
	font-size: 20px;
	color: #1F3864;
	text-align: center;
	margin-bottom: 6px;
}

.login-box .sub {
	font-size: 13px;
	color: #888;
	text-align: center;
	margin-bottom: 28px;
}

label {
	display: block;
	font-size: 13px;
	color: #444;
	margin-bottom: 6px;
}

input[type="text"] {
	width: 100%;
	padding: 11px 12px;
	border: 1px solid #ccd3dd;
	border-radius: 6px;
	font-size: 14px;
	margin-bottom: 16px;
}

input[type="text"]:focus {
	outline: none;
	border-color: #1F3864;
}

button {
	width: 100%;
	padding: 12px;
	background: #1F3864;
	color: #fff;
	border: none;
	border-radius: 6px;
	font-size: 15px;
	cursor: pointer;
}

button:hover {
	background: #2E5395;
}

.error {
	background: #fdecea;
	color: #b3261e;
	font-size: 13px;
	padding: 10px 12px;
	border-radius: 6px;
	margin-bottom: 16px;
}
</style>
</head>
<body>
	<div class="login-box">
		<h1>eApproval 전자결재</h1>
		<p class="sub">사원번호로 로그인하세요</p>

		<c:if test="${not empty errorMessage}">
			<div class="error">${errorMessage}</div>
		</c:if>

		<form action="${pageContext.request.contextPath}/login" method="post">
			<label for="employeeCode">사원번호</label> 
			<input type="text" id="employeeCode" name="employeeCode" placeholder="예: EMP0001" autofocus>
			<button type="submit">로그인</button>
		</form>
	</div>
</body>
</html>