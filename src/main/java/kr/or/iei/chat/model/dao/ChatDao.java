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

	    public List<ChatRoom> getChatRoomList() {
	        return sqlSession.selectList("chat.getChatRoomList");
	    }

	    public List<ChatRoom> getChatRoomListByUser(int userNo) {
	        return sqlSession.selectList("chat.getChatRoomListByUser", userNo);
	    }

	    public List<ChatMessage> getChatMessages(int roomId) {
	        return sqlSession.selectList("chat.getChatMessages", roomId);
	    }

	    public int getUserNoByUserId(String userId) {
	        return sqlSession.selectOne("chat.getUserNoByUserId", userId);
	    }

	    public ChatRoom getChatRoomByUsers(Map<String, Integer> params) {
	        return sqlSession.selectOne("chat.getChatRoomByUsers", params);
	    }

	    public void createChatRoom(Map<String, Integer> params) {
	        sqlSession.insert("chat.createChatRoom", params);
	    }

	    public void saveChatMessage(ChatMessage chatMessage) {
	        sqlSession.insert("chat.saveChatMessage", chatMessage);
	    }

	    public void leaveChatRoom(Map<String, Integer> params) {
	        sqlSession.update("chat.leaveChatRoom", params);
	    }

	    // 추가: roomId로 채팅방을 조회하는 메소드
	    public ChatRoom getChatRoomByRoomId(int roomId) {
	        return sqlSession.selectOne("chat.getChatRoomByRoomId", roomId);
	    }
}