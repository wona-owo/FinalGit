package kr.or.iei.chat.model.vo;

import java.util.Date;

public class ChatRoom {
    private int roomId;
    private int user1No;
    private int user2No;
    private String user1Left;
    private String user2Left;
    private Date createDate;
    private Date user1OutTime;
    private Date user2OutTime;
    private String user1ReadYN;
    private String user2ReadYN;
    //join
    private String user1Name;
    private String user1NickName;
    private String user2Name;
    private String user2NickName;
	public ChatRoom() {
		super();
		// TODO Auto-generated constructor stub
	}
	public ChatRoom(int roomId, int user1No, int user2No, String user1Left, String user2Left, Date createDate,
			Date user1OutTime, Date user2OutTime, String user1ReadYN, String user2ReadYN, String user1Name,
			String user1NickName, String user2Name, String user2NickName) {
		super();
		this.roomId = roomId;
		this.user1No = user1No;
		this.user2No = user2No;
		this.user1Left = user1Left;
		this.user2Left = user2Left;
		this.createDate = createDate;
		this.user1OutTime = user1OutTime;
		this.user2OutTime = user2OutTime;
		this.user1ReadYN = user1ReadYN;
		this.user2ReadYN = user2ReadYN;
		this.user1Name = user1Name;
		this.user1NickName = user1NickName;
		this.user2Name = user2Name;
		this.user2NickName = user2NickName;
	}
	public int getRoomId() {
		return roomId;
	}
	public void setRoomId(int roomId) {
		this.roomId = roomId;
	}
	public int getUser1No() {
		return user1No;
	}
	public void setUser1No(int user1No) {
		this.user1No = user1No;
	}
	public int getUser2No() {
		return user2No;
	}
	public void setUser2No(int user2No) {
		this.user2No = user2No;
	}
	public String getUser1Left() {
		return user1Left;
	}
	public void setUser1Left(String user1Left) {
		this.user1Left = user1Left;
	}
	public String getUser2Left() {
		return user2Left;
	}
	public void setUser2Left(String user2Left) {
		this.user2Left = user2Left;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Date getUser1OutTime() {
		return user1OutTime;
	}
	public void setUser1OutTime(Date user1OutTime) {
		this.user1OutTime = user1OutTime;
	}
	public Date getUser2OutTime() {
		return user2OutTime;
	}
	public void setUser2OutTime(Date user2OutTime) {
		this.user2OutTime = user2OutTime;
	}
	public String getUser1ReadYN() {
		return user1ReadYN;
	}
	public void setUser1ReadYN(String user1ReadYN) {
		this.user1ReadYN = user1ReadYN;
	}
	public String getUser2ReadYN() {
		return user2ReadYN;
	}
	public void setUser2ReadYN(String user2ReadYN) {
		this.user2ReadYN = user2ReadYN;
	}
	public String getUser1Name() {
		return user1Name;
	}
	public void setUser1Name(String user1Name) {
		this.user1Name = user1Name;
	}
	public String getUser1NickName() {
		return user1NickName;
	}
	public void setUser1NickName(String user1NickName) {
		this.user1NickName = user1NickName;
	}
	public String getUser2Name() {
		return user2Name;
	}
	public void setUser2Name(String user2Name) {
		this.user2Name = user2Name;
	}
	public String getUser2NickName() {
		return user2NickName;
	}
	public void setUser2NickName(String user2NickName) {
		this.user2NickName = user2NickName;
	}
	@Override
	public String toString() {
		return "ChatRoom [roomId=" + roomId + ", user1No=" + user1No + ", user2No=" + user2No + ", user1Left="
				+ user1Left + ", user2Left=" + user2Left + ", createDate=" + createDate + ", user1OutTime="
				+ user1OutTime + ", user2OutTime=" + user2OutTime + ", user1ReadYN=" + user1ReadYN + ", user2ReadYN="
				+ user2ReadYN + ", user1Name=" + user1Name + ", user1NickName=" + user1NickName + ", user2Name="
				+ user2Name + ", user2NickName=" + user2NickName + "]";
	}
	
    
    
    
}