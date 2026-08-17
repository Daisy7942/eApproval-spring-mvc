<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>eApproval - 임시 저장함</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* ===== 이 화면에서만 쓰는 스타일 =====
   레이아웃(헤더/사이드바/메인)은 common.css 에 있다. */

/* 결재함 3종(상신·대기·완료)과 같은 모양으로 맞췄다 */

/* 제목 줄 : 왼쪽 제목, 오른쪽 건수 */
.title-row {
	display: flex;
	align-items: baseline;
	justify-content: space-between;
	margin-bottom: 28px;
}

/* 제목 밑 한 줄 설명. 이 문서함에 뭐가 담기는지 말해 준다 */
.page-desc {
	font-size: 12.5px;
	color: #98a3b5;
	margin: -22px 0 22px;
	line-height: 1.5;
}

.total-count {
	font-size: 12.5px;
	color: #8a93a3;
}

.list-card {
	background: #fff;
}

/* 표 위 도구 줄. 바깥 본문 배경(--bg)과 같은 색이라 흰 표만 도드라진다 */
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

/* 검색 - 도구 줄 왼쪽. 상신 문서함과 같은 모양으로 맞췄다 */
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

.divider {
	width: 1px;
	height: 14px;
	background: #dbe1ea;
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
	top: calc(100% + 8px);
	left: -6px;
	min-width: 140px;
	background: #fff;
	border: 1px solid #e6eaf1;
	border-radius: 10px;
	box-shadow: 0 10px 24px rgba(16, 24, 40, .10), 0 2px 6px rgba(16, 24, 40, .06);
	padding: 5px;
	z-index: 40;
}

.col-menu.open {
	display: block;
}

/* 항목. 왼쪽에 체크 자리를 비워 두고, 고른 것만 그 자리에 ✓ 가 들어온다.
   예전처럼 파랗게 꽉 채우면 목록 안에서 그 줄만 튀어서 시끄럽다 */
.col-menu a {
	display: flex;
	align-items: center;
	gap: 7px;
	padding: 8px 10px 8px 8px;
	font-size: 12.5px;
	font-weight: 400;
	color: #3d4756;
	text-decoration: none;
	border-radius: 7px;
	white-space: nowrap;
}

.col-menu a::before {
	content: "";
	flex: 0 0 auto;
	width: 13px;
	text-align: center;
	font-size: 11px;
	color: transparent;
}

.col-menu a:hover {
	background: #f4f7fd;
	color: #2f6bff;
}

/* 지금 걸려 있는 값 */
.col-menu a.sel {
	color: #2f6bff;
	font-weight: 600;
}

.col-menu a.sel::before {
	content: "✓";
	color: #2f6bff;
}

/* 표 아래 페이지 번호 줄.
   칸마다 테두리를 두르면 표 밑에 또 표가 생긴 것처럼 시끄러워서,
   평소엔 글자만 두고 지금 쪽과 마우스 올린 칸에만 바탕을 깐다 */
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

/* 이전·다음 화살표. 번호와 살짝 떼어 둔다 */
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

.act {
	display: inline-flex;
	align-items: center;
	gap: 7px;
	background: none;
	border: none;
	padding: 0;
	font-size: 13.5px;
	color: #3d4756;
	cursor: pointer;
}

.act:hover {
	color: #2f6bff;
}

.act .ico {
	font-size: 15px;
	color: #8a93a3;
}

.act:hover .ico {
	color: #2f6bff;
}

.opt {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	background: none;
	border: none;
	font-size: 13px;
	color: #3d4756;
	cursor: pointer;
}

.opt:hover {
	color: #2f6bff;
}

.card-head select {
	border: 1px solid #dbe1ea;
	border-radius: 6px;
	padding: 3px 4px;
	font-size: 12px;
	color: #3d4756;
	background: #fff;
}

/* 표 */
.doc-table {
	width: 100%;
	border-collapse: collapse;
	background: #fff;
}

.doc-table thead th {
	text-align: left;
	font-size: 13px;
	color: #5b6576;
	font-weight: 500;
	padding: 12px 14px;
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
	width: 44px;
	text-align: center;
}

.col-check input {
	width: 15px;
	height: 15px;
	cursor: pointer;
	accent-color: #2b3444;
}

td.date {
	color: #3d4756;
	white-space: nowrap;
}

/* 결재 마감일. 기안일 밑에 한 줄 더 붙는다.
   기본이 회색인 건 빨강을 아끼기 위해서다 — 전부 빨가면 눈이 그냥 지나치고,
   회색 사이에 하나만 빨개야 그게 걸린다 */
.due {
	display: block;
	margin-top: 3px;
	font-size: 11.5px;
	color: #8a93a3;
}

/* 3일 안쪽 : 빨강 */
.due.near {
	color: #d64545;
}

/* 바로 오늘 : 가장 급한 줄이라 같은 빨강에 굵게까지 얹는다 */
.due.today {
	color: #d64545;
	font-weight: 700;
}

/* 이미 지남 : 주황. 늦은 건 이미 벌어진 일이라, 아직 손쓸 수 있는
   오늘·임박보다 한 단계 낮춰 눈이 급한 쪽으로 먼저 가게 한다 */
.due.over {
	color: #d99a00;
}

td.form-name {
	color: #2f6bff;
	white-space: nowrap;
}

td.title a {
	color: #2b3444;
	text-decoration: none;
}

td.title a:hover {
	color: #2f6bff;
	text-decoration: underline;
}

/* 제목 없이 임시저장한 문서 */
.no-title {
	color: #9aa3b0;
	font-style: italic;
}

/* 긴급 칸 : 머리글과 ⚠ 를 가운데로.
   앞에 .doc-table 을 붙인 건 위의 thead th / tbody td 규칙보다 세게 만들기 위해서다 */
.doc-table .col-urgent {
	width: 80px;
	text-align: center;
}

/* 긴급 표시 */
.urgent-mark {
	color: #e5484d;
	font-weight: bold;
}

/* 결재상태 칩 */
.chip-draft {
	display: inline-block;
	border: 1px solid #b9d0ff;
	background: #f4f8ff;
	color: #2f6bff;
	font-size: 11.5px;
	border-radius: 4px;
	padding: 2px 8px;
	white-space: nowrap;
}

/* 첨부 아이콘 자리 */
td.attach {
	color: #8a93a3;
	font-size: 12px;
	white-space: nowrap;
}

/* 문서가 하나도 없을 때 */
.empty {
	text-align: center;
	color: #98a3b5;
	padding: 56px 0;
	font-size: 13px;
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

	<%-- 사이드바 '개인 문서함 > 임시 저장함' 이 이 값으로 활성 표시된다 --%>
	<c:set var="menu" value="draft" />
	<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>

	<div class="main">
		<div class="content">

			<%-- 브레드크럼·제목 스타일은 common.css 에 있다 (대시보드와 동일) --%>
			<div class="crumb">
				결재 &gt; <b>임시 저장함</b>
			</div>

			<%-- 페이지를 넘겨도 조건이 유지되도록, 링크에 붙일 값을 한 번만 만들어 둔다 --%>
			<c:set var="qs"
				value="&size=${pageVO.size}&keyword=${pageVO.keyword}&docType=${pageVO.docType}" />

			<div class="page-title title-row">
				<h2>임시 저장함</h2>
				<%-- 화면에 그려진 줄이 아니라 DB 가 센 전체 건수다.
				     한 쪽에 20줄이라 ${fn:length(draftList)} 는 최대 20까지밖에 안 나온다 --%>
				<span class="total-count">${pageVO.total}건</span>
			</div>

			<p class="page-desc">작성 중 보관된 문서입니다.</p>

			<div class="list-card">

				<%-- 왼쪽 검색, 오른쪽 도구.
				     검색은 서버가 한다. 글자를 치고 잠깐 멈추면 알아서 다시 불러온다.
				     양식 이름은 DB 에 VACATION·FREE 로 들어 있어 '휴가'로는 안 잡히므로 제목만 찾는다 --%>
				<div class="card-head">
					<div class="search-box">
						<span class="ico">⌕</span> <input type="text" id="q"
							placeholder="제목 검색" value="${pageVO.keyword}" autocomplete="off"
							oninput="scheduleSearch()"
							onkeydown="if(event.key==='Enter'){doSearch();}">
						<%-- 검색어가 있을 때만 뜨는 지우개. 누르면 검색 없는 목록으로 돌아간다 --%>
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
						<button type="button" class="act" onclick="deleteChecked()">
							<span class="ico">🗑</span> 문서 삭제
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

				<form id="deleteForm"
				action="${pageContext.request.contextPath}/document/delete"
				method="post">
				<table class="doc-table">
					<thead>
						<tr>
							<th class="col-check"><input type="checkbox" id="checkAll"
								onclick="toggleAll(this)"></th>
							<%-- 정렬 표시는 뺐다. 지금은 SQL의 ORDER BY doc_id DESC 로 최신순 고정 --%>
							<th style="width: 130px;">생성일</th>
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
							<th style="width: 110px;">결재상태</th>
						</tr>
					</thead>
					<tbody>

						<c:forEach var="doc" items="${draftList}">

							<%-- 양식 이름은 화면에도 쓰고 검색에도 써서 한 번만 만들어 둔다 --%>
							<c:set var="formName"><c:choose>
									<c:when test="${doc.documentType eq 'VACATION'}">휴가신청서</c:when>
									<c:when test="${doc.documentType eq 'FREE'}">기본기안</c:when>
									<c:otherwise>${doc.documentType}</c:otherwise>
								</c:choose></c:set>

							<tr class="doc-row">
								<td class="col-check"><input type="checkbox" name="docIds"
									class="rowCheck" value="${doc.docId}"></td>

								<%-- LocalDateTime 은 2026-08-06T14:22:31 모양으로 찍힌다. 앞 10글자가 날짜 --%>
								<td class="date">${fn:substring(doc.createdAt, 0, 10)} <%-- 마감일은 선택이라
									고른 문서에만 붙는다. 아직 상신 전이라도 미리 잡아둔 마감이 지나가는 게 보여야
									'이거 빨리 올려야겠다'가 된다 --%>
									<c:if test="${not empty doc.dueDate}">
										<span
											class="due ${doc.overdue ? 'over' : (doc.daysLeft eq 0 ? 'today' : (doc.daysLeft le 3 ? 'near' : ''))}">
											마감 ${doc.dueDate} <c:choose>
												<c:when test="${doc.overdue}">(${doc.daysLeft * -1}일 지남)</c:when>
												<c:when test="${doc.daysLeft eq 0}">(오늘) ★</c:when>
												<c:when test="${doc.daysLeft le 3}">(${doc.daysLeft}일 남음)</c:when>
											</c:choose>
										</span>
									</c:if></td>

								<td class="form-name">${formName}</td>

								<td class="col-urgent"><c:if test="${doc.isUrgent}">
										<span class="urgent-mark" title="긴급">⚠</span>
									</c:if></td>

								<%-- 임시저장은 제목 없이도 저장된다. 제목이 비면 <a> 안에 글자가
									 하나도 없어서 클릭할 자리가 사라지므로 대신 보여줄 말을 넣는다 --%>
								<td class="title"><a href="#"
									onclick="editDraft(${doc.docId}); return false;"><c:choose>
											<c:when test="${empty doc.title}">
												<span class="no-title">(제목 없음)</span>
											</c:when>
											<c:otherwise>${doc.title}</c:otherwise>
										</c:choose></a></td>

								<%-- 첨부파일(attachment) 테이블은 아직 없다 --%>
								<td class="attach"></td>

								<td><span class="chip-draft">임시저장</span></td>
							</tr>
						</c:forEach>

						<%-- 빈 목록이어도 이유가 둘이다. 문서가 없는 건지,
						     찾는 게 없는 건지 구분해서 말해 줘야 사용자가 헤매지 않는다 --%>
						<c:if test="${empty draftList}">
							<tr>
								<td colspan="7" class="empty"><c:choose>
										<c:when test="${not empty pageVO.keyword}">'${pageVO.keyword}' 검색 결과가 없습니다.</c:when>
										<c:otherwise>임시저장한 문서가 없습니다.</c:otherwise>
									</c:choose></td>
							</tr>
						</c:if>

					</tbody>
				</table>
				</form>

				<%-- 페이지 번호 줄.
				     lastPage 는 PageVO 가 전체 건수와 한 쪽 줄 수로 계산해 준 값이다.
				     한 장뿐이면 번호를 그릴 이유가 없어 통째로 안 그린다 --%>
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
		// 머리글 체크박스로 전체 선택/해제.
		// 서버가 걸러서 보내므로 화면에 있는 줄이 곧 지금 쪽의 전부다
		function toggleAll(head) {
			var rows = document.querySelectorAll(".rowCheck");
			for (var i = 0; i < rows.length; i++) {
				rows[i].checked = head.checked;
			}
		}

		// 체크된 문서번호 모으기
		function getCheckedIds() {
			var ids = [];
			var rows = document.querySelectorAll(".rowCheck");
			for (var i = 0; i < rows.length; i++) {
				if (rows[i].checked) {
					ids.push(rows[i].value);
				}
			}
			return ids;
		}

		function deleteChecked() {
			var ids = getCheckedIds();
			if (ids.length === 0) {
				alert("삭제할 문서를 선택해 주세요.");
				return;
			}
			if (!confirm(ids.length + "건을 삭제하시겠습니까?")) {
				return;
			}
			document.getElementById("deleteForm").submit();
		}

		function editDraft(docId) {
			var url = "${pageContext.request.contextPath}/document/write?docId="+docId;

			// 화면 정중앙. screen 은 이 창이 놓인 모니터를 가리키므로 모니터가 여러 대여도 맞다
			var w = 1000, h = 800;
			var sx = (screen.availLeft !== undefined) ? screen.availLeft : 0;
			var sy = (screen.availTop  !== undefined) ? screen.availTop  : 0;
			var left = sx + Math.max(0, Math.round((screen.availWidth  - w) / 2));
			var top  = sy + Math.max(0, Math.round((screen.availHeight - h) / 2));

			window.open(url, "docWrite_" + docId,
					"width=" + w + ",height=" + h
					+ ",left=" + left + ",top=" + top
					+ ",resizable=yes,scrollbars=yes");

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


		// 한 쪽 줄 수 바꾸기.
		// 반드시 1페이지로 돌아간다 — 5페이지를 보다가 100줄로 바꾸면
		// 그 문서들이 1페이지 안으로 들어와 5페이지는 아예 없는 쪽이 된다
		// 검색어는 입력칸에서 읽는다. EL 을 JS 문자열에 직접 박으면
		// 제목에 따옴표가 섞였을 때 스크립트가 깨진다
		function changeSize(size) {
			var q = document.getElementById("q").value.trim();
			location.href = "?page=1&size=" + size
					+ "&keyword=" + encodeURIComponent(q);
		}

	</script>

</body>
</html>