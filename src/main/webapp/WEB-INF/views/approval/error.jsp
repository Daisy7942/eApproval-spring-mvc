<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>확인이 필요합니다</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* 이 화면은 팝업(휴가 신청 창) 안에서도 뜨므로 헤더·사이드바 없이 가운데 한 칸만 그린다 */
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

/* 제목 앞에 붙는 작은 느낌표 배지 */
.icon {
	display: inline-block;
	width: 18px;
	height: 18px;
	margin-right: 6px;
	border-radius: 50%;
	background: var(--blue);
	color: #fff;
	font-size: 12px;
	line-height: 18px;
	font-weight: 700;
	vertical-align: 1px;
}

/* 서비스가 throw 한 문구가 그대로 여기 찍힌다 */
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
			<h1><span class="icon">!</span>입력 내용을 확인해 주세요</h1>
			<p class="msg">${empty message ? '입력하신 내용을 다시 확인해 주세요.' : message}</p>
			<p class="sub">아래 버튼을 눌러 내용을 고친 뒤 다시 신청해 주세요.</p>
			<div class="btns">
				<button type="button" class="btn primary" onclick="history.back();">다시 작성하기</button>
				<button type="button" class="btn" id="closeBtn" onclick="window.close();">창 닫기</button>
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
