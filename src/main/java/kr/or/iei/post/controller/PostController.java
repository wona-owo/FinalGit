package kr.or.iei.post.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

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
	public String savePost(@RequestParam("userNo") int userNo, Model model, HttpServletRequest request, @RequestParam("content") String content , @RequestParam("files") MultipartFile [] files, @RequestParam("hashtag") String tagString) {
		
		//1. 미리 시퀀스 세팅
		int postNo = postService.postNo();
		Post post = new Post();
		
		//post 객체 세팅
		post.setPostNo(postNo);
		post.setPostContent(content);
		post.setUserNo(userNo);
		
		//2. 게시글 생성(여부 확인)
		int resWr = postService.write(post);
		   
		//3. 사진 폴더 삽입 + 이름 세팅, 이름 객체에 저장
		   System.out.println("메서드 진입: 파일 처리 시작");
		   
		   if (files == null || files.length == 0) {
			    System.out.println("업로드된 파일이 없습니다.");
			    return "member/myFeed";
			}
		   
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

		   
		//5. 해시태그 삽입 - json을 String으로 받아서 array로 변환
		ObjectMapper objMap = new ObjectMapper();   
		int resHs = 0;  
		ArrayList<String> tagArr;
		
		try {
			
			tagArr = objMap.readValue(tagString, new TypeReference<ArrayList<String>>() {});	
			//태그 array 전달
			resHs = postService.hashtag(tagArr, postNo);			
			
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}							
		
		//성공시 피드 랜딩
		if(resHs > 0 && resWr > 0) {			
			return "redirect:myFeedFrm.kh";								
		}else {
			model.addAttribute("message", "작업에 실패했습니다. 다시 시도해주세요.");
		    model.addAttribute("url", "redirect:myFeedFrm.kh");
		    return "common/alert";
		}
		
	}
	

}	

