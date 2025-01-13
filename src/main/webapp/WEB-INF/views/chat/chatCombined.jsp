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
    main.msg-main {
        display: flex;
        margin-top: 0;
        margin-left: 302px;
        padding: 0;
    }
    .chat-header{
    	padding-top: 28px;
    	padding-bottom: 10px;
    	padding-left: 10px;
    	border-bottom: 1px solid gray;
    }
    
    .msg-container {
        display: flex;
        height: 100vh; /* 브라우저 전체 높이 */
        width: 100%;
    }
	.msg-header-title{
		font-size: 18px;
	}
    /* 채팅방 목록 */
    .chat-room-list {
        width: 320px;
        margin: 0;
        padding: 0;
        overflow-y: auto;
        border-right: 1px solid #ddd;
        background-color: #fff;
    }
    .chat-room-list > div {
        font-weight: bold;
        font-size: 18px;
    }
    #chatRoomList {
        padding: 0;
        margin: 0;
    }
    .chat-room-item {
        display: flex;
        align-items: center;
        border-bottom: 1px solid #f0f0f0;
        cursor: pointer;
    }
    .chat-room-item:hover {
        background-color: #fafafa;
    }
    .chat-room-name {
        flex: 1;
        color: #555;
    }
    .msg-list-Container {
        display: flex;
        align-items: center;
        height: 60px;
    }
    .msg-user-NickName {
        margin-left: 10px;
        font-size: 15px;
        color: #333;
    }
    .read .chat-room-name {
        font-weight: normal;
    }
    .unread .chat-room-name {
        color: #ff6600; /* 새 메시지가 있을 때 주황색 표시 */
        font-weight: bold;
    }

    /* 프로필 이미지 */
    .user-profileImage {
    	margin-left: 10px;
        width: 45px;
        height: 45px;
        border-radius: 50%;
        background-color: gray;
        overflow: hidden;
        flex-shrink: 0;
    }
    .profile-images {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
        display: block;
    }

    /* 채팅창(오른쪽) */
    .chat-window {
        flex: 1;
        display: flex;
        flex-direction: column;
        padding: 20px;
    }
    /* 뒤로가기/나가기 링크 */
    #exitChatScreen,
    #leaveChatRoom {
        margin-bottom: 10px;
        display: none; /* 처음엔 숨김 */
        cursor: pointer;
        color: #777;
        font-size: 14px;
        text-decoration: underline;
    }

    /* 채팅 메시지 영역 */
    #chatMessages {
        flex: 1;
        overflow-y: auto;
        border: 1px solid #ccc;
        padding: 10px;
        margin-bottom: 10px;
        background-color: #fffbee; /* 연한 노란 배경 */
        display: none; /* 채팅방 선택 전에는 숨김 */
    }
    .message {
        margin-bottom: 12px;
        max-width: 60%;
    }
    /* sent, received 정렬 */
    .sent {
        margin-left: auto; /* 오른쪽 정렬 */
        text-align: right;
    }
    .received {
        margin-right: auto; /* 왼쪽 정렬 */
        text-align: left;
    }
    /* 말풍선 모양 */
    .sent .bubble {
        background-color: #f1f1f1;
        color: #333;
        padding: 8px 12px;
        border-radius: 16px;
        display: inline-block;
        text-align: left;
    }
    .received .bubble {
        background-color: #ffa500; /* 오렌지색 */
        color: #fff;
        padding: 8px 12px;
        border-radius: 16px;
        display: inline-block;
        text-align: left;
    }
    /* 메시지 하단 정보 */
    .sender-name {
        margin-top: 4px;
        font-size: 0.85em;
        color: #444;
    }
    .time {
        margin-top: 2px;
        font-size: 0.75em;
        color: #999;
    }

    /* 채팅 입력 폼 */
    #chatForm {
        display: none; /* 채팅방 선택 전에는 숨김 */
    }
    #chatForm input[type="text"] {
    	width: 600px;
        flex: 1;
        height: 28px;
        font-size: 16px;
        padding: 8px;
        margin-right: 5px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }
    #chatForm button {
        padding: 8px 16px;
        background-color: #ff7b00;
        color: #fff;
        font-size: 16px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    #chatForm button:hover {
        background-color: #ff9500;
    }
    .received-message-container {
	    display: flex;
	    align-items: center;  /* 프로필과 텍스트 수직 가운데 정렬 */
	}
	
	/* 프로필 이미지 영역 */
	.profile-image-container {
	    width: 40px;
	    height: 40px;
	    border-radius: 50%;
	    overflow: hidden;
	    flex-shrink: 0;      /* 이미지는 크기 줄어들지 않도록 */
	}
	
	/* 텍스트 전체(닉네임, 말풍선, 시간)를 세로로 쌓되, 
	   전체는 프로필 옆(수평)에 놓이도록 */
	.text-container {
	    display: flex;
	    flex-direction: column;
	    margin-left: 8px;    /* 프로필과 텍스트 사이 간격 */
	    align-items: flex-start;
	}
	
	/* 닉네임 스타일 */
	.sender-name {
	    font-size: 0.85em;
	    color: #444;
	    font-weight: bold;
	    margin-bottom: 4px;
	}
	#chatForm .input-group {
    	display: flex;
    	width: 100%;
    	height: 45px;
	}
	
	/* 채팅창 상단 헤더 */
.chat-window-header {
    display: flex;
    justify-content: space-between; /* 양쪽 끝으로 배치 */
    align-items: center;
    margin-bottom: 10px;
}

/* 왼쪽 정렬 버튼 */
.chat-window-header .left-actions {
    display: flex;
    align-items: center;
}

/* 오른쪽 정렬 버튼 (필요 시 추가) */
.chat-window-header .right-actions {
    display: flex;
    align-items: center;
}

/* 버튼 간 간격 조정 */
.chat-window-header a {
    margin-right: 10px;
    cursor: pointer;
    color: #777;
}

.chat-window-header a:hover {
    color: #000;
}
	
</style>
</head>
<body>
    <!-- 사이드 메뉴 -->
    <%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>

    <main class="msg-main">
        <div class="msg-container">
            <div class="chat-room-list">
                <div class="chat-header">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loginMember}">
                            <span class="msg-header-title">메시지</span>
                            <div class="bottom-line"></div>
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
                                    	<div class="msg-list-Container">
                                 			<div class="user-profileImage">
                                 				<img class="profile-images" src="${not empty chatRoom.user2Image ? chatRoom.user2Image : '/resources/profile_file/default_profile.png'}" alt="프로필 사진">
                                 			</div>
                                    		<span class="msg-user-NickName">${chatRoom.user2NickName}</span>
                                    	</div>
                                    </c:when>
                                    <c:otherwise>
                                   		 <div class="msg-list-Container">
                                 			<div class="user-profileImage">
                                 				<img class="profile-images" src="${not empty chatRoom.user1Image ? chatRoom.user1Image : '/resources/profile_file/default_profile.png'}" alt="프로필 사진">
                                 			</div>
                                    		<span class="msg-user-NickName">${chatRoom.user1NickName}</span>
                                    	</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <div class="chat-window">
                <div class="chat-window-header">
                	<div class="left-actions">
		                <a href="#" id="exitChatScreen" onclick="exitChatScreen()">
		                	<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="gray" class="bi bi-chevron-left" viewBox="0 0 16 16">
							  <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
							</svg>
		                </a>
	                </div>
	                <div class="right-actions">
		                <a href="#" id="leaveChatRoom">
		                	<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="gray" class="bi bi-box-arrow-left" viewBox="0 0 16 16">
		  						<path fill-rule="evenodd" d="M6 12.5a.5.5 0 0 0 .5.5h8a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-8a.5.5 0 0 0-.5.5v2a.5.5 0 0 1-1 0v-2A1.5 1.5 0 0 1 6.5 2h8A1.5 1.5 0 0 1 16 3.5v9a1.5 1.5 0 0 1-1.5 1.5h-8A1.5 1.5 0 0 1 5 12.5v-2a.5.5 0 0 1 1 0z"/>
		  						<path fill-rule="evenodd" d="M.146 8.354a.5.5 0 0 1 0-.708l3-3a.5.5 0 1 1 .708.708L1.707 7.5H10.5a.5.5 0 0 1 0 1H1.707l2.147 2.146a.5.5 0 0 1-.708.708z"/>
							</svg>
						</a>
					</div>
				</div>
                <div id="chatMessages" ></div>

                <form id="chatForm" >
                    <input type="hidden" id="roomId" />
                    <input type="hidden" id="receiverNo" />
                    <div class="input-group">
                    	<input type="text" id="messageInput" placeholder="메시지를 입력하세요" autocomplete="off" />
                    	<button id="" type="submit">전송</button>
                    </div>
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
            
         	// URL 파라미터에서 targetUserId 가져오기
            const urlParams = new URLSearchParams(window.location.search);
            const targetUserId = urlParams.get('targetUserId');

            if(targetUserId) {
                // targetUserId가 존재하면 채팅방 생성 또는 기존 채팅방 가져오기
                $.ajax({
                    url: '/chat/startChat.kh',
                    type: 'GET',
                    data: { userId: targetUserId },
                    success: function(response) {
                        if(response.success && response.roomId) {
                            // 채팅방 ID를 기반으로 채팅방 선택
                            selectChatRoom(response.roomId, response.receiverNo);
                        } else {
                            console.log('채팅방 생성 또는 가져오기 실패: ' + (response.message || ''));
                        }
                    },
                    error: function() {
                        console.log('서버 오류가 발생했습니다.');
                    }
                });
            }
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
            $('#exitChatScreen').show();
            $('#chatMessages').show();

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
        
        /* "빈 화면" 표시 함수 */
        function showBlankChatWindow() {
            // .chat-window 영역을 숨겨 빈 화면처럼 보이게 함
            $('.chat-window').hide();
        }

        /* 채팅창에 메시지 렌더링 */
        function renderChatMessages(chatMessages) {
            // 보이지 않았다면 다시 보이도록(성공 시)
            $('.chat-window').show();
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
         // 부모 컨테이너
            const $msgDiv = $('<div>')
                .addClass('message')
                .addClass(isCurrentUser ? 'sent' : 'received');

            if (isCurrentUser) {
                // 내가 보낸 메시지 (오른쪽 정렬)
                // 말풍선
                $msgDiv.append($('<div>').addClass('bubble').text(message.messageContent));
                // 시간
                $msgDiv.append($('<div>').addClass('time').text(message.sendDate));

            } else {
                // 상대방 메시지 (왼쪽 정렬) - 프로필 + 텍스트(닉네임/메시지/시간)를 수평으로
                // 전체 감싸는 컨테이너 (프로필 사진 + 텍스트)
                const $container = $('<div>')
                    .addClass('received-message-container'); 
                    // 아래 CSS에서 display: flex; align-items: center; 적용할 예정

                // 프로필 이미지 영역
                const $profileDiv = $('<div>').addClass('profile-image-container');
                const $profileImg = $('<img>')
                    .addClass('profile-images')
                    .attr('src', message.senderImage || '/resources/profile_file/default_profile.png')
                    .attr('alt', '프로필 사진');
                $profileDiv.append($profileImg);

                // 텍스트 영역(닉네임, 메시지, 시간)
                // 닉네임과 메시지, 시간을 세로로 쌓되, 전체는 프로필과 수평
                const $textWrapper = $('<div>').addClass('text-container');
                
                // 닉네임
                const $nameDiv = $('<div>').addClass('sender-name').text(message.senderName);

                // 말풍선
                const $bubbleDiv = $('<div>').addClass('bubble').text(message.messageContent);

                // 시간
                const $timeDiv = $('<div>').addClass('time').text(message.sendDate);

                // 조립
                $textWrapper.append($nameDiv, $bubbleDiv, $timeDiv);
                $container.append($profileDiv, $textWrapper);
                $msgDiv.append($container);
            }

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
        /* 스크롤 맨 아래로 이동 */
        function scrollToBottom() {
            const cm = $('#chatMessages');
            cm.scrollTop(cm[0].scrollHeight);
        }
        
        /* 빈화면 처리(채팅창 숨기기) */
        function showBlankChatWindow() {
            $('.chat-window').hide();
        }

        /* 전체 채팅창만 나가기(채팅 목록 그대로 두기) */
        function exitChatScreen() {
        	// 기존 채팅방을 떠난다는 시그널 전송
            if(socket && socket.readyState === WebSocket.OPEN && selectedRoomId) {
                const leaveSignal = {
                    type: "leave",
                    roomId: selectedRoomId,
                    userNo: userNo
                };
                socket.send(JSON.stringify(leaveSignal));
            }
            
            // 이후 화면만 초기화
            selectedRoomId = null;
            selectedReceiverNo = null;
            $('#chatForm').hide();
            $('#leaveChatRoom').hide();
            $('#exitChatScreen').hide();
            $('#chatRoomTitle').text("채팅방이 선택되지 않았습니다.");
            $('#chatMessages').empty();
            showBlankChatWindow();
        }
        
        
    </script>
</body>
</html>