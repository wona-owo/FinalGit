package kr.or.iei.notify.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.iei.member.controller.MemberController;
import kr.or.iei.notify.model.service.NotifyService;
import kr.or.iei.notify.model.vo.Notify;

@RestController
@RequestMapping("/notify/")
public class NotifyController {

    @Autowired
    @Qualifier("notifyService")
    private NotifyService notifyService;
    

    // 새 알림 추가
    public String sendNotification(int sendUserNo, int acceptUserNo, int eventType) {
        
    	//객체에 값 할당
    	Notify notify = new Notify();
    	
    	notify.setAcceptUserNo(acceptUserNo);
    	notify.setSendUserNo(sendUserNo);
        notify.setNotifyId(0); // 기본값 (DB에서 SEQUENCE로 설정)
        notify.setIsRead("N"); // 읽지 않음 상태
        notify.setNotifyDate(null); // DB에서 기본값으로 설정
        notify.setEventType(eventType);

        // 동적으로 알림 내용 생성 (eventType 기반)
        String eventContent = generateNotifyContent(notify.getEventType(), notify.getSendUserNo());
        notify.setNotifyContent(eventContent);

        // 알림 테이블에 알림 저장
        int result = notifyService.addNotify(notify);

        // 결과 반환
        return result > 0 ? "success" : "failure";
    }

    /**
     * 알림 내용 동적 생성
     * 이벤트 타입과 사용자 정보에 따라 다른 알림 메시지를 생성
     */
    private String generateNotifyContent(int eventType, int sendUserNo) {
    	
    	String sendUser = notifyService.srchUserName(sendUserNo);
    		
        switch (eventType) {
            case 1:
                return sendUser + "님이 게시물에 댓글을 달았습니다.";
            case 2:
                return sendUser + "님이 게시물에 좋아요를 남겼습니다.";
            case 3:
                return sendUser + "님이 댓글에 좋아요를 남겼습니다.";
            case 4:
                return sendUser + "님이 댓글에 답글을 남겼습니다.";
            case 6:
                return sendUser + "님이 당신을 팔로우했습니다.";
            default:
                return "새로운 알림이 있습니다.";
        }
    }

    
    
    
	
}
