package kr.or.iei.member.controller;


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

@Controller
@RequestMapping("/member/")
public class MemberController {

	@Autowired
	@Qualifier("service")
	private MemberService memberService;
	
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
	@PostMapping(value = "searchBoard.kh", produces = "text/html; charset=UTF-8") 
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
                html.append("<li class='user-result'>")
                    .append("<a class='a-user' href='/member/hashtags.kh?hashName=")
                    .append(tag.getHashName()) // HashTag 객체의 hashName 사용
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
		            .append("<a class='a-user' href='/member/userProfile.kh?userName=")
		            .append(m.getUserName())
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
	public String searchPage(@RequestParam("search") String search, Model model, HttpSession session) {
	    
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		int userNo = loginMember.getUserNo();
		
		int updateResult  = memberService.updateKeyword(userNo, search);
		
		int insertKeyword = 0;
		
		if (updateResult == 0) {
			insertKeyword =	memberService.insertKeyword(userNo, search);
			
			if(insertKeyword == 0) {
				throw new RuntimeException("키워드 삽입에 실패했습니다."); //확인용
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
}
