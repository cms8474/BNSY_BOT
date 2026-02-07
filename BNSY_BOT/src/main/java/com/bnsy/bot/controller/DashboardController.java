package com.bnsy.bot.controller;

import com.bnsy.bot.dto.ChatDTO;
import com.bnsy.bot.dto.ServerMetricDTO;
import com.bnsy.bot.mapper.DashboardMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardMapper dashboardMapper;

    /**
     * 대시보드 페이지
     * URL: /system/dashboard
     */
    @GetMapping("/system/dashboard")
    public String dashboard(Model model,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false, defaultValue = "all") String period) {

        // 검색 조건에 맞는 채팅 이력 조회
        List<ChatDTO> chatLogs = dashboardMapper.selectChatLogs(startDate, endDate, period);
        model.addAttribute("chatLogs", chatLogs);

        // 검색어 유지용
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("period", period);

        return "dashboard";
    }

    /**
     * 시스템 리소스 메트릭 API (JSON)
     * URL: /api/system/metrics
     */
    @GetMapping("/api/system/metrics")
    @ResponseBody
    public List<ServerMetricDTO> getMetrics() {
        return dashboardMapper.selectRecentMetrics(30);
    }
}
