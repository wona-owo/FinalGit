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
					<a href="/member/mainFeed.kh" class="menu-link">홈</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/member/search.kh" class="menu-link">검색</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					 <a class="open-notification-btn" >알림</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/chat/chatRoomList.kh" class="menu-link">메시지</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/story/modalTest.kh" class="menu-link">정기구독</a>
				</div>
			</div>		
			
			<div class="profile">
				<div class="profile-frame">
					<img class="profileImage"
                            src="${not empty loginMember.userImage ? loginMember.userImage : '/resources/profile_file/default_profile.png'}"
                            alt="프로필 이미지" />
				</div>
					<a class="myNick" href="/post/myFeedFrm.kh"> ${loginMember.userNickname}</a>
			</div>
			<hr>
			<hr>
			<a href="/member/logout.kh" style="color: gray;">
			<i class="fa-solid fa-right-from-bracket" style="color: gray;"></i> 로그아웃</a>					
		</nav>
		
	</div>
	
	
	  <div class="notification-sidebar" id="notificationSidebar">
	    <div class="notification-header">알림</div>
	    <div class="notification-content">이 사이드바는 SNS 알림창입니다!</div>
	    <button class="close-sidebar-btn">닫기</button>
	  </div>
	
	  <script>
	    const notificationSidebar = document.getElementById('notificationSidebar');
	    const openNotificationBtn = document.querySelector('.open-notification-btn');
	    const closeSidebarBtn = document.querySelector('.close-sidebar-btn');
	
	    openNotificationBtn.addEventListener('click', () => {
	      notificationSidebar.classList.add('open');
	    });
	
	    closeSidebarBtn.addEventListener('click', () => {
	      notificationSidebar.classList.remove('open');
	    });
	
	    document.addEventListener('click', (event) => {
	      if (!notificationSidebar.contains(event.target) && event.target !== openNotificationBtn) {
	        notificationSidebar.classList.remove('open');
	      }
	    });
	  </script>
	
	
	
	
</body>
</html>