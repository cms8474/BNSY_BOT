package com.bnsy.bot.service;

import com.bnsy.bot.dto.ChatDTO;

import java.util.List;

/**
 * 채팅 서비스 인터페이스
 */
public interface ChatService {

    /**
     * 사용자의 질문을 처리하고 AI 답변을 생성하여 저장
     * 
     * @param memberId 사용자 ID
     * @param question 질문 내용
     * @return 저장된 채팅 정보 (답변 포함)
     */
    ChatDTO processQuestion(String memberId, String question);

    /**
     * 사용자 채팅 이력 조회
     * 
     * @param memberId 사용자 ID
     * @return 채팅 이력 리스트
     */
    List<ChatDTO> getChatHistory(String memberId);

    /**
     * 특정 회원의 채팅 이력 전체 삭제
     * 
     * @param memberId 회원 ID
     */
    void clearChatHistory(String memberId);
}
