package com.bnsy.bot.service.impl;

import com.bnsy.bot.dto.ChatDTO;
import com.bnsy.bot.mapper.ChatMapper;
import com.bnsy.bot.service.ChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 채팅 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ChatMapper chatMapper;
    private final RestTemplate restTemplate;

    @Value("${ai.server.host}")
    private String aiServerHost;

    @Value("${ai.server.port}")
    private String aiServerPort;

    /**
     * 질문 처리 및 답변 생성 (AI 서버 연동 + Redis MQ)
     */
    @Override
    public ChatDTO processQuestion(String memberId, String question) {
        log.info("질문 수신 - Member: {}, Question: {}", memberId, question);

        String answer = "";

        // 1. AI 서버로 HTTP 요청하여 답변 생성
        try {
            String aiServerUrl = String.format("http://%s:%s/chat", aiServerHost, aiServerPort);
            log.info("🖥️ AI Server 호출: {}", aiServerUrl);

            // 요청 Body 생성
            Map<String, String> requestBody = new HashMap<>();
            requestBody.put("text", question);

            // HTTP 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // HTTP 요청 엔티티 생성
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(requestBody, headers);

            // AI 서버로 POST 요청
            ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                    aiServerUrl,
                    HttpMethod.POST,
                    entity,
                    new org.springframework.core.ParameterizedTypeReference<Map<String, Object>>() {
                    });

            // 응답 처리
            Map<String, Object> responseBody = response.getBody();
            if (response.getStatusCode() == HttpStatus.OK && responseBody != null) {
                Object answerObj = responseBody.get("answer");
                answer = (answerObj != null) ? answerObj.toString() : "";

                if (answer == null || answer.trim().isEmpty()) {
                    log.warn("⚠️ AI 서버 응답이 비어있음");
                    answer = "답변을 생성하지 못했습니다.";
                } else {
                    log.info("✅ AI 답변 수신 성공 (길이: {}자)", answer.length());
                }
            } else {
                log.error("❌ AI 서버 응답 오류 (Status: {})", response.getStatusCode());
                answer = "죄송합니다. AI 서비스에 일시적인 문제가 발생했습니다.";
            }

        } catch (org.springframework.web.client.ResourceAccessException e) {
            // 네트워크/타임아웃 오류
            log.error("❌ AI 서버({}:{}) 연결 실패: {}", aiServerHost, aiServerPort, e.getMessage());
            answer = String.format("죄송합니다. AI 서버(%s)에 연결할 수 없습니다. 데스크탑 서버 상태를 확인해주세요.", aiServerHost);

        } catch (org.springframework.web.client.HttpClientErrorException e) {
            // 4xx 오류
            log.error("❌ AI 서버 요청 오류 ({}): {}", e.getStatusCode(), e.getMessage());
            answer = "죄송합니다. AI 요청 처리 중 오류가 발생했습니다.";

        } catch (org.springframework.web.client.HttpServerErrorException e) {
            // 5xx 오류 - Python 스택트레이스 상세 로깅
            log.error("❌ AI 서버 내부 오류 ({}): {}", e.getStatusCode(), e.getMessage());
            log.error("🔍 AI 서버 응답 본문: {}", e.getResponseBodyAsString()); // 핵심 디버깅 정보
            answer = "죄송합니다. AI 서버에서 오류가 발생했습니다. (로그 확인 필요)";

        } catch (Exception e) {
            // 기타 예외
            log.error("❌ 예기치 않은 오류: {}", e.getMessage(), e);
            answer = "죄송합니다. AI 서버 연결에 실패했습니다.";
        }

        // 2. DTO
        ChatDTO chat = ChatDTO.builder()
                .memberId(memberId)
                .question(question)
                .answer(answer)
                .build();

        // 3. Redis 큐에 전송 (비동기 DB 저장)
        try {
            // Redis 접속 정보 로깅 (디버깅용)
            redisTemplate.opsForList().rightPush("chat_log_queue", chat);
            log.info("🚀 Redis 큐 전송 완료 (DB 저장 대기)");
        } catch (Exception e) {
            log.error("❌ Redis 서버 연결 실패 - 설정된 Host 확인 필요: {}", e.getMessage());
            try {
                // 비상용: Redis 장애 시 직접 DB 저장
                chatMapper.insertChat(chat);
                log.warn("⚠️ Redis 불가 - DB 직접 저장 완료 (LogID: {})", chat.getLogId());
            } catch (Exception dbError) {
                log.error("❌❌ DB 저장도 실패! 데이터 유실 위험: {}", dbError.getMessage());
            }
        }

        return chat;
    }

    /**
     * 채팅 이력 조회
     */
    @Override
    public List<ChatDTO> getChatHistory(String memberId) {
        return chatMapper.selectChatHistoryByMemberId(memberId);
    }

    /**
     * 채팅 이력 삭제
     */
    @Override
    public void clearChatHistory(String memberId) {
        log.info("채팅 이력 삭제 요청: {}", memberId);
        chatMapper.deleteChatHistoryByMemberId(memberId);
    }
}
