package kr.or.iei.naver.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.naver.model.vo.NaverUser;

@Repository("naverDao")
public class NaverDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;

	public Member naverLoginChk(NaverUser naverUser) {
		return sqlSession.selectOne("naver.naverLoginChk", naverUser);
	}
	
}
