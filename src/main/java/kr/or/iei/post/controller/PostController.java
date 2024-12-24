package kr.or.iei.post.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.post.model.service.PostService;
import kr.or.iei.post.model.vo.Post;
@RequestMapping("/post/")
@Controller
public class PostController {
	
	@Autowired
	@Qualifier("postService")
	private PostService postService;
	
	
	//post 이미지 불러오기 + (다른 내용들 포함)
	@GetMapping("myFeedFrm.kh") //메뉴 버튼이랑 매핑
	public String postUserImg(Model model, HttpSession session) {
		 
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		int userNo = loginMember.getUserNo();		
		ArrayList<Post> imgList = postService.postUserImg(userNo);

		model.addAttribute("post",imgList);
		
		return "member/myFeed";
	}
	
	//post 작성
	@PostMapping("write.kh")
	public String savePost(HttpServletRequest request, Post post, MultipartFile [] files) {
		
		//1. 미리 시퀀스 세팅
		int postNo = postService.postNo();
		post.setPostNo(postNo);
		
		//2. 게시글 생성(여부 확인)
		int resWr = postService.write(post);
		   
		//3. 사진 폴더 삽입 + 이름 세팅, 이름 객체에 저장

		   for(int i=0; i<files.length; i++) {
			   
			   MultipartFile file = files[i];
			   
			   //들어갈 경로 세팅
			   String savePath = request.getSession().getServletContext().getRealPath("/resources/post_file/");
			   			   
			   //기존 파일 이름, 확장자 가져오기
			   String originalFileName = file.getOriginalFilename();
			   String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
			   
			   //파일 이름 변경
			   String toDay = new SimpleDateFormat("yyyyMMdd").format(new Date());
			  
			   String fileName = post.getUserNo() + "_" 
					   		   + post.getPostNo() + "_" 
					   		   + toDay + "_"
					   		   + (i+1) + "_" + extension;
			   
			   //파일 경로 세팅
			   savePath += fileName;
			   
			   try {				   
				//파일 저장
				file.transferTo(new File(savePath));
				
			} catch (IllegalStateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			   
			   //4. 사진 삽입(DB) - 순회하면서 같이 삽입
			   post.setPostFileName(fileName);
			   postService.image(post);
		    }
				
		//5. 해시태그 삽입 - hashmap으로 json을 받아서 list로 변환
		int resHs = postService.hashtag();
		
		return null;								
		
	}
	

	
}
