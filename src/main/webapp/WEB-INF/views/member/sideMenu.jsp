<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<!-- <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script> -->
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
					<a href="/chat/chatCombined.kh" class="menu-link">메시지</a>
				</div>
				
				<c:if test="${loginMember.acctLevel > 0}">
					<div class="one-menu">
                    	<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
                    <a href="/report/adminPage.kh" class="menu-link">관리자 페이지</a>
                </div>
				</c:if>
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
		    <div class="notification-header">
		        <span>알림</span>
		        <button class="mark-all-read-btn">지우기</button>
		    </div>
		    <div class="notification-content">
		        <p>읽지 않은 알림이 없습니다.</p>
		    </div>
		</div>

		
		
   <script>
	    $(document).ready(function () {
	        // JSP에서 사용자 번호를 전달받음
	        let userNo = ${loginMember.userNo}; // JSP 변수
	
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
	
	        // 알림 가져오기 (문자열 결합 방식)
	        function fetchNotifications() {
	            var url = '/notify/poll/' + userNo;
	
	            $.ajax({
	                url: url,
	                method: 'GET',
	                success: function (notifications) {
	                    var contentHtml = '';
	
	                    if (notifications.length > 0) {
	                        notifications.forEach(function (notification) {
	                            contentHtml +=
	                                '<div class="notification-item">' +
	                                '<span>' + notification.notifyContent + '</span>' +
	                                '</div>';
	                        });
	                    } else {
	                        contentHtml = '<p>읽지 않은 알림이 없습니다.</p>';
	                    }
	
	                    $('.notification-content').html(contentHtml);
	                },
	                error: function () {
	                    console.error('알림을 가져오는 중 오류 발생');
	                }
	            });
	        }
	
	     // 모든 알림 읽음 처리
	        function markAllAsRead() {
	            $.ajax({
	                url: '/notify/mark-all-read/' + userNo,
	                method: 'PUT',
	                success: function (response) {
	                    if (response === 'success') {
	                        console.log('모든 알림 읽음 처리 완료');
	                        fetchNotifications(); // UI 갱신
	                    } else {
	                        console.error('모든 알림 읽음 처리 실패');
	                    }
	                },
	                error: function () {
	                    console.error('모든 알림 읽음 처리 중 오류 발생');
	                }
	            });
	        }

	        // 버튼 클릭 이벤트에 연결
	        $('.mark-all-read-btn').click(markAllAsRead);

	       
	    });
	</script>


		
			
	
	
</body>
</html>