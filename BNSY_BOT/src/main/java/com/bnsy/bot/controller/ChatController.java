package com.bnsy.bot.controller;

import com.bnsy.bot.dto.ChatDTO;
import com.bnsy.bot.dto.MemberDTO;
import com.bnsy.bot.service.ChatService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 채팅 API 컨트롤러
 * 
 */
@Slf4j
@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    /**
     * 질문하기 (POST /api/chat/ask)
     * 
     * @param requestBody 질문 내용 (JSON: {"question": "..."})
     * @param session     사용자 세션
     * @return 답변이 포함된 ChatDTO
     */
    @PostMapping("/ask")
    public ResponseEntity<?> askQuestion(@RequestBody Map<String, String> requestBody, HttpSession session) {
        // 1. 로그인 체크
        MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        String question = requestBody.get("question");
        if (question == null || question.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("질문 내용이 없습니다.");
        }

        // 2. 서비스 실행
        try {
            ChatDTO result = chatService.processQuestion(loginMember.getMemberId(), question);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("질문 처리 중 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * 채팅 이력 조회 (GET /api/chat/history)
     * 
     * @param session 사용자 세션
     * @return ChatDTO 리스트
     */
    @GetMapping("/history")
    public ResponseEntity<?> getChatHistory(HttpSession session) {
        // 1. 로그인 체크
        MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        // 2. 이력 조회
        List<ChatDTO> history = chatService.getChatHistory(loginMember.getMemberId());
        return ResponseEntity.ok(history);
    }

    @DeleteMapping("/history")
    public ResponseEntity<?> deleteChatHistory(HttpSession session) {
        // 1. 로그인 체크
        MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        // 2. 이력 삭제
        try {
            chatService.clearChatHistory(loginMember.getMemberId());
            return ResponseEntity.ok("삭제되었습니다.");
        } catch (Exception e) {
            log.error("채팅 이력 삭제 중 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("삭제 중 오류가 발생했습니다.");
        }
    }
}
