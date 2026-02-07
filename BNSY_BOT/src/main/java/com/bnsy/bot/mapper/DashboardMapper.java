package com.bnsy.bot.mapper;

import com.bnsy.bot.dto.ChatDTO;
import com.bnsy.bot.dto.ServerMetricDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DashboardMapper {

    /**
     * 최근 시스템 메트릭 조회
     * 
     * @param limit 조회할 개수
     * @return 시간순(ASC)으로 정렬된 메트릭 리스트
     */
    List<ServerMetricDTO> selectRecentMetrics(@Param("limit") int limit);

    /**
     * 시스템 메트릭 저장
     * 
     * @param metric
     */
    void insertMetric(ServerMetricDTO metric);

    /**
     * 대화 이력 조회 (검색 조건 포함)
     * 
     * @param startDate 조회 시작일 (YYYY-MM-DD)
     * @param endDate   조회 종료일 (YYYY-MM-DD)
     * @return 최신순(DESC) 리스트
     */
    List<ChatDTO> selectChatLogs(@Param("startDate") String startDate,
            @Param("endDate") String endDate,
            @Param("period") String period);
}
