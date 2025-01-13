package kr.or.iei.report.model.vo;

public class Report {
	private int reportNo;
	private int userNo;
	private int targetNo;
	private String targetType;
	private String reportReason;
	private String reportDate;
	private String reportYn;
	private int reportCnt;

	// 게시물에 대한 정보
	private String userId;
	private String postContent;

	public Report() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Report(int reportNo, int userNo, int targetNo, String targetType, String reportReason, String reportDate,
			String reportYn, int reportCnt, String userId, String postContent) {
		super();
		this.reportNo = reportNo;
		this.userNo = userNo;
		this.targetNo = targetNo;
		this.targetType = targetType;
		this.reportReason = reportReason;
		this.reportDate = reportDate;
		this.reportYn = reportYn;
		this.reportCnt = reportCnt;
		this.userId = userId;
		this.postContent = postContent;
	}

	public int getReportNo() {
		return reportNo;
	}

	public void setReportNo(int reportNo) {
		this.reportNo = reportNo;
	}

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

	public int getTargetNo() {
		return targetNo;
	}

	public void setTargetNo(int targetNo) {
		this.targetNo = targetNo;
	}

	public String getTargetType() {
		return targetType;
	}

	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}

	public String getReportReason() {
		return reportReason;
	}

	public void setReportReason(String reportReason) {
		this.reportReason = reportReason;
	}

	public String getReportDate() {
		return reportDate;
	}

	public void setReportDate(String reportDate) {
		this.reportDate = reportDate;
	}

	public String getReportYn() {
		return reportYn;
	}

	public void setReportYn(String reportYn) {
		this.reportYn = reportYn;
	}

	public int getReportCnt() {
		return reportCnt;
	}

	public void setReportCnt(int reportCnt) {
		this.reportCnt = reportCnt;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPostContent() {
		return postContent;
	}

	public void setPostContent(String postContent) {
		this.postContent = postContent;
	}

}
