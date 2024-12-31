package kr.or.iei.follor.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.member.model.vo.Mypet;

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

	public List<String> getMyPetTypes(int userNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("follow.getMyPetTypes", userNo);
	}

	public List<Member> getRecommendUsers(HashMap<String, Object> select) {
	    return sqlSession.selectList("follow.getRecommendUsers", select);
	}

	public List<Mypet> getPetsByUserNo(int userNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("follow.getPetsByUserNo", userNo);
	}
}
