package com.bnsy.bot.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 채팅 이력 DTO
 * CHAT_HISTORY 테이블
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatDTO {

    /**
     * 로그 ID (PK)
     */
    private Long logId;

    /**
     * 사용자 ID (FK)
     */
    private String memberId;

    /**
     * 사용자 질문 (CLOB)
     */
    private String question;

    /**
     * AI 답변 (CLOB)
     */
    private String answer;

    /**
     * 대화 일시
     */
    private Date chatDt;
}
