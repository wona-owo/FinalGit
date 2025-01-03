<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅방 목록</title>
<link rel ="stylesheet"  href="/resources/default.css">
<style>
    .container {
        display: flex;
    }
    .chat-room-list {
        width: 30%;
        border-right: 1px solid #ccc;
        overflow-y: auto;
    }
    .chat-window {
        width: 70%;
        padding: 10px;
    }
    .chat-room-item {
        padding: 10px;
        border-bottom: 1px solid #eee;
        cursor: pointer;
    }
    .chat-room-item:hover {
        background-color: #f9f9f9;
    }
</style>
</head>
<body>
    <%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
    <main>
    	<c:set var="currentUserNo" value="${sessionScope.loginMember.userNo}" />
    	<div>
    		<span>${sessionScope.loginMember.userNickname}</span>
    	</div>
	    <ul id="chatRoomList">
	        <c:forEach var="chatRoom" items="${chatRoomList}">
	            <li id="chatRoom-${chatRoom.roomId}">
	                <a href="/chat/chatRoom.kh?roomId=${chatRoom.roomId}">
	                    <c:choose>
	                        <c:when test="${chatRoom.user1No == currentUserNo}">
	                            ${chatRoom.user2NickName}
	                        </c:when>
	                        <c:otherwise>
	                            ${chatRoom.user1NickName}
	                        </c:otherwise>
	                    </c:choose>
	                </a>
	                <button onclick="leaveChatRoom(${chatRoom.roomId})">나가기</button>
	            </li>
	        </c:forEach>
    	</ul>
    </main>
    
     <script>
	    function leaveChatRoom(roomId) {
	        .ajax(`/chat/leaveChatRoom.kh`, {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/x-www-form-urlencoded'
	            },
	            body: `roomId=${roomId}`
	        })
	        .then(response => response.json())
	        .then(data => {
	            if (data.success) {
	                // 채팅방 목록에서 해당 채팅방 제거
	                const chatRoomElement = document.getElementById(`chatRoom-${roomId}`);
	                if (chatRoomElement) {
	                    chatRoomElement.remove();
	                }
	                alert(data.message);
	            } else {
	                alert(data.message);
	            }
	        })
	        .catch(error => console.error('Error:', error));
    }
    </script>
</body>
</html>