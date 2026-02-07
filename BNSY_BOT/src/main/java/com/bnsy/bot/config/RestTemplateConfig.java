package com.bnsy.bot.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

/**
 * RestTemplate 설정 (AI 서버 HTTP 통신용)
 */
@Configuration
public class RestTemplateConfig {

    @Bean
    public RestTemplate restTemplate() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();

        // 타임아웃 설정 (데스크탑 AI 서버 응답 대기)
        factory.setConnectTimeout(5000); // 연결 타임아웃: 5초
        factory.setReadTimeout(30000); // 읽기 타임아웃: 30초 (LLM 응답 대기)

        return new RestTemplate(factory);
    }
}
