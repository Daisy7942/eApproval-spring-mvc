<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
	화면 최상단 헤더 (전체 폭 고정). 세 덩어리로 나뉜다.

	왼쪽   : 로고 + 회사명
	가운데 : 통합 검색
	오른쪽 : 오늘 날짜 · 알림 · 프로필(드롭다운)

	스타일은 common.css 의 "1. 상단 헤더" 구역에 있다.
--%>

<%-- 오늘 날짜를 서버 시각으로 찍기 위한 객체 --%>
<jsp:useBean id="today" class="java.util.Date" />
<fmt:setLocale value="ko_KR" />

<header class="header">

	<!-- ═══════ 왼쪽 : 로고 + 회사명 ═══════ -->
	<%-- 회사명을 바꾸려면 mark 의 글자와 아래 b / span 만 고치면 된다 --%>
	<a class="brand" href="${pageContext.request.contextPath}/">
		<span class="mark">D</span>
		<span class="name">
			<b>DURIAN</b>
			<span>GROUPWARE</span>
		</span>
	</a>


	<!-- ═══════ 가운데 : 통합 검색 ═══════ -->
	<%-- TODO WBS 5.x : 통합 검색 만들면 form 으로 바꾸고 action 연결 --%>
	<div class="search">
		<span class="s-ico">&#128269;</span>
		<input type="text" class="s-input" placeholder="문서 · 사원 검색"
			onkeydown="if (event.key === 'Enter') { alert('통합 검색은 준비 중입니다.'); return false; }">
	</div>


	<!-- ═══════ 오른쪽 : 날짜 · 알림 · 프로필 ═══════ -->
	<div class="util">

		<span class="today"><fmt:formatDate value="${today}"
				pattern="yyyy.MM.dd (E)" /></span>

		<%-- notiCount 는 아직 Controller가 안 내려줌 (WBS 6.2 인앱 알림).
		     값이 없으면 EL 비교가 false라 배지가 안 보인다. --%>
		<button type="button" class="icon-btn"
			onclick="alert('알림 기능은 준비 중입니다.')" title="알림">
			&#128276;
			<c:if test="${notiCount > 0}">
				<span class="badge">${notiCount}</span>
			</c:if>
		</button>

		<div class="divider"></div>

		<div class="profile-box" id="profileBox">
			<button type="button" class="profile-btn" onclick="toggleProfileMenu()">
				<span class="avatar">
					<c:out value="${fn:substring(sessionScope.loginUser.name, 0, 1)}" />
				</span>
				<span class="who">
					<b><c:out value="${sessionScope.loginUser.name}" /></b>
					<%-- TODO 팀·직급 하드코딩 상태.
					     EapprovalVO 에 teamName / position 을 추가하고
					     employee.xml 로그인 SELECT 에 team 테이블을 LEFT JOIN 하면
					     아래 한 줄을 이렇게 바꾸면 된다.
					     <span>${sessionScope.loginUser.teamName} ${sessionScope.loginUser.position}</span> --%>
					<span>재무팀 부장</span>
				</span>
				<span class="caret">&#9662;</span>
			</button>

			<div class="profile-menu">

				<%-- 메뉴 맨 위에 누구로 로그인했는지 한 번 더 보여준다.
				     사원번호는 버튼에서 빼고 여기로 옮겼다. --%>
				<div class="pm-head">
					<b><c:out value="${sessionScope.loginUser.name}" /></b>
					<span><c:out value="${sessionScope.loginUser.employeeCode}" /> · 재무팀 부장</span>
				</div>

				<a href="#" onclick="alert('내 정보는 준비 중입니다.'); return false;">
					<span class="mi">&#9673;</span> 내 정보
				</a>
				<a href="#" onclick="alert('서명 등록은 준비 중입니다.'); return false;">
					<span class="mi">&#9998;</span> 서명 등록
				</a>

				<div class="sep"></div>

				<%-- 되돌리기 어려운 동작이라 빨간색(danger)으로 구분 --%>
				<a class="danger" href="${pageContext.request.contextPath}/logout"
					onclick="return confirm('로그아웃 하시겠습니까?');">
					<span class="mi">&#8594;</span> 로그아웃
				</a>
			</div>
		</div>
	</div>
</header>

<script>
	// 열림/닫힘 표시를 바깥 상자(profile-box)에 준다.
	// 그래야 CSS 하나로 메뉴 펼침 + 버튼 강조 + 화살표 회전을 같이 처리할 수 있다.
	function toggleProfileMenu() {
		document.getElementById("profileBox").classList.toggle("open");
	}
	// 메뉴 바깥을 클릭하면 닫기
	document.addEventListener("click", function(e) {
		if (!e.target.closest(".profile-box")) {
			document.getElementById("profileBox").classList.remove("open");
		}
	});
	// ESC 로도 닫기
	document.addEventListener("keydown", function(e) {
		if (e.key === "Escape") {
			document.getElementById("profileBox").classList.remove("open");
		}
	});
</script>
