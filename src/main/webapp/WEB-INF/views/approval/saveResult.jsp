<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>저장 완료</title>
<style>
/* 창이 닫히기 전 잠깐 보이는 화면. 흰 종이만 뜨면 저장이 안 된 것처럼 보인다 */
body { margin:0; display:flex; align-items:center; justify-content:center;
       height:100vh; font-family:'맑은 고딕',sans-serif;
       font-size:14px; color:#5b6576; background:#f8fafc; }
</style>
</head>
<body>
	<div>저장되었습니다. 잠시만 기다려 주세요…</div>
<script>
	// 컨트롤러가 정해준 곳. 임시저장이면 임시보관함, 상신이면 상신함,
	// 반려 문서를 고치던 중이면 상신함 (그 문서는 REJECTED 라 임시저장함에 없다)
	var next = '${pageContext.request.contextPath}${empty nextUrl ? "/document/drafts" : nextUrl}';

	// 나를 열어준 창(대시보드·목록)이 살아 있으면 새로고침해서 방금 저장한 게 보이게 한다.
	// 그 창이 다른 도메인으로 옮겨갔으면 접근이 막히므로 try 로 감싼다
	if (window.opener && !window.opener.closed) {
		try { window.opener.location.reload(); } catch (e) {}
	}

	// 팝업으로 열렸으면 닫는다. close() 는 스크립트가 연 창에서만 먹는다
	window.close();

	/* 여기까지 살아 있으면 창이 안 닫힌 것이다 — 같은 탭으로 들어왔거나(문서수정·재상신)
	   브라우저가 close() 를 막은 경우다.
	   예전에는 opener 가 없을 때만 이동시켰는데, opener 가 있는데도 close 가 막히면
	   아무 일도 안 일어나 빈 화면에 갇혔다. 사용자는 저장이 안 된 줄 알고 뒤로 가서
	   다시 누르게 된다. 그래서 opener 유무가 아니라 '정말 닫혔는지'를 기다렸다 확인한다.
	   close() 가 먹었으면 이 창은 이미 사라져서 아래 타이머는 돌지 않는다 */
	setTimeout(function () { location.replace(next); }, 150);
</script>
</body>
</html>
