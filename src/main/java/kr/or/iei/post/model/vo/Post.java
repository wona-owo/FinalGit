package kr.or.iei.post.model.vo;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Post {
	private int postNo;
	private int userNo;
	private String postContent;
	private String postDate;
	
	//join으로 인한 객체 통합
	private int postFileNo;
	private String postFileName;
	private String userImage;
	private String userNickname;
	private int likeCount;
    private int commentCount;
	
	//hashtag 테이블 join
	private int hashNo;
	private ArrayList<String> hashName; //태그 배열
	
	//여러 이미지 지원을 위한 필드 추가
    private List<String> postFileNames; // 이미지 파일명 리스트
    
    public Post() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Post(int postNo, int userNo, String postContent, String postDate, int postFileNo, String postFileName,
			String userImage, String userNickname, int likeCount, int commentCount, int hashNo,
			ArrayList<String> hashName, List<String> postFileNames) {
		super();
		this.postNo = postNo;
		this.userNo = userNo;
		this.postContent = postContent;
		this.postDate = postDate;
		this.postFileNo = postFileNo;
		this.postFileName = postFileName;
		this.userImage = userImage;
		this.userNickname = userNickname;
		this.likeCount = likeCount;
		this.commentCount = commentCount;
		this.hashNo = hashNo;
		this.hashName = hashName;
		this.postFileNames = postFileNames;
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

	public String getUserImage() {
		return userImage;
	}

	public void setUserImage(String userImage) {
		this.userImage = userImage;
	}

	public String getUserNickname() {
		return userNickname;
	}

	public void setUserNickname(String userNickname) {
		this.userNickname = userNickname;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}

	public int getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
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

	public List<String> getPostFileNames() {
		return postFileNames;
	}

	public void setPostFileNames(List<String> postFileNames) {
		this.postFileNames = postFileNames;
	}

	@Override
	public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Post post = (Post) o;
        return postNo == post.postNo;
    }
	
	@Override
	public int hashCode() {
		return Objects.hash(postNo);
	}

	@Override
	public String toString() {
		return "Post [postNo=" + postNo + ", userNo=" + userNo + ", postContent=" + postContent + ", postDate="
				+ postDate + ", postFileNo=" + postFileNo + ", postFileName=" + postFileName + ", userImage="
				+ userImage + ", userNickname=" + userNickname + ", likeCount=" + likeCount + ", commentCount="
				+ commentCount + ", hashNo=" + hashNo + ", hashName=" + hashName + ", postFileNames=" + postFileNames
				+ "]";
	}
	
	
}
