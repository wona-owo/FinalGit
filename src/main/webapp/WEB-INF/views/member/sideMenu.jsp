<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="container">
	
		<nav class="side-menu">
			<div class="nav-logo">
				<img alt="댕냥일기"  src="/resources/css_image/logo.png"  class="logo-img">
				<span class="nav-logo-text">댕냥일기</span>
			</div>
			
			  <div class="menu-list">
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/home" class="menu-link" data-url="/home.kh">홈</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/search" class="menu-link" data-url="/search.kh">검색</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					 <a href="/" class="menu-link" >알림</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/message" class="menu-link" data-url="/message.kh">메시지</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/" class="menu-link">정기구독</a>
				</div>
			</div>		
			
			<div class="profile">
				<div class="profile-frame">
				</div>
					<a href="/member/myFeedFrm.kh"> ${loginMember.userNickname}</a>
			</div>
			<hr>
			<hr>
			<a href="/member/logout.kh" style="color: gray;">
			<i class="fa-solid fa-right-from-bracket" style="color: gray;"></i> 로그아웃</a>					
		</nav>
		
	</div>
</body>
</html>