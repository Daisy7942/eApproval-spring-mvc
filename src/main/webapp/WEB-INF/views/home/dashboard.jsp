<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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

/* ===== 실제 데이터를 붙이면서 더한 것 ===== */

/* 카드가 <a> 로 바뀌었다. 링크 밑줄·파란 글자를 지우고 눌리는 느낌만 남긴다 */
.stat {
	text-decoration: none;
	color: inherit;
	transition: border-color .15s, box-shadow .15s;
}

.stat:hover {
	border-color: #c9d6f5;
	box-shadow: 0 2px 8px rgba(16, 24, 40, .07);
}

/* 패널 제목 오른쪽 '전체보기' */
.panel h3 {
	display: flex;
	align-items: baseline;
}

.panel h3 .more {
	margin-left: auto;
	font-size: 12px;
	font-weight: 400;
	color: #8a93a3;
	text-decoration: none;
}

.panel h3 .more:hover {
	color: #2f6bff;
}

.doc {
	cursor: pointer;
}

.doc:hover {
	background: #f8fafd;
}

/* 긴급 표시. 다른 목록(draftList·completedList)과 같은 ⚠ 로 맞춘다 */
.urgent-mark {
	color: #e5484d;
	font-weight: bold;
	margin-right: 3px;
}

/* 목록이 비었을 때 */
.none {
	padding: 40px 0;
	text-align: center;
	font-size: 13px;
	color: #98a3b5;
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

			<%-- 숫자 4개.
			     서버는 목록 두 개만 보낸다(waitDocs = 내가 결재할 것, myDocs = 내가 올린 것).
			     상태별 개수는 집계 쿼리를 따로 만들지 않고 여기서 센다.
			     한 사람이 올린 문서는 많아야 수십 건이라 세는 값이 싸기 때문이다. --%>
			<c:set var="cntApproved" value="0" />
			<c:set var="cntPending" value="0" />
			<c:set var="cntRejected" value="0" />
			<c:forEach var="d" items="${myDocs}">
				<c:choose>
					<c:when test="${d.status eq 'APPROVED'}">
						<c:set var="cntApproved" value="${cntApproved + 1}" />
					</c:when>
					<c:when test="${d.status eq 'REJECTED'}">
						<c:set var="cntRejected" value="${cntRejected + 1}" />
					</c:when>
					<c:otherwise>
						<c:set var="cntPending" value="${cntPending + 1}" />
					</c:otherwise>
				</c:choose>
			</c:forEach>

			<%-- 카드마다 해당 목록 화면으로 넘어간다 --%>
			<c:set var="cp" value="${pageContext.request.contextPath}" />

			<div class="stats">
				<a class="stat" href="${cp}/document/pending">
					<div class="ico wait">◷</div>
					<div>
						<b>${fn:length(waitDocs)}</b><span>결재 대기</span>
					</div>
				</a>
				<a class="stat" href="${cp}/document/submitted">
					<div class="ico done">✓</div>
					<div>
						<b>${cntApproved}</b><span>승인 완료</span>
					</div>
				</a>
				<a class="stat" href="${cp}/document/submitted">
					<div class="ico hold">⏸</div>
					<div>
						<b>${cntPending}</b><span>진행 중</span>
					</div>
				</a>
				<a class="stat" href="${cp}/document/submitted">
					<div class="ico reject">✕</div>
					<div>
						<b>${cntRejected}</b><span>반려</span>
					</div>
				</a>
			</div>

			<div class="panels">

				<%-- 처리 필요 문서 = 결재 대기함과 같은 목록. 앞 5건만 보여준다 --%>
				<div class="panel">
					<h3>
						처리 필요 문서 <a class="more" href="${cp}/document/pending">전체보기</a>
					</h3>

					<c:forEach var="d" items="${waitDocs}" varStatus="st">
						<c:if test="${st.index lt 5}">
							<div class="doc" onclick="openDoc(${d.docId})">
								<%-- 세로 막대 색 = 양식 종류. 휴가는 파랑, 그 밖은 보라 --%>
								<div class="bar"
									style="background: ${d.documentType eq 'VACATION' ? '#4d82f3' : '#7c4dcc'}"></div>
								<div class="info">
									<b><c:if test="${d.isUrgent}">
											<span class="urgent-mark" title="긴급">⚠</span>
										</c:if>${d.title}</b><span>${d.drafterName} · ${d.drafterTeam}</span>
								</div>
								<span class="pill progress">결재중</span>
							</div>
						</c:if>
					</c:forEach>

					<c:if test="${empty waitDocs}">
						<div class="none">처리할 문서가 없습니다.</div>
					</c:if>
				</div>

				<%-- 결재 현황 = 내가 올린 문서를 상태별로. 위에서 이미 센 값을 그대로 쓴다.
				     막대 길이는 전체 대비 비율이고, 0으로 나누지 않도록 전체가 0이면 건너뛴다 --%>
				<c:set var="totalDocs" value="${fn:length(myDocs)}" />

				<div class="panel">
					<h3>내 문서 현황</h3>
					<div class="status-body">

						<div class="track">
							<div class="row">
								<span>승인</span><b>${cntApproved}건</b>
							</div>
							<div class="gauge">
								<i
									style="width: ${totalDocs > 0 ? (cntApproved * 100 / totalDocs) : 0}%; background: #18a058"></i>
							</div>
						</div>

						<div class="track">
							<div class="row">
								<span>결재중</span><b>${cntPending}건</b>
							</div>
							<div class="gauge">
								<i
									style="width: ${totalDocs > 0 ? (cntPending * 100 / totalDocs) : 0}%; background: #d99a00"></i>
							</div>
						</div>

						<div class="track">
							<div class="row">
								<span>반려</span><b>${cntRejected}건</b>
							</div>
							<div class="gauge">
								<i
									style="width: ${totalDocs > 0 ? (cntRejected * 100 / totalDocs) : 0}%; background: #d64545"></i>
							</div>
						</div>

						<div class="total">
							<b>${totalDocs}</b><span>내가 올린 문서</span>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>

	<script>
		// 결재 대기함에서 여는 것과 같다. from=wait 이면 상세 화면의
		// '‹ 목록' 이 결재 대기 문서로 돌아간다
		function openDoc(docId) {
			location.href = "${cp}/document/detail?docId=" + docId + "&from=wait";
		}
	</script>

</body>
</html>
