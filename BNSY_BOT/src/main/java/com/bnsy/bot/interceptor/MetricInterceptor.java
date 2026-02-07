package com.bnsy.bot.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.Getter;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

@Component
public class MetricInterceptor implements HandlerInterceptor {

    @Getter
    private final AtomicInteger requestCount = new AtomicInteger(0);

    @Getter
    private final AtomicLong totalLatencyMs = new AtomicLong(0);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        request.setAttribute("startTime", System.currentTimeMillis());
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        Object startTimeObj = request.getAttribute("startTime");
        if (startTimeObj instanceof Long) {
            long startTime = (Long) startTimeObj;
            long endTime = System.currentTimeMillis();
            long duration = endTime - startTime;

            requestCount.incrementAndGet();
            totalLatencyMs.addAndGet(duration);
        }
    }

    /**
     * 카운터 초기화 (스케줄러가 데이터를 가져간 후 호출)
     */
    public void reset() {
        requestCount.set(0);
        totalLatencyMs.set(0);
    }
}
