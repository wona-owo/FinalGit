package kr.or.iei.story.model.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.story.model.vo.Story;
import kr.or.iei.story.model.vo.StoryFile;
import kr.or.iei.story.model.vo.StoryFollowList;

@Repository("storyDao")
public class StoryDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;
	
	public StoryFollowList selectMyStory(String userNo) {
		return sqlSession.selectOne("story.selectMyStory", userNo);
	}
	
	public List<StoryFile> selectMyStoryFile(String userNo) {
		return sqlSession.selectList("story.selectMyStoryFile", userNo);
	}

	public List<StoryFollowList> selectStoryFollowList(String userNo) {
		return sqlSession.selectList("story.selectStoryFollowList", userNo);
	}

	public List<StoryFile> selectStoryFileList(String userNo) {
		return sqlSession.selectList("story.selectStoryFileList", userNo);
	}

	public int selectStoryNo() {
		return sqlSession.selectOne("story.selectStoryNo");
	}

	public int insertStory(Map<String, Integer> storyInfo) {
		return sqlSession.insert("story.insertStory", storyInfo);
	}

	public int insertStoryFile(Map<String, Object> storyFileInfo) {
		return sqlSession.insert("story.insertStoryFile", storyFileInfo);
	}

	public int deleteStory(String storyNo) {
		return sqlSession.delete("story.deleteStory", storyNo);
	}

}
