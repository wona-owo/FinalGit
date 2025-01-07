package kr.or.iei.notify.model.vo;

public class Notify {
	
	private int notifyId; // 알림 ID (Primary Key)
    private int userNo; // 사용자 번호
    private int eventType; // 이벤트 타입
    private String notifyContent; // 알림 내용
    private String isRead; // 읽음 여부 ('Y' 또는 'N')
    private String notifyDate;
    
    
	public Notify() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public Notify(int notifyId, int userNo, int eventType, String notifyContent, String isRead, String notifyDate) {
		super();
		this.notifyId = notifyId;
		this.userNo = userNo;
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

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
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
