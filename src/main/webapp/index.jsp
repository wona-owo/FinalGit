<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<link rel ="stylesheet"  href="/resources/default.css">
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
						<a href="/" class="other-link">아이디/비밀번호를 잊었나요?</a>
					</div>
				</div>
				
					<input type="submit" value="로그인" class="submit-button">		
				<div>
					<a href="/member/joinFrm.kh" class="other-link">계정이 없으신가요?</a>
				</div>
			</form>
			<form action="/naver/login.kh" method="get">
				<input type="submit" value="네이버">
			</form>
			<form action="/kakao/login.kh" method="get">
				<input type="submit" value="카카오">
			</form>
		</div>
	</div>
	<script>
	    let loginFailMsg = "${loginFailMsg}";
	    if (loginFailMsg) {
	        alert(loginFailMsg);
	    }
	</script>
</body>
</html>