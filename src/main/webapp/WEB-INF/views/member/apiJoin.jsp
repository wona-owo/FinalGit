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
					<form action="/member/apiJoin.kh" method="post">
						<input type="hidden" name="userId" value="${apiUser.apiUserId}">
						<input type="hidden" name="userPw" value="${apiUser.apiUserPw}">
						<input type="hidden" name="userType" value="${apiUser.apiUserType}">
						
						<span class="tag-name">Nickname</span> <br>
						<input type="text" id="userNickname" name="userNickname" placeholder="닉네임">
						<button type="button" id="nickDuplCk" class="join-button">닉네임 중복체크</button> <br>
							
						<span class="tag-name">이름</span> <br>
						<input type="text" id="userName" name="userName" placeholder="ex) 홍길동" value="${apiUser.apiUserName}"> <br>
						
						<span class="tag-name">주소</span> <br>
						<input type="text" id="userAddress" name="userAddress" placeholder="OO시 OO구"> <br>
							
						<span class="tag-name">이메일</span> <span id="invalidEmail"></span> <br>
						<input type="text" id="userEmail" name="userEmail" placeholder="aaa@example.co.kr" value="${apiUser.apiUserEmail}"> <br>
							
						<span class="tag-name">전화번호</span>  <span id="invalidPhone"></span> <br>
						<input type="text" id="userPhone" name="userPhone" placeholder="010-0000-0000" value="${apiUser.apiUserPhone}">
						<button type="button" id="phoneDuplCk" class="join-button">전화번호 중복체크</button> <br> <br>
							
						<input type="submit" value="회원가입" class="submit-button">
					</form>	
				</div>
			</div>
		</div>
		
		<script>
		$(document).ready(function() {
		    chkUserEmail();
		    chkUserPhone();
		});
		
		//유효성 검증 변수
		let phoneVal = false;
		let emailVal = false;
		
		//중복체크 검증 변수
		let chkDuplNick = false;
		let chkDuplPhone = false;
				
		//전화번호
		const userPhone = $("#userPhone");
		const phMessage =$("#invalidPhone");
		
		const phRegExp = /^0\d{2}-\d{3,4}-\d{4}$/;  //전화번호 패턴
		
		function chkUserPhone(){
			const value = $("#userPhone").val();
			
			if(phRegExp.test(value)){
				phMessage.text("");
				phMessage.css("color", "");
				phoneVal = true;
			}else{
				phMessage.text("올바른 형식이 아닙니다.");
				phMessage.css("color","red");
				phoneVal = false;
			}
		}
		
		userPhone.on("input", chkUserPhone);
		
		//이메일
		const userEmail = $("#userEmail");
		const emMessage =$("#invalidEmail");
		
		const emRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;  //이메일 패턴
		
		function chkUserEmail() {
		    const value = $("#userEmail").val();
		    if (emRegExp.test(value)) {
		        emMessage.text("");
		        emMessage.css("color", "");
		        emailVal = true;
		    } else {
		        emMessage.text("올바른 형식이 아닙니다.");
		        emMessage.css("color", "red");
		        emailVal = false;
		    }
		}
		
		userEmail.on("input", chkUserEmail);
		
		//버튼 클릭시 -> 중복검사 진행(아이디, 닉네임, 전화번호)
		//중복체크값 저장필요(무결성 검사)
		
		const userNickname = $("#userNickname");
		
		//닉네임
		$("#nickDuplCk").on("click",function(){
			
			//입력값이 없는 경우
			if(!userNickname.val()){
				alert("닉네임을 입력해주세요");
				return;
			}
			
			$.ajax({
				url : "/member/nickDuplChk.kh", //중복검사 서블릿
				data :{ userNickname : userNickname.val()},
				type : "GET",
				
				success : function(res) {
					if(res == '1'){
						alert("이미 사용중인 닉네임입니다.")
						chkDuplNick = false;
					}else{
						alert("사용 가능한 닉네임입니다.")
						chkDuplNick = true;
					}
				},
				error : function () {
					console.error("ajax 요청 실패!")
				}
			});
		});
		
		//전화번호
		$("#phoneDuplCk").on("click",function(){
			
			//입력값이 없는 경우
			if(!userPhone.val()){
				alert("전화번호를 입력해주세요");
				return;
			}
			
			
			$.ajax({
				url : "/member/phoneDuplChk.kh", //중복검사 서블릿
				data :{ userPhone : userPhone.val()},
				type : "GET",
				
				success : function(res) {
					if(res == '1'){
						alert("이미 가입된 전화번호입니다.")
						chkDuplPhone = false;
					}else{
						alert("사용 가능한 전화번호입니다.")
						chkDuplPhone = true;
						}
					},
					error : function () {
						console.error("ajax 요청 실패!")
					}
				});
			});
		
		
		//제출 버튼 클릭 시 데이터 유효성 검사
		const userAddr = $("#userAddress");
		const userName = $("#userName");
		
		$("form").on("submit",function(event){
			
		//기본 제출 동작 방지
		event.preventDefault();
		
		//빈칸 검사 - 배열 저장
		   const inputVal = [
	        { field: userNickname, message: "닉네임을 입력하세요." },
	        { field: userName, message: "이름을 입력하세요." },
	        { field: userAddr, message: "주소를 입력하세요." },
	        { field: userEmail, message: "이메일을 입력하세요." },
	        { field: userPhone, message: "전화번호를 입력하세요." }
   		 ];
		
		//유효성 변수
		let isValid = false;
		
		//빈값 확인
		for(let i=0; i<inputVal.length; i++){	
			if(!inputVal[i].field.val().trim()){
				alert(inputVal[i].message);
				isValid = false;
				return;
			}		  
			isValid = true;
		}
		
		// 중복 검사 확인
	    if (!chkDuplNick) {
	        alert("닉네임 중복검사를 완료해주세요.");
	        return;
	    	}
	    if (!chkDuplPhone) {
	        alert("전화번호 중복검사를 완료해주세요.");
	        return;
	    	}
	    
		//데이터 유효 검사
		isValid = phoneVal && 
				  emailVal && 
				  chkDuplNick && 
				  chkDuplPhone;
		
		//제출 - 유효성 검사가 끝난 후 
		if(isValid){
			this.submit();
		}else{
		 	alert("유효하지 않은 입력값이 있습니다. 다시 확인해주세요.")
		 	return;
		}
		
		});
		
		</script>
	
	
	
</body>
</html>