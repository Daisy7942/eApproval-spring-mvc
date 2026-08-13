<%-- 이 파일이 UTF-8로 저장돼 있음을 톰캣에 알려준다. 없으면 한글이 깨진다. --%>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
	좌측 사이드바 = [아이콘 레일] + [메뉴 패널]  두 덩어리.

	어느 모듈(결재/휴가)인지는 화면이 알려주지 않아도 된다.
	아래에서 주소를 보고 스스로 판단한다.
	사람이 깜빡해서 휴가 화면에 결재 메뉴가 뜨는 일을 아예 막기 위함이다.

	쓰는 쪽에서는 이것만 정해주면 된다. (안 적어도 화면은 정상, 강조만 안 될 뿐)

	<c:set var="menu" value="dashboard" />
	<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

	menu : dashboard / apprWait / apprSent / apprDone
	       leaveMy / leaveNew / adminLeave
--%>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<%-- 지금 주소에서 컨텍스트 경로(/eapproval)를 떼어낸 나머지.
     예) /eapproval/leave/my  ->  /leave/my

     ★ 함정 : 이 JSP 는 컨트롤러가 forward 로 띄운다. 그래서 이 시점의
       requestURI 는 브라우저 주소가 아니라 /WEB-INF/views/... 다.
       사람이 친 원래 주소는 javax.servlet.forward.request_uri 에 따로 담겨 있고,
       forward 없이 직접 열린 경우엔 그 값이 비어 있으므로 requestURI 로 되돌린다. --%>
<c:set var="uri"
	value="${empty requestScope['javax.servlet.forward.request_uri']
	          ? pageContext.request.requestURI
	          : requestScope['javax.servlet.forward.request_uri']}" />

<c:set var="path" value="${fn:substringAfter(uri, cp)}" />

<%-- /leave 로 시작하면 휴가, 아니면 결재.
     ★ 그러므로 휴가 화면의 주소는 반드시 /leave 로 시작해야 한다. --%>
<c:set var="module"
	value="${fn:startsWith(path, '/leave') ? 'leave' : 'appr'}" />


<%-- ═══════════ 1. 아이콘 레일 ═══════════ --%>
<nav class="rail">

	<a href="${cp}/" class="rail-item ${module eq 'appr' ? 'active' : ''}">
		<span class="ico-box">▤</span> <span>결재</span>
	</a>

	<a href="${cp}/leave/my"
		class="rail-item ${module eq 'leave' ? 'active' : ''}">
		<span class="ico-box">✈ <c:if test="${myLeaveCount > 0}">
				<span class="dot">${myLeaveCount}</span>
			</c:if>
		</span> <span>휴가</span>
	</a>

	<%-- 아직 안 만든 모듈 : a 가 아니라 span 이라 클릭이 안 된다 --%>
	<span class="rail-item disabled" title="준비 중입니다">
		<span class="ico-box">▦</span> <span>캘린더</span>
	</span>

	<span class="rail-item disabled" title="준비 중입니다">
		<span class="ico-box">▣</span> <span>게시판</span>
	</span>

	<div class="rail-bottom">
		<%-- 실수로 누르면 곤란하므로 확인을 한 번 받는다.
		     rail-logout 클래스가 붙으면 마우스를 올렸을 때 빨갛게 바뀐다. --%>
		<a href="${cp}/logout" class="rail-item rail-logout" title="로그아웃"
			onclick="return confirm('로그아웃 하시겠습니까?');">
			<span class="ico-box">[ →</span> <span>로그아웃</span>
		</a>
	</div>
</nav>


<%-- ═══════════ 2. 메뉴 패널 ═══════════ --%>
<aside class="sidebar">
	<c:choose>

		<%-- ── 결재 모듈 ── --%>
		<c:when test="${module eq 'appr'}">
			<div class="panel-head">
				<b>결재</b><span>전자결재</span>
			</div>

			<button class="btn-new" onclick="openFormModal()">＋ 새 결재</button>

			<nav class="menu">
				<a href="${cp}/" class="${menu eq 'dashboard' ? 'active' : ''}">◧
					대시보드</a>

				<div class="section">결재함</div>
				<a href="${cp}/document/pending"
					class="${menu eq 'apprWait' ? 'active' : ''}">◷ 결재 대기 문서
					<c:if test="${waitCount > 0}">
						<span class="badge">${waitCount}</span>
					</c:if>
				</a>
				<a href="${cp}/document/submitted"
					class="${menu eq 'apprSent' ? 'active' : ''}">↥ 상신 문서</a>
				<a href="${cp}/document/completed"
					class="${menu eq 'apprDone' ? 'active' : ''}">✓ 완료 문서</a>

				<%-- 임시저장함은 결재함 3종과 성격이 다르다. 남이 볼 문서가 아니라
				     아직 상신하지 않은 내 문서라서 구분선을 두고 따로 뺀다.
				     draftList.jsp 가 menu="draft" 를 세팅한다. --%>
				<div class="section">내 문서</div>
				<a href="${cp}/document/drafts"
					class="${menu eq 'draft' ? 'active' : ''}">▤ 임시저장함</a>
			</nav>
		</c:when>

		<%-- ── 휴가 모듈 ── --%>
		<c:otherwise>
			<div class="panel-head">
				<b>휴가</b><span>연차 · 반차</span>
			</div>

			<%-- 휴가신청서도 결재 문서 한 장이라 /document/write 로 간다.
			     documentType=VACATION 이면 컨트롤러가 vacationForm 을 띄운다 --%>
			<button class="btn-new" onclick="openVacationWrite()">＋ 휴가
				신청</button>

			<nav class="menu">
				<div class="section">내 휴가</div>
				<a href="${cp}/leave/my"
					class="${menu eq 'leaveMy' ? 'active' : ''}">▤ 휴가 현황</a>
				<%-- 연차 발생·소멸 이력은 표가 없어 아직 못 만든다 --%>
				<a class="soon" data-tip="추후 구현 예정">▤ 연차 내역</a>

				<%-- 관리자에게만 보이는 영역 --%>
				<c:if test="${sessionScope.loginUser.role eq 'ADMIN'}">
					<div class="section">전사 휴가관리</div>
					<a class="soon" data-tip="추후 구현 예정">◔ 전사 휴가 현황</a>
					<a class="soon" data-tip="추후 구현 예정">◔ 전사 휴가 리포트</a>
				</c:if>
			</nav>
		</c:otherwise>
	</c:choose>
</aside>


<%-- 결재 양식 선택 팝업 : [＋ 새 결재] 버튼이 여는 화면 --%>
<div id="formModal"
	style="display: none; position: fixed; inset: 0; z-index: 1000;">
	<iframe id="formFrame" src=""
		style="width: 100%; height: 100%; border: none;"></iframe>
</div>

<script>
	function openFormModal() {
		// DashboardController 의 @GetMapping("/forms")
		document.getElementById("formFrame").src = "${cp}/forms";
		document.getElementById("formModal").style.display = "block";
	}
	function closeFormModal() {
		document.getElementById("formModal").style.display = "none";
		document.getElementById("formFrame").src = ""; // 닫을 때 비워서 초기화
	}

	// 휴가 신청 : 양식이 하나로 정해져 있으니 양식 선택 팝업을 건너뛰고
	// 곧장 작성 창을 연다. 창 크기·위치는 formSelect.jsp 의 openDraft() 와 같다
	function openVacationWrite() {
		var url = "${cp}/document/write?documentType=VACATION";

		var w = 1000, h = 800;
		var sx = (screen.availLeft !== undefined) ? screen.availLeft : 0;
		var sy = (screen.availTop !== undefined) ? screen.availTop : 0;
		var left = sx + Math.max(0, Math.round((screen.availWidth - w) / 2));
		var top = sy + Math.max(0, Math.round((screen.availHeight - h) / 2));

		window.open(url, "docWrite_" + Date.now(),
				"width=" + w + ",height=" + h
				+ ",left=" + left + ",top=" + top
				+ ",resizable=yes,scrollbars=yes");
	}
</script>
