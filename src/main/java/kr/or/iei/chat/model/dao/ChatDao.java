package kr.or.iei.chat.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.iei.chat.model.vo.ChatRoom;
import kr.or.iei.chat.model.vo.ChatMessage;

@Repository("chatDao")
public class ChatDao {

	 @Autowired
	    private SqlSession sqlSession;

	 	// 모든 채팅방 목록을 조회
	    public List<ChatRoom> getChatRoomList() {
	        return sqlSession.selectList("chat.getChatRoomList");
	    }

	    // 특정 사용자가 참여하고 있는 채팅방 목록을 조회
	    public List<ChatRoom> getChatRoomListByUser(int userNo) {
	        return sqlSession.selectList("chat.getChatRoomListByUser", userNo);
	    }

	    // 특정 채팅방의 모든 메시지를 조회
	    public List<ChatMessage> getChatMessages(int roomId) {
	        return sqlSession.selectList("chat.getChatMessages", roomId);
	    }

	    // 사용자 ID를 통해 사용자 번호를 조회
	    public int getUserNoByUserId(String userId) {
	        return sqlSession.selectOne("chat.getUserNoByUserId", userId);
	    }

	    // 두 사용자가 참여하고 있는 채팅방을 조회
	    public ChatRoom getChatRoomByUsers(Map<String, Integer> params) {
	        return sqlSession.selectOne("chat.getChatRoomByUsers", params);
	    }

	    // 새로운 채팅방을 생성
	    public void createChatRoom(Map<String, Integer> params) {
	        sqlSession.insert("chat.createChatRoom", params);
	    }

	    // 채팅 메시지를 저장
	    public void saveChatMessage(ChatMessage chatMessage) {
	        sqlSession.insert("chat.saveChatMessage", chatMessage);
	    }

	    // 사용자가 채팅방을 나갈 때 해당 정보를 업데이트
	    public void leaveChatRoom(Map<String, Integer> params) {
	        sqlSession.update("chat.leaveChatRoom", params);
	    }

	    // 특정 roomId에 해당하는 채팅방을 조회
	    public ChatRoom getChatRoomByRoomId(int roomId) {
	        return sqlSession.selectOne("chat.getChatRoomByRoomId", roomId);
	    }
}