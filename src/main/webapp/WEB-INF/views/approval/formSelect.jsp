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

.paper {
	background: #fff;
	border: 1px solid #e3e7ef;
	border-radius: 8px;
	max-width: 380px;
	margin: 0 auto;
	padding: 22px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, .05);
}

.paper h5 {
	text-align: center;
	font-size: 15px;
	color: #222;
	margin-bottom: 4px;
}

.paper .no {
	text-align: center;
	font-size: 11px;
	color: #a5aebd;
	margin-bottom: 14px;
}

.fld {
	border: 1px solid #e6eaf1;
	border-radius: 6px;
	padding: 8px 10px;
	margin-bottom: 8px;
}

.fld label {
	font-size: 10px;
	color: #a5aebd;
	display: block;
}

.fld .ph {
	height: 8px;
	background: #edf0f5;
	border-radius: 4px;
	margin-top: 5px;
}

.sign-row {
	display: flex;
	gap: 8px;
	justify-content: flex-end;
	margin-top: 12px;
}

.sign {
	width: 52px;
	height: 52px;
	border: 1px solid #e0e5ec;
	border-radius: 4px;
	font-size: 10px;
	color: #a5aebd;
	display: flex;
	align-items: flex-start;
	justify-content: center;
	padding-top: 4px;
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
				<div class="search">
					<input type="text" placeholder="양식 검색...">
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
				</div>
			</div>

			<!-- ===== 우측: 상세 + 미리보기 ===== -->
			<div class="detail">
				<div class="detail-scroll">
					<h2 id="dTitle">자유형식 기안</h2>
					<p class="desc" id="dDesc">에디터로 자유롭게 작성하는 일반 기안 문서</p>

					<div class="meta">
						<div>
							<label>문서 종류</label><b id="dType">일반행정 (FREE)</b>
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
							<div class="no" id="pNo">문서번호: F001-XXXX</div>
							<div class="fld">
								<label>제목</label>
								<div class="ph" style="width: 70%"></div>
							</div>
							<div class="fld" id="pBody">
								<label>내용</label>
								<div class="ph"></div>
								<div class="ph" style="width: 85%"></div>
								<div class="ph" style="width: 60%"></div>
							</div>
							<div class="sign-row">
								<div class="sign">기안</div>
								<div class="sign">팀장</div>
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
		// 양식별 상세 데이터 (지금은 화면 전용, 추후 vacation_type 마스터와 연동 가능)
		var FORMS = {
			free : {
				title : "자유형식 기안",
				desc : "에디터로 자유롭게 작성하는 일반 기안 문서",
				type : "일반행정 (FREE)",
				code : "F001",
				approval : "순차 / 병렬"
			},
			vacation : {
				title : "연차휴가신청서",
				desc : "연차·반차 등 휴가 신청 및 결재 요청 양식",
				type : "인사/복무 (VACATION)",
				code : "V001",
				approval : "순차 / 병렬"
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
			var f = FORMS[key];
			document.getElementById("dTitle").textContent = f.title;
			document.getElementById("dDesc").textContent = f.desc;
			document.getElementById("dType").textContent = f.type;
			document.getElementById("dCode").textContent = f.code;
			document.getElementById("dApproval").textContent = f.approval;
			document.getElementById("pTitle").textContent = f.title;
			document.getElementById("pNo").textContent = "문서번호: " + f.code
					+ "-XXXX";
		}

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