<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BNSY 봇 - 로그인</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
            rel="stylesheet">
        <style>
            * {
                font-family: 'Noto Sans KR', sans-serif;
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background-color: #ffffff;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 30px 15px;
            }

            /* 메인 컨테이너 카드 */
            .main-card {
                background: #ffffff;
                border-radius: 20px;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
                padding: 50px 60px;
                max-width: 480px;
                width: 100%;
            }

            /* 로고 */
            .logo-container {
                text-align: center;
                margin-bottom: 40px;
            }

            .logo-container img {
                max-width: 280px;
                width: 100%;
                height: auto;
            }

            /* 로그인 섹션 */
            .login-section {
                margin-bottom: 35px;
            }

            .form-control {
                border: 1px solid #d0d0d0;
                border-radius: 8px;
                padding: 14px 18px;
                font-size: 15px;
                margin-bottom: 12px;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                border-color: #dc3545;
                box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.15);
                outline: none;
            }

            .form-control::placeholder {
                color: #999;
            }

            /* 로그인 버튼 */
            .btn-login {
                width: 100%;
                padding: 14px;
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                border: none;
                border-radius: 8px;
                color: white;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 8px;
            }

            .btn-login:hover {
                background: linear-gradient(135deg, #c82333 0%, #b01f2e 100%);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(220, 53, 69, 0.3);
            }

            /* 회원가입 섹션 */
            .register-section {
                background: #ffffff;
                border: 2px solid #e0e0e0;
                border-radius: 16px;
                padding: 30px 35px;
                margin-top: 30px;
            }

            .register-title {
                text-align: center;
                font-size: 18px;
                font-weight: 600;
                color: #333;
                margin-bottom: 25px;
            }

            /* 생성 버튼 */
            .btn-register {
                width: 100%;
                padding: 12px;
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                border: none;
                border-radius: 8px;
                color: white;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 8px;
            }

            .btn-register:hover {
                background: linear-gradient(135deg, #c82333 0%, #b01f2e 100%);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(220, 53, 69, 0.3);
            }

            /* 반응형 */
            @media (max-width: 576px) {
                .main-card {
                    padding: 40px 30px;
                }

                .register-section {
                    padding: 25px 25px;
                }

                .logo-container img {
                    max-width: 240px;
                }
            }
        </style>
    </head>

    <body>
        <div class="main-card">
            <!-- 로고 -->
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/resources/images/BNSY_BOT.png" alt="BNSY 봇">
            </div>

            <!-- 로그인 섹션 -->
            <div class="login-section">
                <form action="/login" method="post">
                    <input type="text" class="form-control" name="memberId" placeholder="아이디" required>
                    <input type="password" class="form-control" name="memberPw" placeholder="비밀번호" required>
                    <button type="submit" class="btn-login">로그인</button>
                </form>
            </div>

            <!-- 회원가입 섹션 -->
            <div class="register-section">
                <h3 class="register-title">회원가입</h3>
                <form action="/register" method="post">
                    <input type="text" class="form-control" name="memberId" placeholder="아이디" required>
                    <input type="password" class="form-control" name="memberPw" placeholder="비밀번호" required>
                    <input type="text" class="form-control" name="memberName" placeholder="가입 목적" required>
                    <button type="submit" class="btn-register">생성</button>
                </form>
            </div>
        </div>

        <!-- Toast 메시지 컨테이너 (우측 상단) -->
        <div class="position-fixed top-0 end-0 p-3" style="z-index: 11">
            <div id="liveToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                    <strong class="me-auto">BNSY 봇</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" id="toastMessage">
                    메시지
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Toast 메시지 처리 스크립트 -->
        <script>
            // 서버에서 전달된 FlashAttribute 메시지 확인
            const message = "${message}";
            const messageType = "${messageType}";

            if (message && message !== "") {
                const toastEl = document.getElementById('liveToast');
                const toastBody = document.getElementById('toastMessage');
                const toastHeader = toastEl.querySelector('.toast-header');

                // 메시지 설정
                toastBody.textContent = message;

                // 메시지 타입에 따라 배경색 변경
                if (messageType === "success") {
                    toastHeader.style.backgroundColor = "#d4edda";
                    toastHeader.style.color = "#155724";
                    toastBody.style.backgroundColor = "#d4edda";
                    toastBody.style.color = "#155724";
                } else if (messageType === "error") {
                    toastHeader.style.backgroundColor = "#f8d7da";
                    toastHeader.style.color = "#721c24";
                    toastBody.style.backgroundColor = "#f8d7da";
                    toastBody.style.color = "#721c24";
                }

                // Toast 표시
                const toast = new bootstrap.Toast(toastEl, {
                    animation: true,
                    autohide: true,
                    delay: 3000
                });
                toast.show();
            }
        </script>
    </body>

    </html>