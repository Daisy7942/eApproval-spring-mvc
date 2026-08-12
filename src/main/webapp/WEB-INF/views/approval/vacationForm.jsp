<%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>eApproval - 휴가 신청서</title>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
* { margin:0; padding:0; box-sizing:border-box;
    font-family:"Malgun Gothic","Segoe UI",sans-serif; }
body { background:#f4f6fa; padding:26px; }
.wrap { max-width:840px; margin:0 auto; background:#fff;
        border-radius:12px; box-shadow:0 2px 12px rgba(0,0,0,.06); }

/* ===== 창 머리 ===== */
.head { display:flex; justify-content:space-between; align-items:center;
        padding:16px 24px; border-bottom:1px solid #e9edf3; }
.head b { font-size:15px; color:#1c2a47; }
.head .x { cursor:pointer; color:#9aa3b2; font-size:19px; text-decoration:none;
           line-height:1; }
.head .x:hover { color:#5b6779; }

.body { padding:26px 28px 8px; }

/* ===== 문서 제목 ===== */
.doc-title { text-align:center; margin-bottom:22px; }
.doc-title h1 { font-size:22px; letter-spacing:9px; color:#1c2a47;
                font-weight:800; text-indent:9px; }
.doc-title p { font-size:12px; color:#9aa3b2; margin-top:7px; }

/* ===== 요약 두 칸 (내 정보 · 연차 현황) ===== */
.summary { display:flex; gap:16px; margin-bottom:24px; flex-wrap:wrap; }
.card { border:1px solid #e9edf3; border-radius:10px; padding:16px 18px;
        background:#fff; }
.card.me { flex:1 1 300px; }
.card.leave { flex:1 1 300px; }

.card.me dl { display:flex; justify-content:space-between; align-items:center;
              margin-bottom:9px; }
.card.me dl:last-child { margin-bottom:0; }
.card.me dt { font-size:12px; color:#98a3b5; }
.card.me dd { font-size:13px; color:#1c2a47; font-weight:700; }

.card.leave .cap { font-size:12px; color:#98a3b5; margin-bottom:11px; }
.stat-row { display:flex; gap:9px; }
.stat { flex:1; border-radius:8px; padding:11px 6px; text-align:center; }
.stat .n { font-size:19px; font-weight:800; line-height:1.2; }
.stat .l { font-size:11px; color:#8b94a3; margin-top:3px; }
.stat.total { background:#f2f6ff; } .stat.total .n { color:#2f6bff; }
.stat.used  { background:#eefaf2; } .stat.used  .n { color:#1f8a4c; }
.stat.left  { background:#fdf5ec; } .stat.left  .n { color:#d08a1e; }

/* ===== 입력 ===== */
.row { margin-bottom:19px; }
.row > label.tit, .row .tit { display:block; font-size:12.5px; color:#3d4756;
        font-weight:700; margin-bottom:8px; }
.row .tit .req { color:#d94848; margin-left:2px; }
.row .tit .opt { color:#9aa3b2; font-weight:400; margin-left:3px; }

.row input[type=text], .row input[type=date], .row textarea {
        width:100%; padding:11px 13px; border:1px solid #dbe1ea;
        border-radius:8px; font-size:13.5px; color:#1c2a47; background:#fff; }
.row textarea { min-height:52px; resize:vertical; line-height:1.6; }
.row input::placeholder, .row textarea::placeholder { color:#b9c1cf; }
.row input:focus, .row textarea:focus { outline:none; border-color:#2f6bff;
        box-shadow:0 0 0 3px rgba(47,107,255,.12); }

/* 두 칸 나란히 */
.pair { display:flex; gap:16px; flex-wrap:wrap; }
.pair > div { flex:1 1 240px; }

/* ===== 휴가 종류 칩 =====
   칩 하나가 "휴가 종류 + 시간 단위" 한 쌍이다.
   연차는 종일·오전반차·오후반차 세 칩으로 갈라진다. */
.chips { display:flex; flex-wrap:wrap; gap:9px; }
.vchip { padding:9px 15px; border:1px solid #dbe1ea; border-radius:8px;
         background:#fff; color:#3d4756; font-size:13px; cursor:pointer;
         transition:background .12s, border-color .12s, color .12s; }
.vchip:hover { border-color:#b9c8e8; color:#2f6bff; }
.vchip.on { background:#2f6bff; border-color:#2f6bff; color:#fff;
            font-weight:700; }

/* ===== 계산된 일수 ===== */
.days-box { display:flex; align-items:center; gap:9px; margin-top:11px;
            border:1px solid #dbe4f5; background:#f7faff; border-radius:8px;
            padding:11px 15px; }
.days-box .num { font-size:17px; font-weight:800; color:#2f6bff; }
.days-box .unit { font-size:13px; color:#1c2a47; }
.days-box .calc { font-size:11px; color:#9aa3b2; margin-left:auto; }
.days-box.warn { border-color:#f2c9c9; background:#fdf0f0; }
.days-box.warn .num { color:#d94848; }

/* ===== 아직 저장할 곳이 없는 칸 =====
   테이블에 컬럼이 없어 화면에만 있다. 눌러도 아무 일도 안 일어난다. */
.soon { position:relative; cursor:not-allowed; }
.soon input { background:#f7f8fa; color:#b4bcc9; pointer-events:none; }
.soon::after { content:attr(data-tip); position:absolute; left:12px; top:-26px;
        background:#2b3444; color:#fff; font-size:11px; padding:4px 9px;
        border-radius:5px; white-space:nowrap; opacity:0; transition:opacity .12s;
        pointer-events:none; }
.soon:hover::after { opacity:1; }

/* ===== 결재선 ===== */
.appr-card { border:1px solid #e9edf3; border-radius:10px; padding:15px 18px;
             background:#fbfcfe; }
.appr-head { display:flex; justify-content:space-between; align-items:center;
             margin-bottom:12px; }
.appr-head .cap { font-size:12px; color:#98a3b5; }
.appr-edit { display:inline-flex; align-items:center; gap:6px;
             padding:6px 12px; border:1px solid #dbe1ea; border-radius:7px;
             background:#fff; color:#3d4756; font-size:12px; cursor:pointer; }
.appr-edit:hover { border-color:#2f6bff; color:#2f6bff; }

.appr-flow { display:flex; flex-wrap:wrap; align-items:flex-start; gap:12px; }
.appr-flow .sep { color:#c9ced7; font-size:12px; align-self:center;
                  margin-top:-14px; }
/* 사람 한 칸 : 동그란 이름표 아래 이름 · 소속 */
.pchip { display:flex; flex-direction:column; align-items:center; gap:5px;
         width:74px; text-align:center; }
.pchip .av { width:38px; height:38px; border-radius:50%; background:#2f6bff;
             color:#fff; font-size:14px; font-weight:700; display:flex;
             align-items:center; justify-content:center; }
.pchip .nm { font-size:12px; font-weight:700; color:#2b3444; }
.pchip .rl { font-size:10.5px; color:#8b94a3; line-height:1.35;
             word-break:keep-all; }
.pchip.approval  .av { background:#1f8a4c; }
.pchip.agreement .av { background:#d08a1e; }
.appr-none { font-size:12.5px; color:#9aa3b2; }

.err { color:#d94848; font-size:12px; margin-top:7px; display:none; }

/* ===== 바닥 버튼 ===== */
.foot { border-top:1px solid #e9edf3; padding:15px 24px;
        display:flex; justify-content:flex-end; gap:9px; }
.btn { padding:10px 20px; border-radius:8px; font-size:13px; cursor:pointer;
       border:1px solid #dbe1ea; background:#fff; color:#444;
       text-decoration:none; }
.btn:hover { border-color:#c3ccd8; }
.btn.primary { background:#2f6bff; border-color:#2f6bff; color:#fff;
               font-weight:700; }
.btn.primary:hover { background:#2559dd; border-color:#2559dd; }
</style>
</head>
<body>

<div class="wrap">

      <form id="docForm" method="post"
            action="${pageContext.request.contextPath}/document/write">

              <%-- 이 화면은 휴가 전용이라 문서 종류가 고정이다 --%>
              <input type="hidden" name="documentType" value="VACATION">
              <input type="hidden" name="docId" value="${doc.docId}">

              <%-- 칩으로 고른 값이 여기 담겨서 서버로 간다.
                   칩은 눈에 보이는 버튼일 뿐이고, 실제로 전송되는 건 이 둘이다. --%>
              <input type="hidden" id="vacationTypeId" name="vacation.vacationTypeId" value="">
              <input type="hidden" id="timeUnit"       name="vacation.timeUnit"       value="DAY">

              <%-- 제목은 고른 종류·기간으로 조립해서 넣는다.
                   휴가는 제목이 뻔해서 따로 입력받지 않는다. --%>
              <input type="hidden" id="title" name="title" value="${doc.title}">

              <div class="head">
                      <b>휴가 신청서</b>
                      <a class="x" href="#" onclick="window.close(); return false;">✕</a>
              </div>

              <div class="body">

                      <!-- ===== 문서 제목 ===== -->
                      <div class="doc-title">
                              <h1>휴가신청서</h1>
                              <p>결재 완료 시 자동 차감 · 연차는 잔여일수에서만 차감됩니다</p>
                      </div>

                      <!-- ===== 요약 : 내 정보 + 연차 현황 ===== -->
                      <div class="summary">
                              <div class="card me">
                                      <dl><dt>성명</dt><dd>${loginUser.name}</dd></dl>
                                      <dl><dt>부서</dt><dd>${loginUser.teamName} ${loginUser.departmentName}</dd></dl>
                                      <dl><dt>직급</dt><dd>${empty loginUser.title ? loginUser.position : loginUser.title}</dd></dl>
                                      <dl><dt>사원번호</dt><dd>${loginUser.employeeCode}</dd></dl>
                              </div>

                              <%-- 연차 현황.
                                   employee 테이블엔 remain_leave(잔여) 하나뿐이다.
                                   사용일수는 vacation_request 에서 세야 나오고,
                                   총 부여는 (잔여 + 사용) 으로 거꾸로 구한다.
                                   Controller 가 안 담아주면 '-' 로 나온다. --%>
                              <div class="card leave">
                                      <div class="cap">연차 현황</div>
                                      <div class="stat-row">
                                              <div class="stat total">
                                                      <div class="n">${empty grantedLeave ? '-' : grantedLeave}</div>
                                                      <div class="l">총 부여</div>
                                              </div>
                                              <div class="stat used">
                                                      <div class="n">${empty usedLeave ? '-' : usedLeave}</div>
                                                      <div class="l">사용</div>
                                              </div>
                                              <div class="stat left">
                                                      <div class="n" id="remainLeave">${empty remainLeave ? '-' : remainLeave}</div>
                                                      <div class="l">잔여</div>
                                              </div>
                                      </div>
                              </div>
                      </div>

                      <!-- ===== 휴가 종류 ===== -->
                      <div class="row">
                              <span class="tit">휴가 종류 <span class="req">*</span></span>
                              <div class="chips" id="vacChips">
                                      <%-- vacation_type 표를 그대로 칩으로 그린다.
                                           allow_half_day 가 1 인 종류만 오전·오후 칩이 더 생긴다.
                                           종류를 늘리고 싶으면 표에 행을 넣으면 화면은 저절로 따라온다. --%>
                                      <c:forEach items="${vacationTypes}" var="vt">
                                              <button type="button" class="vchip"
                                                      data-type="${vt.vacationTypeId}"
                                                      data-unit="DAY"
                                                      data-deduct="${vt.deductBalance}">
                                                      ${vt.typeName} (1일)
                                              </button>

                                              <c:if test="${vt.allowHalfDay}">
                                                      <button type="button" class="vchip"
                                                              data-type="${vt.vacationTypeId}"
                                                              data-unit="HALF_AM"
                                                              data-deduct="${vt.deductBalance}">
                                                              ${vt.typeName} 반차(오전) (0.5일)
                                                      </button>
                                                      <button type="button" class="vchip"
                                                              data-type="${vt.vacationTypeId}"
                                                              data-unit="HALF_PM"
                                                              data-deduct="${vt.deductBalance}">
                                                              ${vt.typeName} 반차(오후) (0.5일)
                                                      </button>
                                              </c:if>
                                      </c:forEach>
                              </div>
                              <c:if test="${empty vacationTypes}">
                                      <p class="appr-none">휴가 종류가 없습니다. vacation_type 표를 확인하세요.</p>
                              </c:if>
                              <p class="err" id="typeErr">휴가 종류를 선택해주세요.</p>
                      </div>

                      <!-- ===== 기간 ===== -->
                      <div class="row">
                              <div class="pair">
                                      <div>
                                              <span class="tit">시작일 <span class="req">*</span></span>
                                              <input type="date" id="startDate" name="vacation.startDate"
                                                     value="${doc.vacation.startDate}">
                                      </div>
                                      <div>
                                              <span class="tit">종료일 <span class="req">*</span></span>
                                              <input type="date" id="endDate" name="vacation.endDate"
                                                     value="${doc.vacation.endDate}">
                                      </div>
                              </div>

                              <%-- 화면 계산은 미리보기일 뿐이다. name 이 없으므로 서버로 안 간다.
                                   저장되는 숫자는 서버가 시작일·종료일로 다시 계산한다. --%>
                              <div class="days-box" id="daysBox">
                                      <span class="num" id="daysNum">0</span>
                                      <span class="unit">일</span>
                                      <span class="calc" id="daysCalc">기간을 선택하면 계산됩니다 (주말 제외)</span>
                              </div>
                              <p class="err" id="dateErr">휴가 기간을 올바르게 선택해주세요.</p>
                      </div>

                      <!-- ===== 사유 ===== -->
                      <div class="row">
                              <label class="tit" for="reason">휴가 사유 <span class="opt">(선택)</span></label>
                              <textarea id="reason" name="vacation.reason" maxlength="255"
                                        placeholder="예: 개인 사유, 가족 행사, 병원 진료...">${doc.vacation.reason}</textarea>
                      </div>

                      <!-- ===== 연락처 · 대행자 (추후구현) =====
                           vacation_request 에 해당 컬럼이 없다. 화면에만 있는 칸이라
                           입력해도 저장되지 않으므로 아예 못 쓰게 막아둔다. -->
                      <div class="row">
                              <div class="pair">
                                      <div class="soon" data-tip="추후 구현 예정 — 저장할 컬럼이 없습니다">
                                              <span class="tit">휴가 중 연락처 <span class="opt">(선택)</span></span>
                                              <input type="text" placeholder="010-1234-5678" disabled>
                                      </div>
                                      <div class="soon" data-tip="추후 구현 예정 — 저장할 컬럼이 없습니다">
                                              <span class="tit">업무 대행자 <span class="opt">(선택)</span></span>
                                              <input type="text" placeholder="이름 입력" disabled>
                                      </div>
                              </div>
                      </div>

                      <!-- ===== 결재선 =====
                           documentForm.jsp 와 같은 배열·같은 setApprovalLine() 을 쓴다.
                           그래서 결재선 팝업은 손댈 필요가 없다. -->
                      <div class="row">
                              <div class="appr-card">
                                      <div class="appr-head">
                                              <span class="cap">결재선</span>
                                              <button type="button" class="appr-edit" id="btnApprovalLine">
                                                      <span>👥</span> 결재선 편집
                                              </button>
                                      </div>
                                      <div class="appr-flow" id="apprFlow">
                                              <span class="appr-none">아직 지정되지 않았습니다</span>
                                      </div>
                              </div>
                              <p class="err" id="apprErr">상신하려면 결재선을 지정해주세요.</p>

                              <%-- 결재선은 JS 배열로만 들고 있어서 그냥 두면 서버로 안 간다.
                                   renderApprHidden() 이 결재자 수만큼 hidden 을 다시 그린다.
                                   보내는 건 '누구를 골랐나' 뿐 — 순서·상태는 서버가 정한다. --%>
                              <div id="apprHidden"></div>
                      </div>

              </div>

              <div class="foot">
                      <a class="btn" href="#" onclick="window.close(); return false;">취소</a>
                      <button type="submit" class="btn" id="btnSaveDraft">임시저장</button>
                      <button type="submit" class="btn primary" id="btnSubmitDoc"
                              formaction="${pageContext.request.contextPath}/document/submit">휴가 신청</button>
              </div>

      </form>
</div>

<script>
$(document).ready(function() {

      var t = new Date();
      var pad = function(n) { return (n < 10 ? '0' : '') + n; };
      var todayStr = t.getFullYear() + '-' + pad(t.getMonth() + 1) + '-' + pad(t.getDate());

      // 지난 날짜로는 휴가를 낼 수 없다 (직접 입력은 통과되므로 submit 에서 또 막는다)
      $('#startDate, #endDate').attr('min', todayStr);

      /* ═══════════════ 결재선 ═══════════════
         approvalLine 배열이 유일한 기준이고 화면은 항상 이 배열을 따라 다시 그린다.
         documentForm.jsp 와 같은 함수 이름을 쓴다 — 결재선 팝업이 이 이름으로 부른다. */
      var approvalLine = [];
      var drafterName  = '${loginUser.name}';

      function makePersonChip(name, sub, kind) {
              var $c = $('<span class="pchip"></span>').addClass(kind || '');
              $('<span class="av"></span>').text((name || '?').substring(0, 1)).appendTo($c);
              $('<span class="nm"></span>').text(name || '').appendTo($c);
              $('<span class="rl"></span>').text(sub || '').appendTo($c);
              return $c;
      }

      function renderApprFlow() {
              var $flow = $('#apprFlow').empty();

              if (approvalLine.length === 0) {
                      $flow.append('<span class="appr-none">아직 지정되지 않았습니다</span>');
                      return;
              }

              var drafterSub = '${empty loginUser.title ? loginUser.position : loginUser.title}';
              $flow.append(makePersonChip(drafterName, drafterSub + ' · 기안자', ''));

              $.each(approvalLine, function(i, a) {
                      // roleCode 는 팝업이 넘겨준 APPROVAL / AGREEMENT
                      var kind = (a.roleCode === 'AGREEMENT') ? 'agreement' : 'approval';
                      var role = (a.roleCode === 'AGREEMENT') ? '합의' : '승인';
                      $flow.append('<span class="sep">›</span>');
                      $flow.append(makePersonChip(a.name, (a.position || '') + ' · ' + role, kind));
              });
      }

      /* 결재선을 서버로 넘길 hidden 을 다시 그린다.
         지우지 않고 덧붙이면 편집으로 뺀 사람이 그대로 저장된다. */
      function renderApprHidden() {
              var $box = $('#apprHidden').empty();

              $.each(approvalLine, function(i, a) {
                      $('<input type="hidden">')
                              .attr('name', 'approvalLine[' + i + '].approverId')
                              .val(a.employeeId)
                              .appendTo($box);
              });
      }

      // 결재선 팝업이 부르는 함수. 이름을 documentForm.jsp 와 똑같이 맞춰야 한다.
      window.setApprovalLine = function(list) {
              approvalLine = list || [];
              renderApprFlow();
              renderApprHidden();
              $('#apprErr').hide();
      };

      // 팝업이 뜰 때 '지금까지 고른 결재선'을 읽어가서 편집 상태로 시작한다
      window.getApprovalLine = function() {
              return approvalLine;
      };

      $('#btnApprovalLine').on('click', function() {
              var url = '${pageContext.request.contextPath}/approval/line';
              var w = 980, h = 760;

              // 모니터 기준 정중앙. 이 창 자체가 팝업이라 창 기준으로 잡으면 따라다닌다.
              var sx = (screen.availLeft !== undefined) ? screen.availLeft : 0;
              var sy = (screen.availTop  !== undefined) ? screen.availTop  : 0;
              var left = sx + Math.max(0, Math.round((screen.availWidth  - w) / 2));
              var top  = sy + Math.max(0, Math.round((screen.availHeight - h) / 2));

              var win = window.open(url, 'approvalLine',
                              'width=' + w + ',height=' + h
                              + ',left=' + left + ',top=' + top
                              + ',resizable=yes,scrollbars=yes');
              if (win) { win.focus(); }
      });

      renderApprFlow();
      renderApprHidden();

      // 문서 종류별 추천 결재선. VACATION 은 두 단계 위까지 올라간다.
      var recLine = [
        <c:forEach items="${recLine}" var="m" varStatus="st">
          {
            employeeId : ${m.employeeId},
            name       : '${m.name}',
            position   : '${empty m.title ? m.position : m.title}',
            dept       : '${m.teamName}',
            roleCode   : 'APPROVAL'
          }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
      ];
      if (recLine.length > 0) {
              setApprovalLine(recLine);
      }

      /* ═══════════════ 휴가 종류 칩 ═══════════════
         칩 하나 = 휴가종류 + 시간단위 한 쌍.
         고른 값은 hidden 두 개(vacationTypeId, timeUnit)에 담겨 서버로 간다. */
      function isHalf() { return $('#timeUnit').val() !== 'DAY'; }

      $('#vacChips').on('click', '.vchip', function() {
              $('.vchip').removeClass('on');
              $(this).addClass('on');

              $('#vacationTypeId').val($(this).data('type'));
              $('#timeUnit').val($(this).data('unit'));
              $('#typeErr').hide();

              // 반차는 하루짜리다. 종료일을 시작일에 맞춰 붙여준다.
              if (isHalf() && $('#startDate').val() !== '') {
                      $('#endDate').val($('#startDate').val());
              }

              recalc();
              syncTitle();
      });

      /* ═══════════════ 일수 계산 ═══════════════
         ⚠ 미리보기다. 저장되는 숫자는 서버가 다시 계산한다 —
            화면 값은 개발자도구로 얼마든지 바꿀 수 있기 때문이다.
         규칙 : 시작일부터 종료일까지 하루씩 세면서 토·일은 뺀다.
                공휴일은 표가 없어서 아직 못 뺀다. */
      function countWorkDays(from, to) {
              var d   = new Date(from);
              var end = new Date(to);
              var n   = 0;

              while (d <= end) {
                      var w = d.getDay();          // 0 = 일요일, 6 = 토요일
                      if (w !== 0 && w !== 6) { n++; }
                      d.setDate(d.getDate() + 1);  // 하루 앞으로
              }
              return n;
      }

      function recalc() {
              var s = $('#startDate').val();
              var e = $('#endDate').val();
              var $box = $('#daysBox').removeClass('warn');

              if (s === '' || e === '') {
                      $('#daysNum').text('0');
                      $('#daysCalc').text('기간을 선택하면 계산됩니다 (주말 제외)');
                      return 0;
              }

              if (e < s) {
                      $('#daysNum').text('0');
                      $('#daysCalc').text('종료일이 시작일보다 빠릅니다');
                      $box.addClass('warn');
                      return 0;
              }

              var days = countWorkDays(s, e);

              // 반차는 하루짜리에만 쓸 수 있으므로 0.5 는 s === e 일 때만 나온다
              if (isHalf()) { days = (s === e && days === 1) ? 0.5 : days; }

              if (days === 0) {
                      $('#daysNum').text('0');
                      $('#daysCalc').text('주말만 선택되어 사용 일수가 없습니다');
                      $box.addClass('warn');
                      return 0;
              }

              $('#daysNum').text(days);
              $('#daysCalc').text('주말 제외 · 공휴일은 아직 반영되지 않습니다');
              return days;
      }

      /* 제목은 고른 값으로 조립한다. 휴가는 제목이 뻔해서 입력칸을 두지 않았다.
         예) 연차 신청 (2026-08-13) / 연차 신청 (2026-08-13 ~ 2026-08-15) */
      function syncTitle() {
              var $on = $('.vchip.on');
              var s = $('#startDate').val();
              var e = $('#endDate').val();

              if ($on.length === 0 || s === '') { return; }

              // 칩 글자에서 "(1일)" 같은 꼬리를 떼어 이름만 남긴다
              var label = $on.text().trim().replace(/\s*\(.*?\)\s*$/, '');
              var range = (e === '' || s === e) ? s : (s + ' ~ ' + e);

              $('#title').val(label + ' 신청 (' + range + ')');
      }

      $('#startDate').on('change', function() {
              var s = $(this).val();
              $('#endDate').attr('min', s || todayStr);

              // 반차이거나 종료일이 시작일보다 앞서면 종료일을 붙여준다
              if (isHalf() || $('#endDate').val() === '' || $('#endDate').val() < s) {
                      $('#endDate').val(s);
              }
              $('#dateErr').hide();
              recalc();
              syncTitle();
      });

      $('#endDate').on('change', function() {
              // 반차인데 종료일을 다른 날로 바꾸면 반차가 성립하지 않는다
              if (isHalf() && $(this).val() !== $('#startDate').val()) {
                      $('.vchip.on').removeClass('on');
                      $('#vacationTypeId').val('');
                      $('#timeUnit').val('DAY');
                      alert('반차는 하루만 쓸 수 있습니다. 휴가 종류를 다시 골라주세요.');
              }
              $('#dateErr').hide();
              recalc();
              syncTitle();
      });

      recalc();

      $('#docForm').on('submit', function() {
              $('.err').hide();

              // 임시저장과 휴가신청이 이 핸들러를 같이 탄다.
              // 결재선 검사는 신청(상신)일 때만 — 임시저장은 결재선 없이도 쟁여둘 수 있다.
              var isSubmitDoc = (event
                              && event.submitter
                              && event.submitter.id === 'btnSubmitDoc');

              var msgs  = [];
              var first = null;

              if ($('#vacationTypeId').val() === '') {
                      $('#typeErr').show();
                      msgs.push('휴가 종류를 선택해 주세요.');
                      first = first || function() { $('.vchip').first().focus(); };
              }

              var s  = $('#startDate').val();
              var en = $('#endDate').val();

              if (s === '' || en === '') {
                      $('#dateErr').text('휴가 기간을 선택해주세요.').show();
                      msgs.push('휴가 기간을 선택해 주세요.');
                      first = first || function() { $('#startDate').focus(); };
              } else if (en < s) {
                      $('#dateErr').text('종료일은 시작일보다 빠를 수 없습니다.').show();
                      msgs.push('휴가 종료일을 확인해 주세요.');
                      first = first || function() { $('#endDate').focus(); };
              } else if (s < todayStr) {
                      // 달력의 min 은 UI 만 막는다. 직접 입력하면 통과되므로 여기서 또 본다.
                      $('#dateErr').text('지난 날짜로는 휴가를 신청할 수 없습니다.').show();
                      msgs.push('휴가 시작일은 오늘 이후로 지정해 주세요.');
                      first = first || function() { $('#startDate').focus(); };
              } else if (recalc() === 0) {
                      $('#dateErr').text('사용 일수가 0일입니다. 기간을 다시 선택해주세요.').show();
                      msgs.push('선택한 기간에 근무일이 없습니다.');
                      first = first || function() { $('#startDate').focus(); };
              }

              if (isSubmitDoc && approvalLine.length === 0) {
                      $('#apprErr').show();
                      msgs.push('결재선을 먼저 지정해 주세요.');
                      first = first || function() { $('#btnApprovalLine').focus(); };
              }

              if (msgs.length > 0) {
                      alert(msgs.join('\n'));
                      if (first) { first(); }
                      return false;
              }

              syncTitle();   // 마지막으로 한 번 더 맞춰서 보낸다
              return true;
      });
});
</script>

</body>
</html>
