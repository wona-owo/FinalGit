package kr.or.iei.kakao.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.iei.common.exception.ApiLoginException;
import kr.or.iei.kakao.model.service.KakaoService;
import kr.or.iei.kakao.model.vo.KakaoUser;
import kr.or.iei.member.model.vo.Member;

@Controller
@RequestMapping("/kakao/")
public class KakaoController {

	@Autowired
	@Qualifier("kakaoService")
	private KakaoService service;
	
	@GetMapping("login.kh")
	public String kakoLogin(HttpSession session) {
		String apiURL = service.kakaoLogin(session);
		return "redirect:" + apiURL;
	}
	
	@GetMapping("callback.kh")
	public String kakaoLoginCallback(@RequestParam("code") String code, @RequestParam("state") String state,
			HttpSession session, RedirectAttributes redirectAttributes) {
		String sessionState = (String) session.getAttribute("oauth_state");
		if (sessionState == null || !sessionState.equals(state)) {
        	System.out.println("state값 불일치");
            return "redirect:/";
        }
		
		try {
			String tokenResponse = service.getAccessToken(code, state);
			ObjectMapper mapper = new ObjectMapper();
			JsonNode tokenJson = mapper.readTree(tokenResponse);
			String accessToken = tokenJson.get("access_token").asText();
			
			KakaoUser kakaoUser = service.getUserInfo(accessToken);
			
			Member loginMember = service.kakaoLoginChk(kakaoUser);
				
			if(loginMember != null && !"K".equals(loginMember.getUserType())) {
				redirectAttributes.addFlashAttribute("loginFailMsg", "이미 가입된 회원입니다.");
				return "redirect:/";
			}else if(loginMember != null && "N".equals(loginMember.getBanYN())) {
				session.setAttribute("loginMember", loginMember);
				return "redirect:/member/mainFeed.kh";
			}else if(loginMember != null && "Y".equals(loginMember.getBanYN())) {
				redirectAttributes.addFlashAttribute("loginFailMsg", "정지된 계정입니다. 관리자에게 문의해주세요.");
				return "redirect:/";
			}else {
				// 회원이 아닐시 회원가입 페이지로 이동
				redirectAttributes.addFlashAttribute("apiUser", kakaoUser);
				return "redirect:/kakao/apiJoin.kh";
			}
		} catch (ApiLoginException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "redirect:/";
	}
	
	@GetMapping("apiJoin.kh")
	public String apiJoin() {
		return "member/apiJoin";
	}
}
