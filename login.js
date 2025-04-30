// HTML 문서 로드가 완료되면 실행
document.addEventListener('DOMContentLoaded', () => {
    // 필요한 요소들을 ID로 가져오기
    const loginFormContainer = document.getElementById('loginFormContainer'); // 로그인 폼 감싸는 div
    const signupFormContainer = document.getElementById('signupFormContainer'); // 회원가입 폼 감싸는 div
    const switchToSignupLink = document.getElementById('switchToSignupLink'); // '회원가입' 링크
    const switchToLoginLink = document.getElementById('switchToLoginLink'); // '로그인' 링크 (회원가입 폼 안에 있음)
    const switchFormLinkContainer = document.querySelector('.switch-form-link'); // '아직 회원이 아니신가요?' 링크 감싸는 div

    // 회원가입 폼을 보여주고 로그인 폼을 숨기는 함수
    function showSignupForm() {
        if (loginFormContainer && signupFormContainer && switchFormLinkContainer) {
            loginFormContainer.style.display = 'none'; // 로그인 폼 숨기기
            signupFormContainer.style.display = 'flex'; // 회원가입 폼 보여주기 (flex로 설정했으므로 flex)
            switchFormLinkContainer.style.display = 'none'; // '아직 회원이 아니신가요?' 링크 숨기기
        }
    }

    // 로그인 폼을 보여주고 회원가입 폼을 숨기는 함수
    function showLoginForm() {
        if (loginFormContainer && signupFormContainer && switchFormLinkContainer) {
            loginFormContainer.style.display = 'flex'; // 로그인 폼 보여주기 (flex로 설정했으므로 flex)
            signupFormContainer.style.display = 'none'; // 회원가입 폼 숨기기
            switchFormLinkContainer.style.display = 'block'; // '아직 회원이 아니신가요?' 링크 다시 보여주기
        }
    }

    // '회원가입' 링크 클릭 이벤트 처리
    if (switchToSignupLink) {
        switchToSignupLink.addEventListener('click', (event) => {
            event.preventDefault(); // 링크 기본 동작(페이지 이동) 막기
            showSignupForm(); // 회원가입 폼 보여주는 함수 호출
        });
    }

    // '로그인' 링크(회원가입 폼 내부) 클릭 이벤트 처리
    if (switchToLoginLink) {
        switchToLoginLink.addEventListener('click', (event) => {
            event.preventDefault(); // 링크 기본 동작 막기
            showLoginForm(); // 로그인 폼 보여주는 함수 호출
        });
    }
});