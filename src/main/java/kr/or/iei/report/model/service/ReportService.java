package kr.or.iei.report.model.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.report.model.dao.ReportDao;
import kr.or.iei.report.model.vo.AdminPageData;
import kr.or.iei.report.model.vo.BanList;
import kr.or.iei.report.model.vo.MemberInfo;
import kr.or.iei.report.model.vo.Report;

@Service("reportService")
@EnableScheduling // 스케줄링을 위한 어노테이션
public class ReportService {
	
	@Autowired
	@Qualifier("reportDao")
	private ReportDao dao;
	
	public Report searchReport(Report report) {
		return dao.searchReport(report);
	}

	public int searchTargetUser(Report report) {
		return dao.searchTargetUser(report);
	}
	public int insertReport(Report report) {
		return dao.insertReport(report);
	}

	public int updCntReport(Report searchReport) {
		return dao.updCntReport(searchReport);
	}

	public AdminPageData selectAdminList(int reqPage, String contentType) {
		
		// 한 페이지에 보여줄 item 갯수
		int viewAdminCnt = 10;
		
		// 게시글 시작번호, 끝번호
		int end = reqPage * viewAdminCnt;
		int start = end - viewAdminCnt + 1;
		
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);

		AdminPageData pd = new AdminPageData();
		
		if(contentType.equals("report")) {
			ArrayList<Report> list = (ArrayList<Report>) dao.selectReportList(map);
			pd.setReportList(list);
		} else if(contentType.equals("banlist")) {
			ArrayList<BanList> list = (ArrayList<BanList>) dao.selectBanList(map);
			pd.setBanList(list);
			
		} else if(contentType.equals("tbl_user")) {
			ArrayList<MemberInfo> list = (ArrayList<MemberInfo>) dao.selectUserList(map);
			pd.setMemberList(list);
		}
		
		//전체 게시글 갯수
		int totCnt = dao.selectAdminCount(contentType);
		
		//전체 페이지 갯수
		int totPage = 0;
		
		/*
		 
		 전체 게시글 갯수     전체 페이지 갯수
		 	  16			  2
		      20			  2
		  	  29 			  3
		 * */
		if(totCnt % viewAdminCnt > 0) {
			totPage = totCnt / viewAdminCnt + 1;
		}else {
			totPage = totCnt / viewAdminCnt;
		}
		
		//페이지 네비게이션 사이즈(몇개의 번호를 보여줄건지 ex) < 1 2 3 4 5 > )
		int pageNaviSize = 5;
		
		//페이지 네비게이션 시작번호 설정( 1 2 3 4 5 일떄 => 1 , 6 7 8 9 10 일떄 > 6) 
		int pageNo = ((reqPage-1) / pageNaviSize) * pageNaviSize + 1;
		
		//페이지 네비게이션 HTML
		String pageNavi = "";
		
		//이전 버튼 
		//시작번호 != 1 (시작번호 == 1 or 6 or 11 or 16 ...)
		if(pageNo != 1) {
			pageNavi += "<a href='#' class='page-link' data-page='" + (pageNo - 1) + "'>이전</a>"; 
		}
		
		//페이지 네비게이션
		for(int i=0; i<pageNaviSize; i++) {
			if(pageNo == reqPage) {
				pageNavi += "<span class='current-page'>" + pageNo + "</span>";
			}else {
				pageNavi += "<a href='#' class='page-link' data-page='" + pageNo + "'>" + pageNo + "</a>";
			}
			
			pageNo++;
			
			if(pageNo > totPage) {
				break;
			}
		}
		
		//다음 버튼
		if(pageNo <= totPage) {
			pageNavi += "<a href='#' class='page-link' data-page='" + pageNo + "'>다음</a>";
		}
		
		pd.setPageNavi(pageNavi);
		
		return pd;
	}

	public Report selectReport(Report report) {
		return dao.selectReport(report);
	}

	public int updYnReport(Report selectReport) {
		return dao.updYnReport(selectReport);
	}
	
	public int insertBanList(BanList banList) {
		return dao.insertBanList(banList);
	}

	// 밴 자동 해제 (매일 자정)
	@Scheduled(cron = "0 0 0 * * ?")
	public void unfreezeBan() {
		System.out.println("???");
		dao.unfreezeBan();
	}

	public int updAcctLevel(Member member) {
		// 유저 등급 조회
		int acctLevel = dao.selectAcctLevel(member);
		
		// 조회한 등급에 따라 변경 등급 세팅
		if (acctLevel == 0) {
	        acctLevel = 1;
	    } else {
	        acctLevel = 0;
	    }
		member.setAcctLevel(acctLevel);
		
		return dao.updAcctLevel(member);
	}

	public int deleteReport(Report selectReport) {
		return dao.deleteReport(selectReport);
	}
	
}
