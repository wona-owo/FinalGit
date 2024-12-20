package kr.or.iei.kakao.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.kakao.model.vo.KakaoUser;
import kr.or.iei.member.model.vo.Member;

@Repository("kakaoDao")
public class KakaoDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;

	public Member kakakoLoginChk(KakaoUser kakaoUser) {
		return sqlSession.selectOne("kakao.kakaoLoginChk", kakaoUser);
	}
	
}
