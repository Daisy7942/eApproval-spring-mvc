<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%--
	예상하지 못한 오류(SQL 오류, NullPointerException 등)가 났을 때 뜨는 화면.
	web.xml 의 <error-page> 가 여기로 넘긴다.

	이 화면을 걸지 않으면 톰캣 기본 오류 화면이 뜨는데, 거기엔 예외 메시지와
	SQL 전문, 스택 트레이스가 그대로 찍힌다. 사용자는 읽을 수 없는 화면이고
	테이블·컬럼 이름과 톰캣 버전이 밖으로 새어 나간다.

	원인은 서버 로그(catalina.out)에 그대로 남으므로 디버깅에는 지장이 없다.
	화면에는 아무 기술 정보도 내보내지 않는다.

	approval/error.jsp 와 따로 둔 이유: 그쪽은 '결재선이 없습니다' 같은
	사용자 실수를 안내하는 화면이라 문구가 '입력 내용을 확인해 주세요' 다.
	시스템 오류에는 맞지 않는 말이다.
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오류가 발생했습니다</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
.wrap {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 24px;
}

.card {
	width: 100%;
	max-width: 420px;
	background: #fff;
	border: 1px solid var(--line);
	border-radius: 14px;
	padding: 34px 28px 26px;
	text-align: center;
	box-shadow: 0 6px 20px rgba(28, 42, 71, .07);
}

.card h1 {
	font-size: 16px;
	color: var(--ink);
	margin-bottom: 12px;
}

/* 사용자 실수가 아니라 시스템 문제이므로 파란 안내가 아닌 붉은 경고로 구분한다 */
.icon {
	display: inline-block;
	width: 18px;
	height: 18px;
	margin-right: 6px;
	border-radius: 50%;
	background: #d94848;
	color: #fff;
	font-size: 12px;
	line-height: 18px;
	font-weight: 700;
	vertical-align: 1px;
}

.msg {
	font-size: 14px;
	line-height: 1.6;
	color: var(--ink-soft);
	word-break: keep-all;
	margin-bottom: 6px;
}

.sub {
	font-size: 12.5px;
	color: var(--muted);
	margin-bottom: 24px;
}

.btns {
	display: flex;
	gap: 8px;
	justify-content: center;
}

.btn {
	min-width: 104px;
	height: 38px;
	border: 1px solid var(--line);
	border-radius: 8px;
	background: #fff;
	color: var(--ink-soft);
	font-size: 13px;
	cursor: pointer;
}

.btn:hover {
	background: #f6f8fc;
}

.btn.primary {
	border-color: var(--blue);
	background: var(--blue);
	color: #fff;
}

.btn.primary:hover {
	background: var(--blue-dark);
}
</style>
</head>
<body>
	<div class="wrap">
		<div class="card">
			<h1><span class="icon">!</span>오류가 발생했습니다</h1>
			<p class="msg">요청을 처리하는 중 문제가 생겼습니다.</p>
			<p class="sub">잠시 후 다시 시도해 주세요. 문제가 계속되면 관리자에게 문의해 주세요.</p>
			<div class="btns">
				<button type="button" class="btn primary"
					onclick="location.href='${pageContext.request.contextPath}/';">홈으로</button>
				<button type="button" class="btn" id="closeBtn"
					onclick="window.close();">창 닫기</button>
			</div>
		</div>
	</div>

	<script>
		// 팝업으로 열린 창일 때만 '창 닫기'를 보여준다 (일반 탭에서는 window.close()가 먹지 않음)
		if (!window.opener || window.opener.closed) {
			document.getElementById('closeBtn').style.display = 'none';
		}
	</script>
</body>
</html>
