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

	public String srchUserName(int sendUserNo) {
		return sqlSession.selectOne("notify.srchUserName", sendUserNo);
	}
	
}
