<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main Feed</title>
<link rel ="stylesheet"  href="/resources/default.css"  >
<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>

	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
	<main id="main-feed">
	 	<p>메인피드</p>
	</main>	


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