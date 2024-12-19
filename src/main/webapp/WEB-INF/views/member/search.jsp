<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet"  href="/resources/default.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
	#searchInputBox {
    display: flex;
    align-items: center; /* 수직 정렬 */
    border: 3px solid #ccc;
    padding: 0 10px 0 10px;
    border-radius: 16px; 
    width: 400px; /* 검색창 너비 */
    height: 40px; /* 고정 높이 설정 */
    background-color: white; /* 배경색 */
    flex-shrink: 0; /* 컨테이너가 줄어들지 않도록 설정 */
  }

  #searchInputBox svg {
    margin-right: 12px; /* 아이콘과 입력창 간 간격 */
    vertical-align: middle; /* 아이콘 위치 중앙 정렬 */
    flex-shrink: 0; /* 아이콘 크기 고정 */
  }
   /* 포커스가 있을 때 SVG 아이콘 숨기기 */
    #searchInputBox:focus-within svg {
        display: none; /* 아이콘을 완전히 숨김 */
    }

  #searchInputBox input[type="search"] {
  	padding: 0;
  	margin: 0;
    border: none; /* 테두리 제거 */
    outline: none; /* 클릭 시 아웃라인 제거 */
    flex: 1; /* 입력 필드가 남은 공간 차지 */
    flex-shrink: 0; /* 줄어들지 않도록 설정 */
    font-size: 16px; /* 글자 크기 */
    color: #666; /* 글자 색상 */
    background-color: white; /* 배경 투명 */
    height: 100%; 
  }

  #searchInputBox input[type="search"]::placeholder {
    color: #aaa; 
  }
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
	<main>
		<form action="/member/search.kh" method="get">
			<div id="searchInputBox">
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#999" class="bi bi-search" viewBox="0 0 16 16">
  					<path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
				</svg>
				<input type="search" name="search" id="search" placeholder="아이디/이름 검색하기" autocomplete="off" onkeyup="searchResults(this.value)">		
			</div>
			<div id="searchResults">
			</div>
		</form>	
	</main>
	
	<script>
		let debounceTimeout = null;
	
	    function searchResults(searchStr){
	        clearTimeout(debounceTimeout);
	        debounceTimeout = setTimeout(function() {
	            var searchResultsBox = $('#searchResults');
	            if (searchStr.trim().length === 0) {
	                searchResultsBox.hide();
	                searchResultsBox.empty();
	                return;
	            }
	            $.ajax({
	                type: 'POST', // GET에서 POST로 변경
	                url: '/member/searchBoard.kh',
	                data: { searchStr: searchStr }, // 'search'에서 'searchStr'로 변경
	                success: function(response) {
	                    if ($.trim(response)) {
	                    	searchResultsBox.html(response).show(); // 서버에서 받은 HTML 그대로 삽입
	                    } else {
	                        searchResultsBox.html('<div class="user-result">검색 결과가 없습니다.</div>').show();
	                    }
	                },
	                error: function() {
	                    searchResultsBox.html('<div class="user-result">서버 오류가 발생했습니다.</div>').show();
	                }
	            });
	        }, 300); // 300ms 디바운스
	    }
	
	    // 검색 입력 필드에 키업 이벤트 연결
	    $(document).ready(function() {
	        $('#search').on('keyup', function() {
	            searchResults($(this).val());
	        });
	    });
	
	    // 검색 결과 외부 클릭 시 결과 숨기기
	    $(document).click(function(event) { 
	        var $target = $(event.target);
	        if(!$target.closest('#searchInputBox').length && 
	           !$target.closest('#searchResults').length) {
	            $('#searchResults').hide();
	        }        
	    });
	    
	</script>
</body>
</html>