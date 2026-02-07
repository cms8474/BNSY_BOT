<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>BNSY 봇 - 채팅</title>
            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Google Fonts -->
            <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
                rel="stylesheet">
            <!-- Bootstrap Icons -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
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

                /* 사이드바 토글 버튼 */
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

                /* 사이드바 헤더 */
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

                /* 메뉴 버튼들 */
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

                /* ========== 중앙 채팅 영역 ========== */
                .main-content {
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    background: white;
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

                /* 채팅 컨테이너 (중앙 정렬) */
                .chat-wrapper {
                    flex: 1;
                    width: 100%;
                    max-width: 800px;
                    display: flex;
                    flex-direction: column;
                    padding: 0 40px;
                    overflow: hidden;
                    min-height: 0;
                }

                /* 대화창 */
                .chat-messages {
                    flex: 1;
                    overflow-y: auto;
                    padding: 20px;
                    min-height: 0;
                    background: white;
                    border: 1px solid #e0e0e0;
                    border-radius: 16px;
                    margin-bottom: 20px;
                }

                .message {
                    display: flex;
                    margin-bottom: 18px;
                    align-items: flex-start;
                }

                .message.bot {
                    justify-content: flex-start;
                }

                .message.user {
                    justify-content: flex-end;
                }

                .message-avatar {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background: white;
                    border: 1px solid #e0e0e0;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    flex-shrink: 0;
                    overflow: hidden;
                }

                .message-avatar img {
                    width: 32px;
                    height: 32px;
                    object-fit: cover;
                }

                .message.user .message-avatar {
                    background: transparent;
                    border: none;
                }

                .message.user .message-avatar img {
                    width: 40px;
                    height: 40px;
                }

                .message-content {
                    margin: 0 12px;
                    max-width: 70%;
                }

                .message-bubble {
                    padding: 12px 16px;
                    border-radius: 12px;
                    word-wrap: break-word;
                    line-height: 1.5;
                    font-size: 14px;
                }

                .message.bot .message-bubble {
                    background: #f0f0f0;
                    color: #333;
                }

                .message.user .message-bubble {
                    background: linear-gradient(135deg, #ffe5e8 0%, #fff0f2 100%);
                    color: #333;
                }

                /* 입력 영역 */
                .chat-input-area {
                    padding-bottom: 30px;
                    background: white;
                }

                .input-container {
                    background: white;
                    border: 1px solid #e0e0e0;
                    border-radius: 12px;
                    padding: 15px;
                }

                .chat-input {
                    width: 100%;
                    padding: 12px;
                    border: 1px solid #e0e0e0;
                    border-radius: 8px;
                    font-size: 13px;
                    outline: none;
                    resize: none;
                    min-height: 80px;
                    margin-bottom: 12px;
                }

                .chat-input:focus {
                    border-color: #ff6b7a;
                }

                .input-buttons {
                    display: flex;
                    justify-content: space-between;
                    gap: 10px;
                }

                .btn-input {
                    padding: 10px 30px;
                    border: none;
                    border-radius: 8px;
                    font-size: 13px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .btn-send {
                    background: linear-gradient(135deg, #ff6b7a 0%, #ff8a95 100%);
                    color: white;
                }

                .btn-send:hover {
                    background: linear-gradient(135deg, #ff8a95 0%, #ffa0a8 100%);
                }

                .btn-clear {
                    background: linear-gradient(135deg, #ff6b7a 0%, #ff8a95 100%);
                    color: white;
                }

                .btn-clear:hover {
                    background: linear-gradient(135deg, #ff8a95 0%, #ffa0a8 100%);
                }

                /* 스크롤바 */
                .chat-messages::-webkit-scrollbar {
                    width: 6px;
                }

                .chat-messages::-webkit-scrollbar-track {
                    background: #f1f1f1;
                }

                .chat-messages::-webkit-scrollbar-thumb {
                    background: #ccc;
                    border-radius: 3px;
                }

                /* 반응형 */
                @media (max-width: 768px) {
                    .sidebar-left {
                        position: absolute;
                        width: 80%;
                        height: 100vh;
                        z-index: 100;
                    }

                    .chat-wrapper {
                        padding: 0 20px;
                    }
                }
            </style>
        </head>

        <body>
            <div class="chat-container">
                <!-- ========== 좌측 사이드바 ========== -->
                <div class="sidebar-left" id="sidebar">
                    <!-- 토글 버튼 -->
                    <button class="sidebar-toggle" onclick="toggleSidebar()">
                        <i class="bi bi-chevron-left" id="toggleIcon"></i>
                    </button>

                    <div class="sidebar-content">
                        <div class="sidebar-header">
                            <div class="user-section">
                                <div class="user-greeting">
                                    ${not empty loginMember ? loginMember.memberName : '게스트'}님 안녕하세요.
                                </div>
                                <button class="logout-btn" onclick="logout()">로그아웃</button>
                            </div>
                        </div>

                        <div class="sidebar-menu">
                            <button class="menu-btn active">벤시 봇 QnA</button>
                            <button class="menu-btn" onclick="goToDashboard()">대시보드</button>
                        </div>

                        <div class="sidebar-footer">
                            Copyright @ 2026, OOO All rights reserved<br>
                            TEL: 010-****-****<br>
                            git: github.com/***
                        </div>
                    </div>
                </div>

                <!-- ========== 중앙 채팅 영역 ========== -->
                <div class="main-content">
                    <!-- 로고 -->
                    <div class="logo-area">
                        <img src="${pageContext.request.contextPath}/resources/images/BNSY_BOT.png" alt="BNSY 봇">
                    </div>

                    <!-- 채팅 래퍼 (중앙 정렬) -->
                    <div class="chat-wrapper">
                        <!-- 대화창 -->
                        <div class="chat-messages" id="chatMessages">
                            <!-- 봇 메시지 1 -->
                            <div class="message bot">
                                <div class="message-avatar">
                                    <img src="${pageContext.request.contextPath}/resources/images/BNSY_ICON.png"
                                        alt="Bot">
                                </div>
                                <div class="message-content">
                                    <div class="message-bubble">
                                        안녕하세요<br>
                                        무엇을 도와드릴까요?
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 입력 영역 -->
                        <div class="chat-input-area">
                            <div class="input-container">
                                <textarea class="chat-input" placeholder="메세지를 입력하세요." id="messageInput"></textarea>
                                <div class="input-buttons">
                                    <button class="btn-input btn-send" onclick="sendMessage()">전송</button>
                                    <button class="btn-input btn-clear" onclick="clearChat()">초기화</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 로그아웃 확인 모달 -->
            <div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content"
                        style="border-radius: 16px; overflow: hidden; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                        <div class="modal-header" style="border-bottom: 1px solid #f0f0f0; padding: 20px;">
                            <h5 class="modal-title fw-bold" id="logoutModalLabel" style="font-size: 18px;">로그아웃 확인</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" style="padding: 30px 20px; text-align: center; color: #555;">
                            정말 로그아웃 하시겠습니까?
                        </div>
                        <div class="modal-footer"
                            style="border-top: none; padding: 0 20px 20px 20px; justify-content: center;">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                                style="width: 100px; padding: 10px; border-radius: 8px; font-weight: 500;">취소</button>
                            <button type="button" class="btn" id="confirmLogoutBtn"
                                style="width: 100px; padding: 10px; border-radius: 8px; font-weight: 600; background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); color: white; border: none;">로그아웃</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 대화 초기화 확인 모달 -->
            <div class="modal fade" id="clearChatModal" tabindex="-1" aria-labelledby="clearChatModalLabel"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content"
                        style="border-radius: 16px; overflow: hidden; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                        <div class="modal-header" style="border-bottom: 1px solid #f0f0f0; padding: 20px;">
                            <h5 class="modal-title fw-bold" id="clearChatModalLabel" style="font-size: 18px;">대화 초기화 확인
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" style="padding: 30px 20px; text-align: center; color: #555;">
                            정말 대화 내용을 모두 지우시겠습니까?<br>
                            <span style="font-size: 13px; color: #dc3545;">(삭제된 대화는 복구할 수 없습니다.)</span>
                        </div>
                        <div class="modal-footer"
                            style="border-top: none; padding: 0 20px 20px 20px; justify-content: center;">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                                style="width: 100px; padding: 10px; border-radius: 8px; font-weight: 500;">취소</button>
                            <button type="button" class="btn" id="confirmClearChatBtn"
                                style="width: 100px; padding: 10px; border-radius: 8px; font-weight: 600; background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); color: white; border: none;">초기화</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 알림(Alert) 모달 -->
            <div class="modal fade" id="alertModal" tabindex="-1" aria-labelledby="alertModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content"
                        style="border-radius: 16px; overflow: hidden; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                        <div class="modal-header" style="border-bottom: 1px solid #f0f0f0; padding: 20px;">
                            <h5 class="modal-title fw-bold" id="alertModalLabel" style="font-size: 18px;">알림</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" id="alertModalBody"
                            style="padding: 30px 20px; text-align: center; color: #555;">
                            <!-- 메시지 내용 -->
                        </div>
                        <div class="modal-footer"
                            style="border-top: none; padding: 0 20px 20px 20px; justify-content: center;">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                                style="width: 100px; padding: 10px; border-radius: 8px; font-weight: 500;">확인</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // 전역 변수 설정
                const contextPath = '${pageContext.request.contextPath}';
                const userIconPath = contextPath + '/resources/images/people.png';
                const botIconPath = contextPath + '/resources/images/BNSY_ICON.png';

                // 페이지 로드 시 채팅 이력 불러오기
                document.addEventListener('DOMContentLoaded', function () {
                    loadHistory();
                });

                // 사이드바 접기/펼치기
                function toggleSidebar() {
                    const sidebar = document.getElementById('sidebar');
                    const icon = document.getElementById('toggleIcon');

                    sidebar.classList.toggle('collapsed');

                    if (sidebar.classList.contains('collapsed')) {
                        icon.className = 'bi bi-chevron-right';
                    } else {
                        icon.className = 'bi bi-chevron-left';
                    }
                }

                // 채팅 이력 로드
                async function loadHistory() {
                    try {
                        const response = await fetch(contextPath + '/api/chat/history');
                        if (response.ok) {
                            const history = await response.json();
                            const chatContainer = document.querySelector('.chat-messages');

                            history.forEach(chat => {
                                // 사용자 질문
                                addMessageToUI('user', chat.question);
                                // 봇 답변
                                if (chat.answer) {
                                    addMessageToUI('bot', chat.answer);
                                }
                            });

                            // 스크롤 최하단으로 이동
                            chatContainer.scrollTop = chatContainer.scrollHeight;
                        }
                    } catch (error) {
                        console.error('이력 로드 실패:', error);
                    }
                }

                // 메시지 전송
                async function sendMessage() {
                    const input = document.getElementById('messageInput');
                    const message = input.value.trim();

                    if (!message) return; // 빈 메시지 방지

                    // 1. 내 메시지 UI 추가
                    addMessageToUI('user', message);
                    input.value = ''; // 입력창 초기화

                    // 2. 로딩 표시
                    const loadingId = addMessageToUI('loading');

                    try {
                        // 3. API 호출
                        const response = await fetch(contextPath + '/api/chat/ask', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify({ question: message })
                        });

                        // 4. 로딩 제거
                        removeMessageUI(loadingId);

                        if (response.ok) {
                            const result = await response.json();
                            // 5. 봇 답변 UI 추가
                            addMessageToUI('bot', result.answer);
                        } else {
                            addMessageToUI('bot', '죄송합니다. 오류가 발생했습니다.');
                        }
                    } catch (error) {
                        console.error('메시지 전송 실패:', error);
                        removeMessageUI(loadingId);
                        addMessageToUI('bot', '서버 통신 중 오류가 발생했습니다.');
                    }
                }

                // 메시지 UI 추가 함수
                function addMessageToUI(type, text) {
                    const chatContainer = document.querySelector('.chat-messages');
                    const uniqueId = 'msg-' + Date.now() + Math.random().toString(36).substr(2, 9);

                    console.log('[UI 추가 시도] 타입:', type, '텍스트:', text);

                    let html = '';

                    // CSS 클래스명 수정
                    if (type === 'user') {
                        html = '<div class="message user" id="' + uniqueId + '">' +
                            '<div class="message-bubble">' +
                            text.replace(/\n/g, '<br>') +
                            '</div>' +
                            '<div class="message-avatar">' +
                            '<img src="' + userIconPath + '" alt="User">' +
                            '</div>' +
                            '</div>';
                    } else if (type === 'bot') {
                        const content = text ? text.replace(/\n/g, '<br>') : '';
                        html = '<div class="message bot" id="' + uniqueId + '">' +
                            '<div class="message-avatar">' +
                            '<img src="' + botIconPath + '" alt="Bot">' +
                            '</div>' +
                            '<div class="message-bubble">' +
                            content +
                            '</div>' +
                            '</div>';
                    } else if (type === 'loading') { // 로딩 상태
                        html = '<div class="message bot" id="' + uniqueId + '">' +
                            '<div class="message-avatar">' +
                            '<img src="' + botIconPath + '" alt="Bot">' +
                            '</div>' +
                            '<div class="message-bubble loading">' +
                            '<div class="spinner-border spinner-border-sm text-secondary" role="status">' +
                            '<span class="visually-hidden">Loading...</span>' +
                            '</div>' +
                            '<span>답변 생성 중...</span>' +
                            '</div>' +
                            '</div>';
                    }

                    console.log('[생성된 HTML]', html);

                    chatContainer.insertAdjacentHTML('beforeend', html);
                    chatContainer.scrollTop = chatContainer.scrollHeight;

                    return uniqueId;
                }

                // 메시지 UI 제거 함수 (로딩 제거용)
                function removeMessageUI(id) {
                    const el = document.getElementById(id);
                    if (el) el.remove();
                }


                // 커스텀 알림 함수
                function showCustomAlert(message) {
                    const alertModalBody = document.getElementById('alertModalBody');
                    alertModalBody.innerText = message;
                    const alertModal = new bootstrap.Modal(document.getElementById('alertModal'));
                    alertModal.show();
                }

                // 초기화 - 모달 띄우기
                function clearChat() {
                    const clearModal = new bootstrap.Modal(document.getElementById('clearChatModal'));
                    clearModal.show();
                }

                // 실제 초기화 실행 (모달 내 버튼 클릭 시)
                document.getElementById('confirmClearChatBtn').addEventListener('click', async function () {
                    // 모달 닫기
                    const modalEl = document.getElementById('clearChatModal');
                    const modal = bootstrap.Modal.getInstance(modalEl);
                    modal.hide();

                    try {
                        // DB 삭제 요청
                        const response = await fetch(contextPath + '/api/chat/history', {
                            method: 'DELETE'
                        });

                        if (response.ok) {
                            // UI 초기화
                            document.getElementById('messageInput').value = '';
                            const chatContainer = document.querySelector('.chat-messages');
                            const messages = chatContainer.querySelectorAll('.message');
                            messages.forEach(msg => msg.remove());
                            console.log('대화 초기화 완료');

                            // 초기화 후 환영 메시지
                            setTimeout(function () {
                                addMessageToUI('bot', '안녕하세요\n무엇을 도와드릴까요?');
                            }, 1000);
                        } else {
                            showCustomAlert('초기화 중 오류가 발생했습니다.');
                        }
                    } catch (error) {
                        console.error('초기화 요청 실패:', error);
                        showCustomAlert('서버 통신 오류가 발생했습니다.');
                    }
                });

                // 로그아웃
                function logout() {
                    const logoutModal = new bootstrap.Modal(document.getElementById('logoutModal'));
                    logoutModal.show();
                }

                // 로그아웃 실행 (모달 내 버튼 클릭 시)
                document.getElementById('confirmLogoutBtn').addEventListener('click', function () {
                    location.href = '${pageContext.request.contextPath}/logout';
                });

                // 대시보드 이동
                function goToDashboard() {
                    location.href = '${pageContext.request.contextPath}/system/dashboard';
                }

                // Enter 키 처리 (Shift+Enter는 줄바꿈)
                document.getElementById('messageInput').addEventListener('keydown', function (e) {
                    if (e.key === 'Enter' && !e.shiftKey) {
                        e.preventDefault();
                        sendMessage();
                    }
                });
            </script>
        </body>

        </html>