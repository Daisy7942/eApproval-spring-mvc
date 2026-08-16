<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>eApproval - 결재 대기 문서</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* ===== 이 화면에서만 쓰는 스타일 =====
   목록 전체를 흰 카드 하나로 묶었다. 카드 머리에 필터·검색·도구가 있고
   그 아래가 표다. 테두리를 카드 하나로 통일해서 요소들이 따로 놀지 않게 했다. */

/* 제목 줄 : 왼쪽 제목, 오른쪽 건수 */
.title-row {
	display: flex;
	align-items: baseline;
	justify-content: space-between;
	margin-bottom: 28px;
}

.total-count {
	font-size: 12.5px;
	color: #8a93a3;
}

/* ===== 카드 : 바탕은 흰색, 테두리는 최소한만 ===== */
.list-card {
	background: #fff;
}

/* 표 위 도구 줄. 바깥 본문 배경(common.css 의 --bg)과 같은 색이라
   흰 표만 판처럼 도드라진다 */
.card-head {
	display: flex;
	align-items: center;
	gap: 16px;
	padding: 15px 0 5px;
	background: var(--bg);
}

.card-head .right {
	margin-left: auto;
	display: flex;
	align-items: center;
	gap: 14px;
}

/* 검색 - 도구 줄 왼쪽. 연회색으로 채워 판 위에서도 눈에 띄게 */
.search-box {
	flex: 1;
	min-width: 0;
	max-width: 620px;
	display: flex;
	align-items: center;
	gap: 8px;
	border: 1px solid #e2e6ee;
	border-radius: 8px;
	background: #fff;
	padding: 7px 12px;
	transition: border-color .15s, background .15s;
}

.search-box:focus-within {
	border-color: #b9d0ff;
	background: #fff;
}

.search-box .ico {
	color: #a5aebd;
	font-size: 19px;
	line-height: 1;
	padding: 0px 0px 5px;
}

.search-box input {
	flex: 1;
	min-width: 0;
	border: none;
	background: none;
	font-size: 13px;
	color: #2b3444;
}

.search-box input::placeholder {
	color: #aab2be;
}

.search-box input:focus {
	outline: none;
}

.search-box .clear {
	border: none;
	background: none;
	color: #a5aebd;
	font-size: 13px;
	line-height: 1;
	padding: 2px 4px;
	cursor: pointer;
}

.search-box .clear:hover {
	color: #2b3444;
}

/* ===== 머리글 필터 =====
   머리글 글자 자체가 버튼이다. 눌러야 열리는 걸 알려야 해서 ▾ 를 붙였고,
   걸려 있는 동안에는 파란색으로 남겨 지금 걸러진 상태임을 보여준다 */
.col-filter {
	position: relative;
	display: inline-block;
}

.col-btn {
	border: none;
	background: none;
	padding: 0;
	font-size: 13px;
	font-weight: 500;
	color: #5b6576;
	cursor: pointer;
	white-space: nowrap;
}

.col-btn:hover {
	color: #2f6bff;
}

.col-btn.on {
	color: #2f6bff;
	font-weight: 600;
}

.col-btn .caret {
	font-size: 10px;
	color: #a5aebd;
}

.col-btn.on .caret {
	color: #2f6bff;
}

/* 평소엔 숨어 있다가 머리글을 누르면 열린다 */
.col-menu {
	display: none;
	position: absolute;
	top: calc(100% + 6px);
	left: 0;
	min-width: 118px;
	background: #fff;
	border: 1px solid #dfe4ec;
	border-radius: 8px;
	box-shadow: 0 6px 18px rgba(16, 24, 40, .12);
	padding: 4px;
	z-index: 40;
}

.col-menu.open {
	display: block;
}

.col-menu a {
	display: block;
	padding: 7px 10px;
	font-size: 12.5px;
	color: #3d4756;
	text-decoration: none;
	border-radius: 6px;
	font-weight: 400;
}

.col-menu a:hover {
	background: #f1f5ff;
	color: #2f6bff;
}

/* 지금 걸려 있는 값 */
.col-menu a.sel {
	background: #2f6bff;
	color: #fff;
	font-weight: 600;
}

/* 표 아래 페이지 번호 줄. 문서함 네 곳이 같은 모양이다 */
.paging {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 2px;
	padding: 26px 0 8px;
}

.paging a, .paging span {
	min-width: 32px;
	height: 32px;
	padding: 0 6px;
	border-radius: 8px;
	font-size: 13px;
	color: #5b6576;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	transition: background .12s, color .12s;
}

.paging a:hover {
	background: #f1f5ff;
	color: #2f6bff;
}

/* 지금 보고 있는 쪽은 누를 데가 아니라 <a> 가 아니다 */
.paging .now {
	background: #2f6bff;
	color: #fff;
	font-weight: 600;
}

.paging .arrow {
	font-size: 16px;
	line-height: 1;
	color: #8a93a3;
}

.paging a.arrow:hover {
	color: #2f6bff;
}

/* 첫 쪽에서의 '이전', 끝 쪽에서의 '다음' — 자리는 지키되 못 누른다 */
.paging .off {
	color: #d3d8e0;
	cursor: default;
}

/* 카드 머리 2줄 : 도구 */
.act {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	background: none;
	border: none;
	padding: 0;
	font-size: 13px;
	color: #3d4756;
	cursor: pointer;
}

.act:hover, .act:hover .ico {
	color: #2f6bff;
}

.act .ico {
	font-size: 14px;
	color: #8a93a3;
}

.card-head select {
	border: 1px solid #dbe1ea;
	border-radius: 6px;
	padding: 3px 4px;
	font-size: 12px;
	color: #3d4756;
	background: #fff;
}

.divider {
	width: 1px;
	height: 13px;
	background: #dfe4ec;
}

/* ===== 표 =====
   표는 화면 폭을 그대로 쓴다. 감싸는 테두리도, 양옆 색 여백도 두지 않는다 */
.table-wrap {
	background: transparent;
}

.doc-table {
	width: 100%;
	border-collapse: collapse;
}

/* 상신함·완료함과 같은 머리글 : 흰 바탕에 위아래 회색선 */
.doc-table thead th {
	text-align: left;
	font-size: 13px;
	color: #5b6576;
	font-weight: 500;
	padding: 12px 14px;
	background: #fff;
	border-top: 1px solid #d9dee7;
	border-bottom: 1px solid #d9dee7;
	white-space: nowrap;
}

.doc-table tbody td {
	padding: 14px;
	border-bottom: 1px solid #f2f4f8;
	font-size: 13.5px;
	color: #2b3444;
	vertical-align: middle;
}

.doc-table tbody tr:last-child td {
	border-bottom: none;
}

.doc-table tbody tr:hover {
	background: #f8fafd;
}

.col-check {
	width: 42px;
	text-align: center;
}

/* 머리글·본문 둘 다 가운데 정렬해야 ⚠ 가 칸 한가운데 온다 */
.doc-table th.col-urgent, .doc-table td.col-urgent {
	width: 80px;
	text-align: center;
}

td.form-name {
	color: #2f6bff;
	white-space: nowrap;
}

td.title a {
	color: #2b3444;
	text-decoration: none;
	font-weight: 500;
}

td.title a:hover {
	color: #2f6bff;
	text-decoration: underline;
}

td.date {
	color: #5b6576;
	white-space: nowrap;
	font-size: 13px;
}

td.attach {
	color: #8a93a3;
	font-size: 12px;
	text-align: center;
}

.urgent-mark {
	color: #e5484d;
	font-weight: bold;
}

/* 기안자 - 이름 아래 팀 이름을 작게 */
td.drafter {
	font-size: 13px;
	color: #2b3444;
	white-space: nowrap;
}

td.drafter span {
	display: block;
	font-size: 11.5px;
	color: #98a3b5;
	margin-top: 2px;
}

/* 상태 칩 - 문서 전체 상태다. '내 차례'가 아니라 문서가 아직 돌고 있다는 뜻 */
.chip {
	display: inline-block;
	border: 1px solid #ffd8a8;
	font-size: 11.5px;
	border-radius: 4px;
	padding: 2px 8px;
	white-space: nowrap;
	background: #fff5e5;
	color: #b26a00;
}

/* 상신함·완료함과 같은 빈 목록 : 흰 바탕에 회색 한 줄 */
.empty {
	text-align: center;
	color: #98a3b5;
	padding: 56px 0;
	font-size: 13px;
}

.empty .big {
	display: block;
	font-size: 28px;
	color: #d5dbe4;
	margin-bottom: 10px;
}

/* ===== 결재선 동그라미 =====
   결재자 이름 첫 글자를 상태 색으로 보여준다. 마우스를 올리면
   아래에 흰 말풍선으로 "이름 직급 (상태)" 가 뜬다.
   nowrap 이 없으면 사람이 많을 때 줄이 접혀 두 줄로 보인다 */
td.appr {
	white-space: nowrap;
}

.appr-line {
	display: flex;
	flex-wrap: nowrap;
	gap: 1px;
	align-items: center;
}

.appr-dot {
	position: relative;
	flex: 0 0 auto;
	width: 24px;
	height: 24px;
	border-radius: 50%;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	font-size: 10.5px;
	font-weight: 600;
	color: #fff;
	background: #c8cdd6; /* 기본 = 대기(회색) */
	cursor: default;
}

.appr-dot.done {
	background: #22a06b;
} /* 승인 */
.appr-dot.now {
	background: #f0932b;
} /* 검토중 = 지금 이 사람 차례 */
.appr-dot.reject {
	background: #e05252;
} /* 반려 */

/* 전달(연보라) 은 아직 기능이 없다. 색만 잡아뒀고 걸리는 데이터가 없다 */
.appr-dot.pass {
	background: #9b8cf5;
}

/* 말풍선. 평소엔 숨어 있다가 동그라미에 마우스를 올리면 나타난다.
   브라우저 기본 title 툴팁은 모양을 못 바꿔서 직접 만들었다 */
/* 5번째부터 접었을 때 보이는 … */
.appr-more {
	position: relative;
	margin-left: 3px;
	font-size: 14px;
	color: #98a3b5;
	cursor: default;
}

.appr-dot .tip, .appr-more .tip {
	display: none;
	position: absolute;
	top: 125%;
	left: 50%;
	transform: translateX(-50%);
	background: #fff;
	border: 1px solid #dfe4ec;
	box-shadow: 0 4px 12px rgba(16, 24, 40, .14);
	color: #2b3444;
	font-size: 11.5px;
	font-weight: 400;
	padding: 5px 9px;
	border-radius: 6px;
	white-space: nowrap;
	z-index: 20;
}

.appr-dot:hover .tip, .appr-more:hover .tip {
	display: block;
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

	<%-- 사이드바 '결재하기 > 결재 대기 문서' 가 이 값으로 활성 표시된다 --%>
	<c:set var="menu" value="apprWait" />
	<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>

	<div class="main">
		<div class="content">

			<div class="crumb">
				결재 &gt; <b>결재 대기 문서</b>
			</div>

			<%-- 페이지를 넘겨도 조건이 유지되도록, 링크에 붙일 값을 한 번만 만들어 둔다.
			     하나라도 빠뜨리면 그 조건만 슬그머니 풀려서 여기 모아 둔다 --%>
			<c:set var="qs"
				value="&size=${pageVO.size}&keyword=${pageVO.keyword}&docType=${pageVO.docType}&status=${pageVO.status}" />

			<div class="page-title title-row">
				<h2>결재 대기 문서</h2>
				<%-- 화면에 그려진 줄이 아니라 DB 가 센 전체 건수다 --%>
				<span class="total-count">${pageVO.total}건</span>
			</div>

			<div class="list-card">

				<%-- 한 줄에 왼쪽 검색, 오른쪽 도구.
				     검색은 서버가 한다. 글자를 치고 잠깐 멈추면 알아서 다시 불러온다 --%>
				<div class="card-head">
					<div class="search-box">
						<span class="ico">⌕</span> <input type="text" id="q"
							placeholder="제목 · 기안자 검색" value="${pageVO.keyword}" autocomplete="off"
							oninput="scheduleSearch()"
							onkeydown="if(event.key==='Enter'){doSearch();}">
						<%-- 검색어가 있을 때만 뜨는 지우개 --%>
						<c:if test="${not empty pageVO.keyword}">
							<button type="button" class="clear" onclick="clearSearch()"
								title="검색어 지우기">✕</button>
						</c:if>
					</div>

					<div class="right">
						<button type="button" class="act soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							<span class="ico">⭳</span> 목록 다운로드
						</button>
						<button type="button" class="act soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							<span class="ico">✓</span> 일괄결재
						</button>
						<span class="divider"></span>
						<%-- 한 쪽에 몇 줄. 고르면 곧바로 그 줄 수로 다시 불러온다 --%>
						<select onchange="changeSize(this.value)" title="한 쪽에 보여줄 줄 수">
							<option value="10" ${pageVO.size eq 10 ? 'selected' : ''}>10</option>
							<option value="20" ${pageVO.size eq 20 ? 'selected' : ''}>20</option>
							<option value="50" ${pageVO.size eq 50 ? 'selected' : ''}>50</option>
						</select>
					</div>
				</div>

				<%-- 체크박스는 일괄결재용이다. 삭제는 남의 문서라 여전히 없다 --%>
				<div class="table-wrap">
				<table class="doc-table">
					<thead>
						<tr>
							<th class="col-check"><input type="checkbox"
								onclick="toggleAll(this)"></th>
							<th style="width: 150px;"><div class="col-filter">
								<button type="button" class="col-btn ${not empty pageVO.docType ? 'on' : ''}"
									onclick="toggleMenu(event, 'mType')">
									결재양식 <span class="caret">▾</span>
								</button>
								<div class="col-menu" id="mType">
									<a href="#" onclick="setFilter('docType',''); return false;"
										class="${empty pageVO.docType ? 'sel' : ''}">전체</a>
									<a href="#" onclick="setFilter('docType','FREE'); return false;"
										class="${pageVO.docType eq 'FREE' ? 'sel' : ''}">기본기안</a>
									<a href="#" onclick="setFilter('docType','VACATION'); return false;"
										class="${pageVO.docType eq 'VACATION' ? 'sel' : ''}">휴가신청서</a>
								</div>
							</div></th>
							<th class="col-urgent">긴급</th>
							<th>제목</th>
							<th style="width: 80px;">첨부</th>
							<th style="width: 110px;">기안자</th>
							<th style="width: 130px;">기안일</th>
							<th style="width: 110px;">상태</th>
							<th class="appr" style="width: 160px;">결재선</th>
						</tr>
					</thead>
					<tbody>

						<%-- data-* 는 화면에서 걸러낼 때 쓰는 값이다.
						     JS 가 이 둘만 보고 줄을 보이거나 숨긴다 --%>
						<c:forEach var="doc" items="${pendingList}">
							<tr class="doc-row" data-status="${doc.status}">
								<td class="col-check"><input type="checkbox"
									class="row-check" value="${doc.docId}"></td>

								<td class="form-name"><c:choose>
										<c:when test="${doc.documentType eq 'VACATION'}">휴가신청서</c:when>
										<c:when test="${doc.documentType eq 'FREE'}">기본기안</c:when>
										<c:otherwise>${doc.documentType}</c:otherwise>
									</c:choose></td>

								<td class="col-urgent"><c:if test="${doc.isUrgent}">
										<span class="urgent-mark" title="긴급">⚠</span>
									</c:if></td>

								<%-- 승인·반려 버튼이 붙을 상세 화면은 아직 없다 --%>
								<td class="title"><a href="#"
									onclick="openDoc(${doc.docId}); return false;">${doc.title}</a></td>

								<td class="attach"></td>

								<%-- 기안자. document.employee_id 로 employee 를 한 번 더 JOIN 해서 가져온 값이다 --%>
								<td class="drafter">${doc.drafterName}<span>${doc.drafterTeam}</span></td>

								<%-- LocalDateTime 은 2026-08-06T14:22:31 모양으로 찍힌다. 앞 10글자가 날짜 --%>
								<td class="date">${fn:substring(doc.createdAt, 0, 10)}</td>

								<td><span class="chip">결재중</span></td>

								<%-- 결재선. 순서대로 훑다가 처음 만나는 PENDING 이 '검토중'(주황),
								     그 뒤에 남은 PENDING 은 전부 '대기'(회색)다.
								     metPending 이 그 '처음 하나'를 이미 만났는지 기억한다 --%>
								<td class="appr">
									<div class="appr-line">
										<%-- 맨 왼쪽은 기안자. 결재선 테이블엔 없는 사람이라 따로 그린다 --%>
										<span class="appr-dot done">${fn:substring(doc.drafterName, 0, 1)}<span
												class="tip">${doc.drafterName} ${doc.drafterPosition} (기안)</span></span>

										<%-- 기안자까지 넣어 동그라미는 4개까지. 5번째부터는 … 로 접는다.
										     상태 판정(metPending)은 접힌 사람도 계속 돌아야 하므로
										     c:choose 는 항상 실행하고 그리는 것만 c:if 로 막는다 --%>
										<c:set var="metPending" value="false" />
										<c:forEach var="a" items="${doc.approvalLine}"
											varStatus="st">
											<c:set var="cls" value="" />
											<c:set var="lbl" value="대기" />
											<c:choose>
												<c:when test="${a.approvalStatus eq 'APPROVED'}">
													<c:set var="cls" value="done" />
													<c:set var="lbl" value="승인" />
												</c:when>
												<c:when test="${a.approvalStatus eq 'REJECTED'}">
													<c:set var="cls" value="reject" />
													<c:set var="lbl" value="반려" />
												</c:when>
												<c:when test="${not metPending}">
													<c:set var="cls" value="now" />
													<c:set var="lbl" value="검토중" />
													<c:set var="metPending" value="true" />
												</c:when>
											</c:choose>
											<c:if test="${st.index lt 3}">
												<span class="appr-dot ${cls}">${fn:substring(a.name, 0, 1)}<span
														class="tip">${a.name} ${a.position} (${lbl})</span></span>
											</c:if>
										</c:forEach>

										<c:if test="${fn:length(doc.approvalLine) gt 3}">
											<span class="appr-more">…<span class="tip">외
													${fn:length(doc.approvalLine) - 3}명</span></span>
										</c:if>
									</div>
								</td>
							</tr>
						</c:forEach>

						<%-- 빈 목록이어도 이유가 둘이다. 문서가 없는 건지,
						     찾는 게 없는 건지 구분해서 말해 줘야 사용자가 헤매지 않는다 --%>
						<c:if test="${empty pendingList}">
							<tr>
								<td colspan="9" class="empty"><span class="big">🗎</span> <c:choose>
										<c:when test="${not empty pageVO.keyword}">'${pageVO.keyword}' 검색 결과가 없습니다.</c:when>
										<c:otherwise>결재할 문서가 없습니다.</c:otherwise>
									</c:choose></td>
							</tr>
						</c:if>

					</tbody>
				</table>
				</div>

				<%-- 페이지 번호 줄. 한 장뿐이면 통째로 안 그린다 --%>
				<c:if test="${pageVO.lastPage > 1}">
					<div class="paging">

						<c:choose>
							<c:when test="${pageVO.page > 1}">
								<a class="arrow"
									href="?page=${pageVO.page - 1}${qs}"
									title="이전">‹</a>
							</c:when>
							<c:otherwise>
								<span class="arrow off">‹</span>
							</c:otherwise>
						</c:choose>

						<c:forEach var="i" begin="1" end="${pageVO.lastPage}">
							<c:choose>
								<c:when test="${i eq pageVO.page}">
									<span class="now">${i}</span>
								</c:when>
								<c:otherwise>
									<a href="?page=${i}${qs}">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>

						<c:choose>
							<c:when test="${pageVO.page < pageVO.lastPage}">
								<a class="arrow"
									href="?page=${pageVO.page + 1}${qs}"
									title="다음">›</a>
							</c:when>
							<c:otherwise>
								<span class="arrow off">›</span>
							</c:otherwise>
						</c:choose>

					</div>
				</c:if>


			</div>
		</div>
	</div>

	<script>
		// 문서 상세 화면으로. 여기서 승인·반려를 한다
		// from : 상세 화면이 '어느 결재함에서 왔는지' 알아야 목록으로 되돌아갈 수 있다
		function openDoc(docId) {
			location.href = "${pageContext.request.contextPath}/document/detail?docId="
					+ docId + "&from=wait";
		}

		// ===== 주소 만들기 =====
		// page·size·keyword·docType·status 다섯 개가 늘 같이 다녀야 한다.
		// 하나라도 빠지면 그 조건만 풀리므로 주소는 여기서만 만든다.
		// 바꾸고 싶은 것만 넘기면 나머지는 지금 값을 그대로 쓴다
		var STATE = {
			size : ${pageVO.size},
			docType : "${pageVO.docType}",
			status : "${pageVO.status}"
		};

		function buildUrl(o) {
			o = o || {};
			var kw = (o.keyword !== undefined) ? o.keyword
					: document.getElementById("q").value.trim();

			return "?page=" + (o.page || 1)
					+ "&size=" + ((o.size !== undefined) ? o.size : STATE.size)
					+ "&keyword=" + encodeURIComponent(kw)
					+ "&docType=" + ((o.docType !== undefined) ? o.docType : STATE.docType)
					+ "&status=" + ((o.status !== undefined) ? o.status : STATE.status);
		}

		// 조건을 바꿀 때는 늘 1페이지로 돌아간다.
		// 5페이지를 보다가 조건을 걸면 그 결과는 1~2장뿐일 수 있어서다
		function setFilter(name, value) {
			var o = {};
			o[name] = value;
			location.href = buildUrl(o);
		}

		// ===== 머리글 필터 목록 열고 닫기 =====
		function toggleMenu(e, id) {
			e.stopPropagation(); // 아래 document 클릭까지 번지면 열자마자 닫힌다
			var m = document.getElementById(id);
			var wasOpen = m.classList.contains("open");
			closeMenus();
			if (!wasOpen) {
				m.classList.add("open");
			}
		}

		function closeMenus() {
			document.querySelectorAll(".col-menu").forEach(function(m) {
				m.classList.remove("open");
			});
		}

		// 딴 데를 누르면 닫힌다
		document.addEventListener("click", closeMenus);

		// ===== 검색 =====
		// 서버가 걸러 온다. 글자 하나마다 물으면 요청이 쏟아지므로
		// 마지막으로 친 뒤 0.4초 조용하면 그때 한 번만 보낸다
		var searchTimer;

		function scheduleSearch() {
			clearTimeout(searchTimer);
			searchTimer = setTimeout(doSearch, 400);
		}

		function doSearch() {
			clearTimeout(searchTimer);
			location.href = buildUrl({});
		}

		function clearSearch() {
			location.href = buildUrl({ keyword : "" });
		}

		function changeSize(size) {
			location.href = buildUrl({ size : size });
		}

		// 검색하면 화면이 새로 뜨면서 입력칸에서 손이 떨어진다.
		// 검색 중이었다면 커서를 글자 끝에 도로 놓아 줘야 이어서 칠 수 있다
		window.onload = function() {
			var q = document.getElementById("q");
			if (q.value !== "") {
				q.focus();
				q.setSelectionRange(q.value.length, q.value.length);
			}
		};



		// 머리글 체크박스로 전체 선택/해제. 일괄결재가 생기면 여기서 골라 넘긴다
		function toggleAll(head) {
			document.querySelectorAll(".row-check").forEach(function(c) {
				c.checked = head.checked;
			});
		}
	</script>

</body>
</html>
