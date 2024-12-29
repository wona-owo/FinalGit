package kr.or.iei.follor.model.dao;

import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

@Repository("followDao")
public class FollowDao {

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;

	public int selectCheckFollor(HashMap<String, Object> check) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("follow.selectCheckFollor", check);
	}

	public int insertFollow(HashMap<String, Object> insert) {
		// TODO Auto-generated method stub
		return sqlSession.insert("follow.insertFollow", insert);
	}

	public int deleteFollow(HashMap<String, Object> deleteMap) {
		// TODO Auto-generated method stub
		 return sqlSession.delete("follow.deleteFollow", deleteMap);
	}
	
	public int selectFollowerCount(int userNo) {
        return sqlSession.selectOne("follow.selectFollowerCount", userNo);
    }

    public int selectFollowingCount(int userNo) {
        return sqlSession.selectOne("follow.selectFollowingCount", userNo);
    }
}
