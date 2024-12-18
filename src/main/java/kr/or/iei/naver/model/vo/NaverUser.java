package kr.or.iei.naver.model.vo;

public class NaverUser {

	private String apiUserId;
	private String apiUserPw;
	private String apiUserName;
	private String apiUserEmail;
	private String apiUserPhone;
	private String apiUserType;

	public NaverUser() {
		super();
		// TODO Auto-generated constructor stub
	}

	public NaverUser(String apiUserId, String apiUserPw, String apiUserName, String apiUserEmail, String apiUserPhone,
			String apiUserType) {
		super();
		this.apiUserId = apiUserId;
		this.apiUserPw = apiUserPw;
		this.apiUserName = apiUserName;
		this.apiUserEmail = apiUserEmail;
		this.apiUserPhone = apiUserPhone;
		this.apiUserType = apiUserType;
	}

	public String getApiUserId() {
		return apiUserId;
	}

	public void setApiUserId(String apiUserId) {
		this.apiUserId = apiUserId;
	}

	public String getApiUserPw() {
		return apiUserPw;
	}

	public void setApiUserPw(String apiUserPw) {
		this.apiUserPw = apiUserPw;
	}

	public String getApiUserName() {
		return apiUserName;
	}

	public void setApiUserName(String apiUserName) {
		this.apiUserName = apiUserName;
	}

	public String getApiUserEmail() {
		return apiUserEmail;
	}

	public void setApiUserEmail(String apiUserEmail) {
		this.apiUserEmail = apiUserEmail;
	}

	public String getApiUserPhone() {
		return apiUserPhone;
	}

	public void setApiUserPhone(String apiUserPhone) {
		this.apiUserPhone = apiUserPhone;
	}

	public String getApiUserType() {
		return apiUserType;
	}

	public void setApiUserType(String apiUserType) {
		this.apiUserType = apiUserType;
	}

}
