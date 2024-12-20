package kr.or.iei.member.model.vo;

public class HashTag {
	private int hashNo;
	private int postNo;
	private String hashName;
	public HashTag() {
		super();
		// TODO Auto-generated constructor stub
	}
	public HashTag(int hashNo, int postNo, String hashName) {
		super();
		this.hashNo = hashNo;
		this.postNo = postNo;
		this.hashName = hashName;
	}
	public int getHashNo() {
		return hashNo;
	}
	public void setHashNo(int hashNo) {
		this.hashNo = hashNo;
	}
	public int getPostNo() {
		return postNo;
	}
	public void setPostNo(int postNo) {
		this.postNo = postNo;
	}
	public String getHashName() {
		return hashName;
	}
	public void setHashName(String hashName) {
		this.hashName = hashName;
	}
	@Override
	public String toString() {
		return "HashTag [hashNo=" + hashNo + ", postNo=" + postNo + ", hashName=" + hashName + "]";
	}
}
