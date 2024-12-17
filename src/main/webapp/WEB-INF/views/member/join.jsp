<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel ="stylesheet"  href="/resources/default.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
			<div class="title-text">회원가입</div>	
			
				<div class="join-area">
					<form action="/member/join.kh" method="post">
							<span class="tag-name">ID</span> <span id="invalidId"></span><br>
							<input type="text" id="userId" name="userId" placeholder="영어+숫자 5~10글자 이내"> 
							<button type="button" id="idDuplCk" class="join-button">ID 중복체크</button> <br>
							
							<span class="tag-name">Password</span> <span id="invalidPw"></span><br>
							<input type="password" id="userPw" name="userPw" placeholder="영어+숫자 5~16글자 이내"> <br>
							
							<span class="tag-name">Password Confirm</span> <span id="confirmCk"></span><br>
							<input type="password" id="confirmPw" placeholder="동일한 비밀번호 입력"> <br>
							
							<span class="tag-name">Nickname</span> <br>
							<input type="text" name="userNickname" placeholder="닉네임"><button type="button" id="nickDuplCk" class="join-button">닉네임 중복체크</button> <br>
							
							<span class="tag-name">이름</span> <br>
							<input type="text" name="userName" placeholder="ex) 홍길동"> <br>
							
							<span class="tag-name">주소</span> <br>
							<input type="text" name="userAddress" placeholder="OO시 OO구"> <br>
							
							<span class="tag-name">이메일</span> <br>
							<input type="text" name="userEmail" placeholder="aaa@example.co.kr"> <br>
							
							<span class="tag-name">전화번호</span> <br>
							<input type="text" name="userPhone" placeholder="010-0000-0000"><button type="button" id="phoneDuplCk" class="join-button">전화번호 중복체크</button> <br> <br>
							
							<input type="submit" value="회원가입" class="submit-button">
					</form>	
				</div>
			</div>
		</div>
		
		<script>
				
		//아이디 형식 검증
		const userId = $("#userId");
		const idMessage = $("#invalidId");
		
		const idRegExp = /^[a-zA-Z0-9]{5,10}$/;  //5~10 글자 이내
		
		userId.on("input", function(){
			const value = $(this).val();
			
			if(idRegExp.test(value)){
				idMessage.text("");
				idMessage.css("color", "");
			}else{
				idMessage.text("*ID는 영어+숫자 5~10글자 사이어야 합니다.");
				idMessage.css("color","red");
			}
		});
		
		//비밀번호 형식 검증
		const userPw = $("#userPw");
		const pwMessage = $("#invalidPw");
		
		const pwRegExp = /^[a-zA-Z0-9]{5,16}$/;  //5~10 글자 이내
		
		userPw.on("input", function(){
			const value = $(this).val();
			
			if(pwRegExp.test(value)){
				pwMessage.text("");
				pwMessage.css("color", "");
			}else{
				pwMessage.text("*비밀번호는 영어+숫자 5~16글자 사이어야 합니다.");
				pwMessage.css("color","red");
			}
		});
				
		//비밀번호 확인
		const confirmPw = $("#confirmPw");
		const confirmCk = $("#confirmCk");
		confirmPw.on("input",function(){
			
			if(confirmPw.val() == userPw.val()){
				confirmCk.text("비밀번호 확인완료");
				confirmCk.css("color", "gray");
			}else{
				confirmCk.text("비밀번호가 일치하지 않습니다.");
				confirmCk.css("color", "red");
			}		
		});
	
		//중복검사 진행(아이디, 닉네임, 전화번호)
		//중복체크값 저장필요(무결성 검사)
		
		//아이디
		$.ajax({
			url : "/" //중복검사 서블릿
			data :{ "userId" : userId.val()},
			type : "GET",
			
			success : function(res) {
				if(res == 0){
					alert("사용 가능한 아이디입니다.")
				}else{
					alert("이미 사용중인 아이디입니다.")
				}
			}
		});
		//닉네임
		$.ajax({
			url : "/" //중복검사 서블릿
			data :{ "userNickname" : userNickname.val()},
			type : "GET",
			
			success : function(res) {
				if(res == 0){
					alert("사용 가능한 닉네임입니다.")
				}else{
					alert("이미 사용중인 닉네임입니다.")
				}
			}
		});
		//전화번호
		$.ajax({
			url : "/" //중복검사 서블릿
			data :{ "userPhone" : userPhone.val()},
			type : "GET",
			
			success : function(res) {
				if(res == 0){
					alert("사용 가능한 전화번호입니다.")
				}else{
					alert("이미 사용중인 전화번호입니다.")
				}
			}
		});
		
		
		
		//전체값 유효성 검사(나중에 맨위로...)
		const chkValue = {
			"userId" : false,   		//아이디 입력(형식 확인)
			"idDuplChk" : false,		//아이디 중복검사
			"userNickname" : false,		//닉네임 입력
			"nickDuplChk" : false,		//닉네임 중복검사
			"userPw": false,			//비밀번호 입력(형식 확인)
			"confirmPw" : false,		//비밀번호 확인
			"userName" : false,			//이름 입력
			"userPhone" : false,		//전화번호 입력
			"phDuplChk" : false			//전화번호 중복검사
		};
		
		
		</script>
	
	
</body>
</html>