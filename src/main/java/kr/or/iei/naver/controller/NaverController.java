package kr.or.iei.naver.controller;


import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.iei.common.exception.ApiLoginException;
import kr.or.iei.naver.model.service.NaverService;

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
			HttpSession session) {
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
			service.getUserInfo(accessToken);
			
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
