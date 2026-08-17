<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결재선 설정</title>
<style>
* { box-sizing:border-box; }
body { margin:0; background:#f7f8fa; color:#2b3444;
       font-family:"맑은 고딕","Malgun Gothic",sans-serif; font-size:13px; }

.modal { display:flex; flex-direction:column; height:100vh; background:#fff; }

/* 위 제목줄 */
.m-head { display:flex; justify-content:space-between; align-items:center;
          padding:14px 18px; border-bottom:1px solid #eceff3; }
.m-head b { font-size:14.5px; color:#1c2a47; }
.m-head .x { cursor:pointer; color:#9aa3b0; font-size:16px; text-decoration:none; }

/* 가운데 2단 */
.m-body { flex:1; display:flex; min-height:0; }
.pane-left  { width:300px; border-right:1px solid #eceff3;
              display:flex; flex-direction:column; min-height:0; }
.pane-right { flex:1; padding:16px 20px; overflow-y:auto; background:#fbfcfd; }

/* --- 왼쪽 : 검색 + 역할 + 트리 --- */
.side-top { padding:12px; border-bottom:1px solid #f1f3f6; }
.side-search { position:relative; }
.side-search input { width:100%; height:32px; border:1px solid #e3e7ed;
                     border-radius:8px; padding:0 10px 0 30px; font-size:12.5px; }
.side-search input:focus { outline:none; border-color:#2f6bff; }
.side-search .ico { position:absolute; left:10px; top:8px; color:#b3bac4;
                    font-size:12px; }

.role-pick { display:flex; align-items:center; gap:6px; margin-top:10px; }
.role-pick .lbl { font-size:11.5px; color:#8b94a3; margin-right:2px; }
.role-chip { border:1px solid #e3e7ed; background:#fff; color:#7b8494;
             border-radius:20px; padding:3px 12px; font-size:11.5px;
             cursor:pointer; }
.role-chip.on { background:#e9f7ef; border-color:#a9dfc0; color:#1f8a4c;
                font-weight:700; }

/* 맨 위 탭 : 결재선 / 참조자 / 열람자 */
.tabs { display:flex; gap:18px; padding:12px 14px 0; border-bottom:1px solid #eceff3; }
.tabs .tab { padding:0 2px 9px; font-size:13px; color:#9aa3b0; cursor:pointer;
             border-bottom:2px solid transparent; margin-bottom:-1px; }
.tabs .tab.on { color:#2b3444; font-weight:700; border-bottom-color:#2b3444; }
.tabs .req { color:#e5484d; margin-right:2px; }

/* 그 아래 탭 : 조직도 / 나의 결재선 */
.subtabs { display:flex; margin:12px 12px 0; border:1px solid #e3e7ed;
           border-radius:6px 6px 0 0; overflow:hidden; }
.subtabs .stab { flex:1; text-align:center; padding:8px 0; font-size:12.5px;
                 color:#8b94a3; background:#f7f8fa; cursor:pointer;
                 border-right:1px solid #e3e7ed; }
.subtabs .stab:last-child { border-right:none; }
.subtabs .stab.on { background:#fff; color:#2b3444; font-weight:700; }

.tree { flex:1; overflow-y:auto; padding:6px 0 14px; }

/* 나의 결재선 목록 */
.mine { flex:1; overflow-y:auto; padding:6px 0 14px; }
.mine-row { display:flex; align-items:center; gap:7px; padding:9px 14px;
            cursor:pointer; }
.mine-row:hover { background:#f6f8fb; }
.mine-row .nm  { font-size:12.5px; }
.mine-row .cnt { flex:1; font-size:11.5px; color:#2f6bff; }
.mine-row .del { border:none; background:none; color:#c9ced7; cursor:pointer;
                 font-size:12px; }
.mine-row .del:hover { color:#e5484d; }
.mine-save { margin:8px 12px 4px; }
.mine-save button { width:100%; height:30px; border:1px dashed #cfd6e0;
                    border-radius:8px; background:#fff; color:#5b6576;
                    font-size:12px; cursor:pointer; }
.mine-save button:hover { border-color:#2f6bff; color:#2f6bff; }

.node { display:flex; align-items:center; gap:7px; cursor:pointer;
        padding:6px 12px; user-select:none; }
.node:hover { background:#f6f8fb; }
.node .ico { color:#9db3ff; font-size:12px; width:13px; text-align:center; }
.node .nm  { flex:1; font-size:12.5px; }
.node .cnt { font-size:11px; color:#9aa3b0; }
.node .arw { font-size:9px; color:#b3bac4; width:10px; text-align:center; }

.node.dept { font-weight:700; color:#3d4756; }
.node.team { padding-left:26px; }
.node.emp  { padding-left:44px; }

/* 사원 줄 : 이름 + 직위, 고르면 체크 */
.node.emp .nm  { display:flex; flex-direction:column; gap:1px; }
.node.emp .pos { font-size:10.5px; color:#a3abb7; }
.node.emp .chk { color:#2f6bff; font-size:11px; visibility:hidden; }
.node.emp.picked { background:#f2f6ff; }
.node.emp.picked .chk { visibility:visible; }
.node.emp .av { width:20px; height:20px; border-radius:50%; background:#e8edf6;
                color:#5b6576; font-size:10px; display:flex;
                align-items:center; justify-content:center; }
.node.emp.picked .av { background:#2f6bff; color:#fff; }

/* --- 오른쪽 : 기안자 + 결재선 --- */
.sec-title { text-align:center; font-size:11.5px; color:#9aa3b0;
             margin:4px 0 8px; }

.card { display:flex; align-items:center; gap:10px; background:#fff;
        border:1px solid #e6ebf2; border-radius:10px; padding:11px 13px; }
.card.me { border-color:#c9dbff; background:#f5f9ff; }
.card .av { width:30px; height:30px; border-radius:50%; background:#2f6bff;
            color:#fff; font-size:11.5px; display:flex;
            align-items:center; justify-content:center; flex:none; }
.card .who { flex:1; min-width:0; }
.card .who .n { font-weight:700; font-size:12.5px; }
.card .who .s { font-size:11px; color:#9aa3b0; margin-top:2px; }
.card .tag { font-size:11px; color:#8b94a3; }

.line-row { display:flex; align-items:center; gap:10px; background:#fff;
            border:1px solid #e6ebf2; border-radius:10px; padding:9px 12px;
            margin-bottom:8px; }
.line-row .no { width:20px; height:20px; border-radius:6px; background:#f0f3f8;
                color:#5b6576; font-size:11px; display:flex;
                align-items:center; justify-content:center; flex:none; }
.line-row .av { width:26px; height:26px; border-radius:50%; background:#e8edf6;
                color:#5b6576; font-size:11px; display:flex;
                align-items:center; justify-content:center; flex:none; }
.line-row select { border:1px solid #cfe9da; background:#f1faf5; color:#1f8a4c;
                   border-radius:6px; font-size:11.5px; padding:3px 6px;
                   cursor:pointer; }
.line-row .who { flex:1; min-width:0; }   /* 이름칸이 남은 자리를 다 먹어야 ✕ 가 끝으로 밀린다 */
.line-row .mv { border:none; background:none; color:#b3bac4; cursor:pointer;
                font-size:11px; padding:0 1px; }
.line-row .mv:hover { color:#2f6bff; }
.line-row .del { margin-left:auto; border:none; background:none; color:#c9ced7;
                 cursor:pointer; font-size:13px; }
.line-row .del:hover { color:#e5484d; }

.empty-line { text-align:center; color:#aeb6c2; font-size:12px;
              border:1px dashed #dfe4ec; border-radius:10px; padding:26px 0; }

/* 결재 흐름 */
.flow-box { margin-top:20px; }
.flow-box .cap { font-size:11.5px; color:#8b94a3; margin-bottom:7px; }
.flow { display:flex; flex-wrap:wrap; align-items:center; gap:6px; }
.flow .step { background:#eef4ff; color:#2f6bff; border-radius:6px;
              padding:3px 9px; font-size:11px; }
.flow .step.agree { background:#e9f7ef; color:#1f8a4c; }
.flow .arw { color:#c9ced7; font-size:10px; }

/* 아래 버튼줄 */
.m-foot { display:flex; align-items:center; justify-content:space-between;
          padding:12px 18px; border-top:1px solid #eceff3; }
.m-foot .cnt { font-size:11.5px; color:#8b94a3; }
.btn { height:32px; padding:0 16px; border:1px solid #e3e7ed; border-radius:8px;
       background:#fff; color:#3d4756; font-size:12.5px; cursor:pointer;
       display:inline-flex; align-items:center; }
.btn:hover { border-color:#cfd6e0; }
.btn.primary { background:#2f6bff; border-color:#2f6bff; color:#fff; }
.btn.primary:hover { background:#1f57e0; }
</style>
</head>
<body>

	<div class="modal">

		<div class="m-head">
			<b>결재선 설정</b>
			<a class="x" href="#" onclick="window.close(); return false;">✕</a>
		</div>

		<div class="m-body">

			<!-- ===== 왼쪽 : 조직도 / 나의 결재선 ===== -->
			<div class="pane-left">

				<div class="tabs">
					<div class="tab on" onclick="pickTab(this,'LINE')">
						<span class="req">*</span>결재선
					</div>
					<div class="tab" onclick="pickTab(this,'REF')">참조자</div>
					<div class="tab" onclick="pickTab(this,'VIEW')">열람자</div>
				</div>

				<div class="subtabs">
					<div class="stab on" onclick="pickSide(this,'ORG')">조직도</div>
					<div class="stab" onclick="pickSide(this,'MINE')">나의 결재선</div>
				</div>

				<!-- 조직도 탭 -->
				<div class="side-top" id="sideTop">
					<div class="side-search">
						<span class="ico">🔍</span>
						<input type="text" id="q" placeholder="이름, 부서, 직책 검색..."
							oninput="drawTree()">
					</div>
				</div>
				<div class="tree" id="tree"></div>

				<!-- 나의 결재선 탭 -->
				<div class="mine" id="mine" style="display: none;"></div>
			</div>

			<!-- ===== 오른쪽 : 결재선 ===== -->
			<div class="pane-right">

				<div class="sec-title">신청 (기안자)</div>
				<div class="card me" id="drafterCard"></div>

				<div class="sec-title" style="margin-top: 18px;">승인 결재선</div>
				<div id="lineList"></div>

				<div class="flow-box">
					<div class="role-pick" style="margin-bottom: 12px;">
						<%-- '합의 방식'이 아니라 '결재 방식'이다. 이 값은 document.approval_type 으로
						     저장돼 결재선 전원(합의자 포함)의 진행 순서를 정한다.
						     아래 사람마다 고르는 승인/합의는 역할(approval_line.approval_type)이라 다른 값이고,
						     같은 화면에서 둘 다 '합의'라고 부르면 구분이 안 된다 --%>
						<span class="lbl">결재 방식</span>
						<button type="button" class="role-chip on" data-mode="SEQUENTIAL"
							onclick="pickApprMode(this)">순차 결재</button>
						<button type="button" class="role-chip" data-mode="PARALLEL"
							onclick="pickApprMode(this)">병렬 결재</button>
					</div>
					<div class="cap">결재 흐름</div>
					<div class="flow" id="flow"></div>
				</div>

			</div>
		</div>

		<div class="m-foot">
			<span class="cnt" id="footCnt">결재자 0명 설정됨</span>
			<div>
				<button type="button" class="btn" onclick="window.close()">취소</button>
				<button type="button" class="btn primary" onclick="confirmLine()">결재선
					확정</button>
			</div>
		</div>

	</div>

	<%-- ===== 서버가 내려준 조직도를 감춰진 칸에 심어 둔다 =====
	     orgList 는 부서·팀·사원이 한 줄씩 펼쳐진 평평한 목록이다.
	     (ORDER BY 부서 → 팀 → 직급 순으로 이미 정렬돼 있다)
	     JS 가 이걸 읽어서 트리 모양으로 다시 묶는다. --%>
	<div id="orgData" style="display: none;">
		<c:forEach var="o" items="${orgList}">
			<span data-did="${o.departmentId}" data-dname="${o.departmentName}"
				data-tid="${o.teamId}" data-tname="${o.teamName}"
				data-eid="${o.employeeId}" data-name="${o.name}"
				data-pos="${o.position}" data-title="${o.title}"
				data-lvl="${o.positionLevel}" data-mgr="${o.managerId}"></span>
		</c:forEach>
	</div>
	<span id="meId" data-eid="${sessionScope.loginUser.employeeId}"
		data-name="${sessionScope.loginUser.name}" style="display: none;"></span>

	<script>
		// ===== 1. 서버가 심어둔 값을 자바스크립트 배열로 옮긴다 =====
		var ORG = [];
		(function () {
			var spans = document.querySelectorAll("#orgData span");
			for (var i = 0; i < spans.length; i++) {
				var s = spans[i];
				ORG.push({
					// 부서·팀이 없는 사람(사장·본부장)은 DB 에서 NULL 이 와서
					// EL 이 빈 칸으로 찍는다. 라벨이 비지 않게 여기서 채운다.
					did   : s.getAttribute("data-did")   || "0",
					dname : s.getAttribute("data-dname") || "경영진",
					tid   : s.getAttribute("data-tid")   || "0",
					tname : s.getAttribute("data-tname") || "임원",
					eid   : s.getAttribute("data-eid"),
					name  : s.getAttribute("data-name"),
					pos   : s.getAttribute("data-pos") || "",
					title : s.getAttribute("data-title") || "",
					// 직급 레벨. 사원·대리 1 < 과장·차장·부장 2 < 사장·이사 3
					lvl   : parseInt(s.getAttribute("data-lvl"), 10) || 0,
					mgr   : s.getAttribute("data-mgr") || ""
				});
			}
		})();

		// 본부장처럼 팀이 없는 사람은 부서 이름이 안 딸려온다.
		// employee ─team─▶ department 로만 이어져 있어서 팀이 없으면 길이 끊기기 때문이다.
		// 대신 내 밑에 달린 사람(manager_id 가 나를 가리키는 사람)의 부서를 빌려 온다.
		(function () {
			var byMgr = {};
			ORG.forEach(function (o) {
				if (!o.mgr) return;
				(byMgr[o.mgr] = byMgr[o.mgr] || []).push(o);
			});
			ORG.forEach(function (o) {
				if (o.did !== "0") return;          // 부서를 이미 아는 사람은 볼 것 없다
				var kids = byMgr[o.eid] || [];
				for (var i = 0; i < kids.length; i++) {
					if (kids[i].did !== "0") { o.ownDept = kids[i].dname; break; }
				}
			});
		})();

		// 결재란에 쓸 이름표. 직책이 있으면 직책, 없으면 직급.
		function rank(o) { return o.title || o.pos || ""; }

		// 트리에만 쓰는 이름표. 본부장은 어느 본부인지까지 붙여준다
		function treeLabel(o) {
			return o.ownDept ? (rank(o) + " · " + o.ownDept) : rank(o);
		}

		var ME       = document.getElementById("meId");
		var MY_ID    = ME.getAttribute("data-eid");
		var MY_NAME  = ME.getAttribute("data-name");

		var picked   = [];              // 고른 결재자 [{eid,name,pos,tname,role}]
		var role     = "APPROVAL";      // 새로 고른 사람에게 붙을 역할. 합의는 아직 못 쓴다
		var apprMode = "SEQUENTIAL";    // 결재 방식 : 순차 / 병렬 (문서 전체가 도는 순서)
		// 접어둔 부서·팀. 이름을 closed 로 두면 안 된다 —
		// window.closed(창이 닫혔는지 알려주는 읽기 전용 값)와 겹쳐서 대입이 통째로 무시된다
		var folded   = {};

		// 처음에는 부서·팀을 전부 접어 둔다. 1806명이 한 번에 펼쳐지면 못 본다
		ORG.forEach(function (o) {
			folded["d" + o.did] = true;
			folded["t" + o.did + "_" + o.tid] = true;
		});

		// ===== 2. 왼쪽 트리 그리기 =====
		function drawTree() {
			var q = document.getElementById("q").value.trim();
			var rows = ORG.filter(function (o) {
				if (!q) return true;
				// ownDept 도 넣어야 '개발본부' 로 검색했을 때 그 본부장이 걸린다
				return (o.name + o.pos + o.tname + o.dname
						+ (o.ownDept || "")).indexOf(q) >= 0;
			});

			// 부서 → 팀 → 사원 으로 묶는다. 평평한 줄을 계단으로 접는 작업이다
			var depts = [];
			var dMap = {}, tMap = {};
			rows.forEach(function (o) {
				if (!dMap[o.did]) {
					dMap[o.did] = { id:o.did, name:o.dname, teams:[], cnt:0 };
					depts.push(dMap[o.did]);
				}
				var tk = o.did + "_" + o.tid;
				if (!tMap[tk]) {
					tMap[tk] = { key:tk, name:o.tname, emps:[] };
					dMap[o.did].teams.push(tMap[tk]);
				}
				tMap[tk].emps.push(o);
				dMap[o.did].cnt++;
			});

			// 검색 중일 때는 접힘을 무시하고 다 펼친다. 안 그러면 찾은 사람이 안 보인다
			var h = "";
			depts.forEach(function (d) {
				var dOpen = q ? true : !folded["d" + d.id];
				h += row("dept", "d" + d.id, "🏢", d.name, d.cnt + "명", dOpen);
				if (!dOpen) return;

				d.teams.forEach(function (t) {
					var tOpen = q ? true : !folded["t" + t.key];
					h += row("team", "t" + t.key, "👥", t.name,
							 t.emps.length + "명", tOpen);
					if (!tOpen) return;

					t.emps.forEach(function (e) {
						var on = isPicked(e.eid) ? " picked" : "";
						h += '<div class="node emp' + on + '" onclick="toggleEmp(\'' + e.eid + '\')">'
						   +   '<span class="av">' + e.name.substring(0, 1) + '</span>'
						   +   '<span class="nm"><span>' + e.name + '</span>'
						   +     '<span class="pos">' + treeLabel(e) + '</span></span>'
						   +   '<span class="chk">✔</span>'
						   + '</div>';
					});
				});
			});

			document.getElementById("tree").innerHTML =
				h || '<div class="empty-line" style="margin:14px 12px;">검색 결과가 없습니다.</div>';
		}

		// 부서·팀 처럼 접었다 폈다 하는 줄
		function row(cls, key, ico, name, cnt, open) {
			return '<div class="node ' + cls + '" onclick="fold(\'' + key + '\')">'
			     +   '<span class="ico">' + ico + '</span>'
			     +   '<span class="nm">' + name + '</span>'
			     +   '<span class="cnt">' + cnt + '</span>'
			     +   '<span class="arw">' + (open ? "▲" : "▼") + '</span>'
			     + '</div>';
		}

		function fold(key) {
			folded[key] = !folded[key];
			drawTree();
		}

		// ===== 2-1. 탭 =====
		// 참조자·열람자는 아직 안 만들었다. 눌러도 결재선 탭에 그대로 남는다
		function pickTab(el, kind) {
			if (kind !== "LINE") { alert("구현 예정입니다."); return; }
			var tabs = document.querySelectorAll(".tabs .tab");
			for (var i = 0; i < tabs.length; i++) {
				tabs[i].className = (tabs[i] === el) ? "tab on" : "tab";
			}
		}

		// 조직도 ↔ 나의 결재선. 둘 중 하나만 보이게 한다
		function pickSide(el, kind) {
			var stabs = document.querySelectorAll(".subtabs .stab");
			for (var i = 0; i < stabs.length; i++) {
				stabs[i].className = (stabs[i] === el) ? "stab on" : "stab";
			}
			var org = (kind === "ORG");
			document.getElementById("sideTop").style.display = org ? ""     : "none";
			document.getElementById("tree").style.display    = org ? ""     : "none";
			document.getElementById("mine").style.display    = org ? "none" : "";
			if (!org) drawMine();
		}

		// 결재 방식 : 순차 / 병렬
		function pickApprMode(btn) {
			apprMode = btn.getAttribute("data-mode");
			var chips = document.querySelectorAll(".role-chip");
			for (var i = 0; i < chips.length; i++) {
				chips[i].className = (chips[i] === btn) ? "role-chip on" : "role-chip";
			}
			drawLine();
		}

		// ===== 3. 결재자 담기 / 빼기 =====
		function isPicked(eid) {
			return picked.some(function (p) { return p.eid === eid; });
		}

		function toggleEmp(eid) {
			if (isPicked(eid)) {
				picked = picked.filter(function (p) { return p.eid !== eid; });
			} else {
				if (eid === MY_ID) { alert("기안자는 결재자로 넣을 수 없습니다."); return; }
				var o = ORG.filter(function (x) { return x.eid === eid; })[0];
				// dname 은 결재선에 찍을 본부. 본부장은 팀이 없어 빌려온 ownDept 가 진짜 본부다
				var row = { eid:o.eid, name:o.name, pos:rank(o), lvl:o.lvl,
							tname:o.tname, dname:(o.ownDept || o.dname), role:role };

				// 결재는 아래에서 위로 올라간다. 나보다 높은 직급 앞에 끼워 넣어
				// 사장이 가운데 박히지 않게 한다. (▲▼ 로 손수 고칠 수는 있다)
				var at = picked.length;
				for (var k = 0; k < picked.length; k++) {
					if (picked[k].lvl > row.lvl) { at = k; break; }
				}
				picked.splice(at, 0, row);
			}
			drawAll();
		}

		function removeAt(i) { picked.splice(i, 1); drawAll(); }

		// 순서 바꾸기. 결재는 순서가 곧 결재 차례다
		function move(i, d) {
			var j = i + d;
			if (j < 0 || j >= picked.length) return;
			var tmp = picked[i]; picked[i] = picked[j]; picked[j] = tmp;
			drawAll();
		}

		// 합의는 아직 안 만들었다. 고르면 알리고 승인으로 되돌린다
		function setRole(i, v) {
			if (v === "AGREEMENT") { alert("구현 예정입니다."); drawLine(); return; }
			picked[i].role = v;
			drawAll();
		}

		// ===== 4. 오른쪽 그리기 =====
		function drawDrafter() {
			var me = ORG.filter(function (o) { return o.eid === MY_ID; })[0];
			var sub = me ? (rank(me) + " · " + me.tname) : "";
			document.getElementById("drafterCard").innerHTML =
				  '<span class="av">' + (MY_NAME || "?").substring(0, 1) + '</span>'
				+ '<span class="who"><div class="n">' + (MY_NAME || "") + '</div>'
				+   '<div class="s">' + sub + '</div></span>'
				+ '<span class="tag">기안자</span>';
		}

		function drawLine() {
			var box = document.getElementById("lineList");
			if (picked.length === 0) {
				box.innerHTML = '<div class="empty-line">왼쪽에서 결재자를 선택하세요.</div>';
			} else {
				var h = "";
				picked.forEach(function (p, i) {
					h += '<div class="line-row">'
					   +   '<span class="no">' + (i + 1) + '</span>'
					   +   '<span class="av">' + p.name.substring(0, 1) + '</span>'
					   +   '<span class="who"><div class="n">' + p.name + '</div>'
					   +     '<div class="s">' + p.pos + ' · ' + p.dname + '</div></span>'
					   +   '<button type="button" class="mv" onclick="move(' + i + ',-1)">▲</button>'
					   +   '<button type="button" class="mv" onclick="move(' + i + ',1)">▼</button>'
					   +   '<select onchange="setRole(' + i + ', this.value)">'
					   +     '<option value="APPROVAL"' + (p.role === "APPROVAL" ? " selected" : "") + '>승인</option>'
					   +     '<option value="AGREEMENT"' + (p.role === "AGREEMENT" ? " selected" : "") + '>합의</option>'
					   +   '</select>'
					   +   '<button type="button" class="del" onclick="removeAt(' + i + ')">✕</button>'
					   + '</div>';
				});
				box.innerHTML = h;
			}

			var f = '<span class="step">' + (MY_NAME || "") + ' (기안자)</span>';
			picked.forEach(function (p) {
				f += '<span class="arw">▶</span>'
				   + '<span class="step' + (p.role === "AGREEMENT" ? " agree" : "") + '">'
				   + p.name + ' (' + (p.role === "AGREEMENT" ? "합의" : "승인") + ')</span>';
			});
			document.getElementById("flow").innerHTML = f;

			document.getElementById("footCnt").innerHTML =
				"결재자 " + picked.length + "명 설정됨";
		}

		// ===== 4-1. 나의 결재선 =====
		// 저장할 테이블(approval_line_template 같은 것)이 아직 없다.
		// 지금은 틀만 있고, 서버 저장이 붙을 때 여기를 채운다
		function drawMine() {
			document.getElementById("mine").innerHTML =
				  '<div class="mine-save">'
				+   '<button type="button" onclick="saveMine()">＋ 지금 결재선 저장</button>'
				+ '</div>'
				+ '<div class="empty-line" style="margin:10px 12px;">저장된 결재선이 없습니다.</div>';
		}

		function saveMine() { alert("구현 예정입니다."); }

		function drawAll() { drawTree(); drawLine(); }

		// ===== 5. 확정 → 기안 작성 창으로 넘긴다 =====
		function confirmLine() {
			if (picked.length === 0) { alert("결재자를 한 명 이상 선택해 주세요."); return; }
			// 기안 작성 창이 기다리는 모양으로 바꿔서 넘긴다
			//   { employeeId, name, position, department, role }
			var out = picked.map(function (p, i) {
				return {
					employeeId : p.eid,
					name       : p.name,
					position   : p.pos,
					department : p.tname,
					dept       : p.dname,          // 부서 (본부)
					role       : (p.role === "AGREEMENT" ? "합의" : "승인"),
					roleCode   : p.role,           // 저장할 때 쓸 값
					order      : i + 1             // 결재 순서
				};
			});

			if (window.opener && !window.opener.closed
					&& window.opener.setApprovalLine) {

				// 결재 방식(순차/병렬)도 같이 넘긴다.
				// 이 값이 안 가면 기안 작성 창은 늘 순차로 저장해 버린다
				window.opener.setApprovalLine(out, apprMode);
				window.close();
			} else {
				alert("기안 작성 창을 찾을 수 없습니다.");
			}
		}

		// ===== 6. 기안 작성 창이 이미 고른 결재선이 있으면 그걸 물려받는다 =====
		// confirmLine() 이 내보낸 모양({employeeId,...})으로 돌아오므로 팝업이 쓰는 모양으로 되돌린다.
		// lvl(직급 레벨)은 안 넘어오니 조직도에서 다시 찾아 채운다 — ▲▼ 자동 끼워넣기가 이 값을 쓴다
		(function () {
			if (!window.opener || window.opener.closed
					|| !window.opener.getApprovalLine) return;

			// 결재 방식도 같이 물려받는다. 이게 없으면 병렬로 골라 둔 문서를
			// 편집하려고 팝업을 열었을 때 순차로 되돌아가 있다
			if (window.opener.getApprovalType) {
				var mode = window.opener.getApprovalType();
				if (mode) {
					apprMode = mode;
					var chips = document.querySelectorAll(".role-chip");
					for (var i = 0; i < chips.length; i++) {
						chips[i].className = (chips[i].getAttribute("data-mode") === mode)
								? "role-chip on" : "role-chip";
					}
				}
			}

			var prev = window.opener.getApprovalLine() || [];
			picked = prev.map(function (a) {
				var eid = String(a.employeeId);
				var o = ORG.filter(function (x) { return x.eid === eid; })[0];
				return {
					eid   : eid,
					name  : a.name,
					pos   : a.position,
					lvl   : o ? o.lvl : 0,
					tname : a.department,
					dname : o ? (o.ownDept || o.dname) : (a.dept || ""),
					role  : a.roleCode || "APPROVAL"
				};
			});
		})();

		drawDrafter();
		drawAll();
	</script>

</body>
</html>
