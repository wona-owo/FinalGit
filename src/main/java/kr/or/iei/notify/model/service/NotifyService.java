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

	public int addNotify(Notify notify) {
        return notifyDao.insertNotification(notify);
    }

	public String srchUserName(int sendUserNo) {
		return notifyDao.srchUserName(sendUserNo);
	}

	public List<Notify> getNewNotify(int userNo) {
		return notifyDao.getNewNotify(userNo);
	}


    // 모든 알림 읽음 처리
    public int markAllAsRead(int userNo) {
        return notifyDao.updateAllRead(userNo);
    }
}
