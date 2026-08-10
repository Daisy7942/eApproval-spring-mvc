<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>eApproval - 상신 문서</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* ===== 이 화면에서만 쓰는 스타일 =====
   레이아웃(헤더/사이드바/메인)은 common.css 에 있다.
   임시저장함(draftList.jsp)과 거의 같다. 다른 점은 아래 두 가지다.
   1) 체크박스 / 삭제 도구가 없다 — 이미 상신한 문서는 지울 수 없다.
   2) 결재상태 칩이 세 가지다 (진행중 / 승인 / 반려). */

/* 표 위 한 줄 : 오른쪽 도구 */
.list-bar {
	display: flex;
	align-items: center;
	gap: 16px;
	padding: 2px 0 12px;
}

/* 목록 아래 가운데 검색창 */
.search-bottom {
	display: flex;
	justify-content: center;
	padding: 22px 0 8px;
}

/* [제목 ▾]  [입력칸 🔍] */
.search {
	display: flex;
	align-items: stretch;
	gap: 8px;
	height: 32px;
}

.search select {
	border: 1px solid #dbe1ea;
	border-radius: 8px;
	background: #fff;
	font-size: 12.5px;
	color: #3d4756;
	padding: 0 8px;
	cursor: pointer;
}

.search select:focus {
	outline: none;
	border-color: #2f6bff;
}

.search .field {
	display: flex;
	align-items: center;
	border: 1px solid #dbe1ea;
	border-radius: 8px;
	background: #fff;
	padding-right: 3px;
	transition: border-color .15s;
}

.search .field:focus-within {
	border-color: #2f6bff;
}

.search input {
	width: 170px;
	border: none;
	background: none;
	padding: 0 10px;
	font-size: 12.5px;
	color: #2b3444;
}

.search input::placeholder {
	color: #aab2be;
}

.search input:focus {
	outline: none;
}

.search .go {
	width: 26px;
	height: 26px;
	border: none;
	border-radius: 6px;
	background: #2f6bff;
	color: #fff;
	font-size: 12px;
	line-height: 1;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
}

.search .go:hover {
	background: #1f57e0;
}

/* 오른쪽 도구 : 다운로드 / 필드 설정 / 표시 개수 */
.tool-bar {
	display: flex;
	justify-content: flex-end;
	align-items: center;
	gap: 18px;
	margin-left: auto;
}

.tool-bar .divider {
	width: 1px;
	height: 14px;
	background: #dbe1ea;
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

.tool-bar select {
	border: 1px solid #dbe1ea;
	border-radius: 6px;
	padding: 5px 8px;
	font-size: 13px;
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
	padding: 13px 14px;
	border-bottom: 1px solid #eef1f5;
	font-size: 13.5px;
	color: #2b3444;
	vertical-align: middle;
}

.doc-table tbody tr:hover {
	background: #f8fafd;
}

td.date {
	color: #3d4756;
	white-space: nowrap;
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

/* 긴급 칸 : 머리글과 ⚠ 를 가운데로 */
.doc-table .col-urgent {
	width: 80px;
	text-align: center;
}

.urgent-mark {
	color: #e5484d;
	font-weight: bold;
}

/* 결재상태 칩 — 색만 다르고 모양은 같아서 공통 부분을 .chip 으로 뺐다 */
.chip {
	display: inline-block;
	border: 1px solid;
	font-size: 11.5px;
	border-radius: 4px;
	padding: 2px 8px;
	white-space: nowrap;
}

.chip-pending {
	border-color: #ffd9a8;
	background: #fff8ef;
	color: #c26a12;
}

.chip-approved {
	border-color: #b6e3c6;
	background: #f2fbf5;
	color: #1e8e4a;
}

.chip-rejected {
	border-color: #f7c2c4;
	background: #fef4f4;
	color: #d1383d;
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
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<%-- 사이드바 '결재함 > 상신 문서' 가 이 값으로 활성 표시된다 --%>
	<c:set var="menu" value="apprSent" />
	<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>

	<div class="main">
		<div class="content">

			<div class="crumb">
				결재 &gt; <b>상신 문서</b>
			</div>

			<div class="page-title">
				<h2>상신 문서</h2>
			</div>

			<%-- 표 위 오른쪽 도구 줄. 서버 기능은 아직 없다.
			     임시저장함에 있던 '문서 삭제' 는 여기 없다 — 상신한 문서는 지울 수 없다. --%>
			<div class="list-bar">
				<div class="tool-bar">
					<button type="button" class="act" onclick="downloadList()">
						<span class="ico">⭳</span> 목록 다운로드
					</button>

					<span class="divider"></span>

					<button type="button" class="opt"
						onclick="alert('필드 설정은 아직 준비 중입니다.');">
						<span>⚙</span> 필드 설정
					</button>
					<select onchange="alert('페이지 나누기는 아직 준비 중입니다.');">
						<option>20</option>
						<option>50</option>
						<option>100</option>
					</select>
				</div>
			</div>

			<%-- 체크박스가 없으므로 form 으로 감쌀 필요도 없다 --%>
			<table class="doc-table">
				<thead>
					<tr>
						<th style="width: 130px;">상신일</th>
						<th style="width: 150px;">결재양식</th>
						<th class="col-urgent">긴급</th>
						<th>제목</th>
						<th style="width: 80px;">첨부</th>
						<th style="width: 110px;">결재상태</th>
					</tr>
				</thead>
				<tbody>

					<c:forEach var="doc" items="${submittedList}">
						<tr>
							<%-- LocalDateTime 은 2026-08-06T14:22:31 모양으로 찍힌다. 앞 10글자가 날짜 --%>
							<td class="date">${fn:substring(doc.createdAt, 0, 10)}</td>

							<td class="form-name"><c:choose>
									<c:when test="${doc.documentType eq 'VACATION'}">휴가신청서</c:when>
									<c:when test="${doc.documentType eq 'FREE'}">기본기안</c:when>
									<c:otherwise>${doc.documentType}</c:otherwise>
								</c:choose></td>

							<td class="col-urgent"><c:if test="${doc.isUrgent}">
									<span class="urgent-mark" title="긴급">⚠</span>
								</c:if></td>

							<%-- 상신한 문서는 수정할 수 없다. 읽기 전용 상세 화면은 아직 없다 --%>
							<td class="title"><a href="#"
								onclick="openDoc(${doc.docId}); return false;">${doc.title}</a></td>

							<%-- 첨부파일(attachment) 테이블은 아직 없다 --%>
							<td class="attach"></td>

							<td><c:choose>
									<c:when test="${doc.status eq 'PENDING'}">
										<span class="chip chip-pending">결재 진행중</span>
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
						</tr>
					</c:forEach>

					<c:if test="${empty submittedList}">
						<tr>
							<td colspan="6" class="empty">상신한 문서가 없습니다.</td>
						</tr>
					</c:if>

				</tbody>
			</table>

			<%-- 페이지네이션 자리. 아직 안 만들었다 (SQL LIMIT / OFFSET 필요) --%>

			<%-- 목록 아래 가운데 검색창 --%>
			<div class="search-bottom">
				<div class="search">
					<select>
						<option>제목</option>
						<option>내용</option>
					</select>
					<div class="field">
						<input type="text" placeholder="검색어를 입력하세요"
							onkeydown="if(event.key==='Enter'){doSearch();}">
						<button type="button" class="go" onclick="doSearch()">🔍</button>
					</div>
				</div>
			</div>

		</div>
	</div>

	<script>
		// ===== 아래는 아직 서버에 만들지 않은 기능이다 =====
		function openDoc(docId) {
			alert("문서 상세 보기는 아직 준비 중입니다.");
		}

		function downloadList() {
			alert("목록 다운로드는 아직 준비 중입니다.");
		}

		function doSearch() {
			alert("검색은 아직 준비 중입니다.");
		}
	</script>

</body>
</html>
