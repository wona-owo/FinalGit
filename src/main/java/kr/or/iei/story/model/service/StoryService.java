package kr.or.iei.story.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.story.model.dao.StoryDao;

@Service("storyService")
public class StoryService {

	@Autowired
	@Qualifier("storyDao")
	private StoryDao dao;
}
