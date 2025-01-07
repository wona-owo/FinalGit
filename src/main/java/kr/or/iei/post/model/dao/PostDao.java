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
import kr.or.iei.post.model.vo.Comment;
import kr.or.iei.post.model.vo.Like;
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

	public int delPost(int postNo) {
		return sqlSession.delete("post.delPost",postNo);
	}

	public int updPost(Post post) {
		return sqlSession.update("post.updPost", post);
	}
	
	public int delTag(int postNo) {	
		return sqlSession.delete("post.delTag", postNo);
	}

	public List<Comment> getComment(int postNo) {
		return sqlSession.selectList("post.getComment", postNo);
	}
	
	public int writeComment(Comment comment) {
		return sqlSession.insert("post.writeComment", comment);
	}

	public int delComment(int commentNo) {
		return sqlSession.delete("post.delComment", commentNo);
	}

	public int updComment(Map<String, Object> params) {
		return sqlSession.update("post.updComment", params);
	}

	public int insertLike(Like like) {
		return sqlSession.insert("post.insertLike",like);
	}

	public int deleteLike(Like like) {
		return sqlSession.delete("post.deleteLikel",like);
	}

	public int countLike(Map<String, Object> likeCnt) {
		return sqlSession.selectOne("post.countLike", likeCnt);
	}

	public int isLiked(Like like) {
	    return sqlSession.selectOne("post.isLiked", like);
	}
	
	// 팔로우한 사람의 게시물 중 랜덤 5개
    public List<Post> getRecentFollowPosts(int userNo) {
        return sqlSession.selectList("post.getRecentFollowPosts", userNo);
    }

    // 전체 게시물 중 랜덤 limit개
    public List<Post> getRandomPosts(Map<String, Object> params) {
        return sqlSession.selectList("post.getRandomPosts", params);
    }

    // 무한 스크롤 - 전체 게시물 최신순으로 (startRow+1 ~ endRow)
    public List<Post> getMorePosts(Map<String, Object> params) {
        return sqlSession.selectList("post.getMorePosts", params);
    }
}
