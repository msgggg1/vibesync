// 전역 변수 선언
var calendar;
var schedulesByDate = {};
var selectedDateCell = null;
var todosById = {};
let dateToRefreshAfterFetch = null;
let isInitialLoad = true;

//  함수 
// 최근 색상 관리를 위한 함수
// [함수] localStorage에서 최근 색상 배열 가져오기
const getRecentColors = () => {
	const colorsJSON = localStorage.getItem('recentColors');
	return colorsJSON ? JSON.parse(colorsJSON) : [] ; // localStorage는 데이터를 오직 '문자열(String)' 형태로만 저장
};

// localStorage에 최근 색상 저장하기(최대 5개)
const saveRecentColor = (color) => {
	if(!color) return;
	let colors = getRecentColors();
	// 이미 존재하는 색상은 배열에서 제거 (최신 순으로 이동시키기 위함)
	colors = colors.filter(c => c !== color);
	// 새로운 색상을 배열의 맨 앞에 추가
	colors.unshift(color); // '맨 앞'에 새로운 요소를 추가하는 함수
	// 최근 5개의 색상만 유지
	const updatedColors = colors.slice(0,5);
	localStorage.setItem('recentColors', JSON.stringify(updatedColors));
}

// 모달에 최근 색상 동그라미 UI를 표시하는 함수
const displayRecentColors = (containerSelector, inputSelector) => {
	const colors = getRecentColors();
	const $container = $(containerSelector);
	const $colorInput = $(inputSelector);
	$container.empty();
	
	colors.forEach(color => {
		const $circle = $('<div>', {
			class: 'recent-color-circle',
			'data-color':color
		}).css('background-color', color);
		
		// 현재 색상 input값과 같으면 'selected' 클래스 추가
		if($colorInput.val() === color){
			$circle.addClass('selected');
		}
		$container.append($circle);
	});
	
}

// [함수] 일별 일정 로딩 (우측 패널)
function loadDailySchedules(dateString) {
	
	// 1. 전달받은 dateString으로 Date 객체 생성
    const date = new Date(dateString);

    // 2. 요일을 한글로 변환하기 위한 배열
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];

    // 3. 'YYYY년 MM월 DD일 (요일)' 형식으로 날짜 포맷팅
    const formattedDate = `${date.getFullYear()}년 ${date.getMonth() + 1}월 ${date.getDate()}일 (${weekdays[date.getDay()]})`;

    // 4. JSP에 추가한 h4 태그에 포맷된 날짜 텍스트를 삽입
    $('#tab_schedule .schedule-date-title').text(formattedDate);
	
    var schedules = schedulesByDate[dateString];
    var scheduleHtml = '<ul class="schedule-list">';
    if (schedules && schedules.length > 0) {
        $.each(schedules, function(index, schedule) {
            var startDate = new Date(schedule.start);
            var endDate = new Date(schedule.end);
            var startTime = String(startDate.getHours()).padStart(2, '0') + ":" + String(startDate.getMinutes()).padStart(2, '0');
            var endTime = String(endDate.getHours()).padStart(2, '0') + ":" + String(endDate.getMinutes()).padStart(2, '0');
            var descriptionHtml = (schedule.description && schedule.description.trim() !== '') ? ' <span class="schedule-desc">' + schedule.description + '</span>' : '';
            
            scheduleHtml += `<li data-id="${schedule.id}">
                               <div class="schedule-item-content">
                                   <span class="schedule-time">${startTime} - ${endTime}</span>
                                   <div class="schedule-details">
                                       <span class="schedule-title">${schedule.title}</span>
                                       ${descriptionHtml}
                                   </div>
                               </div>
                               <button class="schedule-delete-btn">&times;</button>
                           </li>`;
        });
    } else {
        scheduleHtml += '<li class="no-schedule">등록된 일정이 없습니다.</li>';
    }
    scheduleHtml += '</ul>';
    $('#tab_schedule .schedule-date-title').html('<i class="fa-regular fa-calendar-check"></i>' + formattedDate);
    $('#daily-schedule-list-container').html(scheduleHtml);
}

// [함수] 할 일 목록 로딩
function loadTodoList() { 
    $.ajax({
        url: contextPath + '/todoList.do', 
        type: 'GET',
        dataType: 'json',
        success: function(todos) {
            var todoListHtml = '<ul class="todo-list">';
            todosById = {};
            if (todos && todos.length > 0) {
                $.each(todos, function(index, todo) {
                    let isChecked = todo.status === 1 ? "checked" : "";
                    let textClass = todo.status === 1 ? "completed" : "";
                    // 1. 색상 코드를 RGB 객체로 변환
				    let rgb = hexToRgb(todo.color);
				
				    // 2. li 태그에 CSS 변수로 RGB 값을 전달하고, 체크박스 구조 변경
				    todoListHtml += `<li data-id="${todo.todo_idx}" style="--todo-r: ${rgb.r}; --todo-g: ${rgb.g}; --todo-b: ${rgb.b};">
				                        <label class="custom-checkbox-label">
				                            <input type="checkbox" class="todo-checkbox" ${isChecked}>
				                            <span class="custom-checkbox-span"></span>
				                        </label>
				                        <span class="todo-text \${textClass}">${todo.text}</span>
				                        <button class="todo-delete-btn">&times;</button>
				                    </li>`;
				    todosById[todo.todo_idx] = todo;
                });
            } else {
                todoListHtml += '<li style="justify-content:center; color:#888;">등록된 할 일이 없습니다.</li>';
            }
            todoListHtml += '</ul>';
            $('#tab_todo').html(todoListHtml);
        },
        error: function(xhr, status, error) {
            console.error("[TodoList-AJAX-ERR]", error);
            $('#tab_todo').html('<p>할 일 목록을 불러오는 데 실패했습니다.</p>');
        }
    });
}

// [함수] 오늘 날짜 문자열 반환
function getTodayString() {
    var today = new Date();
    var year = today.getFullYear();
    var mm = String(today.getMonth() + 1).padStart(2, '0');
    var dd = String(today.getDate()).padStart(2, '0');
    return year + '-' + mm + '-' + dd;
}
    
// 하나의 범용 위젯 로딩 함수
/* 추후 필요시 사용
function loadPostsWidget(options) {
    const $widget = $(options.selector);
    $widget.html('<p>로딩 중...</p>');

    $.ajax({
        url: contextPath + '/note.do',
        type: 'GET',
        data: { action: options.action },
        dataType: 'json',
        success: function(posts) {
            // 헤더 HTML 생성
            let contentHtml = `<div class="widget-header">
                                   <h4><i class="${options.iconClass}"></i>&nbsp;&nbsp;${options.title}</h4>
                                   <button class="more-btn" data-type="${options.type}">더보기</button>
                               </div>`;
            contentHtml += '<ul>';

            if (posts && posts.length > 0) {
                posts.forEach(function(post) {
                    // 리스트 아이템 HTML 생성 (options.metaGenerator 함수 사용)
                    contentHtml += `<li>
                                        <a href="postView.do?nidx=${post.note_idx}" title="${post.title}">
                                            <span>${post.title}</span>
                                            ${options.metaGenerator(post)}
                                        </a>
                                    </li>`;
                });
            } else {
                contentHtml += `<li class="no-items">${options.noItemText}</li>`;
            }
            contentHtml += '</ul>';
            $widget.html(contentHtml);
        },
        error: function() { $widget.html('<p>글을 불러오는 데 실패했습니다.</p>'); }
    });
}
*/

// [함수] 날짜 선택 팝오버 채우기
function populateDatePicker() {
    const $yearSelect = $('#year-select');
    const $monthSelect = $('#month-select');
    if ($yearSelect.children().length > 0) return; // 처음 한 번만 시행
    const currentYear = new Date().getFullYear();
    for (let i = currentYear - 10; i <= currentYear + 10; i++) {
        $yearSelect.append(`<option value="${i}">${i}년</option>`);
    }
    for (let i = 1; i <= 12; i++) {
        $monthSelect.append(`<option value="${i}">${i}월</option>`);
    }
}

// [함수] 16진수 색상을 RGB 객체로 변환하는 헬퍼 함수 
function hexToRgb(hex) {
    if (!hex || hex.length < 4) { // 가장 짧은 16진수 값 4글자
        hex = '#3788d8'; // 기본값
    }
    let result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : { r: 55, g: 136, b: 216 }; // 기본값의 RGB
}

//  페이지 로드 완료 후 실행되는 메인 로직
$(document).ready(function() {
    // --- 변수 선언 ---
    const $unifiedModal = $('#unified-modal');
    const $modalTitle = $('#modal-title');
    const $scheduleForm = $('#schedule-form');
    const $todoForm = $('#todo-form');
    const $datePickerPopover = $('#date-picker-popover');
    const $yearSelect = $('#year-select');
    const $monthSelect = $('#month-select');
    
    // 함수
    const toLocalISOString = (date)=>{
		const y = date.getFullYear(),
			  m = String(date.getMonth()+1).padStart(2, '0'),
			  d = String(date.getDate()).padStart(2,'0'),
			  h = String(date.getHours()).padStart(2, '0'),
			  min = String(date.getMinutes()).padStart(2,'0');
		return y + "-" + m + "-" + d + "T" + h + ":" + min;
	}
    
    // [함수] 스케줄생성 모달 열기 
	 const openNewScheduleModal = (options) => {
		// option객체가 전달되지 않은 경우 빈 객체로 초기화
		options = options || {};
		
		// 1. 모달 제목 설정 및 폼 초기화
		$modalTitle.text('새로운 일정 추가');
		$scheduleForm[0].reset();
		$('#schedule-id').val('');
		
		// 2. 시작/종료 날짜 결정
		// option값이 있으면 그 날짜, 아니면 오늘 날짜
		let startDate = options.start ? new Date(options.start) : new Date();
		//															없으면 시작 날짜
		let endDate = options.end ? new Date(options.end) : new Date(startDate);
		
		// 3. 시간에 대한 기본값 설정
		startDate.setHours(9,0,0,0);
		
		if(options.end){
			// select로 받은 end는 마지막 날+1일이므로 하루 빼기
			endDate.setDate(endDate.getDate() -1);
			endDate.setHours(18,0,0,0)
		}else{
			// 단일 날짜 선택(또는 오늘 날짜) 시 기본 1시간짜리 일정
			endDate.setHours(10,0,0,0);
		}
		
		// 4. 폼에 값 채우기
		$('#schedule-start').val(toLocalISOString(startDate));
		$('#schedule-end').val(toLocalISOString(endDate));
		
		displayRecentColors('#schedule-recent-colors', '#schedule-color');

		// 5. 모달 띄우기
		$todoForm.hide();
    	$scheduleForm.show();
    	$unifiedModal.show();
	}
	
	// [함수]날짜 칸 선택
	const handleDateSelection = (dayCell) => {
		if(!dayCell || !dayCell.getAttribute('data-date')){
			console.error("선택된 날짜 칸(dayCell) 또는 날짜 정보가 없습니다.");
			return;
		}
		
		const dateStr = dayCell.getAttribute('data-date');
	                  
        if(selectedDateCell){
			selectedDateCell.classList.remove('fc-day-selected');
			}
		
		dayCell.classList.add('fc-day-selected');
		selectedDateCell = dayCell;
					
		loadDailySchedules(dateStr);
					
		$('.tab-btn[data-tab="tab_schedule"]').click();	
	};
	
    // --- 이벤트 핸들러 설정 ---

    // 1. 탭 전환
    $('.tab-btn').on('click', function() {
        $('.tab-btn, .tab-content').removeClass('active');
        $(this).addClass('active');
        const tabId = $(this).data('tab');
        $('#' + tabId).addClass('active');
        
        if (tabId === 'tab_schedule') {
            $('#add-schedule-btn').show();
            $('#add-todo-btn').hide();
        } else if (tabId === 'tab_todo') {
            $('#add-schedule-btn').hide();
            $('#add-todo-btn').show();
        }
    });

    // 2. 할 일(Todo) 관련
    // #tab_todo 영역 안에서 클릭 발생 -> .todo-checkbox라는 클래스를 가진 요소에서 일어난 것인지 확인 -> 맞다면, 뒤 함수 실행
    $('#tab_todo').on('click', '.todo-checkbox', function() { 
            var $li = $(this).closest('li');
            var todoIdx = $li.data('id');
            var isChecked = $(this).is(':checked'); // 체크박스가 체크된 상태인지를 확인하는 선택자

			//두번재 인자 값이 true일 때 'completed' 클래스를 추가하고, false일 때 제거
            $li.find('.todo-text').toggleClass('completed', isChecked);
            
            $.ajax({
                url: contextPath + '/todoList.do',
                type: 'POST',
                data: {
                    action: 'updateStatus',
                    todoIdx: todoIdx,
                    status: isChecked ? 1 : 0
                },
                success: function(response) {
                    console.log("Todo [ID:" + todoIdx + "] 상태 변경 완료:", response);
                },
                error: function() {
                    alert("상태 변경에 실패했습니다. 다시 시도해 주세요.");
                    $(this).prop('checked', !isChecked);
                    $li.find('.todo-text').toggleClass('completed', !isChecked);
                }
            });
        });
        
    $('#tab_todo').on('click', '.todo-delete-btn', function() {
    	var $li = $(this).closest('li');
        var todoIdx = $li.data('id');

            if (confirm("정말로 이 할 일을 삭제하시겠습니까?")) {
                $.ajax({
                    url: contextPath + '/todoList.do',
                    type: 'POST',
                    data: {
                        action: 'delete',
                        todoIdx: todoIdx
                    },
                    success: function(response) {
                        console.log("Todo [ID:" + todoIdx + "] 삭제 완료:", response);
                        $li.fadeOut(300, function() { $(this).remove(); }); // 애니메이션 끝나고 실행
                    },
                    error: function() {
                        alert("삭제에 실패했습니다. 다시 시도해 주세요.");
                    }
                });
            }
    });
    
    $('#tab_todo').on('click', '.todo-list li .todo-text', function() {
			const $li = $(this).closest('li');
            const todoId = $li.data('id');
            const clickedTodo = todosById[todoId];

            if(!clickedTodo) {
                console.error("캐시에서 할 일 정보를 찾지 못했습니다. ID:", todoId);
                alert("할 일 정보를 수정할 수 없습니다.");
                return;
            }

            $modalTitle.text('할 일 수정');
            $todoForm[0].reset(); // $todoForm: jquery객체 -> reset() 없음, $todoForm[0](jquery에서 꺼내기): 순수 DOM 요소 -> reset 가능 
            $scheduleForm.hide(); // 스케줄 수정 숨기기
            
            $('#todo-id').val(clickedTodo.todo_idx);
            $('#todo-text').val(clickedTodo.text);
            $('#todo-group').val(clickedTodo.todo_group || '');
            $('#todo-color').val(clickedTodo.color || '#3788d8');
            
            displayRecentColors('#todo-recent-colors', '#todo-color');

            $todoForm.show();	  // 할 일 수정 띄우기
            $unifiedModal.show(); // 모달 창 띄우기
            
            
             }); // 수정 모달 열기

    // 3. 일정(Schedule) 관련
    $('#tab_schedule').on('click', '.schedule-item-content', function() { 
    	const scheduleId = $(this).closest('li').data('id');
            let clickedSchedule = null;
            for (const date in schedulesByDate) {
                const found = schedulesByDate[date].find(event => event.id == scheduleId);
                if (found) {
                    clickedSchedule = found;
                    break;
                }
            }
            if (!clickedSchedule) { alert("일정 정보를 찾을 수 없습니다."); return; }

            $modalTitle.text('일정 수정');
            $scheduleForm[0].reset();
            $todoForm.hide();

            $('#schedule-id').val(clickedSchedule.id);
            $('#schedule-title').val(clickedSchedule.title);
            $('#schedule-description').val(clickedSchedule.description);
            
            $('#schedule-start').val(toLocalISOString(new Date(clickedSchedule.start)));
            $('#schedule-end').val(toLocalISOString(new Date(clickedSchedule.end)));
            $('#schedule-color').val(clickedSchedule.color);
            
            displayRecentColors('#schedule-recent-colors', '#schedule-color');

            $scheduleForm.show();
            $unifiedModal.show();
            
            });
            
     
    $('#tab_schedule').on('click', '.schedule-delete-btn', function(e) { 
    	e.stopPropagation(); // 부모(li)의 수정 이벤트 방지
            const $li = $(this).closest('li');
            const scheduleId = $li.data('id');
            let scheduleDate = null;
            for (const date in schedulesByDate) {
                const found = schedulesByDate[date].find(event => event.id == scheduleId);
                if (found) {
                    const d = new Date(found.start);
                    scheduleDate = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
                    // 삭제가 성공한 뒤, 어떤 날짜의 일일 목록을 새로고침해야 하는지 알려주기 위해 
                    break;
                }
            }
            if (!scheduleDate) {
                alert('오류: 해당 일정의 날짜 정보를 찾을 수 없습니다.');
                return;
            }
            if (confirm("정말로 이 일정을 삭제하시겠습니까?")) {
                $.ajax({
                    url: contextPath + '/schedules.do',
                    type: 'POST',
                    data: {
                        action: 'deleteSchedule',
                        schedule_idx: scheduleId
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            alert("일정이 삭제되었습니다.");
                            dateToRefreshAfterFetch = scheduleDate;
                            calendar.refetchEvents();
                        } else {
                            alert("삭제에 실패했습니다: " + (response.message || ""));
                        }
                    },
                    error: function() {
                        alert("삭제 중 오류가 발생했습니다.");
                    }
                });
            }
    	
     });

    // 4. 통합 모달(추가/수정) 관련
    $('#add-schedule-btn').on('click', function() { 
		openNewScheduleModal();
	 });
	 
    $('#add-todo-btn').on('click', function() { 
    	$modalTitle.text('새로운 할 일 추가');
            $todoForm[0].reset();
            $('#todo-id').val(''); // 새로운 할 일
            $('#todo-group').val('');
            
            displayRecentColors('#todo-recent-colors', '#todo-color');
            
            $scheduleForm.hide();
            $todoForm.show();
            $unifiedModal.show();
     });
     
     // 모달 닫기
     // 1. 회색 배경(오버레이) 클릭 이벤트 처리
    $unifiedModal.on('click', function(e) { 
			// e.target은 실제 클릭이 시작된 요소
			// this는 이벤트가 부착된 요소($unifiedModal)
			// 두 개가 정확히 같을 때만 닫기
			if(e.target === this){
				$unifiedModal.hide();
			}
	 });
	 
	 // 2. 닫기 버튼 클릭 이벤트 별도 처리 
	 $unifiedModal.on('click', '.modal-close-btn', function(){
		$unifiedModal.hide();
	});
	 
	 // 1. 일정 폼 제출
    $scheduleForm.on('submit', function(e) { 
			e.preventDefault(); // 페이지 전체가 새로고침되는 브라우저의 기본 동작 막기
								// AJAX를 이용해 폼을 제출하는 이벤트 핸들러에서는 반드시 가장 첫 줄에 e.preventDefault()를 작성
            const scheduleId = $('#schedule-id').val();
            const isUpdating = !!scheduleId; // boolean값으로 변환. if (scheduleId !== '' && scheduleId !== null && ...)
            const scheduleData = {
                action: isUpdating ? 'updateSchedule' : 'addSchedule',
                title: $('#schedule-title').val(),
                description: $('#schedule-description').val(),
                start_time: $('#schedule-start').val().replace('T', ' ') + ':00', //YYYY-MM-DD HH:MM:SS. DB TIMESTAMP 형식
                end_time: $('#schedule-end').val().replace('T', ' ') + ':00',
                color: $('#schedule-color').val()
            };
            if (isUpdating) { scheduleData.schedule_idx = scheduleId; } // update인 경우 schedule_idx 추가로 담아줌
            const alertMessage = isUpdating ? "수정" : "추가";
            $.ajax({
                url: contextPath +'/schedules.do',
                type: 'POST',
                data: scheduleData,
                success: function(response) {
                    if (response.success) {
                        alert('일정이 성공적으로 ' + alertMessage + '되었습니다.');
                        saveRecentColor(scheduleData.color);
                        $unifiedModal.hide();
                        dateToRefreshAfterFetch = scheduleData.start_time.substring(0, 10);
                        calendar.refetchEvents();
                    } else { alert('일정 ' + alertMessage + '에 실패했습니다.'); }
                },
                error: function() { alert('서버와 통신 중 오류가 발생했습니다.'); }
            });
	 });
	 
	// 2. 할 일 폼 제출
    $todoForm.on('submit', function(e) {  
			e.preventDefault();
            const todoId = $('#todo-id').val();
            const isUpdating = !!todoId;
            const todoData = {
                action: isUpdating ? 'updateTodo' : 'addTodo',
                text: $('#todo-text').val(),
                todo_group: $('#todo-group').val(),
                color: $('#todo-color').val()
            };
            if (isUpdating) { todoData.todo_idx = todoId; }
            const alertMessage = isUpdating ? "수정" : "추가";
            $.ajax({
                url: contextPath +'/todoList.do',
                type: 'POST',
                data: todoData,
                success: function(response) {
                    if (response.success) {
                        alert('할 일이 성공적으로 ' + alertMessage + '되었습니다.');
                        saveRecentColor(todoData.color);
                        $unifiedModal.hide();
                        loadTodoList();
                    } else { alert('할 일 ' + alertMessage + '에 실패했습니다.'); }
                },
                error: function() { alert('서버와 통신 중 오류가 발생했습니다.'); }
            }); 
        });
        
    // 최근 색상 동그라미 클릭 이벤트 핸들러
    $unifiedModal.on("click", '.recent-color-circle', function(){
		const color = $(this).data('color');
		//클릭된 동그라미가 속한 컨테이너 찾기
		const $container = $(this).closest('.recent-colors-container');
		// 해당 컨테이너와 연결된 color input 찾기
		const $colorInput = $container.siblings('input[type="color"]');
		
		// 색상 값 변경
		$colorInput.val(color);
		
		$container.find('.recent-color-circle').removeClass('selected');
		$(this).addClass('selected');
});

	// 기본 색상 선택기 값이 변경될 떄 'selected'클래스 제거
	$('#schedule-color, #todo-color').on('input', function(){
		$(this).siblings('.recent-colors-container').find('.recent-color-circle').removeClass('selected');
	});
    
    // 6. 위젯 '더보기' 및 전체 목록 모달
    $('#contents_grid').on('click', '.more-btn', function() { 
			const type = $(this).data('type');
            let action = '', modalTitle = '';
            if (type === 'my-posts') { action = 'getAllMyPosts'; modalTitle = '내가 작성한 글 전체'; } 
            else if (type === 'liked-posts') { action = 'getAllLikedPosts'; modalTitle = '좋아요한 글 전체'; } 
            else { return; }

            $.ajax({
                url: contextPath + '/note.do',
                type: 'GET',
                data: { action: action },
                dataType: 'json',
                success: function(posts) {
                    const $listModal = $('#list-modal');
                    $('#list-modal-title').text(modalTitle);
                    let listHtml = '<ul class="widget-list">';
                    if (posts && posts.length > 0) {
                        posts.forEach(function(post) {
                            listHtml += `<li>
                                        <a href="postView.do?nidx=${post.note_idx}">
                                            <div class="post-main-info">
                                                <span class="widget-post-title">${post.title}</span>
                                                <span>조회수 ${post.view_count} | 좋아요 ${post.like_count}</span>
                                            </div>
                                            <div class="widget-post-author">
                                                <span class="widget-post-meta">BY ${post.author_name}</span>
                                            </div>
                                        </a>
                                    </li>`;
                        });
                    } else {
                        listHtml += '<li class="no-items">목록이 없습니다.</li>';
                    }
                    listHtml += '</ul>';
                    $listModal.find('.list-modal-content').html(listHtml);
                    $listModal.show();
                }
            });
	 });
     
     // 모달 닫기
     // 1. 회색 배경(오버레이) 클릭 이벤트 처리
    $('#list-modal').on('click', function(e) { 
			// e.target은 실제 클릭이 시작된 요소
			// this는 이벤트가 부착된 요소($unifiedModal)
			// 두 개가 정확히 같을 때만 닫기
			if(e.target === this){
				$('#list-modal').hide();
			}
	 });
	 // 2. 닫기 버튼 클릭 이벤트 별도 처리 
	 $('#list-modal').on('click', '.modal-close-btn', function(){
		$('#list-modal').hide();
	});
    
    // 7. 날짜 이동 팝오버 관련
    setTimeout(() => { // 캘린더 렌더링 후 이벤트 바인딩을 위해 약간의 지연시간 부여
        $('#calendar .fc-toolbar-title').on('click', function(e) { 
        		//e.stopPropagation();
                
                // 현재 캘린더의 년/월을 select box에 설정
                const currentDate = calendar.getDate();
                $yearSelect.val(currentDate.getFullYear());
                $monthSelect.val(currentDate.getMonth() + 1);

                $datePickerPopover.toggle();
         });
    }, 500);
    
    // '이동' 버튼 클릭
    $('#goto-date-btn').on('click', function() { 
			const year = $('#year-select').val();
            const month = $('#month-select').val();
            const targetDate = `${year}-${String(month).padStart(2, '0')}-01`;
            calendar.gotoDate(targetDate);
            $datePickerPopover.hide();
	 });
	 
	  // 팝오버 외부 영역 클릭 시 닫기
    $(document).on('click', function(e) {
        if (!$datePickerPopover.is(e.target) && $datePickerPopover.has(e.target).length === 0 && !$(e.target).closest('.fc-toolbar-title').length) {
            $datePickerPopover.hide();
        }
    });
   

    // 9. ESC 키로 모달 닫기
    $(document).on('keydown', function(e) { 
			if (e.key === 'Escape') {
				$('#addBlockModal, #list-modal').hide();
				$unifiedModal.hide();
				$datePickerPopover.hide();
				} 
			
			});
			
	$('#add-event-button').on("click", function(){
		const $thisButton = $(this);
		
		openNewScheduleModal({
			start : $thisButton.data('start'),
			end : $thisButton.data('end')
		});
		
		$thisButton.hide();
		calendar.unselect();
		
	});

	// 2. 캘린더 생성 및 렌더링
     var calendarEl = document.getElementById('calendar');
        if (calendarEl) { 
            calendar = new FullCalendar.Calendar(calendarEl, {
				eventDidMount: function(info) { // FullCalendar 옵션. 일정 추가 직후(Did Mount) 추가 잡업할 수 있는 함수.
				//						FullCalendar가 자동으로 전달
				//						info.event: 해당 일정의 원본 데이터 객체
        		// 1. 이벤트의 원본 색상을 가져옵니다. 색상이 지정되지 않았다면 기본값을 사용합니다.
        		const originalColor = info.event.backgroundColor || info.event.borderColor || '#3788d8';
        
       			// 2. hexToRgb 함수를 사용해 HEX를 RGB 객체로 변환합니다.
        		const rgb = hexToRgb(originalColor);
        
        if (rgb) {
            // 3. RGB에 투명도(alpha)를 추가하여 연한 배경색(rgba)
            const lightBackgroundColor = `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 0.3)`;
            
            // 4. 이벤트 요소에 직접 스타일을 적용합니다.
            // info.el: 방금 화면에 추가된 일정의 실제 HTML DOM 요소(<div class="fc-event...">...</div>)
            info.el.style.backgroundColor = lightBackgroundColor; // 배경색을 연한 색으로 변경
            info.el.style.borderColor = lightBackgroundColor;     
            
            // 5. 배경색이 밝아졌으므로, 이벤트 제목(title)의 글자색을 어둡게 하여 가독성 높임
            const eventTitleEl = info.el.querySelector('.fc-event-title');
            if (eventTitleEl) {
                eventTitleEl.style.color = 'var(--workspace-cal-font)'; // 진한 회색 계열
	            }
	        }
	    },
                initialView: 'dayGridMonth',
                selectable: true,
                editable: true,
                eventDurationEditable: true,
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek'
                },      
                titleFormat: { year:"numeric", month: "short"},
                dayMaxEvents: 2,
                height: '100%',
                aspectRatio: 1.8,
                fixedWeekCount: false,

                events: function(fetchInfo, successCallback, failureCallback) {
                    var startIso = fetchInfo.start.toISOString();
                    var endIso = fetchInfo.end.toISOString(); 
                    $.ajax({
                        url: contextPath +'/schedules.do',
                        method: 'GET',
                        data: {
                            action: 'getMonthlySchedules',
                            start: startIso,
                            end: endIso
                        },
                        dataType: 'json',
                        success: function(data) {
                            // 1. 받은 데이터의 날짜 문자열을 Date 객체로 변환
                            var processedEvents = data.map(function(event) {
                                return {
                                    id: event.id, // FullCalendar 표준 ID
                                    title: event.title,
                                    color: event.color,
                                    description: event.description,
                                    start: new Date(event.start), // 문자열을 Date 객체로
                                    end: new Date(event.end), // 문자열을 Date 객체로
                                    durationEditable: event.durationEditable,
                                    allDay : event.allDay
                                };
                            });

                            // 2. Date 객체로 변환된 데이터를 사용해 schedulesByDate 객체 생성
                            schedulesByDate = {}; // 초기화
                            processedEvents.forEach(function(event) {
								let loopStartDate = new Date(event.start);
								// 종료일이 없으면 시작일과 동일하게 설정
								let loopEndDate = event.end ? new Date(event.end) : new Date(event.start);
								
								// FullCalendar의 '종일' 이벤트는 종료일이 다음 날 00시
								if(event.end &&loopEndDate.getHours()===0 && loopEndDate.getMinutes() === 0){
									loopEndDate.setDate(loopEndDate.getDate() - 1);
								}
								
								// 2일 이상 일정
								// 시작일부터 종료일까지 하루씩 반복하면서 모든 날짜에 일정 추가
								while(loopStartDate <= loopEndDate){
									const dateKey = loopStartDate.toISOString().substring(0,10);
									
									if(!schedulesByDate[dateKey]){
										schedulesByDate[dateKey] = []
									}
									schedulesByDate[dateKey].push(event);
									
									//다음 날로 날짜 증가
									loopStartDate.setDate(loopStartDate.getDate()+1);
								}
                            });

                            // 3. 날짜별로 일정 정렬
                            for (var date in schedulesByDate) {
                                schedulesByDate[date].sort((a, b) => a.start - b.start);
                            }
                            // 최초 로딩 시 오늘 날짜 일정 로드
                            if (isInitialLoad) {
                                const todayStr = getTodayString();
                                loadDailySchedules(todayStr);
                              
                                isInitialLoad = false; // 플래그를 꺼서 다시는 실행되지 않게 함
                            }

                            // 4. 새로고침이 필요한 날짜가 있는지 확인하고, 목록을 다시 그립니다.
                            if (dateToRefreshAfterFetch) {
								const targetCell = calendarEl.querySelector(`td[data-date="${dateToRefreshAfterFetch}"]`)
								if(targetCell){
									handleDateSelection(targetCell);
								}else{
									// 현재 캘린더 뷰에 해당 날짜가 없으면 목록만 새로고침
									loadDailySchedules(dateToRefreshAfterFetch);
								}
                                dateToRefreshAfterFetch = null; // 변수 초기화
                            }

                            // 5. FullCalendar에게는 Date 객체가 포함된 데이터를 전달
                            successCallback(processedEvents);
                        },
                        error: function(xhr, status, error) {
                            failureCallback(error);
                        }
                    });
                },
                // --- 날짜 클릭 이벤트 ---
                dateClick: function(info) {
					handleDateSelection(info.dayEl);
                },
                eventClick: function(info) {
					// 클릭된 지점에서 가장 가까운 날짜 칸(.fc-daygrid-day) 찾기
					const dayCell = info.jsEvent.target.closest('.fc-daygrid-day');
					handleDateSelection(dayCell);	
                },
                select: function(selectInfo){
					const addButton = $('#add-event-button');
					
					// 1. 캘린더 요소의 현재 화면상 위치와 크기 정보를 가져옵니다.
    				const calendarRect = calendarEl.getBoundingClientRect();
					
					// 2. 뷰포트 기준 클릭 좌표(clientX/Y)에서 캘린더의 시작 좌표(left/top)를 빼서,
					//	  캘린더 내부에서의 상대적인 클릭 위치를 정화하게 계산
					const x = selectInfo.jsEvent.clientX - calendarRect.left;
					const y = selectInfo.jsEvent.clientY - calendarRect.top;
   					
   					// 버튼 위치 설정
   					addButton.css({
						top : y + 'px',
						left : x + 'px',
						display: 'block'
					});
					
					// 3. 나중에 '+' 버튼을 클릭했을 때 사용할 수 있도록,
    				//    선택된 날짜 정보를 버튼의 data 속성에 임시로 저장합니다.
    				addButton.data('start', selectInfo.startStr);
    				addButton.data('end', selectInfo.endStr);    				
				}, 
				unselect : function(){
					$('#add-event-button').hide();
				}, 
				eventDrop: function(dropInfo){
					// 1. 서버에 전송할 데이터 객체 생성
					const scheduleData = {
						action: 'updateSchedule',
						schedule_idx : dropInfo.event.id,
						title: dropInfo.event.title,
						description: dropInfo.event.extendedProps.description || '',
						color : dropInfo.event.backgroundColor,
						start_time : toLocalISOString(dropInfo.event.start).replace('T', ' ') + ':00',
						end_time : dropInfo.event.end ? toLocalISOString(dropInfo.event.end).replace('T', ' ') + ':00' : toLocalISOString(dropInfo.event.start).replace('T', ' ') + ':00'
					}
					
					// 2. AJAX를 통해 서버에 변경 사항을 전송
					$.ajax({
						url : contextPath + '/schedules.do',
						type :'POST',
						data: scheduleData,
						success : function(response){
							if(response.success){
								const newDateStr = scheduleData.start_time.substring(0,10);
								dateToRefreshAfterFetch = newDateStr;
								calendar.refetchEvents();
								
							}else{
								dropInfo.revert();
							}
						},
						error: function(){
							alert("서버와 통신 중 오류가 발생했습니다.");
							dropInfo.revert();
						}
					})
				},
				eventResize : function(resizeInfo){
					const scheduleData = {
						action: 'updateSchedule',
						schedule_idx : resizeInfo.event.id,
						title: resizeInfo.event.title,
						description: resizeInfo.event.extendedProps.description || '',
						color : resizeInfo.event.backgroundColor,
						start_time : toLocalISOString(resizeInfo.event.start).replace('T', ' ') + ':00',
						end_time : resizeInfo.event.end ? toLocalISOString(resizeInfo.event.end).replace('T', ' ') + ':00' : toLocalISOString(resizeInfo.event.start).replace('T', ' ') + ':00'
					};
					$.ajax({
						url : contextPath + '/schedules.do',
						type :'POST',
						data: scheduleData,
						success : function(response){
							if(response.success){
								dataToRefreshAfterFetch = scheduleData.start_time.substring(0,10);
								calendar.refetchEvents();
							}else{
								resizeInfo.revert();
							}
						},
						error: function(){
							alert("서버와 통신 중 오류가 발생했습니다.");
							resizeInfo.revert();
						}
					})	
				}
            });
            calendar.render();
        }

    // --- 초기 데이터 로딩 함수 호출 ---
    loadTodoList();
    populateDatePicker();
});