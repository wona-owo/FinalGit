package kr.or.iei.post.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.post.model.service.PostService;
import kr.or.iei.post.model.vo.Post;
@RequestMapping("/post/")
@Controller
public class PostController {
	
	@Autowired
	@Qualifier("postService")
	private PostService postService;
	
	
	//post 이미지 불러오기
	@GetMapping("myFeedFrm.kh") //메뉴 버튼이랑 매핑
	public String postUserImg(Model model, HttpSession session) {
		 
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		int userNo = loginMember.getUserNo();		
		ArrayList<Post> imgList = postService.postUserImg(userNo);
		
		model.addAttribute("post",imgList);
		
		return "member/myFeed";
	}
	
}
