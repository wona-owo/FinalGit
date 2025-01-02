package kr.or.iei.common.websocket;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import kr.or.iei.chat.model.service.ChatService;
import kr.or.iei.chat.model.vo.ChatMessage;

@Component("socketHandler")
public class SocketHandler extends TextWebSocketHandler {
	@Autowired
    @Qualifier("chatService")
    private ChatService chatService;

    private static HashMap<String, WebSocketSession> userSessions = new HashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        System.out.println("WebSocket 연결 성공: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        JsonElement element = JsonParser.parseString(message.getPayload());
        JsonObject jsonObj = element.getAsJsonObject();
        String type = jsonObj.get("type").getAsString();

        if ("connect".equals(type)) {
            handleConnect(jsonObj, session);
        } else if ("chat".equals(type)) {
            handleChat(jsonObj);
        }
    }

    private void handleConnect(JsonObject jsonObj, WebSocketSession session) {
        String userNo = jsonObj.get("userNo").getAsString();
        userSessions.put(userNo, session);
        System.out.println("사용자 연결: " + userNo);
    }

    private void handleChat(JsonObject jsonObj) {
        try {
            String roomIdStr = jsonObj.get("roomId").getAsString();
            String senderNoStr = jsonObj.get("senderNo").getAsString();
            String receiverNoStr = jsonObj.get("receiverNo").getAsString();
            String messageContent = jsonObj.get("messageContent").getAsString();

            if (roomIdStr.isEmpty() || senderNoStr.isEmpty() || receiverNoStr.isEmpty()) {
                throw new NumberFormatException("빈 문자열을 숫자로 변환할 수 없습니다.");
            }

            int roomId = Integer.parseInt(roomIdStr);
            int senderNo = Integer.parseInt(senderNoStr);
            int receiverNo = Integer.parseInt(receiverNoStr);

            ChatMessage chatMessage = new ChatMessage();
            chatMessage.setRoomId(roomId);
            chatMessage.setSenderNo(senderNo);
            chatMessage.setMessageContent(messageContent);
            chatMessage.setSendDate(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            
            chatService.saveChatMessage(chatMessage);

            JsonObject response = new JsonObject();
            response.addProperty("type", "chat");
            response.addProperty("data", new Gson().toJson(chatMessage));
            String responseMessage = response.toString();

            sendToUser(String.valueOf(senderNo), responseMessage);
            sendToUser(String.valueOf(receiverNo), responseMessage);
        } catch (NumberFormatException e) {
            System.err.println("숫자 형식 오류: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void sendToUser(String userNo, String message) {
        WebSocketSession session = userSessions.get(userNo);
        if (session != null && session.isOpen()) {
            try {
                session.sendMessage(new TextMessage(message));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        userSessions.values().remove(session);
        System.out.println("WebSocket 연결 종료: " + session.getId());
    }
}