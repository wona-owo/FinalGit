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

	// 사용자가 채팅방을 나갈 때 해당 정보를 업데이트
	public void leaveChatRoom(int roomId, int userNo) {
		HashMap<String, Integer> params = new HashMap<>();
		params.put("roomId", roomId);
		params.put("userNo", userNo);
		chatDao.leaveChatRoom(params);
	}

	// 특정 roomId에 해당하는 채팅방을 조회
	public ChatRoom getChatRoomByRoomId(int roomId) {
		return chatDao.getChatRoomByRoomId(roomId);
	}
}