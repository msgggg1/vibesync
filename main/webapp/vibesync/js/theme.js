// js/theme.js

/**
 * 화면에 테마를 적용하고, 선택된 옵션에 시각적 효과를 주는 함수
 * @param {string} theme - 'light' 또는 'dark'
 */
function applyTheme(theme) {
    // 1. <html> 태그의 속성을 변경하여 CSS 전체에 테마 적용
    document.documentElement.setAttribute('color-theme', theme);

    // 2. 현재 테마 옵션에 'selected' 클래스를 추가하여 UI에 표시
    $('.theme-option-label').removeClass('selected');
    $(`input[name="theme"][value="${theme}"]`).closest('.theme-option-label').addClass('selected');
}

// 문서가 준비되면 실행
$(function() {
    const currentTheme = document.documentElement.getAttribute('color-theme') || 'light';
    $(`input[name="theme"][value="${currentTheme}"]`).closest('.theme-option-label').addClass('selected');
    
    // 테마 변경 라디오 버튼에 이벤트 리스너 추가
    $('input[name="theme"]').on('change', function() {
        const selectedTheme = $(this).val();
        applyTheme(selectedTheme);
        
        $.ajax({
            url: `${contextPath}/setting.do`,
            type: 'POST',
            data: {
                theme: selectedTheme
            },
            success: function(response) {
                console.log('테마가 서버에 저장되었습니다.');
            },
            error: function() {
                console.error('테마 저장에 실패했습니다.');
            }
        });
    });
});