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

.tree { flex:1; overflow-y:auto; padding:6px 0 14px; }

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
.line-row .mv { border:none; background:none; color:#b3bac4; cursor:pointer;
                font-size:11px; padding:0 1px; }
.line-row .mv:hover { color:#2f6bff; }
.line-row .del { border:none; background:none; color:#c9ced7; cursor:pointer;
                 font-size:13px; }
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

			<!-- ===== 왼쪽 : 조직도 ===== -->
			<div class="pane-left">
				<div class="side-top">
					<div class="side-search">
						<span class="ico">🔍</span>
						<input type="text" id="q" placeholder="이름, 부서, 직책 검색..."
							oninput="drawTree()">
					</div>
					<div class="role-pick">
						<span class="lbl">추가 역할</span>
						<button type="button" class="role-chip" data-role="AGREEMENT"
							onclick="pickRole(this)">합의</button>
						<button type="button" class="role-chip on" data-role="APPROVAL"
							onclick="pickRole(this)">승인</button>
					</div>
				</div>
				<div class="tree" id="tree"></div>
			</div>

			<!-- ===== 오른쪽 : 결재선 ===== -->
			<div class="pane-right">

				<div class="sec-title">신청 (기안자)</div>
				<div class="card me" id="drafterCard"></div>

				<div class="sec-title" style="margin-top: 18px;">승인 결재선</div>
				<div id="lineList"></div>

				<div class="flow-box">
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
				data-lvl="${o.positionLevel}"></span>
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
					lvl   : parseInt(s.getAttribute("data-lvl"), 10) || 0
				});
			}
		})();

		// 결재란에 쓸 이름표. 직책이 있으면 직책, 없으면 직급.
		function rank(o) { return o.title || o.pos || ""; }

		var ME       = document.getElementById("meId");
		var MY_ID    = ME.getAttribute("data-eid");
		var MY_NAME  = ME.getAttribute("data-name");

		var picked   = [];              // 고른 결재자 [{eid,name,pos,tname,role}]
		var role     = "APPROVAL";      // 지금 고르면 붙을 역할
		var closed   = {};              // 접어둔 부서·팀

		// 처음에는 부서·팀을 전부 접어 둔다. 1806명이 한 번에 펼쳐지면 못 본다
		ORG.forEach(function (o) {
			closed["d" + o.did] = true;
			closed["t" + o.did + "_" + o.tid] = true;
		});

		// ===== 2. 왼쪽 트리 그리기 =====
		function drawTree() {
			var q = document.getElementById("q").value.trim();
			var rows = ORG.filter(function (o) {
				if (!q) return true;
				return (o.name + o.pos + o.tname + o.dname).indexOf(q) >= 0;
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
				var dOpen = q ? true : !closed["d" + d.id];
				h += row("dept", "d" + d.id, "🏢", d.name, d.cnt + "명", dOpen);
				if (!dOpen) return;

				d.teams.forEach(function (t) {
					var tOpen = q ? true : !closed["t" + t.key];
					h += row("team", "t" + t.key, "👥", t.name,
							 t.emps.length + "명", tOpen);
					if (!tOpen) return;

					t.emps.forEach(function (e) {
						var on = isPicked(e.eid) ? " picked" : "";
						h += '<div class="node emp' + on + '" onclick="toggleEmp(\'' + e.eid + '\')">'
						   +   '<span class="av">' + e.name.substring(0, 1) + '</span>'
						   +   '<span class="nm"><span>' + e.name + '</span>'
						   +     '<span class="pos">' + rank(e) + '</span></span>'
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
			closed[key] = !closed[key];
			drawTree();
		}

		function pickRole(btn) {
			role = btn.getAttribute("data-role");
			var chips = document.querySelectorAll(".role-chip");
			for (var i = 0; i < chips.length; i++) {
				chips[i].className = (chips[i] === btn) ? "role-chip on" : "role-chip";
			}
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
				var row = { eid:o.eid, name:o.name, pos:rank(o), lvl:o.lvl,
							tname:o.tname, dname:o.dname, role:role };

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

		function setRole(i, v) { picked[i].role = v; drawAll(); }

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
					   +     '<div class="s">' + p.pos + ' · ' + p.tname + '</div></span>'
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
					role       : (p.role === "AGREEMENT" ? "합의" : "승인"),
					roleCode   : p.role,           // 저장할 때 쓸 값
					order      : i + 1             // 결재 순서
				};
			});

			if (window.opener && !window.opener.closed
					&& window.opener.setApprovalLine) {
				window.opener.setApprovalLine(out);
				window.close();
			} else {
				alert("기안 작성 창을 찾을 수 없습니다.");
			}
		}

		drawDrafter();
		drawAll();
	</script>

</body>
</html>
