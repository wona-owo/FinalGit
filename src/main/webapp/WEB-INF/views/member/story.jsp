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
.add-icons {
	display: none;
	color: #ad5a01;
	position: absolute;
	right: 0;
	bottom: 25px;
	font-size: 22px;
}
.nav-icons {
	color: white;
}

.story-modal-backdrop {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.4);
	z-index: 9990;
}

.story-modal-content {
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 500px;
	height: 660px;
	background: white;
	padding: 5px 0;
	border-radius: 10px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	display: flex;
    flex-direction: column;
	overflow: hidden;
	
}

.story-image-container {
	flex: 1;
	background-color: #f3f3f3;
	justify-content: center;
	align-items: center;
	overflow: hidden;
	border-top: 1px solid #ddd;
	border-bottom: 1px solid #ddd;
	display: flex
}

.story-image-container img,
.story-image-container video {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}

.story-header,
.story-footer {
    display: flex;
    align-items: center;
}
.story-footer {
	justify-content: right;
	height: 40px;
}

.story-header p{
	margin: 0;
}

.story-nav-btn {
	position: absolute;
	top: 50%;
	transform: translateY(-50%);
	background-color: rgba(0, 0, 0, 0.5);
	color: white;
	border: none;
	padding: 5px;
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
    background-color: #fff;
    border-bottom: 1px solid #ddd;
}

.stories-container::-webkit-scrollbar {
    display: none; /* 스크롤바 숨기기 */
}
.story-item {
	position: relative;
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
    margin: auto;
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
    margin-bottom: 5px;
    font-size: 14px;
    color: #333;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
</style>
</head>
<body>
	<div class="stories-container">
		<div class="story-item add-story" data-user-no="${loginMember.userNo}">
		    <div class="story-image">
			    <img src="${not empty loginMember.userImage ? 
			    	loginMember.userImage : '/resources/profile_file/default_profile.png'}"
			    	alt="프로필 이미지" />
			</div>
		    <p>내 스토리</p>
		    <span class="material-icons add-icons">add_circle_outline</span>
		</div>
	</div>
	
	<script>
	$(document).ready(function () {
		searchMyStory();
		searchStoryFollowList();		
	});
	
	// 스토리를 올린 유저 목록과 각 유저의 스토리를 담을 변수
	let storyFollowList = [];
	let myStory = {
		userNo: "",
		userNickname: "",
		userImage: "",
		userIndex: "",
		storyFileList: []
	};
	
	let currentUserIndex = 0; // storyFollowList 내의 인덱스
	let currentStoryIndex = 0; // 선택된 사용자의 storyFileList 내의 인덱스
	let currentStoryNo = null; // 현재 보고 있는 스토리의 storyNo
	
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
		 		
		 		// myStory.fileList가 없거나 빈 배열일 경우 add 아이콘 표시
	            if (myStory.storyFileList.length === 0) {
	                $('.add-story .add-icons').show();
	            } else {
	                $('.add-story .add-icons').hide();
	            }
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
		        	storyFollowList.forEach(function(item) {
	                    const storyHtml = createStoryItem(item);
	                    $storiesContainer.append(storyHtml);
	                });
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
	
	function createStoryModal(){
		let selectUser = currentUserIndex === -1 ? myStory : storyFollowList[currentUserIndex];
		
		const imageSrc = selectUser.userImage
	        ? escapeHtml(selectUser.userImage)
	        : '/resources/profile_file/default_profile.png';

    	const safeNickname = escapeHtml(selectUser.userNickname);
    	
    	const uploadTime = selectUser.storyFileList.length > 0
	        ? calculateRelativeTime(selectUser.storyFileList[currentStoryIndex].storyCreateDate)
	        : "";
    	
		let html = '';
		html += '<div id="storyModalBackdrop" class="story-modal-backdrop">';
		html += '<div class="story-modal-content">';
		html += '<div class="story-header">';
		html += '<div class="story-item" data-user-no="' + selectUser.userNo + '">';
		html += '<div class="story-image">';
		html += '<img src="' + imageSrc + '" alt="프로필 이미지" />';
		html += '</div>';
		html += '<p>' + safeNickname + '</p>';
		html += '</div>';
		html += '<p id="storyDate">' + uploadTime + '</p>';
		html += '<button id="stCloseBtn" class="story-close-btn">';
		html += '<span class="material-icons">close</span>';
		html += '</button>';
		html += '</div>';
		
		html += '<div class="story-image-container"></div>';
	    
	    html += '<div class="story-footer">';
	    
	    if (String(selectUser.userNo) === "${loginMember.userNo}") {
	        html += '<input type="file" id="fileInput" name="files" accept="video/*, image/*"'
	             +   'style="display: none;" multiple>';
	        html +=  '<button id="stAddBtn" class="story-action-btn">';
	        html +=  '<span class="material-icons">post_add</span>';
	        html += '</button>';
	        html += '<button id="stDeleteBtn" class="story-action-btn">';
	        html +=  '<span class="material-icons">delete_outline</span>';
	        html += '</button>';
	    }
	    
		html += '</div>' +
		'</div>' +
		'</div>';
		
		return html;
	}
	
	// 시간 단위로 상대 시간 계산 함수
	function calculateRelativeTime(storyCreateDate) {
	    const storyDate = new Date(storyCreateDate);
	    const now = new Date();
	    const diffTime = Math.abs(now - storyDate); // 밀리초 차이
	    const diffHours = Math.floor(diffTime / (1000 * 60 * 60)); // 시간 단위로 변환

	    return "• " + diffHours + "시간 전";
	}
	
	function showCurrentStory() {
	    const selectUser = currentUserIndex === -1 ? myStory : storyFollowList[currentUserIndex];

	    // 모달 헤더 업데이트
	    const imageSrc = selectUser.userImage ? escapeHtml(selectUser.userImage) : '/resources/profile_file/default_profile.png';
	    const safeNickname = escapeHtml(selectUser.userNickname);
	    const uploadTime = selectUser.storyFileList.length > 0
	        ? calculateRelativeTime(selectUser.storyFileList[currentStoryIndex].storyCreateDate)
	        : "";

        $('#storyModalBackdrop .story-header .story-image img').attr('src', imageSrc);
	    $('#storyModalBackdrop .story-header p').text(safeNickname);
	    $('#storyModalBackdrop #storyDate').text(uploadTime);

	    // 스토리 내용 업데이트
	    const $storyImageContainer = $('#storyModalBackdrop .story-image-container');
	    $storyImageContainer.empty();

	    if (selectUser.storyFileList.length > 0) {
	        const file = selectUser.storyFileList[currentStoryIndex];
	        const mimeType = file.mimeType;

	     	// 현재 스토리의 storyNo 저장
            currentStoryNo = file.storyNo
	     	
	        // 이전 버튼 추가
	        if (currentStoryIndex > 0 || currentUserIndex > -1) {
	            $storyImageContainer.append(
	                '<button class="story-nav-btn story-prev-btn">' +
	                    '<span class="material-icons nav-icons">navigate_before</span>' +
	                '</button>'
	            );
	        }

	        // 이미지/비디오 콘텐츠 추가
	        if (mimeType.startsWith('image/')) {
	            $storyImageContainer.append('<img id="storyImage" src="' + file.storyFileName + '" alt="스토리를 추가해주세요." />');
	        } else if (mimeType.startsWith('video/')) {
	            $storyImageContainer.append(
	                '<video id="storyVideo" autoplay loop muted>' +
	                    '<source src="' + file.storyFileName + '" type="' + mimeType + '">' +
	                '</video>'
	            );
	        }
	        
	        // 다음 버튼 추가
	        if (currentStoryIndex < (selectUser.storyFileList.length - 1) || currentUserIndex < (storyFollowList.length - 1)) {
	            $storyImageContainer.append(
	                '<button class="story-nav-btn story-next-btn">' +
	                    '<span class="material-icons nav-icons">navigate_next</span>' +
	                '</button>'
	            );
	        }
	    } else {
	        $storyImageContainer.append('<p>스토리가 없습니다. 스토리를 추가해보세요!</p>');
	    }

	    bindNavigationButtons();
	    
	    // 다른 사람 스토리를 볼 시 input 및 delete 숨김
	    if (currentUserIndex !== -1) {
            $('#storyModalBackdrop .story-action-btn').hide();
        } else {
            $('#storyModalBackdrop .story-action-btn').show();
        }
	}
	
	// 이전 스토리로 이동하는 함수
    function navigatePrevious() {
        if (currentStoryIndex > 0) {
            currentStoryIndex--;
        } else if (currentUserIndex > -1) {
            // 이전 유저로 이동
            currentUserIndex--;
            if (currentUserIndex === -1) {
                // 이제 내 스토리 보기
                currentStoryIndex = myStory.storyFileList.length - 1; // 수정된 부분
            } else {
                // 이전 유저의 마지막 스토리로 설정
                const previousUser = storyFollowList[currentUserIndex];
                currentStoryIndex = previousUser.storyFileList.length - 1;
            }
        }
        showCurrentStory();
    }
	
 	// 다음 스토리로 이동하는 함수
    function navigateNext() {
        const selectUser = currentUserIndex === -1 ? myStory : storyFollowList[currentUserIndex];
        
        if (currentStoryIndex < (selectUser.storyFileList.length - 1)) {
            currentStoryIndex++;
        } else if (currentUserIndex < (storyFollowList.length - 1)) {
            // 다음 유저로 이동
            currentUserIndex++;
            currentStoryIndex = 0;
        }
        showCurrentStory();
    }
	
	function bindNavigationButtons() {
	    // 이전 버튼 클릭 이벤트
	    $('#storyModalBackdrop').off('click', '.story-prev-btn').on('click', '.story-prev-btn', function(e) {
	        e.stopPropagation();
	        navigatePrevious();
	    });

	    // 다음 버튼 클릭 이벤트
	    $('#storyModalBackdrop').off('click', '.story-next-btn').on('click', '.story-next-btn', function(e) {
	        e.stopPropagation();
	        navigateNext();
	    });
	}
	
	// 스토리 프로필 클릭시 불러올 modal
	$('.stories-container').on('click', '.story-item', function() {
        const loginUserNo = "${loginMember.userNo}";
		
		// 프로필 누른 userNo
	    const userNo = $(this).data('user-no');
		
	 	// 스토리 올린 유저 중, 내가 누른 유저 스토리 정보
        let selectUser;
        let userIndex = -1; // -1은 '내 스토리'를 나타냄

		// 내 스토리와 다른유저 스토리 구분
        if(loginUserNo === String(userNo)){
            selectUser = myStory;
        } else {
            userIndex = storyFollowList.findIndex(function(item) {
                return item.userNo === userNo;
            });
            if (userIndex === -1) {
                console.error('storyFollowList에서 사용자를 찾을 수 없습니다.');
                return;
            }
            selectUser = storyFollowList[userIndex];
        }
		
		// 스토리 인덱스를 0으로 초기화 (첫 번째 스토리)
	    currentUserIndex = userIndex;
        currentStoryIndex = 0;
	 		
		// 동적 storyModal
		const storyModalHtml = createStoryModal(userIndex, currentStoryIndex);
        $('body').prepend(storyModalHtml);
        $("#storyModalBackdrop").fadeIn(200);
		
		// 첫 번째 스토리 표시
	    showCurrentStory();
		
		// 추가 버튼 클릭시 input 호출
		$('#storyModalBackdrop #stAddBtn').on('click', function () {
            $('#storyModalBackdrop #fileInput').click();
        }); 
		
		// 파일 입력 받을 시 호출
		$('#storyModalBackdrop #fileInput').on('change', function (event){
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
		$('#storyModalBackdrop').on('click', '#stCloseBtn', stClose);
		
		// (이벤트) 삭제 버튼
		$('#storyModalBackdrop').on('click', '#stDeleteBtn', stDelete);
		
		// 스토리 닫기
		function stClose(){
			$("#storyModalBackdrop").remove();
			// 스토리를 닫을 때 마다 최신 스토리 불러오기
			searchMyStory();
			searchStoryFollowList();
		}
		
		// 스토리 삭제 함수
        function stDelete(){
            // 삭제 확인 창 표시
            const confirmDelete = confirm("정말로 이 스토리를 삭제하시겠습니까?");
            if (!confirmDelete) {
                return; // 사용자가 취소를 누르면 함수 종료
            }
            
            // 삭제 권한 검사: 현재 스토리의 userNo와 세션의 userNo 비교
            // 현재 스토리의 userNo는 'myStory'일 때는 loginUserNo와 동일, 아니면 다른 사용자
            if (currentUserIndex !== -1) {
                // 'myStory'가 아니면 삭제 권한이 없음
                alert("이 스토리를 삭제할 권한이 없습니다.");
                return;
            }
            
            if (!currentStoryNo) {
                alert("삭제할 스토리를 찾을 수 없습니다.");
                return;
            }
            
            // 삭제 요청을 서버로 전송
            $.ajax({
                url: '/story/deleteStory.kh',
                type: 'POST',
                data: { storyNo: currentStoryNo },
                success: function(response) {
                    if (response === 'success') {
                        alert('스토리가 정상적으로 삭제되었습니다.');
                        stClose();
                    } else if (response === 'error') {
                        alert('스토리 삭제 중 오류가 발생했습니다.');
                    } else {
                        alert('알 수 없는 오류가 발생했습니다.');
                    }
                },
                error: function(xhr, status, error) {
                    alert('스토리 삭제 요청에 실패했습니다.');
                    console.log(error);
                }
            });
        }
		
		
	});
	
		
	</script>
</body>
</html>