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
  <title>user</title>
  <link rel="icon" href="./sources/favicon.ico" />
  <link rel="stylesheet" href="./css/style.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script defer src="./js/script.js"></script>
  
  <!-- 폰트 추가 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  
  <!-- 차트 그리기 : chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  
  <!-- workspace.css -->
  <link rel="stylesheet" href="./css/workspace.css">
  
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
      <jsp:include page="./includes/sidebar.jsp" flush="true"></jsp:include>

      <!-- content -->
      <div id="content_wrapper">
        <section id="content">
          <div id="workspace_wrapper">
            <div id="todolist">
              <div class="calendar_contents"></div>
              <div class="calender"></div>
            </div>
    
            <div class="line"></div>
    
            <div id="contents_grid">
              <div class="contents_item"></div>
              <div class="contents_item"></div>
            
            <!-- 안읽은 메시지 목록 -->
			<div id="unread_messages" class="contents_item" style="background-color: var(--sidebar-color); border-radius: 20px; padding: 20px; box-shadow: 0 4px 20px rgba(0,0,0,0.2);">
			  <h3 style="font-size: 18px; margin-bottom: 16px; color: var(--font-color); border-bottom: 1px solid var(--border-color); padding-bottom: 8px;"><i class="fa-solid fa-bell"></i> 안읽은 메시지</h3>
			  <div class="message_card_list">
			    <c:choose>
			      <c:when test="${not empty workspaceData.unreadMessages}">
			        <c:forEach var="msg" items="${workspaceData.unreadMessages}">
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

    </div>
  </div>
  
</body>

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

	<script> /* 채팅방 */
	
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

	</script>

  <script> /* 모달 */
  
  let category_name = null;
  let sortType = null;
  
  $(document).ready(function() {
	// 페이지 로드 시 초기 차트 렌더링
    <c:forEach var="block" items="${workspaceData.blocks}">
    <c:if test="\${block.block_type == 'UserStats'}">
          (function() {
              const block_id = \${block.block_id};
              const chartData = JSON.parse('<c:out value="\${block.chartDataJson}" escapeXml="false"/>');
              createOrUpdateChart(block_id, chartData);
          })();
    </c:if>
    </c:forEach>

      // 모든 이벤트 핸들러 등록
      const grid = $('#contents_grid');

      // 블록 새로고침
      grid.on('click', '.refresh-block-btn', function() {
          const block_id = $(this).data('block-id');
          const blockContentDiv = $('#block-' + block_id + ' .block-content');
          blockContentDiv.html('<div class="loading-spinner"></div>');
          $.ajax({
              url: 'block.do', type: 'GET', data: { block_id: block_id },
              success: function(newBlockContentHtml) { blockContentDiv.html(newBlockContentHtml); },
              error: function() { blockContentDiv.html('<p style="color:red;">새로고침 실패</p>'); }
          });
      });

      // 블록 삭제
      grid.on('click', '.delete-block-btn', function() {
          deleteBlock($(this).data('block-id'));
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

      // 블록 추가
	  	// '+' 버튼 클릭 -> 추가 블록 모달 열기
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
	    	if ($(this).val() === 'CategoryPosts') {
	            $('#category').show();
	        } else {
	            $('#category').hide();
	        }
	    });
	    $("#blockTypeSelector").change();
	    
        // 블록 개수 5개 제한
        if ($('#contents_grid .generated_block').length >= 4) {
             $("#content_plus").hide();
        }
      
      // 블록 추가 모달 확인 버튼
	  $('#confirmAddBlock').on('click', function() {
		  const block_type = $('#blockTypeSelector').val();
		    
		  // 서버에 전송할 데이터를 담는 객체
		  let dataToSend = {
		      block_type: block_type // 'CategoryPosts', 'UserStats' 등 블록의 종류
		  };
		
		  // '카테고리별 글' 타입일 경우, 추가 설정값을 담아줍니다.
		  if (block_type === 'CategoryPosts') {
		      dataToSend.categoryIdx = $('#categorySelector').val();
		      dataToSend.sortType = $('#sortTypeSelector').val();
		  }
		    
		  // 완성된 데이터 객체를 addBlockToServer 함수에 전달합니다.
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
  
  </script>
  
  <script> /* 함수 모음 */
  
    // 전역 차트 인스턴스 저장소
    const userCharts = {};

    // 차트 생성/재생성 함수 (이 함수는 전역에서 접근 가능해야 함)
    function createOrUpdateChart(block_id, chartData) {
        if (userCharts['userStatsChart_' + block_id]) {
            userCharts['userStatsChart_' + block_id].destroy();
        }
        const ctx = document.getElementById('userStatsChart_' + block_id)?.getContext('2d');
        if (!ctx) return;

        const chart = new Chart(ctx, { /* ... 차트 생성 로직 ... */ });
        userCharts['userStatsChart_' + block_id] = chart;
    }

    // 블록 추가 함수
	function addBlockToServer(dataToSend) {
	    $.ajax({
	        url: 'block.do',
	        type: 'POST',
	        data: dataToSend,
	        dataType: 'html',
	        success: function(newBlockHtml) {
	            $('#content_plus').before(newBlockHtml);
	
	            // 블록 개수 제한 로직
	            if ($('#contents_grid .generated_block').length >= 5) {
	                $("#content_plus").hide();
	            }
	        },
	        error: function(err) {
	            console.error("블록 추가 실패: ", err);
	            alert('블록을 추가하는 데 실패했습니다.');
	        }
	    });
	}

    // 블록 삭제 함수
    function deleteBlock(block_id) {
        if (!confirm("블록을 정말 삭제하시겠습니까?")) return;
        $.ajax({
            url: 'block.do', type: 'DELETE',
            data: { block_id: block_id }, dataType: 'json',
            success: function(res) {
                if (res.success) {
                    $('#block-' + block_id).remove();
                    if ($('#contents_grid .generated_block').length < 5) { $("#content_plus").show(); }
                } else { alert(res.message); }
            },
            error: function() { alert('블록 삭제 중 오류가 발생했습니다.'); }
        });
    }
  
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