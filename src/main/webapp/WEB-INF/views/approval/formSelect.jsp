<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>eApproval - 결재 양식 선택</title>
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: "Malgun Gothic", "Segoe UI", sans-serif;
}

body {
	background: rgba(28, 42, 71, .45);
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 24px;
}

.modal {
	background: #fff;
	border-radius: 12px;
	width: 1000px;
	max-width: 100%;
	height: 640px;
	display: flex;
	flex-direction: column;
	box-shadow: 0 10px 40px rgba(0, 0, 0, .2);
	overflow: hidden;
}

.modal-head {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 16px 20px;
	border-bottom: 1px solid #e9edf3;
}

.modal-head b {
	font-size: 15px;
	color: #1c2a47;
}

.modal-head .x {
	cursor: pointer;
	color: #999;
	font-size: 18px;
	text-decoration: none;
}

.modal-body {
	flex: 1;
	display: flex;
	min-height: 0;
}

/* 좌측 목록 */
.list-side {
	width: 360px;
	border-right: 1px solid #e9edf3;
	display: flex;
	flex-direction: column;
}

.search {
	margin: 14px 16px 10px;
	position: relative;
}

.search input {
	width: 100%;
	padding: 9px 12px 9px 32px;
	border: 1px solid #dbe1ea;
	border-radius: 8px;
	font-size: 13px;
}

/* 검색 결과가 없을 때 */
.no-form {
	padding: 34px 0;
	text-align: center;
	font-size: 12.5px;
	color: #98a3b5;
}

.search::before {
	content: "🔍";
	position: absolute;
	left: 10px;
	top: 8px;
	font-size: 12px;
}

.forms {
	flex: 1;
	overflow-y: auto;
	padding: 6px 12px 14px;
}

.form-item {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 12px;
	border: 1px solid transparent;
	border-radius: 10px;
	cursor: pointer;
}

.form-item:hover {
	background: #f5f8fd;
}

.form-item.selected {
	background: #eef4ff;
	border-color: #b9d0fb;
}

.form-item .doc-ico {
	color: #7a8aa5;
}

.form-item .t b {
	font-size: 13.5px;
	color: #222;
	display: block;
}

.form-item .t span {
	font-size: 12px;
	color: #98a3b5;
}

.form-item.disabled {
	opacity: .45;
	cursor: not-allowed;
}

.form-item .soon {
	margin-left: auto;
	font-size: 10px;
	background: #eef1f6;
	color: #8a93a3;
	padding: 3px 8px;
	border-radius: 10px;
}

.group-label {
	font-size: 11px;
	color: #98a3b5;
	padding: 10px 14px 4px;
}

/* 우측 상세 */
.detail {
	flex: 1;
	display: flex;
	flex-direction: column;
	min-height: 0;
}

.detail-scroll {
	flex: 1;
	overflow-y: auto;
	padding: 20px 24px;
}

.detail h2 {
	font-size: 17px;
	color: #1c2a47;
}

.detail .desc {
	font-size: 13px;
	color: #888;
	margin: 4px 0 16px;
}

.meta {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 10px;
	margin-bottom: 18px;
}

.meta div {
	background: #f6f8fb;
	border-radius: 8px;
	padding: 12px 14px;
}

.meta label {
	font-size: 11px;
	color: #98a3b5;
	display: block;
	margin-bottom: 4px;
}

.meta b {
	font-size: 13px;
	color: #333;
	font-weight: 600;
}

/* 미리보기 */
.preview {
	background: #f6f8fb;
	border-radius: 10px;
	padding: 20px;
}

.preview h4 {
	font-size: 13px;
	color: #555;
	margin-bottom: 14px;
}

/* ===== 미리보기 =====
   문서 상세보기(documentDetail.jsp)의 '종이'를 그대로 축소한 것이다.
   테두리·칸 나눔·도장판 구성은 같고 글자와 칸 크기만 줄였다.
   실제로 열었을 때 딴 화면이 나오면 미리보기가 아니므로 모양을 맞춘다. */
.paper {
	background: #fff;
	border: 1px solid #d5dbe4;
	border-radius: 4px;
	max-width: 380px;
	margin: 0 auto;
	padding: 20px 18px 22px;
	box-shadow: 0 1px 3px rgba(28, 36, 51, .06);
}

/* 종이 제목. 양식이 있는 문서는 자간을 벌려 결재문서처럼 보이게 한다 */
.paper h5 {
	text-align: center;
	font-size: 14px;
	font-weight: 700;
	color: #1c2433;
	line-height: 1.45;
	margin: 0;
}

.paper h5.form {
	letter-spacing: 6px;
	padding-left: 6px;
}

/* 왼쪽 문서정보 / 오른쪽 도장판 */
.paper-top {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 12px;
	margin: 16px 0 12px;
}

.info-tbl {
	border-collapse: collapse;
	flex: 0 1 auto;
	font-size: 9.5px;
}

.info-tbl th, .info-tbl td {
	border: 1px solid #c9d0da;
	padding: 3px 6px;
	text-align: left;
	line-height: 1.5;
	white-space: nowrap;
}

.info-tbl th {
	width: 48px;
	background: #f2f4f7;
	color: #3d4756;
	font-weight: 600;
}

.info-tbl td {
	color: #8a93a3;
}

/* 도장판. 칸 하나가 사람 한 명 (위=직급, 가운데=도장자리, 아래=처리일) */
.stamp-box {
	display: flex;
	border: 1px solid #8b939f;
	flex: 0 0 auto;
}

.stamp-side {
	width: 13px;
	border-right: 1px solid #8b939f;
	background: #f2f4f7;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 8px;
	color: #3d4756;
	letter-spacing: 2px;
	writing-mode: vertical-rl;
	padding: 3px 0;
}

.stamp-col {
	width: 36px;
	border-right: 1px solid #8b939f;
	text-align: center;
}

.stamp-col:last-child {
	border-right: none;
}

.stamp-col .pos {
	font-size: 8px;
	color: #3d4756;
	padding: 2px 0;
	border-bottom: 1px solid #8b939f;
	background: #fafbfc;
}

.stamp-col .mark {
	height: 28px;
}

.stamp-col .day {
	font-size: 7.5px;
	color: #5b6576;
	padding: 2px 0;
	border-top: 1px solid #8b939f;
	min-height: 9px;
}

/* 제목 줄. 양식 문서는 종이 제목이 양식 이름이라 문서 제목이 따로 한 줄 붙는다 */
.title-tbl {
	width: 100%;
	margin-bottom: -1px;
}

.title-tbl th {
	width: 56px;
	text-align: center;
}

/* 본문 칸 */
.paper-body {
	border: 1px solid #c9d0da;
	padding: 10px 9px;
	min-height: 96px;
}

.paper-body .ph {
	height: 7px;
	background: #edf0f5;
	border-radius: 4px;
	margin-bottom: 7px;
}

/* 하단 버튼 */
.modal-foot {
	border-top: 1px solid #e9edf3;
	padding: 14px 20px;
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

.btn {
	padding: 10px 18px;
	border-radius: 8px;
	font-size: 13px;
	cursor: pointer;
	border: 1px solid #dbe1ea;
	background: #fff;
	color: #444;
	text-decoration: none;
}

.btn.primary {
	background: #2f6bff;
	border-color: #2f6bff;
	color: #fff;
}

.btn.primary:hover {
	background: #2456d6;
}
</style>
</head>
<body>

	<div class="modal">
		<div class="modal-head">
			<b>결재 양식 선택</b> <a class="x" href="#"
				onclick="closeSelf(); return false;">✕</a>
		</div>

		<div class="modal-body">
			<!-- ===== 좌측: 양식 목록 ===== -->
			<div class="list-side">
				<%-- 양식은 다섯 개뿐이고 이미 화면에 다 그려져 있다.
				     서버에 다시 물어볼 게 없으니 그려진 줄을 JS 로 걸러낸다.
				     버튼 없이 타는 즉시(oninput) 걸러진다 --%>
				<div class="search">
					<input type="text" id="formSearch" placeholder="양식 검색..."
						oninput="filterForms()">
				</div>
				<div class="forms">
					<div class="group-label">사용 가능한 양식</div>

					<div class="form-item selected" onclick="pick(this,'free')">
						<span class="doc-ico">📄</span>
						<div class="t">
							<b>자유형식 기안</b><span>일반행정 · 전부서</span>
						</div>
					</div>

					<div class="form-item" onclick="pick(this,'vacation')">
						<span class="doc-ico">📄</span>
						<div class="t">
							<b>연차휴가신청서</b><span>인사/복무 · 전부서</span>
						</div>
					</div>

					<div class="group-label">추가 예정 양식</div>

					<div class="form-item disabled">
						<span class="doc-ico">📄</span>
						<div class="t">
							<b>지출결의서</b><span>재무/회계 · 재무팀</span>
						</div>
						<span class="soon">준비 중</span>
					</div>

					<div class="form-item disabled">
						<span class="doc-ico">📄</span>
						<div class="t">
							<b>출장신청서</b><span>인사/복무 · 전부서</span>
						</div>
						<span class="soon">준비 중</span>
					</div>

					<div class="form-item disabled">
						<span class="doc-ico">📄</span>
						<div class="t">
							<b>업무보고서</b><span>일반행정 · 전부서</span>
						</div>
						<span class="soon">준비 중</span>
					</div>

					<%-- 검색 결과가 하나도 없을 때만 보인다 --%>
					<div class="no-form" id="noForm" style="display: none;">검색 결과가 없습니다.</div>
				</div>
			</div>

			<!-- ===== 우측: 상세 + 미리보기 ===== -->
			<div class="detail">
				<div class="detail-scroll">
					<h2 id="dTitle">자유형식 기안</h2>
					<p class="desc" id="dDesc">에디터로 자유롭게 작성하는 일반 기안 문서</p>

					<div class="meta">
						<div>
							<label>문서 종류</label><b id="dType">일반행정</b>
						</div>
						<div>
							<label>기안 부서</label><b>전부서</b>
						</div>
						<div>
							<label>결재 방식</label><b id="dApproval">순차 / 병렬</b>
						</div>
						<div>
							<label>양식 코드</label><b id="dCode">F001</b>
						</div>
					</div>

					<div class="preview">
						<h4>문서 미리보기</h4>
						<div class="paper">
							<h5 id="pTitle">자유형식 기안</h5>

							<%-- 왼쪽 문서정보 / 오른쪽 도장판. 상세보기와 같은 배치다 --%>
							<div class="paper-top">
								<table class="info-tbl">
									<tr>
										<th>문서번호</th>
										<td id="pNo">-</td>
									</tr>
									<tr>
										<th>기 안 일</th>
										<td id="pDate">-</td>
									</tr>
									<tr>
										<th>기 안 자</th>
										<td>${loginUser.name}</td>
									</tr>
									<tr>
										<th>소　　속</th>
										<td>${loginUser.departmentName} ${loginUser.teamName}</td>
									</tr>
								</table>

								<%-- 도장 자리는 비워 둔다. 아직 아무도 결재하지 않은 문서라
								     실제로 열어도 이 칸은 비어 있다 --%>
								<div class="stamp-box">
									<div class="stamp-side">기안</div>
									<div class="stamp-col">
										<div class="pos">${loginUser.position}</div>
										<div class="mark"></div>
										<div class="day"></div>
									</div>

									<div class="stamp-side">결재</div>
									<div class="stamp-col">
										<div class="pos">팀장</div>
										<div class="mark"></div>
										<div class="day"></div>
									</div>
									<div class="stamp-col">
										<div class="pos">부서장</div>
										<div class="mark"></div>
										<div class="day"></div>
									</div>
								</div>
							</div>

							<%-- 양식이 있는 문서는 종이 제목이 양식 이름이라
							     문서 제목이 한 줄로 따로 붙는다 (기본기안은 안 붙는다) --%>
							<table class="info-tbl title-tbl" id="pTitleRow"
								style="display: none;">
								<tr>
									<th>제　　목</th>
									<td>&nbsp;</td>
								</tr>
							</table>

							<div class="paper-body">
								<div class="ph"></div>
								<div class="ph" style="width: 85%"></div>
								<div class="ph" style="width: 60%"></div>
							</div>
						</div>
					</div>
				</div>

				<div class="modal-foot">
					<a class="btn" href="#" onclick="closeSelf(); return false;">취소</a>
					<a class="btn primary" id="goDraft" href="#"
						onclick="openDraft(); return false;">이 양식으로 기안하기</a>
					<!-- 추후: FREE→기안 작성, VACATION→휴가 신청 화면 -->
				</div>
			</div>
		</div>
	</div>

	<script>
		/* 양식 검색.
		   서버에 다시 묻지 않고 이미 그려진 .form-item 을 보이거나 숨긴다.
		   찾는 글자는 양식 이름과 그 밑의 분류(인사/복무 · 전부서)에서 모두 찾는다.
		   대소문자를 안 가리도록 양쪽을 소문자로 맞춘다. */
		function filterForms() {
			var kw = document.getElementById("formSearch").value.trim().toLowerCase();
			var hit = 0;

			document.querySelectorAll(".forms .form-item").forEach(function(item) {
				var text = item.innerText.toLowerCase();
				var show = (kw === "" || text.indexOf(kw) !== -1);
				item.style.display = show ? "" : "none";
				if (show) { hit++; }
			});

			// 묶음 제목('사용 가능한 양식')은 그 아래 남은 양식이 없으면 같이 숨긴다.
			// 다음 묶음 제목을 만날 때까지의 형제들이 그 묶음에 속한 줄이다.
			document.querySelectorAll(".forms .group-label").forEach(function(label) {
				var any = false;
				var next = label.nextElementSibling;

				while (next && !next.classList.contains("group-label")) {
					if (next.classList.contains("form-item")
							&& next.style.display !== "none") {
						any = true;
					}
					next = next.nextElementSibling;
				}
				label.style.display = any ? "" : "none";
			});

			document.getElementById("noForm").style.display = (hit === 0) ? "" : "none";
		}

		// 양식별 상세 데이터 (지금은 화면 전용, 추후 vacation_type 마스터와 연동 가능)
		var FORMS = {
			free : {
				title : "자유형식 기안",
				desc : "에디터로 자유롭게 작성하는 일반 기안 문서",
				type : "일반행정 ",
				code : "F001",
				approval : "순차 / 병렬"
			},
			vacation : {
				title : "연차휴가신청서",
				desc : "연차·반차 등 휴가 신청 및 결재 요청 양식",
				type : "인사/복무 ",
				code : "V001",
				approval : "순차"
			}
		};
		var currentKey = "free";

		function openDraft() {
			var type = (currentKey === "vacation") ? "VACATION" : "FREE";
			var url = "${pageContext.request.contextPath}/document/write?documentType="
					+ type;

			// 화면 정중앙. screen 은 이 창이 놓인 모니터를 가리키므로 모니터가 여러 대여도 맞다
			var w = 1000, h = 800;
			var sx = (screen.availLeft !== undefined) ? screen.availLeft : 0;
			var sy = (screen.availTop  !== undefined) ? screen.availTop  : 0;
			var left = sx + Math.max(0, Math.round((screen.availWidth  - w) / 2));
			var top  = sy + Math.max(0, Math.round((screen.availHeight - h) / 2));

			window.open(url, "docWrite_" + Date.now(),
					"width=" + w + ",height=" + h
					+ ",left=" + left + ",top=" + top
					+ ",resizable=yes,scrollbars=yes");

			closeSelf(); // 양식 선택 모달은 닫기
		}

		function pick(el, key) {
			document.querySelectorAll(".form-item").forEach(function(i) {
				i.classList.remove("selected");
			});
			el.classList.add("selected");

			// 고른 양식을 기억해둔다. 이 값을 openDraft() 가 읽어서
			// documentType=FREE / VACATION 을 정한다.
			currentKey = key;

			var f = FORMS[key];
			document.getElementById("dTitle").textContent = f.title;
			document.getElementById("dDesc").textContent = f.desc;
			document.getElementById("dType").textContent = f.type;
			document.getElementById("dCode").textContent = f.code;
			document.getElementById("dApproval").textContent = f.approval;
			// 종이 제목. 양식이 있는 문서만 자간을 벌린다 (상세보기와 같은 규칙)
			var pt = document.getElementById("pTitle");
			pt.textContent = f.title;
			pt.className = (key === "free") ? "" : "form";

			// 기본기안은 종이 제목이 곧 문서 제목이라 제목 줄이 필요 없다
			document.getElementById("pTitleRow").style.display =
					(key === "free") ? "none" : "";
		}

		/* 문서번호와 기안일은 저장할 때 서버가 정하는 값이다.
		   미리보기에서는 올해 연도와 오늘 날짜로 모양만 보여 준다.
		   날짜는 상세보기와 같은 2026-08-15 꼴로 맞춘다. */
		(function initPaper() {
			var now = new Date();
			var m = ("0" + (now.getMonth() + 1)).slice(-2);
			var d = ("0" + now.getDate()).slice(-2);

			document.getElementById("pNo").textContent =
					"DOC-" + now.getFullYear() + "-XXXX";
			document.getElementById("pDate").textContent =
					now.getFullYear() + "-" + m + "-" + d;
		})();

		function closeSelf() {
			if (window.parent && window.parent.closeFormModal) {
				window.parent.closeFormModal();
			} else {
				history.back();
			}
		}
	</script>

</body>
</html>