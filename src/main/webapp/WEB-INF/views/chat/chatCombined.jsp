<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통합 채팅 화면</title>
<link rel="stylesheet" href="/resources/default.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    .container {
        display: flex;
    }
    .chat-room-list {
        width: 30%;
        border-right: 1px solid #ccc;
        overflow-y: auto;
        height: 600px; 
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

    /* 채팅창 영역 스타일 */
    #chatRoomTitle {
        margin: 0 0 10px 0;
    }
    #chatMessages {
        height: 400px;
        overflow-y: scroll;
        border: 1px solid #ccc;
        padding: 10px;
        margin-bottom: 10px;
    }
    #chatMessages .message {
        margin-bottom: 10px;
    }
    #chatMessages .sent {
        text-align: right;
    }
    #chatMessages .received {
        text-align: left;
    }
    .time {
        font-size: 0.8em;
        color: #999;
    }
    .sender-name {
        font-size: 0.9em;
        color: #333;
    }
</style>
</head>
<body>
    <!-- 사이드 메뉴 -->
    <%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>

    <main>
        <div class="container">
            <!-- 좌측: 채팅방 목록 -->
            <div class="chat-room-list">
                <div>
                    <c:choose>
                        <c:when test="${not empty sessionScope.loginMember}">
                            <span>로그인: ${sessionScope.loginMember.userNickname}</span>
                        </c:when>
                        <c:otherwise>
                            <span>로그인 정보 없음</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <ul id="chatRoomList">
                    <c:forEach var="chatRoom" items="${chatRoomList}">
                        <c:set var="isUnread" value="false"/>
                        <c:if test="(${chatRoom.user1No == sessionScope.loginMember.userNo and chatRoom.user1ReadYN == 'N'})
                                or (${chatRoom.user2No == sessionScope.loginMember.userNo and chatRoom.user2ReadYN == 'N'})">
                            <c:set var="isUnread" value="true"/>
                        </c:if>
                        <li id="chatRoom-${chatRoom.roomId}"
                            class="chat-room-item ${isUnread ? 'unread' : 'read'}"
                            onclick="selectChatRoom(${chatRoom.roomId}, 
                                <c:choose>
                                    <c:when test='${chatRoom.user1No == sessionScope.loginMember.userNo}'>
                                        ${chatRoom.user2No}
                                    </c:when>
                                    <c:otherwise>
                                        ${chatRoom.user1No}
                                    </c:otherwise>
                                </c:choose>)">
                            <div class="chat-room-name">
                                <c:choose>
                                    <c:when test="${chatRoom.user1No == sessionScope.loginMember.userNo}">
                                        상대방: ${chatRoom.user2NickName}
                                    </c:when>
                                    <c:otherwise>
                                        상대방: ${chatRoom.user1NickName}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <button onclick="leaveChatRoom(${chatRoom.roomId}); event.stopPropagation();">
                                나가기
                            </button>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- 우측: 채팅창 -->
            <div class="chat-window">
                <h2 id="chatRoomTitle">채팅방이 선택되지 않았습니다.</h2>
                <a href="#" id="leaveChatRoom" style="display: none;">현재 채팅방 나가기</a>

                <div id="chatMessages"></div>

                <form id="chatForm" style="display: none;">
                    <input type="hidden" id="roomId" />
                    <input type="hidden" id="receiverNo" />
                    <input type="text" id="messageInput" placeholder="메시지를 입력하세요" autocomplete="off" />
                    <button type="submit">전송</button>
                </form>
            </div>
        </div>
    </main>

    <script>
        const userNo = '${sessionScope.loginMember.userNo}'; 
        let socket;
        let selectedRoomId = null;
        let selectedReceiverNo = null;

        $(document).ready(function() {
            // WebSocket 연결
            connectWebSocket();

            // 채팅 전송 이벤트
            $('#chatForm').on('submit', function(e) {
                e.preventDefault();
                const messageContent = $('#messageInput').val().trim();
                if (!selectedRoomId || !messageContent || !socket || socket.readyState !== WebSocket.OPEN) {
                    return;
                }

                const msg = {
                    type: "chat",
                    roomId: selectedRoomId,
                    senderNo: userNo,
                    receiverNo: selectedReceiverNo,
                    messageContent: messageContent
                };
                socket.send(JSON.stringify(msg));
                $('#messageInput').val('');

                // 내 메시지 → 바로 읽음 처리
                const readMsg = {
                    type: "read",
                    roomId: selectedRoomId,
                    userNo: userNo
                };
                socket.send(JSON.stringify(readMsg));
            });

            // 페이지 벗어날 때 'leave' 신호 (서버에서 out_time 처리)
            window.onbeforeunload = function() {
                if(socket && socket.readyState === WebSocket.OPEN && selectedRoomId) {
                    const leaveSignal = {
                        type: "leave",
                        roomId: selectedRoomId,
                        userNo: userNo
                    };
                    socket.send(JSON.stringify(leaveSignal));
                }
            };

            // "현재 채팅방 나가기" 버튼
            $('#leaveChatRoom').on('click', function(e) {
                e.preventDefault();
                if(selectedRoomId) {
                    leaveChatRoom(selectedRoomId);
                }
            });
        });

        /* 특정 채팅방 선택 시 */
        function selectChatRoom(roomId, receiverNo) {
            selectedRoomId = roomId;
            selectedReceiverNo = receiverNo;
            $('#roomId').val(roomId);
            $('#receiverNo').val(receiverNo);
            $('#chatRoomTitle').text(`채팅방 ${roomId}`);
            $('#chatForm').show();
            $('#leaveChatRoom').show();

            // 채팅 메시지 불러오기 (JSON)
            loadChatMessages(roomId);
        }

        /* 채팅 메시지 로드 (Ajax) - Controller에서 JSON 받기 */
        function loadChatMessages(roomId) {
            $.ajax({
                url: '/chat/chatRoomData.kh',
                type: 'GET',
                data: { roomId: roomId },
                success: function(response) {
                    if(response.success) {
                        const chatMessages = response.chatMessages;
                        selectedReceiverNo = response.receiverNo; // 갱신

                        renderChatMessages(chatMessages);
                        // 현재 방 읽음 상태
                        sendReadStatus(roomId, userNo);
                    } else {
                        alert(response.message || '채팅방 정보를 불러오지 못했습니다.');
                    }
                },
                error: function() {
                    alert('채팅 메시지를 불러오는 중 오류가 발생했습니다.');
                }
            });
        }

        /* 채팅창에 메시지 렌더링 */
        function renderChatMessages(chatMessages) {
            $('#chatMessages').empty();
            chatMessages.forEach(msg => {
                appendMessage(msg);
            });
            scrollToBottom();
        }

        /* 채팅방 나가기 */
        function leaveChatRoom(roomId) {
            $.ajax({
                url: '/chat/leaveChatRoom.kh',
                type: 'POST',
                data: { roomId: roomId },
                success: function(res) {
                    if(res.success) {
                        // 목록에서 제거
                        $('#chatRoom-' + roomId).remove();
                        // 만약 현재 열려있는 채팅방이면 초기화
                        if(selectedRoomId == roomId) {
                            selectedRoomId = null;
                            selectedReceiverNo = null;
                            $('#chatRoomTitle').text("채팅방이 선택되지 않았습니다.");
                            $('#chatForm').hide();
                            $('#leaveChatRoom').hide();
                            $('#chatMessages').empty();
                        }
                    } else {
                        alert(res.message || '채팅방 나가기에 실패했습니다.');
                    }
                },
                error: function() {
                    alert('채팅방 나가기에 실패했습니다.');
                }
            });
        }

        /* WebSocket 연결 */
        function connectWebSocket() {
            socket = new WebSocket("ws://" + window.location.host + "/web");

            socket.onopen = function() {
                // 연결 성공 시, 현재 사용자 정보 전송
                const connectMsg = {
                    type: "connect",
                    userNo: userNo
                };
                socket.send(JSON.stringify(connectMsg));
            };

            socket.onmessage = function(event) {
                try {
                    const data = JSON.parse(event.data);
                    if(data.type === "chat") {
                        // 채팅 메시지
                        const chatMessage = JSON.parse(data.data);
                        if(chatMessage.roomId == selectedRoomId) {
                            // 현재 방이면 메시지 표시
                            appendMessage(chatMessage);
                            scrollToBottom();
                            if(chatMessage.senderNo != userNo) {
                                // 내가 아닌 상대 메시지 => 읽음 처리
                                sendReadStatus(chatMessage.roomId, userNo);
                            }
                        } else {
                            // 다른 방 => 목록에서 unread 표시
                            $('#chatRoom-' + chatMessage.roomId).removeClass('read').addClass('unread');
                        }
                    } else if(data.type === "roomUpdate") {
                        // 새로고침 (예: 상대가 재참여)
                        refreshChatRoomList();
                    }
                } catch(e) {
                    console.error("메시지 처리 오류: ", e);
                }
            };

            socket.onclose = function() {
                //console.log("WebSocket 연결 종료");
            };

            socket.onerror = function(error) {
                console.error("WebSocket 오류:", error);
            };
        }

        /* 메시지 화면에 추가 */
        function appendMessage(message) {
            const isCurrentUser = (message.senderNo == userNo);
            const $msgDiv = $('<div>')
                .addClass('message')
                .addClass(isCurrentUser ? 'sent' : 'received');

            $msgDiv.append($('<div>').text(message.messageContent));
            $msgDiv.append($('<div>').addClass('sender-name').text(message.senderName));
            $msgDiv.append($('<div>').addClass('time').text(message.sendDate));

            $('#chatMessages').append($msgDiv);
        }

        /* 읽음 상태 전송 */
        function sendReadStatus(roomId, userNo) {
            if(!roomId) return;
            const readMsg = {
                type: "read",
                roomId: roomId,
                userNo: userNo
            };
            socket.send(JSON.stringify(readMsg));
        }

        /* 목록 부분 새로고침 (상대 재참여 등) */
        function refreshChatRoomList() {
            $.ajax({
                url: '/chat/chatRoomListPartial.kh',
                type: 'GET',
                success: function(partialView) {
                    $('#chatRoomList').html(partialView);
                },
                error: function() {
                    console.error("채팅방 목록 갱신 실패");
                }
            });
        }

        /* 메시지 목록 스크롤바를 맨 아래로 */
        function scrollToBottom() {
            const cm = $('#chatMessages');
            cm.scrollTop(cm[0].scrollHeight);
        }
    </script>
</body>
</html>