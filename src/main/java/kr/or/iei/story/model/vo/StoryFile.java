package kr.or.iei.story.model.vo;

public class StoryFile {
	private int storyFileNo;
	private int storyNo;
	private String storyFileName;

	private int userNo;

	public StoryFile() {
		super();
		// TODO Auto-generated constructor stub
	}

	public StoryFile(int storyFileNo, int storyNo, String storyFileName, int userNo) {
		super();
		this.storyFileNo = storyFileNo;
		this.storyNo = storyNo;
		this.storyFileName = storyFileName;
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

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

}
