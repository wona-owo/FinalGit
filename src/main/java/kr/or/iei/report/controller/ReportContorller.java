package kr.or.iei.report.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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
	
	//신고확인 페이지
		@GetMapping("allReport.kh")
		public String reportFrm() {
			return "admin/report";
		}
		
	//신고 리스트 조회
	@GetMapping("reportList.kh")
	public String reportList(Model model) {
		
		ArrayList<Report> report = service.reportList();
		
		model.addAttribute("report", report);
		
		return "admin/report";
	}
		
		
		
}
