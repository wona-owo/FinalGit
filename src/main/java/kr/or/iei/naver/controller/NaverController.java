package kr.or.iei.naver.controller;


import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.iei.common.exception.ApiLoginException;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.naver.model.service.NaverService;
import kr.or.iei.naver.model.vo.NaverUser;

@Controller
@RequestMapping("/naver/")
public class NaverController {

	@Autowired
	@Qualifier("naverService")
	private NaverService service;

	@GetMapping("login.kh")
	public String naverLogin(HttpSession session) {
		String apiURL = service.naverLogin(session);
		return "redirect:" + apiURL;
	};

	@GetMapping("callback.kh")
	public String naverLoginCallback(@RequestParam("code") String code, @RequestParam("state") String state,
			HttpSession session, RedirectAttributes redirectAttributes, Model model) {
		// State 검증
        String sessionState = (String) session.getAttribute("oauth_state");
        if (sessionState == null || !sessionState.equals(state)) {
        	System.out.println("state값 불일치");
            return "redirect:/";
        }
        
		try {
			// 액세스 토큰 요청
			String tokenResponse = service.getAccessToken(code, state);
			ObjectMapper mapper = new ObjectMapper();
			JsonNode tokenJson = mapper.readTree(tokenResponse);
			String accessToken = tokenJson.get("access_token").asText();
			
			// 유저 정보 조회
			NaverUser naverUser = service.getUserInfo(accessToken);
			
			// 네이버 회원가입 여부 확인
			Member loginMember = service.naverLoginChk(naverUser);
			
			if(loginMember != null && "N".equals(loginMember.getBanYN())) {
				session.setAttribute("loginMember", loginMember);
				return "member/mainFeed";
			}else if(loginMember != null && "Y".equals(loginMember.getBanYN())){
				redirectAttributes.addFlashAttribute("loginFailMsg", "정지된 계정입니다. 관리자에게 문의해주세요.");
				return "redirect:/index.jsp";	
			}else {
				model.addAttribute("apiUser", naverUser);
				return "member/apiJoin";
			}
			
		} catch (ApiLoginException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "redirect:/";
	};
	
}
