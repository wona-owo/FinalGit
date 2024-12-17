package kr.or.iei.common.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {
	@GetMapping("/home.kh")
    public String homePage() {
        return "member/mainFeed"; // /WEB-INF/views/common/home.jsp
    }

    @GetMapping("/search.kh")
    public String searchPage() {
        return "common/search"; // /WEB-INF/views/common/search.jsp
    }


    @GetMapping("/message.kh")
    public String messagePage() {
        return "common/message";
    }

}
