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
							<input type="text" id="userNickname" name="userNickname" placeholder="닉네임"><button type="button" id="nickDuplCk" class="join-button">닉네임 중복체크</button> <br>
							
							<span class="tag-name">이름</span> <br>
							<input type="text" id="userName" name="userName" placeholder="ex) 홍길동"> <br>
							
							<span class="tag-name">주소</span> <br>
							<input type="text" id="userAddress" name="userAddress" placeholder="OO시 OO구"> <br>
							
							<span class="tag-name">이메일</span> <span id="invalidEmail"></span> <br>
							<input type="text" id="userEmail" name="userEmail" placeholder="aaa@example.co.kr"> <br>
							
							<span class="tag-name">전화번호</span>  <span id="invalidPhone"></span> <br>
							<input type="text" id="userPhone" name="userPhone" placeholder="010-0000-0000"><button type="button" id="phoneDuplCk" class="join-button">전화번호 중복체크</button> <br> <br>
							
							<input type="submit" value="회원가입" class="submit-button">
					</form>	
				</div>
			</div>
		</div>
		
		<script>
		
		//유효성 검증 변수
		let idVal = false;
		let pwVal = false;
		let pwConfirm = false;
		let phoneVal = false;
		let emailVal = false;
		
		//중복체크 검증 변수
		let chkDuplId = false;
		let chkDuplNick = false;
		let chkDuplPhone = false;
				
		//아이디 형식 검증
		const userId = $("#userId");
		const idMessage = $("#invalidId");
		
		const idRegExp = /^[a-zA-Z0-9]{5,10}$/;  //5~10 글자 이내
		
		userId.on("input", function(){
			const value = $(this).val();
			
			if(idRegExp.test(value)){
				idMessage.text("");
				idMessage.css("color", "");
				idVal = true;
			}else{
				idMessage.text("*ID는 영어+숫자 5~10글자 사이어야 합니다.");
				idMessage.css("color","red");
				idVal = false;
			}
		});
		
		//비밀번호 형식 검증
		const userPw = $("#userPw");
		const pwMessage = $("#invalidPw");
		
		const pwRegExp = /^[a-zA-Z0-9]{5,16}$/;  //5~16 글자 이내
		
		userPw.on("input", function(){
			const value = $(this).val();
			
			if(pwRegExp.test(value)){
				pwMessage.text("");
				pwMessage.css("color", "");
				pwVal = true;
			}else{
				pwMessage.text("*비밀번호는 영어+숫자 5~16글자 사이어야 합니다.");
				pwMessage.css("color","red");
				pwVal = false;
			}
		});
				
		//비밀번호 확인
		const confirmPw = $("#confirmPw");
		const confirmCk = $("#confirmCk");
		confirmPw.on("input",function(){
			
			if(confirmPw.val() == userPw.val()){
				confirmCk.text("비밀번호 확인완료");
				confirmCk.css("color", "gray");
				pwConfirm = true;
			}else{
				confirmCk.text("비밀번호가 일치하지 않습니다.");
				confirmCk.css("color", "red");
				pwConfirm = false;
			}		
		});
	
		//전화번호
		const userPhone = $("#userPhone");
		const phMessage =$("#invalidPhone");
		
		const phRegExp = /^0\d{2}-\d{3,4}-\d{4}$/;  //전화번호 패턴
		
		userPhone.on("input", function(){
			const value = $(this).val();
			
			if(phRegExp.test(value)){
				phMessage.text("");
				phMessage.css("color", "");
				phoneVal = true;
			}else{
				phMessage.text("올바른 형식이 아닙니다.");
				phMessage.css("color","red");
				phoneVal = false;
			}
		});
		
		//이메일
		const userEmail = $("#userEmail");
		const emMessage =$("#invalidEmail");
		
		const emRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;  //이메일 패턴
		
		userEmail.on("input", function(){
			const value = $(this).val();
			
			if(emRegExp.test(value)){
				emMessage.text("");
				emMessage.css("color", "");
				emailVal = true;
			}else{
				emMessage.text("올바른 형식이 아닙니다.");
				emMessage.css("color","red");
				emailVal = false;
			}
		});
		
		//버튼 클릭시 -> 중복검사 진행(아이디, 닉네임, 전화번호)
		//중복체크값 저장필요(무결성 검사)
		
		const userNickname = $("#userNickname");
		
		
		//아이디
		$("#idDuplCk").on("click",function(){
			
			//입력값이 없는 경우
			if(!userId.val()){
				alert("아이디를 입력해주세요");
				return;
			}
			
			$.ajax({
				url : "/member/idDuplChk.kh", //중복검사 서블릿
				data :{userId : userId.val()},
				type : "GET",				
				success : function(res) {				
					 
					if(res == '1'){
						alert("이미 사용중인 아이디입니다.")
						chkDuplId = false;
					}else{
						alert("사용 가능한 아이디입니다.")
						chkDuplId = true;
					}
				},
				error : function () {
					console.error("ajax 요청 실패!")
				}
			});
		});
		
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
	        { field: userId, message: "아이디를 입력하세요." },
	        { field: userPw, message: "비밀번호를 입력하세요." },
	        { field: confirmPw, message: "비밀번호 확인을 입력하세요." },
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
	    if(!chkDuplId) {
	        alert("아이디 중복검사를 완료해주세요.");
	        return;
	    	}
	    if (!chkDuplNick) {
	        alert("닉네임 중복검사를 완료해주세요.");
	        return;
	    	}
	    if (!chkDuplPhone) {
	        alert("전화번호 중복검사를 완료해주세요.");
	        return;
	    	}
	    
		//데이터 유효 검사
		isValid = idVal && 
				  pwVal && 
				  pwConfirm && 
				  phoneVal && 
				  emailVal && 
				  chkDuplId && 
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