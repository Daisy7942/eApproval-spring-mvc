<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>저장 완료</title>
</head>
<body>
<script>
	// 나를 열어준 창(대시보드)이 아직 살아 있으면 새로고침
	if (window.opener && !window.opener.closed) {
		window.opener.location.reload();
	}
	// 이 팝업 창 닫기
	window.close();
</script>
</body>
</html>