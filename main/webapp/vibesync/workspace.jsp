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
  
</head>
<body>

  <div id="notion-app">
    <input type="hidden" id="mode" value="user">
    <input type="hidden" id="profileUserAcIdx" value="${userPageData.userProfile.ac_idx}">
    <%-- 무한스크롤용 --%>
    <input type="hidden" id="currentPageNumber" value="${userPageData.nextPageNumber - 1}">
    <%-- 현재 로드된 페이지 번호 --%>
    <input type="hidden" id="hasMorePosts" value="${userPageData.hasMorePosts ? 'true' : 'false'}">

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

	    // 추가 블록 모달에서 타입 선택 시 옵션 표시/숨김 처리
	    $('#blockTypeSelector').on('change', function() {
	    	if ($(this).val() === 'CategoryPosts') {
	            $('#category').show();
	        } else {
	            $('#category').hide();
	        }
	        
	    });
	    $("#blockTypeSelector").change();

	    // 모달에서 '추가' 버튼 클릭
	    $('#confirmAddBlock').on('click', function() {
	        const blockType = $('#blockTypeSelector').val();
	        let options = { action: blockType };

	        if (blockType === 'CategoryPosts') {
	        	category_name = $("#categorySelector option:selected").text();
	        	sortType = $("#sortTypeSelector").val();
	            options.categoryIdx = $('#categorySelector').val();
	            options.sortType = $('#sortTypeSelector').val();
	        }
	        
	        addBlockToServer(options);
	        $('#addBlockModal').hide();
	        
	        // 블록 개수 5개 제한
	        if ($('#contents_grid .generated_block').length >= 4) {
	             $("#content_plus").hide();
	             return;
	        }
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
  
	// 서버에 블록 데이터 요청 및 화면에 추가하는 함수
	function addBlockToServer(options) {
	  $.ajax({
	    url: 'block.do',
	    type: 'GET',
	    data: {
	      action: options.action,
	      category_idx: options.categoryIdx,
	      sortType: options.sortType
	    },
	    dataType: 'json',
	    success: function(data) {
	      let blockHtml = '<div class="contents_item generated_block">';
	      const timestamp = Date.now(); // 고유 ID 생성을 위해 사용
	
	      if (options.action === 'CategoryPosts') {
	    	  blockHtml += `<h4><i class="fa-solid fa-layer-group" style="color:#6ac8fa"></i>&nbsp;&nbsp;\${category_name} \${sortType === 'popular' ? '인기' : '최신'}글</h4><ul>`;
	    	  if (data.length === 0) {
	    	    blockHtml += `<li style="color:#bbb">글이 없습니다.</li>`;
	    	  }
	    	  data.forEach(post => {
	    	    blockHtml += `<li>
	    	      <a href="/postView.do?note_idx=\${post.note_idx}" title="\${post.title}">\${post.title}</a>
	    	      <span class="block-meta"><i class="fa-regular fa-eye"></i> \${post.view_count} &nbsp; <i class="fa-regular fa-thumbs-up"></i> \${post.like_count || 0}</span>
	    	    </li>`;
	    	  });
	    	  blockHtml += `</ul>`;
	    	}
	    	else if (options.action === 'WatchParties') {
	    	  blockHtml += `<h4><i class="fa-solid fa-tv" style="color:#6fdc88"></i>&nbsp;&nbsp;진행중인 워치파티</h4><ul>`;
	    	  if (data.length === 0) {
	    	    blockHtml += `<li style="color:#bbb">진행 중인 워치파티가 없습니다.</li>`;
	    	  }
	    	  data.forEach(party => {
	    	    blockHtml += `<li>
	    	      <span class="block-badge">\${party.host.nickname}</span>
	    	      <span>\${party.watchparty.title}</span>
	    	      <span class="block-meta">\${party.current_num}/\${party.max_num}명</span>
	    	    </li>`;
	    	  });
	    	  blockHtml += `</ul>`;
	    	}
	    	else if (options.action === 'UserStats') {
	    	  const chartId = `myStatsChart_\${timestamp}`;
	    	  blockHtml += `<h4><i class="fa-solid fa-chart-simple" style="color:#356dd5"></i>&nbsp;&nbsp;내 활동 통계</h4>`;
	    	  blockHtml += `<canvas id="\${chartId}" height="180"></canvas>`;
	    	}
	
	      blockHtml += '</div>';
	      $('#content_plus').before(blockHtml);
	
	      // Chart.js 렌더링 (활동 통계)
	      if (options.action === 'UserStats') {
	        const chartId = `myStatsChart_\${timestamp}`;
	        const ctx = document.getElementById(chartId).getContext('2d');
	        new Chart(ctx, {
	          type: 'bar',
	          data: {
	            labels: ['총 조회수', '총 좋아요'],
	            datasets: [{
	              label: '활동 통계',
	              data: [data.totalViews, data.totalLikes],
	              backgroundColor: ['rgba(54, 162, 235, 0.6)', 'rgba(255, 99, 132, 0.6)']
	            }]
	          },
	          options: {
	            responsive: true,
	            scales: {
	              y: { beginAtZero: true }
	            }
	          }
	        });
	      }
	    },
	    error: function(err) {
	      console.error("블록 추가 실패: ", err);
	    }
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