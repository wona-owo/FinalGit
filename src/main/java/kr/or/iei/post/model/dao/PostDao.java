package kr.or.iei.post.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	public List<Post> postData(int userNo) {
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

	public int hashTag(ArrayList<String> tagArr, int postNo) {
		int totalInserted = 0; //전체 삽입된 행 수

	    for (String tag : tagArr) {
	        Map<String, Object> paramMap = new HashMap<>();
	        paramMap.put("postNo", postNo);
	        paramMap.put("tag", tag);

	        // 예외 발생 시 전체 작업이 롤백됨
	        totalInserted += sqlSession.insert("post.hashTag", paramMap);
	    }

	    return totalInserted;
	}

	public List<String> callTag(int postNo) {
		return sqlSession.selectList("post.tagList", postNo);
	}

	public List<String> imgLists(int postNo) {
		return sqlSession.selectList("post.imgList", postNo);
	}

	public List<String> thumbNail(int userNo) {
		return sqlSession.selectList("post.thumbNail",userNo);
	}
	
}
