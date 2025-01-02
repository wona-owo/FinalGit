package kr.or.iei.post.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
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
import com.google.gson.Gson;

import kr.or.iei.follor.model.service.FollowService;
import kr.or.iei.member.model.service.MemberService;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.member.model.vo.Mypet;
import kr.or.iei.post.model.service.PostService;
import kr.or.iei.post.model.vo.Comment;
import kr.or.iei.post.model.vo.Post;
@RequestMapping("/post/")
@Controller
public class PostController {
	
	@Autowired
	private ServletContext servletContext;
	
	@Autowired
	@Qualifier("postService")
	private PostService postService;
	
	@Autowired
	@Qualifier("followService")
    private FollowService followService;
	
	@Autowired
	@Qualifier("service")
	private MemberService memberService;
	
	//유저 피드 데이터 불러오기(포스트 이미지, 콘텐츠, 팔로우 수, 썸네일 리스트)
	@GetMapping("myFeedFrm.kh") //메뉴 버튼이랑 매핑
	public String userFeedInfo(Model model, HttpSession session) {
		 
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		int userNo = loginMember.getUserNo();		
        int followerCount  = followService.getFollowerCount(userNo);  // 나를 팔로우하는 사람 수
        int followingCount = followService.getFollowingCount(userNo); // 내가 팔로우하는 사람 수
		
		ArrayList<Post> postData = postService.postData(userNo);
		
		ArrayList<Mypet> mypets = memberService.selectMyPetList(userNo);
		
		model.addAttribute("member", loginMember);
		model.addAttribute("mypetList", mypets);
		model.addAttribute("post", postData);
		model.addAttribute("followerCount", followerCount);
		model.addAttribute("followingCount", followingCount);
		
		
		return "member/myFeed";

	}
	
	//이미지 리스트 반환(ajax)
	@GetMapping(value="imgLists.kh", produces="application/json; charset=utf-8")
	@ResponseBody
	public String imgLists(@RequestParam("postNo")int postNo) {
		
		ArrayList<String> result = postService.imgLists(postNo);	
		return new Gson().toJson(result);
	}
	
	//post 작성
	@PostMapping("write.kh")
	public String savePost(@RequestParam("userNo")int userNo, Model model, HttpServletRequest request, @RequestParam("content") String content , @RequestParam("files") MultipartFile [] files, @RequestParam("hashtag") String tagString) {
		
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
					   		   + (i+1) + extension;
			   
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
	
	//해시태그 불러오기
	@GetMapping(value="hashtags.kh", produces="application/json; charset=utf-8")
	@ResponseBody
	public ArrayList<String> callHashtag(@RequestParam("postNo") int postNo) {	
		ArrayList<String> tagList = (ArrayList<String>) postService.callHashtag(postNo);		
		return tagList;
	}
	
	//게시물 삭제
	@GetMapping(value="delete.kh", produces="text/html; charset=utf-8")
    @ResponseBody
    public String deletePost(@RequestParam("postNo") int postNo) {
        
		 // 파일 경로 리스트 가져오기
        ArrayList<String> filePaths = postService.imgLists(postNo);
        String basePath =  servletContext.getRealPath("/resources/post_file/");
        
        //배열 순회하면서 파일 삭제
        for(String filePath : filePaths) {
        	if(filePath != null) {
        		File file = new File(basePath + filePath);
        		if (file.exists() && !file.delete()) {
                    return "error"; // 파일 삭제 실패 시 반환
                }      		
        	}
        }
         
        // 데이터베이스에서 게시물 삭제
        int result = postService.deletePost(postNo);
        
        if (result > 0) {
            return "success"; 
        } else {
            return "error"; 
        }
		
    }
	
	//게시물 수정
	@PostMapping("update.kh")
	public String updatePost(Model model, @RequestParam("userNo") int userNo, @RequestParam("postNo") int postNo, @RequestParam("content") String content, @RequestParam("hashtag") String tagString ) {
		
		Post post = new Post();
		
		//post 객체 세팅
		post.setUserNo(userNo);
		post.setPostNo(postNo);
		post.setPostContent(content);
		
		 if (postNo == 0) {
		        // postNo가 null일 경우 처리 로직
		        System.out.println("postNo 값이 없습니다.");
		    }
		
		//post 수정
		int resPs = postService.updatePost(post);
		
		//hashtag 수정
		ObjectMapper objMap = new ObjectMapper();   
		int resHs = 0;  
		ArrayList<String> tagArr;
		
		try {
			tagArr = objMap.readValue(tagString, new TypeReference<ArrayList<String>>() {});
			
			//삭제 후 재삽입
			//삭제
			int delRes = postService.delTag(postNo);
			
			if(delRes < 0) {
				model.addAttribute("message", "작업에 실패했습니다. 다시 시도해주세요.");
			    model.addAttribute("url", "redirect:myFeedFrm.kh");
			    return "common/alert";
			}
	
			
			//태그 array 전달(삽입)
			resHs = postService.hashtag(tagArr, postNo);			
			
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}							
		
		//성공시 피드 랜딩
		if(resHs > 0 && resPs > 0) {			
			return "redirect:myFeedFrm.kh";								
		}else {
			model.addAttribute("message", "작업에 실패했습니다. 다시 시도해주세요.");
		    model.addAttribute("url", "redirect:myFeedFrm.kh");
		    return "common/alert";
		}
	}
	
	//게시물 댓글 조회
	@GetMapping(value="comment.kh", produces="application/json; charset=utf-8")
	@ResponseBody
	public ArrayList<Comment> getComment(Model model, @RequestParam("postNo") int postNo) {	
		ArrayList<Comment> comments = postService.getComment(postNo);
		return comments;
	}
	

}	

