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
<title>eApproval - 문서 상세</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* ===== 문서 상세 =====
   화면을 세 덩어리로 나눈다.
   ① 시스템 영역 : 브레드크럼 · 버튼 · 문서 요약(상태·마감)   → 인쇄하면 사라진다
   ② 문서 영역   : 종이 한 장. 제목 → [문서정보 | 도장판] → 본문
   ③ 딸린 정보   : 첨부파일 · 결재이력/결재선/댓글          → 종이 밖
   기준은 '인쇄해서 남한테 줬을 때 종이에 있어야 하나'다. */

/* ===== ① 시스템 영역 ===== */
.detail-bar {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 16px;
	padding: 12px 0 16px;
}

.back-link {
	display: flex;
	align-items: center;
	gap: 10px;
	font-size: 14px;
	color: #5b6576;
}

.back-link a {
	color: #5b6576;
	text-decoration: none;
}

.back-link a:hover {
	color: #2f6bff;
}

.back-link .sep {
	color: #d5dbe4;
}

.back-link b {
	color: #1c2433;
	font-weight: 600;
}

.bar-btns {
	display: flex;
	align-items: center;
	gap: 7px;
	flex: 0 0 auto;
	flex-wrap: wrap;
	justify-content: flex-end;
}

/* 버튼 무리를 '누구를 위한 버튼인가'로 갈라 주는 세로줄.
   왼쪽 = 누구나, 가운데 = 기안자, 오른쪽 = 결재자 */
.btn-sep {
	width: 1px;
	height: 18px;
	background: #e2e6ee;
	margin: 0 3px;
}

/* 버튼은 흰 알약. 글자는 전부 같은 회색이고 아이콘 색으로만 성격을 구분한다.
   버튼마다 글자색까지 바꾸면 여섯 개가 서로 싸운다 */
.btn {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	border: 1px solid #e2e6ee;
	background: #fff;
	border-radius: 8px;
	padding: 7px 13px;
	font-size: 13px;
	color: #3d4756;
	cursor: pointer;
	white-space: nowrap;
	box-shadow: 0 1px 1px rgba(28, 36, 51, .03);
}

.btn:hover {
	border-color: #c6cfdc;
	background: #fbfcfe;
}

.btn .ico {
	font-size: 13px;
	color: #98a3b5;
}

.btn .ico.blue {
	color: #2f6bff;
}

.btn .ico.violet {
	color: #8b5cf6;
}

.btn .ico.teal {
	color: #14a3a3;
}

.btn .ico.red {
	color: #e05252;
}

/* 반려만 글자까지 빨갛다. 되돌릴 수 없는 동작이라 눈에 띄어야 한다 */
.btn-reject {
	color: #e05252;
}

.btn-reject:hover {
	background: #fff7f7;
	border-color: #f0c4c4;
}

/* 결재승인은 이 화면의 주된 동작이라 혼자 통버튼 */
.btn-approve {
	background: #2f6bff;
	border-color: #2f6bff;
	color: #fff;
	box-shadow: 0 1px 2px rgba(47, 107, 255, .3);
}

.btn-approve .ico {
	color: #fff;
}

.btn-approve:hover {
	background: #1f57e0;
	border-color: #1f57e0;
}

/* 내 차례가 아닐 때 결재 버튼 자리에 뜨는 안내 */
.turn-note {
	font-size: 12.5px;
	color: #98a3b5;
}

/* ===== 문서 요약 =====
   종이를 열기 전에 '무슨 문서이고 지금 어떤 상태인지'만 훑는 칸.
   상태·결재마감처럼 문서 내용이 아닌 것들은 전부 여기 모은다 */
.doc-summary {
	background: #f8fafc;
	border: 1px solid #eaeef4;
	border-radius: 8px;
	padding: 16px 22px 18px;
	margin-bottom: 20px;
}

.sum-top {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-bottom: 8px;
}

.doc-no {
	font-family: Consolas, monospace;
	font-size: 12.5px;
	color: #8a93a3;
	letter-spacing: .3px;
}

.chip {
	display: inline-block;
	font-size: 11.5px;
	border-radius: 4px;
	padding: 2px 8px;
	background: #fff5e5;
	color: #b26a00;
	white-space: nowrap;
}

.chip.ok {
	background: #eaf8f1;
	color: #1a7f55;
}

.chip.no {
	background: #fdf0f0;
	color: #c33;
}

.chip.urgent {
	background: #fdeaea;
	color: #d63c3c;
}

.sum-title {
	font-size: 17px;
	font-weight: 600;
	color: #1c2433;
	margin: 0;
	line-height: 1.45;
	word-break: break-all;
}

.sum-meta {
	display: flex;
	gap: 40px;
	margin-top: 16px;
}

.sum-meta .cell {
	flex: 1;
	min-width: 0;
}

.sum-meta .lbl {
	font-size: 12px;
	color: #98a3b5;
	margin-bottom: 6px;
}

.sum-meta .val {
	font-size: 13.5px;
	color: #2b3444;
}

.sum-meta .val.none {
	color: #c3cad5;
}

/* 결재 마감일. 목록과 같은 네 단계다 — 여유는 기본 글자색,
   임박은 빨강, 오늘은 굵게, 지난 것은 주황.
   요약 칸은 글자가 이미 커서 목록처럼 작게 줄이지 않는다 */
.sum-meta .val.due.near {
	color: #d64545;
}

.sum-meta .val.due.today {
	color: #d64545;
	font-weight: 700;
}

.sum-meta .val.due.over {
	color: #d99a00;
}

/* ===== ② 문서 영역 : 종이 한 장 ===== */
.paper {
	background: #fff;
	border: 1px solid #d5dbe4;
	border-radius: 4px;
	padding: 46px 46px 52px;
	box-shadow: 0 1px 3px rgba(28, 36, 51, .06);
}

/* 양식이 있는 문서는 양식 이름이 곧 제목이라 자간을 벌려 결재문서처럼 보이게 한다.
   기본기안은 정해진 이름이 없어 문서 제목이 그 자리에 들어간다 (JSP 쪽에서 갈라진다) */
.paper-title {
	text-align: center;
	font-size: 25px;
	font-weight: 700;
	color: #1c2433;
	margin: 0;
	line-height: 1.45;
	word-break: break-all;
}

.paper-title.form {
	letter-spacing: 12px;
	padding-left: 12px; /* 마지막 글자 뒤에도 자간이 붙어서 왼쪽으로 보정 */
}

/* 왼쪽 문서정보 / 오른쪽 도장판 */
.paper-top {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 30px;
	margin: 36px 0 24px;
}

/* ===== 왼쪽 : 문서정보 표 ===== */
.info-tbl {
	border-collapse: collapse;
	width: 340px;
	flex: 0 1 340px;
	font-size: 13px;
}

.info-tbl th, .info-tbl td {
	border: 1px solid #c9d0da;
	padding: 8px 12px;
	text-align: left;
	line-height: 1.5;
}

.info-tbl th {
	width: 92px;
	background: #f2f4f7;
	color: #3d4756;
	font-weight: 600;
	white-space: nowrap;
}

.info-tbl td {
	color: #2b3444;
}

.info-tbl td .sub {
	color: #8a93a3;
}

/* ===== 오른쪽 : 결재 도장판 =====
   칸 하나가 사람 한 명. 위=직급, 가운데=도장, 아래=처리일.
   왼쪽에 세로로 '기안' / '결재' 라벨이 붙어 두 덩어리를 구분한다 */
.stamp-box {
	display: flex;
	border: 1px solid #8b939f;
	width: fit-content;
	flex: 0 0 auto;
	background: #fff;
}

.stamp-side {
	width: 24px;
	border-right: 1px solid #8b939f;
	background: #f2f4f7;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 11.5px;
	color: #3d4756;
	letter-spacing: 3px;
	writing-mode: vertical-rl;
	padding: 4px 0;
}

.stamp-col {
	width: 78px;
	border-right: 1px solid #8b939f;
	text-align: center;
}

/* 마지막 칸의 오른쪽 선은 바깥 테두리와 겹치므로 지운다 */
.stamp-col:last-child {
	border-right: none;
}

.stamp-col .pos {
	font-size: 11.5px;
	color: #3d4756;
	padding: 5px 0;
	border-bottom: 1px solid #8b939f;
	background: #fafbfc;
	white-space: nowrap;
	overflow: hidden;
}

/* 도장이 찍히는 칸. 비어 있어도 높이가 유지돼야 칸이 안 찌그러진다 */
.stamp-col .mark {
	height: 60px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.stamp {
	width: 44px;
	height: 44px;
	border: 2px solid #e05252;
	border-radius: 50%;
	color: #e05252;
	font-size: 12px;
	font-weight: 600;
	display: flex;
	align-items: center;
	justify-content: center;
	transform: rotate(-8deg);
	word-break: keep-all;
	line-height: 1.1;
}

.stamp.reject {
	border-color: #98a3b5;
	color: #98a3b5;
}

/* 아직 결재를 안 한 칸 : 도장 대신 이름만 옅게 */
.stamp-col .waiting {
	font-size: 12px;
	color: #b8c0cd;
}

/* 취소 : 대기와 같은 옅은 이름이라 구분이 안 된다. 줄을 그어 끝난 칸임을 보인다 */
.stamp-col .waiting.cancel {
	text-decoration: line-through;
	color: #cbd2dc;
}

.stamp-col.now .waiting {
	color: #f0932b;
	font-weight: 600;
}

.stamp-col.now {
	background: #fffaf2;
}

/* 맨 아랫칸 : 처리한 날짜. 아직이면 비워 둔다 */
.stamp-col .day {
	font-size: 11px;
	color: #5b6576;
	padding: 5px 0;
	border-top: 1px solid #8b939f;
	min-height: 12px;
	white-space: nowrap;
}

/* 본문. 글쓴이가 엔터로 나눈 줄을 그대로 살리려면 pre-wrap 이 필요하다.
   안 그러면 줄바꿈이 전부 공백 하나로 뭉개진다 */
.paper-body {
	border: 1px solid #c9d0da;
	padding: 26px 18px;
	min-height: 340px;
	font-size: 14px;
	line-height: 1.9;
	color: #2b3444;
	white-space: pre-wrap;
	word-break: break-all;
}

.paper-body.none {
	color: #c3cad5;
}

/* ===== ③ 종이 바깥 : 딸린 정보 ===== */
.sub-area {
	margin-top: 22px;
}

/* 첨부파일 한 줄 띠. 증빙서류도 결국 첨부파일이라 따로 두지 않고 합쳤다.
   attachment 테이블은 있으나 업로드 기능이 없어 지금은 늘 0개다 */
.file-bar {
	display: flex;
	align-items: center;
	gap: 8px;
	border: 1px solid #e2e6ee;
	background: #f8fafc;
	border-radius: 6px;
	padding: 12px 16px;
	font-size: 13px;
	color: #3d4756;
}

.file-bar .clip {
	color: #98a3b5;
}

.file-bar b {
	font-weight: 600;
}

.file-bar .size {
	color: #98a3b5;
	font-size: 12px;
}

/* ===== 딸린 목록 한 블럭 =====
   결재이력·결재선·댓글·수정이력을 블럭 네 개로 늘어놓으면 화면만 길어진다.
   탭으로 갈아끼우고 개수를 옆에 적어 두면 열어보지 않아도 뭐가 있는지 보인다 */
.list-block {
	margin-top: 20px;
	border: 1px solid #e2e6ee;
	border-radius: 6px;
	overflow: hidden;
}

.list-tabs {
	display: flex;
	gap: 22px;
	background: #f8fafc;
	border-bottom: 1px solid #e2e6ee;
	padding: 0 16px;
}

.ltab {
	background: none;
	border: none;
	padding: 12px 0;
	font-size: 13px;
	color: #8a93a3;
	cursor: pointer;
	border-bottom: 2px solid transparent;
	margin-bottom: -1px;
}

.ltab:hover {
	color: #3d4756;
}

.ltab.on {
	color: #2f6bff;
	border-bottom-color: #2f6bff;
	font-weight: 600;
}

.ltab .cnt {
	color: #b8c0cd;
	font-weight: 400;
}

.ltab.on .cnt {
	color: #7ea3ff;
}

.pane {
	display: none;
	padding: 4px 16px 16px;
}

.pane.on {
	display: block;
}

.pane .empty {
	padding: 26px 0;
	text-align: center;
	font-size: 13px;
	color: #c3cad5;
}

.list-tbl {
	width: 100%;
	border-collapse: collapse;
	font-size: 12.5px;
}

.list-tbl th {
	padding: 10px 10px;
	text-align: left;
	color: #98a3b5;
	font-weight: 500;
	border-bottom: 1px solid #eaeef4;
	white-space: nowrap;
}

.list-tbl td {
	padding: 11px 10px;
	color: #2b3444;
	border-bottom: 1px solid #f2f4f8;
	vertical-align: middle;
}

.list-tbl tr:last-child td {
	border-bottom: none;
}

.list-tbl td.dt {
	color: #5b6576;
	white-space: nowrap;
	width: 130px;
}

.list-tbl td.who {
	white-space: nowrap;
	width: 130px;
}

.list-tbl td.memo {
	color: #5b6576;
	line-height: 1.6;
	white-space: pre-wrap;
}

.list-tbl td.memo.none {
	color: #d5dbe4;
}

/* 값이 없는 칸. 그냥 비워 두면 표가 깨진 것처럼 보여서 '-' 를 옅게 넣는다.
   팀에 속하지 않은 임원(사장·부장)은 team_name 이 늘 비어 있다 */
.list-tbl td.none {
	color: #d5dbe4;
}

/* 결재이력의 '내역' 칸 : 상신 / 승인 / 반려 */
.act {
	display: inline-block;
	font-size: 11.5px;
	border-radius: 3px;
	padding: 2px 9px;
	background: #eef2fb;
	color: #4a5a7a;
}

.act.ok {
	background: #eaf8f1;
	color: #1a7f55;
}

.act.no {
	background: #fdf0f0;
	color: #c33;
}

.act.wait {
	background: #f4f6f9;
	color: #b8c0cd;
}

/* 구분 칸. '1차 결재'·'병렬 결재'가 네 글자라 60px 에서는 '1차 결/재' 로 잘렸다.
   글자 수가 늘 같은 칸이니 줄바꿈을 막고 그만큼 자리를 준다 */
.list-tbl td.role {
	width: 78px;
	color: #8a93a3;
	white-space: nowrap;
}

/* 재상신된 문서에서 '지금 보고 있는 게 몇 회차 결재선인가'를 알리는 한 줄.
   표 위에 붙어야 표를 읽기 전에 눈에 든다 */
.round-note {
	margin: 10px 0 2px;
	padding: 8px 12px;
	background: #f8fafc;
	border: 1px solid #eaeef4;
	border-radius: 5px;
	font-size: 12.5px;
	color: #5b6576;
}

/* 인쇄하면 종이 한 장만 남는다.
   왼쪽 아이콘 줄(.rail)과 '새 결재' 팝업(#formModal)까지 지워야 진짜로 사라진다 */
@media print {
	.header, .rail, .sidebar, #formModal, .crumb, .detail-bar, .doc-summary,
		.sub-area {
		display: none !important;
	}
	.main, .content {
		margin: 0 !important;
		padding: 0 !important;
		max-width: none !important;
		width: auto !important;
	}
	.paper {
		border: none;
		box-shadow: none;
		padding: 0;
	}
	@page {
		margin: 14mm;
	}
}

/* ===== 아직 못 만든 버튼 (.soon) =====
   눌러 놓고 "준비 중입니다" 를 띄우면 사용자는 이미 한 번 속은 뒤다.
   그래서 아예 안 눌리게 하고(핸들러를 안 단다) 커서로 먼저 알려준 뒤,
   왜 안 되는지는 말풍선으로 설명한다. 모양·hover 는 원래 버튼 그대로 둔다.
   이 블럭이 <style> 맨 끝에 있어야 위쪽 버튼의 cursor:pointer 를 이긴다 */
.soon {
	cursor: not-allowed;
	position: relative;
}

/* <select> 는 브라우저가 직접 그리는 물건이라 ::after 가 안 붙는다.
   그래서 span 으로 감싸고 말풍선은 span 에 붙인다 */
span.soon {
	display: inline-flex;
	align-items: center;
}

/* 말풍선. inline-flex 버튼 안의 가상요소는 그냥 두면 flex 아이템이 돼서
   버튼 안에 글자로 끼어든다. absolute 를 줘야 흐름에서 빠져나온다.
   버튼이 화면 위쪽에 있어서 위가 아니라 아래로 띄운다 */
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
	letter-spacing: 0;
	padding: 5px 10px;
	border-radius: 5px;
	white-space: nowrap;
	opacity: 0;
	visibility: hidden;
	transition: opacity .12s;
	pointer-events: none;
	z-index: 30;
}

/* 말풍선 꼬리 */
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
	<%-- 상세는 상신함·대기함·완료함 어디서든 들어온다.
	     그래서 사이드바 메뉴는 일부러 아무것도 켜지 않는다 --%>
	<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>

	<div class="main">
		<div class="content">

			<%-- 로그인한 사람의 사번. 아래에서 '내 차례인지'를 판정할 때 쓴다 --%>
			<c:set var="myId" value="${sessionScope.loginUser.employeeId}" />

			<%-- 어느 결재함에서 들어왔는지. 목록이 ?from= 을 붙여 보낸다.
			     상세 화면 자체는 어디서 왔든 똑같지만, 브레드크럼과 '목록' 링크가
			     되돌아갈 곳을 알아야 하므로 이 값만 받는다 --%>
			<c:choose>
				<c:when test="${param.from eq 'wait'}">
					<c:set var="boxName" value="결재 대기 문서" />
					<c:set var="boxUrl" value="/document/pending" />
				</c:when>
				<c:when test="${param.from eq 'done'}">
					<c:set var="boxName" value="완료 문서함" />
					<c:set var="boxUrl" value="/document/completed" />
				</c:when>
				<c:otherwise>
					<c:set var="boxName" value="상신 문서함" />
					<c:set var="boxUrl" value="/document/submitted" />
				</c:otherwise>
			</c:choose>

			<%-- 병렬이면 순서를 안 따진다. 결재자 모두가 동시에 자기 차례다 --%>
			<c:set var="isParallel" value="${doc.approvalType eq 'PARALLEL'}" />

			<%-- 결재선을 한 번 훑으면서 네 가지를 같이 알아낸다.
			     doc.approvalLine 은 지금 돌고 있는 한 벌(최신 차수)뿐이라
			     반려됐던 지난 차수는 여기 없다 — 그건 doc.history 가 들고 있다.
			     ① 지금 차례가 나인가 (myTurn)
			        - 순차 : 처음 만나는 PENDING 이 나일 때
			        - 병렬 : 내 줄이 아직 PENDING 이기만 하면
			     ② anyDone = 이번 차수에서 한 명이라도 처리했나 (상신취소·수정을 막는 기준)
			     ③ curRound = 지금 몇 차인가. 2 이상이면 재상신된 문서다
			     ④ iAmApprover = 내가 이 문서의 결재자이긴 한가 --%>
			<c:set var="metPending" value="false" />
			<c:set var="myTurn" value="false" />
			<c:set var="anyDone" value="false" />
			<c:set var="curRound" value="1" />
			<c:set var="iAmApprover" value="false" />
			<c:forEach var="a" items="${doc.approvalLine}">
				<c:if test="${a.approvalStatus eq 'PENDING' and not metPending}">
					<c:set var="metPending" value="true" />
					<c:set var="curApproverId" value="${a.approverId}" />
					<c:if test="${a.approverId eq myId}">
						<c:set var="myTurn" value="true" />
					</c:if>
				</c:if>
				<%-- 병렬은 앞사람을 기다리지 않으므로 내 줄만 보면 된다 --%>
				<c:if
					test="${isParallel and a.approverId eq myId and a.approvalStatus eq 'PENDING'}">
					<c:set var="myTurn" value="true" />
				</c:if>
				<%-- 한 벌은 통째로 같은 차수라 아무 줄에서나 읽으면 된다 --%>
				<c:set var="curRound" value="${a.round}" />
				<%-- CANCELED(앞사람 반려로 차례가 사라진 줄)는 사람이 한 일이 아니라
				     이력에 남길 것도, 처리로 셀 것도 없다. 그래서 'PENDING 이 아닌 것'이 아니라
				     실제로 찍힌 두 상태만 센다 --%>
				<c:if
					test="${a.approvalStatus eq 'APPROVED' or a.approvalStatus eq 'REJECTED'}">
					<c:set var="anyDone" value="true" />
				</c:if>
				<c:if test="${a.approverId eq myId}">
					<c:set var="iAmApprover" value="true" />
					<%-- 내 줄이 어떤 상태인지. '아직 안 왔다'와 '내가 이미 했다'를
					     구분해서 안내 문구를 고르는 데 쓴다 --%>
					<c:set var="myLineStatus" value="${a.approvalStatus}" />
				</c:if>
			</c:forEach>

			<%-- 기안자 본인인가. 문서수정·상신취소는 이 사람만 볼 수 있고,
			     게다가 '아직 아무도 결재하지 않았을 때'만이다 —
			     결재가 한 번이라도 찍힌 문서를 고치면 앞사람이 승인한 내용이 달라진다 --%>
			<c:set var="isDrafter" value="${doc.employeeId eq myId}" />
			<c:set var="canEdit"
				value="${isDrafter and doc.status eq 'PENDING' and not anyDone}" />

			<%-- 재상신은 반대다. canEdit 은 status 가 PENDING 일 때, 이쪽은 REJECTED 일 때라
			     한 문서에서 둘이 같이 켜질 수 없다 — 상태는 하나뿐이니까.
			     결재가 찍혔는지(anyDone)는 여기서 안 본다. 반려됐다는 것 자체가
			     결재가 끝났다는 뜻이라 더 볼 게 없다. 반려 문서는 기안자만 되살릴 수 있다 --%>
			<c:set var="canRedraft"
				value="${isDrafter and doc.status eq 'REJECTED'}" />

			<%-- 문서 종류 이름 --%>
			<c:set var="formName">
				<c:choose>
					<c:when test="${doc.documentType eq 'VACATION'}">휴가신청서</c:when>
					<c:when test="${doc.documentType eq 'FREE'}">기본기안</c:when>
					<c:otherwise>${doc.documentType}</c:otherwise>
				</c:choose>
			</c:set>

			<%-- 정해진 양식이 있는 문서는 양식 이름이 곧 종이 제목이다 (휴가신청서·품의서).
			     기본기안은 양식 자체가 없으니 문서 제목이 그 자리에 들어간다.
			     어느 쪽이든 '문서 제목'은 위 요약 칸에 늘 보이므로 정보가 사라지진 않는다 --%>
			<c:set var="isFree" value="${doc.documentType eq 'FREE'}" />

			<div class="crumb">
				결재 &gt; <b>${boxName}</b>
			</div>

			<%-- ===== ① 시스템 영역 : 목록으로 + 버튼 ===== --%>
			<div class="detail-bar">
				<div class="back-link">
					<a href="${pageContext.request.contextPath}${boxUrl}">‹ 목록</a> <span
						class="sep">/</span> <b>${formName}</b>
				</div>

				<div class="bar-btns">
					<%-- '내 차례가 아니다'는 결재자한테만 뜻이 있는 말이다.
					     기안자는 애초에 결재할 사람이 아니라서 이 안내가 필요 없다.
					     버튼 맨 뒤에 두면 승인 버튼이 있던 자리라 눈이 안 가서 앞으로 뺐다 --%>
					<c:if test="${iAmApprover and not myTurn}">
						<span class="turn-note"> <c:choose>
								<c:when test="${doc.status eq 'APPROVED'}">결재가 모두 끝난 문서입니다</c:when>
								<c:when test="${doc.status eq 'REJECTED'}">반려된 문서입니다</c:when>
								<%-- 내가 이미 처리했고 남은 결재자를 기다리는 중.
								     병렬이면 늘 이 경우다 — 병렬엔 '앞 순번'이 없으니까 --%>
								<c:when test="${myLineStatus ne 'PENDING'}">내 결재는 끝났고 다른 결재자를 기다리는 중입니다</c:when>
								<c:otherwise>앞 순번 결재가 끝나면 내 차례가 됩니다</c:otherwise>
							</c:choose>
						</span>
						<div class="btn-sep"></div>
					</c:if>

					<%-- 누구나 쓸 수 있는 버튼 --%>
					<button type="button" class="btn" onclick="window.print();">
						<span class="ico">⎙</span> 인쇄
					</button>
					<%-- 메일 발송은 보낼 창구(메일 서버·발송 이력 테이블)가 없어 자리만 잡아둔다 --%>
					<button type="button" class="btn soon" aria-disabled="true"
						data-tip="추후 구현 예정">
						<span class="ico blue">✉</span> 메일발송
					</button>

					<%-- 기안자 전용 --%>
					<c:if test="${canEdit}">
						<div class="btn-sep"></div>
						<button type="button" class="btn" onclick="doEdit();">
							<span class="ico blue">✎</span> 문서수정
						</button>
						<button type="button" class="btn" onclick="doCancel();">
							<span class="ico violet">↩</span> 상신취소
						</button>
					</c:if>

					<%-- 반려된 내 문서 : 고쳐서 다시 올린다 --%>
					<c:if test="${canRedraft}">
						<div class="btn-sep"></div>
						<button type="button" class="btn btn-approve" onclick="doRedraft();">
							<span class="ico">↻</span> 재상신
						</button>
					</c:if>

					<%-- 결재자 전용 : 지금 내 차례일 때만 --%>
					<c:if test="${myTurn}">
						<div class="btn-sep"></div>
						<%-- 전달·보류·전결은 담을 컬럼이 없다.
						     approval_status 가 PENDING/APPROVED/REJECTED 셋뿐이라 저장할 자리가 없어
						     지금은 자리만 잡아둔 버튼이다 --%>
						<button type="button" class="btn soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							<span class="ico blue">⇄</span> 전달
						</button>
						<button type="button" class="btn soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							<span class="ico violet">⏱</span> 보류
						</button>
						<button type="button" class="btn btn-reject" onclick="doReject();">
							<span class="ico red">✕</span> 반려
						</button>
						<button type="button" class="btn soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							<span class="ico teal">⚑</span> 전결
						</button>
						<button type="button" class="btn btn-approve" onclick="doApprove();">
							<span class="ico">✓</span> 결재승인
						</button>
					</c:if>

				</div>
			</div>

			<%-- ===== 문서 요약 : 종이를 읽기 전에 훑는 칸 ===== --%>
			<div class="doc-summary">
				<div class="sum-top">
					<%-- 문서번호 컬럼이 따로 없어서 기안연도 + doc_id 네 자리로 화면에서 만든다 --%>
					<span class="doc-no">DOC-${fn:substring(doc.createdAt, 0, 4)}-<fmt:formatNumber
							value="${doc.docId}" pattern="0000" /></span>

					<c:choose>
						<c:when test="${doc.status eq 'APPROVED'}">
							<span class="chip ok">결재완료</span>
						</c:when>
						<c:when test="${doc.status eq 'REJECTED'}">
							<span class="chip no">반려</span>
						</c:when>
						<c:otherwise>
							<span class="chip">결재중</span>
						</c:otherwise>
					</c:choose>

					<c:if test="${doc.isUrgent}">
						<span class="chip urgent">긴급</span>
					</c:if>
				</div>

				<h2 class="sum-title">${doc.title}</h2>

				<div class="sum-meta">
					<div class="cell">
						<div class="lbl">기안자</div>
						<div class="val">${doc.drafterName}(${doc.drafterTeam})</div>
					</div>
					<div class="cell">
						<div class="lbl">기안일</div>
						<div class="val">${fn:substring(doc.createdAt, 0, 10)}</div>
					</div>
					<div class="cell">
						<div class="lbl">결재마감</div>
						<%-- 마감일은 선택이라 안 고른 문서는 목록처럼 비우지 않고 '-' 로 둔다.
						     요약 칸은 줄 수가 정해져 있어 칸이 통째로 사라지면 옆 칸들이 밀린다 --%>
						<c:choose>
							<c:when test="${empty doc.dueDate}">
								<div class="val none">-</div>
							</c:when>
							<c:otherwise>
								<div
									class="val due ${doc.overdue ? 'over' : (doc.daysLeft eq 0 ? 'today' : (doc.daysLeft le 3 ? 'near' : ''))}">
									${doc.dueDate}
									<c:choose>
										<c:when test="${doc.overdue}">(${doc.daysLeft * -1}일 지남)</c:when>
										<c:when test="${doc.daysLeft eq 0}">(오늘) ★</c:when>
										<c:when test="${doc.daysLeft le 3}">(${doc.daysLeft}일 남음)</c:when>
									</c:choose>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="cell">
						<div class="lbl">문서종류</div>
						<div class="val">${formName}</div>
					</div>
					<div class="cell">
						<%-- 순서대로 도는 문서인지 동시에 도는 문서인지.
						     도장판만 봐서는 구분이 안 돼서 글자로 적어 준다 --%>
						<div class="lbl">결재 방식</div>
						<div class="val">${isParallel ? '병렬 결재 (동시에)' : '순차 결재 (차례대로)'}</div>
					</div>
				</div>
			</div>

			<%-- ===== ② 문서 영역 : 여기서부터 종이 한 장 ===== --%>
			<div class="paper">

				<h1 class="paper-title ${isFree ? '' : 'form'}">${isFree ? doc.title : formName}</h1>

				<div class="paper-top">

					<%-- 왼쪽 : 이 문서가 '누가 언제 낸 것인지'.
					     위 요약 칸과 겹쳐 보이지만 저건 화면용이고 이건 인쇄물에 남아야 하는 칸이다 --%>
					<table class="info-tbl">
						<tr>
							<th>문서번호</th>
							<td>DOC-${fn:substring(doc.createdAt, 0, 4)}-<fmt:formatNumber
									value="${doc.docId}" pattern="0000" /></td>
						</tr>
						<tr>
							<th>기 안 일</th>
							<td>${fn:substring(doc.createdAt, 0, 10)}</td>
						</tr>
						<tr>
							<th>기 안 자</th>
							<td>${doc.drafterName}<span class="sub">
									${doc.drafterPosition}</span></td>
						</tr>
						<tr>
							<th>소　　속</th>
							<td>${doc.drafterTeam}</td>
						</tr>
					</table>

					<%-- 오른쪽 : 도장판. 기안자는 approval_line 에 없는 사람이라 따로 그린다 --%>
					<div class="stamp-box">
						<div class="stamp-side">기안</div>
						<div class="stamp-col">
							<div class="pos">${doc.drafterPosition}</div>
							<div class="mark">
								<span class="stamp">${doc.drafterName}</span>
							</div>
							<div class="day">${fn:replace(fn:substring(doc.createdAt, 0, 10), '-', '/')}</div>
						</div>

						<div class="stamp-side">결재</div>
						<c:forEach var="a" items="${doc.approvalLine}">
							<%-- 병렬은 아직 안 찍은 사람 모두가 지금 차례다.
						     순차는 그 중 맨 앞 한 명(curApproverId)만 --%>
						<c:set var="isNow"
							value="${isParallel ? (a.approvalStatus eq 'PENDING') : (a.approverId eq curApproverId)}" />
							<div class="stamp-col ${isNow ? 'now' : ''}">
								<div class="pos">${a.position}</div>
								<div class="mark">
									<c:choose>
										<c:when test="${a.approvalStatus eq 'APPROVED'}">
											<span class="stamp">${a.name}</span>
										</c:when>
										<c:when test="${a.approvalStatus eq 'REJECTED'}">
											<span class="stamp reject">반려</span>
										</c:when>
										<%-- 차례가 오지 않은 채 끝난 칸. 대기와 같은 모습이면
										     아직 기다리는 것처럼 보이므로 취소선으로 구분한다 --%>
										<c:when test="${a.approvalStatus eq 'CANCELED'}">
											<span class="waiting cancel">${a.name}</span>
										</c:when>
										<c:otherwise>
											<%-- 아직 안 찍힌 칸 : 도장 없이 이름만. 내 차례면 주황색이 된다 --%>
											<span class="waiting">${a.name}</span>
										</c:otherwise>
									</c:choose>
								</div>
								<div class="day">
									<c:if test="${not empty a.approvedAt}">${fn:replace(fn:substring(a.approvedAt, 0, 10), '-', '/')}</c:if>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>

				<%-- 기본기안이 아니면 종이 제목이 양식 이름이므로 문서 제목을 한 줄 넣어 준다 --%>
				<c:if test="${not isFree}">
					<table class="info-tbl" style="width: 100%; flex: none; margin-bottom: -1px;">
						<tr>
							<th style="width: 110px; text-align: center;">제　　목</th>
							<td>${doc.title}</td>
						</tr>
					</table>
				</c:if>

				<div class="paper-body ${empty doc.content ? 'none' : ''}">${empty doc.content ? '(내용 없음)' : doc.content}</div>
			</div>

			<%-- ===== ③ 종이 바깥 : 문서에 딸린 정보 ===== --%>
			<div class="sub-area">

				<%-- 첨부파일 = 증빙서류. 둘로 나눠 놓을 이유가 없어 한 줄로 합쳤다 --%>
				<div class="file-bar">
					<span class="clip">📎</span> 첨부파일 <b>0</b>개 <span class="size">(0Byte)</span>
				</div>

				<div class="list-block">
					<div class="list-tabs">
						<button type="button" class="ltab on" onclick="showPane('hist', this);">
							결재이력 <span class="cnt">(${fn:length(doc.history) + 1})</span>
						</button>
						<button type="button" class="ltab" onclick="showPane('line', this);">
							결재선 <span class="cnt">(${fn:length(doc.approvalLine)})</span>
						</button>
						<%-- 댓글·수정이력 탭을 뺐다.
						     둘 다 담을 테이블이 없어서 (0) 만 띄우고 못 누르는 탭이었는데,
						     '있는데 안 되는 것'처럼 보여서 없느니만 못했다.
						     수정이력은 회차가 언제 올라갔는지 적을 시각 컬럼조차 없어
						     document_history 테이블이 생기기 전엔 만들 수가 없다.
						     테이블이 생기면 여기 탭을 다시 붙이면 된다 --%>
					</div>

					<%-- 결재이력 : 따로 이력 테이블이 있는 게 아니라
					     document.created_at(상신) + approval_line.approved_at(승인·반려)을 늘어놓은 것이다.
					     결재 의견도 여기 같이 붙였다 — 언제 누가 무슨 말을 했는지가 한 줄에 있어야 읽힌다.
					     위 도장판과 달리 여기는 doc.history 를 본다 — 반려 후 재상신하면
					     지난 차수의 반려 사유가 여기서만 남는다. 그게 이력 탭이 있는 이유다 --%>
					<div class="pane on" id="pane-hist">
						<table class="list-tbl">
							<tr>
								<%-- 한 번도 반려된 적 없는 문서는 전부 1회차라 칸이 있어 봐야 같은 값만 반복된다.
								     아래 결재선 탭이 순서를 'N차 결재'라고 부르고 있어서
								     재상신 차수는 'N회차'로 갈라 적는다. 둘 다 '차'면 못 읽는다 --%>
								<c:if test="${curRound > 1}">
									<th>회차</th>
								</c:if>
								<th>날짜</th>
								<th>내역</th>
								<th>사용자</th>
								<th>의견</th>
							</tr>
							<tr>
								<%-- 상신은 document 에 시각이 한 개(created_at)뿐이라
								     재상신을 몇 번 했든 최초 기안 한 줄만 적는다.
								     상신 시각을 차수별로 남기려면 이력 테이블이 따로 있어야 한다 --%>
								<c:if test="${curRound > 1}">
									<td class="role">1회차</td>
								</c:if>
								<td class="dt">${fn:replace(fn:substring(doc.createdAt, 0, 16), 'T', ' ')}</td>
								<td><span class="act">상신</span></td>
								<td class="who">${doc.drafterName} ${doc.drafterPosition}</td>
								<td class="memo none">-</td>
							</tr>
							<%-- history 는 이미 '찍힌 줄'만 담아 오고 차수·순서대로 정렬돼 있다.
							     대기 중이거나 앞사람 반려로 취소된 줄은 애초에 안 들어온다 --%>
							<c:forEach var="a" items="${doc.history}">
								<tr>
									<c:if test="${curRound > 1}">
										<td class="role">${a.round}회차</td>
									</c:if>
									<td class="dt">${fn:replace(fn:substring(a.approvedAt, 0, 16), 'T', ' ')}</td>
									<td><c:choose>
											<c:when test="${a.approvalStatus eq 'REJECTED'}">
												<span class="act no">반려</span>
											</c:when>
											<c:otherwise>
												<span class="act ok">승인</span>
											</c:otherwise>
										</c:choose></td>
									<td class="who">${a.name} ${a.position}</td>
									<td class="memo ${empty a.comment ? 'none' : ''}">${empty a.comment ? '-' : a.comment}</td>
								</tr>
							</c:forEach>
						</table>
					</div>

					<%-- 결재선 : 상신할 때 정해진 한 벌. 순서대로.
					     재상신하면 결재선을 다시 짤 수 있으므로 여기 뜨는 건 늘 지금 도는 한 벌이다.
					     지난 회차 사람들은 이력 탭에 남아 있다 --%>
					<div class="pane" id="pane-line">
						<c:if test="${curRound > 1}">
							<div class="round-note">반려 후 재상신된 문서입니다. 아래는 ${curRound}회차 결재선입니다.</div>
						</c:if>
						<table class="list-tbl">
							<tr>
								<th>구분</th>
								<th>이름</th>
								<th>부서</th>
								<th>상태</th>
							</tr>
							<tr>
								<td class="role">기안</td>
								<td class="who">${doc.drafterName} ${doc.drafterPosition}</td>
								<td class="${empty doc.drafterTeam ? 'none' : ''}">${empty doc.drafterTeam ? '-' : doc.drafterTeam}</td>
								<td><span class="act">상신</span></td>
							</tr>
							<c:forEach var="a" items="${doc.approvalLine}">
								<tr>
									<%-- 병렬은 동시에 결재하므로 차수가 없다.
									     1차·2차로 적으면 순서가 있는 것처럼 읽힌다 --%>
									<td class="role"><c:choose>
											<c:when test="${isParallel}">병렬 결재</c:when>
											<c:otherwise>${a.approvalOrder}차 결재</c:otherwise>
										</c:choose></td>
									<td class="who">${a.name} ${a.position}</td>
									<td class="${empty a.teamName ? 'none' : ''}">${empty a.teamName ? '-' : a.teamName}</td>
									<td><c:choose>
											<c:when test="${a.approvalStatus eq 'APPROVED'}">
												<span class="act ok">승인</span>
											</c:when>
											<c:when test="${a.approvalStatus eq 'REJECTED'}">
												<span class="act no">반려</span>
											</c:when>
											<%-- 앞사람이 반려해 차례가 오지 않은 사람.
											     검토중 판정보다 먼저 걸러야 한다 --%>
											<c:when test="${a.approvalStatus eq 'CANCELED'}">
												<span class="act wait">취소</span>
											</c:when>
											<%-- 병렬은 안 찍은 사람 모두가 검토중 --%>
											<c:when
												test="${isParallel or a.approverId eq curApproverId}">
												<span class="act">검토중</span>
											</c:when>
											<c:otherwise>
												<span class="act wait">대기</span>
											</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</table>
					</div>

				</div>
			</div>

			<%-- 승인·반려는 이 폼 하나로 보낸다. 의견은 JS 가 채워 넣는다.
			     GET 으로 보내면 주소창만 고쳐도 남의 문서가 결재되니 POST 다 --%>
			<form id="apprForm" method="post"
				action="${pageContext.request.contextPath}/document/approve">
				<input type="hidden" name="docId" value="${doc.docId}"> <input
					type="hidden" name="comment" id="cmtField">
			</form>

		</div>
	</div>

	<script>
		var ctx = "${pageContext.request.contextPath}";

		// 승인 : 의견은 안 써도 된다
		function doApprove() {
			var c = prompt("결재 의견을 입력하세요. (없으면 비워두세요)", "");
			if (c === null) return; // 취소
			document.getElementById("cmtField").value = c;
			document.getElementById("apprForm").action = ctx + "/document/approve";
			document.getElementById("apprForm").submit();
		}

		// 반려 : 사유가 없으면 왜 막혔는지 기안자가 알 수 없으니 꼭 받는다
		function doReject() {
			var c = prompt("반려 사유를 입력하세요.", "");
			if (c === null) return;
			if (c.trim() === "") {
				alert("반려 사유는 반드시 입력해야 합니다.");
				return;
			}
			document.getElementById("cmtField").value = c;
			document.getElementById("apprForm").action = ctx + "/document/reject";
			document.getElementById("apprForm").submit();
		}

		// 상신취소 : 되돌리면 결재 대기 중인 사람들 목록에서 문서가 사라지므로
		// 한 번 물어본다. 의견은 받을 이유가 없어 폼만 다시 쓴다
		function doCancel() {
			if (!confirm("상신을 취소하고 임시저장으로 되돌립니다.\n계속하시겠습니까?")) return;
			document.getElementById("apprForm").action = ctx + "/document/cancel";
			document.getElementById("apprForm").submit();
		}

		// 문서수정 : 고치려면 임시저장으로 내려가야 해서 결재가 한 번 취소된다.
		// 되돌리는 일은 상신취소와 같고 끝나고 가는 곳만 작성 화면으로 다르다
		function doEdit() {
			var msg = "문서를 수정하면 상신이 취소되며 '임시저장' 상태로 전환됩니다.\n\n"
					+ "수정 작업을 취소하더라도 상신 상태로 복구되지 않으므로,\n"
					+ "결재를 진행하려면 반드시 재상신을 해주셔야 합니다.\n\n"
					+ "계속 진행하시겠습니까?";
			if (!confirm(msg)) return;
			document.getElementById("apprForm").action = ctx + "/document/edit";
			document.getElementById("apprForm").submit();
		}

		// 재상신 : 반려된 문서를 임시저장으로 되돌려 작성 화면으로 보낸다.
		// 문서수정과 가는 곳은 같지만 이쪽은 되돌릴 상신이 없다 —
		// 이미 반려로 끝난 문서라 '취소된다'가 아니라 '다시 연다'로 설명해야 맞는다
		function doRedraft() {
			var msg = "반려된 문서를 다시 작성합니다.\n\n"
					+ "문서가 '임시저장' 상태로 바뀌며 상신 문서함에서 내려갑니다.\n"
					+ "내용을 고친 뒤 다시 상신해야 결재가 진행됩니다.\n\n"
					+ "지난 결재 의견은 결재이력에 그대로 남습니다.\n\n"
					+ "계속 진행하시겠습니까?";
			if (!confirm(msg)) return;
			document.getElementById("apprForm").action = ctx + "/document/redraft";
			document.getElementById("apprForm").submit();
		}

		// 아래 목록 블럭 탭 : 켜진 것 하나만 남기고 나머지를 끈다
		function showPane(name, btn) {
			var panes = document.querySelectorAll(".pane");
			for (var i = 0; i < panes.length; i++) {
				panes[i].className = "pane";
			}
			document.getElementById("pane-" + name).className = "pane on";

			var tabs = document.querySelectorAll(".ltab");
			for (var j = 0; j < tabs.length; j++) {
				tabs[j].className = "ltab";
			}
			btn.className = "ltab on";
		}
	</script>

</body>
</html>
