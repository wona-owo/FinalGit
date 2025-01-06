<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<style>
.material-icons {
	font-size: 28px;
	vertical-align: middle;
	pointer-events: none;
}

.story-modal-backdrop {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.4);
	z-index: 9990;
}

.story-modal-content {
	position: absolute; /* 혹은 fixed */
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 500px;
	height: 600px;
	background: white;
	padding: 20px 0px 20px;
	border-radius: 10px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	overflow: hidden;
}

.story-image-container {
	position: absolute;
    left: 0;
	width: 100%;
	height: 500px; /* 고정 높이 */
	background-color: #f3f3f3;
	display: none;
	justify-content: center;
	align-items: center;
	overflow: hidden;
	border-top: 1px solid #ddd;
	border-bottom: 1px solid #ddd;
}

.story-image-container.active {
    display: flex;
}

.story-image-container img,
.story-image-container video {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}

.story-header {
	display: flex;
	height: 29px;
	justify-content: center;
	gap: 15px;
	padding: 10px;
}

.story-header .story-item{
	position: absolute;
    left: 0px;
    top: 3px;
}
.story-header p{
	margin: 0px;
}


.story-footer {
	position: absolute;
	display: flex;
	height: 29px;
	bottom: 15px;
	right: 0px;
	gap: 15px;
	padding: 10px;
}

.story-nav-btn {
	position: absolute;
	top: 50%;
	transform: translateY(-50%);
	background-color: rgba(0, 0, 0, 0.5);
	color: white;
	border: none;
	padding: 10px;
	border-radius: 50%;
	cursor: pointer;
	z-index: 10;
}

.story-nav-btn:hover {
	background-color: rgba(0, 0, 0, 0.8);
}

.story-prev-btn {
	left: 10px;
}

.story-next-btn {
	right: 10px;
}

/* 닫기 버튼 */
.story-close-btn {
	position: absolute;
	top: 10px;
	right: 10px;
	background: none;
	border: none;
	font-size: 32px;
	color: black;
	cursor: pointer;
}

.story-action-btn {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 40px;
	height: 40px;
	background: none;
	border: none;
	font-size: 24px;
	color: black;
	cursor: pointer;
}

/* ===== 스토리 섹션 ===== */
.stories-container {
    display: flex;
    overflow-x: auto;
    padding: 10px;
    background-color: #fff;
    border-bottom: 1px solid #ddd;
}

.stories-container::-webkit-scrollbar {
    display: none; /* 스크롤바 숨기기 */
}
.story-item {
    flex: 0 0 auto;
    width: 70px;
    margin-left: 5px;
    margin-right: 5px;
    text-align: center;
    cursor: pointer;
}

.story-image {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    border: 2px solid #ff8501; /* 인스타그램의 스토리 테두리 색상 */
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #f5f5f5;
    position: relative;
}

.story-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 50%;
}
.story-item p {
    margin-top: 5px;
    font-size: 12px;
    color: #333;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
</style>
</head>
<body>
	<div class="stories-container">
		<!-- 스토리 아이템: "내 스토리 추가" 버튼 -->
		<div class="story-item add-story" data-user-no="${loginMember.userNo}">
		    <div class="story-image">
			    <img src="${not empty loginMember.userImage ? 
			    	loginMember.userImage : '/resources/profile_file/default_profile.png'}"
			    	alt="프로필 이미지" />
			</div>
		    <p>내 스토리</p>
		</div>
	</div>
	
	<button onclick="openStoryModal()">test</button>
	<button onclick="location.href='/member/mainFeed.kh'">메인화면</button>
	<script>
	$(document).ready(function () {
		searchMyStory();
		searchStoryFollowList();		
	});
	
	// 스토리를 올린 유저 목록과 각 유저의 스토리를 담을 변수
	let storyFollowList = [{
			userNo: "",
			userNickname: "",
			userImage: "",
			userIndex: "",
			fileList: []
	}];
	let myStory = {
		userNo: "",
		userNickname: "",
		userImage: "",
		userIndex: "",
		fileList: []
};
	
	function escapeHtml(text) {
	    const map = {
	        '&': '&amp;',
	        '<': '&lt;',
	        '>': '&gt;',
	        '"': '&quot;',
	        "'": '&#039;'
	    };
	    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
	}
	
	// 스토리 목록 HTML 생성
	function createStoryItem(item) {
	    const imageSrc = item.userImage
	        ? escapeHtml(item.userImage)
	        : '/resources/profile_file/default_profile.png';

	    const safeNickname = escapeHtml(item.userNickname);

	    let html = '';
	    html += '<div class="story-item" data-user-no="' + item.userNo + '">';
	    html +=     '<div class="story-image">';
	    html +=         '<img src="' + imageSrc + '" alt="프로필 이미지" />';
	    html +=     '</div>';
	    html +=     '<p>' + safeNickname + '</p>';
	    html += '</div>';
	    
	    return html;
	}
	
	// 내 스토리 가져오기
	function searchMyStory(){
		$.ajax({
			url: '/story/myStory.kh',
			type: 'POST',
			data: {userNo: "${loginMember.userNo}"},
		 	success: function(res){	
		 		myStory = res;
		 	},
			error: function(xhr, status, error) {
		        console.log("내 스토리 정보를 가져오지 못했습니다.");
		    }
		});
	}
	
	// 팔로우 목록 중 스토리 올린사람
	function searchStoryFollowList(){
		$.ajax({
			url: '/story/storyFollowList.kh',
			type: 'POST',
			data: {userNo: "${loginMember.userNo}"},
		 	success: function(res){
				const $storiesContainer = $('.stories-container');
		        // "내 스토리 추가" 버튼을 제외한 모든 기존 스토리 아이템을 제거
		        $storiesContainer.find('.story-item').not('.add-story').remove();
		        
		        // res 데이터를 storyFollowList에 재할당
		        storyFollowList = res;
		        
		        if (Array.isArray(storyFollowList)) {
		            let storyHtml = '';
		            
		            for (let i = 0; i < storyFollowList.length; i++) {
		                const item = storyFollowList[i];
		
		                storyHtml += createStoryItem(item);
		            }
		            
		            $storiesContainer.append(storyHtml);
		        } else {
		            console.error('응답 데이터가 배열이 아닙니다.');
		            $storiesContainer.html('<p>Invalid data format.</p>');
		        }
			},
			error: function(xhr, status, error) {
		        console.error("AJAX 요청 실패:", status, error);
		        const $storiesContainer = $('.stories-container');
		        // "내 스토리 추가" 버튼을 제외한 모든 스토리 아이템을 제거하고 에러 메시지 추가
		        $storiesContainer.find('.story-item').not('.add-story').remove();
		        $storiesContainer.append('<p>Error loading stories.</p>');
		    }
		});
	}
	
	function createStoryModal(selectUser){
		const imageSrc = selectUser.userImage
        ? escapeHtml(selectUser.userImage)
        : '/resources/profile_file/default_profile.png';

    	const safeNickname = escapeHtml(selectUser.userNickname);
    	
    	const loginUserNo = "${loginMember.userNo}";
    	
		let html = '';
		html += '<div id="storyModalBackdrop" class="story-modal-backdrop">';
		html += '<div class="story-modal-content">';
		html += '<div class="story-header">';
		html += '<div class="story-item" data-user-no="' + selectUser.userNo + '">';
		html += '<div class="story-image">';
		html += '<img src="' + imageSrc + '" alt="프로필 이미지" />';
		html += '</div>';
		html += '</div>';
		html += '<p>' + safeNickname + '</p>';
		html += '<button id="stCloseBtn" class="story-close-btn">';
		html += '<span class="material-icons">close</span>';
		html += '</button>';
		html += '</div>';
		selectUser.storyFileList.forEach(function(file, index) {
			const activeClass = index === 0 ? ' active' : '';
			const mimeType = file.mimeType;
			console.log(mimeType);
			html += '<div class="story-image-container' + activeClass + '">';
			html += '<button class="story-nav-btn story-prev-btn">';
			html += '<span class="material-icons">navigate_before</span>';
			html += '</button>';
			
			if (mimeType.startsWith('image/')) {
				html += '<img id="storyImage" src="' + file.storyFileName + '" alt="스토리를 추가해주세요." />';
		    } else if (mimeType.startsWith('video/')) {
		        html += '<video id="storyVideo" autoplay loop muted>';
		        html += '<source src="' + file.storyFileName + '" type="' + mimeType + '">';
		        html += '</video>';
		    }
			
			html += '<button class="story-nav-btn story-next-btn">';
			html += '<span class="material-icons">navigate_next</span>';
			html += '</button>';
			html += '</div>';
		});
		
		html += '<div class="story-footer">';
		
		if (loginUserNo === String(selectUser.userNo)) {
			html += '<input type="file" id="fileInput" name="files" accept="video/*, image/*"'
				 +	'style="display: none;" multiple>';
			html +=	'<button id="stAddBtn" class="story-action-btn">';
			html +=	'<span class="material-icons">post_add</span>';
			html += '</button>';
			html += '<button id="stDeleteBtn" class="story-action-btn">';
			html +=	'<span class="material-icons">delete_outline</span>';
			html += '</button>';
		}
		html += '</div>' +
		'</div>' +
		'</div>';
		
		return html;
	}
	
	// 스토리 프로필 클릭시 불러올 modal
	$('.stories-container').on('click', '.story-item', function() {
		const loginUserNo = "${loginMember.userNo}";
		// 프로필 누른 userNo
	    const userNo = $(this).data('user-no');
		// 스토리 올린 유저 중, 내가 누른 유저 스토리 정보
		let selectUser;
		// 내 스토리와 다른유저 스토리 구분
		if(loginUserNo === String(userNo)){
			selectUser = myStory;
		}else{
			selectUser = storyFollowList.find(item => item.userNo === userNo);
		}
		
		// 동적 storyModal
		let storyModalHtml = '';
		storyModalHtml += createStoryModal(selectUser);

		$('body').prepend(storyModalHtml);
	    
		$("#storyModalBackdrop").fadeIn(200);
		$("#storyModalBackdrop").css("display", "block");
		
		// 추가 버튼 클릭시 input 호출
		$('#stAddBtn').on('click', function () {
			$('#fileInput').click();
		});	
		
		// 파일 입력 받을 시 호출
		$('#fileInput').on('change', function (event){
			const files = event.target.files;
			
	           if (!files.length) return;
	           
	           // 전체 파일 크기 계산
	           let totalSize = 0;
	           Array.from(files).forEach(file => {
	               totalSize += file.size;
	           });
	           
	           if (totalSize > 10 * 1024 * 1024) {
	               alert('선택한 파일들의 총 크기가 10MB를 초과합니다. 다른 파일을 선택해주세요.');
	               $(this).val(''); // 파일 입력 초기화
	               return;
	           }
	        
	           // FormData 생성
	           const formData = new FormData();
	           formData.append("userNo", "${loginMember.userNo}");
	           Array.from(files).forEach(file => {
	               formData.append('files', file);
	               console.log(file);
	           });
	           
	           $.ajax({
	               url: '/story/storyWrite.kh',
	               type: 'POST',
	               data: formData,
	               processData: false,
	               contentType: false,
	               success: function (response) {
	            	   if (response === 'success') {
	            		   alert('스토리가 정상적으로 업로드 되었습니다.');
		 	               stClose();
		 	            } else if (response === 'storyFileFail') {
		 	                alert('파일 업로드 중 에러가 발생했습니다.');
		 	            } else if (response === 'storyFail'){
		 	            	alert('스토리 업로드 중 에러가 발생했습니다..');
		 	            } else {
		 	                alert('파일이 없습니다. 다시 시도해주세요.');
		 	            }
	               },
	               error: function (response) {
	                   alert('파일 업로드 실패!');
	                   console.log(response);
	               }
	           });
	
	           // 파일 입력 초기화
	           $(this).val('');
		});
		
		// (이벤트) 닫기 버튼
		$('#stCloseBtn').on('click', stClose);
		
		// (이벤트) 삭제 버튼
		$('#stDeleteBtn').on('click', stDelete);
		
		// (이벤트) 이전 버튼
		$('.story-prev-btn').on('click', stPrev);
		
		// (이벤트) 다음 버튼
		$('.story-next-btn').on('click', stNext);
		
		// 스토리 닫기
		function stClose(){
			$("#storyModalBackdrop").remove();
			// 스토리를 닫을 때 마다 최신 스토리 불러오기
			searchMyStory();
			searchStoryFollowList();
		}
		
		// 스토리 삭제
		function stDelete(){
			console.log("stDelete");	
		}
		
		// 이전 스토리 호출
		function stPrev(){
			console.log("stPrev");
		}
		
		// 다음 스토리 호출
		function stNext(){
			console.log("stNext");
		}
	});
	
		
	</script>
</body>
</html>