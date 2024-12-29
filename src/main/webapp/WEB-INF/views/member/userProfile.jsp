<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet"  href="/resources/default.css">
<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
.follow-btn {
    color: white;
    background-color: green; /* 예: 초록색 배경 */
    padding: 5px 10px;
    border-radius: 5px;
    text-decoration: none;
}

.unfollow-btn {
    color: white;
    background-color: red; /* 예: 빨간색 배경 */
    padding: 5px 10px;
    border-radius: 5px;
    text-decoration: none;
}

/* 추가로 hover 시 효과도 줄 수 있음 */
.follow-btn:hover, .unfollow-btn:hover {
    opacity: 0.8;
}
</style>
</head>
<body>
	<%--사이드 메뉴--%>
	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
	<%--피드 영역--%>
	<main id="myfeed-main">
		<div class="profile" id="myfeed-profile">
			<div class="profile-frame" id="myfeed-frame">
				<img class="profileImage"
                            src="${not empty member.userImage ? member.userImage : '/resources/profile_file/default_profile.png'}"
                            alt="프로필 이미지" />
			</div>
			<div id="profile-text">
				<span id="myId">${member.userId}</span> <br> <span id="myNick">${member.userNickname}</span>

				<div id="follow-text">
    				<span>팔로워 <span class="followerCountSpan">${followerCount}</span></span>
					<span>팔로잉 <span class="followingCountSpan">${followingCount}</span></span>
				</div>

				<div>
					<div>
						<c:choose>
							  <%-- 서로 팔로우 상태 (맞팔) --%>
							<c:when test="${myFollowCount > 0 && theyFollowCount > 0}">
								<!-- 서로 팔로우 상태 -> '언팔로우' 버튼 표기 -->
								<a href="javascript:void(0)" class="follow-toggle unfollow-btn"
									data-userid="${member.userId}" data-following="true"> 언팔로우
								</a>
							</c:when>

							<%-- 내가 상대만 팔로우 중 --%>
							<c:when test="${myFollowCount > 0 && theyFollowCount == 0}">
								<!-- 문구는 '언팔로우'로 표시(일방 팔로우) -->
								<a href="javascript:void(0)" class="follow-toggle unfollow-btn"
									data-userid="${member.userId}" data-following="true"> 언팔로우
								</a>
							</c:when>

							 <%-- 상대가 나만 팔로우 중 --%>
							<c:when test="${myFollowCount == 0 && theyFollowCount > 0}">
								<!-- 이 경우엔 '맞팔로우' 같은 문구를 쓸 수도 있음 -->
								<a href="javascript:void(0)" class="follow-toggle follow-btn"
									data-userid="${member.userId}" data-following="false"> 맞팔로우
								</a>
							</c:when>

							 <%-- 둘 다 팔로우 안 함 --%>
							<c:otherwise>
								<a href="javascript:void(0)" class="follow-toggle follow-btn"
									data-userid="${member.userId}" data-following="false"> 팔로우
								</a>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

			</div>
		</div>

		<div class="post-container">
	   		<c:forEach var="post" items="${post}">
	   			<div class="post-grid">
	   				<img src="/resources/post_file/${post.postFileName}" alt="thumbnail" class="feed-thumbnail">
	   				<p class="hidden-post-content" style="display: none;">${post.postContent}</p>
	   			</div>
	   		</c:forEach>
	    </div>
	    
	    <%-- 콘텐츠 모달창 --%>
	    <div class="modal">
	    	<div class="modal-place">
		    <div class="modal-contents"> 		     
			    <div class="modal-image">
		    	  <c:forEach var="post" items="${post}">
		    	    <img src="/resources/post_file/${post.postFileName}" alt="thumbnail" class="post-modal">
		    	  </c:forEach>
			    </div>
			    
		     	 <div class="modal-body">
		     	  	<div class="top">
			    	   <div class="modal-user">
			    	   	<div class="profile-frame" id="modal-profile"></div>
			    	    <p>${loginMember.userNickname}</p>
			    	   </div>
			    	   <a href="#" class="modal-close">X</a>
			    	 </div>
			    	 
			    	 <div class="post-content">
			    	 	<div class="post-content-text"></div>
			    	 </div>		
			    	     	 
			    	 <%-- 나중에 댓글 넣기 --%>
		        </div>		        
		    </div>
		    </div>   	        
	    </div>
	    
	     <%-- 포스트 작성 모달창 --%>
	    <div class="modal">
	    	<div class="modal-place">
	    	</div>
	    </div>
	    			    
	</main>
	
	
	<script>
		$(document).ready(function(){
			  // 이벤트 위임
			  $(document).on("click", ".follow-toggle", function(){
			    var $btn = $(this);
			    var userId = $btn.data("userid");       // 상대방 아이디
			    var isFollowing = $btn.data("following"); // true/false
	
			    $.ajax({
			      url: '/follor/follow',        // 실제 컨트롤러 매핑 URL
			      type: 'POST',
			      dataType: 'json',
			      data: {
			        userId: userId,
			        action: isFollowing ? 'unfollow' : 'follow'
			      },
			      success: function(response){
			        // 예: response = { success: true/false, isFollowing: true/false, isMutualFollow: true/false, ... }
			        if(response.success){
			          // 이미 팔로우중 -> 언팔 성공
			          if(response.isFollowing){
			            // 맞팔 여부에 따라 텍스트가 다를 수 있음
			            // 예: response.isMutualFollow ? '언팔로우' : '언팔로우'
			            $btn.text('언팔로우').data('following', true).removeClass('follow-btn').addClass('unfollow-btn');
			          } else {
			            // 팔로우 상태 아님 -> 팔로우 버튼으로
			            $btn.text('팔로우').data('following', false).removeClass('unfollow-btn').addClass('follow-btn');
			          }
			       	  // 1) 만약 Controller 응답에 followerCount / followingCount가 있으면
			          //    아래처럼 DOM을 업데이트
			          if(response.followerCount !== undefined){
			              $(".followerCountSpan").text(response.followerCount);
			          }
			          if(response.followingCount !== undefined){
			              $(".followingCountSpan").text(response.followingCount);
			          }
			        } else {
			          alert("팔로우/언팔로우 처리 실패: " + (response.message || ''));
			        }
			      },
			      error: function(){
			        console.log("AJAX error!");
			      }
			    });
			  });
			});
			
		//모달창 노출
		const modal = $(".modal");
		
		const postText = $(".post-content-text");
		const postCon = $(".hidden-post-content").text();
		
		$(".feed-thumbnail").on("click",function(){
			modal.css("display","block");
			
			//콘텐츠 노출
			postText.text(postCon);
			
		});
		
		//모달창 닫기
		$(".modal-close").on("click", function(){
			modal.css("display", "none");
		})
		
		
		//포스트 작성
		$("#post-button").on("click",function(){
			
			
		});
		
	</script>
</body>
</html>