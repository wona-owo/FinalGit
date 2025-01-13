package kr.or.iei.member.controller;


import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.iei.follow.model.service.FollowService;
import kr.or.iei.member.model.service.MemberService;
import kr.or.iei.member.model.vo.HashTag;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.member.model.vo.Mypet;
import kr.or.iei.member.model.vo.Search;
import kr.or.iei.post.model.service.PostService;
import kr.or.iei.post.model.vo.Post;

@Controller
@RequestMapping("/member/")
public class MemberController {

	@Autowired
	@Qualifier("service")
	private MemberService memberService;
	
	@Autowired
	@Qualifier("postService")
	private PostService postService;
	
	@Autowired
	@Qualifier("followService")
    private FollowService followService; 
	
	
	public MemberController() {
		super();
	}
		
	//로그인
	@PostMapping("login.kh")
	public String memberLogin (Member member,HttpSession session, RedirectAttributes red) {
		
		Member loginMember = memberService.memberLogin(member);
		
		if(loginMember != null && "N".equals(loginMember.getBanYN())) {
			session.setAttribute("loginMember", loginMember);
			return "redirect:/member/mainFeed.kh";
		}else if(loginMember != null && "Y".equals(loginMember.getBanYN())){
			red.addFlashAttribute("loginFailMsg", "정지된 계정입니다. 관리자에게 문의해주세요.");
			return "redirect:/";			
		}else {
			red.addFlashAttribute("loginFailMsg", "로그인에 실패했습니다. ID와 비밀번호를 확인해주세요.");
			return "redirect:/";	
		}
	}
	
	//로그아웃
	@GetMapping("logout.kh")
	public String logout(HttpSession session) {
		session.invalidate();
		
		return "redirect:/";
	}
	
	
	//회원가입 Frm
	@GetMapping("joinFrm.kh")
	public String joinFrm() {
		return "member/join";
	}
	
	//회원가입
	@PostMapping("join.kh")
	public String join(Member member) {
		int result = memberService.join(member);
		if(result > 0) {
			return "redirect:/";
		}else{
			return "member/joinFail";
		}		
	}
	
	//아이디 중복체크
	@GetMapping("idDuplChk.kh")
	@ResponseBody
	public String idDuplChk(String userId) {
		int cnt = memberService.idDuplChk(userId);
		return String.valueOf(cnt);
	}
	
	//닉네임 중복체크
	@GetMapping("nickDuplChk.kh")
	@ResponseBody
	public String nickDuplChk(String userNickname) {
		int cnt = memberService.nickDuplChk(userNickname);
		return String.valueOf(cnt);
	}
	
	//전화번호 중복체크
	@GetMapping("phoneDuplChk.kh")
	@ResponseBody
	public String phoneDuplChk(String userPhone) {
		int cnt = memberService.phoneDuplChk(userPhone);
		return String.valueOf(cnt);
	}
	
	
	// api 회원가입
	// addFlashAttribute로 보낸 데이터를 받기 위한 어노테이션 선언
	@PostMapping("apiJoin.kh")
	public String apiJoin(@ModelAttribute("naverUser") Member member) {
		int result = memberService.apiJoin(member);
		if(result > 0) {
			return "redirect:/";
		}else{
			return "member/joinFail";
		}		
	}
	// 검색 Frm
	@GetMapping("search.kh")
	public String searchFrm(HttpSession session, Model model) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
	        return "redirect:/"; // 로그인 안 된 경우
	    }
		int userNo = loginMember.getUserNo();

	    ArrayList<Search> searchHistory = memberService.selectSearchHistoryList(userNo);
	    
	    model.addAttribute("searchs", searchHistory);
		
		return "member/search";
	}
	
	// 메시지 Frm 
	@GetMapping("message.kh")
	public String messageFrm() {
		return "member/message";
	}
	
	//메인피드 Frm
	@GetMapping("mainFeed.kh")
	public String mainFeedFrm(HttpSession session, Model model) {
		Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/";
        }
        int userNo = loginMember.getUserNo();
        ArrayList<Member> recommendList = followService.recommendFriends(userNo);
        model.addAttribute("friendList", recommendList != null ? recommendList : new ArrayList<>());
        return "member/mainFeed";
	}
	
	//검색 기록
	@GetMapping("searchHistory.kh")
	public String searchHistory(HttpSession session,String searchType, String search,String hashName, String userName, String vals, Model model) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
	        return "redirect:/"; // 로그인 안 된 경우
	    }
		
		int userNo = loginMember.getUserNo();
		if(search != null) {
			memberService.updateSearchHistory(userNo,searchType,search);
			
	        model.addAttribute("search", search); // 검색어를 모델에 추가
	        
	        // 검색 결과 페이지로 이동
	        return "member/searchResult"; // 검색 결과 페이지로 이동
			
		}else if(hashName != null) {
			 // 해시태그를 사용하여 검색 기록을 업데이트
	        memberService.updateSearchHistory(userNo,searchType,hashName); // 해시태그 기록 업데이트 메소드 호출
	       
	        HashTag hashTag = memberService.selectTagName(hashName);
			
			int start = 0;
	        int end = 15;
	        ArrayList<HashTag> initPosts = (ArrayList<HashTag>) memberService.selectHashTagPosts(hashName, start, end);
			model.addAttribute("post", initPosts);
			model.addAttribute("hashName", hashName);
	        // 해시태그 페이지로 이동
	        return "member/hashTagPostList"; // 해시태그 페이지로 이동
	        
		}else if(userName!= null) {
			 // 사용자 이름을 사용하여 검색 기록을 업데이트
	        memberService.updateSearchHistory(userNo, searchType,userName); // 사용자 이름 기록 업데이트 메소드 호출
	        
	        
	        Member member = memberService.selectKeywordUser(userName);
	        
			// 내 프로필 조회 시
			if (loginMember.getUserId().equals(member.getUserId())) {
				int followerCount = followService.getFollowerCount(userNo); // 나를 팔로우하는 사람 수
				int followingCount = followService.getFollowingCount(userNo); // 내가 팔로우하는 사람 수
				
				ArrayList<Post> postData = postService.postData(userNo); // 내가 작성한 글
				ArrayList<Mypet> mypets = memberService.selectMyPetList(userNo);
				
				model.addAttribute("member", loginMember);
				model.addAttribute("mypetList", mypets);
				model.addAttribute("post", postData);
				model.addAttribute("followerCount", followerCount);
				model.addAttribute("followingCount", followingCount);

				return "member/myFeed";
			}
	        
			int targetUserNo = memberService.selectUser(member.getUserId()); //상대방 No값
			// 내가 상대방(targetNo)을 팔로우하고 있는지 여부를 DB에서 조회한 결과
			int myFollowCount   = followService.selectCheckFollor(userNo, targetUserNo);
			
			//상대방(targetNo)이 나를 팔로우하고 있는지 여부를 DB에서 조회한 결과
	        int theyFollowCount = followService.selectCheckFollor(targetUserNo, userNo);

	        //상대방의 팔로잉/팔로워 수
	        //(해당 프로필 주인의 userNo=targetUserNo 로 조회)
	        int followerCount  = followService.getFollowerCount(targetUserNo);  // 나를 팔로우하는 사람 수
	        int followingCount = followService.getFollowingCount(targetUserNo); // 내가 팔로우 중인 사람 수

	        ArrayList<Mypet> mypets = memberService.selectMyPetList(targetUserNo);
	        ArrayList<Post> postData = postService.postData(targetUserNo);
	        
	        
			model.addAttribute("mypetList", mypets);
	        model.addAttribute("member", member);
	        model.addAttribute("post", postData);
	        model.addAttribute("followerCount", followerCount);
	        model.addAttribute("followingCount", followingCount);
			model.addAttribute("myFollowCount", myFollowCount);
			model.addAttribute("theyFollowCount", theyFollowCount);
			
	        // 사용자 프로필 페이지로 이동
	        return "member/userProfile"; // 사용자 프로필 페이지로 이동
	        
		}else {
			return "redirect:/"; // 기본 페이지로 리다이렉트
		}
		
	}
	
	@PostMapping("deleteSearchHistory.kh")
	@ResponseBody
	public String deleteSearchHistory(String search, String searchType, HttpSession session) {
	    Member loginMember = (Member) session.getAttribute("loginMember");

	    if (loginMember == null) {
	    	return "redirect:/"; // 로그인 안 된 경우
	    }
	    
	    int result = 0;
	    
	    int userNo = loginMember.getUserNo();
	    if ("all".equals(search)) { //전체 삭제 눌렀을때
	    	result = memberService.deleteAllSearchHistory(userNo);
	    }else {
	    	result = memberService.deleteSearchHistory(userNo, search, searchType); // 검색 기록 삭제 메서드 호출	    	
	    }
	    
	    if(result > 0) { 
	    	return "redirect:/member/search";
	    }else {
	    	return "redirect:/"; // 로그인 안 된 경우
	    }
	}
	
	
	
	// 실시간 검색
	// value랑 produces 안해주면 인코딩 문제생김
	@GetMapping(value = "searchBoard.kh", produces = "text/html; charset=UTF-8") 
	@ResponseBody
	public String inputSearch(@RequestParam("search") String search, Model model) {
	    ArrayList<Member> users = memberService.searchUser(search);
	    ArrayList<HashTag> tags;
	    
	    //#으로 시작하고 #뒤에 값이 없으면 
	    if(search.charAt(0) == '#' && search.length() > 1) { // #으로 시작하고 #뒤에 값이 있으면
	    	String searchStr = search.replace("#", ""); // # 제거
	    	tags = memberService.searchTag(searchStr);
	    	
	    } else {
	    	 tags = new ArrayList<>(); // 검색어가 #으로 시작하지 않으면 태그 검색 안함
	    }
	    
	    if (tags.isEmpty() && users.isEmpty()) {
	        return "<div class='user-result'>"
	        		+ "<span id='search-result'>검색 결과가 없습니다.</span>"
	        		+ "</div>"; //관련 검색이 없을때 보여줌
	    }
	    
	    StringBuilder html = new StringBuilder(); //HTML 코드 생성
	    // 해시태그 결과 먼저 추가
        if (!tags.isEmpty()) {
        	
            for (HashTag tag : tags) {
            	//#은 페이지 내 위치를 나타내는 특수문자라 서버로 전달되지 않기때문에 enconding 해줘야됨
                html.append("<li class='user-result'>")
                    .append("<a class='a-user' href='/member/keywordResult.kh?hashName=")
                    .append(tag.getHashName()) // HashTag 객체의 hashName 사용
                    .append("&vals=x")
                    .append("'>")
                    .append("<div class='hash-container'>")
                    .append("<div class='tag-profile'>")
                    .append("<svg xmlns=\"http://www.w3.org/2000/svg\" height=\"24px\" viewBox=\"0 -960 960 960\" width=\"24px\" fill=\"black\">")
                    .append("<path d=\"m240-160 40-160H120l20-80h160l40-160H180l20-80h160l40-160h80l-40 160h160l40-160h80l-40 160h160l-20 80H660l-40 160h160l-20 80H600l-40 160h-80l40-160H360l-40 160h-80Zm140-240h160l40-160H420l-40 160Z\"/>")
                    .append("</svg>")
		            .append("</div>")
		            .append("<div class='tag-span'>")
                    .append("<span class='tagName'>")
                    .append(tag.getHashName())
                    .append("</span>")
                    .append("<span class='tagPostCount'>게시글 : ")
                    .append(tag.getPostCount())
                    .append("</span>")
                    .append("</div>")
                    .append("</div>")
                    .append("</a>")
                    .append("</li>");
            }
        }
        if (!users.isEmpty()) {
		    for(Member m : users) { //forEach
		        html.append("<li class='user-result'>")
		            .append("<a class='a-user' href='/member/keywordResult.kh?userName=")
		            .append(m.getUserNickname())
		            .append("&vals=x")
		            .append("'>")
		            .append("<div class='profile-container'>")
		            .append("<div class='user-profile'>")
		            .append("<img class='profileImage' src='")
		            .append((m.getUserImage() != null && !m.getUserImage().isEmpty()) ? m.getUserImage() : "/resources/profile_file/default_profile.png")
		            .append("'alt='프로필 이미지' />")
		            .append("</div>")
		            .append("<span>")
		            .append(m.getUserNickname())
		            .append("/")
		            .append(m.getUserId())
		            .append("</span>")
		            .append("</div>")
		            .append("</a>")
		            .append("</li>");
		        
		       
		    }
        }
	    return html.toString(); // HTML 문자열 반환
	}
	

	//검색 결과(검색 기록 업데이트 및 등록)
	@GetMapping(value = "keywordSearch.kh", produces = "text/html; charset=UTF-8")
	public String searchPage(@RequestParam("search") String search, Model model, HttpSession session,
			@RequestParam(value = "vals", required = false) String vals) {//검색 결과에서 원하는 검색 값을 a태그로 이동했을때 값이 담겨있고 아닌경우 x로 표시 
		Member loginMember = (Member) session.getAttribute("loginMember");

	    if (loginMember == null) {
	        return "redirect:/"; // 로그인 안 된 경우
	    }

	    int userNo = loginMember.getUserNo();
	    String searchType = "G"; // 일반 검색
	    String userId = null;

	    // 검색어가 이미 존재하는지 체크
	    int exists = memberService.checkKeyword(userNo, search);
	    if (exists > 0) {
	        // 이미 존재하면 날짜만 업데이트
	        memberService.updateKeywordDate(userNo, searchType, userId, search);
	    } else {
	        // 존재하지 않으면 새로 삽입
	        memberService.insertKeyword(userNo, searchType, userId, search);
	    }

	    model.addAttribute("search", search);
	    model.addAttribute("m", vals);
	    // 검색 결과 페이지로 이동
	    return "member/searchResult";
	}
	
	// API 연동 끊기 및 탈퇴 메소드 호출
	@GetMapping("userUnlink.kh")
	public String userUnlink(HttpSession session) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		String userType = loginMember.getUserType();
			
		// 회원가입 경로에 따른 탈퇴 절차
		if(userType != null && userType.equals("K")) {
			return "redirect:/kakao/kakaoUnlink.kh";
		}else if(userType != null && userType.equals("N")) {
			return "redirect:/naver/naverUnlink.kh";
		}else {
			return "redirect:/member/userDelete.kh";
		}
	}

	// 회원 탈퇴
	@GetMapping("userDelete.kh")
	public String userDelete(HttpSession session) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		int result = memberService.userDelete(loginMember.getUserId());
		if (result > 0) {
			return "redirect:/member/logout.kh";
		} else {
			return "member/deleteFail";
		}
	}
	
	//결과 페이지에서 사용자가 원하는 검색만 보기 위한 필터
	@GetMapping(value = "filterResults.kh", produces = "text/html; charset=UTF-8")
	@ResponseBody
	public String filterResults(@RequestParam("filterType") String filterType,
								@RequestParam("search") String search,
								@RequestParam(value="page", defaultValue="1") int page) {
		final int pageSize = 12;
		StringBuilder html = new StringBuilder();

		switch (filterType) {
		case "hashtag":
			// 해시태그 데이터 가져오기
			List<HashTag> hashtags = memberService.searchHashTagsKeyword(search, page, pageSize);
			if((hashtags.isEmpty())) {
				return "";
			}else {
				for (HashTag tag : hashtags) {
					html.append("<li class='user-result'>")
		                .append("<a class='a-user' href='/member/keywordResult.kh?hashName=")
		                .append(tag.getHashName()) // HashTag 객체의 hashName 사용
		                .append("&vals=")
			            .append(search)
		                .append("'>")
		                .append("<div class='hash-container'>")
		                .append("<div class='tag-profile'>")
		                .append("<svg xmlns=\"http://www.w3.org/2000/svg\" height=\"24px\" viewBox=\"0 -960 960 960\" width=\"24px\" fill=\"black\">")
		                .append("<path d=\"m240-160 40-160H120l20-80h160l40-160H180l20-80h160l40-160h80l-40 160h160l40-160h80l-40 160h160l-20 80H660l-40 160h160l-20 80H600l-40 160h-80l40-160H360l-40 160h-80Zm140-240h160l40-160H420l-40 160Z\"/>")
		                .append("</svg>")
			            .append("</div>")
			            .append("<div class='tag-span'>")
		                .append("<span class='tagName'>")
		                .append(tag.getHashName())
		                .append("</span>")
		                .append("<span class='tagPostCount'>게시글 : ")
		                .append(tag.getPostCount())
		                .append("</span>")
		                .append("</div>")
		                .append("</div>")
		                .append("</a>")
		                .append("</li>");
				}
			}
			break;
		case "user":
			// 유저 데이터 가져오기
			List<Member> users = memberService.searchUsersKeyword(search, page, pageSize);
			if(users.isEmpty()) {
				return "";
			}else {
				for (Member user : users) {
					html.append("<li class='user-result'>")
					.append("<a class='a-user' href='/member/keywordResult.kh?userName=")
					.append(user.getUserNickname())
					.append("&vals=")
					.append(search)
					.append("'>")
					.append("<div class='profile-container'>")
					.append("<div class='user-profile'>")
					.append("<img class='profileImage' src='")
					.append((user.getUserImage() != null && !user.getUserImage().isEmpty()) ? user.getUserImage() : "/resources/profile_file/default_profile.png")
					.append("' alt='프로필 이미지' />")
					.append("</div>")
					.append("<span>")
					.append(user.getUserNickname())
					.append("/")
					.append(user.getUserId())
					.append("</span>")
					.append("</div>")
					.append("</a>")
					.append("</li>");
				}				
			}
			break;
		default:
			html.append("<p>유효하지 않은 필터입니다.</p>");
			break;
		}

		return html.toString();
	}
	
	//검색 창에서 a 링크 클릭 시 기록 남기는 용도(이거 안쓰면 피드에서 a 링크 눌러도 검색 기록으로 처리됨)
	//required
	@GetMapping("keywordResult.kh")
	public String keywordResult( 
			@RequestParam(value = "hashName", required = false) String hashName,
	        @RequestParam(value = "userName", required = false) String userName, //유저 이름
	        @RequestParam(value = "vals", required = false) String vals, //검색 결과에서 원하는 검색 값을 a태그로 이동했을때 값이 담겨있고 아닌경우 x로 표시 
	        HttpSession session, Model model) {

		Member loginMember = (Member) session.getAttribute("loginMember");

		if (loginMember == null) {
			return "redirect:/"; // 로그인 안 된 경우
		}

		int userNo = loginMember.getUserNo();

		String searchType = null; // 이게 User검색인지 HashTag 검색인지 일반 검색인지 구분해주는 값
		String userId = null; // user Name값
		String keyword = null;
		
		/*
		if ("x".equals(vals)) {
			val = "x";
		} else {
			val = vals;
		}
	    */
		
		if (hashName != null && !hashName.isEmpty()) {
			searchType = "H";
			keyword = hashName; // 해시태그
		} else if (userName != null && !userName.isEmpty()) {
			searchType = "U";
			userId = userName;
			keyword = userName; // 유저 닉네임으로 검색
		} else {
			return "redirect:/member/search";
		}
		 // 1. 새로운 키워드가 이미 존재하는지 체크
	    int exists = memberService.checkKeyword(userNo, keyword);
	    if(exists > 0) {
	        // 이미 존재하면 삭제
	        memberService.deleteKeyword(userNo, keyword);
	    }

	    // 2. 기존 검색어(vals)가 있는 경우 삭제
	    if(vals != null && !"x".equals(vals)) {
	        memberService.deleteKeyword(userNo, vals);
	    }
	    // 3. 새로운 키워드 insert
	    int result = memberService.insertKeyword(userNo, searchType, userId, keyword);
		
		if("H".equals(searchType)) { //타입이 해시태그(H)일때
			HashTag hashTag = memberService.selectTagName(hashName);
			// 처음 15개만 가져오기 (start=0, end=15)
	        int start = 0;
	        int end = 15;
	        ArrayList<HashTag> initPosts = (ArrayList<HashTag>) memberService.selectHashTagPosts(hashName, start, end);

	        // JSP로 데이터 전달
	        model.addAttribute("hashTag", hashTag);
	        model.addAttribute("hashName", hashName);
	        model.addAttribute("post", initPosts);

	        return "member/hashTagPostList";
			
		}else if("U".equals(searchType)){ //타입이 유저(U)일때
			Member member = memberService.selectKeywordUser(userName);
			
			// 내 프로필 조회 시
			if(loginMember.getUserId().equals(member.getUserId())){
				int followerCount  = followService.getFollowerCount(userNo);  // 나를 팔로우하는 사람 수
				int followingCount = followService.getFollowingCount(userNo); // 내가 팔로우하는 사람 수
				
				ArrayList<Post> postData = postService.postData(userNo); // 내가 작성한 글 
				ArrayList<Mypet> mypets = memberService.selectMyPetList(userNo);
				
				model.addAttribute("member", loginMember);
				model.addAttribute("mypetList", mypets);
				model.addAttribute("post", postData);
				model.addAttribute("followerCount", followerCount);
				model.addAttribute("followingCount", followingCount);

				return "member/myFeed";
			}

			// 내가 상대방(targetNo)을 팔로우하고 있는지 여부를 DB에서 조회한 결과
			int targetUserNo = memberService.selectUser(member.getUserId()); //상대방 No값
			// 내가 상대방(targetNo)을 팔로우하고 있는지 여부를 DB에서 조회한 결과
			int myFollowCount   = followService.selectCheckFollor(userNo, targetUserNo);
			
			//상대방(targetNo)이 나를 팔로우하고 있는지 여부를 DB에서 조회한 결과
	        int theyFollowCount = followService.selectCheckFollor(targetUserNo, userNo);
	        
	        //상대방의 팔로잉/팔로워 수
	        //(해당 프로필 주인의 userNo=targetUserNo 로 조회)
	        int followerCount  = followService.getFollowerCount(targetUserNo);  // 나를 팔로우하는 사람 수
	        int followingCount = followService.getFollowingCount(targetUserNo); // 내가 팔로우하는 사람 수
	        ArrayList<Mypet> mypets = memberService.selectMyPetList(targetUserNo);
	        ArrayList<Post> postData = postService.postData(targetUserNo);
	        
			model.addAttribute("mypetList", mypets);
			model.addAttribute("member", member);
			model.addAttribute("post", postData);
			model.addAttribute("myFollowCount", myFollowCount);
			model.addAttribute("theyFollowCount", theyFollowCount);
			model.addAttribute("followerCount", followerCount);
			model.addAttribute("followingCount", followingCount);
			
			return "member/userProfile";
			
		}else { // 둘다 해당 안될때
			return "redirect:/"; // 로그인 안 된 경우
		}
	}
	
	
	
	// 프로필 수정
	@PostMapping(value="updateProfile.kh", produces="application/json; charset=utf-8")
	@ResponseBody
	public Member updateProfile(HttpServletRequest request, MultipartFile file, Member member,
			HttpSession session, @RequestParam(required = false) boolean delChk) {
		
		if (file != null && !file.isEmpty()) {
			String savePath = request.getSession().getServletContext().getRealPath("/resources/profile_file/");
			String originalFileName = file.getOriginalFilename();
			String fileName = originalFileName.substring(0, originalFileName.lastIndexOf("."));
			String extension = originalFileName.substring(originalFileName.lastIndexOf("."));

			String toDay = new SimpleDateFormat("yyyyMMdd").format(new Date());
			int ranNum = new Random().nextInt(10000) + 1;
			String filePath = fileName + "_" + toDay + "_" + ranNum + extension;

			savePath += filePath;
			member.setUserImage("/resources/profile_file/" + filePath);

			// 파일 업로드를 위한 보조스트림
			BufferedOutputStream bos = null;

			try {
				byte[] bytes = file.getBytes();
				FileOutputStream fos = new FileOutputStream(new File(savePath));
				bos = new BufferedOutputStream(fos);
				bos.write(bytes);

			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				try {
					if (bos != null) bos.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		if(delChk) {
			member.setUserImage("");
		}
		
		Member loginMember =  (Member) session.getAttribute("loginMember");
		member.setUserPw(loginMember.getUserPw());
		
		int result = memberService.updateProfile(member);
		
		if (result > 0) {
			// 업데이트 성공 시, 최신 회원 정보를 반환
			Member updatedMember = memberService.memberLogin(member);
			
			session.setAttribute("loginMember", updatedMember); // 세션 업데이트
			return updatedMember;
		} else {
			return null;
		}
	}
	
	// 비밀번호 수정
	@PostMapping(value="updatePassword.kh", produces="application/json; charset=utf-8")
	@ResponseBody
	public int updatePassword(HttpSession session, Member member,
			@RequestParam(required = false) String userNewPw) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		loginMember.setUserPw(member.getUserPw());
		
		// 입력받은 비밀번호와 일치하는 회원 존재 여부 확인
		Member chkMember = memberService.memberLogin(loginMember);
		
		if(chkMember != null) {
			// chkMember에 새 비밀번호 세팅
			chkMember.setUserPw(userNewPw);
			// 일치하는 회원 존재 비밀번호 업데이트
			int result = memberService.updatePassword(chkMember);
			
			if(result > 0) {
				// 비밀번호 변경완료 시
				session.invalidate();
				return 2;
			}else {
				// 비밀번호 변경실패 시
				return 1;
			}
		}else {
			// 비밀번호가 일치하지 않을 시
			return 0;
		}
	}
	
	//아이디 비밀번호 찾기
	@PostMapping(value = "find.kh", produces = "application/json; charset=utf-8")
	@ResponseBody
	public String findUserId(@RequestParam("email") String email, @RequestParam("phone") String phone,
			@RequestParam("userId") String userId, @RequestParam("actionType") String actionType) {
		if ("findId".equals(actionType)) {
			String userIds = memberService.findUserId(email, phone);
			if (userIds != null) {
				return "가입한 아이디는: " + userIds;
			} else { 
				return "해당 정보로 가입된 아이디가 없습니다."; 
			}
			
		} else if ("findPassword".equals(actionType)) {
			String checkuser = memberService.selectPwUser(userId, email);
			if (checkuser != null) {
				String newPw = generateRandomPassword();
				int result = memberService.replaceMemberPw(userId, newPw);
				if (result > 0) {
					sendEmail(email, newPw);
					return "임시 비밀번호가 이메일로 발송되었습니다.";
				} else {
					return "비밀번호 업데이트에 실패했습니다.";
				}
			} else {
				return "해당 정보로 가입된 아이디가 없습니다.";
			}
		}
		return "유효하지 않은 요청입니다.";
	}

	// 랜덤 비밀번호 생성 메서드
	private String generateRandomPassword() {
		String upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		String lower = "abcdefghijklmnopqrstuvwxyz";
		String digit = "0123456789";
		String special = "!@#$";
		String allStr = upper + lower + digit + special;

		SecureRandom random = new SecureRandom();
		StringBuilder ranPw = new StringBuilder();

		// 각각 최소 1개 이상은 포함되도록
		ranPw.append(upper.charAt(random.nextInt(upper.length())));
		ranPw.append(lower.charAt(random.nextInt(lower.length())));
		ranPw.append(digit.charAt(random.nextInt(digit.length())));
		ranPw.append(special.charAt(random.nextInt(special.length())));

		for (int i = 0; i < 8; i++) { // 나머지 8자리를 랜덤으로 추가
			ranPw.append(allStr.charAt(random.nextInt(allStr.length())));
		}

		// 임시 비밀번호를 무작위로 섞기
		char[] allChars = ranPw.toString().toCharArray();
		for (int i = 0; i < allChars.length; i++) {
			int ranIdx = random.nextInt(allChars.length);
			char temp = allChars[i];
			allChars[i] = allChars[ranIdx];
			allChars[ranIdx] = temp;
		}

		return new String(allChars);
	}

	// 이메일 전송 메서드
	private void sendEmail(String toEmail, String newPassword) {
		Properties prop = new Properties();
		prop.put("mail.smtp.host", "smtp.naver.com");
		prop.put("mail.smtp.port", "465");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.ssl.enable", "true");
		prop.put("mail.smtp.ssl.trust", "smtp.naver.com");

		// Session 객체 생성
		Session session = Session.getInstance(prop, new javax.mail.Authenticator() {
			@Override
			protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
				
				return new javax.mail.PasswordAuthentication("이메일", "비밀번호"); //발신자
			}
		});

		try {
			MimeMessage msg = new MimeMessage(session);
			msg.setSentDate(new Date());
			msg.setFrom(new InternetAddress("이메일", "댕냥일기")); //발신자
			InternetAddress to = new InternetAddress(toEmail); 
			msg.addRecipient(Message.RecipientType.TO, to); //수신자
			msg.setSubject("임시 비밀번호 발급");
			msg.setContent("임시 비밀번호는 [<span style='color:red;font-weight:bold;'>" + newPassword + "</span>]입니다",
					"text/html; charset=utf-8");
			Transport.send(msg);
		} catch (MessagingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	// 품종 가져오기
    @GetMapping("breedOption.kh")
    @ResponseBody
    public ArrayList<String> breedOption(@RequestParam String petType) {
        ArrayList<String> breedList = memberService.selectBreedType(petType);
        return breedList;
    }
    
    // 내 반려동물 가져오기
    @PostMapping("selectMypet.kh")
    @ResponseBody
    public ArrayList<Mypet> selectMypet (@RequestParam String userNo) {
        ArrayList<Mypet> petList = memberService.selectMypet(userNo);
        return petList;
    }
    
    // 반려동물 추가
    @PostMapping("insertMypet.kh")
    @ResponseBody
    public String insertMypet (Mypet mypet) {
        // 반려동물 중복체크
        int result = memberService.dupChkMypet(mypet);
        
        if(result > 0) {
            // 중복 이름의 반려동물 존재
            return "duplicate";
        }else {
            // 반려동물 6마리 이상 등록 시, 등록 실패
            result = memberService.overChkMypet(mypet);
            
            if(result > 5) {
                return "over";
            }else {
                result = memberService.insertMypet(mypet);
                
                if(result > 0) {
                    return "success";
                } else {
                    return "fail";
                }
            }
            
        }
    }
    
    // 반려동물 삭제
    @PostMapping("deleteMypet.kh")
    @ResponseBody
    public String deleteMypet (Mypet mypet) {
        int result = memberService.deleteMypet(mypet);
        
        if(result > 0) {
            return "success";
        } else {
            return "fail";
        }
        
    }
    
    // 반려동물 수정
    @PostMapping("updateMypet.kh")
    @ResponseBody
    public String updateMypet (Mypet mypet) {
        int result = memberService.updateMypet(mypet);
        
        if(result > 0) {
            return "success";
        } else {
            return "fail";
        }
    }
    
	//유저프로필 이동
	@GetMapping("profile.kh")
	public String profileFrm(@RequestParam("userNo") int userNo, String type, HttpSession session, Model model) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/"; // 로그인 안 된 경우
		}
		
		int myNo = loginMember.getUserNo();

		// 나의 유저 번호가 a링크로 이동한 userNo랑 같을 시
		if (myNo == userNo) {
			int followerCount = followService.getFollowerCount(myNo); // 나를 팔로우하는 사람 수
			int followingCount = followService.getFollowingCount(myNo); // 내가 팔로우하는 사람 수

			ArrayList<Post> postData = postService.postData(myNo); // 내가 작성한 글
			ArrayList<Mypet> mypets = memberService.selectMyPetList(myNo);

			model.addAttribute("member", loginMember);
			model.addAttribute("mypetList", mypets);
			model.addAttribute("post", postData);
			model.addAttribute("followerCount", followerCount);
			model.addAttribute("followingCount", followingCount);

			return "member/myFeed";
		}
		Member member = memberService.searchUserData(userNo);
		// 내가 상대방(targetNo)을 팔로우하고 있는지 여부를 DB에서 조회한 결과
		int myFollowCount = followService.selectCheckFollor(myNo, userNo);

		// 상대방(targetNo)이 나를 팔로우하고 있는지 여부를 DB에서 조회한 결과
		int theyFollowCount = followService.selectCheckFollor(userNo, myNo);

		// 상대방의 팔로잉/팔로워 수
		// (해당 프로필 주인의 userNo=targetUserNo 로 조회)
		int followerCount = followService.getFollowerCount(userNo); // 나를 팔로우하는 사람 수
		int followingCount = followService.getFollowingCount(userNo); // 내가 팔로우하는 사람 수
		ArrayList<Mypet> mypets = memberService.selectMyPetList(userNo);
		ArrayList<Post> postData = postService.postData(userNo);

		model.addAttribute("mypetList", mypets);
		model.addAttribute("member", member);
		model.addAttribute("post", postData);
		model.addAttribute("myFollowCount", myFollowCount);
		model.addAttribute("theyFollowCount", theyFollowCount);
		model.addAttribute("followerCount", followerCount);
		model.addAttribute("followingCount", followingCount);

		return "member/userProfile";
	}

	
	// 작성자 정보 반환 API
	@GetMapping("getUserInfo.kh")
	@ResponseBody
	public Member getUserInfo(@RequestParam("userNo") int userNo) {
	    // userNo로 사용자를 검색
	    Member member = memberService.searchUserData(userNo);
	    
	    // 사용자 정보가 없을 경우 예외 처리
	    if (member == null) {
	        throw new IllegalArgumentException("해당 유저 정보를 찾을 수 없습니다.");
	    }
	    
	    return member;
	}

	
}

