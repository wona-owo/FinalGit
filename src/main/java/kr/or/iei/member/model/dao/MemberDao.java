package kr.or.iei.member.model.dao;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.member.model.vo.Member;

@Repository("dao")
public class MemberDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;

	public int join(Member member) {
		return sqlSession.insert("member.insertUser", member);
	}
	
	public Member memberLogin(Member member) {
		return sqlSession.selectOne("member.loginMember", member);
	}

	public int idDuplChk(String userId) {
		return sqlSession.selectOne("member.idDuplChk", userId);
	}

	public int nickDuplChk(String userNickname) {
		return sqlSession.selectOne("member.nickDuplChk", userNickname);
	}

	public int phoneDuplChk(String userPhone) {
		return sqlSession.selectOne("member.phoneDuplChk", userPhone);
	}

	public int apiJoin(Member member) {
		return sqlSession.insert("member.insertApiUser", member);
	}

	public List<Member> searchUser(String searchStr) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("member.userSearch", searchStr);
	}
}
