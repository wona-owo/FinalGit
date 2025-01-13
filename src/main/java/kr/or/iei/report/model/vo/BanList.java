package kr.or.iei.report.model.vo;

public class BanList {
	private int banNo;
	private int userNo;
	private String banReason;
	private String banStartDate;
	private String banEndDate;

	private String userId;

	public BanList() {
		super();
		// TODO Auto-generated constructor stub
	}

	public BanList(int banNo, int userNo, String banReason, String banStartDate, String banEndDate, String userId) {
		super();
		this.banNo = banNo;
		this.userNo = userNo;
		this.banReason = banReason;
		this.banStartDate = banStartDate;
		this.banEndDate = banEndDate;
		this.userId = userId;
	}

	public int getBanNo() {
		return banNo;
	}

	public void setBanNo(int banNo) {
		this.banNo = banNo;
	}

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

	public String getBanReason() {
		return banReason;
	}

	public void setBanReason(String banReason) {
		this.banReason = banReason;
	}

	public String getBanStartDate() {
		return banStartDate;
	}

	public void setBanStartDate(String banStartDate) {
		this.banStartDate = banStartDate;
	}

	public String getBanEndDate() {
		return banEndDate;
	}

	public void setBanEndDate(String banEndDate) {
		this.banEndDate = banEndDate;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

}
