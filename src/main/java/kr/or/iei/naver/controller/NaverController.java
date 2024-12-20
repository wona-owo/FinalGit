package kr.or.iei.naver.controller;


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
	}

	@GetMapping("callback.kh")
	public String naverLoginCallback(@RequestParam("code") String code, @RequestParam("state") String state,
			HttpSession session, RedirectAttributes redirectAttributes) {
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
			
			// 네이버 회원가입 여부 조회
			Member loginMember = service.naverLoginChk(naverUser);
			
			// 네이버 로그인 시 동일한 이름, 전화번호를 가지고 있는 회원이 가입경로가 다를 경우
			if(loginMember != null && !"N".equals(loginMember.getUserType())) {
				redirectAttributes.addFlashAttribute("loginFailMsg", "다른 경로로 가입된 회원입니다.");
				return "redirect:/";
			// 네이버 로그인 성공
			}else if(loginMember != null && "N".equals(loginMember.getBanYN())) {
				session.setAttribute("loginMember", loginMember);
				return "redirect:/member/mainFeed.kh";
			// 네이버 로그인 시 밴이 되어있을 경우
			}else if(loginMember != null && "Y".equals(loginMember.getBanYN())){
				redirectAttributes.addFlashAttribute("loginFailMsg", "정지된 계정입니다. 관리자에게 문의해주세요.");
				return "redirect:/";
			// 회원이 아닐시 회원가입 페이지로 이동
			}else {
				redirectAttributes.addFlashAttribute("apiUser", naverUser);
				return "redirect:/naver/apiJoin.kh";
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
