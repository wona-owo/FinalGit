package kr.or.iei.story.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.iei.story.model.service.StoryService;

@Controller
@RequestMapping("/story/")
public class StoryController {

	@Autowired
	@Qualifier("storyService")
	private StoryService service;
}
