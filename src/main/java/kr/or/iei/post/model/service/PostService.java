package kr.or.iei.post.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.post.model.dao.PostDao;
import kr.or.iei.post.model.vo.Comment;
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
	
}
