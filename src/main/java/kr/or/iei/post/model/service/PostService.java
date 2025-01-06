package kr.or.iei.post.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.post.model.dao.PostDao;
import kr.or.iei.post.model.vo.Comment;
import kr.or.iei.post.model.vo.Like;
import kr.or.iei.post.model.vo.Post;

@Service("postService")
public class PostService {

	@Autowired
	@Qualifier("postDao")
	private PostDao postDao;

	public ArrayList<Post> postData(int userNo) {
		return (ArrayList<Post>) postDao.postData(userNo);
	}

	public int write(Post post) {
		return postDao.write(post);
	}
	
	public int postNo() {
		return postDao.postNo();
	}

	public int image(Post post) {
		return postDao.image(post);
	}
	
	@Transactional //트랜잭션 설정
	public int hashtag(ArrayList<String> tagArr, int postNo) {
		return postDao.hashTag(tagArr, postNo);
	}

	public List<String> callHashtag(int postNo) {
		return postDao.callTag(postNo);
	}

	public ArrayList<String> imgLists(int postNo) {
		return (ArrayList<String>) postDao.imgLists(postNo);
	}

	public List<String> thumbNail(int userNo) {
		return postDao.thumbNail(userNo);
	}

	public int deletePost(int postNo) {
		return postDao.delPost(postNo);
	}

	public int updatePost(Post post) {
		return postDao.updPost(post);
	}
	
	public int delTag(int postNo) {
		return postDao.delTag(postNo);
	}

	public ArrayList<Comment> getComment(int postNo) {
		return (ArrayList<Comment>) postDao.getComment(postNo);
	}

	public int writeComment(Comment comment) {
		return postDao.writeComment(comment);
	}

	public int delComment(int commentNo) {
		return postDao.delComment(commentNo);
	}

	public int updComment(Map<String, Object> params) {
		return postDao.updComment(params);
	}

	public int insertLike(Like like) {
		return postDao.insertLike(like);
	}

	public int deleteLike(Like like) {
		return postDao.deleteLike(like);
	}

	public int countLike(Map<String, Object> likeCnt) {
		return postDao.countLike(likeCnt);
	}
	
	public int isLiked(Like like) {
	    return postDao.isLiked(like);
	}
	// 초기 게시물 로드
    public List<Post> getInitialPosts(int userNo) {
        // 팔로우한 사람의 최근 2일 이내 랜덤 5개 게시물
        List<Post> followPosts = getRecentFollowPosts(userNo);

        // 전체 게시물 중 랜덤으로 10개 가져오기
        List<Post> randomPosts = getRandomPosts(userNo, 10);

        // 두 리스트를 합치고 중복 제거
        Set<Post> initialPostsSet = new LinkedHashSet<>();
        initialPostsSet.addAll(followPosts);
        initialPostsSet.addAll(randomPosts);

        // 리스트로 변환
        List<Post> initialPosts = new ArrayList<>(initialPostsSet);

        // 최대 15개로 제한
        if (initialPosts.size() > 15) {
            initialPosts = initialPosts.subList(0, 15);
        }

        return initialPosts;
    }

    // 팔로우한 사람의 최근 게시물 가져오기
    public List<Post> getRecentFollowPosts(int userNo) {
        return postDao.getRecentFollowPosts(userNo);
    }

    // 랜덤 게시물 가져오기
    public List<Post> getRandomPosts(int userNo, int limit) {
        Map<String, Object> params = new HashMap<>();
        params.put("userNo", userNo);
        params.put("limit", limit);
        return postDao.getRandomPosts(params);
    }

    // 무한 스크롤 시 추가 게시물 가져오기
    public List<Post> getMorePosts(int userNo, int offset) {
        Map<String, Object> params = new HashMap<>();
        params.put("userNo", userNo);
        params.put("offset", offset);
        params.put("limit", 15);
        return postDao.getMorePosts(params);
    }
	
}
