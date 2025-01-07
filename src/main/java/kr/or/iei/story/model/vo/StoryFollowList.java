package kr.or.iei.story.model.vo;

import java.util.ArrayList;

public class StoryFollowList {
	private int userNo;
	private String userNickname;
	private String userImage;
	private String userIndex;
	private ArrayList<StoryFile> storyFileList;

	public StoryFollowList() {
		super();
		this.storyFileList = new ArrayList<>();
	}

	public StoryFollowList(int userNo, String userNickname, String userImage, String userIndex,
			ArrayList<StoryFile> storyFileList) {
		super();
		this.userNo = userNo;
		this.userNickname = userNickname;
		this.userImage = userImage;
		this.userIndex = userIndex;
		this.storyFileList = storyFileList;
	}

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

	public String getUserNickname() {
		return userNickname;
	}

	public void setUserNickname(String userNickname) {
		this.userNickname = userNickname;
	}

	public String getUserImage() {
		return userImage;
	}

	public void setUserImage(String userImage) {
		this.userImage = userImage;
	}

	public String getUserIndex() {
		return userIndex;
	}

	public void setUserIndex(String userIndex) {
		this.userIndex = userIndex;
	}

	public ArrayList<StoryFile> getStoryFileList() {
		return storyFileList;
	}

	public void setStoryFileList(ArrayList<StoryFile> storyFileList) {
		this.storyFileList = storyFileList;
	}

}
