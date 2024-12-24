<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Feed</title>
<link rel ="stylesheet"  href="/resources/default.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<%--해시태그--%>
<script src="https://cdn.jsdelivr.net/npm/@yaireo/tagify"></script>
<script src="https://cdn.jsdelivr.net/npm/@yaireo/tagify/dist/tagify.polyfills.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/@yaireo/tagify/dist/tagify.css" rel="stylesheet" type="text/css" />
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
		    	    <img src="/resources/post_file/${post.postFileName}" alt="thumbnail">
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
	    <div class="post-modal">
	    	<div class="modal-place">
	    	
	    	<form action="/post/write.kh" method="post" enctype="multipart/form-data">
	    	<div class="modal-body">
			    <div class="top">
			   		 <span class="modal-title">일기쓰기</span>
			    	 <a href="#" class="modal-close" id="post-write-close">X</a>
			    </div>
			
			   <div>
			   		<span class="modal-title">이미지, 영상파일 추가</span> <br>
			   		<input type="file" id="post-input" accept=".jpg, .gif, .png, .jpeg, .mp4, .wmv, .mov" multiple>
			   </div>
			   
			   <div>
				   <span>내용 추가</span> <br>
				   <textarea rows="10" cols="55" style="resize: none;"></textarea> 
			   </div>
			   
			   <div>
			  	   <span>태그 추가</span> <br>
			  	   <input name="hashtag" placeholder="태그를 입력하세요.(최대 5개)" id="post-hashtag">
			   </div>
			   
			    <div>
				    <input type="submit" value="작성" id="post-submit">
				</div>
					
	    	</div>
	    </form>	
	    
	   </div> 
	  </div> 			    
	</main>
	
	
	<script>
	
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
		
		
		//포스트 작성 열기
		$("#post-button").on("click",function(){
			$(".post-modal").css("display","block");		
		});
		
		//포스트 작성 닫기
		$(".modal-close").on("click",function(){
			$(".post-modal").css("display","none");		
		});
		
		
		 // Tagify 초기화 및 옵션 설정
	    const tagify = new Tagify($('#post-hashtag')[0], {
	        delimiters: ", ",           // 쉼표와 공백으로 태그 구분
	        maxTags: 5,                 // 최대 5개의 태그 허용
	        pattern: /^[가-힣]{1,30}$/,  // 한글태그
	        duplicates: false,          // 중복 태그 방지
	    });
		 
		 //태그 데이터 유효성 관련 알럿
		 tagify.on("invalid",function(e){
			 if (e.detail.reason == "exceeds") {
			    alert("최대 5개의 태그만 입력할 수 있습니다.");
			} else if (e.detail.reason == "duplicate") {
			    alert("같은 태그는 등록할 수 없습니다.");
			} else if (e.detail.reason == "pattern") {
			    alert("태그는 한글, 영어, 숫자만 입력할 수 있습니다.");
			}
		 });
		
		 //사진이 하나라도 없으면 작성 불가
		 const imageCk = $("#post-input");
		 const submit = $("#post-submit");
		 
		 submit.on("click",function(){
				
			//기본 제출 동작 방지
			event.preventDefault();
				 
			if(!imageCk.val()){
				alert("1개 이상의 이미지를 등록해야 합니다!");
			}else{
				this.submit();
			}
		});
		 
	</script>
</body>
</html>