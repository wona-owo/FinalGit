package kr.or.iei.report.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.iei.report.model.service.ReportService;
import kr.or.iei.report.model.vo.Report;

@Controller
@RequestMapping("/report/")
public class ReportContorller {
	
	@Autowired
	@Qualifier("reportService")
	private ReportService service;
	
	// 신고하기
	@PostMapping("insertReport.kh")
	@ResponseBody
	public String insertReport(Report report) {
		int result = service.insertReport(report);
		
		if(result > 0 ) {
			return "success";
		} else {
			return "error";
		}
	}
}
