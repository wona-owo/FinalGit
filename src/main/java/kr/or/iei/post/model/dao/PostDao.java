package kr.or.iei.post.model.dao;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.post.model.vo.Post;

@Repository("postDao")
public class PostDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;

	public List<Post> postUserImg(int userNo) {
		return sqlSession.selectList("post.postData", userNo);
	}

	public int write(Post post) {
		return sqlSession.insert("post.write", post);
	}
	
	//시퀀스
	public int postNo() {
		return sqlSession.selectOne("post.getPostId");
	}

	public int image(Post post) {
		return sqlSession.insert("post.image", post);
	}
	
}
