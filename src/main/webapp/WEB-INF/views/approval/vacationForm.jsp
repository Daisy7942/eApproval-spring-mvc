<%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
/* 긴급 문서 토글. documentForm.jsp 와 같은 모양으로 맞췄다.
   기본 체크박스는 숨기고 옆 chip 을 대신 보여준다 — 기본 회색, 체크했을 때만 빨강. */
.head-left { display:flex; align-items:center; gap:14px; }
.head-left .urgent { position:relative; cursor:pointer;
                     -webkit-user-select:none; user-select:none; }
.head-left .urgent input { position:absolute; opacity:0;
                           width:0; height:0; pointer-events:none; }
.head-left .urgent .chip { display:inline-flex; align-items:center; gap:6px;
                     font-size:12px; padding:5px 12px; border-radius:20px;
                     border:1px solid #e0e5ec; background:#f7f8fa; color:#8b94a3;
                     transition:background .12s, border-color .12s, color .12s; }
.head-left .urgent .chip .dot { width:6px; height:6px; border-radius:50%;
                     background:#c4cbd6; transition:background .12s, box-shadow .12s; }
.head-left .urgent:hover .chip { border-color:#cfd6e0; color:#6b7686; }
.head-left .urgent input:checked + .chip { background:#fdf0f0; border-color:#f2c9c9;
                     color:#d94848; font-weight:700; }
.head-left .urgent input:checked + .chip .dot { background:#e5484d;
                     box-shadow:0 0 0 3px rgba(229,72,77,.18); }
.head-left .urgent input:focus-visible + .chip { border-color:#2f6bff;
                     box-shadow:0 0 0 3px rgba(47,107,255,.15); }

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
/* 대기 = 아직 결재가 안 끝난 것. 승인되면 잔여에서 깎인다 (leaveMy.jsp 와 같은 주황) */
.stat.wait  { background:#fff8ec; } .stat.wait  .n { color:#b26a00; }
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
/* 칩 크기를 글자 길이에 맡기지 않는다. 격자 한 칸 = 칩 하나라
   "연차"든 "연차 반차(오전)"든 폭·높이가 같다.
   종류 11개가 두 줄에 떨어지도록 한 줄에 6칸씩 놓는다. */
.chips { display:grid; grid-template-columns:repeat(6, 1fr); gap:7px; }
.vchip { display:flex; align-items:center; justify-content:center;
         min-height:34px; padding:6px 8px; width:100%;
         border:1px solid #dbe1ea; border-radius:7px;
         background:#fff; color:#3d4756; font-size:11.5px; cursor:pointer;
         white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
         transition:background .12s, border-color .12s, color .12s; }
.vchip:hover { border-color:#b9c8e8; color:#2f6bff; }
.vchip.on { background:#2f6bff; border-color:#2f6bff; color:#fff;
            font-weight:700; }
/* 선택한 휴가 종류 설명.
   문구 길이에 따라 카드가 커지면 옆 카드와 높이가 어긋난다.
   그래서 두 줄 높이로 고정하고 넘치면 … 로 자른다. */
.type-desc { margin:10px 0 0; font-size:11px; line-height:1.5; color:#6b7686;
             height:33px; overflow:hidden; display:-webkit-box;
             -webkit-line-clamp:2; -webkit-box-orient:vertical; }

/* 지난 날짜를 고른 칸. 막는 게 아니라 눈에 띄게만 한다.
   달력 안의 날짜 하나하나는 브라우저가 그려서 색을 못 바꾼다 — 칸 전체를 회색으로. */
.row input[type=date].past { background:#f2f4f8; color:#8b94a3;
                             border-color:#d7dde7; }

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

/* ===== 첨부파일 (껍데기) ===== */
.file-box { display:flex; align-items:center; gap:10px; padding:9px 12px;
            border:1px dashed #d7dde7; border-radius:8px; background:#f7f8fa; }
.file-btn { border:1px solid #d7dde7; border-radius:6px; background:#fff;
            color:#b4bcc9; font-size:12px; padding:5px 12px; }
.file-none { color:#b4bcc9; font-size:12px; }
.file-help { color:#9aa3b2; font-size:11px; margin:6px 0 0; }

/* ===== 결재선 =====
   documentForm.jsp 와 같은 모양으로 맞춘다. 두 화면의 결재선은
   같은 배열·같은 팝업을 쓰므로 생김새도 같아야 헷갈리지 않는다. */
.todo { border:1px dashed #d5dbe5; border-radius:8px; padding:14px;
        background:#fafbfd; display:flex; align-items:center; gap:10px; }
.todo .ghost { padding:7px 14px; border:1px solid #dbe1ea; border-radius:6px;
               background:#fff; color:#3d4756; font-size:13px; cursor:pointer; }
.todo .ghost:hover { border-color:#2f6bff; color:#2f6bff; }
.todo .note { font-size:11px; color:#a5aebd; }

/* 왼쪽 묶음(제목 + 방식 뱃지). space-between 이라 묶지 않으면 셋이 흩어진다 */
.appr-head-l { display:flex; align-items:center; gap:8px; }
/* 결재 방식 뱃지. 팝업에서 고르고 나면 지금까지 화면 어디에도 안 보였다.
   순차는 파랑, 병렬은 보라 — 아래 흐름의 구분자와 색을 맞춘다 */
.appr-mode { font-size:11.5px; border-radius:4px; padding:3px 9px;
             background:#eef2fb; color:#4a5a7a; white-space:nowrap; }
.appr-mode.parallel { background:#f3ecfd; color:#7c4dcc; }
.appr-head { display:flex; justify-content:space-between; align-items:center;
             margin-bottom:10px; }
.appr-edit { display:inline-flex; align-items:center; gap:6px;
             padding:7px 14px; border:1px solid #dbe1ea; border-radius:8px;
             background:#fff; color:#3d4756; font-size:12.5px; cursor:pointer; }
.appr-edit:hover { border-color:#2f6bff; color:#2f6bff; }

.appr-flow { display:flex; flex-wrap:wrap; align-items:center; gap:8px; }
.appr-flow .sep { color:#c9ced7; font-size:11px; }
.appr-flow .none { font-size:12px; color:#a5aebd; }

/* 사람 한 칸 : 동그란 이름표 + 이름 + 역할 */
.pchip { display:inline-flex; align-items:center; gap:8px;
         border:1px solid #dbe4f5; background:#f2f6ff; border-radius:10px;
         padding:7px 13px 7px 8px; }
.pchip .av { width:26px; height:26px; border-radius:50%; background:#2f6bff;
             color:#fff; font-size:11px; display:flex;
             align-items:center; justify-content:center; flex:none; }
.pchip .nm { font-size:12.5px; font-weight:700; color:#2b3444; line-height:1.25; }
.pchip .rl { font-size:10.5px; color:#8b94a3; }
.pchip.approval  { border-color:#bfe6cd; background:#eefaf2; }
.pchip.approval  .av { background:#1f8a4c; }
.pchip.agreement { border-color:#f2ddb8; background:#fdf7ec; }
.pchip.agreement .av { background:#d08a1e; }

.err { color:#d94848; font-size:12px; margin-top:7px; display:none; }
/* 칸 아래 설명 한 줄. documentForm.jsp 와 같은 이름·같은 모양으로 둔다 —
   두 화면이 같은 칸을 다르게 그리면 같은 기능으로 안 읽힌다 */
.hint { font-size:11px; color:#a5aebd; margin-top:6px; }
/* 오류가 아니라 안내다. 붉은색 대신 회색으로 조용히 알린다. */
.half-info { color:#8b94a3; font-size:11.5px; margin-top:7px; display:none; }

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

      <%-- 반려 문서를 고치는 중인가(재상신). 이 화면은 그때 두 가지가 달라진다 —
           나갈 곳이 상신함이고, 임시저장 버튼이 없다 --%>
      <c:set var="isRedraft" value="${doc.status eq 'REJECTED'}" />

      <%-- 이 화면을 그냥 나갔을 때 돌아갈 곳.
           재상신 중이면 그 문서는 status 가 REJECTED 그대로라 임시저장함에 없다 —
           거기로 보내면 방금 보던 문서를 못 찾는다.
           새 문서·임시저장 문서는 지금까지처럼 임시저장함으로 --%>
      <c:set var="backUrl"
             value="${isRedraft ? '/document/submitted' : '/document/drafts'}" />

      <form id="docForm" method="post"
            action="${pageContext.request.contextPath}/document/write">

              <%-- 이 화면은 휴가 전용이라 문서 종류가 고정이다 --%>
              <input type="hidden" name="documentType" value="VACATION">
              <input type="hidden" name="docId" value="${doc.docId}">

              <%-- 칩은 눈에 보이는 버튼일 뿐이고, 실제로 전송되는 건 이 셋이다.
                   반차 칩을 고르면 startHalf 에 AM/PM 이 담긴다. 하루짜리라 endHalf 는 비운다.
                   (DB 는 양끝 반차를 담을 수 있게 돼 있으니 화면만 나중에 늘리면 된다) --%>
              <input type="hidden" id="vacationTypeId" name="vacation.vacationTypeId" value="">
              <input type="hidden" id="startHalf"      name="vacation.startHalf"      value="">
              <input type="hidden" id="endHalf"        name="vacation.endHalf"        value="">

              <%-- 제목은 고른 종류·기간으로 조립해서 넣는다.
                   휴가는 제목이 뻔해서 따로 입력받지 않는다. --%>
              <input type="hidden" id="title" name="title" value="${doc.title}">

              <%-- 본문도 입력칸이 없다. 고른 값으로 조립해서 넣는다.
                   상세보기의 본문 칸에 그대로 찍히는 글이다. --%>
              <input type="hidden" id="content" name="content" value="${doc.content}">

              <div class="head">
                      <%-- 긴급 여부는 document 표의 is_urgent 다. 휴가 고유값이 아니라
                           모든 문서가 공통으로 갖는 값이라 documentForm.jsp 와 이름·모양을 맞춘다. --%>
                      <div class="head-left">
                              <b>휴가 신청서</b>
                              <label class="urgent"
                                     title="긴급 문서로 지정하면 결재자에게 우선 표시됩니다">
                                      <input type="checkbox" name="isUrgent" value="true" ${doc.isUrgent ? 'checked' : ''}>
                                      <span class="chip"><span class="dot"></span>긴급</span>
                              </label>
                      </div>
                      <a class="x" href="${pageContext.request.contextPath}${backUrl}"
                         onclick="if (window.opener) { window.close(); return false; }">✕</a>
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
                                   Controller 가 getLeaveSummary(empId) 를 summary 로 담아준다.
                                   실컬럼은 remain_leave(잔여) 하나뿐이고
                                   사용은 vacation_request 를 세서, 총부여는 (잔여+사용) 으로 나온다.
                                   휴가 현황 화면(leaveMy.jsp)과 똑같은 숫자다.
                                   세션이 아니라 요청마다 DB 를 읽으므로 승인 직후에도 값이 맞다. --%>
                              <div class="card leave">
                                      <div class="cap" id="leaveCap">연차 현황</div>
                                      <div class="stat-row">
                                              <div class="stat total">
                                                      <div class="n" id="statGrant"><c:choose><c:when test="${empty summary}">-</c:when><c:otherwise><fmt:formatNumber value="${summary.totalDays}" maxFractionDigits="1"/></c:otherwise></c:choose></div>
                                                      <div class="l" id="statGrantLabel">부여</div>
                                              </div>
                                              <div class="stat used">
                                                      <div class="n" id="statUsed"><c:choose><c:when test="${empty summary}">-</c:when><c:otherwise><fmt:formatNumber value="${summary.usedDays}" maxFractionDigits="1"/></c:otherwise></c:choose></div>
                                                      <div class="l">사용</div>
                                              </div>
                                              <div class="stat wait">
                                                      <div class="n" id="statWait"><c:choose><c:when test="${empty summary}">-</c:when><c:otherwise><fmt:formatNumber value="${summary.pendingDays}" maxFractionDigits="1"/></c:otherwise></c:choose></div>
                                                      <div class="l">대기</div>
                                              </div>
                                              <div class="stat left">
                                                      <div class="n" id="statLeft"><c:choose><c:when test="${empty summary}">-</c:when><c:otherwise><fmt:formatNumber value="${summary.remainDays}" maxFractionDigits="1"/></c:otherwise></c:choose></div>
                                                      <div class="l">잔여</div>
                                              </div>
                                      </div>

                                      <%-- 고른 종류의 vacation_type.description 이 여기 뜬다.
                                           문구는 DB 에 있으므로 바뀌어도 JSP 를 안 고친다. --%>
                                      <p class="type-desc" id="typeDesc">휴가 종류를 선택하면 안내와 부여일수가 표시됩니다.</p>
                              </div>
                      </div>

                      <!-- ===== 휴가 종류 ===== -->
                      <div class="row">
                              <span class="tit">휴가 종류 <span class="req">*</span></span>
                              <div class="chips" id="vacChips">
                                      <%-- vacation_type 표를 그대로 칩으로 그린다.
                                           allow_half_day 가 1 인 종류만 오전·오후 칩이 더 생긴다.
                                           data-half 가 그대로 vacation_request.start_half 로 간다. --%>
                                      <c:forEach items="${vacationTypes}" var="vt">
                                              <button type="button" class="vchip"
                                                      data-type="${vt.vacationTypeId}"
                                                      data-deduct="${vt.deductBalance}"
                                                      data-half=""
                                                      data-days="${vt.defaultDays}"
                                                      data-desc="${fn:escapeXml(vt.description)}">
                                                      ${vt.typeName}
                                              </button>

                                              <c:if test="${vt.allowHalfDay}">
                                                      <button type="button" class="vchip"
                                                              data-type="${vt.vacationTypeId}"
                                                              data-deduct="${vt.deductBalance}"
                                                              data-half="AM"
                                                              data-days="${vt.defaultDays}"
                                                              data-desc="${fn:escapeXml(vt.description)}">
                                                              ${vt.typeName} 반차(오전)
                                                      </button>
                                                      <button type="button" class="vchip"
                                                              data-type="${vt.vacationTypeId}"
                                                              data-deduct="${vt.deductBalance}"
                                                              data-half="PM"
                                                              data-days="${vt.defaultDays}"
                                                              data-desc="${fn:escapeXml(vt.description)}">
                                                              ${vt.typeName} 반차(오후)
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
                              <p class="half-info" id="halfInfo"></p>
                              <p class="err" id="dateErr">휴가 기간을 올바르게 선택해주세요.</p>
                      </div>

                      <!-- ===== 사유 ===== -->
                      <div class="row">
                              <label class="tit" for="reason">휴가 사유 <span class="req">*</span></label>
                              <textarea id="reason" name="vacation.reason" maxlength="255"
                                        placeholder="예: 개인 사유, 가족 행사, 병원 진료...">${doc.vacation.reason}</textarea>
                              <p class="err" id="reasonErr">휴가 사유를 입력해주세요.</p>
                      </div>

                      <!-- ===== 첨부파일 (추후구현) =====
                           attachment 테이블은 있지만 업로드 처리가 없다.
                           form 에 enctype 도 없어서 파일은 서버로 가지 않는다. -->
                      <div class="row">
                              <label class="tit">첨부파일 <span class="opt">(선택)</span></label>
                              <div class="file-box soon" data-tip="추후 구현 예정">
                                      <span class="file-btn">파일 선택</span>
                                      <span class="file-none">선택된 파일 없음</span>
                              </div>
                              <p class="file-help">진단서·청첩장 등 증빙서류를 첨부할 수 있습니다. (최대 10MB)</p>
                      </div>

                      <!-- ===== 연락처 · 대행자 (추후구현) =====
                           vacation_request 에 해당 컬럼이 없다. 화면에만 있는 칸이라
                           입력해도 저장되지 않으므로 아예 못 쓰게 막아둔다. -->
                      <div class="row">
                              <div class="pair">
                                      <div class="soon" data-tip="추후 구현 예정">
                                              <span class="tit">휴가 중 연락처 <span class="opt">(선택)</span></span>
                                              <input type="text" placeholder="010-1234-5678" disabled>
                                      </div>
                                      <div class="soon" data-tip="추후 구현 예정">
                                              <span class="tit">업무 대행자 <span class="opt">(선택)</span></span>
                                              <input type="text" placeholder="이름 입력" disabled>
                                      </div>
                              </div>
                      </div>

                      <!-- ===== 결재선 =====
                           documentForm.jsp 와 같은 배열·같은 setApprovalLine() 을 쓴다.
                           그래서 결재선 팝업은 손댈 필요가 없다. -->
                      <div class="row">
                              <%-- ① 아직 아무도 안 골랐을 때 : 점선 상자 --%>
                              <div id="apprEmpty">
                                      <label class="tit">결재선</label>
                                      <div class="todo">
                                              <button type="button" class="ghost" id="btnApprovalLine">＋ 결재선 지정</button>
                                              <span class="note">아직 지정되지 않았습니다</span>
                                      </div>
                              </div>

                              <%-- ② 골랐을 때 : 기안자 ▸ 결재자… 흐름 --%>
                              <div id="apprPicked" style="display:none;">
                                      <div class="appr-head">
                                              <div class="appr-head-l">
                                                      <label class="tit" style="margin:0;">결재선 설정</label>
                                                      <%-- 순차/병렬은 결재선 팝업에서 고르는데, 닫고 나면
                                                           고른 값이 화면 어디에도 안 남아서 확인할 방법이 없었다 --%>
                                                      <span class="appr-mode" id="apprMode"></span>
                                              </div>
                                              <button type="button" class="appr-edit" id="btnApprovalLineEdit">
                                                      <span>👥</span> 결재선 편집
                                              </button>
                                      </div>
                                      <div class="appr-flow" id="apprFlow"></div>
                              </div>
                              <p class="err" id="apprErr">상신하려면 결재선을 지정해주세요.</p>

                              <%-- 결재선은 JS 배열로만 들고 있어서 그냥 두면 서버로 안 간다.
                                   renderApprHidden() 이 결재자 수만큼 hidden 을 다시 그린다.
                                   보내는 건 '누구를 골랐나' 뿐 — 순서·상태는 서버가 정한다. --%>
                              <div id="apprHidden"></div>
                      </div>

                      <%-- ===== 결재 마감일 =====
                           document.due_date 는 문서 공통 칸인데 이 화면에만 빠져 있었다.
                           칸이 없으면 값이 안 실려 와서, 마감일을 넣어 둔 휴가 문서를
                           여기서 한 번만 저장해도 due_date 가 null 로 덮어써진다.
                           휴가 기간(startDate·endDate)과는 아무 상관 없는 값이다 —
                           저건 '언제 쉬는가', 이건 '언제까지 결재를 받아야 하는가'다.
                           documentForm.jsp 와 이름·모양을 똑같이 맞춰 뒀다 --%>
                      <div class="row">
                              <label class="tit" for="dueDate">결재 마감일 <span class="opt">(선택)</span></label>
                              <input type="date" id="dueDate" name="dueDate" value="${doc.dueDate}">
                              <p class="hint">언제까지 결재를 받아야 하는지 지정합니다. 비워두면 마감일 없이 진행됩니다.</p>
                              <p class="err" id="dueDateErr">마감일은 오늘 이후로 지정해주세요.</p>
                      </div>

              </div>

              <div class="foot">
                      <%-- 팝업으로 열렸으면 창을 닫는다. 문서수정·재상신처럼 같은 탭으로 들어온
                           경우엔 닫을 창이 없어 아무 일도 안 일어나므로 backUrl 로 보낸다 --%>
                      <a class="btn" href="${pageContext.request.contextPath}${backUrl}"
                         onclick="if (window.opener) { window.close(); return false; }">취소</a>
                      <%-- 재상신 중에는 임시저장을 주지 않는다. 반려 문서는 상태가 REJECTED 라
                           임시저장함에 들어가지도 않고, 저장해 봐야 다음 회차 결재선만 미리 깔려서
                           결재자 도장판에서 반려 도장이 사라진다.
                           고쳐서 바로 올리거나, 그만두거나 둘 중 하나다 --%>
                      <c:if test="${not isRedraft}">
                              <button type="submit" class="btn" id="btnSaveDraft">임시저장</button>
                      </c:if>
                      <button type="submit" class="btn primary" id="btnSubmitDoc"
                              formaction="${pageContext.request.contextPath}/document/submit">${isRedraft ? '휴가 재신청' : '휴가 신청'}</button>
              </div>

      </form>
</div>

<script>
$(document).ready(function() {

      var t = new Date();
      var pad = function(n) { return (n < 10 ? '0' : '') + n; };
      var todayStr = t.getFullYear() + '-' + pad(t.getMonth() + 1) + '-' + pad(t.getDate());

      /* 결재 마감일은 휴가 기간과 달리 지난 날짜를 열어둘 이유가 없다.
         이미 지난 마감일이 채워진 채로 열렸으면(오래 묵은 임시저장) min 을 걸지 않는다 —
         걸면 브라우저가 그 칸을 '유효하지 않음'으로 잡아 임시저장 버튼조차 안 먹는다. */
      if (!$('#dueDate').val() || $('#dueDate').val() >= todayStr) {
              $('#dueDate').attr('min', todayStr);
      }
      $('#dueDate').on('input change', function() { $('#dueDateErr').hide(); });

      /* 지난 날짜도 고를 수 있게 열어둔다.
         급하게 휴가를 쓰고 신청서를 나중에 올리는 경우가 있어서다.
         대신 고르는 순간 알려주고 칸을 회색으로 표시한다. */
      if ($('#startDate').val() === '') { $('#startDate').val(todayStr); }
      if ($('#endDate').val()   === '') { $('#endDate').val(todayStr); }

      function markPast($el) {
              var past = $el.val() !== '' && $el.val() < todayStr;
              $el.toggleClass('past', past);
              return past;
      }

      function warnPast($el) {
              if (markPast($el)) {
                      alert('지난 날짜를 선택했습니다.\n이미 사용한 휴가를 뒤늦게 신청하는 경우에만 사용하세요.');
              }
      }

      /* 연차 잔여는 employee.remain_leave 하나뿐이다. 다른 종류는 담을 칸이 없다.
         세션(loginUser)이 아니라 Controller 가 담아준 summary 를 쓴다 —
         세션 값은 로그인한 순간의 사진이라 휴가가 승인돼 깎여도 그대로이기 때문이다. */
      var annualRemain = '${empty summary ? "" : summary.remainDays}';

      /* 아직 결재가 안 끝난 신청 일수. remain_leave 는 승인될 때만 깎이므로
         대기 중인 것까지 빼야 실제로 쓸 수 있는 연차가 나온다.
         서버(DocumentService)도 같은 식으로 검사한다 — 여기는 미리 알려주는 용도다. */
      var annualPending = '${empty summary ? "" : summary.pendingDays}';

      // 연차 3칸(총부여·사용·잔여)은 전부 summary 값이다. 칩을 눌러도 이 값으로 되돌린다.
      var annualTotal = '${empty summary ? "" : summary.totalDays}';
      var annualUsed  = '${empty summary ? "" : summary.usedDays}';

      /* ═══════════════ 결재선 ═══════════════
         approvalLine 배열이 유일한 기준이고 화면은 항상 이 배열을 따라 다시 그린다.
         documentForm.jsp 와 같은 함수 이름을 쓴다 — 결재선 팝업이 이 이름으로 부른다. */
      var approvalLine = [];

      // 결재 방식 : SEQUENTIAL(순차) / PARALLEL(병렬).
      // 임시저장한 문서를 다시 열면 저장해 둔 값으로 시작한다
      var approvalType = '${empty doc.approvalType ? "SEQUENTIAL" : doc.approvalType}';
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

              // 아직 아무도 안 골랐으면 점선 상자만 보여준다. 둘 중 하나만 켠다.
              if (approvalLine.length === 0) {
                      $('#apprEmpty').show();
                      $('#apprPicked').hide();
                      return;
              }
              $('#apprEmpty').hide();
              $('#apprPicked').show();

              // 결재 방식 뱃지. 팝업에서 고른 값이 여기 말고는 보이는 데가 없다
              var isPar = (approvalType === 'PARALLEL');
              $('#apprMode').text(isPar ? '병렬 결재' : '순차 결재')
                            .toggleClass('parallel', isPar);

              $flow.append(makePersonChip(drafterName, '기안자', ''));

              $.each(approvalLine, function(i, a) {
                      // roleCode 는 팝업이 넘겨준 APPROVAL / AGREEMENT
                      var kind = (a.roleCode === 'AGREEMENT') ? 'agreement' : 'approval';
                      var sub  = [ a.position, a.dept ].filter(function(v) { return v; }).join(' · ');
                      // 기안자 → 첫 결재자는 병렬이어도 순서가 맞으므로 늘 화살표다.
                      // 병렬에서 순서가 없는 건 결재자들끼리이므로 둘째부터 + 로 잇는다
                      //   순차 : 기안자 › 결재자1 › 결재자2
                      //   병렬 : 기안자 › 결재자1 + 결재자2
                      $flow.append('<span class="sep">' + (isPar && i > 0 ? '+' : '›') + '</span>');
                      $flow.append(makePersonChip(a.name, sub || a.role, kind));
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

              // 결재 방식(순차/병렬)도 같이 보낸다. 이게 없으면 서버는 늘 순차로 저장한다
              $('<input type="hidden">')
                      .attr('name', 'approvalType')
                      .val(approvalType)
                      .appendTo($box);
      }

      // 결재선 팝업이 부르는 함수. 이름을 documentForm.jsp 와 똑같이 맞춰야 한다.
      window.setApprovalLine = function(list, mode) {
              approvalLine = list || [];

              // 팝업이 방식을 안 주면(옛 호출) 지금 값을 그대로 둔다
              if (mode) { approvalType = mode; }

              renderApprFlow();
              renderApprHidden();
              $('#apprErr').hide();
      };

      // 팝업이 뜰 때 '지금까지 고른 결재선'을 읽어가서 편집 상태로 시작한다
      window.getApprovalLine = function() {
              return approvalLine;
      };

      // 결재 방식도 같은 이유로 물려준다
      window.getApprovalType = function() {
              return approvalType;
      };

      $('#btnApprovalLine, #btnApprovalLineEdit').on('click', function() {
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
      /* 임시저장 문서를 다시 열었을 때 이미 저장돼 있던 결재선.
         selectDraft 가 approval_line 을 JOIN 해서 doc.approvalLine 에 담아준다.
         화면이 쓰는 이름(employeeId·dept)과 VO 의 이름(approverId·teamName)이 달라 갈아 끼운다. */
      var savedLine = [
        <c:forEach items="${doc.approvalLine}" var="a" varStatus="st">
          {
            employeeId : ${a.approverId},
            name       : '${a.name}',
            position   : '${a.position}',
            dept       : '${a.teamName}',
            roleCode   : 'APPROVAL'
          }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
      ];

      // 저장해 둔 결재선이 우선이다. 추천은 새로 쓸 때만 쓴다.
      if (savedLine.length > 0) {
              setApprovalLine(savedLine);
      } else if (recLine.length > 0) {
              setApprovalLine(recLine);
      }

      /* ═══════════════ 휴가 종류 칩 ═══════════════
         칩 하나 = 휴가 종류 + 반차 여부 한 쌍.
         고른 값은 hidden 셋(vacationTypeId, startHalf, endHalf)에 담겨 서버로 간다. */
      function isHalf() { return $('#startHalf').val() !== ''; }

      $('#vacChips').on('click', '.vchip', function() {
              $('.vchip').removeClass('on');
              $(this).addClass('on');

              $('#vacationTypeId').val($(this).data('type'));
              $('#startHalf').val($(this).data('half'));
              $('#endHalf').val('');          // 반차는 하루짜리라 종료일 쪽은 비운다
              $('#typeErr').hide();
              $('#halfInfo').hide();

              // 반차는 하루짜리다. 종료일을 시작일에 맞춰 붙여준다.
              if (isHalf() && $('#startDate').val() !== '') {
                      $('#endDate').val($('#startDate').val());
              }

              applyType($(this));
              recalc();
              syncTitle();
      });

      /* 처음 고를 칩을 정한다.
         임시저장 문서를 다시 열었으면 그때 골랐던 종류를, 새 문서면 연차(종일)를 고른다.
         값을 직접 넣지 않고 위 클릭 핸들러를 그대로 태운다 —
         그래야 hidden 셋·오른쪽 카드·일수 계산·제목까지 한꺼번에 맞춰진다. */
      var savedType = '${doc.vacation.vacationTypeId}';   // 새 문서면 빈 문자열
      var savedHalf = '${doc.vacation.startHalf}';        // 종일이거나 새 문서면 빈 문자열

      function findChip(type, half) {
              return $('.vchip').filter(function() {
                      return $(this).data('type') === type
                          && ($(this).data('half') || '') === half;
              }).first();
      }

      // 저장된 종류가 있으면 그것만 찾는다. 못 찾으면(종류가 지워졌다든가) 아무것도 고르지 않는다 —
      // 연차로 대신 골라주면 사용자 모르게 신청 내용이 바뀐다.
      var $first = (savedType !== '') ? findChip(savedType, savedHalf)
                                      : findChip('ANNUAL', '');

      $first.trigger('click');

      /* 고른 종류에 맞춰 오른쪽 카드를 바꾼다.
         숫자는 vacation_type.default_days, 문구는 description 이다 — 둘 다 DB 값. */
      function applyType($chip) {
              // 칩 글자에서 "반차(오전)" 꼬리를 떼어 종류 이름만 남긴다
              var name = $chip.text().trim().replace(/\s*반차\(.*?\)\s*$/, '');

              $('#leaveCap').text(name + ' 현황');
              $('#typeDesc').text($chip.data('desc') || '등록된 안내 문구가 없습니다.');

              // 연차만 사람마다 다르다 → employee.remain_leave 를 쓴다.
              // 나머지는 모두에게 같은 법정일수(default_days)다.
              if ($chip.data('type') === 'ANNUAL') {
                      // 서버가 담아준 summary 그대로. 화면 처음 모습과 같아야 한다.
                      $('#statGrant').text(dayText(annualTotal));
                      $('#statUsed').text(dayText(annualUsed));
                      $('#statWait').text(dayText(annualPending));
                      $('#statLeft').text(dayText(annualRemain));
                      $('#statGrantLabel').text('부여'); // 연차는 실제로 받아둔 일수다
              } else {
                      // 나머지는 사람마다 다른 값이 없어 법정일수만 보여준다
                      $('#statGrant').text(dayText($chip.data('days')));
                      $('#statUsed').text('-');
                      $('#statWait').text('-');
                      $('#statLeft').text('-');
                      // 연차 외 휴가는 미리 받아둔 잔고가 없다.
                      // default_days 는 받은 일수가 아니라 신청할 수 있는 상한이라 '한도' 로 부른다.
                      $('#statGrantLabel').text('한도');
              }
      }

      // 90.0 → "90일", 0.5 → "0.5일", 빈 값 → "-"
      function dayText(v) {
              if (v === '' || v == null) { return '-'; }
              var n = parseFloat(v);
              if (isNaN(n)) { return '-'; }
              return (n % 1 === 0 ? n.toFixed(0) : n) + '일';
      }

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
              $('#daysCalc').text('주말은 자동 제외됩니다.(공휴일은 반영 X )');
              return days;
      }

      /* 제목은 고른 값으로 조립한다. 휴가는 제목이 뻔해서 입력칸을 두지 않았다.
         예) 연차 신청 (2026-08-13) / 연차 신청 (2026-08-13 ~ 2026-08-15) */
      function syncTitle() {
              var $on = $('.vchip.on');
              var s = $('#startDate').val();
              var e = $('#endDate').val();

              if ($on.length === 0 || s === '') { return; }

              var label = $on.text().trim();
              var range = (e === '' || s === e) ? s : (s + ' ~ ' + e);
              var days  = recalc();

              $('#title').val(label + ' 신청 (' + range + ', 총 ' + days + '일)');
              syncBody($on, range, days);
      }

      /* 본문도 입력칸이 없다. 고른 값으로 글을 조립해 hidden 에 넣는다.
         보유 휴가는 employee.remain_leave, 신청 후 잔여는 그 값에서 신청일수를 뺀 것.
         ⚠ 연차(deduct_balance=1)만 잔여가 줄어든다. 병가·공가는 잔여를 안 깎는다. */
      function syncBody($chip, range, days) {
              var deduct = String($chip.data('deduct')) === 'true';
              var lines  = [];

              lines.push('휴가 종류 : ' + $chip.text().trim());
              lines.push('휴가 기간 : ' + range);
              lines.push('신청 일수 : ' + days + '일');

              if (deduct && annualRemain !== '') {
                      var have = parseFloat(annualRemain);
                      lines.push('보유 휴가 : ' + have + '일');
                      lines.push('신청 후 잔여 : ' + (have - days) + '일');
              } else if (deduct) {
                      lines.push('보유 휴가 : 확인 불가');
              } else {
                      lines.push('※ 잔여 연차에서 차감되지 않는 휴가입니다.');
              }

              var reason = $('#reason').val();
              if (reason !== '') { lines.push('휴가 사유 : ' + reason); }

              $('#content').val(lines.join('\n'));
      }

      $('#startDate').on('change', function() {
              var s = $(this).val();
              $('#endDate').attr('min', s);

              // 반차이거나 종료일이 시작일보다 앞서면 종료일을 붙여준다
              if (isHalf() || $('#endDate').val() === '' || $('#endDate').val() < s) {
                      $('#endDate').val(s);
              }
              markPast($('#endDate'));
              warnPast($(this));
              $('#dateErr').hide();
              recalc();
              syncTitle();
      });

      $('#endDate').on('change', function() {
              /* 반차인데 종료일을 다른 날로 바꾸면 반차가 성립하지 않는다.
                 종류까지 풀어버리면 다시 고르게 만드니까, 같은 종류의 '종일' 칩으로 옮겨준다. */
              if (isHalf() && $(this).val() !== $('#startDate').val()) {
                      var type   = $('#vacationTypeId').val();
                      var $whole = $('.vchip').filter(function() {
                              return $(this).data('type') === type && $(this).data('half') === '';
                      }).first();

                      // 값이 바뀌는 건 알려주고 바꾼다. 조용히 바꾸면 사용자가 모른다.
                      alert('반차는 하루만 쓸 수 있습니다. 종일 휴가로 변경합니다.');

                      $('.vchip').removeClass('on');
                      $whole.addClass('on');
                      $('#startHalf').val('');
                      $('#halfInfo').text('여러 날을 고르면 반차가 종일로 바뀝니다.').show();
              } else {
                      $('#halfInfo').hide();
              }
              warnPast($(this));
              $('#dateErr').hide();
              recalc();
              syncTitle();
      });

      // 사유를 고치면 본문도 따라 바뀌고, 띄워둔 안내문도 걷는다
      $('#reason').on('input', function() {
              if ($.trim($(this).val()) !== '') { $('#reasonErr').hide(); }
              syncTitle();
      });

      markPast($('#startDate'));
      markPast($('#endDate'));
      recalc();

      /* 뒤로가기로 돌아온 경우. 브라우저는 입력칸 값만 되살리고 스크립트는 다시 안 돌린다.
         게다가 값을 되살리면서 change 를 띄우지 않아 화면 숫자가 옛날 값으로 남는다.
         그래서 되살리기가 끝난 뒤에 한 번 더 계산한다 */
      $(window).on('pageshow', function() {
              recalc();
              syncTitle();
      });

      /* 입력칸에서 엔터를 치면 폼이 통째로 넘어간다. 브라우저가 '첫 번째 submit 버튼'을
         누른 것으로 치기 때문인데, 재상신 화면에는 임시저장이 없어서 그 첫 버튼이
         '휴가 재신청'이다 — 사유 칸 옆 입력칸에서 엔터만 쳐도 그대로 신청돼 버린다.
         textarea 는 줄바꿈을 써야 하므로 input 에만 건다 */
      $('#docForm').on('keydown', 'input', function(e) {
              // 한글 조합 중에 누른 엔터는 글자를 확정하는 용도라 막으면 안 된다.
              // 그것까지 막으면 마지막 글자가 안 들어간다
              if (e.key === 'Enter'
                              && !(e.originalEvent && e.originalEvent.isComposing)) {
                      e.preventDefault();
              }
      });

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
              } else if (recalc() === 0) {
                      $('#dateErr').text('사용 일수가 0일입니다. 기간을 다시 선택해주세요.').show();
                      msgs.push('선택한 기간에 근무일이 없습니다.');
                      first = first || function() { $('#startDate').focus(); };
              }

              /* 연차를 깎는 종류일 때만 잔여를 미리 본다.
                 서버(DocumentService)가 하는 것과 같은 계산이다 — 여기서 막는 건 안내용이고
                 진짜 방어는 서버다. 화면 JS 는 개발자도구로 지울 수 있기 때문이다. */
              var $onChip = $('.vchip.on');
              if ($onChip.length > 0 && String($onChip.data('deduct')) === 'true'
                              && annualRemain !== '' && s !== '' && en !== '' && en >= s) {
                      var need   = recalc();
                      var usable = parseFloat(annualRemain) - parseFloat(annualPending === '' ? 0 : annualPending);
                      if (need > 0 && need > usable) {
                              $('#dateErr').text('남은 연차보다 신청 일수가 많습니다.').show();
                              msgs.push('남은 연차보다 신청 일수가 많습니다.');
                              first = first || function() { $('#startDate').focus(); };
                      }
              }

              // 사유는 신청(상신)할 때만 필수다. 공백만 친 것도 안 쓴 것으로 본다.
              // 임시저장은 쓰다 만 신청서를 그대로 쟁여두는 기능이라 빈칸이어도 저장돼야 한다.
              // vacation_request.reason 이 NULL 을 받는 컬럼이라 DB 도 막지 않는다.
              // (종류·기간은 못 푼다 — vacation_type_id·start_date·end_date·days 가 NOT NULL 이다)
              if (isSubmitDoc && $.trim($('#reason').val()) === '') {
                      $('#reasonErr').show();
                      msgs.push('휴가 사유를 입력해 주세요.');
                      first = first || function() { $('#reason').focus(); };
              }

              if (isSubmitDoc && approvalLine.length === 0) {
                      $('#apprErr').show();
                      msgs.push('결재선을 먼저 지정해 주세요.');
                      first = first || function() { $('#btnApprovalLine').focus(); };
              }

              /* 달력의 min 은 브라우저 UI만 막을 뿐, 직접 쳐 넣으면 통과된다.
                 신청(상신)할 때만 본다 — 오래 묵혀 둔 임시저장은 마감일이 이미
                 지나 있을 수 있는데 그걸로 쟁여두기까지 막으면 안 된다. */
              var due = $('#dueDate').val();
              if (isSubmitDoc && due !== '' && due < todayStr) {
                      $('#dueDateErr').show();
                      msgs.push('결재 마감일은 오늘 이후로 지정해 주세요.');
                      first = first || function() { $('#dueDate').focus(); };
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
