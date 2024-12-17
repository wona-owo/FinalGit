package kr.or.iei.member.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.iei.member.model.service.MemberService;
import kr.or.iei.member.model.vo.Member;

@Controller
@RequestMapping("/member/")
public class MemberController {

	@Autowired 
	@Qualifier("service") 
	private MemberService memberService;
	
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
	
	
}
