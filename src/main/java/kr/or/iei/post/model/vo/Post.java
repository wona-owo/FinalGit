package kr.or.iei.post.model.vo;

import java.util.ArrayList;

public class Post {
	private int postNo;
	private int userNo;
	private String postContent;
	private String postDate;
	
	//join으로 인한 객체 통합
	private int postFileNo;
	private String postFileName;
	
	
	//hashtag 테이블 join
	private int hashNo;
	private ArrayList<String> hashName; //태그 배열
	


	public Post() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Post(int postNo, int userNo, String postContent, String postDate, int postFileNo, String postFileName,
			int hashNo, ArrayList<String> hashName, String postThumbnail) {
		super();
		this.postNo = postNo;
		this.userNo = userNo;
		this.postContent = postContent;
		this.postDate = postDate;
		this.postFileNo = postFileNo;
		this.postFileName = postFileName;
		this.hashNo = hashNo;
		this.hashName = hashName;

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

	public int getHashNo() {
		return hashNo;
	}

	public void setHashNo(int hashNo) {
		this.hashNo = hashNo;
	}

	public ArrayList<String> getHashName() {
		return hashName;
	}

	public void setHashName(ArrayList<String> hashName) {
		this.hashName = hashName;
	}
	
	
	
	
}
