package kr.or.iei.story.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.story.model.service.StoryService;
import kr.or.iei.story.model.vo.StoryFile;
import kr.or.iei.story.model.vo.StoryFollowList;

@Controller
@RequestMapping("/story/")
public class StoryController {

	@Autowired
	@Qualifier("storyService")
	private StoryService service;
	
	@GetMapping("modalTest.kh")
	public String modalTest() {
		return "member/story";
	}
	
	// 팔로우 유저의 스토리 정보
	@PostMapping(value="storyFollowList.kh", produces="application/json; charset=utf-8")
	@ResponseBody
	public String storyFollowList(@RequestParam String userNo){
		// 팔로우 유저 중 스토리를 올린 유저 정보
		ArrayList<StoryFollowList> followUserList = service.selectStoryFollowList(userNo);
		
		// 팔로우한 유저 중 스토리 파일 정보
		ArrayList<StoryFile> storyFileList = service.selectStoryFileList(userNo);
		
		// 스토리 파일 정보를 돌면서 uNo를 가져온다.
	    for(StoryFile sf : storyFileList) {
	        int uNo = sf.getUserNo();
	        
	        // uNo와 일치하는 유저정보에 file정보를 추가한다. 
	        for(StoryFollowList sfl : followUserList) {
	            if(sfl.getUserNo() == uNo) {
	                sfl.getStoryFileList().add(sf);
	            }
	        }
	    }
	    
		return new Gson().toJson(followUserList);
	}
	
	
}
