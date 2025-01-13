package kr.or.iei.member.model.vo;

public class HashTag {
	private int hashNo; 
	private int postNo; //o
	private int user_no; //o
	private String postContent; // o 
	private String hashName; //o
	private int postCount;
	private String postFileName; // o
	private String postDate; // o 
	public HashTag() {
		super();
		// TODO Auto-generated constructor stub
	}
	public HashTag(int hashNo, int postNo, int user_no, String postContent, String hashName, int postCount,
			String postFileName, String postDate) {
		super();
		this.hashNo = hashNo;
		this.postNo = postNo;
		this.user_no = user_no;
		this.postContent = postContent;
		this.hashName = hashName;
		this.postCount = postCount;
		this.postFileName = postFileName;
		this.postDate = postDate;
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
	public int getUser_no() {
		return user_no;
	}
	public void setUser_no(int user_no) {
		this.user_no = user_no;
	}
	public String getPostContent() {
		return postContent;
	}
	public void setPostContent(String postContent) {
		this.postContent = postContent;
	}
	public String getHashName() {
		return hashName;
	}
	public void setHashName(String hashName) {
		this.hashName = hashName;
	}
	public int getPostCount() {
		return postCount;
	}
	public void setPostCount(int postCount) {
		this.postCount = postCount;
	}
	public String getPostFileName() {
		return postFileName;
	}
	public void setPostFileName(String postFileName) {
		this.postFileName = postFileName;
	}
	public String getPostDate() {
		return postDate;
	}
	public void setPostDate(String postDate) {
		this.postDate = postDate;
	}
	@Override
	public String toString() {
		return "HashTag [hashNo=" + hashNo + ", postNo=" + postNo + ", user_no=" + user_no + ", postContent="
				+ postContent + ", hashName=" + hashName + ", postCount=" + postCount + ", postFileName=" + postFileName
				+ ", postDate=" + postDate + "]";
	}
	
	
	
	
}
