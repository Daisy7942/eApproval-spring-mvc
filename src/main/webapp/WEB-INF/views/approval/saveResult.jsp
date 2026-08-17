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

	// 팝업이 아니라 같은 탭에서 들어온 경우(문서수정 등)엔 닫을 창이 없어 빈 화면만 남는다.
	// 그때는 컨트롤러가 정해준 곳으로 보낸다 — 임시저장이면 임시보관함, 상신이면 상신함
	if (!window.opener) {
		location.replace('${pageContext.request.contextPath}${empty nextUrl ? "/document/drafts" : nextUrl}');
	}
</script>
</body>
</html>