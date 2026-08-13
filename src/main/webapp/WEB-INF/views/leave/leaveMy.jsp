<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>eApproval - 휴가 현황</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* ===== 휴가 현황 =====
   결재함 3종과 같은 뼈대(.crumb / .page-title / 흰 카드)를 쓴다.
   다른 점은 표가 아니라 '숫자 카드 4개 + 신청 내역 줄' 이라는 것뿐이다. */
.title-row {
	display: flex;
	align-items: baseline;
	justify-content: space-between;
	margin-bottom: 20px;
}

.total-count {
	font-size: 12.5px;
	color: #8a93a3;
}

/* ===== 카드 껍데기 (연차 현황 / 신청 내역 공용) ===== */
.card {
	background: #fff;
	border: 1px solid #e3e7ef;
	border-radius: 10px;
	padding: 20px 22px;
	margin-bottom: 16px;
}

.card-top {
	display: flex;
	align-items: flex-start;
	margin-bottom: 16px;
}

.card-top h3 {
	font-size: 15px;
	color: var(--ink);
	font-weight: 600;
}

/* 제목 밑 작은 설명 줄 */
.card-top p {
	font-size: 12px;
	color: #98a3b5;
	margin-top: 4px;
}

.card-top .right {
	margin-left: auto;
	display: flex;
	align-items: center;
	gap: 10px;
}

/* 파란 실선 버튼 — 사이드바 [＋ 새 결재] 와 같은 색 */
.btn-apply {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	background: var(--blue);
	color: #fff;
	border: none;
	border-radius: 8px;
	padding: 9px 16px;
	font-size: 13px;
	cursor: pointer;
	text-decoration: none;
}

.btn-apply:hover {
	filter: brightness(.94);
}

/* ===== 숫자 카드 4칸 =====
   총부여 · 사용 · 대기 · 잔여. 뜻이 다른 숫자라 색으로 갈라둔다.
   화면이 좁아지면 2줄로 접힌다 */
.stat-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 12px;
}

@media ( max-width : 1000px) {
	.stat-grid {
		grid-template-columns: repeat(2, 1fr);
	}
}

.stat {
	border: 1px solid;
	border-radius: 9px;
	padding: 18px 10px;
	text-align: center;
}

.stat b {
	display: block;
	font-size: 22px;
	font-weight: 700;
	letter-spacing: -.5px;
}

.stat span {
	display: block;
	font-size: 12.5px;
	color: #5b6576;
	margin-top: 6px;
}

/* 총 부여 = 기준값이라 무채색에 가깝게 */
.stat-total {
	background: #f3f6fc;
	border-color: #e1e8f5;
}

.stat-total b {
	color: #2b3f63;
}

/* 사용 = 이미 확정돼 깎인 것 */
.stat-used {
	background: #eef9f4;
	border-color: #cbeadb;
}

.stat-used b {
	color: #1a7f55;
}

/* 대기 = 승인되면 깎일 것. 결재중 칩과 같은 주황 */
.stat-wait {
	background: #fff8ec;
	border-color: #ffe2b8;
}

.stat-wait b {
	color: #b26a00;
}

/* 잔여 = 지금 쓸 수 있는 것 */
.stat-remain {
	background: #f4f1fe;
	border-color: #e0d9fb;
}

.stat-remain b {
	color: #5b45c9;
}

/* ===== 사용률 막대 ===== */
.usage {
	margin-top: 18px;
}

.usage-label {
	display: flex;
	justify-content: space-between;
	font-size: 12px;
	color: #5b6576;
	margin-bottom: 7px;
}

.usage-bar {
	height: 8px;
	border-radius: 99px;
	background: #eaeef5;
	overflow: hidden;
}

.usage-bar i {
	display: block;
	height: 100%;
	border-radius: 99px;
	background: var(--blue);
}

/* ===== 아래 2단 : 왼쪽 예정 휴가 / 오른쪽 지난 휴가 =====
   좁아지면 위아래로 쌓인다 */
.two-col {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 16px;
	align-items: start;
}

@media ( max-width : 1100px) {
	.two-col {
		grid-template-columns: 1fr;
	}
}

/* ===== 휴가 한 건 =====
   표가 아니라 '줄' 이다. 한 건에 두 줄씩 들어가서 표로 만들면
   칸이 비어 보이기 때문이다. 왼쪽 세로 막대 색이 곧 상태다 */
.leave-row {
	display: flex;
	align-items: flex-start;
	gap: 14px;
	padding: 15px 4px;
	border-bottom: 1px solid #f2f4f8;
}

.leave-row:last-child {
	border-bottom: none;
}

.leave-row:hover {
	background: #f8fafd;
}

.bar {
	flex: 0 0 auto;
	width: 3px;
	align-self: stretch;
	border-radius: 2px;
	background: #c8cdd6;
}

.bar.approved {
	background: #22a06b;
}

.bar.pending {
	background: #f0932b;
}

.bar.rejected {
	background: #e05252;
}

.leave-main {
	flex: 1;
	min-width: 0;
}

.leave-main .l1 {
	font-size: 13.5px;
	color: #2b3444;
	font-weight: 600;
}

/* 문서번호 — 상세 화면에서 쓰는 것과 같은 방식으로 조립한다 */
.leave-main .l1 em {
	font-style: normal;
	font-weight: 400;
	font-size: 12px;
	color: #98a3b5;
	margin-left: 8px;
}

.leave-main .l2 {
	font-size: 12.5px;
	color: #5b6576;
	margin-top: 5px;
}

.leave-main a {
	color: inherit;
	text-decoration: none;
}

.leave-main a:hover .l1 {
	color: #2f6bff;
	text-decoration: underline;
}

.leave-side {
	flex: 0 0 auto;
	text-align: right;
}

.leave-side .when {
	display: block;
	font-size: 11.5px;
	color: #98a3b5;
	margin-top: 7px;
}

.chip {
	display: inline-block;
	border: 1px solid;
	font-size: 11.5px;
	border-radius: 4px;
	padding: 2px 8px;
	white-space: nowrap;
}

.chip-pending {
	border-color: #ffd8a8;
	background: #fff5e5;
	color: #b26a00;
}

.chip-approved {
	border-color: #b7e4cd;
	background: #eef9f4;
	color: #1a7f55;
}

.chip-rejected {
	border-color: #f7c2c2;
	background: #fdf0f0;
	color: #c53c3c;
}

.empty {
	text-align: center;
	color: #98a3b5;
	padding: 46px 0;
	font-size: 13px;
}

.empty .big {
	display: block;
	font-size: 28px;
	color: #d5dbe4;
	margin-bottom: 10px;
}

/* ===== 아직 못 만든 것 (.soon) =====
   결재함들과 같은 규칙이다. 눌리지 않게 두고 말풍선으로 이유를 알린다.
   이 블럭이 <style> 맨 끝에 있어야 위쪽의 cursor:pointer 를 이긴다 */
.soon {
	cursor: not-allowed;
	position: relative;
}

.soon::after {
	content: attr(data-tip);
	position: absolute;
	top: calc(100% + 8px);
	left: 50%;
	transform: translateX(-50%);
	background: #2b3444;
	color: #fff;
	font-size: 11.5px;
	font-weight: 400;
	padding: 5px 10px;
	border-radius: 5px;
	white-space: nowrap;
	opacity: 0;
	visibility: hidden;
	transition: opacity .12s;
	pointer-events: none;
	z-index: 30;
}

.soon::before {
	content: "";
	position: absolute;
	top: calc(100% + 3px);
	left: 50%;
	transform: translateX(-50%);
	border: 5px solid transparent;
	border-bottom-color: #2b3444;
	opacity: 0;
	visibility: hidden;
	transition: opacity .12s;
	pointer-events: none;
	z-index: 30;
}

.soon:hover::after, .soon:hover::before {
	opacity: 1;
	visibility: visible;
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<%-- 사이드바 '내 휴가 > 휴가 현황' 이 이 값으로 활성 표시된다.
	     주소가 /leave 로 시작하므로 사이드바가 알아서 휴가 메뉴로 바뀐다 --%>
	<c:set var="menu" value="leaveMy" />
	<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>

	<div class="main">
		<div class="content">

			<div class="crumb">
				휴가 &gt; <b>내 휴가</b>
			</div>

			<div class="page-title title-row">
				<h2>휴가 현황</h2>
			</div>

			<%-- ═══════ 1. 나의 연차 현황 ═══════
			     숫자 넷 중 DB 컬럼은 잔여(employee.remain_leave) 하나뿐이다.
			     사용·대기는 vacation_request 를 세서 나오고,
			     총부여는 '잔여 + 사용' 으로 계산한 값이다 --%>
			<div class="card">
				<div class="card-top">
					<div>
						<h3>나의 연차 현황</h3>
						<p>승인 시 차감 · 연차만 집계</p>
					</div>
					<%-- 사이드바가 들고 있는 함수를 그대로 쓴다. 새 결재와 같은
					     1000x800 창이 뜬다 (sidebar.jsp 의 openVacationWrite) --%>
					<div class="right">
						<button type="button" class="btn-apply"
							onclick="openVacationWrite()">＋ 휴가 신청</button>
					</div>
				</div>

				<%-- .0 을 떼려고 fmt 를 쓴다. 8.0 -> 8, 0.5 -> 0.5 --%>
				<div class="stat-grid">
					<div class="stat stat-total">
						<b><fmt:formatNumber value="${summary.totalDays}"
								maxFractionDigits="1" />일</b> <span>총 부여 연차</span>
					</div>
					<div class="stat stat-used">
						<b><fmt:formatNumber value="${summary.usedDays}"
								maxFractionDigits="1" />일</b> <span>사용 연차</span>
					</div>
					<div class="stat stat-wait">
						<b><fmt:formatNumber value="${summary.pendingDays}"
								maxFractionDigits="1" />일</b> <span>승인 대기</span>
					</div>
					<div class="stat stat-remain">
						<b><fmt:formatNumber value="${summary.remainDays}"
								maxFractionDigits="1" />일</b> <span>잔여 연차</span>
					</div>
				</div>

				<%-- 사용률. 부여가 0이면 0으로 나누게 되므로 그때는 막대를 비운다 --%>
				<c:set var="rate" value="0" />
				<c:if test="${summary.totalDays gt 0}">
					<c:set var="rate"
						value="${summary.usedDays / summary.totalDays * 100}" />
				</c:if>

				<div class="usage">
					<div class="usage-label">
						<span>사용률 <fmt:formatNumber value="${rate}"
								maxFractionDigits="0" />%
						</span> <span><fmt:formatNumber value="${summary.usedDays}"
								maxFractionDigits="1" />/<fmt:formatNumber
								value="${summary.totalDays}" maxFractionDigits="1" />일</span>
					</div>
					<div class="usage-bar">
						<i style="width: ${rate}%"></i>
					</div>
				</div>
			</div>


			<%-- ═══════ 2. 예정 휴가 / 지난 휴가 ═══════
			     쿼리는 하나고, 서비스가 end_date 를 오늘과 견줘 두 리스트로 갈라 보낸다.
			     한 줄에 필요한 값 : docId / typeName / startDate / endDate / days
			                        / reason / status / createdAt
			     두 칸은 안이 완전히 같은 모양이다. 리스트 이름과 빈 문구만 다르다 --%>
			<div class="two-col">

				<%-- ── 왼쪽 : 예정 휴가 (오늘 이후) ── --%>
				<div class="card">
					<div class="card-top">
						<div>
							<h3>예정 휴가</h3>
							<p>오늘 이후로 잡혀 있는 휴가</p>
						</div>
						<div class="right">
							<span class="total-count">${fn:length(upcomingList)}건</span>
						</div>
					</div>

					<c:forEach var="lv" items="${upcomingList}">
						<%-- 왼쪽 세로 막대 색 = 문서 상태 --%>
						<c:set var="cls" value="pending" />
						<c:if test="${lv.status eq 'APPROVED'}">
							<c:set var="cls" value="approved" />
						</c:if>
						<c:if test="${lv.status eq 'REJECTED'}">
							<c:set var="cls" value="rejected" />
						</c:if>

						<div class="leave-row">
							<span class="bar ${cls}"></span>

							<div class="leave-main">
								<a
									href="${pageContext.request.contextPath}/document/detail?docId=${lv.docId}&from=sent">
									<div class="l1">
										${lv.typeName}
										<%-- 문서번호는 컬럼이 없어 화면에서 조립한다. 상세 화면과 같은 방식 --%>
										<em>LV-<fmt:formatNumber value="${lv.docId}"
												minIntegerDigits="4" groupingUsed="false" /></em>
									</div>
									<div class="l2">
										${lv.startDate}
										<c:if test="${lv.endDate ne lv.startDate}"> ~ ${lv.endDate}</c:if>
										· <fmt:formatNumber value="${lv.days}" maxFractionDigits="1" />일
										<c:if test="${not empty lv.reason}"> · ${lv.reason}</c:if>
									</div>
								</a>
							</div>

							<div class="leave-side">
								<c:choose>
									<c:when test="${lv.status eq 'APPROVED'}">
										<span class="chip chip-approved">승인</span>
									</c:when>
									<c:when test="${lv.status eq 'REJECTED'}">
										<span class="chip chip-rejected">반려</span>
									</c:when>
									<c:otherwise>
										<span class="chip chip-pending">승인대기</span>
									</c:otherwise>
								</c:choose>
								<span class="when">${fn:substring(lv.createdAt, 0, 10)} 신청</span>
							</div>
						</div>
					</c:forEach>

					<c:if test="${empty upcomingList}">
						<div class="empty">
							<span class="big">🏖</span>예정된 휴가가 없습니다.
						</div>
					</c:if>
				</div>

				<%-- ── 오른쪽 : 지난 휴가 (오늘 이전) ── --%>
				<div class="card">
					<div class="card-top">
						<div>
							<h3>지난 휴가</h3>
							<p>이미 다녀온 휴가</p>
						</div>
						<div class="right">
							<span class="total-count">${fn:length(pastList)}건</span>
						</div>
					</div>

					<c:forEach var="lv" items="${pastList}">
						<c:set var="cls" value="pending" />
						<c:if test="${lv.status eq 'APPROVED'}">
							<c:set var="cls" value="approved" />
						</c:if>
						<c:if test="${lv.status eq 'REJECTED'}">
							<c:set var="cls" value="rejected" />
						</c:if>

						<div class="leave-row">
							<span class="bar ${cls}"></span>

							<div class="leave-main">
								<a
									href="${pageContext.request.contextPath}/document/detail?docId=${lv.docId}&from=sent">
									<div class="l1">
										${lv.typeName}
										<em>LV-<fmt:formatNumber value="${lv.docId}"
												minIntegerDigits="4" groupingUsed="false" /></em>
									</div>
									<div class="l2">
										${lv.startDate}
										<c:if test="${lv.endDate ne lv.startDate}"> ~ ${lv.endDate}</c:if>
										· <fmt:formatNumber value="${lv.days}" maxFractionDigits="1" />일
										<c:if test="${not empty lv.reason}"> · ${lv.reason}</c:if>
									</div>
								</a>
							</div>

							<div class="leave-side">
								<c:choose>
									<c:when test="${lv.status eq 'APPROVED'}">
										<span class="chip chip-approved">승인</span>
									</c:when>
									<c:when test="${lv.status eq 'REJECTED'}">
										<span class="chip chip-rejected">반려</span>
									</c:when>
									<c:otherwise>
										<span class="chip chip-pending">승인대기</span>
									</c:otherwise>
								</c:choose>
								<span class="when">${fn:substring(lv.createdAt, 0, 10)} 신청</span>
							</div>
						</div>
					</c:forEach>

					<c:if test="${empty pastList}">
						<div class="empty">
							<span class="big">🗓</span>지난 휴가가 없습니다.
						</div>
					</c:if>
				</div>

			</div>

		</div>
	</div>

</body>
</html>
