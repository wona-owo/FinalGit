package kr.or.iei.member.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/member/")
public class MemberController {

	public MemberController() {
		super();
	}
		
	
	@PostMapping("login.kh")
	public String memberLogin () {
		
		return "member/mainFeed";
	}
	
	
}
