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

/* [제목 ▾]  [입력칸 🔍]  — 앞의 선택칸은 살짝 띄운다 */
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

/* 입력칸 + 돋보기 버튼을 한 덩어리로 */
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

/* 오른쪽 도구 : 다운로드 / 삭제 / 필드 설정 / 표시 개수 */
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

			<div class="page-title">
				<h2>임시 저장함</h2>
			</div>

			<%-- 표 위 오른쪽 도구 줄. 서버 기능은 아직 없다 --%>
			<div class="list-bar">
				<div class="tool-bar">
					<button type="button" class="act soon" aria-disabled="true"
						data-tip="추후 구현 예정">
						<span class="ico">⭳</span> 목록 다운로드
					</button>
					<button type="button" class="act" onclick="deleteChecked()">
						<span class="ico">🗑</span> 문서 삭제
					</button>

					<span class="divider"></span>

					<button type="button" class="opt soon" aria-disabled="true"
						data-tip="추후 구현 예정">
						<span>⚙</span> 필드 설정
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
							<th style="width: 150px;">결재양식</th>
							<th class="col-urgent">긴급</th>
							<th>제목</th>
							<th style="width: 80px;">첨부</th>
							<th style="width: 110px;">결재상태</th>
						</tr>
					</thead>
					<tbody>

						<c:forEach var="doc" items="${draftList}">
							<tr>
								<td class="col-check"><input type="checkbox" name="docIds"
									class="rowCheck" value="${doc.docId}"></td>

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

						<c:if test="${empty draftList}">
							<tr>
								<td colspan="7" class="empty">임시저장한 문서가 없습니다.</td>
							</tr>
						</c:if>

					</tbody>
				</table>
			</form>

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
		// 머리글 체크박스로 전체 선택/해제
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
		

		function doSearch() {
			alert("검색은 아직 준비 중입니다.");
		}

	</script>

</body>
</html>