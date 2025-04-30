$(function() {

    const $loginFormContainer = $('#loginFormContainer');
    const $signupFormContainer = $('#signupFormContainer');
    const $switchToSignupLink = $('#switchToSignupLink');
    const $switchToLoginLink = $('#switchToLoginLink');
    const $switchFormLinkContainer = $('.switch-form-link'); 

    const $signupForm = $('#signupForm');
    const $passwordInput = $('#signupPw');
    const $confirmPasswordInput = $('#confirmPw');
    const $confirmPwError = $('#confirmPwError'); 


    // 회원가입 폼 보여주기
    function showSignupForm() {
        // .length를 확인하여 요소 존재 여부 체크
        if ($loginFormContainer.length && $signupFormContainer.length && $switchFormLinkContainer.length) {
            $loginFormContainer.hide(); // 로그인 폼 숨기기
            $signupFormContainer.css('display', 'flex'); // 회원가입 폼 보이기 
            $switchFormLinkContainer.hide(); // '아직 회원이 아니신가요?' 링크 숨기기
        }
    }

    // 로그인 폼 보여주기
    function showLoginForm() {
        if ($loginFormContainer.length && $signupFormContainer.length && $switchFormLinkContainer.length) {
            $loginFormContainer.css('display', 'flex'); // 로그인 폼 보이기 
            $signupFormContainer.hide(); // 회원가입 폼 숨기기
            $switchFormLinkContainer.show(); // '아직 회원이 아니신가요?' 링크 보이기 (기본 display block)
        }
    }

    // '회원가입' 링크 클릭 이벤트 (.on() 사용)
    if ($switchToSignupLink.length) {
        $switchToSignupLink.on('click', function(event) {
            event.preventDefault(); // 링크 기본 동작 중단
            showSignupForm();
        });
    }

    // '로그인' 링크(회원가입 폼 내부) 클릭 이벤트
    if ($switchToLoginLink.length) {
        $switchToLoginLink.on('click', function(event) {
            event.preventDefault();
            showLoginForm();
        });
    }

    // --- 비밀번호 확인 기능 ---

    // 비밀번호 일치 여부 확인 함수
    function validatePasswords() {
        const passwordVal = $passwordInput.val(); // .val()로 값 가져오기
        const confirmPasswordVal = $confirmPasswordInput.val();

        if (passwordVal !== confirmPasswordVal) {
            // 불일치 시
            $confirmPwError.text('Passwords do not match.').show(); 
            $confirmPasswordInput.css('border-bottom-color', 'red'); // .css()로 스타일 변경
            return false;
        } else {
            // 일치 시
            $confirmPwError.text('').hide(); // 내용 비우고 숨기기
            $confirmPasswordInput.css('border-bottom-color', ''); // 인라인 스타일 제거하여 CSS 기본값으로 복원
            return true;
        }
    }


    // 회원가입 폼 제출 시 최종 검증 (.on('submit', ...) 사용)
    if ($signupForm.length) {
        $signupForm.on('submit', function(event) {
            if (!validatePasswords()) {
                console.log('비밀번호 불일치로 제출 중단 (jQuery)');
                event.preventDefault(); // 폼 제출 중단
                $confirmPasswordInput.focus(); // .trigger('focus') 또는 .focus()로 포커스 주기
            }
        });
    }

    // (선택 사항) 비밀번호 확인 필드 입력 시 실시간 검증
    if ($confirmPasswordInput.length) {
        $confirmPasswordInput.on('input', validatePasswords);
    }

    // (선택 사항) 비밀번호 필드 입력 시 확인 필드 검증
    if ($passwordInput.length) {
         $passwordInput.on('input', function() {
             // 확인 필드에 값이 있을 때만 비교 실행
             if ($confirmPasswordInput.val()) {
                 validatePasswords();
             }
         });
    }

});

