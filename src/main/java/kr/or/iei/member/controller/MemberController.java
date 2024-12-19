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
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.iei.member.model.service.MemberService;
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
	public String memberLogin (Member member,HttpSession session, Model model) {
		
		Member loginMember = memberService.memberLogin(member);
		
		if(loginMember != null && "N".equals(loginMember.getBanYN())) {
			session.setAttribute("loginMember", loginMember);
			return "member/mainFeed";
		}else if(loginMember != null && "Y".equals(loginMember.getBanYN())){
			model.addAttribute("loginFailMsg", "정지된 계정입니다. 관리자에게 문의해주세요.");
			return "forward:/index.jsp";			
		}else {
			model.addAttribute("loginFailMsg", "로그인에 실패했습니다. ID와 비밀번호를 확인해주세요.");
			return "forward:/index.jsp";	
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
	
	@PostMapping("searchBoard.kh")
	@ResponseBody
	public String inputSearch(String searchStr, Model model) {
		ArrayList<Member> users = memberService.searchUser(searchStr);
		if (users.isEmpty()) {
			return "<div class='user-result'>검색 결과가 없습니다.</div>";
		}
		model.addAttribute("user", users);
		StringBuilder html = new StringBuilder();
		for (Member m : users) {
			html.append("<div class='user-result'>").append("<a href='/member/userView.kh?userNo=")
				.append(m.getUserNo()).append("'>").append(m.getUserNickname()).append("</a>").append("</div>");
		}
		return html.toString();
	}
}
