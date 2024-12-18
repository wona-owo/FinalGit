package kr.or.iei.naver.model.vo;

public class NaverUser {

	private String userId;
	private String userName;
	private String userEmail;
	private String userPhone;

	public NaverUser() {
		super();
		// TODO Auto-generated constructor stub
	}

	public NaverUser(String userId, String userName, String userEmail, String userPhone) {
		super();
		this.userId = userId;
		this.userName = userName;
		this.userEmail = userEmail;
		this.userPhone = userPhone;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
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

}
