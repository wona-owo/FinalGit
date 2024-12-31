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
	position: relative;
	width: 100%;
	height: 500px; /* 고정 높이 */
	background-color: #f3f3f3;
	display: flex;
	justify-content: center;
	align-items: center;
	overflow: hidden;
	border-top: 1px solid #ddd;
	border-bottom: 1px solid #ddd;
}

.story-image-container img {
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
</style>
</head>
<body>
	<h1>h2</h1>

	<button onclick="openStoryModal()">test</button>
	<button onclick="location.href='/member/mainFeed.kh'">메인화면</button>
	<div id="storyModalBackdrop" class="story-modal-backdrop">
		<div class="story-modal-content">
			<input type="file" id="fileInput" name="files" accept="image/*,video/*"
				style="display: none;" multiple>
			<div class="story-header">
				<button id="stCloseBtn" class="story-close-btn">
					<span class="material-icons">close</span>
				</button>
			</div>
			<div class="story-image-container">
				<button class="story-nav-btn story-prev-btn">
					<span class="material-icons">navigate_before</span>
				</button>
				<img id="storyImage" alt="스토리를 추가해주세요"  />
				<button class="story-nav-btn story-next-btn">
					<span class="material-icons">navigate_next</span>
				</button>
			</div>
			<div class="story-footer">
				<button id="stAddBtn" class="story-action-btn">
					<span class="material-icons">post_add</span>
				</button>
				<button id="stDeleteBtn" class="story-action-btn">
					<span class="material-icons">delete_outline</span>
				</button>
			</div>
		</div>
	</div>
	<script>
		// 스토리 불러오기
		function openStoryModal(){
		    $("#storyModalBackdrop").css("display", "block");
		}
		
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
            Array.from(files).forEach(file => {
                formData.append('files', file);
            console.log(file);
            });
            
            /* $.ajax({
                url: '',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    alert('파일 업로드 성공!');
                    console.log(response);
                },
                error: function (error) {
                    alert('파일 업로드 실패!');
                    console.error(error);
                }
            }); */

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
			console.log("stClose");
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
		
	</script>
</body>
</html>