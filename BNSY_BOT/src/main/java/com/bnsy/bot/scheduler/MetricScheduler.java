package com.bnsy.bot.scheduler;

import com.bnsy.bot.dto.ServerMetricDTO;
import com.bnsy.bot.mapper.DashboardMapper;
import com.sun.management.OperatingSystemMXBean;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.lang.management.ManagementFactory;
import java.util.Random;

@Slf4j
@Component
@RequiredArgsConstructor
public class MetricScheduler {

    private final DashboardMapper dashboardMapper;
    private final com.bnsy.bot.interceptor.MetricInterceptor metricInterceptor;
    private final Random random = new Random();

    /**
     * 5초마다 시스템 메트릭 수집 및 저장
     */
    @Scheduled(fixedRate = 5000)
    public void collectMetrics() {
        try {
            OperatingSystemMXBean osBean = ManagementFactory.getPlatformMXBean(OperatingSystemMXBean.class);

            // CPU Usage (0.0 ~ 1.0) -> Percentage
            double cpuLoad = osBean.getCpuLoad() * 100;
            if (cpuLoad < 0)
                cpuLoad = 0;

            // Memory Usage
            long totalMem = osBean.getTotalMemorySize();
            long freeMem = osBean.getFreeMemorySize();
            long usedMem = totalMem - freeMem;
            double memUsage = (double) usedMem / totalMem * 100;

            // GPU Usage
            double gpuUsage = 10 + (random.nextDouble() * 30);

            // Real RPM & Latency from Interceptor
            int requestCount = metricInterceptor.getRequestCount().get();
            long totalLatencyMs = metricInterceptor.getTotalLatencyMs().get();
            metricInterceptor.reset();

            // 분당 요청 수(RPM)로 환산 (x12)
            int rpm = requestCount * 12;

            // 평균 Latency (초 단위)
            double latency = 0.0;
            if (requestCount > 0) {
                latency = (double) totalLatencyMs / requestCount / 1000.0;
            }

            ServerMetricDTO metric = ServerMetricDTO.builder()
                    .serverIp("192.168.0.19")
                    .cpuUsage(Math.round(cpuLoad * 100) / 100.0)
                    .memUsage(Math.round(memUsage * 100) / 100.0)
                    .gpuUsage(Math.round(gpuUsage * 100) / 100.0)
                    .rpm(rpm)
                    .latency(Math.round(latency * 1000) / 1000.0)
                    .status("NORMAL")
                    .build();

            dashboardMapper.insertMetric(metric);

        } catch (Exception e) {
            log.error("메트릭 수집 중 오류: {}", e.getMessage());
        }
    }
}
