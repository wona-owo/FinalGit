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
<%-- select2 --%>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.1.0-rc.0/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.1.0-rc.0/js/select2.min.js"></script>
<style>
/* ===== 모달 배경 ===== */
.modal-backdrop-G {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.4); /* 어두운 반투명 */
	z-index: 9990;
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
	z-index: 9991;
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
#proImagePreview {
	width: 100%;
	height: 100%;
	object-fit: cover;
	object-position: 50% 50%;
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
.info-group input[readonly] {
	background-color: #eee;
	color: #666;
	outline: none;
	cursor: default;
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
.form-group label {
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
#btnDeleteUser {
	margin-top: 16px;
}

/* === 비밀번호 변경 === */
#updatePwModal {
	min-width: 300px;
	max-width: 350px;
	z-index: 9992;
}
#updatePwBody {
	display: flex;
	flex-direction: column;
	gap: 5px;
}
.modal-in-pw {
	padding: 0.2rem;
	width: 97%;
}

/* === 마이펫 편집 === */
.radio-group {
    display: flex;
    gap: 20px;
    align-items: center;
    justify-content: space-between;
}

.radio-group label {
    display: flex;
    width: 110px;
    align-items: center;
    justify-content: center;
    text-align: center;
    cursor: pointer;
    gap: 5px;
}
.radio-group input {
    width: 30px;
    height: 30px;
}
.select2-container{
    z-index: 9992;
}
.pet-box{
    width:130px; 
    height:120px; 
    border: 1px solid #ddd; 
    border-radius: 8px; 
    padding: 4px; 
    box-sizing: border-box; 
    text-align: center; 
}
.pet-image-container {
    width: 120px;
    height: 60px;
    border-radius: 15%;
    overflow: hidden; /* 둥글게 잘림 */
    background-color: #f5f5f5;
    display: flex;
    justify-content: center;
    align-items: center;
}
#pet-box-container{
    display: grid;
    grid-template-columns: repeat(2, 130px);
    grid-auto-rows: 120px;
    gap: 8px;     
}
/* 팔로워 및 팔로잉 모달 내부 콘텐츠 스타일 */
.followCount, .followingCount{
    cursor: pointer;
}
.user-list-item{
    text-decoration: none;
    width: 100%;
    height: 60px; /* 높이 60px */
    display: flex;
    align-items: center;
    padding: 0 10px; /* 좌우 패딩 조정 */
    border-bottom: 1px solid #ddd;
    box-sizing: border-box; /* 패딩과 보더를 포함하여 크기 계산 */
}

.user-alink{
    width: 100%;
    height: 100%;
    text-decoration: none;
    color: inherit; /* 링크의 기본 색상을 상속받도록 설정 */
}

.user-list{
    list-style: none; /* 리스트 스타일 제거 */
    padding: 0; /* 패딩 제거 */
    margin: 0; /* 마진 제거 */
}

.followUser-container{
    display: flex;
    align-items: center;
    width: 100%;
    margin-top: 5px;
}

.user-info {
    display: flex;
    flex-direction: column;
    justify-content: center; /* 세로 가운데 정렬 */
    height: 100%;
}

.userNickname {
    font-weight: bold;
    font-size: 16px; /* 글씨 크기 조정 */
}

.userId {
    color: #555;
    font-size: 14px; /* 글씨 크기 조정 */
}

/* 이미지 스타일 */
.followUser-container img {
    width: 44px; /* 이미지 너비 조정 */
    height: 44px; /* 이미지 높이 조정 */
    border-radius: 50%;
    object-fit: cover;
    margin-right: 10px;
    border: 1px solid gray;
}

.followers-modal, .followings-modal {
    display: none; /* 초기에는 숨김 */
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.4); /* 반투명 배경 */
}

.modal-content-follow {
    background-color: #fefefe;
    margin: 10% auto; /* 화면 상단에서 약간 내려온 위치 중앙 */
    padding: 20px;
    border: 1px solid #888;
    width: 440px; /* 너비 440px */
    height: 440px; /* 높이 440px */
    border-radius: 8px;
}

.follow-modal-header{
	display: flex;
	width: 100%;
}
.header-font{
	width: 90%;
}
.user-follow-close {
 	flex: 0 0 auto; /* 고정된 너비 */
    color: #aaa;
    width: 10%;
    font-size: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    cursor: pointer;
}

.followings-ultag,
.followers-ultag{
	width: 100%;
	height: 380px;
	overflow-y: auto; /* 내용이 많을 경우 스크롤 */
}
.user-follow-close:hover,
.user-follow-close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}
#followersLoading, #followingsLoading {
    text-align: center;
    padding: 10px;
    font-size: 14px;
    color: #777;
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
                            src="${not empty loginMember.userImage ? loginMember.userImage : '/resources/profile_file/default_profile.png'}"
                            alt="프로필 이미지" />
			</div>
			 <div id="profile-text">
				 <span id="myId">${loginMember.userId}</span> <br>
				 <span class="myNick" id="myNick">${loginMember.userNickname}</span>
				 
				 <div id="follow-text">
    				<span class="followCount">팔로워 ${followerCount}</span>
					<span class="followingCount">팔로잉 ${followingCount}</span>
				 </div>
																									 
				 <div> <%--구현안된 페이지는 홈으로 랜딩 --%>
				 	<button class="profile-button" onclick="openProfileModal()"> 프로필 편집 </button>
				 	<button class="profile-button" id="updPet" onclick="openMypetModal()"> 마이펫 편집 </button>
				 </div>	
				 <div>	
				 	<button class="profile-button" id="allBook" onclick="location.href='/member/mainFeed.kh'"> 북마크 확인 </button>
				 </div>			 
			 </div>
		</div> 	
	
	    <div class="post-write">
			<button class="write-button" id="post-button" > 일기 쓰기 </button>
	    </div>
    	
	    <div class="post-container">
	   		<c:forEach var="post" items="${post}">
	   			<div class="post-grid" data-id="${post.postNo}">
	   				<img class="feed-thumbnail" src="/resources/post_file/${post.postFileName}" alt="thumbnail">
	   				<p class="hidden-post-content" style="display: none;">${post.postContent}</p>			
	   			</div>
	   		</c:forEach>
	    </div>
	    
	    <%--포스트 modal--%>
	    <%@ include file="/WEB-INF/views/member/postModal.jsp" %>
	  	
	  	
		<%-- 포스트 작성 모달창 --%>
		<div class="post-modal" id="write-modal">
			<div class="modal-place">
	
				<form id="postForm" action="/post/write.kh" method="post"
					enctype="multipart/form-data">
					<input type="hidden" name="userNo"
						value="${sessionScope.loginMember.userNo}">
					<div class="modal-body">
						<div class="top">
							<span class="modal-title">일기쓰기</span> <a href="#"
								class="modal-close" id="post-write-close">X</a>
						</div>
	
						<div>
							<span class="modal-title">이미지, 영상파일 추가</span> <br> <input
								name="files" type="file" id="post-input"
								accept=".jpg, .gif, .png, .jpeg, .mp4, .wmv, .mov" multiple>
						</div>
	
						<div>
							<span>내용 추가</span> <br>
							<textarea name="content" rows="10" cols="55" style="resize: none;"></textarea>
						</div>
	
						<div>
							<span>태그 추가</span> <br> <input name="hashtag"
								placeholder="태그를 입력하세요.(최대 5개)" id="post-hashtag" type="hidden">
						</div>
	
						<div>
							<input type="submit" value="작성" id="post-submit">
						</div>
	
					</div>
				</form>
	
			</div>
		</div>
	
	
		<%-- 포스트 수정 모달창 --%>
		<div class="post-modal" id="update-modal">
			<div class="modal-place">
	
				<form id="update" action="/post/update.kh" method="post"
					enctype="multipart/form-data">
					<input type="hidden" name="userNo"
						value="${sessionScope.loginMember.userNo}"> <input
						type="hidden" name="postNo" id="postNo">
	
					<div class="modal-body">
						<div class="top">
							<span class="modal-title">일기 수정</span> <a href="#"
								class="modal-close" id="post-update-close">X</a>
						</div>
	
						<div>
							<span>내용 수정</span> <br>
							<textarea name="content" rows="10" cols="55" style="resize: none;"
								id="postContent"></textarea>
						</div>
	
						<div>
							<span>태그 수정</span> <br> <input name="hashtag" id="editTags"
								placeholder="태그를 입력하세요.(최대 5개)" type="hidden">
						</div>
	
						<div>
							<input type="submit" value="수정" id="post-update-submit">
						</div>
					</div>
				</form>
	
			</div>
		</div>
	  	
	  	<div id="followersModal" class="followers-modal follow-modal">
            <div class="modal-content-follow">
            	<div class="follow-modal-header">
            		<div class="header-font">
		                <h2>팔로워 목록</h2>
            		</div>
	                <span class="user-follow-close">&times;</span>
            	</div>
            	<div class="followers-ultag" >
	                <ul class="user-list" id="followersList">
	                </ul>
            	</div>
                <div id="followersLoading" style="display: none; text-align: center;">
                     <i class="fas fa-spinner fa-spin"></i> 로딩 중...
                </div>
            </div>
        </div>

        <div id="followingsModal" class="followings-modal follow-modal">
            <div class="modal-content-follow">
                <div class="follow-modal-header">
                	<div class="header-font">
		                <h2>팔로잉 목록</h2>
                	</div>
	                <span class="user-follow-close">&times;</span>
            	</div>
            	<div class="followings-ultag">
	                <ul class="user-list" id="followingsList">
	                </ul>
            	</div>
                <div id="followingsLoading" style="display: none; text-align: center;">
                     <i class="fas fa-spinner fa-spin"></i> 로딩 중...
                </div>
            </div>
        </div> 
	  	  		    
	</main>
	
	<%@ include file="/WEB-INF/views/member/rightSideMenu.jsp" %>

	<script>
		
		//삭제, 수정 스크립트
	    $(".feed-thumbnail").on("click", function () {
		     
	    	let postNo = $(this).closest(".post-grid").data("id");
	    	
		    // 게시물 삭제
		    $("#post-delete").off("click").on("click", function () {
		        if (confirm("게시물을 삭제하시겠습니까?")) {
		            $.ajax({
		                url: "/post/delete.kh",
		                method: "GET",
		                data: { postNo: postNo },
		                success: function (res) {
		                    alert("게시물이 삭제되었습니다.");
		                    location.reload();
		                },
		                error: function () {
		                    alert("게시물 삭제에 실패하였습니다! 다시 시도해주세요.");
		                },
		            });
		        }
		    });
	
		    // 게시물 수정
		 // 게시물 수정
		    $("#post-update").on("click", function () {
		        const postContent = $(this).closest(".post-grid").find(".hidden-post-content").text(); // 게시물 내용
		        const postTags = $(this).closest(".post-grid").data("tags"); // 기존 태그 데이터
	
		        $("#postNo").val(postNo); // 게시물 번호
		        $("#postContent").val(postContent); // 게시물 내용
	
		        $("#update-modal").css("display", "block"); // 수정 모달 열기
	
		        const tagInput = document.querySelector("#editTags");
	
		        // 기존 Tagify 인스턴스 제거
		        if (tagInput._tagify) {
		            tagInput._tagify.destroy();
		        }
	
		        // 새로운 Tagify 인스턴스 생성
		        const tagify = new Tagify(tagInput, {
		            delimiters: ", ",
		            maxTags: 5,
		            pattern: /^[가-힣]{1,30}$/, // 한글만 허용
		            duplicates: false, // 중복 태그 방지
		        });
	
		        // 기존 태그 데이터 처리
		        const tagList = postTags ? postTags.map(tag => tag.value) : []; // 데이터가 없을 경우 빈 배열
		        tagify.addTags(tagList); // Tagify에 기존 태그 추가
	
		        // 폼 제출 시 태그 데이터 처리
		        $("#update").on("submit", function (event) {
		            event.preventDefault(); // 기본 폼 제출 방지
	
		            // Tagify에서 현재 태그 데이터를 가져옴
		            const tagData = tagify.value;
		            const tagValues = tagData.map(tag => tag.value); // 태그 값만 추출
	
		            // JSON 문자열로 변환하여 hidden input에 설정
		            const tagString = JSON.stringify(tagValues);
		            $("#editTags").val(tagString);
	
		            // 최종 폼 제출
		            this.submit();
		        });
		    });
	
	    });
		
		
	 	// 포스트 작성 열기/닫기
	    $("#post-button").on("click", function () {
	        $("#write-modal").css("display", "block");
	    });
	    
	    $(".modal-close").on("click", function () {
	        $("#write-modal").css("display", "none");
	    });

	    // 포스트 수정 닫기
	    $(".modal-close").on("click", function () {
	        $("#update-modal").css("display", "none");
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
	
		
			// 사진이 하나라도 없으면 작성 불가
			 const imageCk = $("#post-input");
			 const submit = $("#post-submit");
	
			 submit.on("click", function (event) {
			     // 기본 제출 동작 방지
			     event.preventDefault();
	
			     if (!imageCk[0].files.length) {
			         alert("1개 이상의 이미지를 등록해야 합니다!");
			     } else {
			         let tagData = tagify.value;
			         let tagList = [];
	
			         for (let tag of tagData) {
			             tagList.push(tag["value"]);
			         }
	
			         let tagString = JSON.stringify(tagList);
			         $("#post-hashtag").val(tagString);
			         $("#postForm")[0].submit();
			         
			         
			     }
			 });
	
			
	</script>
	
	
	
	<%-- 포로필 modal --%>
	<script>
	function createProfileHTML(){
	    return `
	    <div class="modal-backdrop-G" id="profileModalBackdrop" style="display: none;">
	    <div class="modal-G" id="profileModal" style="display: none;">
	        <div class="modal-content-G">
	            <h2>프로필 편집</h2>

	            <div class="modal-body-G">
	                <div class="modal-left-G">
	                    <div class="profile-image-container">
	                        <img id="proImagePreview"
	                            alt="프로필 이미지" />
	                    </div>
	                    <div class="image-btn-group">
	                        <button id="btnChangeImage" class="btn">변경</button>
	                        <button id="btnDeleteImage" class="btn btn-delete">삭제</button>
	                        <input type="file" id="userImage" name="userImage" accept="image/*"
	                            style="display: none;" />
	                    </div>

	                    <div class="info-group">
	                        <label for="userId">아이디</label>  
	                        <input type="text" id="userId" class="modal-in" name="userId" readonly/>
	                    </div>
	                    <div class="info-group">
	                        <label for="userName">이름</label>
	                        <input type="text" id="userName" class="modal-in" name="userName" readonly/>
	                    </div>
	                    <button id="btnDeleteUser" class="btn btn-delete">탈퇴</button>
	                    <button id="btnUpdataPw" class="btn">비밀번호 변경</button>
	                </div>

	                <div class="modal-right-G">
	                    <div class="form-group duplication-group">
	                        <label for="userNickname">닉네임</label>
	                        <div class="input-with-btn">
	                            <input type="text" class="modal-in" id="userNickname" name="userNickname" />
	                            <button type="button" id="btnCheckNickname" class="btn btn-dup-check">
	                                중복확인
	                            </button>
	                        </div>
	                    </div>

	                    <div class="form-group">
	                        <label for="userAddress">주소</label>
	                        <input type="text" class="modal-in" id="userAddress" name="userAddress"
	                            placeholder="OO시 OO구"/>
	                    </div>

	                    <div class="form-group">
	                        <label for="userEmail">이메일<span id="invalidEmail"></span></label>
	                        <input type="email" class="modal-in" id="userEmail" name="userEmail"
	                            placeholder="aaa@example.co.kr"/>
	                    </div>

	                    <div class="form-group duplication-group">
	                        <label for="userPhone">전화번호<span id="invalidPhone"></span></label>
	                        <div class="input-with-btn">
	                            <input type="text" class="modal-in" id="userPhone" name="userPhone"
	                                placeholder="010-0000-0000"/>
	                            <button type="button" id="btnCheckPhone" class="btn btn-dup-check">
	                                중복확인
	                            </button>
	                        </div>
	                    </div>

	                    <div class="button-area">
	                        <button class="btn save-btn" id="saveBtn">수정</button>
	                        <button class="btn cancel-btn" id="cancelBtn">취소</button>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
	    `;
	}
	
	// 업데이트 된 정보를 담을 객체 선언
	let updMember = {
            userId: "",
            userName: "",
            userImage: "",
            userNickname: "",
            userAddress: "",
            userEmail: "",
            userPhone: ""
	};
	
	// 선택된 프로필 이미지 파일 보관
	let selectedProfileImageFile = null;

	function openProfileModal(){
	    // 1. 모달 HTML 문자열 생성
	    const modalHTML = createProfileHTML();

	    // 2. 임시로 div를 만들고, 그 안에 모달 HTML을 주입
	    const tempDiv = document.createElement('div');
	    tempDiv.innerHTML = modalHTML.trim();

	    // 3. 실제 모달 요소(overlay)를 가져오기
	    // (tempDiv 안에 있는 첫 번째 자식이 우리가 만든 .modal-overlay)
	    const modalOverlay = tempDiv.firstChild;

	    // 4. body에 모달 요소를 추가 
	    $('#myfeed-main').append(modalOverlay);
	    
	    // 5. 모달 표시	
	    $("#profileModalBackdrop").css("display", "block");
	    $("#profileModal").css("display", "block");
	    
		// user를 구분할 값
		const currentUserPhone = "${loginMember.userPhone}";
		const currentNickname = "${loginMember.userNickname}";
	    
		let updId = $("#userId");
		let updName = $("#userName");
		let updNickname = $("#userNickname");
		let updAddress = $("#userAddress");
		let updEmail = $("#userEmail");
	    let updPhone = $("#userPhone");
	    let updImage = $("#proImagePreview");
	    
	    // 이미지 파일 변경없음과 삭제를 구분할 변수
	    let delChk = false;	    

	 	// updMember 데이터가 비어 있으면 loginMember 데이터를 기본값으로 사용
	    updId.val(updMember.userId || "${loginMember.userId}");
	    updName.val(updMember.userName || "${loginMember.userName}");
	    updNickname.val(updMember.userNickname || "${loginMember.userNickname}");
	    updAddress.val(updMember.userAddress || "${loginMember.userAddress}");
	    updEmail.val(updMember.userEmail || "${loginMember.userEmail}");
	    updPhone.val(updMember.userPhone || "${loginMember.userPhone}");
	    updImage.attr("src", updMember.userImage || "${loginMember.userImage}" || "/resources/profile_file/default_profile.png");
	    
	    // (이벤트) 모달 바깥(배경) 클릭 시 닫기
	    $("#profileModalBackdrop").on("click", function (event) {
	        if (event.target === this) {
	            closeProfileModal();
	        }
	    });

	    // (이벤트) 취소 버튼
	    $("#cancelBtn").on("click", closeProfileModal);
	    
	    // 모달 닫기 함수
	    function closeProfileModal() {
	        $("#profileModalBackdrop").remove(); // DOM에서 제거
	    }
	    
	    // (이벤트) 이미지 변경 버튼 → file input 클릭
	    $("#btnChangeImage").on("click", function () {
	        $("#userImage").click();
	    });
	    
	    // (이벤트) 파일 input 변경 시 → 미리보기
	    $("#userImage").on("change", imageChange);

	    // (이벤트) 이미지 삭제
	    $("#btnDeleteImage").on("click", imageDelete);
	    
	     // (이벤트) 닉네임 중복확인
	    $("#btnCheckNickname").on("click", checkNickname);

	    // (이벤트) 전화번호 중복확인
	    $("#btnCheckPhone").on("click", checkPhone);

	    // (이벤트) 수정 버튼
	    $("#saveBtn").on("click", profileUpdate);
	    
	    // (이벤트) 회원탈퇴 버튼
	    $("#btnDeleteUser").on("click", deleteUser);
	    
	 	// (이벤트) 비밀번호 변경 버튼
	    $("#btnUpdataPw").on("click", openPasswordModal);
	    
	    // 이미지 변경
	    function imageChange() {
	        const fileInput = this;
	        const file = fileInput.files[0];
	        if (!file) return;

	        // selectedProfileImageFile에 저장
	        selectedProfileImageFile = file;

	        // 미리보기
	        const reader = new FileReader();
	        reader.onload = (e) => {
	            $("#proImagePreview").attr("src", e.target.result);
	        };
	        reader.readAsDataURL(file);
	            
	        // 파일 선택 후 같은 파일을 다시 선택할 수 있도록 `value`를 초기화
	        fileInput.value = "";
	    }

	    // 이미지 삭제
	    function imageDelete() {
	        if (!confirm("정말 이미지를 삭제하시겠습니까?")) return;

	        // 기본이미지로 변경
	        updImage.attr("src", "/resources/profile_file/default_profile.png");
	        
	        // 초기화
	        selectedProfileImageFile = null;
	        
	        // 파일 입력 요소 초기화
	        $("#userImage").val("");
	        
	        delChk = true;
	    }
	    
	    //유효성 검증 변수
	    let phoneVal = false;
	    let emailVal = false;
	    
	    //중복체크 검증 변수 - insert가 아닌 update이기 때문에 처음에 true로 선언
	    let chkDuplNick = true;
	    let chkDuplPhone = true;
	    
	    //전화번호
	    
	    const phMessage =$("#invalidPhone");
	    
	    const phRegExp = /^0\d{2}-\d{3,4}-\d{4}$/;  //전화번호 패턴
	    
	    function chkUserPhone(){
	        const value = updPhone.val();
	        
	        if(phRegExp.test(value)){
	            phMessage.text("");
	            phMessage.css("color", "");
	            phoneVal = true;
	        }else{
	            phMessage.text("올바른 형식이 아닙니다.");
	            phMessage.css("color","red");
	            phoneVal = false;
	        }
	    }
	    
	    updPhone.on("input", chkUserPhone);
	    
	    //이메일
	   
	    const emMessage =$("#invalidEmail");
	    
	    const emRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;  //이메일 패턴
	    
	    function chkUserEmail() {
	        const value = updEmail.val();
	        if (emRegExp.test(value)) {
	            emMessage.text("");
	            emMessage.css("color", "");
	            emailVal = true;
	        } else {
	            emMessage.text("올바른 형식이 아닙니다.");
	            emMessage.css("color", "red");
	            emailVal = false;
	        }
	    }
	    
	    updEmail.on("input", chkUserEmail);
	    
	 	// 입력 정보 체크
        chkUserEmail();
        chkUserPhone();
	    
	    // 닉네임
	    // 닉네임 입력 시, 중복체크 변수를 false로 변경
	    updNickname.on('input', function(){
	        chkDuplNick = false;
	    });

	    function checkNickname(){
	        //입력값이 없는 경우
	        if(!updNickname.val()){
	            alert("닉네임을 입력해주세요");
	            return;
	        }
	        
	        $.ajax({
	            url : "/member/nickDuplChk.kh", //중복검사 서블릿
	            data :{ userNickname : updNickname.val()},
	            type : "GET",
	            
	            success : function(res) {
	                if(res == '1' && updNickname.val() !== currentNickname){
	                    alert("이미 사용중인 닉네임입니다.")
	                    chkDuplNick = false;
	                }else{
	                    alert("사용 가능한 닉네임입니다.")
	                    chkDuplNick = true;
	                }
	            },
	            error : function () {
	                console.error("ajax 요청 실패!")
	            }
	        });
	    }
	    
	    // 전화번호
	    // 전화번호 입력 시, 중복체크 변수를 false로 변경
	    updPhone.on('input', function(){
	        chkDuplPhone = false;
	    });
	    
	    function checkPhone(){
	        //입력값이 없는 경우
	        if(!updPhone.val()){
	            alert("전화번호를 입력해주세요");
	            return;
	        }
	        
	        
	        $.ajax({
	            url : "/member/phoneDuplChk.kh", //중복검사 서블릿
	            data :{ userPhone : updPhone.val()},
	            type : "GET",
	            
	            success : function(res) {
	                if(res == '1' && updPhone.val() !== currentUserPhone){
	                    alert("이미 가입된 전화번호입니다.")
	                    chkDuplPhone = false;
	                }else{
	                    alert("사용 가능한 전화번호입니다.")
	                    chkDuplPhone = true;
	                }
	            },
	            error : function () {
	                console.error("ajax 요청 실패!")
	            }
	        });
	    }
	    
	    // 프로필 업데이트
	    
	    function profileUpdate(){
	        //빈칸 검사 - 배열 저장
	           const inputVal = [
	            { field: updNickname, message: "닉네임을 입력하세요." },
	            { field: updAddress, message: "주소를 입력하세요." },
	            { field: updEmail, message: "이메일을 입력하세요." },
	            { field: updPhone, message: "전화번호를 입력하세요." }
	            ];
	        
	        //유효성 변수
	        let isValid = false;
	        
	        //빈값 확인
	        for(let i=0; i<inputVal.length; i++){	
	            if(!inputVal[i].field.val()){
	                alert(inputVal[i].message);
	                isValid = false;
	                return;
	            }		  
	            isValid = true;
	        }
	        
	        // 중복 검사 확인
	        if (!chkDuplNick) {
	            alert("닉네임 중복검사를 완료해주세요.");
	            return;
	        }
	        if (!chkDuplPhone) {
	            alert("전화번호 중복검사를 완료해주세요.");
	            return;
	        }
	        
	        //데이터 유효 검사
	        isValid = phoneVal && 
	                  emailVal && 
	                  chkDuplNick && 
	                  chkDuplPhone;
	        
	        //제출 - 유효성 검사가 끝난 후 
	        if(isValid){
	            // 전달할 데이터들을 formData에 세팅
	            const formData = new FormData();
	            formData.append("userId", updId.val());
	            formData.append("userNickname", updNickname.val());
	            formData.append("userAddress", updAddress.val());
	            formData.append("userEmail", updEmail.val());
	            formData.append("userPhone", updPhone.val());

	            // 이미지 파일을 업로드 했을 시 formData에 세팅
	            if(selectedProfileImageFile){
	                formData.append("file", selectedProfileImageFile);
	            }
	            // 이미지 파일을 삭제 했을 시 구분 값
	            if(delChk){
	            	formData.append("delChk", true);
	            }

	            $.ajax({
	                url : "/member/updateProfile.kh",
	                type: "post",
	                data: formData,
	                processData: false, // 데이터를 쿼리 문자열로 변환하지 않음
	                contentType: false, // 콘텐츠 타입을 설정하지 않음 (브라우저가 자동으로 설정)
	                success: function(updatedMember){
	                    if(updatedMember){
	                    	updMember = updatedMember;
	                    
	                        $(".myNick").text(updatedMember.userNickname);
	                        $(".profileImage").attr("src", updatedMember.userImage || "/resources/profile_file/default_profile.png");
	                        updImage.attr("src", updatedMember.userImage || "/resources/profile_file/default_profile.png");
	                        
	                        alert("프로필이 업데이트되었습니다");
	                    }else{
	                        alert("프로필 업데이트에 실패했습니다.");
	                    }
	                    closeProfileModal();
	                },
	                error: function(){
	                    console.log('ajax 통신 오류');
	                }
	            });
	        }else{
	             alert("유효하지 않은 입력값이 있습니다. 다시 확인해주세요.")
	             return;
	        }
	    }
	    
	    // 회원탈퇴
	    function deleteUser(){
	        if (!confirm("정말 회원 탈퇴를 하시겠습니까?")) return;
	        
	        window.location.href = "/member/userUnlink.kh";
	    }
	    
		// 비밀번호 변경
	    function createPasswordHTML(){
		    return `
	    	<div class="modal-G" id="updatePwModal" style="display: none;">
	        	<div class="modal-content-G" id="updatePwContent">
	            	<h2>비밀번호 변경</h2>
	            	
		            <div class="modal-body-G" id="updatePwBody">
	                    <div class="form-group">
	   	                    <label for="currentPw">현재 비밀번호</label>
           	                <input type="password" class="modal-in-pw" id="currentPw" name="currentPw" />
		                    
	                        <label for="newPw">새 비밀번호<span id="invalidNewPw"></label>
    	                    <input type="password" class="modal-in-pw" id="newPw" name="newPw" placeholder="영어+숫자 5~16글자 이내" />
	            	        
	                        <label for="cofirmNewPw">새 비밀번호 확인<span id="invalidConPw"></span></label>
       	                    <input type="password" class="modal-in-pw" id="cofirmNewPw" name="cofirmNewPw" />
            	        </div>
                       	
	                    <div class="button-area">
	                        <button class="btn save-btn" id="savePwBtn">수정</button>
    	                    <button class="btn cancel-btn" id="cancelPwBtn">취소</button>
        	            </div>
	            	</div>
	    	    </div>
		    </div>
		    `;
		}
	    
	    function openPasswordModal(){
	    	// 1. 모달 HTML 문자열 생성
		    const modalHTML = createPasswordHTML();

		    // 2. 임시로 div를 만들고, 그 안에 모달 HTML을 주입
		    const tempDiv = document.createElement('div');
		    tempDiv.innerHTML = modalHTML.trim();

		    // 3. 실제 모달 요소(overlay)를 가져오기
		    // (tempDiv 안에 있는 첫 번째 자식이 우리가 만든 .modal-overlay)
		    const modalOverlay = tempDiv.firstChild;

		    // 4. body에 모달 요소를 추가 
		    $('#profileModalBackdrop').append(modalOverlay);
		    
		    // 5. 모달 표시	
		    $("#updatePwModal").css("display", "block");
		    
		    
		 	// (이벤트) 패스워드 취소 버튼
			$("#cancelPwBtn").on("click", closePassWordModal);
		    
		    // (이벤트) 패스워드 수정 버튼
		    $("#savePwBtn").on("click", passwordUpdate);
		    
		    // 패스워드 모달 닫기 함수
		    function closePassWordModal() {
		        $("#updatePwModal").remove(); // DOM에서 제거
		    }
		    
		    
		 	// 유효성 검증 변수
			let isValid = false;
			let newPwConfirm = false;
			let newPwChk = false;
		    
			//비밀번호 형식 검증
			const currPw = $("#currentPw");
			const newPw = $("#newPw");
			const newPwMessage = $("#invalidNewPw");
			
			const newPwRegExp = /^[a-zA-Z0-9]{5,16}$/;  //5~16 글자 이내
			
			newPw.on("input", function(){
				const value = $(this).val();
					newPwMessage.text("*현재 비밀번호와 동일");
					newPwMessage.css("color","red");
					newPwConfirm = false;
				if(currPw.val() === newPw.val()){
					
				}else if(newPwRegExp.test(value)){
					newPwMessage.text("");
					newPwMessage.css("color", "");
					newPwConfirm = true;
				}else{
					newPwMessage.text("*영어+숫자 5~16글자");
					newPwMessage.css("color","red");
					newPwConfirm = false;
				}
				updateValidity();
			});
			
			//비밀번호 확인
			const cofirmNewPw = $("#cofirmNewPw");
			const conPwMessage = $("#invalidConPw");
			
			cofirmNewPw.on("input",function(){
				
				if(cofirmNewPw.val() == newPw.val()){
					conPwMessage.text("비밀번호 일치");
					conPwMessage.css("color", "gray");
					newPwChk = true;
				}else{
					conPwMessage.text("비밀번호 불일치");
					conPwMessage.css("color", "red");
					newPwChk = false;
				}
				updateValidity();
			});
		    
			// 유효성 업데이트 변수
			function updateValidity(){
			isValid = newPwConfirm && newPwChk;
			}
			
		    // 패스워드 수정 함수
		    function passwordUpdate(){
		    	if(isValid){
		    		// 전달할 데이터들을 formData에 세팅
		            const formData = new FormData();
		            formData.append("userPw", currPw.val());
		            formData.append("userNewPw", newPw.val());
		    		
		    		$.ajax({
		                url : "/member/updatePassword.kh",
		                type: "post",
		                data: formData,
		                processData: false, // 데이터를 쿼리 문자열로 변환하지 않음
		                contentType: false, // 콘텐츠 타입을 설정하지 않음 (브라우저가 자동으로 설정)
		                success: function(res){
		                    if(res == 2){
		                        alert("비밀번호가 변경되었습니다. 재로그인 부탁드립니다.");
		                        
		                        window.location.href = "/";
		                    }else if(res == 1){
		                    	alert("비밀번호 변경 실패했습니다.");
		                        return;
		                	}else{
		                        alert("비밀번호가 일치하지 않습니다.");
		                        return;
		                    }
		                },
		                error: function(){
		                    console.log('ajax 통신 오류');
		                }
		            });
		    	}else{
		    		alert("유효하지 않은 입력값이 있습니다. 다시 확인해주세요.")
				 	return;
		    	}
		    }
	    }
	}
	
	// 마이펫 HTML
	function createMypetHTML(){
	    return `
	    <div class="modal-backdrop-G" id="mypetModalBackdrop" style="display: none;">
	    <div class="modal-G" id="mypetModal" style="display: none;">
	        <div class="modal-content-G">
	            <h2>마이펫 편집</h2>

	            <div class="modal-body-G">
	                <div class="modal-left-G" id="pet-box-container">
	                </div>

	                <div class="modal-right-G">
	                    <div class="form-group">
	                        <label for="petName">이름</label>
                            <input type="text" class="modal-in" id="petName" name="petName" />
	                    </div>

	                    <div class="form-group">
	                        <label>성별</label>
	                        <div class="radio-group">
                        	<label><input type="radio" name="petGender" value="M"> 수컷  </label>
                            <label><input type="radio" name="petGender" value="F"> 암컷  </label>
                            </div>
	                    </div>

	                    <div class="form-group">
	                        <label>종류</label>
	                        <div class="radio-group">
                        	<label><input type="radio" name="petType" value="DOG"> 댕댕이</label>
                            <label><input type="radio"  name="petType" value="CAT"> 냥냥이</label>
                            </div>
	                    </div>

	                    <div class="form-group">
	                        <label for="breedType">품종</label>
							<select class="breedType" name="breedType">
								
							</select>
	                    </div>

	                    <div class="button-area">
	                    	<button class="btn btn-dup-check" id="insertPetBtn">추가</button>
	                        <button class="btn save-btn" id="updatePetBtn">수정</button>
	                        <button class="btn cancel-btn" id="cancelPetBtn">취소</button>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
	    `;
	}
	
	function openMypetModal(){
    	// 1. 모달 HTML 문자열 생성
	    const modalHTML = createMypetHTML();

	    // 2. 임시로 div를 만들고, 그 안에 모달 HTML을 주입
	    const tempDiv = document.createElement('div');
	    tempDiv.innerHTML = modalHTML.trim();

	    // 3. 실제 모달 요소(overlay)를 가져오기
	    // (tempDiv 안에 있는 첫 번째 자식이 우리가 만든 .modal-overlay)
	    const modalOverlay = tempDiv.firstChild;

	    // 4. body에 모달 요소를 추가 
	    $('#myfeed-main').append(modalOverlay);
	    
	    // 5. 모달 표시	
	    $("#mypetModalBackdrop").css("display", "block");
	    $("#mypetModal").css("display", "block");
	    
	    const userNo = "${loginMember.userNo}";
 	    
		$('.breedType').select2();
        
        selectUserMypet(userNo);
    	
     	// petType 변경 이벤트 추가
        $("input[name='petType']").on("change", function () {
            const selectedType = $(this).val(); // 선택된 petType 값
            updateBreedOptions(selectedType); // 옵션 업데이트 호출
        });
	    
	    // 내 반려동물 리스트
	    function selectUserMypet(userNo){
	    	$.ajax({
	            url: '/member/selectMypet.kh',
	            type: 'POST',
	            data: { userNo: userNo }, // petType을 파라미터로 전달
	            success: function (res) {
	            	const petBoxContainer = $('#pet-box-container');
	            	petBoxContainer.empty();
	            	
	            	res.forEach(mypet => {
	                    const $petBox = $('<div>', { class: 'pet-box' });
	                    
	                    const $petImageContainer = $('<div>', { class: 'pet-image-container' });
	                    const $img = $('<img>', {
	                        id: 'proImagePreview',
	                        src: '/resources/css_image/' + mypet.petType + '.png',
	                        alt: '반려동물 이미지'
	                    });
	                    $petImageContainer.append($img);

	                    const $petNameDiv = $('<div>', { 
	                        class: 'petName',
	                        text: mypet.petName
	                    });
	                    
	                    const $cancelBtn = $('<button>', {
	                        class: 'btn btn-delete',
	                        id: 'deletePetBtn_'+mypet.petNo,
	                        text: '삭제'
	                        
	                    // 삭제 버튼 이벤트
	                    }).on("click", deletePet);

	                    $petBox.append($petImageContainer);
	                    $petBox.append($petNameDiv);
	                    $petBox.append($cancelBtn);

	                    petBoxContainer.append($petBox);
	                    
	                 	// `pet-box` 클릭 이벤트
	                    $petBox.on('click', function () {
	                    	
	                        // 다른 박스의 선택 상태 초기화
	                        $('.pet-box').css('background-color', '');
	                        $('.pet-box').find('#petNo').remove();
	                        
	                        // 클릭된 박스 선택
	                        $petBox.css('background-color', '#f0a235');
	                        
	                        const $hiddenInput = $('<input>', {
		                    	id: 'petNo',
		                        type: 'hidden', 
		                        value: mypet.petNo 
		                    });
	                        $petBox.append($hiddenInput)
	                        
	                        // 오른쪽 폼 값 설정
	                        $('#petName').val(mypet.petName);
	                        $('input[name="petGender"][value="' + mypet.petGender + '"]').prop('checked', true);
	                        $('input[name="petType"][value="' + mypet.petType + '"]').prop('checked', true);
	                        updateBreedOptions(mypet.petType, mypet.breedType);
	                    });
	                });

	            },
	            error: function(xhr, status, error) {
	                console.error("에러 발생:", error);
	            }
	        });
	    }
	    
		// 품종 옵션 업데이트 함수
	    function updateBreedOptions(petType, selectedBreed = null) {
	        // AJAX 요청으로 DB에서 품종 목록 가져오기
	        $.ajax({
	            url: '/member/breedOption.kh', // 서버 API 엔드포인트
	            type: 'GET',
	            data: { petType: petType }, // petType을 파라미터로 전달
	            success: function (response) {
	                const breedSelect = $('.breedType');
	                breedSelect.empty(); // 기존 옵션 제거
	                
	                // 받아온 데이터로 옵션 추가
	                response.forEach(breedName => {
	                	const option = new Option(breedName, breedName, false, false);
	                    breedSelect.append(option);
	                });

	             	// 선택된 값 설정
	                if (selectedBreed) {
	                    breedSelect.val(selectedBreed).trigger('change');
	                }
	            },
	            error: function (xhr, status, error) {
	                console.error("옵션 가져오기 실패:", error);
	            }
	        });
	    }
	    
	 	// (이벤트) 모달 바깥(배경) 클릭 시 닫기
	    $("#mypetModalBackdrop").on("click", function (event) {
	        if (event.target === this) {
	        	closeMypetModal();
	        }
	    });

	    // (이벤트) 취소 버튼
	    $("#cancelPetBtn").on("click", closeMypetModal);
	    
	    // 모달 닫기 함수
	    function closeMypetModal() {
	        $("#mypetModalBackdrop").remove(); // DOM에서 제거
	    }
	    
	    // (이벤트) 추가 버튼
	    $("#insertPetBtn").on("click", insertPet);
	    
	 	// (이벤트) 수정 버튼
	    $("#updatePetBtn").on("click", updatePet);
	 
	 	// petName 확인
	 	function chkPetName(petName, petGender, petType, breedType){
	 		// petName의 글자수 확인
	 	    const isValid = /^[가-힣]{1,5}$/.test(petName);
	 	    
	 		if (!petName || !petGender || !petType || !breedType) {
	 			alert('입력하지 않은 값이 있습니다.');
	 			return false;
	 	    }
	 		
	 		if (!isValid) {
	 			alert("펫 이름은 한글로 작성해야 하며, 5글자를 초과할 수 없습니다.");
	 	        return false;
	 	    }
	 		
	 		return true;
	 	}
	 	
	 	// 반려동물 추가
	 	function insertPet(){
	 		const petName = $('#petName').val().trim();
	 	    const petGender = $('input[name="petGender"]:checked').val();
	 	    const petType = $('input[name="petType"]:checked').val();
	 	    const breedType = $('.breedType').val();
	 		
	 		// 유효성 검사
	 	    if (!chkPetName(petName, petGender, petType, breedType)) {
	 	        return; // 유효하지 않은 경우 종료
	 	    }
	 	    
	 		$.ajax({
	 	        url: '/member/insertMypet.kh',
	 	        type: 'POST',
	 	        data: {
	 	            petName: petName,
	 	            petGender: petGender,
	 	            petType: petType,
	 	            breedType: breedType,
	 	            userNo: userNo},
	 	        success: function (response) {
	 	        	if (response === 'success') {
	 	                alert('반려동물이 성공적으로 추가되었습니다.');
	 	                selectUserMypet(userNo);
	 	            } else if (response === 'duplicate') {
	 	                alert('이미 동일한 이름의 반려동물이 존재합니다.');
	 	            } else if (response === 'over'){
	 	            	alert('반려동물은 6마리까지 등록 가능합니다.');
	 	            } else {
	 	                alert('반려동물 추가에 실패했습니다. 다시 시도해주세요.');
	 	            }
	 	        },
	 	        error: function (xhr, status, error) {
	 	            console.error('반려동물 추가 중 오류 발생:', error);
	 	        }
	 	    });

	 	}
	 	
	 	function updatePet(){
	 		const petNo = $('#petNo').val();
	 		const petName = $('#petName').val().trim();
	 	    const petGender = $('input[name="petGender"]:checked').val();
	 	    const petType = $('input[name="petType"]:checked').val();
	 	    const breedType = $('.breedType').val();
			console.log(petNo);
	 	   
	 		if (!petNo) {
	 	        alert('수정할 반려동물을 선택하거나 지정해주세요.');
	 	        return;
	 	    }
	 	    
	 		// 유효성 검사
	 	    if (!chkPetName(petName, petGender, petType, breedType)) {
	 	        return; // 유효하지 않은 경우 종료
	 	    }
	 		
	 		$.ajax({
	 	        url: '/member/updateMypet.kh',
	 	        type: 'POST',
	 	        data: {
	 	            petNo: petNo,
	 	            userNo : userNo,
	 	            petName: petName,
	 	            petGender: petGender,
	 	            petType: petType,
	 	            breedType: breedType
	 	        },
	 	        success: function (response) {
	 	            if (response === 'success') {
	 	                alert('반려동물이 성공적으로 수정되었습니다.');
	 	                selectUserMypet("${loginMember.userNo}"); // 갱신
	 	            } else {
	 	                alert('반려동물 수정에 실패했습니다. 다시 시도해주세요.');
	 	            }
	 	        },
	 	        error: function (xhr, status, error) {
	 	            console.error('반려동물 수정 중 오류 발생:', error);
	 	        }
	 	    });
	 	}
	 	
	 	// 반려동물 삭제
	 	function deletePet(e){
	 		const petNo = $(e.target).attr('id').split('_')[1];
	 		
	 		if (!confirm('정말로 이 반려동물을 삭제하시겠습니까?')) {
	 	        return;
	 	    }
	 		
	 		$.ajax({
	 	        url: '/member/deleteMypet.kh',
	 	        type: 'POST',
	 	        data: { petNo: petNo,
	 	        		userNo: userNo},
	 	        success: function (response) {
	 	            if (response === 'success') {
	 	                alert('반려동물이 성공적으로 삭제되었습니다.');
	 	                selectUserMypet(userNo); // 갱신
	 	            } else {
	 	                alert('반려동물 삭제에 실패했습니다. 다시 시도해주세요.');
	 	            }
	 	        },
	 	        error: function (xhr, status, error) {
	 	            console.error('반려동물 삭제 중 오류 발생:', error);
	 	        }
	 	    });
	 	}
	 		
	}
	$(document).ready(function() {
		var userNo = ${member.userNo};
		var followersPage = 1;
	    var followersLimit = 10;
	    var followersEnd = false;
	    var followersIsLoading = false;
	
	    var followingsPage = 1;
	    var followingsLimit = 10;
	    var followingsEnd = false;
	    var followingsIsLoading = false;
	
	    // 팔로워 모달 열기
	    $('#follow-text .followCount').on('click', function() {
	        $('#followersModal').fadeIn();
	        followersPage = 1;
	        followersEnd = false;
	        $('#followersList').empty();
	        loadFollowers(followersPage);
	    });
	
	    // 팔로잉 모달 열기
	    $('#follow-text .followingCount').on('click', function() {
	        $('#followingsModal').fadeIn();
	        followingsPage = 1;
	        followingsEnd = false;
	        $('#followingsList').empty();
	        loadFollowings(followingsPage);
	    });
	
	    // 모달 닫기
	    $('.user-follow-close').on('click', function() {
	        $(this).closest('.follow-modal').fadeOut();
	    });
	
	    // 클릭 외부 영역 닫기
	    $(window).on('click', function(event) {
	        if ($(event.target).hasClass('followers-modal') || $(event.target).hasClass('followings-modal')) {
	            $('.follow-modal').fadeOut();
	        }
	    });
	 	// 디바운스 함수
	    function debounce(func, delay) {
	        var inDebounce;
	        return function() {
	            var context = this;
	            var args = arguments;
	            clearTimeout(inDebounce);
	            inDebounce = setTimeout(function() {
	                func.apply(context, args);
	            }, delay);
	        };
	    }
	 	// 팔로워 무한 스크롤
	    function loadFollowers(page) {
	        if (followersEnd || followersIsLoading) return;
	        followersIsLoading = true;
	        $('#followersLoading').show();
	        $.ajax({
	            url: '/follow/getFollowers',
	            type: 'GET',
	            data: {
	                userNo: userNo,
	                page: page,
	                limit: followersLimit
	            },
	            success: function(response) {
	                if (response.success) {
	                    var followers = response.followers;
	                    if (followers.length < followersLimit) {
	                        followersEnd = true;
	                    }
	                    followers.forEach(function(follower) {
	                        var item = '<li class="user-list-item">';
	                            item += '<a class="user-alink" href="/member/profile.kh?userNo=' + follower.userNo + '" data-type="Post">';
	                            item += '<div class="followUser-container">';
	                            item += '<img src="' + (follower.userImage ? follower.userImage : '/resources/profile_file/default_profile.png') + '" alt="프로필 이미지">';
	                            item += '<div class="user-info">';
	                            item += '<span class="userNickname">' + follower.userNickname + '</span>';
	                            item += '<span class="userId">' + follower.userId + '</span>';
	                            item += '</div>';
	                            item += '</div>';
	                            item += '</a>';
	                            item += '</li>';
	                        $('#followersList').append(item);
	                    });
	                    followersPage++;
	                } else {
	                	console.log('팔로워 목록을 불러오는데 실패했습니다.');
	                }
	            },
	            error: function() {
	            	console.log('서버 오류가 발생했습니다.');
	            },
	            complete: function() {
	                $('#followersLoading').hide();
	                followersIsLoading = false;
	            }
	        });
	    }
	
	 	// 팔로잉 무한 스크롤
	    function loadFollowings(page) {
	        if (followingsEnd || followingsIsLoading) return;
	        followingsIsLoading = true;
	        $('#followingsLoading').show();
	        $.ajax({
	            url: '/follow/getFollowings',
	            type: 'GET',
	            data: {
	                userNo: userNo,
	                page: page,
	                limit: followingsLimit
	            },
	            success: function(response) {
	                if (response.success) {
	                    var followings = response.followings;
	                    if (followings.length < followingsLimit) {
	                        followingsEnd = true;
	                    }
	                    followings.forEach(function(following) {
	                        var item = '<li class="user-list-item">';
	                            item += '<a class="user-alink" href="/member/profile.kh?userNo=' + following.userNo + '" data-type="Post">';
	                            item += '<div class="followUser-container">';
	                            item += '<img src="' + (following.userImage ? following.userImage : '/resources/profile_file/default_profile.png') + '" alt="프로필 이미지">';
	                            item += '<div class="user-info">';
	                            item += '<span class="userNickname">' + following.userNickname + '</span>';
	                            item += '<span class="userId">' + following.userId + '</span>';
	                            item += '</div>';
	                            item += '</div>';
	                            item += '</a>';
	                            item += '</li>';
	                        $('#followingsList').append(item);
	                    });
	                    followingsPage++;
	                } else {
	                	console.log('팔로잉 목록을 불러오는데 실패했습니다.');
	                }
	            },
	            error: function() {
	                console.log('서버 오류가 발생했습니다.');
	            },
	            complete: function() {
	                $('#followingsLoading').hide();
	                followingsIsLoading = false;
	            }
	        });
	    }
	
	    // 팔로워 모달의 .modal-content에 스크롤 이벤트 바인딩
	    $('.followers-ultag').on('scroll', debounce(function() {
	        var scrollHeight = $(this)[0].scrollHeight;
	        var scrollTop = $(this).scrollTop();
	        var containerHeight = $(this).height();
	        if (scrollTop + containerHeight >= scrollHeight - 50) {
	        	loadFollowers(followersPage);
	        }
	    }, 200));
	
	    // 팔로잉 모달의 .modal-content에 스크롤 이벤트 바인딩
	    $('.followings-ultag').on('scroll', debounce(function() {
	        var scrollHeight = $(this)[0].scrollHeight;
	        var scrollTop = $(this).scrollTop();
	        var containerHeight = $(this).height();
	        if (scrollTop + containerHeight >= scrollHeight - 50) {
	            loadFollowings(followingsPage);
	        }
	    },200));
	});
	</script>
</body>
</html>