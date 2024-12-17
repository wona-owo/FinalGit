package kr.or.iei.member.model.vo;


public class Member {

	private int userNo;			   //번호
	private String userId;		   //아이디
	private String userPw;		   //비번
	private String userNickname;   //닉네임
	private String userName;	   //이름
	private String userAddress;    //주소
	private String userEmail;	   //이메일
	private String userPhone;	   //전화번호
	private String userType;	   //가입경로
	private String enrollDate;	   //가입일
	private int acctLevel;	   	   //등급
	private String banYN;	   	   //밴여부
	private String userImage;	   //이미지
	
	public Member() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Member(int userNo, String userId, String userPw, String userNickname, String userName, String userAddress,
			String userEmail, String userPhone, String userType, String enrollDate, int acctLevel, String banYN,
			String userImage) {
		super();
		this.userNo = userNo;
		this.userId = userId;
		this.userPw = userPw;
		this.userNickname = userNickname;
		this.userName = userName;
		this.userAddress = userAddress;
		this.userEmail = userEmail;
		this.userPhone = userPhone;
		this.userType = userType;
		this.enrollDate = enrollDate;
		this.acctLevel = acctLevel;
		this.banYN = banYN;
		this.userImage = userImage;
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

	public String getUserPw() {
		return userPw;
	}

	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}

	public String getUserNickname() {
		return userNickname;
	}

	public void setUserNickname(String userNickname) {
		this.userNickname = userNickname;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserAddress() {
		return userAddress;
	}

	public void setUserAddress(String userAddress) {
		this.userAddress = userAddress;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getUserPhone() {
		return userPhone;
	}

	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
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

	public int getAcctLevel() {
		return acctLevel;
	}

	public void setAcctLevel(int acctLevel) {
		this.acctLevel = acctLevel;
	}

	public String getBanYN() {
		return banYN;
	}

	public void setBanYN(String banYN) {
		this.banYN = banYN;
	}

	public String getUserImage() {
		return userImage;
	}

	public void setUserImage(String userImage) {
		this.userImage = userImage;
	}
	
	
	
}
