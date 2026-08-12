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

.list-tbl td.role {
	width: 60px;
	color: #8a93a3;
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
					<c:set var="boxName" value="완료 문서" />
					<c:set var="boxUrl" value="/document/completed" />
				</c:when>
				<c:otherwise>
					<c:set var="boxName" value="상신 문서" />
					<c:set var="boxUrl" value="/document/submitted" />
				</c:otherwise>
			</c:choose>

			<%-- 결재선을 한 번 훑으면서 세 가지를 같이 알아낸다.
			     ① 처음 만나는 PENDING = 지금 차례. 그게 나면 myTurn
			     ② anyDone = 한 명이라도 처리했나 (상신취소·수정을 막는 기준)
			     ③ doneCnt = 결재이력 탭에 찍을 줄 수
			     ④ iAmApprover = 내가 이 문서의 결재자이긴 한가 --%>
			<c:set var="metPending" value="false" />
			<c:set var="myTurn" value="false" />
			<c:set var="anyDone" value="false" />
			<c:set var="doneCnt" value="0" />
			<c:set var="iAmApprover" value="false" />
			<c:forEach var="a" items="${doc.approvalLine}">
				<c:if test="${a.approvalStatus eq 'PENDING' and not metPending}">
					<c:set var="metPending" value="true" />
					<c:set var="curApproverId" value="${a.approverId}" />
					<c:if test="${a.approverId eq myId}">
						<c:set var="myTurn" value="true" />
					</c:if>
				</c:if>
				<c:if test="${a.approvalStatus ne 'PENDING'}">
					<c:set var="anyDone" value="true" />
					<c:set var="doneCnt" value="${doneCnt + 1}" />
				</c:if>
				<c:if test="${a.approverId eq myId}">
					<c:set var="iAmApprover" value="true" />
				</c:if>
			</c:forEach>

			<%-- 기안자 본인인가. 문서수정·상신취소는 이 사람만 볼 수 있고,
			     게다가 '아직 아무도 결재하지 않았을 때'만이다 —
			     결재가 한 번이라도 찍힌 문서를 고치면 앞사람이 승인한 내용이 달라진다 --%>
			<c:set var="isDrafter" value="${doc.employeeId eq myId}" />
			<c:set var="canEdit"
				value="${isDrafter and doc.status eq 'PENDING' and not anyDone}" />

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
						<button type="button" class="btn soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							<span class="ico blue">✎</span> 문서수정
						</button>
						<button type="button" class="btn soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							<span class="ico violet">↩</span> 상신취소
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

					<%-- '내 차례가 아니다'는 결재자한테만 뜻이 있는 말이다.
					     기안자는 애초에 결재할 사람이 아니라서 이 안내가 필요 없다.
					     문서가 지금 어떤 상태인지는 아래 요약 칸의 상태칩이 이미 말해 준다 --%>
					<c:if test="${iAmApprover and not myTurn}">
						<span class="turn-note"> <c:choose>
								<c:when test="${doc.status eq 'APPROVED'}">결재가 모두 끝난 문서입니다</c:when>
								<c:when test="${doc.status eq 'REJECTED'}">반려된 문서입니다</c:when>
								<c:otherwise>앞 순번 결재가 끝나면 내 차례가 됩니다</c:otherwise>
							</c:choose>
						</span>
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
						<%-- document 테이블에 마감일 컬럼이 아직 없다. 자리만 잡아둔 칸 --%>
						<div class="lbl">결재마감</div>
						<div class="val none">-</div>
					</div>
					<div class="cell">
						<div class="lbl">문서종류</div>
						<div class="val">${formName}</div>
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
							<th>기 안 자</th>
							<td>${doc.drafterName}<span class="sub">
									${doc.drafterPosition}</span></td>
						</tr>
						<tr>
							<th>소　　속</th>
							<td>${doc.drafterTeam}</td>
						</tr>
						<tr>
							<th>기 안 일</th>
							<td>${fn:substring(doc.createdAt, 0, 10)}</td>
						</tr>
						<tr>
							<th>문서번호</th>
							<td>DOC-${fn:substring(doc.createdAt, 0, 4)}-<fmt:formatNumber
									value="${doc.docId}" pattern="0000" /></td>
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
							<c:set var="isNow" value="${a.approverId eq curApproverId}" />
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
							결재이력 <span class="cnt">(${doneCnt + 1})</span>
						</button>
						<button type="button" class="ltab" onclick="showPane('line', this);">
							결재선 <span class="cnt">(${fn:length(doc.approvalLine)})</span>
						</button>
						<%-- 댓글·수정이력은 담을 테이블이 아예 없다.
						     열어봐야 빈 칸이라 탭 자체를 못 누르게 막고 말풍선으로 알린다 --%>
						<button type="button" class="ltab soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							댓글 <span class="cnt">(0)</span>
						</button>
						<button type="button" class="ltab soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							수정이력 <span class="cnt">(0)</span>
						</button>
					</div>

					<%-- 결재이력 : 따로 이력 테이블이 있는 게 아니라
					     document.created_at(상신) + approval_line.approved_at(승인·반려)을 늘어놓은 것이다.
					     결재 의견도 여기 같이 붙였다 — 언제 누가 무슨 말을 했는지가 한 줄에 있어야 읽힌다 --%>
					<div class="pane on" id="pane-hist">
						<table class="list-tbl">
							<tr>
								<th>날짜</th>
								<th>내역</th>
								<th>사용자</th>
								<th>의견</th>
							</tr>
							<tr>
								<td class="dt">${fn:replace(fn:substring(doc.createdAt, 0, 16), 'T', ' ')}</td>
								<td><span class="act">상신</span></td>
								<td class="who">${doc.drafterName} ${doc.drafterPosition}</td>
								<td class="memo none">-</td>
							</tr>
							<c:forEach var="a" items="${doc.approvalLine}">
								<%-- 아직 처리 안 한 사람은 이력이 없다. 찍힌 것만 나온다 --%>
								<c:if test="${a.approvalStatus ne 'PENDING'}">
									<tr>
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
								</c:if>
							</c:forEach>
						</table>
					</div>

					<%-- 결재선 : 상신할 때 정해진 한 벌. 순서대로 --%>
					<div class="pane" id="pane-line">
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
								<td>${doc.drafterTeam}</td>
								<td><span class="act">상신</span></td>
							</tr>
							<c:forEach var="a" items="${doc.approvalLine}">
								<tr>
									<td class="role">${a.approvalOrder}차 결재</td>
									<td class="who">${a.name} ${a.position}</td>
									<td>${a.teamName}</td>
									<td><c:choose>
											<c:when test="${a.approvalStatus eq 'APPROVED'}">
												<span class="act ok">승인</span>
											</c:when>
											<c:when test="${a.approvalStatus eq 'REJECTED'}">
												<span class="act no">반려</span>
											</c:when>
											<c:when test="${a.approverId eq curApproverId}">
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
