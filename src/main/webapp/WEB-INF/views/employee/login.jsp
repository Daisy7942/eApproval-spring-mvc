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

/* 로그인 실패 안내 모달 */
.modal-back {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, .45);
	display: flex;
	align-items: center;
	justify-content: center;
}

.modal-box {
	background: #fff;
	border-radius: 10px;
	width: 320px;
	padding: 28px 24px 20px;
	text-align: center;
	box-shadow: 0 8px 24px rgba(0, 0, 0, .2);
}

.modal-box .msg {
	font-size: 14px;
	color: #b3261e;
	margin-bottom: 20px;
	line-height: 1.5;
}

.modal-box button {
	width: auto;
	min-width: 90px;
	padding: 9px 18px;
	font-size: 14px;
}
</style>
</head>
<body>
	<div class="login-box">
		<h1>eApproval 전자결재</h1>
		<p class="sub">사원번호로 로그인하세요</p>

		<form action="${pageContext.request.contextPath}/login" method="post">
			<label for="employeeCode">사원번호</label> 
			<input type="text" id="employeeCode" name="employeeCode" placeholder="예: EMP0001" autofocus>
			<button type="submit">로그인</button>
		</form>
	</div>

	<%-- errorMessage 가 있을 때만 모달을 그린다 --%>
	<c:if test="${not empty errorMessage}">
		<div class="modal-back" id="errorModal">
			<div class="modal-box">
				<p class="msg">${errorMessage}</p>
				<button type="button" onclick="closeErrorModal()">확인</button>
			</div>
		</div>
	</c:if>

	<script>
		function closeErrorModal() {
			document.getElementById("errorModal").style.display = "none";
			document.getElementById("employeeCode").focus();
		}
	</script>
</body>
</html>