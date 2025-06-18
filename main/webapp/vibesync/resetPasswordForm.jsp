<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Set a New Password</title>
    <link rel="stylesheet" href="./css/login.css"> <%-- 기존 login.css를 재활용합니다. --%>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        /* 'password-reset-page' 클래스를 가진 body 안의 #login::before 요소만 선택 */
        .password-reset-page #login::before {
            display: none !important;
        }
    </style>
</head>
<body ondragstart="return false" ondrop="return false" onselectstart="return false" class="password-reset-page">
    <canvas id="starfield"></canvas>
    <div class="container" style="justify-content: center; align-items: center;">
        
        <div id="login" style="max-width: 500px; padding: 40px; border-radius: 8px;">
            <div class="login-wrapper" style="height: auto; justify-content: center; gap: 40px;">

                <div id="findYourVibeSync">
                    Set a New<br><span class="highlight">Password</span>
                </div>
                
                <form action="<%=request.getContextPath()%>/vibesync/user.do" method="post" id="resetPasswordForm">
                    <input type="hidden" name="accessType" value="performPasswordReset">
                    
                    <%-- URL 파라미터로 전달된 토큰을 hidden 필드에 담아 다시 서버로 전송합니다. --%>
                    <input type="hidden" name="token" value="${param.token}">

                    <input type="password" id="newPassword" name="newPassword" placeholder="New Password" required
                           pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$"
                           title="8자 이상, 영문자, 숫자, 특수문자를 모두 포함해야 합니다.">
                           
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm New Password" required>
                    
                    <%-- 비밀번호 불일치 에러 메시지를 표시할 공간 --%>
                    <p id="confirmPwError" class="error-message" style="display: none; color: red; font-size: 0.8em; text-align: left; width: 100%; margin: -20px 0;"></p>

                    <button type="submit">Update Password</button>
                </form>

            </div>
        </div>
    </div>

    <script>
        // 배경 애니메이션을 위한 간단한 스크립트 (기존 login.js에서 가져옴)
        const starCanvas = document.getElementById('starfield');
        if (starCanvas) {
            const starCtx = starCanvas.getContext('2d');
            let stars = [];
            function initStars() {
                starCanvas.width = window.innerWidth;
                starCanvas.height = window.innerHeight;
                stars = [];
                for (let i = 0; i < 200; i++) {
                    stars.push({ x: Math.random() * starCanvas.width, y: Math.random() * starCanvas.height, r: Math.random() * 1.2 + 0.3 });
                }
            }
            function drawStars() {
                starCtx.clearRect(0, 0, starCanvas.width, starCanvas.height);
                stars.forEach(s => {
                    starCtx.globalAlpha = Math.random() * 0.6 + 0.4;
                    starCtx.beginPath();
                    starCtx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
                    starCtx.fillStyle = 'white';
                    starCtx.fill();
                });
            }
            initStars();
            drawStars();
            window.addEventListener('resize', () => { initStars(); drawStars(); });
            setInterval(drawStars, 800);
        }

        // 비밀번호 일치 확인을 위한 jQuery 스크립트
        $(function() {
            const $form = $('#resetPasswordForm');
            const $password = $('#newPassword');
            const $confirm = $('#confirmPassword');
            const $errorMsg = $('#confirmPwError');

            function validate() {
                if ($password.val() !== $confirm.val()) {
                    $errorMsg.text('Passwords do not match.').show();
                    return false;
                } else {
                    $errorMsg.hide();
                    return true;
                }
            }

            // 실시간 검증
            $confirm.on('input', validate);
            $password.on('input', function() {
                if ($confirm.val()) {
                    validate();
                }
            });

            // 폼 제출 시 최종 검증
            $form.on('submit', function(e) {
                if (!validate()) {
                    e.preventDefault(); // 폼 제출 중단
                    $confirm.focus();
                }
            });
        });
    </script>
</body>
</html>