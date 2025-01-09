<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main Feed</title>

<link rel ="stylesheet"  href="/resources/default.css"  >
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
/* 가운데 정렬이 안되서 width값 1200으로 고정시킴 */
.main-feed-container {
  width: 55vw;
}
/* 전체 카드 감싸는 컨테이너 */
.main-post-container {
  width: 500px;                /* 카드 전체 폭 예시 */
  margin: 32px auto 0;
  border: 1px solid #ccc;      /* 테두리 */
  border-radius: 6px;          /* 모서리 살짝 둥글게 */
  box-sizing: border-box;
  background-color: #fff;
  overflow: hidden;            /* 내부 요소가 삐져나가지 않도록 */
  font-family: sans-serif;     /* 폰트 예시 */
}

/* 헤더 영역: 프로필사진, 닉네임, 작성일, 우측 옵션버튼(...) */
.main-feed-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px;               /* 헤더 안쪽 여백 */
}
.header-left-user{
	display: flex;
	align-items: center;
	cursor: pointer;
}

/* 왼쪽: 프로필 사진 + 닉네임 + 작성일 */
.main-feed-header-left {
  display: flex;          /* 가로 배치 */
  align-items: center;    /* 세로 가운데 정렬 */
}

/* 프로필 사진 틀(원형) */
.main-feed-header-left-img {
  width: 40px;                /* 프로필 이미지 크기 */
  height: 40px;
  margin-right: 8px;
  border-radius: 50%;         /* 원형 */
  overflow: hidden;           /* 이미지가 원형에 맞게 잘리도록 */
  background-color: #eee;     /* 실제 이미지 없을 때 배경 표시용 */
  border: 1px solid gray;
}

/* 프로필 이미지 실제 적용 */
.main-feed-header-left-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;          /* 이미지가 영역에 꽉 차도록 */
}
.hearder-left-user{
	display: flex;
	align-items: center;
	
}
/* 닉네임 */
.main-feed-header-left-nickname {
  font-weight: bold;
  font-size: 18px;
  margin-right: 4px;
}

/* 작성일 */
.main-feed-header-left-postDate {
  font-size: 1rem;
  color: #666;
}

/* 오른쪽: 점세개(...) */
.main-feed-header-right {
  cursor: pointer;
}

/* 게시물 이미지 영역 */
.main-feed-content {
  width: 100%;
  border-top: 1px solid #ccc;
  border-bottom: 1px solid #ccc;
}

.main-feed-content-img img {
  width: 100%;
  display: block;
  object-fit: cover;          /* 필요한 경우, 이미지 비율 유지하면서 꽉 채울 때 */
}

/* 푸터 전체 */
.main-feed-footer {
  padding: 8px;               /* 좋아요, 댓글, 북마크, 텍스트 부분 */
  position: relative;         /* float 요소 배치를 좀 더 직관적으로 조정 가능 */
}

/* 좋아요/댓글 아이콘 영역(왼쪽) + 북마크 영역(오른쪽) */
.main-feed-footer-left {
  display: flex;              /* 가로로 나란히 */
  align-items: center;        /* 세로 정렬 */
  gap: 8px;                   /* 아이콘 간격 */
  float: left;
}

.main-feed-footer-right {
  display: flex;
  align-items: center;
  float: right;               /* 오른쪽 배치 */
}
.all-comment{
	display: flex;
	margin-bottom: 8px;
}
/* 아이콘 자체 스타일 (여백 등) */
.main-feed-like,
.main-feed-comment,
.main-feed-bookmark {
  margin-right: 8px;
}

/* float 해제용 (BFC) */
.main-feed-footer::after {
  content: "";
  display: block;
  clear: both;
}

/* 좋아요 개수를 새 줄에 배치 */
.main-feed-footer-likeCount {
  display: block;   /* 블록화 */
  clear: both;      /* 위 float된 요소들 아래로 */
  margin-top: 8px;  /* 간격 */
  font-weight: 500; /* 예시로 약간 볼드하게 */
}

/* 닉네임 + 내용 부분 */
.main-feed-content-text {
  margin-top: 6px;            /* '좋아요 개수' 아래로 약간 여백 */
  font-size: 0.95rem;
  line-height: 1.4;
}

.main-feed-content-text span:first-child {
  font-weight: bold;          /* 닉네임 볼드 처리 */
  margin-right: 6px;
  margin-bottom: 6px;
}
.user-comment{
	margin-bottom: 6px;
	font-size: 0.95rem;
	line-height: 1.4;
}
.main-feed-like svg {
  display: flex;          /* 링크 자체가 flex 컨테이너가 되도록 */
  align-items: center;    /* 내부 SVG를 수직 중앙 정렬 */
  justify-content: center; /* 필요하면 수평도 가운데 정렬 */
}
/* 로딩 스피너 스타일 */
#loading {
	text-align: center;
	padding: 20px;
	display: none; /* 기본적으로 숨김 */
}
#loading i {
	font-size: 24px;
	color: #555;
}
.comment-input{
	width: 100%;
}

/* ===========신고 모달============ */
.report-modal-content {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 400px;
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    display: flex;
    flex-direction: column;
    gap: 20px;
}
.report-header h2 {
    font-size: 18px;
    text-align: center;
    margin: 0;
}
.report-reason label {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 15px;
    cursor: pointer;
}
.report-reason {
    display: grid;
    grid-template-columns: 1fr 1fr; /* 2열로 정렬 */
    gap: 10px;
}
.reportRadio{
    width: 10px;
    height: 10px;
    margin-right: 5px;
}
.report-footer {
    display: flex;
    justify-content: space-around;
    gap: 10px;
}

.report-footer .btn {
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 14px;
    border: none;
}
.btn-delete {
    background-color: #f7d3d3;
    color: #a33;
}
.btn-delete:hover {
    background-color: #f5bcbc;
}
.cancel-btn {
    background-color: #ccc;
}
.cancel-btn:hover {
    background-color: #bbb;
}

/* 좋아요 버튼 기본 스타일 */
.post-like svg {
  fill: gray; /* 기본 색상 */
  transition: fill 0.3s ease; /* 색상 변화 효과 */
}



/* 좋아요 활성화 상태 */
.post-like[data-liked="true"] svg {
  fill: red; /* 좋아요 활성화 상태 색상 */
  transform: scale(1.2); /* 약간 커지는 효과 */
  transition: transform 0.2s ease, fill 0.2s ease; /* 크기와 색상 변화 효과 */
}

/* 좋아요 비활성화 상태 */
.post-like[data-liked="false"] svg {
  fill: gray; /* 비활성화 상태 색상 */
  transform: scale(1); /* 원래 크기 */
}

</style>
</head>
<body>
	<%--사이드 메뉴--%>
	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
	
	<main id="main-feed">
		<div>
			<%@ include file="/WEB-INF/views/member/story.jsp" %>
		</div>
	 	<div>
	 		 <div id="feed-container" class="main-feed-container"></div>
	 		 <div id="loading">
	 		  	<i class="fa fa-spinner fa-spin"></i> 로딩중...
	 		</div>
	 	</div>
	</main>
	
	<%@ include file="/WEB-INF/views/member/rightSideMenu.jsp" %>
	
	<script>
	let offset = 0;       // 현재까지 로드된 게시물 수
    let isLoading = false; // 중복 로딩 방지
    let noMorePosts = false; // 새 게시물이 더이상 없는 상태인지 여부
    const limit = 10;  
    const loadedPostIds = new Set();

    $(document).ready(function() {
    	 
    	window.initializeLikeButtons = function () {
    	    const loginUserNo = "${loginMember.userNo}"; // 현재 로그인한 사용자

    	    $(".post-like").each(function () {
    	        const $btn = $(this);
    	        const postNo = $btn.data("target-no");

    	        if (!postNo || !loginUserNo) {
    	            console.warn(`[WARN] postNo 또는 loginUserNo가 없음. postNo: ${postNo}, loginUserNo: ${loginUserNo}`);
    	            return;
    	        }

    	        // 좋아요 상태 확인 요청
    	        $.ajax({
    	            url: "/post/isLiked.kh",
    	            type: "GET",
    	            data: { 
    	                targetNo: postNo, 
    	                userNo: loginUserNo, // 로그인한 사용자 기준으로 좋아요 상태 확인
    	                targetType: "P" 
    	            },
    	            success: function (response) {
    	                const isLiked = response === "true";
    	                $btn.data("liked", isLiked);
    	                $btn.attr("data-liked", isLiked.toString());
    	                $btn.find("svg")
    	                    .removeClass("bi-heart bi-heart-fill")
    	                    .addClass(isLiked ? "bi-heart-fill" : "bi-heart");
    	            },
    	            error: function (xhr, status, error) {
    	                console.error(`[ERROR] 좋아요 상태 확인 실패 - postNo: ${postNo}, loginUserNo: ${loginUserNo}`, error);
    	            },
    	        });
    	    });
    	};

    	
    	// 페이지 로드 시 초기 게시물 로딩
        loadInitialPosts();
        
        // 스크롤 이벤트 감지: 끝부분 근접 시 추가 로딩
        $(window).scroll(function() {
        	
        	if (noMorePosts) {
                return;
            }
        	
            if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
                if (!isLoading) {
                    loadMorePosts();
                }
            }
        });
    });

    // 초기 게시물 불러오기
    function loadInitialPosts() {
        isLoading = true;
        $.ajax({
            url: '/post/initialPosts.kh',  // 컨트롤러에서 JSON 리스트 반환
            type: 'GET',
            dataType: 'json',
            success: function(data) {
            	// 새로운 게시물만 필터링
                let newPosts = data.filter(post => !loadedPostIds.has(post.postNo));
                //console.log("[loadInitialPosts] data:", data);
                if (newPosts.length > 0) {
                offset += newPosts.length;
                renderPosts(newPosts);
                // 새로운 게시물의 postNo를 loadedPostIds에 추가
                newPosts.forEach(post => {
                    loadedPostIds.add(post.postNo);
                });
            } else {
                // 새로운 게시물이 없으면 무한 스크롤 중지
                noMorePosts = true;
                $('#feed-container').append('<p style="text-align:center;">더 이상 게시물이 없습니다.</p>');
            }
                
                isLoading = false;
            },
            error: function() {
                alert('게시물을 불러오는 도중 오류가 발생했습니다.');
                isLoading = false;
            }
        });
    }

    // 추가 게시물 불러오기 (무한 스크롤)
    function loadMorePosts() {
        isLoading = true;
        $('#loading').show();
        $.ajax({
            url: '/post/loadMorePosts.kh',
            type: 'GET',
            data: { 
            	offset: offset,
                limit: limit,
                excludeList: Array.from(loadedPostIds)   // Set을 배열로 변환하여 전송
            	},
            traditional: true, // 배열 직렬화 옵션 추가
            dataType: 'json',
            success: function(data) {
            	if (data.length > 0) {
            		renderPosts(data);
                    // 새로운 게시물의 postNo를 loadedPostIds에 추가 (Set을 사용하여 중복 없이 추가)
                    data.forEach(post => {
                        loadedPostIds.add(post.postNo);
                    });
                    offset += data.length;
                } else {
                    // 새로운 게시물이 없으면 무한 스크롤 중지
                    noMorePosts = true;
                    $('#feed-container').append('<p style="text-align:center;">더 이상 게시물이 없습니다.</p>');
                }
                $('#loading').hide();
                isLoading = false;
            },
            error: function() {
                alert('게시물을 불러오는 도중 오류가 발생했습니다.');
                $('#loading').hide();
                isLoading = false;
            }
        });
    }

    // 받아온 posts 배열을 HTML로 변환 후 화면에 추가
    function renderPosts(posts) {
        let container = $('#feed-container');
        //console.log("renderPosts() 호출, posts:", posts);

        posts.forEach(function(post, index) {
            let mediaHtml = '';
            if(post.postFileNames && post.postFileNames.length > 0) {
                // 이미지 여러 장이라면, 슬라이더나 캐러셀로 보여주는 방식도 가능
                post.postFileNames.forEach(function(fileUrl) {
                    // 파일 확장자 체크
                    let lowerUrl = fileUrl.toLowerCase();
                    let ext = lowerUrl.substring(lowerUrl.lastIndexOf('.')+1);
                    if(ext === 'mp4' || ext === 'wmv' || ext === 'mov') {
                        mediaHtml += 
                          '<video controls width="500" style="max-height:500px;">'
                         + '  <source src="' + fileUrl + '" type="video/' + ext + '" />'
                         + '동영상을 재생할 수 없습니다.'
                         + '</video>';
                    } else {
                        mediaHtml += 
                          '<img src="' + fileUrl + '" '
                         + '     alt="Post Image" style="max-width:500px; max-height:500px;">';
                    }
                });
            } else {
                // 이미지가 없는 경우(텍스트만 있는 경우)
                // 혹은 기본 이미지를 보여줄 수도 있음
                mediaHtml = '<p>이미지 없음</p>';
            }
            
            // 혹시 댓글 n개 모두 보기가 필요한 경우
            let commentLink = '';
            if (post.commentCount > 1) {
                commentLink =
                	'<span class="user-comment">' +
                		post.firstCommentUserNickname + ' ' +
                		post.firstCommentContent +
                	'</span>' + 
                    '<a class="all-comment" href="#">' +
                    '    <span>댓글 ' + post.commentCount + '개 모두 보기</span>' +
                    '</a>';
            } else if(post.commentCount == 1){
            	commentLink =
            		'<span class="user-comment">' +
	            		post.firstCommentUserNickname + ' ' +
	            		post.firstCommentContent +
	            	'</span>'
            }
            
            //좋아요 상태 관련 체크
            const isLiked = post.isLiked ? 'true' : 'false'; 
            
            // 게시물 하나에 대한 HTML (문자열 연결)
            let postHtml =
                '<div class="main-post-container">' +
                    '<div class="main-feed-header">' +
                        '<div class="main-feed-header-left">' +
                            '<a class="header-left-user"  href="/member/profile.kh?userNo=' + post.userNo + '"  data-type="Post">' +
                                '<div class="main-feed-header-left-img">' +
                                    '<img src="' + post.userImage + '" alt="User Image" class="main-feed-profile-img">' +
                                '</div>' +
                                '<div class="main-feed-header-left-nickname">' +
                                    '<span>' + post.userNickname + '</span>' +
                                '</div>' +
                            '</a>' +
                            '<div class="main-feed-header-left-postDate">' +
                                '<span>• ' + post.postDate + '</span>' +
                            '</div>' +
                        '</div>' +
                        '<div class="main-feed-header-right">' +
                            '<a class="report-Btn" href="#" data-post-no="'+ post.postNo + '" data-target-type="P">' +
                                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="black"' +
                                    'class="bi bi-three-dots" viewBox="0 0 16 16">' +
                                    '<path d="M3 9.5a1.5 1.5 0 1 1 0-3' +
                                            ' 1.5 1.5 0 0 1 0 3m5 0a1.5' +
                                            ' 1.5 0 1 1 0-3 1.5 1.5 0 0 1' +
                                            ' 0 3m5 0a1.5 1.5 0 1 1 0-3' +
                                            ' 1.5 1.5 0 0 1 0 3"/>' +
                                '</svg>' +
                            '</a>' +
                        '</div>' +
                    '</div>' + // main-feed-header

                    '<div class="main-feed-content">' +
                        '<div class="main-feed-content-img">' +
                        	mediaHtml +
                        '</div>' +
                    '</div>' +

                    '<div class="main-feed-footer">' +
                        '<div class="main-feed-footer-left">' +
                            '<div class="main-feed-like">' +
                            '<a href="#" class="post-like" data-target-no="'+ post.postNo + '" data-user-no="'+ ${loginUserNo} + '" data-liked="'+ isLiked + '">' +
                                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="black"' +
                                         'class="bi bi-heart" viewBox="0 0 16 16">' +
                                        '<path d="m8 2.748-.717-.737C5.6.281' +
                                                ' 2.514.878 1.4 3.053c-.523' +
                                                ' 1.023-.641 2.5.314 4.385.92' +
                                                ' 1.815 2.834 3.989 6.286' +
                                                ' 6.357 3.452-2.368 5.365-4.542' +
                                                ' 6.286-6.357.955-1.886.838-3.362.314-4.385' +
                                                ' C13.486 .878 10.4 .28 8.717 2.01zM8' +
                                                ' 15C-7.333 4.868 3.279-3.04 7.824' +
                                                ' 1.143q.09.083.176.171a3 3 0 0 1' +
                                                ' .176-.17C12.72-3.042 23.333' +
                                                ' 4.867 8 15"/>' +
                                    '</svg>' +
                                '</a>' +
                            '</div>' +
                            '<div class="main-feed-comment">' +
                                '<a href="#">' +
                                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="black"' +
                                         'class="bi bi-chat" viewBox="0 0 16 16">' +
                                        '<path d="M2.678 11.894a1 1 0 0 1' +
                                                ' .287.801 11 11 0 0 1-.398' +
                                                ' 2c1.395-.323 2.247-.697' +
                                                ' 2.634-.893a1 1 0 0 1 .71-.074A8' +
                                                ' 8 0 0 0 8 14c3.996 0 7-2.807' +
                                                ' 7-6s-3.004-6-7-6-7 2.808-7' +
                                                ' 6c0 1.468.617 2.83 1.678' +
                                                ' 3.894m-.493 3.905a22 22 0 0 1' +
                                                ' -.713.129c-.2.032-.352-.176-.273-.362a10' +
                                                ' 10 0 0 0 .244-.637l.003-.01c.248-.72.45-1.548.524-2.319C.743' +
                                                ' 11.37 0 9.76 0 8c0-3.866' +
                                                ' 3.582-7 8-7s8 3.134 8' +
                                                ' 7-3.582 7-8 7a9 9 0 0' +
                                                ' 1-2.347-.306c-.52.263-1.639.742-3.468' +
                                                ' 1.105"/>' +
                                    '</svg>' +
                                '</a>' +
                            '</div>' +
                        '</div>' +
                        '<div class="main-feed-footer-right">' +
                            '<div class="main-feed-bookmark">' +
                                '<a href="#">' +
                                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="black"' +
                                         'class="bi bi-bookmark" viewBox="0 0 16 16">' +
                                        '<path d="M2 2a2 2 0 0 1 2-2h8a2' +
                                                ' 2 0 0 1 2 2v13.5a.5.5' +
                                                ' 0 0 1-.777.416L8' +
                                                ' 13.101l-5.223 2.815A.5.5' +
                                                ' 0 0 1 2 15.5zm2-1a1' +
                                                ' 1 0 0 0-1 1v12.566l4.723-2.482a.5.5' +
                                                ' 0 0 1 .554 0L13 14.566V2a1' +
                                                ' 1 0 0 0-1-1z"/>' +
                                    '</svg>' +
                                '</a>' +
                            '</div>' +
                        '</div>' +
                        '<div class="main-feed-footer-likeCount">' +
                            '<span class="like-count">' + post.likeCount + '</span>명이 좋아합니다' +
                        '</div>' +
                        '<div>' +
                            '<div class="main-feed-content-text">' +
                                '<span>' + post.userNickname + '</span>' +
                                '<span>' + post.postContent + '</span>' +
                            '</div>' +
                            '<div class="main-feed-footer-comment">' +
                                commentLink +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';
			
             
            // feed-container 내부에 게시물 DOM 추가
            container.append(postHtml);
            
        });
        
        initializeLikeButtons();
        
        
        // 신고 modalHTML
        function createReportModal(targetType){
            
            let html = '';
            html += '<div id="storyModalBackdrop" class="story-modal-backdrop">';
            html += '<div class="report-modal-content">';
            html += '<div class="report-header">';
                if(targetType === 'P'){
                    html += '<h2>해당 게시물을 신고하시겠습니까?</h2>';
                } else if (targetType === 'C'){
                    html += '<h2>해당 댓글을 신고하시겠습니까?</h2>';
                }
            html += '</div>';
            html += '<div class="report-item">';
            html += '<div class="report-reason">';
            html += '<label><input class="reportRadio" type="radio" name="reportReason" value="영리목적/홍보성"/>영리목적/홍보성</label>';
            html += '<label><input class="reportRadio" type="radio" name="reportReason" value="개인정보노출"/>개인정보노출</label>';
            html += '<label><input class="reportRadio" type="radio" name="reportReason" value="불법정보"/>불법정보</label>';
            html += '<label><input class="reportRadio" type="radio" name="reportReason" value="음란성/선정성"/>음란성/선정성</label>';
            html += '<label><input class="reportRadio" type="radio" name="reportReason" value="욕설/인신공격"/>욕설/인신공격</label>';
            html += '<label><input class="reportRadio" type="radio" name="reportReason" value="도배성"/>도배성</label>';
            html += '</div>';
            html += '</div>';
            html += '<div class="report-footer">';
            html += '<button class="btn btn-delete" id="reportBtn">신고</button>';
            html += '<button class="btn cancel-btn" id="cancelBtn">취소</button>';
            html += '</div>';
            html += '</div>';
            html += '</div>';
            
            return html;
        }
        
        // 게시물에서 '''버튼 클릭 시
        $('.report-Btn').on('click', function() {
            const loginUserNo = "${loginMember.userNo}";
            const targetNo = $(this).data('target-no');
            const targetType = $(this).data('target-type');
            
            const reportModalHtml = createReportModal(targetType);
            $('body').prepend(reportModalHtml);
            
            // (이벤트) 신고 버튼
            $('.report-modal-content').on('click', '#reportBtn', executeReport);
            
             // (이벤트) 닫기 버튼
            $('.report-modal-content').on('click', '#cancelBtn', cancelReport);
            
             function executeReport(){
                 const selectedReason = $('input[name="reportReason"]:checked').val();
                 
                 if (!confirm("정말 신고를 하시겠습니까?")) return;
                 
                 if (!selectedReason) {
                    alert('신고 사유를 선택해주세요.');
                    return;
                }
                 
                 const formData = new FormData();
                formData.append("userNo", loginUserNo);
                formData.append("targetNo", targetNo);
                formData.append("targetType", targetType);
                formData.append("reportReason", selectedReason);
                 
                 $.ajax({
                    url: '/report/insertReport.kh',
                    type: 'POST',
                    data: formData,
                    processData: false, // 데이터를 쿼리 문자열로 변환하지 않음
                    contentType: false, // 콘텐츠 타입을 설정하지 않음 (브라우저가 자동으로 설정)
                    success: function(response) {
                        if (response === 'success') {
                            alert('신고가 정상적으로 접수되었습니다.');
                            cancelReport();
                        } else if (response === 'error') {
                            alert('신고 중 오류가 발생했습니다.');
                        } else {
                            alert('알 수 없는 오류가 발생했습니다.');
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('신고에 실패했습니다.');
                        console.log(error);
                    }
                });
                 
             }
             
             function cancelReport(){
                 $("#storyModalBackdrop").remove();
             }
        });
    }
    
    $(document).ready(function () {
        // 좋아요 클릭 이벤트
     let isProcessing = false;
			
			$(document).off("click", ".post-like").on("click", ".post-like", function (event) {
			    event.preventDefault();
			
			    if (isProcessing) return;
			    isProcessing = true;
			
			    const $btn = $(this);
			    const postNo = $btn.data("target-no");
			    const loginUserNo = "${loginMember.userNo}"; // 현재 로그인한 사용자
			    const isLiked = $btn.data("liked");
			    const url = isLiked ? "/post/postLikeDel.kh" : "/post/postLike.kh";
			
			    if (!postNo || !loginUserNo) {
			        console.error("postNo 또는 loginUserNo가 누락되었습니다.");
			        isProcessing = false;
			        return;
			    }
			
			    // 좋아요 상태 변경 요청
			    $.ajax({
			        url: url,
			        type: "GET",
			        data: { 
			            targetNo: postNo, 
			            userNo: loginUserNo, // 로그인한 사용자 전달
			            targetType: "P" 
			        },
			        success: function (response) {
			            if (response === "success") {
			                const newLiked = !isLiked;
			                $btn.data("liked", newLiked);
			                $btn.attr("data-liked", newLiked.toString());
			                $btn.find("svg")
			                    .removeClass("bi-heart bi-heart-fill")
			                    .addClass(newLiked ? "bi-heart-fill" : "bi-heart");
			
			                // 좋아요 개수 업데이트
			                updateLikeCount(postNo, $btn);
			            } else {
			                alert("좋아요 처리 실패");
			            }
			            isProcessing = false;
			        },
			        error: function () {
			            alert("좋아요 요청 처리 중 문제가 발생했습니다.");
			            isProcessing = false;
			        },
			    });
			});
			


        // 좋아요 개수 업데이트 함수
	     function updateLikeCount(postNo, $likeBtn) {
		    $.ajax({
		        url: "/post/postlikeCnt.kh",
		        type: "GET",
		        data: { targetNo: postNo },
		        success: function (likeCountResponse) {
		            const likeCount = parseInt(likeCountResponse) || 0;
		            $likeBtn.closest(".main-post-container")
		                .find(".like-count").text(likeCount); // 현재 게시물 좋아요 개수 업데이트
		        },
		        error: function () {
		            console.error(`[ERROR] 좋아요 개수 초기화 실패 - postNo: ${postNo}`);
		        },
		    });
		}



        // 초기화 호출
        initializeLikeButtons();
    });




	  

    
    </script>
</body>
</html>