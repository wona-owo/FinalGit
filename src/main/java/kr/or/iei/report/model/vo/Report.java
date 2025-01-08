package kr.or.iei.report.model.vo;

public class Report {
	private int userNo;
	private int targetNo;
	private String targetType;
	private String reportReason;
	private String reportDate;

	public Report() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Report(int userNo, int targetNo, String targetType, String reportReason, String reportDate) {
		super();
		this.userNo = userNo;
		this.targetNo = targetNo;
		this.targetType = targetType;
		this.reportReason = reportReason;
		this.reportDate = reportDate;
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

}
