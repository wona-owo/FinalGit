package kr.or.iei.story.model.vo;

import java.util.Date;

public class StoryFile {
	private int storyFileNo;
	private int storyNo;
	private String storyFileName;
	private String mimeType;
	private Date storyCreateDate;

	private int userNo;

	public StoryFile() {
		super();
		// TODO Auto-generated constructor stub
	}

	public StoryFile(int storyFileNo, int storyNo, String storyFileName, String mimeType, Date storyCreateDate,
			int userNo) {
		super();
		this.storyFileNo = storyFileNo;
		this.storyNo = storyNo;
		this.storyFileName = storyFileName;
		this.mimeType = mimeType;
		this.storyCreateDate = storyCreateDate;
		this.userNo = userNo;
	}

	public int getStoryFileNo() {
		return storyFileNo;
	}

	public void setStoryFileNo(int storyFileNo) {
		this.storyFileNo = storyFileNo;
	}

	public int getStoryNo() {
		return storyNo;
	}

	public void setStoryNo(int storyNo) {
		this.storyNo = storyNo;
	}

	public String getStoryFileName() {
		return storyFileName;
	}

	public void setStoryFileName(String storyFileName) {
		this.storyFileName = storyFileName;
	}

	public String getMimeType() {
		return mimeType;
	}

	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}

	public Date getStoryCreateDate() {
		return storyCreateDate;
	}

	public void setStoryCreateDate(Date storyCreateDate) {
		this.storyCreateDate = storyCreateDate;
	}

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

}
