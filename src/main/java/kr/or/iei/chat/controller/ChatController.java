package kr.or.iei.chat.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.iei.chat.model.service.ChatService;
import kr.or.iei.chat.model.vo.ChatRoom;
import kr.or.iei.chat.model.vo.ChatMessage;
import kr.or.iei.member.model.vo.Member;

@Controller
@RequestMapping("/chat/")
public class ChatController {

	@Autowired
	@Qualifier("chatService")
	private ChatService chatService;

	// 1) 채팅방 목록 + 단일 JSP 로 이동
    @GetMapping("chatCombined.kh")
    public String chatCombined(HttpSession session, Model model) {
        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/"; // 로그인 안 됨
        }
        // 사용자 참여중인 채팅방 목록 조회
        ArrayList<ChatRoom> chatRoomList = chatService.getChatRoomListByUser(loginMember.getUserNo());
        model.addAttribute("chatRoomList", chatRoomList);

        // chatCombined.jsp로 이동
        return "chat/chatCombined";
    }

    // 2) 특정 채팅방의 메시지를 JSON으로 반환
    @GetMapping("chatRoomData.kh")
    @ResponseBody
    public HashMap<String, Object> getChatRoomData(@RequestParam("roomId") int roomId, HttpSession session) {
        HashMap<String, Object> result = new HashMap<>();
        Member loginMember = (Member) session.getAttribute("loginMember");

        if (loginMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        // 채팅방 조회
        ChatRoom chatRoom = chatService.getChatRoomByRoomId(roomId);
        if (chatRoom == null) {
            // 방이 없으면
            result.put("success", false);
            result.put("message", "존재하지 않는 채팅방입니다.");
            return result;
        }

        // 읽음 상태 업데이트
        chatService.updateReadStatus(roomId, loginMember.getUserNo(), "Y");

        // 상대방 번호
        int receiverNo = (chatRoom.getUser1No() == loginMember.getUserNo()) 
                         ? chatRoom.getUser2No() 
                         : chatRoom.getUser1No();

        // 마지막 OutTime 확인
        Date lastOutTime = null;
        if (chatRoom.getUser1No() == loginMember.getUserNo()) {
            lastOutTime = chatRoom.getUser1OutTime();
        } else {
            lastOutTime = chatRoom.getUser2OutTime();
        }

        ArrayList<ChatMessage> chatMessages;
        if (lastOutTime != null) {
            // 나간 이후의 메시지만
            chatMessages = chatService.getChatMessagesAfterOutTime(roomId, lastOutTime);
        } else {
            // 전체 메시지
            chatMessages = chatService.getChatMessages(roomId);
        }

        result.put("success", true);
        result.put("roomId", roomId);
        result.put("receiverNo", receiverNo);
        result.put("chatMessages", chatMessages);

        return result;
    }

    // 3) 채팅방 나가기 (AJAX)
    @PostMapping("leaveChatRoom.kh")
    @ResponseBody
    public HashMap<String, Object> leaveChatRoom(@RequestParam("roomId") int roomId, HttpSession session) {
        HashMap<String, Object> result = new HashMap<>();
        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        chatService.leaveChatRoom(roomId, loginMember.getUserNo());
        result.put("success", true);
        result.put("message", "채팅방을 나갔습니다.");
        return result;
    }

    // 4) 새 채팅방 시작 (Button / Modal 등에서 호출)
    @GetMapping("startChat.kh")
    @ResponseBody
    public HashMap<String, Object> startChat(@RequestParam("userId") String userId, HttpSession session) {
        HashMap<String, Object> result = new HashMap<>();
        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        int user1No = loginMember.getUserNo(); // 나
        int user2No = chatService.getUserNoByUserId(userId); // 상대방 번호

        if (user2No == 0) {
            result.put("success", false);
            result.put("message", "존재하지 않는 사용자입니다.");
            return result;
        }

        // 기존 채팅방 있는지 확인
        ChatRoom chatRoom = chatService.getChatRoomByUsers(user1No, user2No);
        if (chatRoom == null) {
            // 없으면 새로 생성
            chatRoom = chatService.createChatRoom(user1No, user2No);
            if (chatRoom == null) {
                result.put("success", false);
                result.put("message", "채팅방 생성 실패");
                return result;
            }
        } else if ("Y".equals(chatRoom.getUser1Left()) || "Y".equals(chatRoom.getUser2Left())) {
            // 나간 상태면 재참여
            int updateChatRoom = chatService.updateChatRoom(user1No, chatRoom.getRoomId(),
                                                            chatRoom.getUser1No(), chatRoom.getUser2No());
            if (updateChatRoom == 0) {
                result.put("success", false);
                result.put("message", "채팅방 업데이트 실패");
                return result;
            }
        }

        result.put("success", true);
        result.put("roomId", chatRoom.getRoomId());
        return result;
    }

 
}