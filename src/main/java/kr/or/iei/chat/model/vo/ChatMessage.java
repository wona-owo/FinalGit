package kr.or.iei.chat.model.vo;

import java.util.Date;

public class ChatMessage {
    private int messageId;
    private int roomId;
    private int senderNo;
    private String messageContent;
    private String sendDate;
	public ChatMessage() {
		super();
		// TODO Auto-generated constructor stub
	}
	public ChatMessage(int messageId, int roomId, int senderNo, String messageContent, String sendDate) {
		super();
		this.messageId = messageId;
		this.roomId = roomId;
		this.senderNo = senderNo;
		this.messageContent = messageContent;
		this.sendDate = sendDate;
	}
	public int getMessageId() {
		return messageId;
	}
	public void setMessageId(int messageId) {
		this.messageId = messageId;
	}
	public int getRoomId() {
		return roomId;
	}
	public void setRoomId(int roomId) {
		this.roomId = roomId;
	}
	public int getSenderNo() {
		return senderNo;
	}
	public void setSenderNo(int senderNo) {
		this.senderNo = senderNo;
	}
	public String getMessageContent() {
		return messageContent;
	}
	public void setMessageContent(String messageContent) {
		this.messageContent = messageContent;
	}
	public String getSendDate() {
		return sendDate;
	}
	public void setSendDate(String sendDate) {
		this.sendDate = sendDate;
	}
	@Override
	public String toString() {
		return "ChatMessage [messageId=" + messageId + ", roomId=" + roomId + ", senderNo=" + senderNo
				+ ", messageContent=" + messageContent + ", sendDate=" + sendDate + "]";
	}
	
    
    
}