<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결재자 선택</title>
<style>
* { box-sizing:border-box; }
body { margin:0; background:#f4f6fa; font-family:"맑은 고딕",sans-serif;
       padding:18px; }

.head { display:flex; justify-content:space-between; align-items:center;
        padding-bottom:12px; }
.head b { font-size:15px; color:#1c2a47; }
.head .x { cursor:pointer; color:#999; font-size:17px; text-decoration:none; }

.box { background:#fff; border-radius:10px; padding:16px;
       box-shadow:0 2px 12px rgba(0,0,0,.06); }

/* 검색 줄 */
.search { display:flex; gap:8px; margin-bottom:14px; }
.search input { flex:1; height:34px; border:1px solid #dbe1ea; border-radius:8px;
                padding:0 10px; font-size:13px; color:#2b3444; }
.search input:focus { outline:none; border-color:#2f6bff; }
.search button { height:34px; padding:0 16px; border:none; border-radius:8px;
                 background:#2f6bff; color:#fff; font-size:13px; cursor:pointer; }
.search button:hover { background:#1f57e0; }

/* 결과 표 */
.emp-table { width:100%; border-collapse:collapse; }
.emp-table thead th { text-align:left; font-size:12.5px; color:#5b6576;
                      font-weight:500; padding:9px 10px;
                      border-top:1px solid #d9dee7; border-bottom:1px solid #d9dee7;
                      white-space:nowrap; }
.emp-table tbody td { padding:9px 10px; border-bottom:1px solid #eef1f5;
                      font-size:13px; color:#2b3444; }
.emp-table tbody tr:hover { background:#f8fafd; }
.emp-table .col-check { width:40px; text-align:center; }
.emp-table .col-check input { width:15px; height:15px; cursor:pointer;
                              accent-color:#2b3444; }

/* 결과가 없을 때 / 아직 검색 전 */
.empty { text-align:center; color:#98a3b5; padding:44px 0; font-size:13px; }

/* 아래 버튼 줄 */
.foot { display:flex; justify-content:flex-end; gap:8px; padding-top:14px; }
.btn { height:34px; padding:0 18px; border:1px solid #dbe1ea; border-radius:8px;
       background:#fff; color:#3d4756; font-size:13px; cursor:pointer;
       display:inline-flex; align-items:center; text-decoration:none; }
.btn:hover { border-color:#cfd6e0; }
.btn.primary { background:#2f6bff; border-color:#2f6bff; color:#fff; }
.btn.primary:hover { background:#1f57e0; }
</style>
</head>
<body>

	<div class="head">
		<b>결재자 선택</b>
		<a class="x" href="#" onclick="window.close(); return false;">✕</a>
	</div>

	<div class="box">

		<%-- 검색은 평범한 GET 폼이다. 주소창에 ?keyword=김 이 남는다 --%>
		<form class="search" method="get"
			action="${pageContext.request.contextPath}/employee/search">
			<input type="text" name="keyword" value="${param.keyword}"
				placeholder="이름을 입력하세요" autofocus>
			<button type="submit">검색</button>
		</form>

		<table class="emp-table">
			<thead>
				<tr>
					<th class="col-check"></th>
					<th style="width: 110px;">사원번호</th>
					<th>이름</th>
					<th style="width: 200px;">이메일</th>
				</tr>
			</thead>
			<tbody>

				<c:forEach var="emp" items="${empList}">
					<tr>
						<%-- data-* 는 브라우저가 무시하는 내 마음대로 붙이는 칸이다.
						     선택 완료를 누를 때 JS 가 여기서 값을 꺼내 쓴다 --%>
						<td class="col-check"><input type="checkbox" class="empCheck"
							value="${emp.employeeId}" data-name="${emp.name}"></td>
						<td>${emp.employeeCode}</td>
						<td>${emp.name}</td>
						<td>${emp.email}</td>
					</tr>
				</c:forEach>

				<%-- 아직 검색 전인 경우와, 검색했는데 없는 경우를 나눠서 보여준다 --%>
				<c:if test="${empty empList}">
					<tr>
						<td colspan="4" class="empty"><c:choose>
								<c:when test="${empty param.keyword}">이름을 입력해 검색하세요.</c:when>
								<c:otherwise>'${param.keyword}' 로 찾은 사원이 없습니다.</c:otherwise>
							</c:choose></td>
					</tr>
				</c:if>

			</tbody>
		</table>

		<div class="foot">
			<a class="btn" href="#" onclick="window.close(); return false;">취소</a>
			<button type="button" class="btn primary" onclick="pickChecked()">선택
				완료</button>
		</div>

	</div>

	<script>
		// 체크된 사원을 [{id, name}, ...] 로 모은다
		function getChecked() {
			var picked = [];
			var rows = document.querySelectorAll(".empCheck");
			for (var i = 0; i < rows.length; i++) {
				if (rows[i].checked) {
					picked.push({
						id : rows[i].value,
						name : rows[i].getAttribute("data-name")
					});
				}
			}
			return picked;
		}

		// 나를 열어준 창(기안 작성)에 넘겨주고 닫는다.
		// 넘겨받는 쪽은 addApprovers(list) 라는 함수를 갖고 있어야 한다.
		function pickChecked() {
			var picked = getChecked();
			if (picked.length === 0) {
				alert("결재자를 선택해 주세요.");
				return;
			}
			if (window.opener && !window.opener.closed
					&& window.opener.addApprovers) {
				window.opener.addApprovers(picked);
				window.close();
			} else {
				alert("기안 작성 창을 찾을 수 없습니다.");
			}
		}
	</script>

</body>
</html>
