package kr.or.iei.post.model.vo;

public class Like {
	private int targetNo;
	private int userNo;
	private char targetType;
	
	public Like() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Like(int targetNo, int userNo, char targetType) {
		super();
		this.targetNo = targetNo;
		this.userNo = userNo;
		this.targetType = targetType;
	}

	public int getTargetNo() {
		return targetNo;
	}

	public void setTargetNo(int targetNo) {
		this.targetNo = targetNo;
	}

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

	public char getTargetType() {
		return targetType;
	}

	public void setTargetType(char targetType) {
		this.targetType = targetType;
	}
	 
	
	
}
