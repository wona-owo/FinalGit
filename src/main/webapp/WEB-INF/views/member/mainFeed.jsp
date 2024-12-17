<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main Feed</title>
<link rel ="stylesheet"  href="/resources/default.css"  >
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>

	<div class="container">
	
		<nav class="side-menu">
			<div class="nav-logo">
				<img alt="댕냥일기"  src="/resources/css_image/logo.png"  class="logo-img">
				<span class="nav-logo-text">댕냥일기</span>
			</div>
			
			  <div class="menu-list">
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/home" class="menu-link" data-url="/home.kh">홈</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/search" class="menu-link" data-url="/search.kh">검색</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					 <a href="/" class="menu-link" >알림</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/message" class="menu-link" data-url="/message.kh">메시지</a>
				</div>
				
				<div class="one-menu">
					<img alt="메뉴아이콘" src="/resources/css_image/icon.png" class="icon-img">
					<a href="/" class="menu-link">정기구독</a>
				</div>
			</div>		
			
			<div class="profile">
				<div class="profile-frame">
				</div>
					<a href="/">프로필(이름)</a>
			</div>
						
		</nav>
		
		<main id="main-feed">
		 	<p>본문영역</p>
		</main>
		
	</div>

	<script>
	function loadPageContent(url, pushState = true) {
	    var mainFeed = document.getElementById('main-feed');
		if(url != "/home.kh"){
		    // AJAX 요청
		    $.ajax({
		        type: 'GET',
		        url: url,
		        success: function(response) {
		            mainFeed.innerHTML = response; // 불러온 내용 삽입
	
		            // URL 변경
		            if (pushState) {
		                window.history.pushState({ url: url }, '', url);
		            }
		        },
		        error: function() {
		            mainFeed.innerHTML = '<p>페이지를 불러오는 중 오류가 발생했습니다.</p>';
		        }
		    });			
		}else{
			window.location.href = "";
		}
		
		
	}

	document.addEventListener("DOMContentLoaded", function() {
	    // 메뉴 링크 클릭 이벤트
	    document.querySelectorAll('.menu-link').forEach(function(link) {
	        link.addEventListener('click', function(event) {
	            event.preventDefault(); // 기본 이동 방지
	            var url = this.getAttribute('data-url'); // data-url 속성 값 가져오기
	            loadPageContent(url); // AJAX로 페이지 내용 불러오기
	        });
	    });

	    // 뒤로 가기/앞으로 가기 이벤트
	    window.onpopstate = function(event) {
	        if (event.state && event.state.url) {
	            loadPageContent(event.state.url, false); // pushState 실행 안 함
	        }
	    };
	});
	</script>
</body>
</html>