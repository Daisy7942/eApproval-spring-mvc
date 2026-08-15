<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>eApproval - 완료 문서함</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* ===== 결재함 3종(상신·대기·완료) 공통 모양 =====
   대기함(pendingList.jsp)과 같은 스타일이다. 여기 담기는 건
   '내가 결재한 문서'라 일괄결재가 없다. */

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

/* 검색 - 도구 줄 왼쪽 */
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

/* ===== 표 ===== */
.doc-table {
	width: 100%;
	border-collapse: collapse;
}

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

/* 상태 칩 - 문서 전체 상태(document.status) */
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
   아래에 흰 말풍선으로 "이름 직급 (상태)" 가 뜬다 */
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

	<%-- 사이드바 '개인 문서함 > 완료 문서함' 이 이 값으로 활성 표시된다 --%>
	<c:set var="menu" value="apprDone" />
	<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>

	<div class="main">
		<div class="content">

			<div class="crumb">
				결재 &gt; <b>완료 문서함</b>
			</div>

			<div class="page-title title-row">
				<h2>완료 문서함</h2>
				<span class="total-count">${fn:length(completedList)}건</span>
			</div>

			<div class="list-card">

				<%-- 왼쪽 검색, 오른쪽 도구.
				     검색은 버튼 없이 글자를 칠 때마다 걸러낸다 (oninput).
				     목록 다운로드용 체크박스만 있고 일괄결재는 없다 --%>
				<div class="card-head">
					<div class="search-box">
						<span class="ico">⌕</span> <input type="text" id="q"
							placeholder="제목 · 기안자 검색" oninput="applyFilter()">
					</div>

					<div class="right">
						<button type="button" class="act soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							<span class="ico">⭳</span> 목록 다운로드
						</button>
						<span class="divider"></span>
						<button type="button" class="act soon" aria-disabled="true"
							data-tip="추후 구현 예정">
							<span class="ico">⚙</span> 필드 설정
						</button>
						<span class="soon" data-tip="추후 구현 예정">
							<select disabled>
							<option>20</option>
							<option>50</option>
							<option>100</option>
						</select>
						</span>
					</div>
				</div>

				<table class="doc-table">
					<thead>
						<tr>
							<th class="col-check"><input type="checkbox"
								onclick="toggleAll(this)"></th>
							<th style="width: 150px;">결재양식</th>
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

						<%-- data-text 는 화면에서 걸러낼 때 쓰는 값이다 --%>
						<c:forEach var="doc" items="${completedList}">
							<tr class="doc-row"
								data-text="${fn:toLowerCase(doc.title)} ${fn:toLowerCase(doc.drafterName)}">
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

								<%-- 주의 : 상태 칸은 내 결재 결과가 아니라 '문서 전체' 상태다.
								     내가 승인했어도 뒷 결재자가 남아 있으면 문서는 아직 PENDING 이다 --%>
								<td class="title"><a href="#"
									onclick="openDoc(${doc.docId}); return false;">${doc.title}</a></td>

								<%-- 첨부파일 업로드 기능이 아직 없다 --%>
								<td class="attach"></td>

								<td class="drafter">${doc.drafterName}<span>${doc.drafterTeam}</span></td>

								<%-- LocalDateTime 은 2026-08-06T14:22:31 모양으로 찍힌다. 앞 10글자가 날짜 --%>
								<td class="date">${fn:substring(doc.createdAt, 0, 10)}</td>

								<td><c:choose>
										<c:when test="${doc.status eq 'PENDING'}">
											<span class="chip chip-pending">결재중</span>
										</c:when>
										<c:when test="${doc.status eq 'APPROVED'}">
											<span class="chip chip-approved">승인</span>
										</c:when>
										<c:when test="${doc.status eq 'REJECTED'}">
											<span class="chip chip-rejected">반려</span>
										</c:when>
										<c:otherwise>
											<span class="chip chip-pending">${doc.status}</span>
										</c:otherwise>
									</c:choose></td>

								<%-- 결재선. 순서대로 훑다가 처음 만나는 PENDING 이 '검토중'(주황),
								     그 뒤에 남은 PENDING 은 전부 '대기'(회색)다 --%>
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

						<c:if test="${empty completedList}">
							<tr>
								<td colspan="9" class="empty"><span class="big">🗎</span>완료한
									문서가 없습니다.</td>
							</tr>
						</c:if>

						<%-- 검색으로 다 걸러졌을 때만 JS 가 이 줄을 보여준다 --%>
						<tr id="noResult" style="display: none;">
							<td colspan="9" class="empty"><span class="big">🗎</span>검색
								결과가 없습니다.</td>
						</tr>

					</tbody>
				</table>

				<%-- 페이지네이션 자리. 아직 안 만들었다 (SQL LIMIT / OFFSET 필요) --%>

			</div>
		</div>
	</div>

	<script>
		// 문서 상세 화면으로. 이미 내가 결재한 문서다
		// from : 상세 화면이 '어느 결재함에서 왔는지' 알아야 목록으로 되돌아갈 수 있다
		function openDoc(docId) {
			location.href = "${pageContext.request.contextPath}/document/detail?docId="
					+ docId + "&from=done";
		}

		// ===== 아직 서버에 만들지 않은 기능 =====


		// 머리글 체크박스로 전체 선택/해제. 목록 다운로드가 생기면 여기서 골라 넘긴다
		function toggleAll(head) {
			document.querySelectorAll(".row-check").forEach(function(c) {
				c.checked = head.checked;
			});
		}

		// ===== 검색 =====
		// 서버에 다시 묻지 않고, 이미 화면에 그려진 줄만 보였다 숨겼다 한다.
		// 한계: 화면에 올라온 것만 걸러진다.
		function applyFilter() {
			var q = document.getElementById("q").value.trim().toLowerCase();
			var rows = document.querySelectorAll(".doc-row");
			var shown = 0;

			rows.forEach(function(tr) {
				if (q === "" || tr.dataset.text.indexOf(q) > -1) {
					tr.style.display = "";
					shown++;
				} else {
					tr.style.display = "none";
				}
			});

			document.getElementById("noResult").style.display = (shown === 0 && rows.length > 0)
					? "" : "none";
		}
	</script>

</body>
</html>
