<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
	    <button class="close-sidebar-btn">&times;</button> <!-- X 버튼 -->
	    <div class="notification-header">알림</div>
	    <div class="notification-content">
	        <p>알림 데이터를 불러오는 중...</p>
	    </div>
	</div>

	
	<script>
		  $(document).ready(function () {
		      // JSP에서 사용자 번호를 전달받음
		      const userNo = ${loginMember.userNo}; // JSP 변수
		
		      // 알림 사이드바 열기
		      $('.open-notification-btn').click(function () {
		          $('#notificationSidebar').addClass('open');
		          fetchNotifications(); // 알림 가져오기
		      });
		
		      // 알림 사이드바 닫기
		      $('.close-sidebar-btn').click(function () {
		          $('#notificationSidebar').removeClass('open');
		      });
		
		      // 외부 클릭 시 닫기
		      $(document).click(function (event) {
		          if (!$(event.target).closest('#notificationSidebar, .open-notification-btn').length) {
		              $('#notificationSidebar').removeClass('open');
		          }
		      });
		
		      // 알림 가져오기
		      function fetchNotifications() {
		          // 문자열 결합 방식으로 URL 생성
		          var url = '/notify/poll/' + userNo;
		
		          $.ajax({
		              url: url, // 동적으로 생성된 URL
		              method: 'GET',
		              success: function (notifications) {
		                  const $content = $('.notification-content');
		                  $content.empty();
		
		                  if (notifications.length > 0) {
		                      notifications.forEach(function (notification) {
		                          const $item = $(
		                              '<div class="notification-item">' +
		                              notification.notifyContent +
		                              '</div>'
		                          );
		                          $content.append($item);
		                      });
		                  } else {
		                      $content.html('<p>읽지 않은 알림이 없습니다.</p>');
		                  }
		              },
		              error: function () {
		                  console.error('알림을 가져오는 중 오류 발생');
		              }
		          });
		      }
		  });
		</script>

	
	
	
</body>
</html>