package kr.or.iei.post.model.service;

import java.util.ArrayList;
import java.util.Collections;
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
		// 좋아요가 되어 있는지 먼저 확인
	    int isLiked = postDao.isLiked(like);
	    
	    if (isLiked > 0) {
	        // 이미 좋아요 상태라면 0을 리턴 or 예외 처리
	        return 0;
	    }
	    
	    // 좋아요가 아니라면 INSERT 진행
	    int result = postDao.insertLike(like);
	    return result;
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
	
	/*
     * 초기 게시물 로드 시: 
     * - getRecentFollowPosts(5개)
     * - getRandomPosts(5개)
     * 합쳐서 중복 제거 후 최대 10개로 제한
     */
    public List<Post> getInitialPosts(int userNo) {
        // 내가 팔로우한 사람 중 랜덤 5개
        List<Post> followPosts = getRecentFollowPosts(userNo);
        // 전체 게시물 중 랜덤 5개 (팔로우 게시물이 없을 경우 10개로 조정)
        int randomLimit = followPosts.isEmpty() ? 10 : 5;
        List<Post> randomPosts = getRandomPosts(randomLimit);

        // 두 리스트 합치기 + 중복 제거
        Set<Post> initialPostsSet = new LinkedHashSet<>();
        initialPostsSet.addAll(followPosts);
        initialPostsSet.addAll(randomPosts);

        // 리스트 변환
        List<Post> initialPosts = new ArrayList<>(initialPostsSet);

        // 최대 10개로 제한
        if (initialPosts.size() > 10) {
            initialPosts = initialPosts.subList(0, 10);
        }
        return initialPosts;
    }

 // 팔로우한 사람의 게시물 중 랜덤 5개
    public List<Post> getRecentFollowPosts(int userNo) {
        return postDao.getRecentFollowPosts(userNo);
    }

    // 전체 게시물 중 랜덤 limit개
    public List<Post> getRandomPosts(int limit) {
        return postDao.getRandomPosts(limit);
    }

    // 무한 스크롤 시 추가 게시물 로드
    public List<Post> getMorePosts(int userNo, int offset,int limit, List<Integer> excludeList) {
    	 // 중복된 excludeList 제거
	    if (excludeList != null) {
	        excludeList = new ArrayList<>(new LinkedHashSet<>(excludeList));
	    } else {
	        excludeList = new ArrayList<>();
	    }
	    
	    int startRow = offset;
	    int endRow = offset + limit;
	    
	    Map<String, Object> params = new HashMap<>();
	    params.put("userNo", userNo);
	    params.put("startRow", startRow);
	    params.put("endRow", endRow);
	    params.put("excludeList", excludeList != null ? excludeList : Collections.emptyList());

		return postDao.getMorePosts(params);
	}

	//게시글 작성자 조회
	public int getPostOwnerId(int postNo) {
		return postDao.getPostOwnerId(postNo);
	}
	
	//댓글 작성자 조회
	public int getCommentOwnerId(int commentNo) {
		return postDao.getCommentOwnerId(commentNo);
	}
    
}
