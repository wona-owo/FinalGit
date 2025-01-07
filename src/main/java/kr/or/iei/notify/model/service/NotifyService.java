package kr.or.iei.notify.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.or.iei.notify.model.dao.NotifyDao;
import kr.or.iei.notify.model.vo.Notify;

@Service("notifyService")
public class NotifyService {
	
	@Autowired
	@Qualifier("notifyDao")
	private NotifyDao notifyDao;

	public int addNotification(Notify notify) {
        return notifyDao.insertNotification(notify);
    }

    /**
     * 읽지 않은 알림 가져오기
     * 특정 사용자의 읽지 않은 알림 목록 반환
     */
    public List<Notify> getUnreadNotifications(int userNo) {
        return notifyDao.getUnreadNotifications(userNo);
    }

    /**
     * 단일 알림 읽음 처리
     * notifyId를 기반으로 읽음 처리
     */
    public int markAsRead(int notifyId) {
        return notifyDao.updateNotificationReadStatus(notifyId);
    }

    /**
     * 여러 알림 읽음 처리
     * notifyIds 리스트를 기반으로 알림을 읽음 처리
     */
    public int markMultipleAsRead(List<Integer> notifyIds) {
        return notifyDao.updateMultipleRead(notifyIds);
    }

	
}
