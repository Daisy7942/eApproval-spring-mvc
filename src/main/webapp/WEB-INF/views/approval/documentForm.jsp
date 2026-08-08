<%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>eApproval - 기안 작성</title>

<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/lang/summernote-ko-KR.min.js"></script>

<style>
* { margin:0; padding:0; box-sizing:border-box;
    font-family:"Malgun Gothic","Segoe UI",sans-serif; }
body { background:#f4f6fa; padding:30px; }
.wrap { max-width:900px; margin:0 auto; background:#fff;
        border-radius:12px; box-shadow:0 2px 12px rgba(0,0,0,.06); }

/* 헤더 */
.head { display:flex; justify-content:space-between; align-items:center;
        padding:18px 24px; border-bottom:1px solid #e9edf3; }
.head b { font-size:16px; color:#1c2a47; }
.head .x { cursor:pointer; color:#999; font-size:18px; text-decoration:none; }
.head-left { display:flex; align-items:center; gap:14px; }
/* 긴급 문서 토글.
   전에는 항상 빨간 알약이라 체크를 안 해도 켜진 것처럼 보였다.
   기본은 회색, 체크했을 때만 빨갛게 해서 상태가 한눈에 구분되게 한다. */
.head-left .urgent { position:relative; cursor:pointer;
                     -webkit-user-select:none; user-select:none; }
/* 기본 체크박스는 숨기고 옆의 chip 을 대신 보여준다 */
.head-left .urgent input { position:absolute; opacity:0;
                           width:0; height:0; pointer-events:none; }
.head-left .urgent .chip { display:inline-flex; align-items:center; gap:6px;
                     font-size:12px; padding:5px 12px; border-radius:20px;
                     border:1px solid #e0e5ec; background:#f7f8fa; color:#8b94a3;
                     transition:background .12s, border-color .12s, color .12s; }
.head-left .urgent .chip .dot { width:6px; height:6px; border-radius:50%;
                     background:#c4cbd6; transition:background .12s, box-shadow .12s; }
.head-left .urgent:hover .chip { border-color:#cfd6e0; color:#6b7686; }
/* 켜짐 */
.head-left .urgent input:checked + .chip { background:#fdf0f0; border-color:#f2c9c9;
                     color:#d94848; font-weight:700; }
.head-left .urgent input:checked + .chip .dot { background:#e5484d;
                     box-shadow:0 0 0 3px rgba(229,72,77,.18); }
/* 체크박스를 숨겼으므로 키보드 포커스 표시를 chip 에 직접 준다 */
.head-left .urgent input:focus-visible + .chip { border-color:#2f6bff;
                     box-shadow:0 0 0 3px rgba(47,107,255,.15); }

.body { padding:24px; }

/* 상단: 문서정보 + 결재란 */
.doc-top { display:flex; justify-content:space-between;
           align-items:flex-start; gap:20px;
           padding-bottom:20px; margin-bottom:20px;
           border-bottom:1px solid #e9edf3; }
.doc-info { font-size:13px; color:#444; }
.doc-info dl { display:flex; margin-bottom:6px; }
.doc-info dt { width:70px; color:#98a3b5; font-size:12px; }

/* 결재란 (도장칸) */
.sign-area { flex-shrink:0; text-align:right; }
/* block 이면 아래 안내문 길이만큼 늘어나 칸 오른쪽에 흰 여백이 생긴다.
   inline-flex 라야 칸 개수만큼만 폭을 차지한다. */
.sign-box { display:inline-flex; border:1px solid #dbe1ea; border-radius:4px;
            overflow:hidden; vertical-align:top; }
.sign-cell { width:64px; text-align:center; border-right:1px solid #dbe1ea; }
.sign-cell:last-child { border-right:none; }
.sign-cell .role { font-size:11px; color:#7a8aa5; padding:5px 0;
                   background:#f6f8fb; border-bottom:1px solid #dbe1ea;
                   white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.sign-cell .stamp { height:60px; display:flex; align-items:center;
                    justify-content:center; font-size:11px; color:#5b6779;
                    padding:0 4px; word-break:break-all; }
/* 아직 결재자가 안 정해진 칸 — 안쪽에 점선 상자를 그리면 빈칸이 하나 더
   있는 것처럼 보여서, 옅은 글자로만 "미지정"을 표시한다. */
.sign-cell.empty { background:#fbfcfe; }
.sign-cell.empty .role { color:#b9c1cf; }
.sign-cell.empty .stamp { font-size:10px; color:#c2cad6; }
.sign-note { font-size:10.5px; color:#a5aebd; margin-top:7px; }

/* 입력 영역 */
.row { margin-bottom:18px; }
.row label.tit { display:block; font-size:12px; color:#7a8aa5; margin-bottom:6px; }
.row label.tit .opt { color:#b9c1cf; font-size:11px; margin-left:3px; }
.row input[type=text] { width:100%; padding:10px 12px;
        border:1px solid #dbe1ea; border-radius:8px; font-size:14px; }
.row input[type=date] { padding:10px 12px; width:220px;
        border:1px solid #dbe1ea; border-radius:8px; font-size:14px; color:#444; }
.row input:focus { outline:none; border-color:#2f6bff;
        box-shadow:0 0 0 3px rgba(47,107,255,.12); }
.hint { font-size:11px; color:#a5aebd; margin-top:6px; }
.err { color:#d94848; font-size:12px; margin-top:6px; display:none; }

/* 미구현 영역 */
.todo { border:1px dashed #d5dbe5; border-radius:8px; padding:14px;
        background:#fafbfd; display:flex; align-items:center; gap:10px; }
.todo .ghost { padding:7px 14px; border:1px solid #dbe1ea; border-radius:6px;
               background:#fff; color:#b4bcc9; font-size:13px; cursor:not-allowed; }
.todo .note { font-size:11px; color:#a5aebd; }

/* 하단 버튼 */
.foot { border-top:1px solid #e9edf3; padding:16px 24px;
        display:flex; justify-content:flex-end; gap:10px; }
.btn { padding:10px 20px; border-radius:8px; font-size:13px; cursor:pointer;
       border:1px solid #dbe1ea; background:#fff; color:#444; text-decoration:none; }
.btn.primary { background:#2f6bff; border-color:#2f6bff; color:#fff; }
.btn:disabled { background:#f2f4f8; color:#b4bcc9; cursor:not-allowed;
                border-color:#e4e8ef; }
</style>
</head>
<body>

<div class="wrap">

      <form id="docForm" method="post"
            action="${pageContext.request.contextPath}/document/write">

              <input type="hidden" name="documentType"
                     value="${empty param.documentType ? 'FREE' : param.documentType}">
              <input type="hidden" name="docId"
                     value="${doc.docId }">
              

              <!-- ===== 헤더 (제목 + 긴급) ===== -->
              <div class="head">
                      <div class="head-left">
                              <b>기안 작성</b>
                              <label class="urgent"
                                     title="긴급 문서로 지정하면 결재자에게 우선 표시됩니다">
                                      <input type="checkbox" name="isUrgent" value="true">
                                      <span class="chip"><span class="dot"></span>긴급 문서</span>
                              </label>
                      </div>
                      <a class="x" href="#" onclick="window.close(); return false;">✕</a>
              </div>

              <div class="body">

                      <!-- ===== 문서정보 + 결재란 ===== -->
                      <div class="doc-top">
                              <div class="doc-info">
                                      <dl><dt>문서번호</dt><dd>저장 후 부여</dd></dl>
                                      <dl><dt>기안일</dt><dd id="draftDate">-</dd></dl>
                                      <dl><dt>기안자</dt><dd>${loginUser.name} (${loginUser.employeeCode})</dd></dl>
                                      <!-- TODO: 부서명은 세션에 없음. EapprovalVO + employee.xml 확장 필요 -->
                                      <dl><dt>기안부서</dt><dd>-</dd></dl>
                              </div>

                              <%-- 결재란.
                                   칸의 내용은 아래 renderSignArea() 가 그린다. 여기 있는 두 칸은
                                   자바스크립트가 꺼졌을 때 보이는 기본 모습이자 초기 상태다.
                                   기안 칸은 본인이라 확정이지만 결재자는 아직 없으므로 '미지정' 한 칸.
                                   기안자 이름은 EL 을 JS 문자열에 직접 박지 않고
                                   data-drafter 로 넘겨서 따옴표·특수문자에 안전하게 처리한다. --%>
                              <div class="sign-area" id="signArea"
                                   data-drafter="${loginUser.name}">
                                      <div class="sign-box" id="signBox">
                                              <div class="sign-cell">
                                                      <div class="role">기안</div>
                                                      <div class="stamp">${loginUser.name}</div>
                                              </div>
                                              <div class="sign-cell empty">
                                                      <div class="role">결재</div>
                                                      <div class="stamp">미지정</div>
                                              </div>
                                      </div>
                                      <p class="sign-note" id="signNote">결재선을 지정하면 결재자 수만큼 칸이 생깁니다.</p>
                              </div>
                      </div>

                      <!-- ===== 제목 ===== -->
                      <div class="row">
                              <label class="tit">제목</label>
                              <input type="text" id="title" name="title" maxlength="200"
                                     placeholder="제목을 입력하세요" value="${doc.title}">
                              <p class="err" id="titleErr" >제목을 입력해주세요.</p>
                      </div>

                      <!-- ===== 내용 ===== -->
                      <div class="row">
                              <label class="tit">내용</label>
                              <textarea id="summernote" name="content" >${doc.content}</textarea>
                              <p class="err" id="contentErr">내용을 입력해주세요.</p>
                      </div>

                      <!-- ===== 첨부파일 (추후구현) ===== -->
                      <div class="row">
                              <label class="tit">첨부파일</label>
                              <div class="todo">
                                      <button type="button" class="ghost" disabled >파일 선택</button>
                                      <span class="note">추후구현 — attachment 테이블 사용 예정</span>
                              </div>
                      </div>

                      <!-- ===== 결재선 (3.2) =====
                           조직도 트리에서 결재자를 고르는 [결재선 설정] 모달이 여기 붙는다.
                           모달이 '결재선 확정'을 누르면 setApprovalLine() 만 불러주면 되고,
                           그러면 위 결재란 칸이 결재자 수만큼 자동으로 늘어난다. -->
                      <div class="row">
                              <label class="tit">결재선</label>
                              <div class="todo">
                                      <button type="button" class="ghost" id="btnApprovalLine"
                                              disabled title="3.2에서 구현">＋ 결재선 지정</button>
                                      <span class="note" id="apprLineNote">아직 지정되지 않았습니다</span>
                              </div>
                      </div>

                      <%-- ===== 결재 마감일 =====
                           ⚠ 아직 저장되지 않는다. 저장하려면 3곳을 더 손봐야 한다.
                              ① document 테이블에 due_date DATE NULL 컬럼 추가
                              ② DocumentVO 에 dueDate 필드 + getter/setter
                              ③ document.xml 의 INSERT 에 due_date, #{dueDate} 추가 --%>
                      <div class="row">
                              <label class="tit" for="dueDate">결재 마감일 <span class="opt">선택</span></label>
                              <input type="date" id="dueDate" name="dueDate">
                              <p class="hint">언제까지 결재를 받아야 하는지 지정합니다. 비워두면 마감일 없이 진행됩니다.</p>
                              <p class="err" id="dueDateErr">마감일은 오늘 이후로 지정해주세요.</p>
                      </div>

              </div>

              <!-- ===== 하단 버튼 ===== -->
              <div class="foot">
                      <a class="btn" href="#" onclick="window.close(); return false;">취소</a>
                      <button type="submit" class="btn primary">임시저장</button>
                      <!-- TODO 3.2: 결재선 저장 + status를 PENDING으로 -->
                      <button type="button" class="btn" disabled title="3.2에서 구현">상신</button>
              </div>

      </form>
</div>

<script>
$(document).ready(function() {

      // 기안일 = 오늘 (실제 값은 저장 시 DB의 created_at)
      $('#draftDate').text(new Date().toLocaleDateString('ko-KR'));

      // 마감일 달력에서 어제 이전은 아예 못 고르게 막는다.
      // toISOString() 은 세계표준시라 한국 시간과 하루 어긋날 수 있어 직접 조립한다.
      var t = new Date();
      var pad = function(n) { return (n < 10 ? '0' : '') + n; };
      var todayStr = t.getFullYear() + '-' + pad(t.getMonth() + 1) + '-' + pad(t.getDate());
      $('#dueDate').attr('min', todayStr);

      /* ═══════════════ 결재란 ═══════════════
         결재란 = [기안 1칸] + [결재자 수만큼의 칸].
         approvalLine 배열이 유일한 기준이고 화면은 항상 이 배열을 따라 다시 그린다.
         결재선 UI 가 바뀌어도 이 배열만 채우고 renderSignArea() 를 부르면 된다. */

      // [결재선 설정] 모달에서 고른 결재자들. 결재 순서대로 담는다.
      //   { name:'최준혁', position:'이사', department:'경영진', role:'승인' }
      //   role 은 모달의 '추가 역할' — 합의 | 승인
      var approvalLine = [];
      var drafterName  = $('#signArea').data('drafter');

      // 칸 하나를 만든다. 이름을 문자열로 붙이지 않고 .text() 로 넣어
      // 이름에 <, & 같은 글자가 있어도 그대로 글자로 나오게 한다.
      function makeSignCell(role, stamp, isEmpty) {
              var $cell = $('<div class="sign-cell"></div>');
              if (isEmpty) { $cell.addClass('empty'); }
              $('<div class="role"></div>').text(role).appendTo($cell);
              $('<div class="stamp"></div>').text(stamp).appendTo($cell);
              return $cell;
      }

      function renderSignArea() {
              var $box = $('#signBox').empty();
              $box.append(makeSignCell('기안', drafterName, false));

              // 결재선 지정 전 — '결재' 빈 칸 하나로 자리만 잡아둔다
              if (approvalLine.length === 0) {
                      $box.append(makeSignCell('결재', '미지정', true));
                      $('#signNote').text('결재선을 지정하면 결재자 수만큼 칸이 생깁니다.');
                      $('#apprLineNote').text('아직 지정되지 않았습니다');
                      return;
              }

              // 칸 위 이름표는 직급(이사·과장)을 쓴다.
              // 직급을 모르면 역할(합의·승인), 그것도 없으면 순번으로 대신한다.
              $.each(approvalLine, function(i, a) {
                      var label = a.position || a.role || ('결재' + (i + 1));
                      $box.append(makeSignCell(label, a.name, false));
              });

              var names = approvalLine.map(function(a) { return a.name; });
              $('#signNote').text('결재자 ' + names.length + '명');
              $('#apprLineNote').text(names.join(' → '));
      }

      // [결재선 설정] 모달과 이어지는 유일한 지점.
      // 모달에서 '결재선 확정'을 누를 때 결재자 배열을 넘겨 이 함수를 부르면 된다.
      //   setApprovalLine([{ name:'최준혁', position:'이사', department:'경영진', role:'승인' }, ...]);
      // 빈 배열이나 아무것도 안 넘기면 '미지정' 상태로 되돌아간다.
      window.setApprovalLine = function(list) {
              approvalLine = list || [];
              renderSignArea();
      };

      // TODO 3.2: 아래 주석을 풀고 조직도 모달을 띄운다. (버튼의 disabled 도 함께 제거)
      // $('#btnApprovalLine').on('click', openApprovalLineModal);

      renderSignArea();   // 첫 진입 시 한 번 그려서 HTML 기본 모습과 상태를 맞춘다

      $('#summernote').summernote({
              lang : 'ko-KR',
              height : 300, // 높이, 설정하지 않으면 내용의 길이에 따라 길이가 변한다.
              placeholder : '내용을 입력하세요',
              toolbar : [
                      [ 'style', [ 'bold', 'italic', 'underline', 'clear' ] ],
                      [ 'font', [ 'fontsize', 'color' ] ],
                      [ 'para', [ 'ul', 'ol', 'paragraph' ] ],
                      [ 'table', [ 'table' ] ],
                      [ 'view', [ 'codeview' ] ]
              ],
              fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체'],
      		  fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72']
      });

      $('#docForm').on('submit', function() {
              $('.err').hide();

              if ($('#title').val().trim() === '') {
                      $('#titleErr').show();
                      return false;
              }

              // 달력의 min 은 브라우저 UI만 막을 뿐, 직접 입력하면 통과된다.
              var due = $('#dueDate').val();
              if (due !== '' && due < todayStr) {   // 'YYYY-MM-DD' 는 문자열끼리 비교해도 날짜순이 맞다
                      $('#dueDateErr').show();
                      return false;
              }

              // 내용을 안 쓰면 <p><br></p> 가 들어옴
              var content = $('#summernote').summernote('code');
              if (content === '' || content === '<p><br></p>') {
                      $('#contentErr').show();
                      return false;
              }

              $('#summernote').val(content);
              return true;
      });
});
</script>

</body>
</html>
