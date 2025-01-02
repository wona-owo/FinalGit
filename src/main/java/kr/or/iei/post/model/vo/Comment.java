package kr.or.iei.post.model.vo;

public class Comment {
	
	private int commentNo;
	private int userNo;
	private int postNo;
	private int parentNo;
	private String commentContent;
	private String commentDate;
	
	private String userNickname;
	private String userId;
	
	
	public Comment() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Comment(int commentNo, int userNo, int postNo, int parentNo, String commentContent, String commentDate,
			String userNickname, String userId) {
		super();
		this.commentNo = commentNo;
		this.userNo = userNo;
		this.postNo = postNo;
		this.parentNo = parentNo;
		this.commentContent = commentContent;
		this.commentDate = commentDate;
		this.userNickname = userNickname;
		this.userId = userId;
	}
	public int getCommentNo() {
		return commentNo;
	}
	public void setCommentNo(int commentNo) {
		this.commentNo = commentNo;
	}
	public int getUserNo() {
		return userNo;
	}
	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}
	public int getPostNo() {
		return postNo;
	}
	public void setPostNo(int postNo) {
		this.postNo = postNo;
	}
	public int getParentNo() {
		return parentNo;
	}
	public void setParentNo(int parentNo) {
		this.parentNo = parentNo;
	}
	public String getCommentContent() {
		return commentContent;
	}
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	public String getCommentDate() {
		return commentDate;
	}
	public void setCommentDate(String commentDate) {
		this.commentDate = commentDate;
	}
	public String getUserNickname() {
		return userNickname;
	}
	public void setUserNickname(String userNickname) {
		this.userNickname = userNickname;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}

	
	
	
}
