<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>eApproval - 대시보드</title>
<%-- 공통 레이아웃(헤더/사이드바/본문) 스타일 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* ===== 이 화면에서만 쓰는 스타일 =====
   레이아웃(헤더/사이드바/메인/패널)은 common.css 에 있다. */

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

	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<%-- module(결재/휴가)은 sidebar.jsp 가 주소를 보고 알아서 판단한다 --%>
	<c:set var="menu" value="dashboard" />
	<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>

	<div class="main">
		<div class="content">

			<div class="crumb">
				전자결재 &gt; <b>대시보드</b>
			</div>

			<div class="page-title">
				<h2>대시보드</h2>
				<p>
					<c:out value="${sessionScope.loginUser.name}" />님, 안녕하세요.
				</p>
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

</body>
</html>
