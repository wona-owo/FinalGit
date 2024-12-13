<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<link rel ="stylesheet"  href="/resources/default.css"  >
</head>
<body>
<header>
	<div class="header">
			<div class="logo">
				<img alt="댕냥일기"  src="/resources/css_image/logo.png"  class="logo-img">
				<span class="logo-text">댕냥일기</span>
			</div>		
			<nav>
				<a href="/" class="nav-text">회원가입</a>
				<a href="/" class="nav-text">로그인</a>
			</nav>
	</div>
</header>

	<div class="main">
	<div>
		<img alt="메인 이미지" src="/resources/css_image/main.jpg" class="main-image">
	</div>
	
		<div class="login-area">
			<div id="login-title-text">로그인</div>
			
			<form action="/member/login.kh" method="post">
				<div class="input-area">
					<label for="memberId">ID</label> <br> 
					<input type="text" name="memberId"> <br>
					<label for="memberPw">Password</label> <br> 
					<input type="password" name="memberPw">
					<div class="srch-link">			
						<a href="/" class="other-link">아이디/비밀번호를 잊었나요?</a>
					</div>
				</div>
				
					<input type="submit" value="로그인" class="submit-button">		
				<div>
					<a href="/" class="other-link">계정이 없으신가요?</a>
				</div>
			</form>
		</div>
	</div>



</body>
</html>