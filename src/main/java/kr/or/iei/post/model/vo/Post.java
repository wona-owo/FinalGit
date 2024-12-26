package kr.or.iei.post.model.vo;

public class Post {
	private int postNo;
	private int userNo;
	private String postContent;
	private String postDate;
	
	//join으로 인한 객체 통합
	private int postFileNo;
	private String postFileName;
	
	
	
	public Post() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Post(int postNo, int userNo, String postContent, String postDate, int postFileNo, String postFileName) {
		super();
		this.postNo = postNo;
		this.userNo = userNo;
		this.postContent = postContent;
		this.postDate = postDate;
		this.postFileNo = postFileNo;
		this.postFileName = postFileName;
	}
	public int getPostNo() {
		return postNo;
	}
	public void setPostNo(int postNo) {
		this.postNo = postNo;
	}
	public int getUserNo() {
		return userNo;
	}
	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}
	public String getPostContent() {
		return postContent;
	}
	public void setPostContent(String postContent) {
		this.postContent = postContent;
	}
	public String getPostDate() {
		return postDate;
	}
	public void setPostDate(String postDate) {
		this.postDate = postDate;
	}
	public int getPostFileNo() {
		return postFileNo;
	}
	public void setPostFileNo(int postFileNo) {
		this.postFileNo = postFileNo;
	}
	public String getPostFileName() {
		return postFileName;
	}
	public void setPostFileName(String postFileName) {
		this.postFileName = postFileName;
	}
	
	
}
