package kr.or.iei.member.model.vo;

public class Search {
	private int userNo;
	private String keyWord;
	private String keywordDate;
	private String searchType;
	private String searchUserId;
	
	
	//join
	private String userImage;


	public Search() {
		super();
		// TODO Auto-generated constructor stub
	}


	public Search(int userNo, String keyWord, String keywordDate, String searchType, String searchUserId,
			String userImage) {
		super();
		this.userNo = userNo;
		this.keyWord = keyWord;
		this.keywordDate = keywordDate;
		this.searchType = searchType;
		this.searchUserId = searchUserId;
		this.userImage = userImage;
	}


	public int getUserNo() {
		return userNo;
	}


	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}


	public String getKeyWord() {
		return keyWord;
	}


	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}


	public String getKeywordDate() {
		return keywordDate;
	}


	public void setKeywordDate(String keywordDate) {
		this.keywordDate = keywordDate;
	}


	public String getSearchType() {
		return searchType;
	}


	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}


	public String getSearchUserId() {
		return searchUserId;
	}


	public void setSearchUserId(String searchUserId) {
		this.searchUserId = searchUserId;
	}


	public String getUserImage() {
		return userImage;
	}


	public void setUserImage(String userImage) {
		this.userImage = userImage;
	}


	@Override
	public String toString() {
		return "Search [userNo=" + userNo + ", keyWord=" + keyWord + ", keywordDate=" + keywordDate + ", searchType="
				+ searchType + ", searchUserId=" + searchUserId + ", userImage=" + userImage + "]";
	}
	
	
	
}
