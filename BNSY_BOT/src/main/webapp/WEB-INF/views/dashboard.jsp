<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>BNSY 봇 - 관리자 대시보드</title>
                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Google Fonts -->
                <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
                    rel="stylesheet">
                <!-- Bootstrap Icons -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
                    rel="stylesheet">
                <!-- Chart.js -->
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                <style>
                    * {
                        font-family: 'Noto Sans KR', sans-serif;
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        background: #f5f5f5;
                        height: 100vh;
                        overflow: hidden;
                    }

                    .chat-container {
                        display: flex;
                        height: 100vh;
                        position: relative;
                    }

                    /* ========== 좌측 사이드바 ========== */
                    .sidebar-left {
                        width: 20%;
                        min-width: 200px;
                        background: #EDEEF3;
                        display: flex;
                        flex-direction: column;
                        border-right: 1px solid #c8cdd3;
                        transition: all 0.3s ease;
                        position: relative;
                    }

                    .sidebar-left.collapsed {
                        width: 60px;
                        min-width: 60px;
                    }

                    .sidebar-left.collapsed .sidebar-content {
                        opacity: 0;
                        pointer-events: none;
                    }

                    .sidebar-content {
                        transition: opacity 0.3s ease;
                        text-align: left;
                        width: 100%;
                    }

                    .sidebar-toggle {
                        position: absolute;
                        top: 15px;
                        right: 15px;
                        width: 30px;
                        height: 30px;
                        background: white;
                        border: 1px solid #c8cdd3;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        z-index: 10;
                        transition: all 0.3s ease;
                    }

                    .sidebar-toggle:hover {
                        background: #f5f5f5;
                    }

                    .sidebar-header {
                        padding: 60px 20px 20px 20px;
                        background: #EDEEF3;
                    }

                    .user-section {
                        position: relative;
                        margin-bottom: 20px;
                    }

                    .user-greeting {
                        font-size: 14px;
                        color: #333;
                        margin-bottom: 5px;
                    }

                    .logout-btn {
                        position: absolute;
                        bottom: 0;
                        right: 0;
                        padding: 5px 14px;
                        background: linear-gradient(135deg, #ff6b7a 0%, #ff8a95 100%);
                        color: white;
                        border: none;
                        border-radius: 6px;
                        font-size: 12px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .logout-btn:hover {
                        background: linear-gradient(135deg, #ff8a95 0%, #ffa0a8 100%);
                    }

                    .sidebar-menu {
                        padding: 0 15px;
                    }

                    .menu-btn {
                        width: 100%;
                        padding: 13px 16px;
                        background: #c8cdd3;
                        color: #666;
                        border: none;
                        border-radius: 8px;
                        font-size: 14px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        margin-bottom: 10px;
                        text-align: left;
                    }

                    .menu-btn:hover {
                        background: #b8bdc3;
                    }

                    .menu-btn.active {
                        background: linear-gradient(135deg, #888 0%, #666 100%);
                        color: white;
                    }

                    .sidebar-footer {
                        margin-top: 160%;
                        padding: 15px 15px 25px 20px;
                        font-size: 11px;
                        color: #666;
                        border-top: 1px solid #c8cdd3;
                        line-height: 1.6;
                        text-align: left !important;
                        display: block;
                        width: 100%;
                    }


                    /* ========== 메인 콘텐츠 영역 ========== */
                    .main-content {
                        flex: 1;
                        display: flex;
                        flex-direction: column;
                        background: #fdfdfd;
                        position: relative;
                        align-items: center;
                        overflow: hidden;
                    }

                    /* 로고 영역 */
                    .logo-area {
                        padding: 50px 20px 30px 20px;
                        text-align: center;
                        width: 100%;
                        flex-shrink: 0;

                    }

                    .logo-area img {
                        max-width: 250px;
                        height: auto;
                    }

                    /* 대시보드 그리드 래퍼 */
                    .dashboard-wrapper {
                        flex: 1;
                        width: 100%;
                        padding: 0 40px 40px 40px;
                        overflow-y: auto;
                        max-width: 1200px;
                        margin: 0 auto;
                    }

                    .dashboard-wrapper::-webkit-scrollbar {
                        width: 6px;
                    }

                    .dashboard-wrapper::-webkit-scrollbar-track {
                        background: #f1f1f1;
                    }

                    .dashboard-wrapper::-webkit-scrollbar-thumb {
                        background: #ccc;
                        border-radius: 3px;
                    }

                    /* ===== 카드 공통 ===== */
                    .card-box {
                        background: white;
                        border: 1px solid #777;
                        border-radius: 8px;
                        padding: 20px;
                        height: 100%;
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
                    }

                    /* 1열: 서버 사양 & 리소스 모니터 */
                    .row-specs {
                        display: flex;
                        gap: 20px;
                        margin-bottom: 20px;
                        height: 280px;
                    }

                    .box-specs {
                        flex: 0 0 35%;
                        font-size: 14px;
                        line-height: 1.6;
                        color: #333;
                    }

                    .box-specs h5 {
                        font-weight: bold;
                        margin-bottom: 15px;
                        font-size: 16px;
                    }

                    .box-resources {
                        flex: 1;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        gap: 15px;
                        min-width: 0;
                    }

                    /* 리소스 미니 차트 박스 */
                    .resource-item {
                        flex: 1;
                        height: 100%;
                        display: flex;
                        flex-direction: column;
                        border: 1px solid #eee;
                        border-radius: 8px;
                        padding: 10px;
                        background: #fff;
                        min-width: 0;
                    }

                    .resource-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: flex-start;
                        margin-bottom: 10px;
                    }

                    .resource-title {
                        font-size: 14px;
                        color: #555;
                        font-weight: 600;
                    }

                    .resource-value {
                        font-size: 13px;
                        color: #888;
                    }

                    .chart-container-mini {
                        flex: 1;
                        position: relative;
                        background: #f9f9f9;
                        /* 차트 배경 */
                        border-radius: 4px;
                        padding: 5px;
                    }

                    /* 2열: RPM, Latency, Status */
                    .row-metrics {
                        display: flex;
                        gap: 20px;
                        margin-bottom: 20px;
                        height: 100px;
                    }

                    .metric-card {
                        flex: 1;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: 15px 20px;
                    }

                    .metric-info h6 {
                        font-size: 14px;
                        color: #333;
                        margin-bottom: 5px;
                        font-weight: 600;
                    }

                    .metric-number {
                        font-size: 20px;
                        font-weight: bold;
                        color: #333;
                    }

                    .metric-chart-mini {
                        width: 50%;
                        height: 100%;
                        position: relative;
                    }

                    /* Status 전용 */
                    .status-content {
                        display: flex;
                        align-items: center;
                        gap: 15px;
                        width: 100%;
                        justify-content: center;
                    }

                    .status-dot {
                        width: 30px;
                        height: 30px;
                        border-radius: 50%;
                        background: #198754;
                    }

                    .status-text-area {
                        display: flex;
                        flex-direction: column;
                    }

                    .status-main {
                        font-weight: bold;
                        font-size: 16px;
                        color: #333;
                    }

                    .status-sub {
                        font-size: 12px;
                        color: #666;
                    }

                    /* 3열: 질문목록 */
                    .question-section h5 {
                        font-size: 16px;
                        font-weight: bold;
                        margin-bottom: 0;
                        padding: 10px 0;
                    }

                    .filter-bar {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 15px;
                    }

                    .left-controls {
                        display: flex;
                        align-items: center;
                        gap: 20px;
                    }

                    .count-text {
                        font-weight: bold;
                        color: #333;
                    }

                    /* 탭 버튼 스타일 */
                    .time-tabs {
                        display: flex;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        overflow: hidden;
                        background: white;
                    }

                    .time-tab {
                        padding: 6px 16px;
                        background: white;
                        border: none;
                        border-right: 1px solid #eee;
                        font-size: 13px;
                        cursor: pointer;
                        transition: 0.2s;
                    }

                    .time-tab:last-child {
                        border-right: none;
                    }

                    .time-tab.active {
                        background: #888;
                        color: white;
                    }

                    .time-tab:hover:not(.active) {
                        background: #f5f5f5;
                    }

                    .search-area {
                        display: flex;
                        gap: 5px;
                    }

                    .search-input {
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        padding: 5px 10px;
                        width: 250px;
                        font-size: 13px;
                    }

                    .btn-search {
                        background: #ccc;
                        border: none;
                        padding: 5px 15px;
                        border-radius: 4px;
                        color: white;
                        font-size: 13px;
                        font-weight: bold;
                    }

                    /* 테이블 */
                    .qa-table {
                        width: 100%;
                        border-top: 2px solid #aaa;
                        /* 상단 진한 선 */
                        border-bottom: 1px solid #ccc;
                    }

                    .qa-table th {
                        background: #f1f3f5;
                        padding: 12px 10px;
                        font-weight: 600;
                        font-size: 13px;
                        text-align: center;
                        color: #333;
                    }

                    .qa-table td {
                        padding: 12px 10px;
                        font-size: 13px;
                        border-bottom: 1px solid #eee;
                        color: #333;
                        vertical-align: middle;
                    }

                    .qa-table tr:last-child td {
                        border-bottom: none;
                    }

                    .btn-answer {
                        background: #ddd;
                        color: #fff;
                        border: none;
                        padding: 4px 12px;
                        border-radius: 4px;
                        font-size: 12px;
                        font-weight: bold;
                    }

                    .btn-answer.done {
                        background: #aaa;
                        /* 답변 완료 시 색상 */
                    }

                    /* 반응형 */
                    @media (max-width: 768px) {
                        .sidebar-left {
                            position: absolute;
                            width: 80%;
                            height: 100vh;
                            z-index: 100;
                        }

                        .row-specs,
                        .row-metrics,
                        .filter-bar {
                            flex-direction: column;
                            height: auto;
                        }

                        .box-specs,
                        .metric-card {
                            margin-bottom: 10px;
                        }
                    }
                </style>
            </head>

            <body>

                <div class="chat-container">
                    <!-- ========== 좌측 사이드바 ========== -->
                    <div class="sidebar-left" id="sidebar">
                        <button class="sidebar-toggle" onclick="toggleSidebar()">
                            <i class="bi bi-chevron-left" id="toggleIcon"></i>
                        </button>

                        <div class="sidebar-content">
                            <div class="sidebar-header">
                                <div class="user-section">
                                    <div class="user-greeting">
                                        ${not empty loginMember ? loginMember.memberName : '관리자'}님 안녕하세요.
                                    </div>
                                    <button class="logout-btn" onclick="logout()">로그아웃</button>
                                </div>
                            </div>

                            <div class="sidebar-menu">
                                <button class="menu-btn"
                                    onclick="location.href='${pageContext.request.contextPath}/chat'">
                                    벤시 봇 QnA
                                </button>
                                <button class="menu-btn active">
                                    대시보드
                                </button>
                            </div>

                            <div class="sidebar-footer">
                                Copyright @ 2026, OOO All rights reserved<br>
                                TEL: 010-****-****<br>
                                git: github.com/***
                            </div>
                        </div>
                    </div>

                    <!-- ========== 메인 콘텐츠 ========== -->
                    <div class="main-content">
                        <!-- 로고 -->
                        <div class="logo-area">
                            <img src="${pageContext.request.contextPath}/resources/images/BNSY_BOT.png" alt="BNSY 봇">
                        </div>

                        <div class="dashboard-wrapper">

                            <!-- 1열: 서버 사양 + 리소스 -->
                            <div class="row-specs">
                                <!-- 서버 사양 -->
                                <div class="card-box box-specs">
                                    <h5>서버 사양</h5>
                                    <p id="serverSpecs">
                                    </p>
                                </div>

                                <!-- 리소스 모니터 (3개 분할) -->
                                <div class="card-box box-resources">
                                    <!-- CPU -->
                                    <div class="resource-item">
                                        <div class="resource-header">
                                            <span class="resource-title" style="color:#0d6efd;">CPU</span>
                                            <span class="resource-value" id="labelCpu">Usage: 0%</span>
                                        </div>
                                        <div class="chart-container-mini">
                                            <canvas id="chartCpu"></canvas>
                                        </div>
                                    </div>
                                    <!-- Memory -->
                                    <div class="resource-item">
                                        <div class="resource-header">
                                            <span class="resource-title" style="color:#6f42c1;">메모리</span>
                                            <span class="resource-value" id="labelMem">Loading...</span>
                                        </div>
                                        <div class="chart-container-mini">
                                            <canvas id="chartMem"></canvas>
                                        </div>
                                    </div>
                                    <!-- GPU -->
                                    <div class="resource-item">
                                        <div class="resource-header">
                                            <span class="resource-title" style="color:#198754;">GPU</span>
                                            <span class="resource-value" id="labelGpu">Usage: 0%</span>
                                        </div>
                                        <div class="chart-container-mini">
                                            <canvas id="chartGpu"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 2열: RPM, Latency, Status -->
                            <div class="row-metrics">
                                <div class="card-box metric-card">
                                    <div class="metric-info">
                                        <h6>RPM</h6>
                                        <div class="metric-number" id="valRpm">0</div>
                                    </div>
                                    <div class="metric-chart-mini">
                                        <canvas id="chartRpm"></canvas>
                                    </div>
                                </div>
                                <div class="card-box metric-card">
                                    <div class="metric-info">
                                        <h6>Latency</h6>
                                        <div class="metric-number" id="valLatency">0s</div>
                                    </div>
                                    <div class="metric-chart-mini">
                                        <canvas id="chartLatency"></canvas>
                                    </div>
                                </div>
                                <div class="card-box metric-card">
                                    <div class="status-content">
                                        <div class="status-dot" id="statusDot"></div>
                                        <div class="status-text-area">
                                            <span class="status-main" id="statusMain">정상</span>
                                            <span class="status-sub" id="statusSub">(Normal)</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 3열: 질문 목록 -->
                            <div class="question-section">

                                <div class="filter-bar">
                                    <div class="left-controls">
                                        <h5>질문목록</h5>
                                        <!-- 시간 탭 -->
                                        <div class="time-tabs">
                                            <button class="time-tab" data-period="1h"
                                                onclick="setDateRange('1h')">1시간</button>
                                            <button class="time-tab" data-period="1d"
                                                onclick="setDateRange('1d')">1일</button>
                                            <button class="time-tab" data-period="1w"
                                                onclick="setDateRange('1w')">1주</button>
                                            <button class="time-tab active" data-period="all"
                                                onclick="setDateRange('all')">전체</button>
                                        </div>
                                    </div>

                                    <div class="search-area">
                                        <div class="count-text align-self-center me-3">${chatLogs != null ?
                                            chatLogs.size() : 0}건</div>
                                        <form action="" method="get" class="d-flex gap-2">
                                            <input type="hidden" name="startDate" id="startDate" value="${startDate}">
                                            <input type="hidden" name="endDate" id="endDate" value="${endDate}">

                                            <input type="text" class="search-input" placeholder="" disabled
                                                style="background:#fff;">
                                            <button type="button" class="btn-search">검색</button>
                                        </form>
                                    </div>
                                </div>

                                <!-- 테이블 -->
                                <table class="qa-table">
                                    <colgroup>
                                        <col width="20%">
                                        <col width="15%">
                                        <col width="55%">
                                        <col width="10%">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>일시</th>
                                            <th>사용자ID</th>
                                            <th>질문 내용</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty chatLogs}">
                                                <tr>
                                                    <td colspan="4" class="text-center py-4 text-muted">데이터가 없습니다.</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="chat" items="${chatLogs}">
                                                    <tr>
                                                        <td class="text-center">
                                                            <fmt:formatDate value="${chat.chatDt}"
                                                                pattern="yyyy-MM-dd HH:mm" />
                                                        </td>
                                                        <td class="text-center">${chat.memberId}</td>
                                                        <td style="padding-left: 20px;">
                                                            ${chat.question}
                                                        </td>
                                                        <td class="text-center">
                                                            <button class="btn-answer"
                                                                data-question="<c:out value='${chat.question}'/>"
                                                                data-answer="<c:out value='${chat.answer}'/>"
                                                                onclick="showDetail(this)">답변</button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>

                            </div>

                        </div>
                    </div>
                </div>

                <!-- 로그아웃 확인 모달 -->
                <div class="modal fade" id="logoutModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content" style="border-radius: 16px;">
                            <div class="modal-header">
                                <h5 class="modal-title fw-bold">로그아웃 확인</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body text-center py-4">
                                정말 로그아웃 하시겠습니까?
                            </div>
                            <div class="modal-footer justify-content-center border-0">
                                <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">취소</button>
                                <button type="button" class="btn btn-danger px-4" id="confirmLogoutBtn">로그아웃</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 상세 보기 모달 -->
                <div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">질문 상세</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="fw-bold text-primary">질문</label>
                                    <div class="p-3 bg-light rounded mt-1" id="modalQuestion"></div>
                                </div>
                                <div class="mb-3">
                                    <label class="fw-bold text-success">답변</label>
                                    <div class="p-3 bg-light rounded mt-1" id="modalAnswer"
                                        style="white-space: pre-wrap;"></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    const contextPath = '${pageContext.request.contextPath}';

                    // 데스크탑 서버 스펙
                    const SERVER_SPECS = {
                        cpu: 'Intel Core i5-10400 @ 2.90GHz',
                        gpu: 'NVIDIA GeForce RTX 2060 (8GB)',
                        os: 'Windows 10 Host (On-Premise)',
                        env: 'Oracle 21c XE, Ollama (Llama3)'
                    };

                    const TOTAL_MEM = 16; // GB

                    // 1. 차트 설정 공통 옵션
                    const commonOptions = {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        scales: {
                            x: { display: false },
                            y: { display: false, beginAtZero: true }
                        },
                        elements: {
                            point: { radius: 0 },
                            line: { cubicInterpolationMode: 'monotone', display: false /* fill only */ }
                        },
                        animation: { duration: 0 }
                    };

                    // 2. 차트 초기화 함수
                    function initChart(id, color, isFill = true) {
                        const ctx = document.getElementById(id).getContext('2d');
                        return new Chart(ctx, {
                            type: 'line',
                            data: {
                                labels: [],
                                datasets: [{
                                    borderWidth: 2,
                                    borderColor: color,
                                    backgroundColor: isFill ? color + '20' : 'transparent',
                                    data: [],
                                    fill: isFill,
                                    tension: 0.4
                                }]
                            },
                            options: commonOptions
                        });
                    }

                    // 5개 차트 생성
                    const chartCpu = initChart('chartCpu', '#0d6efd'); // Blue
                    const chartMem = initChart('chartMem', '#6f42c1'); // Purple
                    const chartGpu = initChart('chartGpu', '#198754'); // Green
                    const chartRpm = initChart('chartRpm', '#0dcaf0'); // Cyan
                    const chartLatency = initChart('chartLatency', '#fd7e14'); // Orange

                    // 3. 데이터 갱신
                    function fetchMetrics() {
                        fetch(contextPath + '/api/system/metrics')
                            .then(res => res.json())
                            .then(data => {
                                if (!data || data.length === 0) return;

                                const labels = data.map(d => '');
                                const cpuData = data.map(d => d.cpuUsage);
                                const memData = data.map(d => d.memUsage);
                                const gpuData = data.map(d => d.gpuUsage);
                                const rpmData = data.map(d => d.rpm);
                                const latData = data.map(d => d.latency);

                                updateChart(chartCpu, labels, cpuData);
                                updateChart(chartMem, labels, memData);
                                updateChart(chartGpu, labels, gpuData);
                                updateChart(chartRpm, labels, rpmData);
                                updateChart(chartLatency, labels, latData);

                                // 최신 데이터
                                const last = data[data.length - 1];

                                // 1) CPU
                                document.getElementById('labelCpu').innerText = last.cpuUsage + '%';

                                // 2) MEM
                                const usedMem = (TOTAL_MEM * last.memUsage / 100).toFixed(1);
                                document.getElementById('labelMem').innerText = usedMem + ' / ' + TOTAL_MEM + 'GB (' + last.memUsage + '%)';

                                // 3) GPU
                                const TOTAL_GPU = 8;
                                const usedGpu = (TOTAL_GPU * last.gpuUsage / 100).toFixed(1);
                                document.getElementById('labelGpu').innerText = usedGpu + ' / ' + TOTAL_GPU + 'GB (' + last.gpuUsage + '%)';

                                // RPM, Latency
                                document.getElementById('valRpm').innerText = last.rpm;
                                document.getElementById('valLatency').innerText = last.latency + 's';

                                // Status
                                const dot = document.getElementById('statusDot');
                                const txtMain = document.getElementById('statusMain');
                                const txtSub = document.getElementById('statusSub');

                                if (last.status === 'NORMAL') {
                                    dot.style.background = '#198754';
                                    txtMain.innerText = '정상';
                                    txtSub.innerText = '(Normal)';
                                } else if (last.status === 'WARNING') {
                                    dot.style.background = '#ffc107';
                                    txtMain.innerText = '주의';
                                    txtSub.innerText = '(Warning)';
                                } else {
                                    dot.style.background = '#dc3545';
                                    txtMain.innerText = '오류';
                                    txtSub.innerText = '(Error)';
                                }
                            })
                            .catch(err => console.error(err));
                    }

                    function updateChart(chart, labels, data) {
                        chart.data.labels = labels;
                        chart.data.datasets[0].data = data;
                        chart.update();
                    }

                    // 호출
                    setInterval(fetchMetrics, 5000);
                    fetchMetrics();

                    // 4. 날짜 필터
                    const currentPeriod = '${period}';

                    // 초기 로드 시 활성 탭 설정
                    document.addEventListener('DOMContentLoaded', function () {
                        // [2. Server Specs 렌더링]
                        const specHtml =
                            'CPU: ' + SERVER_SPECS.cpu + '<br>' +
                            'GPU: ' + SERVER_SPECS.gpu + '<br>' +
                            'OS: ' + SERVER_SPECS.os + '<br>' +
                            'ENV: ' + SERVER_SPECS.env;
                        document.getElementById('serverSpecs').innerHTML = specHtml;

                        const tabs = document.querySelectorAll('.time-tab');
                        tabs.forEach(tab => {
                            if (tab.getAttribute('data-period') === currentPeriod) {
                                tab.classList.add('active');
                            } else {
                                tab.classList.remove('active');
                            }
                        });

                        // 만약 period가 없거나 all이면 전체 탭 활성화
                        if (!currentPeriod || currentPeriod === 'all') {
                            document.querySelector('.time-tab[data-period="all"]')?.classList.add('active');
                        }
                    });

                    function setDateRange(range) {
                        location.href = contextPath + '/system/dashboard?period=' + range;
                    }

                    // ... (기타 사이드바/로그아웃/모달)
                    function toggleSidebar() {
                        const sidebar = document.getElementById('sidebar');
                        const icon = document.getElementById('toggleIcon');
                        sidebar.classList.toggle('collapsed');
                        icon.className = sidebar.classList.contains('collapsed') ? 'bi bi-chevron-right' : 'bi bi-chevron-left';
                    }

                    function logout() {
                        new bootstrap.Modal(document.getElementById('logoutModal')).show();
                    }
                    document.getElementById('confirmLogoutBtn').addEventListener('click', function () {
                        location.href = contextPath + '/logout';
                    });

                    function showDetail(btn) {
                        const q = btn.getAttribute('data-question');
                        const a = btn.getAttribute('data-answer');
                        document.getElementById('modalQuestion').innerText = q;
                        document.getElementById('modalAnswer').innerText = a;
                        new bootstrap.Modal(document.getElementById('detailModal')).show();
                    }

                </script>
            </body>

            </html>