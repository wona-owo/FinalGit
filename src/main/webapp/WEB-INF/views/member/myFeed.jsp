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
<style>
/* ===== 모달 배경 ===== */
.modal-backdrop-G {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.4); /* 어두운 반투명 */
  z-index: 9998;
}

/* ===== 모달 창 ===== */
.modal-G {
  position: absolute; /* 혹은 fixed */
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  min-width: 601px;
  max-width: 90%;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  z-index: 9999;
}

.modal-content-G {
  padding: 20px;
  position: relative;
}

.modal-content-G h2 {
  margin: 0 0 1rem;
  font-size: 1.25rem;
  border-bottom: 1px solid #eee;
  padding-bottom: 10px;
}

/* ===== 모달 내부 레이아웃 ===== */
.modal-body-G {
  display: flex; /* 좌우 배치 */
  gap: 20px;
}

/* 왼쪽 영역 */
.modal-left-G {
  flex: 0 0 260px; /* 고정너비 (예시) */
  border-right: 1px solid #f0f0f0;
  padding-right: 20px;
}

/* 오른쪽 영역 */
.modal-right-G {
  flex: 1; /* 나머지 공간 */
}

/* ===== 프로필 이미지 ===== */
.profile-image-container {
  width: 150px;
  height: 150px;
  margin-left: 55px;
  border-radius: 50%;
  overflow: hidden; /* 둥글게 잘림 */
  background-color: #f5f5f5;
  margin-bottom: 1rem;
  display: flex;
  justify-content: center;
  align-items: center;
}
#profileImagePreview {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 이미지 변경/삭제 버튼 영역 */
.image-btn-group {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
  justify-content: center;
}

/* ===== 아이디/이름 (읽기전용) ===== */
.info-group {
  margin-bottom: 0.75rem;
}
.info-group label {
  display: block;
  margin-bottom: 0.25rem;
  font-weight: bold;
}
.info-group input[disabled] {
  background-color: #eee;
  color: #666;
  outline: none;
  cursor: not-allowed;
  border: 1px solid #ddd;
  border-radius: 4px;
  width: 94%;
}

/* ===== 오른쪽 폼 ===== */
.form-group {
  margin-bottom: 0.75rem;
  display: flex;
  flex-direction: column;
}
.form-group label {
  margin-bottom: 0.25rem;
  font-weight: bold;
}
.modal-in {
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  width: 94%;
}
.form-group label{
display: flex;
justify-content: space-between;
}
/* 닉네임/전화번호 중복체크 버튼 나란히 배치 */
.duplication-group .input-with-btn {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

/* ===== 버튼 기본 ===== */
.btn {
  padding: 0.5rem 0.75rem;
  border: none;
  border-radius: 4px;
  background-color: #f0f0f0;
  color: #333;
  font-size: 0.9rem;
  cursor: pointer;
}

.btn:hover {
  background-color: #e0e0e0;
}

/* 삭제 버튼 */
.btn-delete {
  background-color: #f7d3d3;
  color: #a33;
}
.btn-delete:hover {
  background-color: #f5bcbc;
}

/* 중복확인 버튼 */
.btn-dup-check {
  background-color: #ffdd66;
}
.btn-dup-check:hover {
  background-color: #ffc107;
}

/* 수정/취소 버튼 (오른쪽 정렬) */
.button-area {
  margin-top: 1rem;
  display: flex;
  justify-content: center;
  gap: 0.5rem;
}
.save-btn {
  background-color: #4078c0;
  color: #fff;
}
.save-btn:hover {
  background-color: #33629a;
}
.cancel-btn {
  background-color: #ccc;
}
.cancel-btn:hover {
  background-color: #bbb;
}

#btnDeleteUser{
margin-top:16px;
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
				<img id="profileImage"
                            src="${loginMember.userImage ? loginMember.userImage : '/resources/profile_file/default_profile.png'}"
                            alt="프로필 이미지" />
			</div>
			 <div id="profile-text">
				 <span id="myId">${loginMember.userId}</span> <br>
				 <span id="myNick">${loginMember.userNickname}</span>
				 
				 <div id="follow-text">
					 <span>팔로잉 00</span> <%-- 팔로워 테이블 연동 예정 --%>
					 <span>팔로워 00</span>
				 </div>
				 
				 <div> <%--구현안된 페이지는 홈으로 랜딩 --%>
				 	<button class="profile-button" onclick="openProfileModal()"> 프로필 편집 </button>
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
	    	
	    	<form id="postForm" action="/post/write.kh" method="post" enctype="multipart/form-data">
				<input type="hidden" name="userNo" value="${sessionScope.loginMember.userNo}">
	    	<div class="modal-body">
			    <div class="top">
			   		 <span class="modal-title">일기쓰기</span>
			    	 <a href="#" class="modal-close" id="post-write-close">X</a>
			    </div>
			
			   <div>
			   		<span class="modal-title">이미지, 영상파일 추가</span> <br>
			   		<input name="files" type="file" id="post-input" accept=".jpg, .gif, .png, .jpeg, .mp4, .wmv, .mov" multiple>
			   </div>
			   
			   <div>
				   <span>내용 추가</span> <br>
				   <textarea name="content" rows="10" cols="55" style="resize: none;"></textarea> 
			   </div>
			   
			   <div>
			  	   <span>태그 추가</span> <br>
			  	   <input name="hashtag" placeholder="태그를 입력하세요.(최대 5개)" id="post-hashtag" type="hidden">
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
		 
		 submit.on("click",function(event){
				
			//기본 제출 동작 방지
			event.preventDefault();
				 
			if(!imageCk[0].files.length){
				alert("1개 이상의 이미지를 등록해야 합니다!");
			}else{
				
				const tagData = tagify.value;
				const tagList = [];
				
				
				for(let tag of tagData){
					tagList.push(tag["value"]);
				}
						
				const tagString = JSON.stringify(tagList);			
				
				$("#post-hashtag").val(tagString);
				
				$("#postForm")[0].submit();
			}
		});
		 
	</script>
	<%-- js 파일에서 변수를 불러오기 위한 세팅 --%>
	<script type="text/javascript">
	const loginMember = {
	        userId: "${sessionScope.loginMember.userId}",
	        userName: "${sessionScope.loginMember.userName}",
	        userImage: "${sessionScope.loginMember.userImage}",
	        userNickname: "${sessionScope.loginMember.userNickname}",
	        userAddress: "${sessionScope.loginMember.userAddress}",
	        userEmail: "${sessionScope.loginMember.userEmail}",
	        userPhone: "${sessionScope.loginMember.userPhone}"
	    };
	
	// 기존 값 사용 시 체크할 변수
    const currentUserPhone = "${loginMember.userPhone}";
    const currentNickname = "${loginMember.userNickname}";
    
	</script>
	<script type="text/javascript" src="/resources/modal_profile.js"></script>
</body>
</html>