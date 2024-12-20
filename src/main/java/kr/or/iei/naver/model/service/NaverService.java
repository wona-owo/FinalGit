package kr.or.iei.naver.model.service;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.iei.common.exception.ApiLoginException;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.naver.model.dao.NaverDao;
import kr.or.iei.naver.model.vo.NaverUser;

@Service("naverService")
public class NaverService {
	
	@Autowired
	@Qualifier("naverDao")
	private NaverDao dao;
	
	private static final String NAVER_CLIENT_ID = "R7uvrgzkvgtjc54icJns";
	private static final String NAVER_CLIENT_SECRET = "UYxdNxkprV";
	private static final String NAVER_REDIRECT_URI = "http://localhost/naver/callback.kh";
	private static final String NAVER_TOKEN_URL = "https://nid.naver.com/oauth2.0/token";
    private static final String NAVER_USERINFO_URL = "https://openapi.naver.com/v1/nid/me";
	
    // 네이버 로그인 페이지로 이동
	public String naverLogin(HttpSession session) {
		String state = UUID.randomUUID().toString();
		session.setAttribute("oauth_state", state);
		String apiURL = "";
		
		apiURL = "https://nid.naver.com/oauth2.0/authorize" 
			   + "?response_type=code" 
			   + "&client_id=" + NAVER_CLIENT_ID
			   + "&redirect_uri=" + URLEncoder.encode(NAVER_REDIRECT_URI, StandardCharsets.UTF_8)
			   + "&state=" + state;
		return apiURL;
	}

	// 네이버 로그인 토큰 가져오기
	public String getAccessToken(String code, String state) {
		String params = "grant_type=authorization_code"
					  + "&client_id=" + NAVER_CLIENT_ID
					  + "&client_secret=" + NAVER_CLIENT_SECRET
					  + "&redirect_uri=" + URLEncoder.encode(NAVER_REDIRECT_URI, StandardCharsets.UTF_8)
					  + "&code=" + code
					  + "&state=" + state;
		
		HttpPost post = new HttpPost(NAVER_TOKEN_URL);
        post.setEntity(new StringEntity(params, StandardCharsets.UTF_8));
        post.setHeader("Content-Type", "application/x-www-form-urlencoded");
        
        try(CloseableHttpClient client = HttpClients.createDefault();
        	CloseableHttpResponse response = client.execute(post)) {
			return EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			throw new ApiLoginException("Failed to get access token from Naver", e);
		}
	}

	// 네이버 유저 정보 가져오기
	public NaverUser getUserInfo(String accessToken) {
		HttpPost post = new HttpPost(NAVER_USERINFO_URL);
		post.setHeader("Authorization", "Bearer " + accessToken);
		NaverUser naverUser = new NaverUser();
		
		try (CloseableHttpClient client = HttpClients.createDefault();
	             CloseableHttpResponse response = client.execute(post)) {
			String userInfoResponse = EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);
			ObjectMapper mapper = new ObjectMapper();
	        JsonNode userInfoJson = mapper.readTree(userInfoResponse);
	        JsonNode responseNode = userInfoJson.get("response");
	        
	        // 가져온 User정보를 객체로 저장
	        String name = responseNode.get("name").asText(); 
	        String email = responseNode.get("email").asText();
	        String phone = responseNode.get("mobile").asText();
	        // 일반회원과 아이디 중복을 피하기 위해 앞에 N_를 삽입
	        String id = "N_" + email.split("@")[0];
	        String pw = UUID.randomUUID().toString();
	        
	        naverUser.setApiUserId(id);
	        naverUser.setApiUserPw(pw);
	        naverUser.setApiUserName(name);
	        naverUser.setApiUserEmail(email);
	        naverUser.setApiUserPhone(phone);
	        naverUser.setApiUserType("N");
	            
	        } catch (IOException e) {
	            throw new ApiLoginException("Failed to get user info from Naver", e);
	        }
		return naverUser;
	}
	
	// 네이버 로그인회원이 DB에 존재 여부 확인
	public Member naverLoginChk(NaverUser naverUser) {
		return dao.naverLoginChk(naverUser);
	}
}
