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
	.dropdown-bottom-line{
	    border-color: gray;
	    height: 0;
	    width:425px;
	    margin: .5rem 0;
	    overflow: hidden;
	    border-top: 1px solid gray;
	    border-top-color: gray;
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
	.searchRecord{
		width: 425.2px;
		padding: 0;
		margin: 20px 0 0 0;
	}
	.searchRecord ul{
		margin: 0;
		padding: 0;
	}
	.searchRecordBox li{
		list-style-type: none;
		margin-bottom: 8px;
	}
	
	
	.ResultBox li {
		list-style-type: none;
		margin-bottom: 8px;
	}
	
	.user-result {
		width: 100%;
		display: flex;
		justify-content: space-between; /* 아이템 간의 공간을 균등하게 배분 */
    	align-items: center; /* 수직 중앙 정렬 */
		font-size: 16px;
		height: 62px;
	}
	.user-result:hover {
		background-color: #E6E6E6;
	}
	
	.a-user {
		display: block; /* block으로 변경하여 a가 li 크기를 채우도록 설정 */
		width: 100%; /* 부모 요소의 너비만큼 클릭 가능 */
		height: 100%;
		text-decoration: none; /* 밑줄 제거 */
		margin-left: 10px;
	}
	.delete-search {
	    display: flex; /* Flexbox 활성화 */
	    justify-content: center; /* 수평 중앙 정렬 */
	    align-items: center; /* 수직 중앙 정렬 */
	    margin-right: 10px; /* 왼쪽으로 약간 이동 */
	}
	.profile-container {
		display: flex;
		line-height: 62px; /* 세로 중앙 정렬 (li의 높이와 동일하게 설정) */
	}
	
	.hash-container{
		display: flex;
		line-height: 31px;
	}	
	.result-container{
		display: flex;
		line-height: 62px; /* 세로 중앙 정렬 (li의 높이와 동일하게 설정) */
	}
	.result-profile{
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
	
	.SearchName{
		display: flex;
	    font-weight: bold;
	    font-size: 16px;
	    justify-content: center; /* 수평 가운데 정렬 */
        align-items: center;
	    margin: 0; /* 여백 제거 */
    	line-height: normal; /* 텍스트 높이를 기본값으로 */
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
	.tagNames{
		display: flex;
	    font-weight: bold;
	    font-size: 16px;
	    justify-content: center; /* 수평 가운데 정렬 */
        align-items: center;
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
	.profileImage{
		background-color: #E6E6E6;
		height: 100%;
		width: 100%;
		border-radius: 50%;
		overflow: hidden; /*나중에 사진 들어가면 깔끔하게 잘리게*/
	}
	#ResultCategory{
		font-weight: bold;
		font-size: 18px;
		margin-left: 12px;
	}
	.ResultBtnBox{
		display: flex; /* Flexbox 활성화 */
		justify-content: space-between; /* 양쪽 끝으로 정렬 */
		align-items: center; /* 수직 중앙 정렬 */
		height: 42px;
	}
	.resultAllDelete{
		color: #0095F6;
	}
	.resultAllDelete:hover{
		color: black;
	}
	.user-profile{
		border: 1px solid gray;
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
        <br>
        <div class="dropdown-bottom-line"></div>
        	<c:if test="${not empty searchs}">
			<div class="searchRecord" id="searchRecord">
				<div class="ResultBtnBox">
					<div id="ResultCategory">최근 검색 항목</div>
					<div><a href="#" class="resultAllDelete">모두 지우기</a></div>
				</div>
				<ul class="searchRecordBox" id="searchRecordBox">
					<c:forEach var="search" items="${searchs}">
						<c:choose>
							<c:when test="${search.searchType == 'G'}">
								<li class="user-result">
									<a class="a-user" href="/member/searchHistory.kh?search=${search.keyWord}&vals=x&searchType=${search.searchType}">
										<div class="result-container">
											<div class="result-profile">
												<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="black" class="bi bi-search" viewBox="0 0 16 16">
  													<path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
												</svg>
											</div>
											<span class="SearchName">${search.keyWord}</span>
										</div>
									</a>
									<a href="#" class="delete-search" data-keyword="${search.keyWord}" data-search-type="${search.searchType}">
										<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="gray" class="bi bi-x-lg" viewBox="0 0 16 16">
  											<path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>
										</svg>
									</a>
								</li>
							</c:when>
							<c:when test="${search.searchType == 'H'}">
								<li class="user-result">
									<a class="a-user" href="/member/searchHistory.kh?hashName=${search.keyWord}&vals=x&searchType=${search.searchType}">
										<div class="hash-container">
											<div class="tag-profile">
												<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="black">
                                        			<path d="m240-160 40-160H120l20-80h160l40-160H180l20-80h160l40-160h80l-40 160h160l40-160h80l-40 160h160l-20 80H660l-40 160h160l-20 80H600l-40 160h-80l40-160H360l-40 160h-80Zm140-240h160l40-160H420l-40 160Z" />
                                    			</svg>
											</div>
											<span class="tagNames">${search.keyWord}</span>
										</div>
									</a>
									<a href="#" class="delete-search" data-keyword="${search.keyWord}" data-search-type="${search.searchType}">
										<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="gray" class="bi bi-x-lg" viewBox="0 0 16 16">
  											<path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>
										</svg>
									</a>
								</li>
							</c:when>
							<c:otherwise>
								<li class="user-result">
									<a class="a-user" href="/member/searchHistory.kh?userName=${search.searchUserId}&vals=x&searchType=${search.searchType}">
										<div class="profile-container">
											<div class="user-profile">
											<img class="profileImage" src="${not empty search.userImage ? search.userImage : '/resources/profile_file/default_profile.png'}"alt="프로필 이미지" />
											</div>
											<span>${search.searchUserId}</span>
										</div>
									</a>
									<a href="#" class="delete-search" data-keyword="${search.searchUserId}" data-search-type="${search.searchType}">
										<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="gray" class="bi bi-x-lg" viewBox="0 0 16 16">
  											<path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>
										</svg>
									</a>
								</li>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</ul>
			</div>
			</c:if>
			<div class="searchResults" id="searchResults">
            <ul class="ResultBox" id="ResultBox">
            
            </ul>
        </div>
    </form>    
</main>

<script>

	//입력을 받을때 마다 이벤트 발생 
	$(document).ready(function() {
		// 검색 입력란에 입력 이벤트(keyup)가 발생할 때마다 searchResults 함수 실행
		$('#search').on('keyup', function() {
			var searchValue = $(this).val().trim();

			// 입력 필드에 값이 없을 때 searchRecord를 다시 보이게 함
			if (searchValue.length === 0) {
				$('#searchRecord').show();
				$('#ResultBox').hide(); // 검색 결과를 숨김
			} else {
				$('#searchRecord').hide();
				$('#ResultBox').show();
				searchResults(searchValue);
			}

			// 기존의 searchResults 함수 호출

		});
	});

	let debounceTimeout = null;
	// 디바운스 하는 이유 : 서버 과부화 최소화하기 위해    
	function searchResults(search) {
		clearTimeout(debounceTimeout); // 이전에 설정된 타이머 제거 (중복 요청 방지)
		debounceTimeout = setTimeout(
				function() {
					var searchResultsBox = $('#ResultBox');
					if (search.trim().length == 0 || search == '#') { // 검색어가 비었거나 '#'만 있는 경우
						searchResultsBox.hide();
						searchResultsBox.empty();
						return;
					}
					$
							.ajax({
								type : 'GET',
								url : '/member/searchBoard.kh',
								data : {
									search : search
								}, // 'searchStr'에서 'search'로 변경
								success : function(response) {
									if ($.trim(response)) {
										searchResultsBox.html(response).show(); // 서버에서 받은 HTML 그대로 삽입
									} else {
										searchResultsBox
												.html(
														'<li class="user-result"><span id="search-result">검색 결과가 없습니다.</span></li>')
												.show();
									}
								},
								error : function() {
									searchResultsBox
											.html(
													'<li class="user-result">서버 오류가 발생했습니다.</li>')
											.show();
								}
							});
				}, 300); // 사용자가 입력을 멈춘 후 300ms(0.3초)가 지나면 서버 요청 실행
	}
	// 삭제 링크 클릭 이벤트
	$(document).on('click', '.delete-search', function(e) {
		e.preventDefault(); // 기본 링크 동작 방지
		var keyword = $(this).data('keyword'); // 삭제할 검색어 가져오기
		var searchType = $(this).data('search-type'); // 삭제할 검색 타입 가져오기
		var $listItem = $(this).closest('li'); // 삭제할 항목의 li 요소

		$.ajax({
			type : 'POST',
			url : '/member/deleteSearchHistory.kh', // 삭제 요청 URL
			data : {
				search : keyword,
				searchType : searchType
			}, // 검색어와 검색 타입 전송
			success : function(response) {
				// 삭제 성공 시 해당 항목을 DOM에서 제거
				$listItem.remove(); // 삭제된 항목을 DOM에서 제거
			},
			error : function() {
				console.log('서버 오류가 발생했습니다.');
			}
		});
	});
	
	// 전체 삭제 버튼 클릭 이벤트
	$(document).on('click', '.resultAllDelete', function(e) {
		e.preventDefault(); // 기본 링크 동작 방지

	    // AJAX 요청
	    $.ajax({
	        type: 'POST',
	        url: '/member/deleteSearchHistory.kh', // 삭제 요청 URL
	        data: {
	            search: 'all', // 전체 삭제를 위한 파라미터
	            searchType: null // 필요하지 않음
	        },
	        success: function(response) {
	        	location.reload(); // 페이지 새로고침
	        },
	        error: function() {
	            console.log('서버 오류가 발생했습니다.');
	        }
	    });
	});
</script>

</body>
</html>