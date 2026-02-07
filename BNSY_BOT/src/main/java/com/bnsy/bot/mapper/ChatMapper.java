package com.bnsy.bot.mapper;

import com.bnsy.bot.dto.ChatDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 채팅 이력 Mapper 인터페이스
 */
@Mapper
public interface ChatMapper {

    /**
     * 채팅 저장
     * 
     * @param chat 채팅 정보 (사용자ID, 질문, 답변 등)
     * @return 저장된 행의 개수
     */
    int insertChat(ChatDTO chat);

    /**
     * 특정 사용자 채팅 이력 조회
     * 
     * @param memberId 사용자 ID
     * @return 채팅 이력 리스트
     */
    List<ChatDTO> selectChatHistoryByMemberId(@Param("memberId") String memberId);

    /**
     * 특정 회원의 채팅 이력 전체 삭제
     * 
     * @param memberId 회원 ID
     * @return 삭제된 행의 수
     */
    int deleteChatHistoryByMemberId(String memberId);
}
