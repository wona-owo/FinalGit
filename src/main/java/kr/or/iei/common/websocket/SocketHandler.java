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

	//사용자 번호와 세션을 매핑하기 위한 HashMap
    private static HashMap<String, WebSocketSession> userSessions = new HashMap<>();

    //WebSocket 연결이 성립되었을 때 호출되는 메소드
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        //System.out.println("WebSocket 연결 성공: " + session.getId());
    }

    //클라이언트로부터 메시지를 수신했을 때 호출되는 메소드
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
    	// 수신한 메시지를 JSON으로 파싱
        JsonElement element = JsonParser.parseString(message.getPayload());
        JsonObject jsonObj = element.getAsJsonObject();
        String type = jsonObj.get("type").getAsString();

        //메시지의 타입에 따라 처리 분기
        if ("connect".equals(type)) {
            handleConnect(jsonObj, session);
        } else if ("chat".equals(type)) {
            handleChat(jsonObj);
        }
    }
    
    //사용자가 연결될 때 세션을 매핑
    private void handleConnect(JsonObject jsonObj, WebSocketSession session) {
        String userNo = jsonObj.get("userNo").getAsString();
        userSessions.put(userNo, session); 
        //System.out.println("사용자 연결: " + userNo);
    }

    //채팅 메시지를 처리하는 메소드
    private void handleChat(JsonObject jsonObj) {
        try {
            String roomIdStr = jsonObj.get("roomId").getAsString();
            String senderNoStr = jsonObj.get("senderNo").getAsString();
            String receiverNoStr = jsonObj.get("receiverNo").getAsString();
            String messageContent = jsonObj.get("messageContent").getAsString();

            //필수 필드가 비어있는지 확인
            if (roomIdStr.isEmpty() || senderNoStr.isEmpty() || receiverNoStr.isEmpty()) {
                throw new NumberFormatException("빈 문자열을 숫자로 변환할 수 없습니다.");
            }
            
            //문자열을 정수로 변환
            int roomId = Integer.parseInt(roomIdStr);
            int senderNo = Integer.parseInt(senderNoStr);
            int receiverNo = Integer.parseInt(receiverNoStr);

            //채팅 메시지 객체 생성 및 설정
            ChatMessage chatMessage = new ChatMessage();
            chatMessage.setRoomId(roomId);
            chatMessage.setSenderNo(senderNo);
            chatMessage.setMessageContent(messageContent);
            chatMessage.setSendDate(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            
            //메시지를 데이터베이스에 저장
            chatService.saveChatMessage(chatMessage);

            //응답 JSON 객체 생성
            JsonObject response = new JsonObject();
            response.addProperty("type", "chat");
            response.addProperty("data", new Gson().toJson(chatMessage));
            String responseMessage = response.toString();

            //송신자와 수신자에게 메시지 전송
            sendToUser(String.valueOf(senderNo), responseMessage);
            sendToUser(String.valueOf(receiverNo), responseMessage);
        } catch (NumberFormatException e) {
            //System.err.println("숫자 형식 오류: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //특정 사용자에게 메시지를 전송하는 메소드
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
    //WebSocket 연결이 종료되었을 때 호출되는 메소드
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        userSessions.values().remove(session); //웹 소켓 종료
        //System.out.println("WebSocket 연결 종료: " + session.getId());
    }
}