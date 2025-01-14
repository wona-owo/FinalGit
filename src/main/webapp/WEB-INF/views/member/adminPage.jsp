<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Page</title>
<link rel ="stylesheet"  href="/resources/default.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
#admin-page {
	margin-left: 400px;
	margin-right: 350px;
}
/* 메인 컨테이너 */
.admin-container {
  width: 80%;
  min-width: 600px;
  margin: 40px 0;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.3);
  padding: 20px;
}

h1, h2, h4 {
  text-align: center;
}

h4 * {
margin-right: 7px;
}
.current-page {
	color: #f0a235;
}

/* 탭 메뉴 */
.tab-menu {
  list-style: none;
  display: flex;
  border-bottom: 2px solid #ddd;
  margin-bottom: 20px;
  padding-left: 20px;
}

.tab-menu .tab-item {
  padding: 10px 20px;
  cursor: pointer;
  background-color: #c7c7c7;
  border: 1px solid #ddd;
  border-bottom: none;
  margin-right: 5px;
  border-radius: 10px 10px 0 0;
}

.tab-menu .tab-item:hover {
  background-color: #e6e6e6;
}

/* 탭 아이템 활성화 상태 */
.tab-menu .tab-item.active {
  background-color: #fff;
  border-bottom: 2px solid #fff;
  font-weight: 600;
}

/* 테이블 공통 스타일 */
table {
  width: 100%;
  border-collapse: collapse;
}

table thead {
  background-color: #ffe4c4; /* 밝은 배경 */
}

table th,
table td {
  text-align: center;
  padding: 10px 8px;
  border: 1px solid #ddd;
  font-size: 14px;
}

table tbody tr:hover {
  background-color: #f5f5f5;
}

/* 처리 버튼 스타일 */
.process-btn {
  background-color: #ff7675;
  color: #fff;
  border: none;
  padding: 6px 12px;
  cursor: pointer;
  border-radius: 4px;
  font-size: 13px;
}

.process-btn:hover {
  background-color: #ff5e57;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
	
	<main id="admin-page">
		<header>
    		<h1>관리자 페이지</h1>
  		</header>
		<div class="admin-container">
 			<ul class="tab-menu">
			    <li class="tab-item active" data-type="report">신고 내역</li>
			    <li class="tab-item" data-type="banlist">제재 내역</li>
			    <li class="tab-item" data-type="tbl_user">유저 관리</li>
 			</ul>
		</div>
	</main>
	<div id="modal-container">
        <%@ include file="/WEB-INF/views/member/postModal.jsp"%>
    </div>
	<%@ include file="/WEB-INF/views/member/rightSideMenu.jsp" %>
	
	<script>
	// 리스트로 불러올 떄 전달 및 반환변수
    let contentType = "report";
    let reqPage = 1;
    
    $(document).ready(function() {
    	loadList();
    	
		// 탭 클릭 이벤트
      	$('.tab-item').on('click', function() {
        // 모든 탭에서 active 제거
        $('.tab-item').removeClass('active');

        // 클릭한 탭에 active 추가
        $(this).addClass('active');

        // 탭마다 검색할 종류
        contentType = $(this).data('type');
        
        reqPage = 1;
        
        loadList();
	});
	
   	$(document).on('click', '.page-link', function(event) {
		event.preventDefault(); // 기본 동작(링크 이동) 방지
		
		// 클릭된 <a> 태그의 data-page 속성 값을 가져와 reqPage 업데이트
		reqPage = parseInt($(this).data('page'), 10);
		
		// 리스트를 새로 로드
		loadList();
		});
   	
	// "처리하기" 버튼 클릭 이벤트 (예시)
    $(document).on('click', '.process-btn', function() {
    	// 현재 클릭한 버튼이 속한 tr 찾기
        const $row = $(this).closest('tr');
		
    	// data-속성에서 값 꺼내기
        const userNo = $row.data('userno');
        const userId = $row.data('userid');
        const reportNo = $row.data('reportno'); 
    	
     	// tr 내부의 select.ban-duration에서 value 가져오기
        const banDuration = $row.find('.ban-duration').val();

     	// 신고내역에서 버튼 클릭 시
     	if (banDuration) {
     		if (!confirm(userId + "의 신고를 처리하시겠습니까?")) return;
            
            const formData = new FormData();
    		
    		formData.append("userNo", userNo);
    		formData.append("userId", userId);
    		formData.append("reportNo", reportNo);
    		formData.append("banEndDate", banDuration);
            
    		$.ajax({
    		    url: '/report/insertBanList.kh',
    		    type: 'POST',
    		    data: formData,
    		    processData: false, // 데이터를 쿼리 문자열로 변환하지 않음
    		    contentType: false, // 콘텐츠 타입을 설정하지 않음 (브라우저가 자동으로 설정)
    		    success: function(response) {
    		    	if (response === 'success') {
                        alert('신고가 정상적으로 처리되었습니다.');
                        
                        contentType = "report";
                        loadList();
                    } else if (response === 'error') {
                        alert('신고 처리 중 오류가 발생했습니다.');
                    } else {
                        alert('알 수 없는 오류가 발생했습니다.');
                    }
    		    },
    		    error: function(xhr, status, error) {
    		        alert('내용을 불러오는데 실패했습니다.');
    		        console.log(error);
    		    }
    		});

		// 유저관리에서 버튼 클릭 시
        } else {
        	if (!confirm(userId + "의 등급을 변경하시겠습니까?")) return;
            
            const formData = new FormData();
    		
    		formData.append("userNo", userNo);
    		formData.append("userId", userId);
    		
    		$.ajax({
    		    url: '/report/updAcctLevel.kh',
    		    type: 'POST',
    		    data: formData,
    		    processData: false, // 데이터를 쿼리 문자열로 변환하지 않음
    		    contentType: false, // 콘텐츠 타입을 설정하지 않음 (브라우저가 자동으로 설정)
    		    success: function(response) {
    		    	if (response === 'success') {
                        alert('등급이 정상적으로 변경되었습니다.');
                        
                        contentType = "tbl_user";
                        loadList();
                    } else if (response === 'error') {
                        alert('등급 변경 중 오류가 발생했습니다.');
                    } else {
                        alert('알 수 없는 오류가 발생했습니다.');
                    }
    		    },
    		    error: function(xhr, status, error) {
    		        alert('내용을 불러오는데 실패했습니다.');
    		        console.log(error);
    		    }
    		});
        }
	});
 
	});
    
    // 리스트를 불러올 함수
    function loadList(){
    	const formData = new FormData();
		
		formData.append("reqPage", reqPage);
		formData.append("contentType", contentType);
		
		$.ajax({
		    url: '/report/adminList.kh',
		    type: 'POST',
		    data: formData,
		    processData: false, // 데이터를 쿼리 문자열로 변환하지 않음
		    contentType: false, // 콘텐츠 타입을 설정하지 않음 (브라우저가 자동으로 설정)
		    success: function(response) {
		        const createhtml = createListHTML(response);
		        
		        // ul태그를 제외한 값 삭제
		        $('.admin-container').children().not('ul').remove();
		        
		        $('.admin-container').append(createhtml);
		    },
		    error: function(xhr, status, error) {
		        alert('내용을 불러오는데 실패했습니다.');
		        console.log(error);
		    }
		});
    }
    
    // html을 만들어주는 함수
    function createListHTML(viewContent){
    			
    	let html = '';
    	
    	html += '<div class="tab-content">';
    	
    	// 신고 내역일 경우
    	if(viewContent.reportList && viewContent.reportList.length > 0){
    		const reportList = viewContent.reportList;
    		
	    	html += '<h2>신고 내역</h2>';
	    	html += '<table>';
	    	html += '<thead>';
	    	html += '<tr><th>회원아이디</th><th>게시글</th><th>신고사유</th>' +
	    	           '<th>신고날짜</th><th>처리</th><th></th></tr>';
	    	html += '</thead>';
	    	html += '<tbody>';
    		reportList.forEach(report => {
    			html += '<tr ';
				html += 'data-reportno="' + report.reportNo + '" ';
				html += 'data-userno="' + report.userNo + '" ';
				html += 'data-userid="' + report.userId + '" ';
				html += '>';
				html += '<td>' + report.userId + '</td>';
				
		    	if(report.targetType === 'P'){
		    		html += '<td><a href="#" class="report-link" ' +
		    				'data-content="' + report.postContent + '" ' +
		    				'data-userno="' + report.userNo +'" ' +
		    				'data-post-no="' + report.targetNo + '">보기</a></td>';
		    	} else if(report.targetType === 'C'){
		    		html += '<td>댓글</td>';
		    	}
		    	
		    	html += '<td>' + report.reportReason + '</td>';
		    	html += '<td>' + report.reportDate + '</td>';
		    	html += '<td>';
		    	html += '<select class="ban-duration">';
		    	html +='<option value="false">허위신고</option>';
		    	html +='<option value="3">3일</option>';
		    	html +='<option value="7">7일</option>';
		    	html +='<option value="10">10일</option>';
		    	html +='<option value="forever">영구정지</option>';
		    	html +='</select>';
		    	html += '</td>';
		    	html += '<td><button class="process-btn">처리하기</button></td>';
		    	html += '</tr>';
    		});
    		
    	// 제재 내역일 경우
    	} else if (viewContent.banList && viewContent.banList.length > 0){
    		const banList = viewContent.banList;
	    	html += '<h2>제재 내역</h2>';
	    	html += '<table>';
	    	html += '<thead>';
	    	html += '<tr><th>회원아이디</th><th>제제사유</th><th>제제 시작일</th><th>제제 종료일</th></tr>';
	    	html += '</thead>';
	    	html += '<tbody>';
	    	banList.forEach(ban => {
		    	html += '<tr>';
		    	html += '<td>' + ban.userId + '</td>';
		    	html += '<td>' + ban.banReason + '</td>';
		    	html += '<td>' + ban.banStartDate + '</td>';
		    	
		    	if(ban.banEndDate != null){
		    		html += '<td>' + ban.banEndDate + '</td>';
		    	} else {
		    		html += '<td>영구정지</td>';
		    	}
		    	html += '</tr>';
    		});
    	
    	// 유저 정보일 경우
    	} else if (viewContent.memberList && viewContent.memberList.length > 0) {
    		const memberList = viewContent.memberList;
	    	html += '<h2>유저 관리</h2>';
	    	html += '<table>';
	    	html += '<thead>';
	    	html += '<tr><th>회원아이디</th><th>가입경로</th><th>가입일</th>' +
	    	           '<th>상태</th><th>정지이력</th><th>등급</th><th></th></tr>';
	    	html += '</thead>';
	    	html += '<tbody>';
	    	memberList.forEach(user => {
	    		html += '<tr ';
				html += 'data-userno="' + user.userNo + '" ';
				html += 'data-userid="' + user.userId + '" ';
				html += '>';
				
		    	html += '<td>' + user.userId + '</td>';
		    	
		    	if(user.userType === 'K'){
		    		html += '<td>카카오</td>';	
		    	} else if(user.userType === 'N'){
		    		html += '<td>네이버</td>';
		    	} else {
		    		html += '<td>홈페이지</td>';
		    	}
		    	
		    	html += '<td>' + user.enrollDate + '</td>';
		    	
		    	if(user.banYN === 'Y'){
		    		html += '<td>정지</td>';	
		    	} else if(user.banYN === 'N'){
		    		html += '<td>정상</td>';
		    	}
		    	
		    	html += '<td>' + user.banCnt + '</td>';
		    	
		    	if(user.acctLevel === 1){
		    		html += '<td>관리자</td>';	
		    	} else if(user.acctLevel === 0){
		    		html += '<td>일반회원</td>';
		    	}
		    	
		    	html += '<td><button class="process-btn">등급변경</button></td>';
		    	html += '</tr>';
    		});
    	} else {
    		html += '<h2>내역이 존재하지 않습니다.</h2>';
    	}
    	
    	html += '</tbody>';
    	html += '</table>';
    	html += '</div>';
    	html += '<h4>' + viewContent.pageNavi + '</h4>';
    	
    	return html;
    }
  </script>
</body>
</html>