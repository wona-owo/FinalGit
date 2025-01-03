package kr.or.iei.story.model.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.story.model.dao.StoryDao;
import kr.or.iei.story.model.vo.StoryFile;
import kr.or.iei.story.model.vo.StoryFollowList;

@Service("storyService")
public class StoryService {

	@Autowired
	@Qualifier("storyDao")
	private StoryDao dao;

	public ArrayList<StoryFollowList> selectStoryFollowList(String userNo) {
		return (ArrayList<StoryFollowList>) dao.selectStoryFollowList(userNo);
	}

	public ArrayList<StoryFile> selectStoryFileList(String userNo) {
		return (ArrayList<StoryFile>) dao.selectStoryFileList(userNo);
	}
}
