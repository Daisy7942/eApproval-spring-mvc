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
.head-left .urgent { display:flex; align-items:center; gap:5px;
                     font-size:12px; color:#d94848; cursor:pointer;
                     padding:4px 10px; border:1px solid #f0d5d5;
                     border-radius:20px; background:#fdf6f6; }

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
.sign-box { display:flex; border:1px solid #dbe1ea; border-radius:4px;
            overflow:hidden; flex-shrink:0; }
.sign-cell { width:64px; text-align:center; border-right:1px solid #dbe1ea; }
.sign-cell:last-child { border-right:none; }
.sign-cell .role { font-size:11px; color:#7a8aa5; padding:5px 0;
                   background:#f6f8fb; border-bottom:1px solid #dbe1ea; }
.sign-cell .stamp { height:60px; display:flex; align-items:center;
                    justify-content:center; font-size:10px; color:#c8cfda; }

/* 입력 영역 */
.row { margin-bottom:18px; }
.row label.tit { display:block; font-size:12px; color:#7a8aa5; margin-bottom:6px; }
.row input[type=text] { width:100%; padding:10px 12px;
        border:1px solid #dbe1ea; border-radius:8px; font-size:14px; }
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

              <!-- ===== 헤더 (제목 + 긴급) ===== -->
              <div class="head">
                      <div class="head-left">
                              <b>기안 작성</b>
                              <label class="urgent">
                                      <input type="checkbox" name="isUrgent" value="true"> 긴급 문서
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

                              <!-- TODO 3.2 / 도장: 결재선이 정해지면 칸이 동적으로 생성됨 -->
                              <div class="sign-box">
                                      <div class="sign-cell">
                                              <div class="role">기안</div><div class="stamp">서명</div>
                                      </div>
                                      <div class="sign-cell">
                                              <div class="role">팀장</div><div class="stamp"></div>
                                      </div>
                                      <div class="sign-cell">
                                              <div class="role">부장</div><div class="stamp"></div>
                                      </div>
                              </div>
                      </div>

                      <!-- ===== 제목 ===== -->
                      <div class="row">
                              <label class="tit">제목</label>
                              <input type="text" id="title" name="title" maxlength="200"
                                     placeholder="제목을 입력하세요">
                              <p class="err" id="titleErr">제목을 입력해주세요.</p>
                      </div>

                      <!-- ===== 내용 ===== -->
                      <div class="row">
                              <label class="tit">내용</label>
                              <textarea id="summernote" name="content"></textarea>
                              <p class="err" id="contentErr">내용을 입력해주세요.</p>
                      </div>

                      <!-- ===== 첨부파일 (미구현) ===== -->
                      <div class="row">
                              <label class="tit">첨부파일</label>
                              <div class="todo">
                                      <button type="button" class="ghost" disabled>파일 선택</button>
                                      <span class="note">추후구현 — attachment 테이블 사용 예정</span>
                              </div>
                      </div>

                      <!-- ===== 결재선 (3.2) ===== -->
                      <div class="row">
                              <label class="tit">결재선</label>
                              <div class="todo">
                                      <button type="button" class="ghost" disabled>＋ 결재선 지정</button>
                                      <span class="note"></span>
                              </div>
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

      $('#summernote').summernote({
              lang : 'ko-KR',
              height : 300,
              placeholder : '내용을 입력하세요',
              toolbar : [
                      [ 'style', [ 'bold', 'italic', 'underline', 'clear' ] ],
                      [ 'font', [ 'fontsize', 'color' ] ],
                      [ 'para', [ 'ul', 'ol', 'paragraph' ] ],
                      [ 'table', [ 'table' ] ],
                      [ 'view', [ 'codeview' ] ]
              ]
      });

      $('#docForm').on('submit', function() {
              $('.err').hide();

              if ($('#title').val().trim() === '') {
                      $('#titleErr').show();
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