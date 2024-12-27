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
				<img class="profileImage"
                            src="${not empty loginMember.userImage ? loginMember.userImage : '/resources/profile_file/default_profile.png'}"
                            alt="프로필 이미지" />
			</div>
			 <div id="profile-text">
				 <span id="myId">${loginMember.userId}</span> <br>
				 <span class="myNick" id="myNick">${loginMember.userNickname}</span>
				 
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
	   				<img class="feed-thumbnail" src="/resources/post_file/${post.postFileName}" alt="thumbnail">
	   				<p class="hidden-post-content" style="display: none;">${post.postContent}</p>
	   			</div>
	   		</c:forEach>
	    </div>
	    
	    <%-- 콘텐츠 모달창 --%>
	    <div class="modal">
		    <div class="modal-place">
		        <div class="modal-contents">
		            <div class="modal-image">
		                <%-- 클릭한 게시글의 이미지를 동적으로 삽입 --%>
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
		                    <div class="post-content-hashtag"></div>
		                </div>
				
		                <%-- 나중에 댓글 조회 추가 영역 --%>
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
	
	    // 콘텐츠 모달 내용 업데이트
		$(".feed-thumbnail").on("click", function () {
		    const postGrid = $(this).closest(".post-grid"); // 클릭된 썸네일의 부모 요소
		    const postId = postGrid.data("id"); // 게시글 ID
		    const postContent = postGrid.find(".hidden-post-content").text(); // 숨겨진 콘텐츠 가져오기
		    const postImage = $(this).attr("src"); // 썸네일 이미지 가져오기
			
		    console.log(postImage);
		    console.log(`Post Image: ${postImage}`);

		  
		    $(".modal").css("display", "block");
		    $(".modal .modal-image").html("<img src=" + postImage + " alt=Post File>"); // 이미지 업데이트
		    $(".modal .post-content-text").text(postContent); // 내용 업데이트
		});
	
		// 모달 닫기
		$(".modal-close").on("click", function () {
		    $(".modal").css("display", "none");
		});

		
		//모달창 닫기
		$(".modal-close").on("click", function(){
			$(".modal").css("display", "none");
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
	                        <img id="profileImagePreview"
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
	    let updImage = $("#profileImagePreview");
	    
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
	            $("#profileImagePreview").attr("src", e.target.result);
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
	    
	    // 입력 정보 체크
	    $(document).ready(function() {
	        chkUserEmail();
	        chkUserPhone();
	    });
	    
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
	}
	</script>
</body>
</html>