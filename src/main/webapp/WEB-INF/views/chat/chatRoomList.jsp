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
	    <ul>
	     
	        <c:forEach var="chatRoom" items="${chatRoomList}">
	            <li class="">
	                <a href="/chat/chatRoom.kh?roomId=${chatRoom.roomId}">
	                   <%-- 현재 사용자가 user1인 경우 user2NickName 표시 --%>
                        <c:choose>
                            <c:when test="${chatRoom.user1No == currentUserNo}">
                                ${chatRoom.user2NickName}
                            </c:when>
                            <%-- 그렇지 않은 경우 user1NickName 표시 --%>
                            <c:otherwise>
                                ${chatRoom.user1NickName}
                            </c:otherwise>
                        </c:choose>
	                </a>
	            </li>
	        </c:forEach>
	    </ul>    
    </main>
</body>
</html>