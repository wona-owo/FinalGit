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
				<span class="nav-text"><a href="/">회원가입</a></span>
				<span class="nav-text"><a href="/">로그인</a></span>
			</nav>
	</div>
</header>

	<h3>로그인</h3>
	<form action="/" method="post">
		ID <br> <input type="text" name="memberId"> <br>
		Password <br> <input type="password" name="memberPw">
		<h4><a href="/">아이디/비밀번호를 잊었나요?</a></h4>
		<input type="submit" value="로그인" class="submit-button">
	</form>

	<h4><a href="/">계정이 없으신가요?</a></h4>


</body>
</html>