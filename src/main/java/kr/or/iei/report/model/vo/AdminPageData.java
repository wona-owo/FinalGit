package kr.or.iei.report.model.vo;

import java.util.ArrayList;

public class AdminPageData {
	private ArrayList<Report> reportList;
	private ArrayList<BanList> banList;
	private ArrayList<MemberInfo> memberList;
	private String pageNavi;

	public AdminPageData() {
		super();
	}

	public AdminPageData(ArrayList<Report> reportList, ArrayList<BanList> banList, ArrayList<MemberInfo> memberList,
			String pageNavi) {
		super();
		this.reportList = reportList;
		this.banList = banList;
		this.memberList = memberList;
		this.pageNavi = pageNavi;
	}

	public ArrayList<Report> getReportList() {
		return reportList;
	}

	public void setReportList(ArrayList<Report> reportList) {
		this.reportList = reportList;
	}

	public ArrayList<BanList> getBanList() {
		return banList;
	}

	public void setBanList(ArrayList<BanList> banList) {
		this.banList = banList;
	}

	public ArrayList<MemberInfo> getMemberList() {
		return memberList;
	}

	public void setMemberList(ArrayList<MemberInfo> memberList) {
		this.memberList = memberList;
	}

	public String getPageNavi() {
		return pageNavi;
	}

	public void setPageNavi(String pageNavi) {
		this.pageNavi = pageNavi;
	}

	
}
