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
	.searchInputBox {
		display: flex;
		align-items: center; /* 수직 정렬 */
		border: 3px solid #ccc;
		padding: 0 10px 0 10px;
		border-radius: 16px;
		width: 400px;
		height: 40px; /* 고정 높이 설정 */
		background-color: white; /* 배경색 */
		flex-shrink: 0; /* 컨테이너가 줄어들지 않도록 설정 */
	}
	
	.searchInputBox svg {
		margin-right: 12px; /* 아이콘과 입력창 간 간격 */
		vertical-align: middle; /* 아이콘 위치 중앙 정렬 */
		flex-shrink: 0; /* 아이콘 크기 고정 */
	}
	/* 포커스가 있을 때 SVG 아이콘 숨기기 */
	.searchInputBox:focus-within svg {
		display: none; /* 아이콘을 완전히 숨김 */
	}
	
	.searchInputBox input[type="search"] {
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
	
	.searchInputBox input[type="search"]::placeholder {
		color: #aaa;
	}
	
	.searchResults {
		width: 425.2px;
		padding: 0;
		margin: 20px 0 0 0;
	}
	
	.searchResults ul {
		margin: 0;
		padding: 0;
	}
	
	.ResultBox li {
		list-style-type: none;
		margin-bottom: 8px;
	}
	
	.user-result {
		width: 100%;
		font-size: 16px;
		height: 62px;
	}
	
	.a-user {
		display: block; /* block으로 변경하여 a가 li 크기를 채우도록 설정 */
		width: 100%; /* 부모 요소의 너비만큼 클릭 가능 */
		height: 100%;
		text-decoration: none; /* 밑줄 제거 */
	}
	
	.a-user:hover {
		background-color: #E6E6E6;
	}
	
	.profile-container {
		display: flex;
		line-height: 62px; /* 세로 중앙 정렬 (li의 높이와 동일하게 설정) */
	}
	
	.hash-container{
		display: flex;
		line-height: 31px;
	}	
	.tag-profile{
		font-size: 24px;
		width: 45px;
		height: 45px;
		border: 1px solid gray;
		border-radius: 50%;
		background-color: white;
		margin: 8px 12px 5px 0;
		display: flex; /* Flexbox 활성화 */
	    justify-content: center; /* 수평 가운데 정렬 */
	    align-items: center; /* 수직 가운데 정렬 */
	}
	.tag-span{
		display: flex;
    	flex-direction: column; /* 태그 이름과 게시글 수를 수직으로 정렬 */
    	justify-content: center; /* 수직 정렬 */
    	gap: 2px; /* 태그 이름과 게시글 수 간의 간격 */ 
	}
	.tagName {
		display: flex;
	    font-weight: bold;
	    font-size: 16px;
	    margin: 0; /* 여백 제거 */
    	line-height: normal; /* 텍스트 높이를 기본값으로 */
	}
	.tagPostCount {
		display: block; /* block으로 설정하여 아래로 이동 */
	    color: #666;
	    font-size: 12px;
	    margin: 0; /* 여백 제거 */
    	line-height: normal; /* 텍스트 높이를 기본값으로 */
	}
	
	.user-profile {
		width: 45px;
		height: 45px;
		border-radius: 50%;
		background-color: gray;
		margin: 8px 12px 5px 0;
	}
	
	#search-result {
		line-height: 62px; /* 세로 중앙 정렬 (li의 높이와 동일하게 설정) */
		text-align: center; /* 가로 중앙 정렬 */
	}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
	<main>
		<form action="/member/keywordSearch.kh" method="get">
	        <div class="searchInputBox" id="searchInputBox">
	            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#999" class="bi bi-search" viewBox="0 0 16 16">
	                <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
	            </svg>
	            <input type="search" class="search" name="search" id="search" placeholder="아이디/이름 검색하기" autocomplete="off" onkeyup="searchResults(this.value)">        
	        </div>
	        <div >
		    	<ul>
		    		<li>
		    			<a onclick="filterResults('post')">게시글</a>
		    		</li>
		    		<li>
		    			<a onclick="filterResults('hashtag')">해시태그</a>
		    		</li>
		    		<li>
		    			<a onclick="filterResults('user')">사용자</a>
		    		</li>
		    	</ul>
		    </div>
	        <div class="searchResults" id="searchResults">
	            <ul class="ResultBox" id="ResultBox">
	            
	            </ul>
	        </div>
	    </form>    
	</main>
	
	<script>
		// 페이지 로드 시 유저 검색 결과를 기본으로 가져옴
	    $(document).ready(function() {
	        filterResults('user');
	    });
	
		document.addEventListener('DOMContentLoaded', function () {
	        const searchInput = document.getElementById('search');
	        const originalValue = searchInput.value; // 원래 값을 저장
	
	        // 입력창을 클릭하면 값 비우기
	        searchInput.addEventListener('focus', function () {
	            if (searchInput.value == originalValue) {
	                searchInput.value = '';
	            }
	        });
	
	        // 입력창에서 포커스를 벗어나면 원래 값 복원
	        searchInput.addEventListener('blur', function () {
	            if (searchInput.value.trim() == '') {
	                searchInput.value = originalValue;
	            }
	        });
	    });
		
		function filterResults(type) {
            $.ajax({
                type: 'GET',
                url: '/member/filterResults.kh', // 컨트롤러 URL
                data: {
                    filterType: type,
                    search: '${search}' // 검색 키워드 전달
                },
                success: function(response) {
                    $('#ResultBox').html(response); // 결과 영역에 응답 삽입
                },
                error: function() {
                    $('#ResultBox').html('<p>결과를 가져오는 중 오류가 발생했습니다.</p>');
                }
            });
        }
	</script>
</body>
</html>