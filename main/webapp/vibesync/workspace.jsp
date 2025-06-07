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
  
	<style>
	
	html, body {
	  height: 100%;
	  margin: 0;
	  padding: 0;
	  overflow-x: hidden;
	}
	
	.modal {
	  display: none;
	  justify-content: center;
	  align-items: center;
	  position: fixed;
	  z-index: 9999;
	  top: 0;
	  left: 0;
	  width: 100vw;
	  height: 100vh;
	  /* background-color: rgba(0,0,0,0.6); */
	  backdrop-filter: blur(4px);
	}
	
	.modal-content {
	  position: relative;
	  max-width: 420px;
	  width: 90%;
	  background-color: var(--background-color);
	  padding: 30px;
	  border-radius: 16px;
	  color: var(--font-color);
	  text-align: center;
	  box-shadow: 0 6px 30px rgba(0, 0, 0, 0.3);
	  animation: fadeInUp 0.3s ease-out;
	}
	
	#categorySelector {
	  display: flex;
	  flex-direction: column;
	  gap: 10px;
	}
	
	.modal-content select,
	.modal-content button {
	  width: 100%;
	  padding: 12px;
	  font-size: 1rem;
	  border: 2px solid var(--border-color);
	  border-radius: 8px;
	  background-color: var(--sidebar-color);
	  color: var(--font-color);
	  margin-bottom: 10px;
	}
	
	.modal-content button {
	  background-color: #5DAED7;
	  color: white;
	  font-weight: bold;
	  cursor: pointer;
	  transition: background-color 0.3s;
	}
	
	.modal-content button:hover {
	  background-color: #4297bf;
	}
	
	@keyframes fadeInUp {
	  from {
	    transform: translateY(30px);
	    opacity: 0;
	  }
	  to {
	    transform: translateY(0);
	    opacity: 1;
	  }
	}

	</style>
  
</head>
<body>

	<!-- 모달 -->
	<!-- 메시지 모달 -->
	<div id="chatModal" class="modal">
		<div class="modal-content">
			<span class="close-modal" onclick="closeChatModal()">&times;</span>
			<h4 id="chatTitle">채팅</h4>
			<div id="chatHistory"></div>
		</div>
	</div>
	
	<!-- 블록 추가 모달 -->
	<div id="addBlockModal" class="modal">
		<div class="modal-content">
			<h4>추가할 블록 선택</h4>
			<select id="blockTypeSelector">
				<option value="getCategoryPosts">카테고리별 글</option>
				<option value="getWatchParties">구독 워치파티</option>
				<option value="getUserStats">내 활동 통계</option>
			</select>
	
			<div id="categorySelector" style="display: none;">
				<select id="category" name="category">
					<c:forEach items="${ categoryVOList }" var="categoryVO">
						<option value="${ categoryVO.category_idx }">${ categoryVO.c_name }</option>
					</c:forEach>
				</select> <select id="sortTypeSelector">
					<option value="popular">인기순</option>
					<option value="latest">최신순</option>
				</select>
			</div>
			<button id="confirmAddBlock" style="display: block;">추가</button>
		</div>
	</div>
	<!-- 모달 끝 -->

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
			  <div id="unread_messages">
			  	<h3><i class="fa-solid fa-bell"></i> 안읽은 메시지</h3>
			  	<ul class="message_list">
			  		<c:choose>
			  			<c:when test="${not empty initialData.unreadMessages}">
			  				<c:forEach var="msg" items="${initialData.unreadMessages}">
			  					<li class="message_item" data-sender-idx="${msg.ac_sender}">
			  						<div class="msg_info">
			  							<span class="sender_name">${msg.sender_nickname}</span>
				                        <p class="msg_preview">${msg.text}</p>
				                    </div>
				                </li>
				            </c:forEach>
				        </c:when>
				        <c:otherwise>
				        	<li class="no_message">새로운 메시지가 없습니다.</li>
				        </c:otherwise>
				    </c:choose>
				</ul>
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

  <script>
  
  $(document).ready(function() {
	    // 안읽은 메시지 클릭 -> 채팅 모달 열기
	    $('.message_item').on('click', function() {
	        const senderIdx = $(this).data('sender-idx');
	        // AJAX로 채팅 내역 불러오고 모달 띄우는 함수 호출
	        openChatModalWithHistory(senderIdx); 
	    });

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
	    	if ($(this).val() === 'getCategoryPosts') {
	            $('#categorySelector').show();
	        } else {
	            $('#categorySelector').hide();
	        }
	        
	    });
	    $("#blockTypeSelector").change();

	    // 모달에서 '추가' 버튼 클릭
	    $('#confirmAddBlock').on('click', function() {
	        const blockType = $('#blockTypeSelector').val();
	        let options = { action: blockType };

	        if (blockType === 'getCategoryPosts') {
	            options.categoryIdx = $('#categorySelector').val();
	            options.sortType = $('#sortTypeSelector').val();
	        }
	        
	        // 블록 개수 5개 제한
	        if ($('#contents_grid .generated_block').length >= 5) {
	             alert('블록은 최대 5개까지 추가할 수 있습니다.');
	             return;
	        }

	        addBlockToServer(options);
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

	// 서버에 블록 데이터 요청 및 화면에 추가하는 함수
	function addBlockToServer(options) {
	  $.ajax({
	    url: 'workspace.do',
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
	
	      if (options.action === 'getCategoryPosts') {
	        blockHtml += `<h4>카테고리 글</h4><ul>`;
	        data.forEach(post => {
	          blockHtml += `<li><a href="/postView.do?note_idx=${post.note_idx}">${post.title}</a></li>`;
	        });
	        blockHtml += `</ul>`;
	
	      } else if (options.action === 'getWatchParties') {
	        blockHtml += `<h4>구독 워치파티</h4><ul>`;
	        data.forEach(party => {
	          blockHtml += `<li>${party.host_nickname}님의 "${party.title}"</li>`;
	        });
	        blockHtml += `</ul>`;
	
	      } else if (options.action === 'getUserStats') {
	        const chartId = `myStatsChart_${timestamp}`;
	        blockHtml += `<h4>내 활동 통계</h4><canvas id="${chartId}"></canvas>`;
	      }
	
	      blockHtml += '</div>';
	      $('#content_plus').before(blockHtml);
	
	      // Chart.js 렌더링 (활동 통계)
	      if (options.action === 'getUserStats') {
	        const chartId = `myStatsChart_${timestamp}`;
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

	
	// 모달창에서 채팅 내역 보는 함수
	function openChatModalWithHistory(senderIdx) {
		  $.ajax({
		    url: 'workspace.do?action=getChatHistory',
		    type: 'GET',
		    data: { sender_idx: senderIdx },
		    dataType: 'json',
		    success: function(chatList) {
		      let html = '<ul>';
		      chatList.forEach(msg => {
		        html += `<li><strong>${msg.sender_nickname}</strong>: ${msg.text}</li>`;
		      });
		      html += '</ul>';
		      $('#chatHistory').html(html);
		      $('#chatModal').show();
		    },
		    error: function(err) {
		      console.error("채팅 불러오기 실패:", err);
		    }
		  });
		}

		function closeChatModal() {
		  $('#chatModal').hide();
		}
  
  </script>

</html>