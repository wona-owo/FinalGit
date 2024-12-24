package kr.or.iei.member.controller;


import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.iei.member.model.service.MemberService;
import kr.or.iei.member.model.vo.HashTag;
import kr.or.iei.member.model.vo.Member;
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
	public String searchFrm() {
		return "member/search";
	}
	
	// 메시지 Frm 
	@GetMapping("message.kh")
	public String messageFrm() {
		return "member/message";
	}
	
	//메인피드 Frm
	@GetMapping("mainFeed.kh")
	public String mainFeedFrm() {
		return "member/mainFeed";
	}
	
	// 실시간 검색
	// value랑 produces 안해주면 인코딩 문제생김
	@GetMapping(value = "searchBoard.kh", produces = "text/html; charset=UTF-8") 
	@ResponseBody
	public String inputSearch(@RequestParam("search") String search) {
	    ArrayList<Member> users = memberService.searchUser(search);
	    ArrayList<HashTag> tags;
	    
	    
	    
	    //#으로 시작하고 #뒤에 값이 없으면 
	    if(search.charAt(0) == '#' && "#".equals(search)) { 
	    	tags = new ArrayList<>(); // 빈 리스트로 초기화
	    	
	    } else if(search.charAt(0) == '#' && search.length() > 1) { // #으로 시작하고 #뒤에 값이 있으면
	    	tags = memberService.searchTag(search);
	    	
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
            	String encodedHashName = URLEncoder.encode(tag.getHashName(), StandardCharsets.UTF_8);
                html.append("<li class='user-result'>")
                    .append("<a class='a-user' href='/member/keywordResult.kh?hashName=")
                    .append(encodedHashName) // HashTag 객체의 hashName 사용
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

		int userNo = loginMember.getUserNo();

		int insertKeyword = 0; //등록 확인
		String searchType = "G"; //검색일 경우 G
		String userId = null; 
		String val = null;
		if (vals == null || vals.isEmpty()) { // 검색 결과 페이지로 이돟한 경우 null값이거나 비어있음
			val = "x"; //강제로 문자열 X라는 값 부여
		}

		int updateResult = memberService.updateKeyword(userNo, searchType, val, userId, search); //검색 날짜 최신으로 업데이트
		if (updateResult == 0) {
			insertKeyword = memberService.insertKeyword(userNo, searchType, userId, search); // 검색한 값이 처음인 경우 새롭게 등록

			if (insertKeyword == 0) {
				throw new RuntimeException("키워드 삽입에 실패했습니다."); // 확인용
			}
		}
	    model.addAttribute("search", search);

	    // 검색 결과 페이지로 이동
	    return "member/searchResult";
	}
	@GetMapping("userProfile.kh")
	public String userProfile() {
		return "member/userProfile";
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

	@GetMapping(value = "filterResults.kh", produces = "text/html; charset=UTF-8")
	@ResponseBody
	public String filterResults(@RequestParam("filterType") String filterType,
			@RequestParam("search") String search) {
		StringBuilder html = new StringBuilder();

		switch (filterType) {
		case "post":
			// 게시물 데이터 가져오기
			//ArrayList<Post> posts = postService.searchPostsKeyword(search);
			//for (Post post : posts) {
				
			//}
			break;

		case "hashtag":
			// 해시태그 데이터 가져오기
			ArrayList<HashTag> hashtags = memberService.searchHashTagsKeyword(search);
			for (HashTag tag : hashtags) {
				String encodedHashName = URLEncoder.encode(tag.getHashName(), StandardCharsets.UTF_8);
				html.append("<li class='user-result'>")
	                .append("<a class='a-user' href='/member/keywordResult.kh?hashName=")
	                .append(encodedHashName) // HashTag 객체의 hashName 사용
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
			break;

		case "user":
			// 유저 데이터 가져오기
			ArrayList<Member> users = memberService.searchUsersKeyword(search);
			for (Member user : users) {
				html.append("<li class='user-result'>")
		            .append("<a class='a-user' href='/member/keywordResult.kh?userName=")
		            .append(user.getUserNickname())
		            .append("&vals=")
		            .append(search)
		            .append("'>")
		            .append("<div class='profile-container'>")
		            .append("<div class='user-profile'>")
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
	@ResponseBody
	public String keywordResult( 
			@RequestParam(value = "hashName", required = false) String hashName,
	        @RequestParam(value = "userName", required = false) String userName, //유저 이름
	        @RequestParam(value = "vals", required = false) String vals, //검색 결과에서 원하는 검색 값을 a태그로 이동했을때 값이 담겨있고 아닌경우 x로 표시 
	        HttpSession session, Model model) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		int userNo = loginMember.getUserNo();
		
		String searchType = null; //이게 User검색인지 HashTag 검색인지 일반 검색인지 구분해주는 값
		String userId = null; //user Name값
		String val = null;
		Member member = memberService.selectKeywordUser(userName);
		
		ArrayList<HashTag> hash = memberService.selectKeywordTag(hashName); //어차피 a태그 눌렀을때 검색 기록 등록 수정 목적으로 하는거라 여기에 선언함
		
		int result = 0; //값 정상적으로 들어갔나 확인용
		
		if (hashName != null && !hashName.isEmpty() && "x".equals(vals)) { //해시태그 값이 있고 실시간 검색에서 a태그로 페이지를 이동한 경우
			searchType = "H";
			val = vals;
			int updateResult  = memberService.updateKeyword(userNo,searchType,val,userId,hashName);
			if(updateResult == 0) {
				result = memberService.insertKeyword(userNo, searchType, userId, hashName);
				
				if(result == 1) {
					model.addAttribute("hashtags", hash);
					return "member/hashTag";
				}else {
					return "redirect:/"; // 로그아웃 상태일떄나 등록 실패인 경우
				}
			}else {
				model.addAttribute("hashtags", hash);
				return "member/hashTag";
			}
		}else if(hashName != null && !hashName.isEmpty() && !"x".equals(vals)) {//해시태그 값이 있고 검색 결과 페이지에서 a태그로 페이지를 이동한 경우
			searchType = "H";
			val = vals;
			int updateResult  = memberService.updateKeyword(userNo,searchType,val,userId,hashName);
			if(updateResult == 0) {
				result = memberService.insertKeyword(userNo, searchType, userId, hashName);
				
				if(result == 1) {
					model.addAttribute("hashtags", hash);
					return "member/hashTag";
				}else {
					return "redirect:/"; // 로그아웃 상태일떄나 등록 실패인 경우
				}
			}else {
				model.addAttribute("hashtags", hash);
				return "member/hashTag";
			}
		}else if (userName != null && !userName.isEmpty()&& "x".equals(vals)) { //유저 이름 값이 있고 실시간 검색에서 a태그로 페이지를 이동한 경우
			searchType = "U"; 
			userId = userName;
			val = vals;
			int updateResult  = memberService.updateKeyword(userNo,searchType,val,userId,userName);
			
			if(updateResult == 0) {
				result = memberService.insertKeyword(userNo, searchType, userId, userName);

				if (result == 1) {
					model.addAttribute("members", member);
					return "member/userProfile";
				} else {
					return "redirect:/"; // 로그아웃 상태일떄나 등록 실패인 경우
				}
			}else {
				model.addAttribute("members", member);
				return "member/userProfile";
			}
		}else if(userName != null && !userName.isEmpty()&& !"x".equals(vals)) { //유저 이름 값이 있고 검색 결과 페이지에서 a태그로 페이지를 이동한 경우
			searchType = "U"; 
			userId = userName;
			val = vals;
			int updateResult  = memberService.updateKeyword(userNo,searchType,val,userId,userName);
			
			if(updateResult == 0) {
				result = memberService.insertKeyword(userNo, searchType, userId, userName);

				if (result == 1) {
					model.addAttribute("members", member);
					return "member/userProfile";
				} else {
					return "redirect:/"; // 로그아웃 상태일떄나 등록 실패인 경우
				}
			}else {
				model.addAttribute("members", member);
				return "member/userProfile";
			}
			
		}else {
			System.out.println("검색 a 태그 이동 실패 keywordResult.kh으로 매핑 선언한 부분 오류남");
			return "redirect:/"; // 로그아웃 상태일떄 등록, 업데이트 실패인경우 
		}
		
	}
}
