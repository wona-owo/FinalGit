package kr.or.iei.chat.model.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.chat.model.dao.ChatDao;
import kr.or.iei.chat.model.vo.ChatRoom;
import kr.or.iei.chat.model.vo.ChatMessage;

@Service("chatService")
public class ChatService {

	@Autowired
	@Qualifier("chatDao")
	private ChatDao chatDao;

	// 모든 채팅방 목록을 조회
	public ArrayList<ChatRoom> getChatRoomList() {
		return (ArrayList<ChatRoom>) chatDao.getChatRoomList();
	}

	// 특정 사용자가 참여하고 있는 채팅방 목록을 조회
	public ArrayList<ChatRoom> getChatRoomListByUser(int userNo) {
		return (ArrayList<ChatRoom>) chatDao.getChatRoomListByUser(userNo);
	}

	// 특정 채팅방의 모든 메시지를 조회
	public ArrayList<ChatMessage> getChatMessages(int roomId) {
		return (ArrayList<ChatMessage>) chatDao.getChatMessages(roomId);
	}

	// 사용자 ID를 통해 사용자 번호를 조회
	public int getUserNoByUserId(String userId) {
		return chatDao.getUserNoByUserId(userId);
	}

	// 두 사용자가 참여하고 있는 채팅방을 조회
	public ChatRoom getChatRoomByUsers(int user1No, int user2No) {
		HashMap<String, Integer> params = new HashMap<>();
		params.put("user1_no", user1No);
		params.put("user2_no", user2No);
		return chatDao.getChatRoomByUsers(params);
	}

	// 새로운 채팅방을 생성
	public ChatRoom createChatRoom(int user1No, int user2No) {
		HashMap<String, Integer> params = new HashMap<>();
		params.put("user1_no", user1No);
		params.put("user2_no", user2No);
		chatDao.createChatRoom(params);
		return chatDao.getChatRoomByUsers(params);
	}

	// 채팅 메시지를 저장
	public void saveChatMessage(ChatMessage chatMessage) {
		chatDao.saveChatMessage(chatMessage);
	}

	// 사용자가 채팅방을 나갈 때 해당 정보를 업데이트하고 필요시 채팅방 삭제
    public void leaveChatRoom(int roomId, int userNo) {
        ChatRoom chatRoom = chatDao.getChatRoomByRoomId(roomId);
        if (chatRoom == null) {
            // 채팅방이 존재하지 않으면 예외 처리 또는 로그 추가
            return;
        }

        HashMap<String, Object> params = new HashMap<>();
        params.put("roomId", roomId);
        params.put("userNo", userNo);
        params.put("user1No", chatRoom.getUser1No());
        params.put("user2No", chatRoom.getUser2No());

        chatDao.setUserOutTimeAndLeft(params);

        // 채팅방이 양쪽 모두 나갔는지 확인 후 삭제
        if ("Y".equals(chatRoom.getUser1Left()) && "Y".equals(chatRoom.getUser2Left())) {
            chatDao.deleteChatRoom(roomId);
        }
    }

	// 특정 roomId에 해당하는 채팅방을 조회
	public ChatRoom getChatRoomByRoomId(int roomId) {
		return chatDao.getChatRoomByRoomId(roomId);
	}
	
	// 마지막 나간 시간 이후의 채팅 메시지를 조회
	public ArrayList<ChatMessage> getChatMessagesAfterOutTime(int roomId, Date lastOutTime) {
	    HashMap<String, Object> params = new HashMap<>();
	    params.put("roomId", roomId);
	    params.put("lastOutTime", lastOutTime);
	    return (ArrayList<ChatMessage>) chatDao.getChatMessagesAfterOutTime(params);
	}

	//채팅방 나간거 활성화
	public int updateChatRoom(int user1No, int roomId, int getUser1No, int getUser2No) {
		HashMap<String, Object> params = new HashMap<>();
		params.put("roomId", roomId);
		params.put("userNo", user1No);
		params.put("user1No", getUser1No);
        params.put("user2No", getUser2No);
		return chatDao.updateChatRoom(params);
	}
	
}