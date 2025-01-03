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

	// 채팅방 목록을 보여주는 메소드
	@GetMapping("chatRoomList.kh")
	public String chatRoomList(HttpSession session, Model model) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/"; // 로그인 안 된 경우
		}

		ArrayList<ChatRoom> chatRoomList = chatService.getChatRoomListByUser(loginMember.getUserNo());
		model.addAttribute("chatRoomList", chatRoomList);
		return "chat/chatRoomList";
	}

	// 채팅방 상세 페이지를 보여주는 메소드
	@GetMapping("chatRoom.kh")
	public String chatRoom(@RequestParam("roomId") int roomId, Model model, HttpSession session) {
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return "redirect:/";
	    }

	    ChatRoom chatRoom = chatService.getChatRoomByRoomId(roomId);
	    if (chatRoom == null) {
	        return "redirect:/chat/chatRoomList.kh";
	    }

	    int receiverNo = (chatRoom.getUser1No() == loginMember.getUserNo()) ? chatRoom.getUser2No()
	            : chatRoom.getUser1No();

	    // 마지막 나간 시간 확인
	    Date lastOutTime = null;
	    if (chatRoom.getUser1No() == loginMember.getUserNo()) {
	        lastOutTime = chatRoom.getUser1OutTime();
	    } else {
	        lastOutTime = chatRoom.getUser2OutTime();
	    }

	    ArrayList<ChatMessage> chatMessages;
	    if (lastOutTime != null) {
	        chatMessages = chatService.getChatMessagesAfterOutTime(roomId, lastOutTime);
	    } else {
	        chatMessages = chatService.getChatMessages(roomId);
	    }

	    model.addAttribute("chatMessages", chatMessages);
	    model.addAttribute("receiverNo", receiverNo);
	    model.addAttribute("roomId", roomId);
	    return "chat/chatRoom";
	}

	// 메시지를 전송하는 메소드
	@PostMapping("sendMessage.kh")
	public String sendMessage(@RequestParam("roomId") int roomId, @RequestParam("message") String message,
			HttpSession session) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/"; // 로그인 안 된 경우
		}

		ChatMessage chatMessage = new ChatMessage();
		chatMessage.setRoomId(roomId);
		chatMessage.setSenderNo(loginMember.getUserNo());
		chatMessage.setMessageContent(message);

		chatService.saveChatMessage(chatMessage);
		
		return "redirect:/chat/chatRoom.kh?roomId=" + roomId;
	}

	// 새로운 채팅방을 시작하는 메소드
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
		int user2No = chatService.getUserNoByUserId(userId); //상대방

		if (user2No == 0) {
			result.put("success", false);
			result.put("message", "존재하지 않는 사용자입니다.");
			return result;
		}

		// 기존 채팅방 확인
		ChatRoom chatRoom = chatService.getChatRoomByUsers(user1No, user2No);
		if (chatRoom == null) {
			// 기존 채팅방이 없을 때만 생성
			chatRoom = chatService.createChatRoom(user1No, user2No);
			if (chatRoom == null) {
				result.put("success", false);
				result.put("message", "채팅방을 생성하는 데 실패했습니다.");
				return result;
			}
			
		} else if ("Y".equals(chatRoom.getUser1Left()) || "Y".equals(chatRoom.getUser2Left())) {
			int updateChatRoom = chatService.updateChatRoom(user1No, chatRoom.getRoomId(), chatRoom.getUser1No(), chatRoom.getUser2No());
			if (updateChatRoom == 0) {
			    // 업데이트 실패 처리 로직
			    result.put("success", false);
			    result.put("message", "채팅방 업데이트에 실패했습니다.");
			    return result;
			}
	    } 

		result.put("success", true);
		result.put("roomId", chatRoom.getRoomId());
		return result;
	}
	
	// 채팅방 나가기 요청 처리
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
}