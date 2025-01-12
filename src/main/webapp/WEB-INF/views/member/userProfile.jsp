<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet" href="/resources/default.css">
<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
.followCount, .followingCount{
    cursor: pointer;
}
#follow-text{
    margin: 0 0 10px 20px;
}

.follow-event, .message-btn {
    width: 80px; /* 버튼의 고정 너비 */
    height: 30px; /* 고정 높이 */
    display: inline-block; /* 크기 고정을 위한 속성 */
    text-align: center; /* 텍스트 가운데 정렬 */
    line-height: 30px; /* 텍스트가 세로 가운데에 위치하도록 설정 */
    padding: 0; /* 패딩 초기화 (필요 시 추가) */
    box-sizing: border-box; /* 패딩과 보더를 포함하여 크기 계산 */
}

.message-btn {
    border-radius: 5px; 
    color: black;
    background-color: #ced4da;
    text-decoration: none;
}

.user-follow-btn {
    color: white;
    background-color: #FF8383;
    border-radius: 5px;
    text-decoration: none;
}

.user-unfollow-btn {
    color: black;
    background-color: #ced4da;
    border-radius: 5px;
    text-decoration: none;
}

.user-follow-btn:hover, .user-unfollow-btn:hover, .message-btn:hover {
    opacity: 0.6;
}

.bottom-line{
    max-width:850px;
    padding:25px;
    border-bottom: 0.5px solid black;
}

/* 팔로워 및 팔로잉 모달 내부 콘텐츠 스타일 */
.user-list-item{
    text-decoration: none;
    width: 100%;
    height: 60px; /* 높이 60px */
    display: flex;
    align-items: center;
    padding: 0 10px; /* 좌우 패딩 조정 */
    border-bottom: 1px solid #ddd;
    box-sizing: border-box; /* 패딩과 보더를 포함하여 크기 계산 */
}

.user-alink{
    width: 100%;
    height: 100%;
    text-decoration: none;
    color: inherit; /* 링크의 기본 색상을 상속받도록 설정 */
}

.user-list{
    list-style: none; /* 리스트 스타일 제거 */
    padding: 0; /* 패딩 제거 */
    margin: 0; /* 마진 제거 */
}

.followUser-container{
    display: flex;
    align-items: center;
    width: 100%;
    margin-top: 5px;
}

.user-info {
    display: flex;
    flex-direction: column;
    justify-content: center; /* 세로 가운데 정렬 */
    height: 100%;
}

.userNickname {
    font-weight: bold;
    font-size: 16px; /* 글씨 크기 조정 */
}

.userId {
    color: #555;
    font-size: 14px; /* 글씨 크기 조정 */
}

/* 이미지 스타일 */
.followUser-container img {
    width: 44px; /* 이미지 너비 조정 */
    height: 44px; /* 이미지 높이 조정 */
    border-radius: 50%;
    object-fit: cover;
    margin-right: 10px;
    border: 1px solid gray;
}

.followers-modal, .followings-modal {
    display: none; /* 초기에는 숨김 */
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.4); /* 반투명 배경 */
}

.modal-content {
    background-color: #fefefe;
    margin: 10% auto; /* 화면 상단에서 약간 내려온 위치 중앙 */
    padding: 20px;
    border: 1px solid #888;
    width: 440px; /* 너비 440px */
    height: 440px; /* 높이 440px */
    border-radius: 8px;
}

.follow-modal-header{
	display: flex;
	width: 100%;
}
.header-font{
	width: 90%;
}
.user-follow-close {
 	flex: 0 0 auto; /* 고정된 너비 */
    color: #aaa;
    width: 10%;
    font-size: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    cursor: pointer;
}

.followings-ultag,
.followers-ultag{
	width: 100%;
	height: 380px;
	overflow-y: auto; /* 내용이 많을 경우 스크롤 */
}
.user-follow-close:hover,
.user-follow-close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}
#followersLoading, #followingsLoading {
    text-align: center;
    padding: 10px;
    font-size: 14px;
    color: #777;
}
</style>
</head>
<body>
	<%--사이드 메뉴--%>
	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
	<%--피드 영역--%>
	<main id="myfeed-main">
		<div class="profile" id="myfeed-profile">
			<div class="profile-frame" id="myfeed-frame">
				<img class="profileImage"
					src="${not empty member.userImage ? member.userImage : '/resources/profile_file/default_profile.png'}"
					alt="프로필 이미지" />
			</div>
			<div id="profile-text">
				<span id="myId">${member.userId}</span> <br> <span id="myNick">${member.userNickname}</span>
				<div id="follow-text">
					<span class="followCount">팔로워 <span class="followerCountSpan">${followerCount}</span></span>
					<span class="followingCount">팔로잉 <span class="followingCountSpan">${followingCount}</span></span>
				</div>
				<div class="user-profile-btn">
					<c:choose>
						<%-- 서로 팔로우 상태 (맞팔) --%>
						<c:when test="${myFollowCount > 0 && theyFollowCount > 0}">
							<a href="javascript:void(0)"
								class="follow-event user-unfollow-btn"
								data-userid="${member.userId}" data-following="true"
								data-chkfollow="true"> 언팔로우 </a>
							<a href="/chat/startChat.kh?userId=${member.userId}"
								class="message-btn" data-userid="${member.userId}">메시지</a>
						</c:when>
	
						<%-- 내가 상대만 팔로우 중 --%>
						<c:when test="${myFollowCount > 0 && theyFollowCount == 0}">
							<a href="javascript:void(0)"
								class="follow-event user-unfollow-btn"
								data-userid="${member.userId}" data-following="true"
								data-chkfollow="false"> 언팔로우 </a>
							<a href="/chat/startChat.kh?userId=${member.userId}"
								class="message-btn" data-userid="${member.userId}"
								style="display: none;">메시지</a>
						</c:when>
	
						<%-- 상대가 나만 팔로우 중 --%>
						<c:when test="${myFollowCount == 0 && theyFollowCount > 0}">
							<a href="javascript:void(0)" class="follow-event user-follow-btn"
								data-userid="${member.userId}" data-following="false"
								data-chkfollow="true"> 맞팔로우 </a>
							<a href="/chat/startChat.kh?userId=${member.userId}"
								class="message-btn" data-userid="${member.userId}"
								style="display: none;">메시지</a>
						</c:when>
	
						<%-- 둘 다 팔로우 안 함 --%>
						<c:otherwise>
							<a href="javascript:void(0)" class="follow-event user-follow-btn"
								data-userid="${member.userId}" data-following="false"
								data-chkfollow="false"> 팔로우 </a>
							<a href="/chat/startChat.kh?userId=${member.userId}"
								class="message-btn" data-userid="${member.userId}"
								style="display: none;">메시지</a>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
		
		<div class="bottom-line"></div>
		<div class="post-container">
	   		<c:forEach var="post" items="${post}">
	   			<div class="post-grid" data-id="${post.postNo}">
	   				<img class="feed-thumbnail" src="/resources/post_file/${post.postFileName}" alt="thumbnail">
	   				<p class="hidden-post-content" style="display: none;">${post.postContent}</p>			
	   			</div>
	   		</c:forEach>
	    </div>
	    
	    <%--포스트 modal--%>
	    <%@ include file="/WEB-INF/views/member/postModal.jsp" %>
	    
	     
        <div id="followersModal" class="followers-modal follow-modal">
            <div class="modal-content">
            	<div class="follow-modal-header">
            		<div class="header-font">
		                <h2>팔로워 목록</h2>
            		</div>
	                <span class="user-follow-close">&times;</span>
            	</div>
            	<div class="followers-ultag" >
	                <ul class="user-list" id="followersList">
	                </ul>
            	</div>
                <div id="followersLoading" style="display: none; text-align: center;">
                     <i class="fas fa-spinner fa-spin"></i> 로딩 중...
                </div>
            </div>
        </div>

        <div id="followingsModal" class="followings-modal follow-modal">
            <div class="modal-content">
                <div class="follow-modal-header">
                	<div class="header-font">
		                <h2>팔로잉 목록</h2>
                	</div>
	                <span class="user-follow-close">&times;</span>
            	</div>
            	<div class="followings-ultag">
	                <ul class="user-list" id="followingsList">
	                </ul>
            	</div>
                <div id="followingsLoading" style="display: none; text-align: center;">
                     <i class="fas fa-spinner fa-spin"></i> 로딩 중...
                </div>
            </div>
        </div> 
	</main>
	<%@ include file="/WEB-INF/views/member/rightSideMenu.jsp" %>
	
	<script>
	$(document).ready(function() {
		var userNo = ${member.userNo};
		var followersPage = 1;
	    var followersLimit = 10;
	    var followersEnd = false;
	    var followersIsLoading = false;

	    var followingsPage = 1;
	    var followingsLimit = 10;
	    var followingsEnd = false;
	    var followingsIsLoading = false;
	
        // 팔로워 모달 열기
        $('#follow-text .followCount').on('click', function() {
            $('#followersModal').fadeIn();
            followersPage = 1;
            followersEnd = false;
            $('#followersList').empty();
            loadFollowers(followersPage);
        });

        // 팔로잉 모달 열기
        $('#follow-text .followingCount').on('click', function() {
            $('#followingsModal').fadeIn();
            followingsPage = 1;
            followingsEnd = false;
            $('#followingsList').empty();
            loadFollowings(followingsPage);
        });

        // 모달 닫기
        $('.user-follow-close').on('click', function() {
            $(this).closest('.follow-modal').fadeOut();
        });

        // 클릭 외부 영역 닫기
        $(window).on('click', function(event) {
            if ($(event.target).hasClass('followers-modal') || $(event.target).hasClass('followings-modal')) {
                $('.follow-modal').fadeOut();
            }
        });
     	// 디바운스 함수
        function debounce(func, delay) {
            var inDebounce;
            return function() {
                var context = this;
                var args = arguments;
                clearTimeout(inDebounce);
                inDebounce = setTimeout(function() {
                    func.apply(context, args);
                }, delay);
            };
        }
     	// 팔로워 무한 스크롤
        function loadFollowers(page) {
            if (followersEnd || followersIsLoading) return;
            followersIsLoading = true;
            $('#followersLoading').show();
            $.ajax({
                url: '/follow/getFollowers',
                type: 'GET',
                data: {
                    userNo: userNo,
                    page: page,
                    limit: followersLimit
                },
                success: function(response) {
                    if (response.success) {
                        var followers = response.followers;
                        if (followers.length < followersLimit) {
                            followersEnd = true;
                        }
                        followers.forEach(function(follower) {
                            var item = '<li class="user-list-item">';
                                item += '<a class="user-alink" href="/member/profile.kh?userNo=' + follower.userNo + '" data-type="Post">';
                                item += '<div class="followUser-container">';
                                item += '<img src="' + (follower.userImage ? follower.userImage : '/resources/profile_file/default_profile.png') + '" alt="프로필 이미지">';
                                item += '<div class="user-info">';
                                item += '<span class="userNickname">' + follower.userNickname + '</span>';
                                item += '<span class="userId">' + follower.userId + '</span>';
                                item += '</div>';
                                item += '</div>';
                                item += '</a>';
                                item += '</li>';
                            $('#followersList').append(item);
                        });
                        followersPage++;
                    } else {
                    	console.log('팔로워 목록을 불러오는데 실패했습니다.');
                    }
                },
                error: function() {
                	console.log('서버 오류가 발생했습니다.');
                },
                complete: function() {
                    $('#followersLoading').hide();
                    followersIsLoading = false;
                }
            });
        }

     	// 팔로잉 무한 스크롤
        function loadFollowings(page) {
            if (followingsEnd || followingsIsLoading) return;
            followingsIsLoading = true;
            $('#followingsLoading').show();
            $.ajax({
                url: '/follow/getFollowings',
                type: 'GET',
                data: {
                    userNo: userNo,
                    page: page,
                    limit: followingsLimit
                },
                success: function(response) {
                    if (response.success) {
                        var followings = response.followings;
                        if (followings.length < followingsLimit) {
                            followingsEnd = true;
                        }
                        followings.forEach(function(following) {
                            var item = '<li class="user-list-item">';
                                item += '<a class="user-alink" href="/member/profile.kh?userNo=' + following.userNo + '" data-type="Post">';
                                item += '<div class="followUser-container">';
                                item += '<img src="' + (following.userImage ? following.userImage : '/resources/profile_file/default_profile.png') + '" alt="프로필 이미지">';
                                item += '<div class="user-info">';
                                item += '<span class="userNickname">' + following.userNickname + '</span>';
                                item += '<span class="userId">' + following.userId + '</span>';
                                item += '</div>';
                                item += '</div>';
                                item += '</a>';
                                item += '</li>';
                            $('#followingsList').append(item);
                        });
                        followingsPage++;
                    } else {
                    	console.log('팔로잉 목록을 불러오는데 실패했습니다.');
                    }
                },
                error: function() {
                    console.log('서버 오류가 발생했습니다.');
                },
                complete: function() {
                    $('#followingsLoading').hide();
                    followingsIsLoading = false;
                }
            });
        }

        // 팔로워 모달의 .modal-content에 스크롤 이벤트 바인딩
        $('.followers-ultag').on('scroll', debounce(function() {
            var scrollHeight = $(this)[0].scrollHeight;
            var scrollTop = $(this).scrollTop();
            var containerHeight = $(this).height();
            if (scrollTop + containerHeight >= scrollHeight - 50) {
            	loadFollowers(followersPage);
            }
        }, 200));

        // 팔로잉 모달의 .modal-content에 스크롤 이벤트 바인딩
        $('.followings-ultag').on('scroll', debounce(function() {
            var scrollHeight = $(this)[0].scrollHeight;
            var scrollTop = $(this).scrollTop();
            var containerHeight = $(this).height();
            if (scrollTop + containerHeight >= scrollHeight - 50) {
                loadFollowings(followingsPage);
            }
        },200));
		
	    // 메시지 버튼 클릭 이벤트
	    $(".message-btn").on("click", function(event) {
		    event.preventDefault(); // 기본 링크 동작 방지
		    var targetUserId = $(this).data("userid");
		    $.ajax({
		        url: '/chat/startChat.kh',
		        type: 'GET',
		        data: { userId: targetUserId },
		        success: function(response) {
		            if (response.success) {
		                window.location.href = '/chat/chatRoom.kh?roomId=' + response.roomId;
		            } else {
		            	console.log('채팅방 생성에 실패했습니다: ' + (response.message || ''));
		            }
		        },
		        error: function() {
		        	console.log('서버 오류가 발생했습니다.');
		        }
		    });
		});
		
	    // 팔로우/언팔로우 버튼 클릭 이벤트
	    $(".follow-event").on("click", function() {
	        var $btn = $(this);
	        var userId = $btn.data("userid");
	        var isFollowing = $btn.data("following");
	        var checkFollow = $btn.data("chkfollow");

	        $.ajax({
	            url: '/follow/follow.kh', // 실제 컨트롤러 매핑 URL
	            type: 'POST',
	            dataType: 'json',
	            data: {
	                userId: userId,
	                action: isFollowing ? 'unfollow' : 'follow' // 팔로우/언팔로우 액션
	            },
	            success: function(response) {
	                if (response.success) {
	                    // 버튼 상태 업데이트
	                    if (response.isFollowing) {
	                    	if(checkFollow){
	                    		$btn.text('언팔로우').data('chkfollow', true).data('following', true).removeClass('user-follow-btn').addClass('user-unfollow-btn');
	                    		$(".message-btn").show();
	                    	}else{                    		
		                        $btn.text('언팔로우').data('chkfollow', false).data('following', true).removeClass('user-follow-btn').addClass('user-unfollow-btn');
		                        $(".message-btn").hide();
	                    	}
	                    } else {
	                    	if(checkFollow){
	                    		$btn.text('맞팔로우').data('chkfollow', true).data('following', false).removeClass('user-unfollow-btn').addClass('user-follow-btn');
	                    		$(".message-btn").hide();
	                    	}else{	                    		
		                        $btn.text('팔로우').data('chkfollow', false).data('following', false).removeClass('user-unfollow-btn').addClass('user-follow-btn');
		                        $(".message-btn").hide();
	                    	}
	                    }
	                    // 카운트 업데이트
	                    if (response.followerCount !== undefined) {
	                        $(".followerCountSpan").text(response.followerCount);
	                    }
	                    if (response.followingCount !== undefined) {
	                        $(".followingCountSpan").text(response.followingCount);
	                    }
	                } else {
	                	console.log("팔로우/언팔로우 처리 실패: " + (response.message || ''));
	                }
	            },
	            error: function() {
	                console.log("AJAX error!");
	            }
	        });
	    });
	});
	</script>
</body>
</html>