<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
/* 오른쪽 사이드 메뉴 스타일 */
.right-menu {
    position: fixed;
    top: 0;
    right: 0;
    width: 300px; /* 원하는 너비로 조정 */
    height: 100%;
    padding: 10px;
    border-left: 1px solid #ddd; /* 메인 콘텐츠와 구분을 위해 왼쪽에 경계선 추가 */
    background-color: #fff; /* 배경색 설정 */
    overflow-y: auto; /* 내용이 넘칠 경우 스크롤 */
    z-index: 100; /* 다른 요소보다 위에 표시 */
}
/* 간단한 스타일 추가 */
.right-menu {
    width: 300px;
    padding: 10px;
    border: 1px solid #ddd;
}

.re-friend-container {
    margin-top: 20px;
}

.friend-container-title {
    font-weight: bold;
    margin-bottom: 10px;
    text-align: center; /* 가운데 정렬 */
}

.friend-list {
    list-style: none;
    padding: 0;
}

.friend-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 5px 0;
    border-bottom: 1px solid #eee;
}

.friend-item:last-child {
    border-bottom: none;
}

.profile-img {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    object-fit: cover;
    margin-right: 10px;
    border: 1px solid gray;
    
}

.recommendation-info {
    display: flex;
    flex-direction: column;
}

.username {
    font-weight: bold;
}

.pet-info {
    font-size: 0.9em;
    color: #666;
}

.follow-btn, .unfollow-btn {
    display: inline-block; /* 버튼 크기 강제 적용 */
    padding: 5px 10px; /* 내부 여백 */
    width: 80px; /* 버튼 너비 고정 */
    height: 32px; /* 버튼 높이 고정 */
    line-height: 25px; /* 텍스트 수직 정렬 */
    text-align: center; /* 텍스트 수평 정렬 */
    color: white;
    text-decoration: none;
    border: none;
    border-radius: 3px;
    cursor: pointer;
    box-sizing: border-box; /* 패딩과 높이 계산 포함 */
}

.follow-btn {
    background-color: #FF8383;
}

.unfollow-btn {
    background-color: gray;
}

#loadingSpinner {
    display: none;
    text-align: center;
    margin-top: 20px;
}

.friend-item-content {
    display: flex;
    align-items: center;
}
</style>
<link rel ="stylesheet"  href="/resources/default.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
    <aside class="right-menu">
        <div class="re-friend-container">
            <div class="friend-container-title">
                <span>같은 동물 키우는 사람, 여기 있어요!</span>
            </div>
            <ul class="friend-list">
                <c:forEach var="friend" items="${friendList}">
                    <li class="friend-item">
                        <div class="friend-item-content">
                            <img class="profile-img" src="${not empty friend.userImage ? friend.userImage : '/resources/profile_file/default_profile.png'}"alt="프로필 이미지" />
                            <div class="recommendation-info">
                                <span class="username">${friend.userNickname}</span>
                                <span class="pet-info"> 
                                    <c:choose>
                                        <c:when test="${friend.petType == 'DOG'}">강아지</c:when>
                                        <c:when test="${friend.petType == 'CAT'}">고양이</c:when>
                                        <c:otherwise>${friend.petType}</c:otherwise>
                                    </c:choose> - ${friend.breedType}
                                </span>
                            </div>                        
                        </div>
                        <div>
                            <a href="javascript:void(0)" class="follow-toggle ${friend.following ? 'unfollow-btn' : 'follow-btn'}" 
                                    data-userid="${friend.userId}" data-following="${friend.following}">
                                ${friend.following ? '언팔로우' : '팔로우'}
                            </a>
                        </div>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </aside>
    <script>
    $(document).ready(function(){
        // 이벤트 위임
        $(document).on("click", ".follow-toggle", function(){
            var $btn = $(this);
            var userId = $btn.data("userid");       // 상대방 아이디
            var isFollowing = $btn.data("following"); // true/false

            $.ajax({
                url: '/follor/follow',        // 실제 컨트롤러 매핑 URL
                type: 'POST',
                dataType: 'json',
                data: {
                    userId: userId,
                    action: isFollowing ? 'unfollow' : 'follow'
                },
                success: function(response){
                    // 예: response = { success: true/false, isFollowing: true/false, isMutualFollow: true/false, ... }
                    if(response.success){
                        // 이미 팔로우중 -> 언팔 성공
                        if(response.isFollowing){
                            // 맞팔 여부에 따라 텍스트가 다를 수 있음
                            // 예: response.isMutualFollow ? '언팔로우' : '언팔로우'
                            $btn.text('언팔로우').data('following', true).removeClass('follow-btn').addClass('unfollow-btn');
                        } else {
                            // 팔로우 상태 아님 -> 팔로우 버튼으로
                            $btn.text('팔로우').data('following', false).removeClass('unfollow-btn').addClass('follow-btn');
                        }
                        // 1) 만약 Controller 응답에 followerCount / followingCount가 있으면
                        //    아래처럼 DOM을 업데이트
                        if(response.followerCount !== undefined){
                            $(".followerCountSpan").text(response.followerCount);
                        }
                        if(response.followingCount !== undefined){
                            $(".followingCountSpan").text(response.followingCount);
                        }
                    } else {
                        alert("팔로우/언팔로우 처리 실패: " + (response.message || ''));
                    }
                },
                error: function(){
                    console.log("AJAX error!");
                }
            });
        });
    });
</script>
</body>
</html>