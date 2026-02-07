package com.bnsy.bot.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

/**
 * 시스템 리소스 메트릭 DTO
 * SERVER_METRIC 테이블 매핑
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ServerMetricDTO {
    private Long metricId; // METRIC_ID
    private String serverIp; // SERVER_IP
    private Double cpuUsage; // CPU_USAGE
    private Double memUsage; // MEM_USAGE
    private Double gpuUsage; // GPU_USAGE
    private Integer rpm; // RPM
    private Double latency; // LATENCY
    private String status; // STATUS
    private Date logDt; // LOG_DT
}
