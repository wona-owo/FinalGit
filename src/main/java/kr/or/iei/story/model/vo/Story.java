package kr.or.iei.story.model.vo;

public class Story {
	private int storyNo;
	private int userNo;
	private String createDate;
	private String endDate;

	public Story() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Story(int storyNo, int userNo, String createDate, String endDate) {
		super();
		this.storyNo = storyNo;
		this.userNo = userNo;
		this.createDate = createDate;
		this.endDate = endDate;
	}

	public int getStoryNo() {
		return storyNo;
	}

	public void setStoryNo(int storyNo) {
		this.storyNo = storyNo;
	}

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

}
