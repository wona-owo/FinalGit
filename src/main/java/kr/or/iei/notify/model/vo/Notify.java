package kr.or.iei.notify.model.vo;

public class Notify {
	 /*
		1	내 게시물 댓글
		2	내 게시물 좋아요
		3	내 댓글 좋아요
		4	내 댓글 답글
		5	팔로워 알림 
		6	채팅 알림
	     */
	
	private int notifyId; // 알림 ID (Primary Key)
    private int sendUserNo; // 알림을 유발한 사용자
    private int acceptUserNo; //알림을 받을 사용자
    private int eventType; // 이벤트 타입
   
    private String notifyContent; // 알림 내용
    private String isRead; // 읽음 여부 ('Y' 또는 'N')
    private String notifyDate;
    
    
	public Notify() {
		super();
		// TODO Auto-generated constructor stub
	}


	public Notify(int notifyId, int sendUserNo, int acceptUserNo, int eventType, String notifyContent, String isRead,
			String notifyDate) {
		super();
		this.notifyId = notifyId;
		this.sendUserNo = sendUserNo;
		this.acceptUserNo = acceptUserNo;
		this.eventType = eventType;
		this.notifyContent = notifyContent;
		this.isRead = isRead;
		this.notifyDate = notifyDate;
	}


	public int getNotifyId() {
		return notifyId;
	}


	public void setNotifyId(int notifyId) {
		this.notifyId = notifyId;
	}


	public int getSendUserNo() {
		return sendUserNo;
	}


	public void setSendUserNo(int sendUserNo) {
		this.sendUserNo = sendUserNo;
	}


	public int getAcceptUserNo() {
		return acceptUserNo;
	}


	public void setAcceptUserNo(int acceptUserNo) {
		this.acceptUserNo = acceptUserNo;
	}


	public int getEventType() {
		return eventType;
	}


	public void setEventType(int eventType) {
		this.eventType = eventType;
	}


	public String getNotifyContent() {
		return notifyContent;
	}


	public void setNotifyContent(String notifyContent) {
		this.notifyContent = notifyContent;
	}


	public String getIsRead() {
		return isRead;
	}


	public void setIsRead(String isRead) {
		this.isRead = isRead;
	}


	public String getNotifyDate() {
		return notifyDate;
	}


	public void setNotifyDate(String notifyDate) {
		this.notifyDate = notifyDate;
	}

	
	
}