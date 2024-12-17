package kr.or.iei.member.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
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
	
	public MemberController() {
		super();
	}
		
	
	@PostMapping("login.kh")
	public String memberLogin () {
		
		return "member/mainFeed";
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
			return "redirect :/";
		}else{
			return "member/joinFail";
		}		
	}
	
}
