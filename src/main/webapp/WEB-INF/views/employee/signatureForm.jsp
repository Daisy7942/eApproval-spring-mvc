<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>eApproval - 서명 등록</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* ===== 서명 관리 =====
   카드 두 장으로 끝난다.
   위  : 새 서명 만들기 (직접 그리기 / 이미지 올리기 중 하나)
   아래: 등록해 둔 서명 목록. 이 중 하나가 대표 서명이 된다. */
.title-row {
	display: flex;
	align-items: baseline;
	justify-content: space-between;
	margin-bottom: 20px;
}

.title-row .hint {
	font-size: 12.5px;
	color: #8a93a3;
}

.card {
	background: #fff;
	border: 1px solid #e3e7ef;
	border-radius: 10px;
	margin-bottom: 16px;
}

.card-head {
	padding: 18px 22px 14px;
	border-bottom: 1px solid #f0f3f8;
}

.card-head h3 {
	font-size: 15px;
	color: var(--ink);
	font-weight: 600;
}

.card-head p {
	font-size: 12px;
	color: #98a3b5;
	margin-top: 5px;
	line-height: 1.6;
}

.card-body {
	padding: 20px 22px 22px;
}

/* ===== 탭 (결재선 화면과 같은 모양을 쓴다) ===== */
.tabs {
	display: flex;
	gap: 18px;
	padding: 0 22px;
	border-bottom: 1px solid #eceff3;
}

.tabs .tab {
	padding: 12px 2px 10px;
	font-size: 13px;
	color: #9aa3b0;
	cursor: pointer;
	border-bottom: 2px solid transparent;
	user-select: none;
}

.tabs .tab.on {
	color: #2b3444;
	font-weight: 700;
	border-bottom-color: #2b3444;
}

/* 탭 하나만 보이고 나머지는 숨는다 */
.pane {
	display: none;
}

.pane.on {
	display: block;
}

/* ===== 그리는 판 =====
   canvas 는 CSS 로 크기를 바꾸면 그림이 늘어난다.
   그래서 width/height 속성값 그대로 두고 CSS 로는 손대지 않는다. */
.pad-wrap {
	display: flex;
	gap: 20px;
	align-items: flex-start;
	flex-wrap: wrap;
}

.pad {
	border: 1px dashed #c7d0de;
	border-radius: 8px;
	background: #fff;
	position: relative;
	width: 420px;
	height: 170px;
}

.pad canvas {
	display: block;
	cursor: crosshair;
	touch-action: none;
}

/* 아직 아무것도 안 그렸을 때만 보이는 안내.
   클릭은 캔버스가 받아야 하므로 마우스를 통과시킨다 */
.pad .guide {
	position: absolute;
	left: 0;
	right: 0;
	top: 50%;
	transform: translateY(-50%);
	text-align: center;
	font-size: 13px;
	color: #c2cbd9;
	pointer-events: none;
}

/* 종이 서명란 느낌을 주는 밑줄 */
.pad .baseline {
	position: absolute;
	left: 30px;
	right: 30px;
	bottom: 34px;
	border-bottom: 1px solid #eef2f7;
	pointer-events: none;
}

.pad-side {
	flex: 1;
	min-width: 220px;
	font-size: 12.5px;
	color: #7b869a;
	line-height: 1.9;
}

.pad-side b {
	color: var(--ink);
	font-size: 13px;
	display: block;
	margin-bottom: 6px;
}

.pen-row {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-top: 14px;
}

.pen-row span {
	font-size: 12.5px;
	color: #7b869a;
}

.pen {
	width: 26px;
	height: 26px;
	border: 1px solid #dfe5ee;
	border-radius: 6px;
	background: #fff;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
}

.pen.on {
	border-color: #2b3444;
	background: #f4f6fa;
}

.pen i {
	display: block;
	background: #2b3444;
	border-radius: 50%;
}

/* ===== 이미지 올리기 ===== */
.drop {
	border: 1px dashed #c7d0de;
	border-radius: 8px;
	width: 420px;
	height: 170px;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	gap: 10px;
	color: #b3bccb;
	font-size: 13px;
	background: #fcfdff;
	cursor: pointer;
}

.drop img {
	max-width: 90%;
	max-height: 80%;
}

.drop .big {
	font-size: 26px;
}

/* ===== 버튼 ===== */
.btns {
	display: flex;
	gap: 8px;
	margin-top: 16px;
}

.btn {
	height: 34px;
	padding: 0 16px;
	border: 1px solid #dfe5ee;
	border-radius: 6px;
	background: #fff;
	color: #46536b;
	font-size: 13px;
	cursor: pointer;
}

.btn:hover {
	background: #f6f8fc;
}

.btn.primary {
	background: var(--blue);
	border-color: var(--blue);
	color: #fff;
	font-weight: 600;
}

.btn.primary:hover {
	background: var(--blue-dark);
}

/* ===== 등록해 둔 서명 ===== */
.sig-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
	gap: 14px;
}

/* 칸 전체가 라디오다. 작은 동그라미만 누르게 하면 고르기 불편하기 때문 */
.sig-item {
	border: 1px solid #e3e7ef;
	border-radius: 9px;
	padding: 12px;
	cursor: pointer;
	position: relative;
	background: #fff;
}

.sig-item:hover {
	border-color: #c3d0e6;
}

.sig-item.on {
	border-color: var(--blue);
	box-shadow: 0 0 0 2px rgba(47, 107, 255, .12);
}

.sig-item input {
	position: absolute;
	opacity: 0;
}

.sig-item .thumb {
	height: 92px;
	display: flex;
	align-items: center;
	justify-content: center;
	background: #fbfcfe;
	border-radius: 6px;
	margin-bottom: 10px;
}

.sig-item .thumb img {
	max-width: 92%;
	max-height: 82px;
}

.sig-item .meta {
	display: flex;
	align-items: center;
	font-size: 11.5px;
	color: #97a1b2;
}

.sig-item .meta .del {
	margin-left: auto;
	color: #b9c2d0;
	cursor: pointer;
}

.sig-item .meta .del:hover {
	color: var(--red);
}

/* 대표 서명 표시 */
.sig-item .badge {
	position: absolute;
	top: 10px;
	right: 10px;
	background: var(--blue);
	color: #fff;
	font-size: 10.5px;
	padding: 2px 7px;
	border-radius: 10px;
	display: none;
}

.sig-item.on .badge {
	display: block;
}

/* 서버가 되돌려 보낸 알림 한 줄 (개수 초과 등) */
.notice {
	background: #fff8e6;
	border: 1px solid #f5e3b3;
	color: #8a6d1f;
	font-size: 12.5px;
	border-radius: 8px;
	padding: 10px 14px;
	margin-bottom: 16px;
}

/* 기본 도장 칸. 문서 도장판(documentDetail.jsp) 과 같은 모양을 그대로 가져온다 --
   여기서 고른 모습이 문서에 그대로 찍혀야 하기 때문 */
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

</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<%-- 사이드바가 아니라 헤더 프로필 메뉴로 들어오는 화면이라 활성 메뉴가 없다 --%>
	<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>

	<div class="main">
		<div class="content">

			<div class="crumb">
				내 정보 &gt; <b>서명 등록</b>
			</div>

			<div class="page-title title-row">
				<h2>서명 등록</h2>
				<span class="hint">대표 서명이 결재할 때 도장 자리에 찍힙니다 · ${fn:length(sigList)}/${maxSignature}개</span>
			</div>

			<%-- 개수를 넘겨 저장을 시도했을 때 서버가 돌려보내는 한 줄 --%>
			<c:if test="${not empty msg}">
				<div class="notice">${msg}</div>
			</c:if>

			<%-- 눈에 보이지 않는 전송용 폼 두 개.
			     그리기와 올리기가 결국 같은 base64 문자열이라 등록 폼은 하나로 충분하다 --%>
			<form id="saveForm" method="post"
				action="${pageContext.request.contextPath}/signature/save">
				<input type="hidden" name="imageData" id="imageData">
			</form>

			<form id="delForm" method="post"
				action="${pageContext.request.contextPath}/signature/delete">
				<input type="hidden" name="signatureId" id="delId">
			</form>

			<%-- ═══════ 1. 새 서명 등록 ═══════ --%>
			<div class="card">
				<div class="card-head">
					<h3>새 서명 등록</h3>
					<p>
						직접 그리거나 이미지 파일로 올릴 수 있습니다.<br> 이미 결재가 끝난 문서의 도장은 그때 찍힌 서명 그대로
						남습니다.
					</p>
				</div>

				<div class="tabs">
					<div class="tab on" onclick="pickTab(this, 'DRAW')">직접 그리기</div>
					<div class="tab" onclick="pickTab(this, 'FILE')">이미지 올리기</div>
				</div>

				<div class="card-body">

					<%-- ── 직접 그리기 ── --%>
					<div id="paneDRAW" class="pane on">
						<div class="pad-wrap">
							<div class="pad">
								<div class="baseline"></div>
								<div class="guide" id="guide">이 안에 마우스로 서명을 그려주세요</div>
								<canvas id="pad" width="420" height="170"></canvas>
							</div>

							<div class="pad-side">
								<b>이렇게 하면 좋아요</b> 밑줄 위에 평소 쓰는 사인을 그대로 그려주세요.<br> 한 번에 안
								되면 지우고 다시 그리면 됩니다.

								<div class="pen-row">
									<span>굵기</span>
									<div class="pen" onclick="pickPen(this, 2)">
										<i style="width: 4px; height: 4px"></i>
									</div>
									<div class="pen on" onclick="pickPen(this, 3)">
										<i style="width: 7px; height: 7px"></i>
									</div>
									<div class="pen" onclick="pickPen(this, 5)">
										<i style="width: 11px; height: 11px"></i>
									</div>
								</div>
							</div>
						</div>

						<div class="btns">
							<button type="button" class="btn primary" onclick="saveDraw()">등록</button>
							<button type="button" class="btn" onclick="clearPad()">지우기</button>
						</div>
					</div>

					<%-- ── 이미지 올리기 ── --%>
					<div id="paneFILE" class="pane">
						<div class="pad-wrap">
							<%-- label 로 감싸 두면 칸 아무 데나 눌러도 파일 창이 열린다 --%>
							<label class="drop" id="drop"> <span class="big">🖊</span> <span>클릭해서
									이미지 파일을 선택하세요</span> <input type="file" id="file" accept="image/*"
								hidden onchange="showPick(this)">
							</label>

							<div class="pad-side">
								<b>파일은 이렇게</b> 배경이 없는 PNG 를 쓰면 도장이 종이 위에 자연스럽게 얹힙니다.<br>
								JPG 도 되지만 흰 네모가 같이 찍힙니다.
							</div>
						</div>

						<div class="btns">
							<button type="button" class="btn primary" onclick="saveFile()">등록</button>
							<button type="button" class="btn" onclick="clearPick()">취소</button>
						</div>
					</div>

				</div>
			</div>

			<%-- ═══════ 2. 등록해 둔 서명 ═══════ --%>
			<div class="card">
				<div class="card-head">
					<h3>등록해 둔 서명</h3>
					<p>하나를 눌러 대표 서명으로 정하세요. 지난 서명도 과거 문서에 찍힌 채로 남아 있습니다.</p>
				</div>

				<div class="card-body">
					<%-- 칸을 고르는 즉시 이 폼이 전송된다. 따로 저장 버튼을 두지 않는다 --%>
					<form id="pickForm" method="post"
						action="${pageContext.request.contextPath}/signature/select">
						<div class="sig-grid" id="grid">

						<%-- 기본 도장 : 서명을 안 고른 상태를 뜻한다.
						     값이 빈 문자열이라 서버는 signature_id 를 NULL 로 저장하고,
						     문서 도장판은 지금까지처럼 이름 동그라미를 찍는다.
						     지우거나 바꿀 수 없으므로 삭제 글자가 없다 --%>
						<label class="sig-item ${empty activeSignatureId ? 'on' : ''}"> <input
							type="radio" name="signatureId" value="" onclick="pickSig(this)">
							<div class="badge">대표</div>
							<div class="thumb">
								<span class="stamp">${sessionScope.loginUser.name}</span>
							</div>
							<div class="meta">
								<span>기본 도장 (서명 없음)</span>
							</div>
						</label>

						<%-- 등록해 둔 서명들. 지운 것은 서버가 이미 빼고 내려준다 --%>
						<c:forEach var="sg" items="${sigList}">
							<label class="sig-item ${sg.isActive eq 'Y' ? 'on' : ''}"> <input
								type="radio" name="signatureId" value="${sg.signatureId}"
								onclick="pickSig(this)">
								<div class="badge">대표</div>
								<div class="thumb">
									<img
										src="${pageContext.request.contextPath}/signature/image/${sg.signatureId}"
										alt="서명">
								</div>
								<div class="meta">
									<span>${fn:substring(sg.createdAt, 0, 10)}</span> <span class="del"
										onclick="removeSig(event, ${sg.signatureId})">삭제</span>
								</div>
							</label>
						</c:forEach>
						</div>
					</form>
				</div>
			</div>

		</div>
	</div>

	<script>
		/* ───────── 탭 ───────── */
		function pickTab(el, key) {
			var tabs = document.querySelectorAll(".tabs .tab");
			for (var i = 0; i < tabs.length; i++) {
				tabs[i].className = (tabs[i] === el) ? "tab on" : "tab";
			}
			document.getElementById("paneDRAW").className = (key === "DRAW") ? "pane on" : "pane";
			document.getElementById("paneFILE").className = (key === "FILE") ? "pane on" : "pane";
		}

		/* ───────── 서명 그리기 ─────────
		   마우스를 누르고 있는 동안만 선을 잇는다.
		   캔버스 좌표는 화면 좌표와 다르므로 getBoundingClientRect 로 빼준다 */
		var pad = document.getElementById("pad");
		var ctx = pad.getContext("2d");
		var drawing = false;
		var inked = false; /* 한 획이라도 그렸는지 (빈 그림 등록 방지) */

		ctx.lineWidth = 3;
		ctx.lineCap = "round";
		ctx.lineJoin = "round";
		ctx.strokeStyle = "#1c2a47";

		function spot(e) {
			var r = pad.getBoundingClientRect();
			return {
				x : e.clientX - r.left,
				y : e.clientY - r.top
			};
		}

		pad.addEventListener("mousedown", function(e) {
			drawing = true;
			inked = true;
			document.getElementById("guide").style.display = "none";
			var p = spot(e);
			ctx.beginPath();
			ctx.moveTo(p.x, p.y);
		});

		pad.addEventListener("mousemove", function(e) {
			if (!drawing) {
				return;
			}
			var p = spot(e);
			ctx.lineTo(p.x, p.y);
			ctx.stroke();
		});

		/* 판 밖에서 손을 떼도 선이 계속 따라오지 않도록 둘 다 잡는다 */
		pad.addEventListener("mouseup", function() {
			drawing = false;
		});
		pad.addEventListener("mouseleave", function() {
			drawing = false;
		});

		function pickPen(el, w) {
			var pens = document.querySelectorAll(".pen");
			for (var i = 0; i < pens.length; i++) {
				pens[i].className = (pens[i] === el) ? "pen on" : "pen";
			}
			ctx.lineWidth = w;
		}

		function clearPad() {
			ctx.clearRect(0, 0, pad.width, pad.height);
			inked = false;
			document.getElementById("guide").style.display = "";
		}

		/* 그린 그림을 문자열로 뽑는다. "data:image/png;base64,iVBORw0K..." 형태 */
		function saveDraw() {
			if (!inked) {
				alert("서명을 먼저 그려주세요.");
				return;
			}
			send(pad.toDataURL("image/png"));
		}

		/* ───────── 이미지 올리기 ─────────
		   FileReader 가 고른 파일을 그리기와 똑같은 base64 문자열로 읽어준다 */
		var picked = null;

		function showPick(input) {
			var f = input.files[0];
			if (!f) {
				return;
			}

			var reader = new FileReader();
			reader.onload = function(e) {
				picked = e.target.result;
				var drop = document.getElementById("drop");
				drop.innerHTML = "";

				var img = document.createElement("img");
				img.src = picked;
				img.alt = "미리보기";
				drop.appendChild(img);
				drop.appendChild(input); /* 다시 고를 수 있어야 하므로 input 은 살려 둔다 */
			};
			reader.readAsDataURL(f);
		}

		function clearPick() {
			picked = null;

			var input = document.getElementById("file");
			input.value = "";

			var drop = document.getElementById("drop");
			drop.innerHTML = '<span class="big">🖊</span><span>클릭해서 이미지 파일을 선택하세요</span>';
			drop.appendChild(input);
		}

		function saveFile() {
			if (!picked) {
				alert("이미지 파일을 먼저 선택해주세요.");
				return;
			}
			send(picked);
		}

		/* ───────── 서버로 보내기 ─────────
		   그리기와 올리기가 같은 base64 문자열이라 보내는 길도 하나다.
		   저장이 끝나면 서버가 목록 화면으로 되돌려 준다 */
		var isFull = ${fn:length(sigList) >= maxSignature};

		function send(imageData) {
			/* 서버도 막지만 여기서 먼저 걸러야 그린 그림이 날아가지 않는다 */
			if (isFull) {
				alert("서명은 ${maxSignature}개까지 등록할 수 있습니다.\n하나를 지우고 다시 등록해주세요.");
				return;
			}

			document.getElementById("imageData").value = imageData;
			document.getElementById("saveForm").submit();
		}

		/* 고른 칸 하나만 파랗게 하고 바로 전송한다.
		   되돌아온 화면은 서버가 정한 대표를 다시 그리므로 이 표시는 잠깐 보이는 것뿐이다 */
		function pickSig(input) {
			var items = document.querySelectorAll(".sig-item");
			for (var i = 0; i < items.length; i++) {
				items[i].className = "sig-item";
			}
			input.parentNode.className = "sig-item on";

			document.getElementById("pickForm").submit();
		}

		/* 삭제 글자를 눌렀을 때 칸 전체(라디오)까지 눌리지 않게 막는다 */
		function removeSig(e, id) {
			e.preventDefault();
			e.stopPropagation();

			if (!confirm("이 서명을 삭제할까요?\n이미 결재한 문서의 도장은 그대로 남습니다.")) {
				return;
			}

			document.getElementById("delId").value = id;
			document.getElementById("delForm").submit();
		}
	</script>

</body>
</html>
