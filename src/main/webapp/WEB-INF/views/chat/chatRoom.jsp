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
	        <div>
	        	<a href="#" id="leaveChatRoom">채팅방 나가기</a>
	        </div>
	        <div id="chatMessages">
	            <c:forEach var="chatMessage" items="${chatMessages}">
				    <div class="message ${chatMessage.senderNo eq loginMember.userNo ? 'sent' : 'received'}">
				        <div>${chatMessage.messageContent}</div>
				        <div>${chatMessage.senderName }</div>
				        <div class="time">
				            ${chatMessage.sendDate}
				            <c:if test="${lastMessage != null && lastMessage.messageId == chatMessage.messageId}">
				                <span class="read-status">
				                    ${readStatus eq 'Y' ? '읽음' : '읽지 않음'}
				                </span>
				            </c:if>
				        </div>
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
		const roomId = $('#roomId').val();
		const userNo = '${loginMember.userNo}'; // 로그인한 사용자의 번호
		const receiverNo = $('#receiverNo').val();
		let reconnectAttempts = 0;
		const MAX_RECONNECT_ATTEMPTS = 5;

		$(document).ready(function() {
			connectWebSocket();
			scrollToBottom();
			// 채팅 메시지 전송 이벤트
			$('#chatForm').on('submit', function(e) {
				e.preventDefault();
				const messageContent = $('#messageInput').val().trim();
				
				if (!messageContent || !socket || socket.readyState !== WebSocket.OPEN) {
					return;
				}

				const message = {
					type: "chat",
					roomId: roomId,
					senderNo: userNo,
					receiverNo: receiverNo,
					messageContent: messageContent
					// readStatus는 서버에서 처리하므로 제거
				};

				socket.send(JSON.stringify(message));
				$('#messageInput').val('');

				// 송신자의 readStatus를 'Y'로 업데이트
				const readStatusMessage = {
					type: "read",
					roomId: roomId,
					userNo: userNo,
					readStatus: 'Y'
				};
				socket.send(JSON.stringify(readStatusMessage));
			});

			// 메시지 입력 시 Enter 키로 전송
			$('#messageInput').on('keypress', function(e) {
				if (e.which === 13 && !e.shiftKey) {
					e.preventDefault();
					$('#chatForm').submit();
				}
			});

			// 페이지 벗어남 시 'leave' 메시지 전송
			window.onbeforeunload = function() {
				if (socket && socket.readyState === WebSocket.OPEN) {
					const leaveMessage = {
						type: "leave",
						roomId: roomId,
						userNo: userNo
					};
					//console.log("보내는 메시지:", leaveMessage);
					socket.send(JSON.stringify(leaveMessage));
				}
			};

			// 메시지를 읽었을 때 'read' 메시지 전송
			$('#chatMessages').on('scroll', function() {
				const chatMessages = $(this);
				if (chatMessages.scrollTop() + chatMessages.innerHeight() >= chatMessages[0].scrollHeight) {
					sendReadStatus();
				}
			});

            // 채팅방 나가기 버튼 클릭 시
		    $('#leaveChatRoom').on('click', function() {
		        const roomId = $('#roomId').val();
		        $.ajax({
		            url: '/chat/leaveChatRoom.kh',
		            type: 'POST',
		            data: { roomId: roomId },
		            success: function(response) {
		                if (response.success) {
		                    //alert(response.message);
		                    window.location.href = '/chat/chatRoomList.kh';
		                } else {
		                    //alert(response.message);
		                }
		            },
		            error: function() {
		                alert('채팅방 나가기에 실패했습니다.');
		            }
		        });
		    });
		});

		function connectWebSocket() {
			socket = new WebSocket("ws://" + window.location.host + "/web");

			socket.onopen = function() {
				//console.log("WebSocket 연결됨");
				socket.send(JSON.stringify({
					type: "connect",
					userNo: userNo
				}));
			};

			socket.onmessage = function(event) {
				//console.log("메시지 수신:", event.data);
				try {
					const message = JSON.parse(event.data);
					if (message.type === "chat") {
						const chatMessage = JSON.parse(message.data);
						if (chatMessage.roomId == roomId) {
							appendMessage(chatMessage);
							// 메시지를 받은 경우 읽음 상태 업데이트
							if (chatMessage.senderNo != userNo) {
								sendReadStatus();
							}
						}
					} else if (message.type === "roomUpdate") {
						// 채팅방 목록 갱신 로직
						refreshChatRoomList();
					}
				} catch (e) {
					console.error("메시지 처리 오류:", e);
				}
			};

			socket.onclose = function() {
				console.log("WebSocket 연결 종료");
				// 재접속 로직 추가 가능
			};

			socket.onerror = function(error) {
				console.error("WebSocket 오류:", error);
			};
		}

		function appendMessage(message) {
			const isCurrentUser = message.senderNo == userNo;
			const messageDiv = $('<div>')
				.addClass('message')
				.addClass(isCurrentUser ? 'sent' : 'received');
			
			messageDiv.append($('<div>').text(message.messageContent));
			
			// readStatus에 따라 읽음/안읽음 표시
			const readStatusText = isCurrentUser ? '읽음' : (message.readStatus === 'Y' ? '읽음' : '안읽음');
			messageDiv.append($('<div>').addClass('read-status').text(readStatusText));
			
			messageDiv.append($('<div>').addClass('sender-name').text(message.senderName));
			messageDiv.append($('<div>').addClass('time').text(message.sendDate));
			$('#chatMessages').append(messageDiv);
			scrollToBottom();
		}

		function scrollToBottom() {
			const chatMessages = $('#chatMessages');
			chatMessages.scrollTop(chatMessages[0].scrollHeight);
		}

		function sendReadStatus() {
			const readMessage = {
				type: "read",
				roomId: roomId,
				userNo: userNo,
				readStatus: 'Y'
			};
			socket.send(JSON.stringify(readMessage));
		}
    </script>
</body>
</html>