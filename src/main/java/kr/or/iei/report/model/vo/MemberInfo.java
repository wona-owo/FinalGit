package kr.or.iei.report.model.vo;

public class MemberInfo {
	private int userNo;
	private String userId;
	private String userType;
	private String enrollDate;
	private String banYN;
	private int acctLevel;
	private int banCnt;

	public MemberInfo() {
		super();
		// TODO Auto-generated constructor stub
	}

	public MemberInfo(int userNo, String userId, String userType, String enrollDate, String banYN, int acctLevel,
			int banCnt) {
		super();
		this.userNo = userNo;
		this.userId = userId;
		this.userType = userType;
		this.enrollDate = enrollDate;
		this.banYN = banYN;
		this.acctLevel = acctLevel;
		this.banCnt = banCnt;
	}

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public String getEnrollDate() {
		return enrollDate;
	}

	public void setEnrollDate(String enrollDate) {
		this.enrollDate = enrollDate;
	}

	public String getBanYN() {
		return banYN;
	}

	public void setBanYN(String banYN) {
		this.banYN = banYN;
	}

	public int getAcctLevel() {
		return acctLevel;
	}

	public void setAcctLevel(int acctLevel) {
		this.acctLevel = acctLevel;
	}

	public int getBanCnt() {
		return banCnt;
	}

	public void setBanCnt(int banCnt) {
		this.banCnt = banCnt;
	}

}
