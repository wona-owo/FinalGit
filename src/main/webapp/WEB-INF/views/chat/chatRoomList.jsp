<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅방 목록</title>
<link rel ="stylesheet"  href="/resources/default.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
    <main>
	    <ul>
	        <c:forEach var="chatRoom" items="${chatRoomList}">
	            <li>
	                <a href="/chat/chatRoom.kh?roomId=${chatRoom.roomId}">
	                    Chat Room with ${chatRoom.user1No} and ${chatRoom.user2No}
	                </a>
	            </li>
	        </c:forEach>
	    </ul>    
    </main>
</body>
</html>