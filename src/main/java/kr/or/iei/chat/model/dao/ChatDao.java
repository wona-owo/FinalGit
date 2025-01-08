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

	    // 사용자 나가기 시 out_time과 _left 업데이트 (동적 SQL 사용)
	    public void setUserOutTimeAndLeft(Map<String, Object> params) {
	        sqlSession.update("chat.setUserOutTimeAndLeft", params);
	    }
	    
	    // 양쪽 사용자가 모두 나갔을 경우 채팅방 삭제
	    public void deleteChatRoom(int roomId) {
	        sqlSession.delete("chat.deleteChatRoom", roomId);
	    }
	    
	    // 특정 roomId에 해당하는 채팅방을 조회
	    public ChatRoom getChatRoomByRoomId(int roomId) {
	        return sqlSession.selectOne("chat.getChatRoomByRoomId", roomId);
	    }
	    
	    // 특정 방의 마지막 out_time을 기준으로 메시지 조회
	    public List<ChatMessage> getChatMessagesAfterOutTime(Map<String, Object> params) {
	        return sqlSession.selectList("chat.getChatMessagesAfterOutTime", params);
	    }

	    // 채팅방 나간 상대 재참여
		public int updateChatRoom(HashMap<String, Object> params) {
			// TODO Auto-generated method stub
			return sqlSession.update("chat.updateChatRoomUser", params);
		}
		
		// 읽음 상태 업데이트
		public int updateReadStatus(HashMap<String, Object> params) {
			// 로그 추가
			//System.out.println("updateReadStatus 실행됨: " + params);
		    return sqlSession.update("chat.updateReadStatus", params);
		}

		// 읽음 상태 조회
		public String getReadStatus(HashMap<String, Object> params) {
		    return sqlSession.selectOne("chat.getReadStatus", params);
		}

		// 사용자 번호로 사용자 이름 조회
	    public String getUserNameByUserNo(int userNo) {
	        return sqlSession.selectOne("chat.getUserNameByUserNo", userNo);
	    }

		// 채팅방의 마지막 메시지 조회
		public ChatMessage getLastChatMessage(int roomId) {
			return sqlSession.selectOne("chat.getLastChatMessage", roomId);
		}
}