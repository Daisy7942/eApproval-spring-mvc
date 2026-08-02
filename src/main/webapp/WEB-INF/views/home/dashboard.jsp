<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>eApproval - 대시보드</title>
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: "Malgun Gothic", "Segoe UI", sans-serif;
}

body {
	display: flex;
	background: #f0f2f7;
	min-height: 100vh;
}

/* ===== 좌측 사이드바 ===== */
.sidebar {
	width: 230px;
	background: #1c2a47;
	color: #cdd6e6;
	display: flex;
	flex-direction: column;
	position: fixed;
	top: 0;
	bottom: 0;
}

.logo {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 18px 20px;
}

.logo .mark {
	width: 34px;
	height: 34px;
	background: #2f6bff;
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #fff;
	font-weight: bold;
}

.logo b {
	color: #fff;
	font-size: 15px;
	display: block;
}

.logo span {
	font-size: 11px;
	color: #8fa0bd;
}

.btn-new {
	margin: 6px 16px 14px;
	padding: 11px;
	background: #2f6bff;
	color: #fff;
	border: none;
	border-radius: 8px;
	font-size: 14px;
	cursor: pointer;
	width: calc(100% - 32px);
}

.btn-new:hover {
	background: #2456d6;
}

.profile {
	display: flex;
	align-items: center;
	gap: 10px;
	background: #24345a;
	margin: 0 12px 16px;
	padding: 10px 12px;
	border-radius: 10px;
}

.avatar {
	width: 34px;
	height: 34px;
	border-radius: 50%;
	background: #2f6bff;
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 14px;
}

.profile b {
	color: #fff;
	font-size: 13px;
	display: block;
}

.profile span {
	font-size: 11px;
	color: #8fa0bd;
}

.menu {
	flex: 1;
	overflow-y: auto;
}

.menu .section {
	font-size: 11px;
	color: #7487a8;
	padding: 12px 20px 4px;
}

.menu a {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 9px 20px;
	color: #cdd6e6;
	text-decoration: none;
	font-size: 13px;
}

.menu a:hover {
	background: #24345a;
	color: #fff;
}

.menu a.active {
	background: #2c3e66;
	color: #fff;
	border-radius: 8px;
	margin: 0 8px;
	padding: 9px 12px;
}

.menu a .badge {
	background: #e5484d;
	color: #fff;
	font-size: 10px;
	border-radius: 9px;
	padding: 2px 7px;
}

.sidebar-bottom {
	border-top: 1px solid #2c3a5c;
	padding: 10px 0;
}

.sidebar-bottom a {
	display: block;
	padding: 8px 20px;
	color: #9fb0ca;
	font-size: 13px;
	text-decoration: none;
}

.sidebar-bottom a:hover {
	color: #fff;
}

/* ===== 우측 메인 ===== */
.main {
	flex: 1;
	margin-left: 230px;
}

.topbar {
	background: #fff;
	border-bottom: 1px solid #e3e7ef;
	padding: 12px 28px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	font-size: 13px;
	color: #666;
}

.topbar .crumb b {
	color: #222;
}

.content {
	padding: 24px 28px;
	max-width: 1400px;
}

.page-title h2 {
	font-size: 20px;
	color: #1c2a47;
}

.page-title p {
	font-size: 13px;
	color: #777;
	margin: 6px 0 20px;
}

/* 상태 카드 4개 */
.stats {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
	gap: 16px;
	margin-bottom: 20px;
}

.stat {
	background: #fff;
	border: 1px solid #e3e7ef;
	border-radius: 10px;
	padding: 18px 20px;
	display: flex;
	align-items: center;
	gap: 14px;
}

.stat .ico {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 18px;
}

.ico.wait {
	background: #fff4d6;
	color: #d99a00;
}

.ico.done {
	background: #ddf3e4;
	color: #18a058;
}

.ico.hold {
	background: #ece4fb;
	color: #7c4dcc;
}

.ico.reject {
	background: #fde3e3;
	color: #d64545;
}

.stat b {
	font-size: 22px;
	color: #1c2a47;
	display: block;
	line-height: 1;
}

.stat span {
	font-size: 12px;
	color: #888;
}

/* 하단 2단 */
.panels {
	display: grid;
	grid-template-columns: 2fr 1fr;
	gap: 16px;
}

.panel {
	background: #fff;
	border: 1px solid #e3e7ef;
	border-radius: 10px;
}

.panel h3 {
	font-size: 14px;
	color: #1c2a47;
	padding: 16px 20px;
	border-bottom: 1px solid #eef1f6;
}

/* 처리 필요 문서 리스트 */
.doc {
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 14px 20px;
	border-bottom: 1px solid #f2f4f8;
}

.doc:last-child {
	border-bottom: none;
}

.doc .bar {
	width: 4px;
	height: 34px;
	border-radius: 2px;
}

.doc .info {
	flex: 1;
}

.doc .info b {
	font-size: 13.5px;
	color: #222;
	display: block;
	margin-bottom: 3px;
}

.doc .info span {
	font-size: 12px;
	color: #999;
}

.pill {
	font-size: 11px;
	padding: 4px 10px;
	border-radius: 12px;
}

.pill.progress {
	background: #fff4d6;
	color: #b98200;
}

.pill.hold {
	background: #ece4fb;
	color: #7c4dcc;
}

/* 결재 현황 */
.status-body {
	padding: 16px 20px;
}

.track {
	margin-bottom: 14px;
}

.track .row {
	display: flex;
	justify-content: space-between;
	font-size: 12px;
	color: #555;
	margin-bottom: 5px;
}

.track .row b {
	color: #222;
}

.gauge {
	height: 5px;
	background: #eef1f6;
	border-radius: 3px;
	overflow: hidden;
}

.gauge i {
	display: block;
	height: 100%;
	border-radius: 3px;
}

.total {
	text-align: center;
	padding: 14px 0 6px;
}

.total b {
	font-size: 30px;
	color: #1c2a47;
	display: block;
}

.total span {
	font-size: 12px;
	color: #888;
}
</style>
</head>
<body>

	<!-- ===== 사이드바 ===== -->
	<aside class="sidebar">
		<div class="logo">
			<div class="mark">e</div>
			<div>
				<b>eApproval</b><span>전자결재 시스템</span>
			</div>
		</div>
		<button class="btn-new" onclick="openFormModal()">＋ 새 결재</button>

		<!-- 로그인 연동 후: 세션의 이름/직급/팀으로 교체 -->
		<div class="profile">
			<div class="avatar">김</div>
			<div>
				<b>${sessionScope.loginUser.name}</b><span>백엔드팀 · 사원</span>
			</div>
		</div>

		<nav class="menu">
			<a href="#" class="active">◧ 대시보드</a>
			<div class="section">결재함</div>
			<a href="#">◷ 결재 대기 문서 <span class="badge">2</span></a> <a href="#">↥
				상신 문서</a> <a href="#">✓ 완료 문서</a>
			<div class="section">휴가</div>
			<a href="#">✈ 휴가 신청</a> <a href="#">▤ 휴가 이력</a>
			<div class="section">관리자</div>
			<a href="#">⚙ 조직 관리</a> <a href="#">◔ 연차 관리</a>
		</nav>

		<div class="sidebar-bottom">
			<a href="#">[→ 로그아웃</a>
		</div>
	</aside>

	<!-- ===== 메인 ===== -->
	<div class="main">
		<div class="topbar">
			<div class="crumb">
				전자결재 &gt; <b>대시보드</b>
			</div>
			<div>2026-07-22 (수)</div>
		</div>

		<div class="content">
			<div class="page-title">
				<h2>대시보드</h2>
				<!-- 로그인 연동 후: "OOO님, 안녕하세요"로 교체 -->
				<p>김수현님, 안녕하세요.</p>
			</div>

			<!-- 숫자 4개: 추후 Controller가 DB 집계값을 Model로 전달 -->
			<div class="stats">
				<div class="stat">
					<div class="ico wait">◷</div>
					<div>
						<b>2</b><span>결재 대기</span>
					</div>
				</div>
				<div class="stat">
					<div class="ico done">✓</div>
					<div>
						<b>1</b><span>승인 완료</span>
					</div>
				</div>
				<div class="stat">
					<div class="ico hold">⏸</div>
					<div>
						<b>1</b><span>진행 중</span>
					</div>
				</div>
				<div class="stat">
					<div class="ico reject">✕</div>
					<div>
						<b>1</b><span>반려</span>
					</div>
				</div>
			</div>

			<div class="panels">
				<!-- 처리 필요 문서: 추후 결재 대기 목록 조회로 교체 -->
				<div class="panel">
					<h3>처리 필요 문서</h3>
					<div class="doc">
						<div class="bar" style="background: #e5484d"></div>
						<div class="info">
							<b>연차 휴가 신청서</b><span>홍길동 · 인사팀</span>
						</div>
						<span class="pill progress">결재중</span>
					</div>
					<div class="doc">
						<div class="bar" style="background: #7c4dcc"></div>
						<div class="info">
							<b>하반기 업무 계획 보고서</b><span>이몽룡 · 전략기획팀</span>
						</div>
						<span class="pill progress">결재중</span>
					</div>
					<div class="doc">
						<div class="bar" style="background: #4d82f3"></div>
						<div class="info">
							<b>비품 구매 품의서</b><span>성춘향 · 총무팀</span>
						</div>
						<span class="pill hold">대기</span>
					</div>
				</div>

				<!-- 결재 현황: 추후 상태별 집계로 교체 -->
				<div class="panel">
					<h3>결재 현황</h3>
					<div class="status-body">
						<div class="track">
							<div class="row">
								<span>승인</span><b>1건</b>
							</div>
							<div class="gauge">
								<i style="width: 20%; background: #18a058"></i>
							</div>
						</div>
						<div class="track">
							<div class="row">
								<span>결재중</span><b>2건</b>
							</div>
							<div class="gauge">
								<i style="width: 40%; background: #d99a00"></i>
							</div>
						</div>
						<div class="track">
							<div class="row">
								<span>대기</span><b>1건</b>
							</div>
							<div class="gauge">
								<i style="width: 20%; background: #7c4dcc"></i>
							</div>
						</div>
						<div class="track">
							<div class="row">
								<span>반려</span><b>1건</b>
							</div>
							<div class="gauge">
								<i style="width: 20%; background: #d64545"></i>
							</div>
						</div>
						<div class="total">
							<b>5</b><span>전체 문서</span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 결재 양식 선택 팝업 -->
	<div id="formModal"
		style="display: none; position: fixed; inset: 0; z-index: 1000;">
		<iframe id="formFrame" src=""
			style="width: 100%; height: 100%; border: none;"></iframe>
	</div>

	<script>
		function openFormModal() {
			document.getElementById("formFrame").src = "forms"; // FormController의 @GetMapping("/forms")
			document.getElementById("formModal").style.display = "block";
		}
		function closeFormModal() {
			document.getElementById("formModal").style.display = "none";
			document.getElementById("formFrame").src = ""; // 닫을 때 비워서 초기화
		}
	</script>

</body>
</html>