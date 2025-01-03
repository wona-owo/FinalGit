package kr.or.iei.story.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import kr.or.iei.story.model.vo.StoryFile;
import kr.or.iei.story.model.vo.StoryFollowList;

@Repository("storyDao")
public class StoryDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSession;

	public List<StoryFollowList> selectStoryFollowList(String userNo) {
		return sqlSession.selectList("story.selectStoryFollowList", userNo);
	}

	public List<StoryFile> selectStoryFileList(String userNo) {
		return sqlSession.selectList("story.selectStoryFileList", userNo);
	}

}
