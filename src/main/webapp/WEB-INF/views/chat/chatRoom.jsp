<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅방</title>
<link rel="stylesheet" href="/resources/default.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    #chatMessages {
        height: 200px; /* 5개의 메시지를 보여줄 수 있는 높이로 설정 */
        overflow-y: scroll; /* 스크롤 가능하도록 설정 */
        border: 1px solid #ccc;
        padding: 10px;
    }
    #chatMessages div {
        margin-bottom: 10px;
    }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
<main>
    <div class="chat-container">
        <div class="chat-header">
            <h2>채팅방 ${param.roomId}</h2>
        </div>
        <div id="chatMessages">
            <c:forEach var="chatMessage" items="${chatMessages}">
                <div class="message ${chatMessage.senderNo eq loginMember.userNo ? 'sent' : 'received'}">
                    <div>${chatMessage.messageContent}</div>
                    <div class="time">${chatMessage.sendDate}</div>
                </div>
            </c:forEach>
        </div>
        <form id="chatForm">
            <input type="hidden" id="roomId" value="${param.roomId}">
            <input type="hidden" id="receiverNo" value="${receiverNo}">
            <input type="text" id="messageInput" placeholder="메시지를 입력하세요" autocomplete="off">
            <button type="submit">전송</button>
        </form>
    </div>
</main>
<script>
let socket;
let reconnectAttempts = 0;
const MAX_RECONNECT_ATTEMPTS = 5;

function connectWebSocket() {
    console.log("WebSocket 연결 시도...");
    socket = new WebSocket("ws://" + window.location.host + "/web");

    socket.onopen = function() {
        console.log("WebSocket 연결됨");
        reconnectAttempts = 0;
        socket.send(JSON.stringify({
            type: "connect",
            userNo: '${loginMember.userNo}'
        }));
    };

    socket.onmessage = function(event) {
        console.log("메시지 수신:", event.data);
        try {
            const message = JSON.parse(event.data);
            if (message.type === "chat") {
                const chatMessage = JSON.parse(message.data);
                if (chatMessage.roomId == $('#roomId').val()) {
                    appendMessage(chatMessage);
                }
            }
        } catch (e) {
            console.error("메시지 처리 오류:", e);
        }
    };

    socket.onclose = function() {
        console.log("WebSocket 연결 종료");
        if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
            setTimeout(connectWebSocket, 2000);
            reconnectAttempts++;
        }
    };

    socket.onerror = function(error) {
        console.error("WebSocket 오류:", error);
    };
}

function appendMessage(message) {
    const isCurrentUser = message.senderNo == '${loginMember.userNo}';
    const messageDiv = $('<div>')
        .addClass('message')
        .addClass(isCurrentUser ? 'sent' : 'received');

    messageDiv.append($('<div>').text(message.messageContent));
    messageDiv.append($('<div>').addClass('time').text(message.sendDate));
    
    $('#chatMessages').append(messageDiv);
    scrollToBottom();
}

function scrollToBottom() {
    const chatMessages = $('#chatMessages');
    chatMessages.scrollTop(chatMessages[0].scrollHeight);
}

$(document).ready(function() {
    connectWebSocket();
    scrollToBottom();

    $('#chatForm').on('submit', function(e) {
        e.preventDefault();
        const messageContent = $('#messageInput').val().trim();
        
        if (!messageContent || !socket || socket.readyState !== WebSocket.OPEN) {
            return;
        }

        const message = {
            type: "chat",
            roomId: $('#roomId').val(),
            senderNo: '${loginMember.userNo}',
            receiverNo: $('#receiverNo').val(),
            messageContent: messageContent
        };

        socket.send(JSON.stringify(message));
        $('#messageInput').val('');
    });

    $('#messageInput').on('keypress', function(e) {
        if (e.which === 13 && !e.shiftKey) {
            e.preventDefault();
            $('#chatForm').submit();
        }
    });
});
    </script>
</body>
</html>