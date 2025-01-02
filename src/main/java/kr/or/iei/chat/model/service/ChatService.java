package kr.or.iei.chat.model.service;

import java.util.ArrayList;
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

	public ArrayList<ChatRoom> getChatRoomList() {
		return (ArrayList<ChatRoom>) chatDao.getChatRoomList();
	}

	public ArrayList<ChatRoom> getChatRoomListByUser(int userNo) {
		return (ArrayList<ChatRoom>) chatDao.getChatRoomListByUser(userNo);
	}

	public ArrayList<ChatMessage> getChatMessages(int roomId) {
		return (ArrayList<ChatMessage>) chatDao.getChatMessages(roomId);
	}

	public int getUserNoByUserId(String userId) {
		return chatDao.getUserNoByUserId(userId);
	}

	public ChatRoom getChatRoomByUsers(int user1No, int user2No) {
		HashMap<String, Integer> params = new HashMap<>();
		params.put("user1_no", user1No);
		params.put("user2_no", user2No);
		return chatDao.getChatRoomByUsers(params);
	}

	public ChatRoom createChatRoom(int user1No, int user2No) {
		HashMap<String, Integer> params = new HashMap<>();
		params.put("user1_no", user1No);
		params.put("user2_no", user2No);
		chatDao.createChatRoom(params);
		return chatDao.getChatRoomByUsers(params);
	}

	public void saveChatMessage(ChatMessage chatMessage) {
		chatDao.saveChatMessage(chatMessage);
	}

	public void leaveChatRoom(int roomId, int userNo) {
		HashMap<String, Integer> params = new HashMap<>();
		params.put("roomId", roomId);
		params.put("userNo", userNo);
		chatDao.leaveChatRoom(params);
	}

	// 추가: roomId로 채팅방을 조회하는 메소드
	public ChatRoom getChatRoomByRoomId(int roomId) {
		return chatDao.getChatRoomByRoomId(roomId);
	}
}