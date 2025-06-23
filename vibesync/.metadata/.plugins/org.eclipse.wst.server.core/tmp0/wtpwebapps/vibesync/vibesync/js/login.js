$(function() {

    const $loginFormContainer = $('#loginFormContainer');
    const $signupFormContainer = $('#signupFormContainer');
    const $resetPasswordContainer = $('#resetPasswordContainer'); 
    const $switchToSignupLink = $('#switchToSignupLink');
    const $switchToLoginLink = $('#switchToLoginLink');
    const $switchToResetLink = $('a:contains("Reset Password")'); 
    const $switchToLoginFromResetLink = $('#switchToLoginFromReset'); 
    const $switchFormLinkContainer = $('.switch-form-link'); 

    const $signupForm = $('#signupForm');
    const $passwordInput = $('#signupPw');
    const $confirmPasswordInput = $('#confirmPw');
    const $confirmPwError = $('#confirmPwError'); 


    function showForm($formToShow) {
        // 모든 폼을 일단 숨김
        $loginFormContainer.hide();
        $signupFormContainer.hide();
        $resetPasswordContainer.hide();

        // 요청된 폼만 flex로 보여줌
        if ($formToShow && $formToShow.length) {
            $formToShow.css('display', 'flex');
        }

        // '아직 회원이 아니신가요?' 링크는 로그인 폼일 때만 보여줌
        if ($formToShow && $formToShow.is($loginFormContainer)) {
            $switchFormLinkContainer.show();
        } else {
            $switchFormLinkContainer.hide();
        }
    }

    // '회원가입' 링크 클릭 이벤트
    $switchToSignupLink.on('click', function(e) {
        e.preventDefault();
        showForm($signupFormContainer);
    });

    // '로그인' 링크(회원가입 폼 내부) 클릭 이벤트
    $switchToLoginLink.on('click', function(e) {
        e.preventDefault();
        showForm($loginFormContainer);
    });
    
    // '비밀번호 재설정' 링크 클릭 이벤트 (새로 추가)
    $switchToResetLink.on('click', function(e) {
        e.preventDefault();
        // login.jsp에 resetPasswordContainer가 있는지 확인
        if ($resetPasswordContainer.length) {
            showForm($resetPasswordContainer);
        } else {
            console.error("'resetPasswordContainer' 요소를 찾을 수 없습니다. login.jsp에 추가해주세요.");
        }
    });

    // 재설정 폼에서 '로그인으로 돌아가기' 링크 클릭 이벤트 (새로 추가)
    $switchToLoginFromResetLink.on('click', function(e) {
        e.preventDefault();
        showForm($loginFormContainer);
    });


    // --- 3. 비밀번호 확인 기능 (회원가입 폼) ---

    // 비밀번호 일치 여부 확인 함수
    function validatePasswords() {
        const passwordVal = $passwordInput.val();
        const confirmPasswordVal = $confirmPasswordInput.val();

        if (passwordVal !== confirmPasswordVal) {
            $confirmPwError.text('Passwords do not match.').show();
            $confirmPasswordInput.css('border-bottom-color', 'red');
            return false;
        } else {
            $confirmPwError.text('').hide();
            $confirmPasswordInput.css('border-bottom-color', '');
            return true;
        }
    }

    // 회원가입 폼 제출 시 최종 검증
    $signupForm.on('submit', function(e) {
        if (!validatePasswords()) {
            console.log('비밀번호 불일치로 제출 중단');
            e.preventDefault();
            $confirmPasswordInput.focus();
        }
    });

    // 비밀번호 확인 필드 실시간 검증
    $confirmPasswordInput.on('input', validatePasswords);
    
    // 비밀번호 필드 입력 시 확인 필드에 값이 있으면 검증
    $passwordInput.on('input', function() {
        if ($confirmPasswordInput.val()) {
            validatePasswords();
        }
    });
});


    const starCanvas = document.getElementById('starfield');
    const starCtx    = starCanvas.getContext('2d');
    let stars = [];

    function initStars() {
      starCanvas.width  = window.innerWidth;
      starCanvas.height = window.innerHeight;
      stars = [];
      for (let i = 0; i < 200; i++) {
        stars.push({
          x: Math.random() * starCanvas.width,
          y: Math.random() * starCanvas.height,
          r: Math.random() * 1.2 + 0.3
        });
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
    // 초기화 및 주기적 트윙클
    initStars();
    drawStars();
    window.addEventListener('resize', () => { initStars(); drawStars(); });
    setInterval(drawStars, 800);

    // 별똥별 생성
    function createShootingStar() {
      const star = document.createElement('div');
      star.classList.add('shooting-star');
      // 상단 랜덤 x 위치에서 시작
      star.style.top  = '0px';
      star.style.left = Math.random() * (window.innerWidth -100) + 'px'; // 여유 100px
      // 회전각각
      star.style.transform = 'rotate(45deg)';
      document.body.appendChild(star);
      // 애니메이션 끝나면 제거
      star.addEventListener('animationend', () => star.remove());
    }
    // 3초마다 별똥별 생성
    setInterval(createShootingStar, 3000);

    // 커서 따라 파티클
    const particles = [];
    const mouse = { x: 0, y: 0 };
    const particleCanvas = document.createElement('canvas');
    particleCanvas.id = 'particle-canvas';
    particleCanvas.style.position = 'fixed';
    particleCanvas.style.top = '0'; particleCanvas.style.left = '0';
    particleCanvas.style.width = '100vw'; particleCanvas.style.height = '100vh';
    particleCanvas.style.pointerEvents = 'none';
    document.body.appendChild(particleCanvas);
    const ctx = particleCanvas.getContext('2d');
    particleCanvas.width = window.innerWidth;
    particleCanvas.height = window.innerHeight;

    window.addEventListener('resize', () => {
      particleCanvas.width = window.innerWidth;
      particleCanvas.height = window.innerHeight;
    });

    // 파티클 객체
    class Particle {
      constructor(x, y) {
        this.x = x; this.y = y;
        this.vx = (Math.random() - 0.5) * 2;
        this.vy = (Math.random() - 0.5) * 2;
        this.alpha = 1;
        this.size = Math.random() * 3 + 1;
      }
      update() {
        this.x += this.vx; this.y += this.vy;
        this.alpha -= 0.02;
      }
      draw() {
        ctx.globalAlpha = this.alpha;
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fillStyle = '#fff';
        ctx.fill();
      }
    }

    // 마우스 이동 시 파티클 추가
    window.addEventListener('mousemove', e => {
      for (let i = 0; i < 3; i++) {
        particles.push(new Particle(e.clientX, e.clientY));
      }
    });

    // 애니메이션 루프
    function animate() {
      ctx.clearRect(0, 0, particleCanvas.width, particleCanvas.height);
      for (let i = particles.length - 1; i >= 0; i--) {
        const p = particles[i];
        p.update();
        if (p.alpha <= 0) particles.splice(i, 1);
        else p.draw();
      }
      requestAnimationFrame(animate);
    }
    animate();
