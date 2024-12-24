package kr.or.iei.post.model.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.post.model.dao.PostDao;
import kr.or.iei.post.model.vo.Post;

@Service("postService")
public class PostService {

	@Autowired
	@Qualifier("postDao")
	private PostDao postDao;

	public ArrayList<Post> postUserImg(int userNo) {
		return (ArrayList<Post>) postDao.postUserImg(userNo);
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

	public int hashtag() {
		return 0;
	}
	
}
