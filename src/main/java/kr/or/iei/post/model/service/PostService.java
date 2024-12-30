package kr.or.iei.post.model.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.post.model.dao.PostDao;
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
	
}
