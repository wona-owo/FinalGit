package kr.or.iei.kakao.model.service;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.iei.common.exception.ApiLoginException;
import kr.or.iei.kakao.model.dao.KakaoDao;
import kr.or.iei.kakao.model.vo.KakaoUser;
import kr.or.iei.member.model.vo.Member;

@Service("kakaoService")
public class KakaoService {

	@Autowired
	@Qualifier("kakaoDao")
	private KakaoDao dao;
	
	private static final String KAKAO_CLIENT_ID = "1d1a27c9d4ee331e3b1e707f8b5494a3";
	private static final String KAKAO_CLIENT_SECRET = "KNWpze0v7fReegQDcVp6Cai76VWcTYQl";
	private static final String KAKAO_REDIRECT_URI = "http://localhost/kakao/callback.kh";
	private static final String KAKAO_TOKEN_URL = "https://kauth.kakao.com/oauth/token";
	private static final String KAKAO_USERINFO_URL = "https://kapi.kakao.com/v2/user/me";
	private static final String KAKAO_UNLINK_URL = "https://kapi.kakao.com/v1/user/unlink";
	
	// 카카오 로그인 페이지로 이동
	public String kakaoLogin(HttpSession session) {
		String state = UUID.randomUUID().toString();
		session.setAttribute("oauth_state", state);
		String apiURL = "";
		
		apiURL = "https://kauth.kakao.com/oauth/authorize"
			   + "?response_type=code"
			   + "&client_id=" + KAKAO_CLIENT_ID
			   + "&redirect_uri=" + URLEncoder.encode(KAKAO_REDIRECT_URI, StandardCharsets.UTF_8)
			   + "&state=" + state;
		return apiURL;
	}

	// 카카오 로그인 토큰 가져오기
	public String getAccessToken(String code, String state) {
		String params = "grant_type=authorization_code"
					  + "&client_id=" + KAKAO_CLIENT_ID
					  + "&client_secret=" + KAKAO_CLIENT_SECRET
					  + "&redirect_uri=" + URLEncoder.encode(KAKAO_REDIRECT_URI, StandardCharsets.UTF_8)
					  + "&code=" + code
					  + "&state=" +state;

		HttpPost post = new HttpPost(KAKAO_TOKEN_URL);
		post.setEntity(new StringEntity(params, StandardCharsets.UTF_8));
		post.setHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
		
		try(CloseableHttpClient client = HttpClients.createDefault();
	        CloseableHttpResponse response = client.execute(post)) {
			return EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			throw new ApiLoginException("Failed to get access token from Kakao", e);
		}
	}

	// 카카오 유저 정보 가져오기
	public KakaoUser getUserInfo(String accessToken) {
		HttpPost post = new HttpPost(KAKAO_USERINFO_URL);
		post.setHeader("Authorization", "Bearer " + accessToken);
		post.setHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
		KakaoUser kakaoUser = new KakaoUser();
		
		try (CloseableHttpClient client = HttpClients.createDefault();
				CloseableHttpResponse response = client.execute(post)) {
			String userInfoResponse = EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);
			ObjectMapper mapper = new ObjectMapper();
	        JsonNode userInfoJson = mapper.readTree(userInfoResponse);
	        JsonNode responseNode = userInfoJson.get("kakao_account");
	            
            // 가져온 User정보를 객체로 저장
            String name = responseNode.get("name").asText(); 
            String email = responseNode.get("email").asText();
            String phone = responseNode.get("phone_number").asText();
                   // kakao에서는 +82 10-0000-0000 형식으로 주기때문에 replaceFirst로 변경
            	   phone = phone.replaceFirst("\\+82\\s*", "0");
            // 일반회원과 아이디 중복을 피하기 위해 뒤에 _kakao를 삽입
            String id = email.split("@")[0] + "_kakao";
            String pw = UUID.randomUUID().toString();
	        
            kakaoUser.setApiUserId(id);
            kakaoUser.setApiUserPw(pw);
            kakaoUser.setApiUserName(name);
            kakaoUser.setApiUserEmail(email);
            kakaoUser.setApiUserPhone(phone);
            kakaoUser.setApiUserType("K");
	        
	        } catch (IOException e) {
	            throw new ApiLoginException("Failed to get user info from Kakao", e);
	        }
		return kakaoUser;
	}

	// 카카오 로그인회원이 DB에 존재 여부 확인
	public Member kakaoLoginChk(KakaoUser kakaoUser) {
		return dao.kakakoLoginChk(kakaoUser);
	}

	// 회원탈퇴 시 카카오 연동해제
	public boolean kakaoUnlink(String accessToken) {
		HttpPost post = new HttpPost(KAKAO_UNLINK_URL);
		post.setHeader("Authorization", "Bearer " + accessToken);
		post.setHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
		
		try (CloseableHttpClient client = HttpClients.createDefault();
		         CloseableHttpResponse response = client.execute(post)) {
			int statusCode = response.getStatusLine().getStatusCode();
		    if (statusCode == 200) {
		        // 연동 해제 성공
		    	return true;
		    } else {
		    	// 실패 처리
		    	String responseBody = EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);
		    	System.out.println("Unlink failed: " + responseBody);
		    	return false;
		    }
		} catch (IOException e) {
			throw new ApiLoginException("Failed to unlink Kakao account", e);
		}
	}
}
