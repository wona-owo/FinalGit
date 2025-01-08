package kr.or.iei.story.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.FileSystemLoopException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.story.model.service.StoryService;
import kr.or.iei.story.model.vo.Story;
import kr.or.iei.story.model.vo.StoryFile;
import kr.or.iei.story.model.vo.StoryFollowList;

@Controller
@RequestMapping("/story/")
public class StoryController {

	@Autowired
	@Qualifier("storyService")
	private StoryService service;
	
	// 내 스토리 정보
	@PostMapping(value="myStory.kh", produces="application/json; charset=utf-8")
	@ResponseBody
	public String myStory(@RequestParam String userNo) {
		// 내 정보 가져오기
		StoryFollowList myStory = service.selectMyStory(userNo);
		// 내가 올린 스토리 파일 정보
		ArrayList<StoryFile> myStoryFileList = service.selectMyStoryFile(userNo);
		
		for(StoryFile sf: myStoryFileList) {
			myStory.getStoryFileList().add(sf);
		}
		return new Gson().toJson(myStory);
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
	
	// 스토리 작성
	@PostMapping("storyWrite.kh")
	@ResponseBody
	public String storyWrite(HttpServletRequest request, MultipartFile [] files,
			@RequestParam int userNo) {
		
		for(MultipartFile file: files) {
			
			if(file != null && !file.isEmpty()) {
				// 스토리 고유번호 생성
				int storyNo = service.selectStoryNo();
				
				// insertStory에 전달할 데이터 바인딩
				Map<String, Integer> storyInfo = new HashMap<String, Integer>();
				storyInfo.put("userNo", userNo);
				storyInfo.put("storyNo", storyNo);
				
				// 스토리 DB 생성
				int storyResult = service.insertStory(storyInfo);
				
				// 스토리가 정상적으로 생성 시
				if(storyResult > 0) {
					String savePath = request.getSession().getServletContext().getRealPath("/resources/story_file/");
					String originalFileName = file.getOriginalFilename();
					String fileName = originalFileName.substring(0, originalFileName.lastIndexOf("."));
					String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
					
					String toDay = new SimpleDateFormat("yyyyMMdd").format(new Date());
					int ranNum = new Random().nextInt(10000) + 1;
					String filePath = fileName + "_" + toDay + "_" + ranNum + extension;
					
					savePath += filePath;
					
					// insertStoryFile에 전달할 데이터 바인딩
					Map<String, Object> storyFileInfo = new HashMap<String, Object>();
					storyFileInfo.put("storyNo", storyNo);
					storyFileInfo.put("storyFileName", "/resources/story_file/" + filePath);
					
					// 파일 MIMETYPE 추가
					Path path = Paths.get(filePath);
					try {
						String mimeType = Files.probeContentType(path);

						storyFileInfo.put("mimeType", mimeType);
					} catch (IOException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					
					// 스토리 파일 DB 생성
					int storyFileResult = service.insertStoryFile(storyFileInfo);
					
					// 스토리 파일이 정상적으로 생성 시
					if(storyFileResult > 0) {
						// 파일 업로드를 위한 보조스트림
						BufferedOutputStream bos = null;
						
						try {
							byte[] bytes = file.getBytes();
							FileOutputStream fos = new FileOutputStream(new File(savePath));
							bos = new BufferedOutputStream(fos);
							bos.write(bytes);
							
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} finally {
							try {
								if (bos != null) bos.close();
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
					} else {
						return "storyFileFail";
					}
				} else {
					return "storyFail";
				}
			} else {
				return "fileIsEmpty";
			}
		}
		return "success";
	}
	
	// 스토리 삭제
	@PostMapping("deleteStory.kh")
	@ResponseBody
	public String deleteStory(@RequestParam String storyNo) {
		int result = service.deleteStory(storyNo);

		if(result > 0) {
            return "success";
        } else {
            return "error";
        }
	}
}
