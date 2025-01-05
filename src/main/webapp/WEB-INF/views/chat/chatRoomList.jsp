<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅방 목록</title>
<link rel ="stylesheet"  href="/resources/default.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
    .read .chat-room-name {
        color: black;
    }
    .unread .chat-room-name {
        color: blue;
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
		        <li id="chatRoom-${chatRoom.roomId}" class="${(chatRoom.user1No == currentUserNo && chatRoom.user1ReadYN == 'N') || (chatRoom.user2No == currentUserNo && chatRoom.user2ReadYN == 'N') ? 'unread' : 'read'}">
		            <a href="/chat/chatRoom.kh?roomId=${chatRoom.roomId}" class="chat-room-name">
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
        $(document).ready(function() {
            // 채팅방 나가기 함수 수정 (AJAX 메소드 호출 수정)
            function leaveChatRoom(roomId) {
			    $.ajax({
			        url: '/chat/leaveChatRoom.kh',
			        type: 'POST',
			        headers: {
			            'Content-Type': 'application/x-www-form-urlencoded'
			        },
			        data: `roomId=${roomId}`
			    })
			    .then(response => response.json())
			    .then(data => {
			        if (data.success) {
			            // 채팅방 목록에서 해당 채팅방 제거
			            const chatRoomElement = document.getElementById(`chatRoom-${roomId}`);
			            if (chatRoomElement) {
			                chatRoomElement.remove();
			            }
			            //alert(data.message);
			        } else {
			            //alert(data.message);
			        }
			    })
			    .catch(error => console.error('Error:', error));
			}

            // WebSocket 연결 설정
            let roomListSocket = new WebSocket("ws://" + window.location.host + "/web");
            
            roomListSocket.onopen = function() {
                roomListSocket.send(JSON.stringify({
                    type: "connect",
                    userNo: '${sessionScope.loginMember.userNo}'
                }));
            };

            roomListSocket.onmessage = function(event) {
                try {
                    const message = JSON.parse(event.data);
                    if (message.type === "roomUpdate") {
                        // AJAX를 통해 최신 채팅방 목록을 불러와 갱신
                        $.ajax({
                            url: '/chat/chatRoomListPartial.kh',
                            method: 'GET',
                            success: function(data) {
                                $('#chatRoomList').html(data);
                            },
                            error: function() {
                                //console.error('채팅방 목록 갱신에 실패했습니다.');
                            }
                        });
                    }
                } catch (e) {
                    console.error("메시지 처리 오류:", e);
                }
            };

            roomListSocket.onclose = function() {
                //console.warn("WebSocket 연결이 종료되었습니다.");
                // 필요 시 재연결 로직 추가
            };

            roomListSocket.onerror = function(error) {
                console.error("WebSocket 오류:", error);
            };
        });
   </script>
</body>
</html>