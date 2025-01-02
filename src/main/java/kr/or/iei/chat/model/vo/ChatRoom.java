package kr.or.iei.chat.model.vo;

import java.util.Date;

public class ChatRoom {
    private int roomId;
    private int user1No;
    private int user2No;
    private String user1Left;
    private String user2Left;
    private Date createDate;
	public ChatRoom() {
		super();
		// TODO Auto-generated constructor stub
	}
	public ChatRoom(int roomId, int user1No, int user2No, String user1Left, String user2Left, Date createDate) {
		super();
		this.roomId = roomId;
		this.user1No = user1No;
		this.user2No = user2No;
		this.user1Left = user1Left;
		this.user2Left = user2Left;
		this.createDate = createDate;
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
	@Override
	public String toString() {
		return "ChatRoom [roomId=" + roomId + ", user1No=" + user1No + ", user2No=" + user2No + ", user1Left="
				+ user1Left + ", user2Left=" + user2Left + ", createDate=" + createDate + "]";
	}

    // Getters and Setters
    
    
}