package kr.or.iei.member.controller;


import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
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
			return "member/mainFeed";
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
	
	//개인피드 Frm
	@GetMapping("myFeedFrm.kh")
	public String myFeedFrm() {
		return "member/myFeed";
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
	public String inputSearch(@RequestParam("searchStr") String searchStr) {
	    ArrayList<Member> users = memberService.searchUser(searchStr);
	    ArrayList<HashTag> tags = memberService.searchTag(searchStr);
	    
	    
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
                    .append("<a class='a-user' href='/member/hashtags.kh?hashName='")
                    .append(tag.getHashName()) // HashTag 객체의 hashName 사용
                    .append("'>")
                    .append("<div class='profile-container'>")
                    .append("<span >")
                    .append(tag.getHashName())
                    .append("</span>")
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
	@GetMapping("userProfile.kh")
	public String userProfile() {
		return "member/userProfile";
	}
}
