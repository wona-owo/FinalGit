package kr.or.iei.member.model.vo;

public class Search {
	private int userNo;
	private String keyWord;
	private String keywordDate;
	public Search() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Search(int userNo, String keyWord, String keywordDate) {
		super();
		this.userNo = userNo;
		this.keyWord = keyWord;
		this.keywordDate = keywordDate;
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
	@Override
	public String toString() {
		return "Search [userNo=" + userNo + ", keyWord=" + keyWord + ", keywordDate=" + keywordDate + "]";
	}
}
