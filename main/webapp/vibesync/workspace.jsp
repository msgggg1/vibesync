                <%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<% String contextPath = request.getContextPath() + "/vibesync"; %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>workspace</title>
<link rel="icon" href="./sources/favicon.ico" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script defer src="./js/script.js"></script>
  <!-- 폰트 추가 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  <!-- 차트 그리기 : chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <%-- 달력 --%>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>
<link rel="stylesheet" href="./css/workspace.css">
<link rel="stylesheet" href="./css/style.css"> 
<link rel="stylesheet" href="./css/sidebar.css">
  
    <style> /* 추가 블록 */
        .block-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .block-header h4 { margin: 0; }
        .block-actions button { background: none; border: none; cursor: pointer; color: #888; font-size: 14px; margin-left: 5px; }
        .block-actions button:hover { color: #000; }
        .chart-toggles { margin-bottom: 10px; }
        .chart-toggles label { margin-right: 15px; font-size: 13px; cursor: pointer; }
        .loading-spinner { border: 4px solid #f3f3f3; border-top: 4px solid #3498db; border-radius: 50%; width: 30px; height: 30px; animation: spin 1s linear infinite; margin: 20px auto; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
  
</head>
<body>
	<div id="notion-app">
		<input type="hidden" id="mode" value="workspace">
		<div class="notion-app-inner">
			<jsp:include page="./includes/sidebar.jsp"></jsp:include>
			<!-- content -->
			<div id="content_wrapper">
				<section id="content">
					<div id="workspace_wrapper">
						<div id="todolist">
							<div id="calendar"></div>
							<div id="date-picker-popover" style="display: none;">
					            <div class="date-picker-body">
					                <select id="year-select"></select>
					                <select id="month-select"></select>
					                <button id="goto-date-btn">이동</button>
					            </div>
					        </div>
							<%-- 우측 영역: .calendar_contents --%>
							<div class="calendar_contents">
								<%-- 탭 버튼 영역 --%>
								<div class="tab-buttons">
									<button class="tab-btn active" data-tab="tab_schedule">일정</button>
									<button class="tab-btn" data-tab="tab_todo">할 일</button>
								</div>
								<div class="add-btn-container">
									<button id="add-schedule-btn" class="add-btn">+ 새 일정</button>
									<button id="add-todo-btn" class="add-btn"
										style="display: none;">+ 새 할 일</button>
								</div>
								<%-- 탭 컨텐츠 영역 --%>
								<div class="tab-content-wrapper">
									<div id="tab_schedule" class="tab-content active">
										<p>캘린더에서 날짜를 선택해주세요.</p>
									</div>
									<div id="tab_todo" class="tab-content">
										<p>로딩 중...</p>
									</div>
								</div>
							</div>
						</div>


						<div class="line"></div>

						<div id="contents_grid">
							<div class="contents_item" id="my-posts">
								<div class="widget-header">
						        <h4><i class="fa-solid fa-pen-nib"></i>&nbsp;&nbsp;내가 작성한 글</h4>
						        <button class="more-btn" data-type="my-posts">더보기</button>
						    </div>
						    <ul>
						        <%-- initialData에 담겨온 myPosts 목록을 사용 --%>
						        <c:choose>
						            <c:when test="${not empty initialData.myPosts}">
						                <c:forEach var="post" items="${initialData.myPosts}">
						                    <li>
						                        <a href="postView.do?nidx=${post.note_idx}" title="${post.title}">
						                            <span>${post.title}</span>
						                            <span class="block-meta">
						                                <i class="fa-regular fa-eye"></i> ${post.view_count}&nbsp;&nbsp;
						                                <i class="fa-regular fa-thumbs-up"></i>${post.like_count}
						                            </span>
						                        </a>
						                    </li>
						                </c:forEach>
						            </c:when>
						            <c:otherwise>
						                <li class="no-items">작성한 글이 없습니다.</li>
						            </c:otherwise>
						        </c:choose>
						    </ul>
							</div>
							<div class="contents_item" id="liked-posts">
								<div class="widget-header">
							        <h4><i class="fa-solid fa-heart"></i>&nbsp;&nbsp;좋아요한 글</h4>
							        <button class="more-btn" data-type="liked-posts">더보기</button>
							    </div>
							    <ul>
							        <%-- initialData에 담겨온 likedPosts 목록을 사용 --%>
							        <c:choose>
							            <c:when test="${not empty initialData.likedPosts}">
							                <c:forEach var="post" items="${initialData.likedPosts}">
							                    <li>
							                        <a href="postView.do?nidx=${post.note_idx}" title="${post.title}">
							                            <span>${post.title}</span>
							                            <span class="block-meta">by ${post.author_name}</span>
							                        </a>
							                    </li>
							                </c:forEach>
							            </c:when>
							            <c:otherwise>
							                <li class="no-items">좋아요한 글이 없습니다.</li>
							            </c:otherwise>
							        </c:choose>
							    </ul>
							</div>

							<!-- 안읽은 메시지 목록 -->
                            <div id="unread_messages" class="contents_item" style="background-color: var(--sidebar-color); border-radius: 20px; padding: 20px; box-shadow: 0 4px 20px rgba(0,0,0,0.2);">
                            <h3 style="font-size: 18px; margin-bottom: 16px; color: var(--font-color); border-bottom: 1px solid var(--border-color); padding-bottom: 8px;"><i class="fa-solid fa-bell"></i> 안읽은 메시지</h3>
                            <div class="message_card_list">
                                <c:choose>
                                <c:when test="${not empty initialData.unreadMessages}">
                                    <c:forEach var="msg" items="${initialData.unreadMessages}">
                                    <div class="message_card message_item" data-sender-idx="${msg.ac_sender}" data-nickname="${msg.latestMessage.sender_nickname}">
                                        <%-- <div class="msg_profile">
                                        <img src="${pageContext.request.contextPath}/vibesync/sources/profile/${msg.latestMessage.sender_img}" alt="profile">
                                        </div> --%>
                                        <div class="msg_text_area">
                                        <div class="msg_sender_row">
                                        <div class="msg_sender">${msg.latestMessage.sender_nickname}</div>
                                        <span class="unread-badge">${msg.numOfUnreadMessages}</span>
                                        </div>
                                        <div class="msg_preview">${msg.latestMessage.text}</div>
                                        <div class="msg_time">${msg.latestMessage.relativeTime}</div>
                                        </div>
                                    </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no_message">새로운 메시지가 없습니다.</div>
                                </c:otherwise>
                                </c:choose>
                            </div>
                            </div>

							<%-- 동적으로 추가된 블록들을 렌더링하는 부분 --%>
							<c:forEach var="block" items="${workspaceData.blocks}">
								<div class="contents_item generated_block" id="block-${block.block_id}">
									<div class="block-header">
										<h4>
											<c:choose>
												<c:when test="${block.block_type == 'CategoryPosts'}"><i class="fa-solid fa-layer-group"></i>&nbsp;${block.categoryName} ${block.sortType == 'popular' ? '인기' : '최신'}글</c:when>
												<c:when test="${block.block_type == 'WatchParties'}"><i class="fa-solid fa-tv"></i>&nbsp;진행중인 워치파티</c:when>
												<c:when test="${block.block_type == 'UserStats'}"><i class="fa-solid fa-chart-simple"></i>&nbsp;${block.title}</c:when>
											</c:choose>
										</h4>
										<button class="refresh-block-btn" data-block-id="${block.block_id}" title="새로고침">
											<i class="fa-solid fa-arrows-rotate"></i>
										</button>
									</div>
									<div class="block-content">
										<%-- 각 블록 타입에 맞는 JSP 프래그먼트를 include --%>
										<c:set var="block" value="${block}" scope="request" />
										<jsp:include page="/WEB-INF/views/workspace/fragments/_${block.block_type}Content.jsp" />
									</div>
								</div>
						</c:forEach>

                        <!-- 추가 블록 -->
			            <div id="content_plus" class="contents_item">+</div>

						</div>
					</div>
				</section>
			</div>
            
            <%-- 동적으로 추가된 블록들을 렌더링하는 부분 --%>
            <c:forEach var="block" items="${workspaceData.blocks}">
				<%-- 각 블록에 대한 데이터를 request scope에 설정 --%>
			    <c:set var="block" value="${block}" scope="request" />
			    <%-- _blockWrapper.jsp를 include하여 블록을 렌더링 --%>
			    <jsp:include page="/WEB-INF/views/workspace/fragments/_blockWrapper.jsp" />
           </c:forEach>
            
            <!-- 추가 블록 -->
			<div id="content_plus" class="contents_item">+</div>

<%-- ======================================================== --%>
<%--                통합 추가/수정 모달 창                     --%>
<%-- ======================================================== --%>
<div class="modal-overlay" id="unified-modal" style="display: none;">
    <div class="modal-content">
        <h2 id="modal-title"></h2> <%-- 제목은 JS가 채워줍니다 --%>
        
        <form id="schedule-form" style="display: none;">
            <input type="hidden" id="schedule-id" name="schedule_idx">
            <div class="form-group">
                <label for="schedule-title">제목</label>
                <input type="text" id="schedule-title" name="title" required>
            </div>
            <div class="form-group">
                <label for="schedule-description">설명</label>
                <textarea id="schedule-description" name="description" rows="3"></textarea>
            </div>
            <div class="form-group-row">
                <div class="form-group">
                    <label for="schedule-start">시작 시간</label>
                    <input type="datetime-local" id="schedule-start" name="start_time" required>
                </div>
                <div class="form-group">
                    <label for="schedule-end">종료 시간</label>
                    <input type="datetime-local" id="schedule-end" name="end_time" required>
                </div>
            </div>
            <div class="form-group">
                <label for="schedule-color">색상</label>
                <input type="color" id="schedule-color" name="color" value="#3788d8">
            </div>
            <div class="modal-buttons">
                <button type="button" class="modal-close-btn">취소</button>
                <button type="submit" class="modal-save-btn">저장</button>
            </div>
        </form>

        <form id="todo-form" style="display: none;">
            <input type="hidden" id="todo-id" name="todo_idx">
            <div class="form-group">
                <label for="todo-text">내용</label>
                <textarea id="todo-text" name="text" rows="4" required></textarea>
            </div>
            <div class="form-group">
                <label for="todo-group">그룹</label>
                <input type="text" id="todo-group" name="todo_group">
            </div>
            <div class="form-group">
        		<label for="todo-color">색상</label>
        		<input type="color" id="todo-color" name="color" value="#3788d8">
    		</div>
            
            <div class="modal-buttons">
                <button type="button" class="modal-close-btn">취소</button>
                <button type="submit" class="modal-save-btn">저장</button>
            </div>
        </form>
    </div>
</div>
<%-- 게시글 전체 목록 표시용 모달 창 --%>
<div class="modal-overlay" id="list-modal" style="display: none;">
    <div class="modal-content">
        <h2 id="list-modal-title"></h2>
        <div class="list-modal-content"></div> 
        <div class="modal-buttons">
            <button type="button" class="modal-close-btn">닫기</button>
        </div>
    </div>
</div>

<!-- 모달 -->
	<!-- 메시지 모달 -->
	<div id="chatModal" class="modal">
	  <div class="modal-content" style="min-width:350px; max-width:430px;">
	    <span class="close-modal" onclick="closeChatModal()"> &times; </span>
	    <h4 id="chatTitle" style="text-align:center;">채팅</h4>
	    <div id="chatHistory"></div>
		<div class="chat-input-row">
		  <input type="text" id="chatInput" placeholder="메시지를 입력하세요..." autocomplete="off" />
		  <button type="button" id="sendMessageBtn" title="전송">
		    <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
		      <path d="M3 19L20 11L3 3V10L15 11L3 12V19Z" fill="#fff"/>
		    </svg>
		  </button>
		</div>
	  </div>
	</div>
	
	<!-- 블록 추가 모달 -->
	<div id="addBlockModal" class="modal">
		<div class="modal-content" style="text-align: center;">
			<h4>추가할 블록 선택</h4>
			<hr><br>
			<select id="blockTypeSelector">
				<option value="CategoryPosts">카테고리별 글</option>
				<option value="WatchParties">구독 워치파티</option>
				<option value="UserStats">내 활동 통계</option>
			</select>
	
			<div id="category" style="display: none;">
				<select id="categorySelector" name="category">
					<c:forEach items="${ categoryVOList }" var="categoryVO">
						<option value="${ categoryVO.category_idx }">${ categoryVO.c_name }</option>
					</c:forEach>
				</select>
				<br>
				<select id="sortTypeSelector">
					<option value="popular">인기순</option>
					<option value="latest">최신순</option>
				</select>
			</div>
			<button id="confirmAddBlock" style="display: block;">추가</button>
		</div>
	</div>
	<!-- 모달 끝 -->

<script> /* 모달, 블록 */
	
    // 전역 차트 인스턴스 저장소
    const userCharts = {};
	
    /* js, jquery */
    $(document).ready(function() {
    	// 초기 페이지 로드
        <c:forEach var="block" items="${workspaceData.blocks}">
            <c:if test="${block.block_type == 'UserStats'}">
                // 서버에서 받은 JSON 문자열을 사용해 차트 생성 함수를 호출하는 코드를 반복문으로 생성
                createOrUpdateChart(${block.block_id}, JSON.parse('<c:out value="${block.chartDataJson}" escapeXml="false"/>'));
            </c:if>
        </c:forEach>
        
        // + 버튼 표시여부 결정
        updateAddBlockButtonVisibility();
		
        // 이벤트 관련
        const grid = $('#contents_grid');

     // 이벤트 위임을 사용하여 새로고침 및 삭제 버튼 이벤트 한 번에 처리
        grid.on('click', '.block-actions button', function() {
            const button = $(this);
            const blockId = button.data('block-id');

            if (button.hasClass('refresh-block-btn')) {
                const blockContentDiv = $('#block-' + blockId + ' .block-content');
                blockContentDiv.html('<div class="loading-spinner"></div>');
                $.ajax({
                    url: 'block.do',
                    type: 'GET',
                    data: { block_id: blockId },
                    dataType: 'json', // 서버로부터 JSON 응답을 기대한다고 명시
                    success: function(res) {
                        // 1. 새로운 HTML로 내용을 교체
                        blockContentDiv.html(res.html);

                        // 2. 만약 블록 타입이 'UserStats'이고 차트 데이터가 있다면 차트를 다시 그림
                        if (res.block_type === 'UserStats' && res.chart_data) {
                            createOrUpdateChart(blockId, res.chart_data);
                        }
                    },
                    error: function() {
                        blockContentDiv.html('<p style="color:red;">새로고침 실패</p>');
                    }
                });
            } else if (button.hasClass('delete-block-btn')) {
                deleteBlock(blockId);
            }
        });

        // 차트 데이터셋 토글
        grid.on('change', '.dataset-toggle-cb', function() {
            const checkbox = $(this);
            const chartId = checkbox.closest('.chart-toggles').data('chart-id');
            const datasetIndex = checkbox.data('dataset-index');
            const chart = userCharts[chartId];
            if (chart) {
                chart.setDatasetVisibility(datasetIndex, checkbox.prop('checked'));
                chart.update();
            }
        });

        // --- 블록 추가 모달 관련 이벤트 ---
        $('#content_plus').on('click', function() {
  		  $('html, body').scrollTop(0);
		  $('#addBlockModal').css({
			  position: 'fixed',
			  top: '50%',
			  left: '50%',
			  transform: 'translate(-50%, -50%)',
			  backgroundColor: 'rgba(0,0,0,0.8)',
			  display: 'flex',
			  zIndex: 99999
		  });
        });
        
        $('#blockTypeSelector').on('change', function() {
            if ($(this).val() === 'CategoryPosts') { $('#category').show(); } 
            else { $('#category').hide(); }
        }).change();

        $('#confirmAddBlock').on('click', function() {
            const blockType = $('#blockTypeSelector').val();
            let dataToSend = {
                block_type: blockType, // camelCase 사용
            };
            if (blockType === 'CategoryPosts') {
                dataToSend.category_idx = $('#categorySelector').val();
                dataToSend.category_name = $('#categorySelector option:selected').text();
                dataToSend.sort_type = $('#sortTypeSelector').val();
            }
            addBlockToServer(dataToSend);
            $('#addBlockModal').hide();
        });
        
	    // 모달 외부 클릭/ESC로 닫기
	    $(document).on('keydown', function(e) {
	        if (e.key === 'Escape') {
	          $('#addBlockModal').hide();
	        }
	    });

	    $('#addBlockModal').on('click', function(e) {
	        if (e.target.id === 'addBlockModal') {
	          $(this).hide();
	        }
	    });
        
    });
    
	/* 함수 */

	// '+' 버튼 표시 여부를 업데이트하는 함수
	function updateAddBlockButtonVisibility() {
	    if ($('.generated_block').length >= 5) {
	        $("#content_plus").hide();
	    } else {
	        $("#content_plus").show();
	    }
	}
	
    // 차트 생성 함수
    function createOrUpdateChart(blockId, chartData) {
        const chartId = 'userStatsChart_' + blockId;
        if (userCharts[chartId]) {
            userCharts[chartId].destroy();
        }
        const ctx = document.getElementById(chartId)?.getContext('2d');
        if (!ctx) return;

        const chart = new Chart(ctx, {
            type: 'line',
            data: chartData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } },
                plugins: { legend: { position: 'top' }, tooltip: { mode: 'index', intersect: false } },
                hover: { mode: 'index', intersect: false }
            }
        });
        userCharts[chartId] = chart;
    }

    // 블록 추가 함수
	function addBlockToServer(payload) {
	    $.ajax({
	        url: 'block.do',
	        type: 'POST',
	        data: payload,
	        dataType: 'json', // 응답 타입을 'html'에서 'json'으로 변경
	        success: function(res) { // 응답 변수 이름을 res (response)로 변경
	            // 1. 새로운 HTML을 화면에 추가
	            $('#content_plus').before(res.html);
	            
	            // 2. 만약 추가된 블록이 차트 블록이라면, 차트를 그려줌
	            if (res.block_type === 'UserStats' && res.chart_data) {
	                // res.blockId로 새로 추가된 블록의 ID를 사용
	                createOrUpdateChart(res.block_id, res.chart_data);
	            }
	            
	            // 3. '+' 버튼 표시 여부 업데이트
	            updateAddBlockButtonVisibility();
	        },
	        error: function() { alert('블록을 추가하는 데 실패했습니다.'); }
	    });
	}

	// 블록 삭제
	function deleteBlock(blockId) {
	    if (!confirm("블록을 정말 삭제하시겠습니까?")) return;
	    $.ajax({
	        url: 'block.do',
	        type: 'POST', // 1. type을 'DELETE'에서 'POST'로 변경
	        data: {
	            block_id: blockId,
	            _method: 'DELETE' // 2. 실제 의도를 담은 파라미터 추가
	        },
	        dataType: 'json',
	        success: function(res) {
	            if (res.success) {
	                $('#block-' + blockId).fadeOut(function() {
	                    $(this).remove();
	                    
	                    updateAddBlockButtonVisibility();
	                });
	            } else { alert(res.message); }
	        },
	        error: function() { alert('블록 삭제 중 오류가 발생했습니다.'); }
	    });
	}

    
</script>

<script> /* 채팅방 */

	/* js, jquery */
	let currentChatSenderIdx = null;
	
	$(document).ready(function() {
	    $('.message_item').on('click', function () {
	      const senderIdx = $(this).data('sender-idx');
	      currentChatSenderIdx = senderIdx;
	      const nickname = $(this).data('nickname');
	      $('#chatTitle').text(nickname);
	      
	      $.ajax({
	        url: '${pageContext.request.contextPath}/message.do',
	        type: 'GET',
	        data: { senderIdx },
	        dataType: 'json',
	        success: function (chatList) {
	        	$('#chatHistory').empty();
	
	            if (!chatList || !Array.isArray(chatList) || chatList.length === 0) {
	                $('#chatHistory').html('<p style="text-align:center; color:grey;">채팅 내역이 없습니다.</p>');
	                return; 
	            }
	            
	            const chatContainer = $('<div class="chat-container"></div>');
	
	            chatList.forEach(msg => {
	                const who = msg.isMine ? 'bubble-me' : 'bubble-other';
	                const formattedText = msg.text.replace(/\n/g, '<br>');
	
	                const messageHtml = `
	                    <div class="chat-bubble \${who}">
	                        <div class="bubble-text">\${formattedText}</div>
	                        <div class="bubble-time">\${msg.relativeTime}</div>
	                    </div>
	                `;
	                chatContainer.append(messageHtml);
	            });
	
	            $('#chatHistory').append(chatContainer);
	
	            $('#chatModal').css({
	                display: 'flex',
	                top: '50%',
	                left: '50%',
	                transform: 'translate(-50%, -50%)',
	                backgroundColor: 'rgba(0,0,0,0.8)'
	            });
	            
	            if(chatContainer.length) {
	                chatContainer.scrollTop(chatContainer[0].scrollHeight);
	            }
	        },
	        error: function () {
	          alert('채팅 내역 불러오기 실패');
	        }
	      });
	    });
	    
	    // 채팅방에서 메시지 전송 (버튼 클릭 또는 엔터)
	    $("#sendMessageBtn").on("click", sendChatMessage);
	
	    $("#chatInput").on("keydown", function(e) {
	      if (e.key === "Enter" && !e.shiftKey) {
	        e.preventDefault();
	        sendChatMessage();
	      }
	   });
	});

/* 채팅방 함수 */
	// 채팅 내역 닫기
	function closeChatModal() {
		$('#chatModal').hide();
		location.reload();
	}
	
	// 채팅방에서 메시지 전송하는 함수
	function sendChatMessage() {
	    const message = $("#chatInput").val().trim();
	    if (!message || !currentChatSenderIdx) return;
	
	    $.ajax({
	      url: '${pageContext.request.contextPath}/message.do',
	      type: 'POST',
	      data: JSON.stringify({
	        receiverIdx: currentChatSenderIdx,
	        text: message
	      }),
	      contentType: "application/json; charset=utf-8",
	      success: function(res) {
	        $("#chatInput").val(""); // 입력창 비우기
	
	        // 메시지 전송 성공시 채팅 내역 갱신
	        // 서버에서 새 메시지 저장 후, 최신 내역 반환
	        // 채팅내역 새로 불러오기
	        reloadChatHistory();
	      },
	      error: function() {
	        alert('메시지 전송 실패!');
	      }
	    });
	}
	
	// 채팅내역 새로 불러오기
    function reloadChatHistory() {
      if (currentChatSenderIdx) {
        $('.message_item[data-sender-idx="'+currentChatSenderIdx+'"]').click();
      }
    }

</script>

</html>

























