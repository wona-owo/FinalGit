<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<link rel ="stylesheet"  href="/resources/default.css">
<style>
	/* 모달 전체 */
	.modal {
	    display: none; 
	    position: fixed; 
	    top: 0;
	    left: 0;
	    width: 100%;
	    height: 100%;
	    background-color: rgba(0, 0, 0, 0.4); 
	    z-index: 1000; 
	    
	}
	
	.modal-place {
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    width: 100%;
	    height: 100%;
	}
	
	.modal-contents {
	    background-color: #fff;
	    border-radius: 5px;
	    width: 450px; 
	    max-height: 400px; /* 최대 높이 설정 */
	    padding: 20px;
	    display: flex; /* Flexbox 사용 */
	    flex-direction: column; /* 세로 방향으로 정렬 */
	    align-items: center; /* 가로 방향 가운데 정렬 */
	    justify-content: center; /* 세로 방향 가운데 정렬 */
	    
	}
	
	.modal-body {
	    display: flex;
	    flex-direction: column;
	}
	.modal-title-container {
	    flex: 1; /* 남은 공간을 차지하도록 설정 */
	    display: flex; /* Flexbox 사용 */
	    justify-content: center; /* 가운데 정렬 */
	}
	
	.top {
	    display: flex; 
	    align-items: center;
	    position: relative; /* X 버튼 절대 위치 잡기 위해 필요 */
	    font-size: 18px;
	    margin-bottom: 10px;
	    border: none;
	}
	
	#modal-title{
		font-size: 22px;
		color: gray;
	}
	
	/* X 버튼을 오른쪽 끝으로 이동 */
	.modal-close {
	    position: absolute;
	    right: 0;
	    cursor: pointer;
	    font-size: 18px;
	    color: #ff6b6b;
	}
	/* 탭 버튼 컨테이너 */
	.tab-buttons {
	    display: flex;
	    border-bottom: 1px solid gray; /* 탭 아래 구분선 */
	    margin-bottom: 20px; /* 컨텐츠와 간격 */
	}
	
	/* 탭 버튼 */
	.tab-button {
	    flex: 1;
	    text-align: center;
	    padding: 12px 0;
	    font-size: 15px; 
	    font-weight: 500;
	    color: #777; 
	    text-decoration: none; 
	    border: none; 
	    background: none; 
	    cursor: pointer;
	    /* 탭 구분 위해 아래쪽만 테두리 사용 */
	    border-bottom: 3px solid transparent;
	    transition: color 0.2s, border-bottom 0.2s;
	}
	
	/* 활성화된 탭 */
	.tab-button.active {
	    color: #000; 
	    border-bottom: 3px solid #f0a235; /* 오렌지색 포인트 */
	    font-weight: 600;
	}
	
	/* 탭 hover 효과 */
	.tab-button:hover {
	    color: #333;
	}
	
	/* 폼 영역 스타일 */
	.modal-body label {
	    margin-top: 10px;
	    font-size: 14px;
	    color: #555;
	}
	
	.modal-body input {
	    margin-top: 5px;
	    padding: 10px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    width: 100%;
	    box-sizing: border-box;
	}
	.button-container {
	    display: flex; /* Flexbox 사용 */
	    justify-content: center; /* 가운데 정렬 */
	    width: 100%; /* 전체 너비 사용 */
	    margin-top: 20px; /* 버튼과 위 요소 간의 간격 */
	}
	
	/* 제출 버튼 */
	.submit-button {
	    margin-top: 20px;
	    padding: 12px;
	    background-color: #f0a235; 
	    color: white;
	    border: none;
	    border-radius: 5px;
	    cursor: pointer;
	    font-weight: 600;
	    text-align: center;
	    transition: background-color 0.2s;
	}
	
	#actionButton{
		width: 350px;
		height: 50px;	
		display: flex; 
	    align-items: center;
	    justify-content: center; /* 가운데 정렬 */
	}
	
	.submit-button:hover {
	    background-color: #e59424; 
	}
	#resultSection{
		text-align: center;
		font-weight: bold;
		font-size: 18px; 
	}
</style>
</head>
<body>
<header>
	<div class="header">
			<div class="logo">
				<img alt="댕냥일기"  src="/resources/css_image/logo.png"  class="logo-img">
				<span class="logo-text">댕냥일기</span>
			</div>		
			<nav>
				<a href="/member/joinFrm.kh" class="nav-text">회원가입</a>
				<a href="/" class="nav-text">로그인</a>
			</nav>
	</div>
</header>
	<div class="main">
	<div>
		<img alt="메인 이미지" src="/resources/css_image/main.jpg" class="main-image">
	</div>
	
		<div class="index-area">
			<div class="title-text">로그인</div>
			
			<form action="/member/login.kh" method="post">
				<div class="input-area">
					<span class="tag-name">ID</span> <br> 
					<input type="text" name="userId"> <br>
					<span class="tag-name">Password</span> <br> 
					<input type="password" name="userPw">
					<div class="srch-link">			
						 <a href="#" class="other-link" id="openModal">아이디/비밀번호를 잊었나요?</a>
					</div>
				</div>
				
					<input type="submit" value="로그인" class="submit-button">		
				<div>
					<a href="/member/joinFrm.kh" class="other-link">계정이 없으신가요?</a>
				</div>
			</form>
			<div class="api-area">
			<a href="/naver/login.kh" id="naver"></a>
			<a href="/kakao/login.kh" id="kakao"></a>
			</div>
		</div>
	</div>
	<div class="modal" id="modal">
	    <div class="modal-place">
	        <div class="modal-contents">
	            <div class="modal-body">
		            <div class="top">
		                    <div class="modal-title-container">
	        					<span id="modal-title">아이디 찾기</span>
	    					</div>
		                    <a href="#" class="modal-close" id="closeModal">X</a>
		                </div>
	                <div class="tab-buttons">
	                    <a href="#" id="findIdButton" class="tab-button active">아이디 찾기</a>
	                    <a href="#" id="findPasswordButton" class="tab-button">비밀번호 찾기</a>
	                </div>
	                <form id="findForm" action="/member/find.kh" method="post">
	                	<input type="hidden" name="actionType" id="actionType" value="findId">
	                    <div id="findSection">
	                        <label id="sectionLabel">가입한 이메일 입력</label>
	                        <input type="email" name="email" id="emailInput" placeholder="이메일을 입력하세요" required>
	                        <label id="phoneLabel" style="display: block;">전화번호 입력</label>
	                        <input type="tel" name="phone" id="phoneInput" placeholder="전화번호를 입력하세요">
	                        <label id="userIdLabel" style="display: none;">가입한 아이디 입력</label>
	                        <input type="text" name="userId" id="userIdInput" placeholder="아이디를 입력하세요" style="display: none;">
	                        <div class="button-container"> 
            					<button type="submit" class="submit-button" id="actionButton">아이디 찾기</button>
        					</div>
	                    </div>
	                    <div id="resultSection" style="display: none;">
					        <p id="resultMessage"></p>
					    </div>
	                </form>
	            </div>
	        </div>
	    </div>
	</div>
	<script>
	    let loginFailMsg = "${loginFailMsg}";
	    if (loginFailMsg) {
	        alert(loginFailMsg);
	    }

	    // 모달 열기
	    document.getElementById('openModal').onclick = function() {
	        document.getElementById('modal').style.display = 'block';
	    };

	    // 모달 닫기
	    document.getElementById('closeModal').onclick = function() {
	        document.getElementById('modal').style.display = 'none';
	        document.getElementById('emailInput').value = ''; // 이메일 입력 필드 비우기
	        document.getElementById('phoneInput').value = ''; // 전화번호 입력 필드 비우기
	        document.getElementById('userIdInput').value = ''; // 아이디 입력 필드 비우기
	        document.getElementById('resultSection').style.display = 'none'; // 결과 영역 숨기기
	        document.getElementById('findSection').style.display = 'block'; // 입력 필드 보이기
	        document.getElementById('actionType').value = 'findId'; // actionType 값을 'findId'로 초기화
	        document.getElementById('modal-title').innerText = '아이디 찾기'; // 모달 제목 초기화
	        document.getElementById('findIdButton').classList.add('active'); // 아이디 찾기 버튼 활성화
	        document.getElementById('findPasswordButton').classList.remove('active'); // 비밀번호 찾기 버튼 비활성화
	    };
	 // 비밀번호 찾기 버튼 클릭 시
	    document.getElementById('findPasswordButton').onclick = function(event) {
	        event.preventDefault(); // 기본 링크 동작 방지
	        document.getElementById('modal-title').innerText = '비밀번호 찾기';

	        // 아이디 찾기 결과를 숨기고 비밀번호 찾기 관련 요소를 보여줍니다.
	        document.getElementById('resultSection').style.display = 'none'; // 결과 영역 숨기기
	        document.getElementById('findSection').style.display = 'block'; // 입력 필드 보이기
	        document.getElementById('phoneLabel').style.display = 'none'; // 전화번호 레이블 숨기기
	        document.getElementById('phoneInput').style.display = 'none'; // 전화번호 입력 필드 숨기기
	        document.getElementById('userIdLabel').style.display = 'block'; // 아이디 레이블 보이기
	        document.getElementById('userIdInput').style.display = 'block'; // 아이디 입력 필드 보이기
	        document.getElementById('actionButton').innerText = '비밀번호 찾기'; // 버튼 텍스트 변경
	        document.getElementById('actionType').value = 'findPassword'; // actionType 값 변경
	        document.getElementById('findIdButton').classList.remove('active'); // 아이디 찾기 버튼 비활성화
	        document.getElementById('findPasswordButton').classList.add('active'); // 비밀번호 찾기 버튼 활성화
	        // 입력 필드 초기화
	        document.getElementById('emailInput').value = ''; // 이메일 입력 필드 비우기
	        document.getElementById('phoneInput').value = ''; // 전화번호 입력 필드 비우기
	        document.getElementById('userIdInput').value = ''; // 아이디 입력 필드 비우기
	        document.getElementById('resultSection').style.display = 'none'; // 결과 영역 숨기기
	    };

	    // 아이디 찾기 버튼 클릭 시
	    document.getElementById('findIdButton').onclick = function(event) {
	        event.preventDefault(); // 기본 링크 동작 방지
	        document.getElementById('modal-title').innerText = '아이디 찾기';
	        document.getElementById('sectionLabel').innerText = '가입한 이메일 입력';
	        document.getElementById('phoneLabel').style.display = 'block';
	        document.getElementById('phoneInput').style.display = 'block';
	        document.getElementById('userIdLabel').style.display = 'none';
	        document.getElementById('userIdInput').style.display = 'none';
	        document.getElementById('actionButton').innerText = '아이디 찾기'; // 버튼 텍스트 변경
	        document.getElementById('actionType').value = 'findId'; // actionType 값 변경
	        document.getElementById('findPasswordButton').classList.remove('active'); // 비밀번호 찾기 버튼 비활성화
	        document.getElementById('findIdButton').classList.add('active'); // 아이디 찾기 버튼 활성화
	        // 입력 필드 초기화
	        document.getElementById('emailInput').value = ''; // 이메일 입력 필드 비우기
	        document.getElementById('phoneInput').value = ''; // 전화번호 입력 필드 비우기
	        document.getElementById('userIdInput').value = ''; // 아이디 입력 필드 비우기
	        document.getElementById('resultSection').style.display = 'none'; // 결과 영역 숨기기
	    };

	    // 아이디 찾기 성공 시
	    document.getElementById('findForm').onsubmit = function(event) {
	        event.preventDefault(); // 기본 폼 제출 방지

	        // 폼 데이터 수집
	        const formData = new FormData(this);

	        // AJAX 요청
	        fetch(this.action, {
	            method: 'POST',
	            body: formData
	        })
	        .then(response => response.text())
	        .then(data => {
	            // 결과 메시지 표시
	            document.getElementById('resultMessage').innerText = data;
	            document.getElementById('resultSection').style.display = 'block'; // 결과 영역 보이기

	            // 입력 필드 숨기기
	            document.getElementById('findSection').style.display = 'none'; // 입력 필드 숨기기
	        })
	        .catch(error => {
	            console.error('Error:', error);
	        });
	    };
	</script>
</body>
</html>
