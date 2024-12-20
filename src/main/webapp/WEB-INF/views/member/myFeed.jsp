<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Feed</title>
<link rel ="stylesheet"  href="/resources/default.css">
<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<%--사이드 메뉴--%>
	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
	
	<%--피드 영역--%>
	<main id="myfeed-main">
		<div class="profile" id="myfeed-profile">
			<div class="profile-frame" id="myfeed-frame"></div>
			 <div id="profile-text">
				 <span id="myId">${loginMember.userId}</span> <br>
				 <span id="myNick">${loginMember.userNickname}</span>
				 
				 <div id="follow-text">
					 <span>팔로잉 00</span> <%-- 팔로워 테이블 연동 예정 --%>
					 <span>팔로워 00</span>
				 </div>
				 
				 <div> <%--구현안된 페이지는 홈으로 랜딩 --%>
				 	<button class="profile-button" onclick="location.href='/member/mainFeed.kh'"> 프로필 편집 </button>
				 	<button class="profile-button" id="updPet" onclick="location.href='/member/mainFeed.kh'"> 마이펫 편집 </button>
				 </div>	
				 <div>	
				 	<button class="profile-button" id="allBook" onclick="location.href='/member/mainFeed.kh'"> 북마크 확인 </button>
				 	<button class="profile-button" id="mySub" onclick="location.href='/member/mainFeed.kh'"> 내 구독 관리 </button>
				 </div>			 
			 </div>
		</div> 	
		
	    <div class="post-write">
			<button class="write-button" id="post-button" > 일기 쓰기 </button>
			<button class="write-button" id="story-button"> 스토리 쓰기 </button>
	    </div>
	    	
	    <div class="post-container">
	   		<c:forEach var="post" items="${posts}">
	   			<div class="post-grid">
	   				<%-- 이미지 배열의 첫번째 이미지(0번)의 파일 이름 --%>
	   				<img src="/resources/postFile${post.files[0].fileName}" alt="thumbnail">
	   			</div>
	   		</c:forEach>
	    </div>
	</main>
	
	
	<script>
	
	
	</script>
</body>
</html>