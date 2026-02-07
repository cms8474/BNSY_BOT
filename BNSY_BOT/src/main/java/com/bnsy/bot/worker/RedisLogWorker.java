package com.bnsy.bot.worker;

import com.bnsy.bot.dto.ChatDTO;
import com.bnsy.bot.mapper.ChatMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Redis 큐에서 채팅 로그를 꺼내 DB에 저장하는 백그라운드 Worker
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RedisLogWorker {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ChatMapper chatMapper;

    /**
     * 1초마다 Redis 큐를 확인하여 DB에 저장
     */
    @Scheduled(fixedDelay = 1000)
    public void processLogQueue() {
        try {
            // 큐 '조회'
            Object data = redisTemplate.opsForList().index("chat_log_queue", 0);

            if (data instanceof ChatDTO) {
                ChatDTO logData = (ChatDTO) data;
                log.info("📥 [Worker] 로그 감지: {}", logData.getQuestion());

                // DB 저장
                chatMapper.insertChat(logData);

                // 큐에서 제거
                redisTemplate.opsForList().leftPop("chat_log_queue");

                log.info("✅ [Worker] DB 저장 완료 & 큐 제거 (LogID: {})", logData.getLogId());
            } else if (data != null) {
                // 예상치 못한 타입의 데이터 발견
                log.warn("⚠️ 알 수 없는 데이터 타입 감지: {}", data.getClass().getName());
                redisTemplate.opsForList().leftPop("chat_log_queue"); // 문제 데이터 제거
            }
        } catch (Exception e) {
            log.error("❌ [Worker] DB 저장 실패 (데이터 보존됨, 재시도 예정): {}", e.getMessage());
        }
    }
}
