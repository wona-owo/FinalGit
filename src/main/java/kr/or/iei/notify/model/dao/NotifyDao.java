package kr.or.iei.notify.model.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.notify.model.vo.Notify;

@Repository("notifyDao")
public class NotifyDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;
	
	
	// 새 알림 추가
    public int insertNotification(Notify notify) {
        return sqlSession.insert("notify.insert", notify);
    }

    // 특정 사용자의 읽지 않은 알림 가져오기
    public List<Notify> getUnreadNotifications(int userNo) {
        return sqlSession.selectList("notify.getUnread", userNo);
    }

    // 단일 알림 읽음 처리
    public int updateNotificationReadStatus(int notifyId) {
        return sqlSession.update("notify.updateRead", notifyId);
    }

    // 다중 알림 읽음 처리
    public int updateMultipleRead(List<Integer> notifyIds) {
        return sqlSession.update("notify.updateMultipleRead", notifyIds);
    }
	
}
