package kr.or.iei.follor.controller;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.iei.follor.model.service.FollowService;
import kr.or.iei.member.model.service.MemberService;
import kr.or.iei.member.model.vo.Member;

@Controller
@RequestMapping("/follor/")
public class FollorController {
	
	@Autowired
	@Qualifier("followService")
	private FollowService followService;
	
	@Autowired
	@Qualifier("service")
	private MemberService memberService;
	
	
	@PostMapping("/follow")
	@ResponseBody
	public HashMap<String, Object> followUser(@RequestParam("userId") String userId,
			@RequestParam("action") String action, HttpSession session, Model model) {

		HashMap<String, Object> resultMap = new HashMap<>();

		Member loginMember = (Member) session.getAttribute("loginMember");

		int myNo = loginMember.getUserNo(); // 나
		int targetNo = memberService.selectUser(userId); // 상대방

		if (targetNo == 0) {
			resultMap.put("success", false);
			resultMap.put("message", "존재하지 않는 사용자입니다.");
			return resultMap;
		}
		if ("follow".equals(action)) {
			// (1) 이미 팔로우 중인지 확인
			int isFollowing = followService.selectCheckFollor(myNo, targetNo);
			if (isFollowing > 0) {
				// 이미 팔로우 중
				resultMap.put("success", false);
				resultMap.put("isFollowing", true);
				resultMap.put("message", "이미 팔로우하고 있습니다.");
			} else {
				// 팔로우 insert
				int insertResult = followService.insertfollow(myNo, targetNo);
				if (insertResult > 0) {
					int followerCount = followService.getFollowerCount(targetNo);
					int followingCount = followService.getFollowingCount(targetNo);
					resultMap.put("success", true);
					resultMap.put("isFollowing", true);
					resultMap.put("message", "팔로우 성공");
					resultMap.put("followerCount", followerCount);
					resultMap.put("followingCount", followingCount);
				} else {
					resultMap.put("success", false);
					resultMap.put("isFollowing", false);
					resultMap.put("message", "팔로우 실패");
				}
			}

		} else if ("unfollow".equals(action)) {
			// (1) 현재 내가 팔로우 중인지 확인
			int isFollowing = followService.selectCheckFollor(myNo, targetNo);
			if (isFollowing == 0) {
				// 이미 팔로우 안 하고 있음
				resultMap.put("success", false);
				resultMap.put("isFollowing", false);
				resultMap.put("message", "이미 언팔로우 상태입니다.");
			} else {
				// 언팔로우 delete
				int deleteResult = followService.deleteFollow(myNo, targetNo);
				if (deleteResult > 0) {
					int followerCount = followService.getFollowerCount(targetNo);
					int followingCount = followService.getFollowingCount(targetNo);
					resultMap.put("success", true);
					resultMap.put("isFollowing", false);
					resultMap.put("message", "언팔로우 성공");
	                resultMap.put("followerCount", followerCount);
	                resultMap.put("followingCount", followingCount);
				} else {
					resultMap.put("success", false);
					resultMap.put("isFollowing", true);
					resultMap.put("message", "언팔로우 실패");
				}
			}
		} else {
			resultMap.put("success", false);
			resultMap.put("message", "잘못된 요청입니다. (action 파라미터)");
		}
		// 4) 맞팔 여부 체크
		boolean isMutualFollow = followService.isFollowingEachOther(myNo, targetNo);
		resultMap.put("isMutualFollow", isMutualFollow);

		return resultMap;
	}
	
}
