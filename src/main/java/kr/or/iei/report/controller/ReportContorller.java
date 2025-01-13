package kr.or.iei.report.controller;

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
import kr.or.iei.post.model.service.PostService;
import kr.or.iei.report.model.service.ReportService;
import kr.or.iei.report.model.vo.AdminPageData;
import kr.or.iei.report.model.vo.BanList;
import kr.or.iei.report.model.vo.Report;

@Controller
@RequestMapping("/report/")
public class ReportContorller {
	
	@Autowired
	@Qualifier("reportService")
	private ReportService service;
	
	@Autowired
	@Qualifier("postService")
	private PostService postService;
	
	// Admin page 이동
	@GetMapping("adminPage")
	public String adminPage() {
		return "member/adminPage";
	}
	
	// 신고하기
	@PostMapping("insertReport.kh")
	@ResponseBody
	public String insertReport(Report report) {
		// 이전에 신고 내역이 있는지 확인
		Report searchReport = service.searchReport(report);
		
		int result = 0;
		
		if(searchReport == null) {
			// 신고 받은 유저의 번호
			int userNo = service.searchTargetUser(report);
			
			report.setUserNo(userNo);
			
			// 없을 시, 신고 내역 추가
			result = service.insertReport(report);
			if(result > 0 ) {
				return "success";
			} else {
				return "error";
			}
		} else {
			// 존재 할 시, cnt 값 + 1
			result = service.updCntReport(searchReport);
			System.out.println("!");
			if(result > 0 ) {
				return "success";
			} else {
				return "error";
			}
		}
	}
	
	// 관리자 페이지 리스트 가져오기
	@PostMapping(value="adminList.kh", produces="application/json; charset=utf-8")
	@ResponseBody
	public String adminList(@RequestParam int reqPage,
			@RequestParam String contentType) {
		AdminPageData pd = service.selectAdminList(reqPage, contentType);
		
		return new Gson().toJson(pd);
	}
	
	// 신고 처리
	@PostMapping("insertBanList.kh")
	@ResponseBody
	public String insertBanList(Report report, BanList banList) {
		// 전달받은 reportNo를 기준을 검색
		Report selectReport = service.selectReport(report);
		// 선택된 신고사유를 밴사유에 셋팅
		banList.setBanReason(selectReport.getReportReason());
		// 신고처리 N에서 Y로 업데이트
		int result = service.updYnReport(selectReport);
		
		if(result > 0){
			// 신고 처리 허위신고 시
			if(banList.getBanEndDate().equals("false")) {
				result = service.deleteReport(selectReport);
				
				if(result > 0) {
					return "success";
				} else {
					return "error";
				}
			} else {
				// 신고 처리 기간 정할 시
				result = service.insertBanList(banList);
				
				if(result > 0) {
					// 밴 처리 시, 게시물 삭제
					result = postService.deletePost(selectReport.getTargetNo());
					
					if(result> 0) {
						return "success";
					} else {
						return "error";
					}
				} else {
					return "error";
				}
			}
		} else {
			return "error";
		}
	}
	
	// 등급 변경
	@PostMapping("updAcctLevel.kh")
	@ResponseBody
	public String updAcctLevel(Member member) {
		int result = service.updAcctLevel(member);
		
		if(result > 0) {
			return "success";
		} else {
			return "error";
		}
	}
	
}
