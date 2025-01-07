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
import org.springframework.web.bind.annotation.RestController;

import kr.or.iei.notify.model.service.NotifyService;
import kr.or.iei.notify.model.vo.Notify;

@RestController
@RequestMapping("/notify/")
public class NotifyController {

    @Autowired
    @Qualifier("notifyService")
    private NotifyService notifyService;

    // 새 알림 추가
    @PostMapping("/send")
    public String sendNotification(@RequestBody Notify notify) {
        // 누락되지 않도록 모든 변수에 값 할당
        notify.setNotifyId(0); // 기본값 (DB에서 SEQUENCE로 설정)
        notify.setIsRead("N"); // 읽지 않음 상태
        notify.setNotifyDate(null); // DB에서 기본값으로 설정

        // 동적으로 알림 내용 생성 (eventType 기반)
        String dynamicContent = generateNotifyContent(notify.getEventType(), notify.getUserNo());
        notify.setNotifyContent(dynamicContent);

        // 알림 저장
        int result = notifyService.addNotification(notify);

        // 결과 반환
        return result > 0 ? "success" : "failure";
    }

    /**
     * 알림 내용 동적 생성
     * 이벤트 타입과 사용자 정보에 따라 다른 알림 메시지를 생성
     */
    private String generateNotifyContent(int eventType, int userNo) {
        switch (eventType) {
            case 1:
                return "사용자 " + userNo + "님이 새로운 팔로워를 추가했습니다.";
            case 2:
                return "사용자 " + userNo + "님의 게시글에 댓글이 달렸습니다.";
            case 3:
                return "사용자 " + userNo + "님의 게시글이 좋아요를 받았습니다.";
            case 4:
                return "사용자 " + userNo + "님의 댓글에 답글이 달렸습니다.";
            default:
                return "새로운 알림이 있습니다.";
        }
    }

    // 특정 사용자의 읽지 않은 알림 가져오기 (롱폴링 방식)
    @GetMapping("/poll/{userNo}")
    public List<Notify> pollUnreadNotifications(@PathVariable int userNo) throws InterruptedException {
        List<Notify> notifications;
        for (int i = 0; i < 30; i++) {
            notifications = notifyService.getUnreadNotifications(userNo);
            if (notifications != null && !notifications.isEmpty()) {
                return notifications; // 알림이 있으면 반환
            }
            Thread.sleep(1000); // 1초 대기
        }
        return List.of(); // 알림이 없으면 빈 리스트 반환
    }

    // 여러 알림 읽음 처리
    @PutMapping("/mark-read")
    public String markMultipleNotificationsAsRead(@RequestBody List<Integer> notifyIds) {
        int result = notifyService.markMultipleAsRead(notifyIds);
        return result > 0 ? "success" : "failure";
    }
    
	
}
