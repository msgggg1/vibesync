<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<% String contextPath = request.getContextPath() + "/vibesync"; %>
<%
Enumeration<String> names = request.getParameterNames();
while (names.hasMoreElements()) {
    String name = names.nextElement();
    String name_val = request.getParameter(name);
    System.out.println("name : " + name + "/ val : " + name_val);
}
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<jsp:include page="/vibesync/includes/header.jsp" />
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>user</title>
  <link rel="icon" href="./sources/favicon.ico" />
  <link rel="stylesheet" href="./css/style.css">
  <link rel="stylesheet" href="./css/sidebar.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script defer src="./js/script.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  <style>
    h3 {
      margin: 0;
    }
   .wp_btn {background: black;}
    #pageCreateBtn {
      position: fixed;
      bottom: 20px;
      right: 20px;
      width: 50px;
      height: 50px;
      border-radius: 50%;
      background: #8ac4ff;
      color: #fff;
      font-size: 24px;
      z-index: 1000;
      border: none;
      cursor: pointer;
    }

    .modal-overlay {
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0,0,0,0.5);
      display: none;
      justify-content: center;
      align-items: center;
      z-index: 2000;
    }
    
    #modalWrapper {
      width: 100%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    
    .modal-content {
      display: flex;
      flex-direction: column;
      justify-content: space-evenly;
      align-items: center;

      background: #fff;
      padding: 20px;
      border-radius: 8px;
      width: 90%; max-width: 400px;
      min-height: 14rem;
      position: relative;
    }

    #pageSelect {
      width: 100%;
      height: 2rem;
      text-align: center;
      border-radius: 10px;
      font-weight: bold;
      text-transform: uppercase;
    }

    #btn_wrapper {
      display: flex;
      gap: 2rem;
    }

    .btn_deco {
      background: #8ac4ff;
      border: none;
      color: white;
      padding: 4px 12px;
      border-radius: 6px;
    }

    .btn_deco:hover {
      background: #4da3f9;
    }

    #pageCreateForm {
      display: flex;
      flex-direction: column;
    }

    .modal-close {
      position: absolute;
      top: 10px; right: 10px;
      cursor: pointer;
      font-size: 18px;
      border: none;
      background: none;
    }
  </style>
  
  <style> /* Message */
  
   #up_msg_btn {
     background-color: #fe4f4f;
     color: #fff;
     border: none;
     padding: 11px 32px 11px 23px;
     font-weight: 700;
     font-size: 1.06rem;
     display: flex;
     align-items: center;
     gap: 13px;
     letter-spacing: 0.3px;
     cursor: pointer;
     outline: none;
     transition: background-color 0.18s ease-in-out, transform 0.12s;
   }
   
   #up_msg_btn i {
     font-size: 1.18em;
     color: #fff;
   }
   
   #up_msg_btn:hover {
     background: #fe1717;
     color: #fff;
   }
  
     /* 메시지 목록 뒷배경 */
   .modal-msglist {
     display: none;
     position: fixed;
     z-index: 999;
     left: 0; top: 0;
     width: 100vw; height: 100vh;
     background: rgba(0,0,0,0.6);
     backdrop-filter: blur(2.5px);
     justify-content: center;
     align-items: center;
   }
   
   /* 메시지 목록 본문 */
   .modal-msg {
     position: relative;
     background: #f5f8fb;
     border-radius: 20px;
     box-shadow: 0 4px 32px 0 rgba(80,110,150,0.10), 0 0 0 1.5px #c7d3e8;
     width: 92%; max-width: 415px; min-width: 330px;
     min-height: 390px; max-height: 78vh;
     display: flex; flex-direction: column;
     padding-bottom: 13px;
     border: none;
     animation: zoomIn 0.21s;  
   }
   
   @keyframes zoomIn {
     from { transform: scale(0.97); opacity: 0; }
     to { transform: scale(1); opacity: 1; }
   }
   
   /* 메시지 목록 모달창 제목 */
   #msgRoomTitle {
     font-size: 18px;
     font-weight: 700;
     color: var(--font-size);
     padding: 18px 0 12px 0;
     border-bottom: 2px solid var(--border-color);
     background: transparent;
     margin: 0 0 6px 0;
     text-align: center;
     letter-spacing: 0.02em;
   }
   
   #msgRoomTitle i {
     margin-right: 9px;
     color: var(--font-color);
     font-size: 20px;
   }
   
   /* 닫기 버튼 */
   .close-modal {
     position: absolute;
     top: 13px; right: 17px;
     color: #bcb8ad;
     font-size: 26px;
     font-weight: 400;
     cursor: pointer;
     background: none;
     border: none;
     border-radius: 50%;
     width: 32px; height: 32px;
     display: flex; align-items: center; justify-content: center;
     transition: background 0.13s, color 0.12s;
   }
   .close-modal:hover,
   .close-modal:focus {
     font-weight: bold;
     color: var(--font-color);
     text-decoration: none;
   }
   
   /* 메시지 목록이 표시될 영역 */
   #msgList {
     padding: 13px 25px 10px 25px;
     overflow-y: auto;
     flex-grow: 1;
     flex-direction: column;
     min-height: 150px;
     display: flex;
     align-items: stretch;
     justify-content: flex-start;
     background: transparent;
   }
   
   /* "메시지 내역이 없습니다" 문구 스타일 */
   .no-message-placeholder {
     display: flex;
     flex-direction: column;
     align-items: center;
     justify-content: center;
     color: #888;
     text-align: center;
     padding: 20px;
   }
   .no-message-placeholder i {
     font-size: 48px;
     margin-bottom: 16px;
     color: #e0e0e0;
   }
   .no-message-placeholder p {
     margin: 0;
     font-size: 1rem;
     font-weight: 500;
   }
   
   .msg_item {
     display: flex;
     align-items: flex-start;
     gap: 15px;
     width: 100%;
     background: var(--card-back);
     padding: 19px 18px 17px 15px;
     border-radius: 11px;
     animation: fadeInUp 0.26s;
     border: 2px solid var(--border-color);
     margin-bottom: 18px;
     transition: background-color 0.14s ease-in-out;  
   } 
   .msg_item:last-child {
     margin-bottom: 0;
   }
   
   .msg_item:hover {
     background-color: #a7ffa193;
     cursor: pointer;
   }
   
   @keyframes fadeInUp {
     from { opacity: 0; transform: translateY(20px);}
     to { opacity: 1; transform: translateY(0);}
   }
   
   .msg_profile img {
     width: 44px;
     height: 44px;
     object-fit: cover;
     border-radius: 50%;
     aspect-ratio: 1/1;
     margin-left: 8px;
     margin-right: 5px;
     border: 1.5px solid lightgrey;
     background: #faf9f6;
     display: block;
   }
     
   .msg_text_area {
     flex: 1 1 auto;
     min-width: 0;
     display: flex;
     flex-direction: column;
     align-items: flex-start;
   }
   
   .msg_sender_row {
     display: flex;
     align-items: center;
     gap: 7px;
     margin-bottom: 1px;
   }
   .msg_sender {
     font-weight: 700;
     font-size: 17px;
     color: #2d3440;
     margin-bottom: 1px;
   }
   .msg_preview {
     font-size: 14px;
     font-weight: 450;
     color: black; /* #223355; */
     margin: 2px 0 0 0;
     word-break: break-all;
     opacity: 0.93;
     text-overflow: ellipsis;
   }
   .msg_time {
     font-size: 12px;
     color: #7890a2;
     margin-top: 5px;
     white-space: nowrap;
   }
     
   /* 읽지 않은 뱃지 */
   .unread-badge {
     display: flex;
     align-items: center; justify-content: center;
     min-width: 20px; height: 20px;
     padding: 0 5px;
     background: #45607d;
     color: #fff;
     font-size: 12px;
     font-weight: 700;
     border-radius: 50%;
     box-shadow: 0 1px 3px rgba(175,175,160,0.10);
     margin-left: 5px;
     user-select: none;
   }
  
  </style>
  
  <style> /* Chat */
    .chat-modal-super-container {
        display: none;
        justify-content: center;
        align-items: center;
        position: fixed;
        z-index: 9999;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background: rgba(0,0,0,0.6);
        backdrop-filter: blur(4px);
    }
    
    .chat-modal-content {
        position: relative;
        max-width: 430px;
        min-width: 350px;
        width: 90%;
        background-color: #f5f8fb;
        padding: 0;
        border-radius: 16px;
        color: #223355;
        box-shadow: 0 6px 30px rgba(0, 0, 0, 0.3);
        animation: fadeInUp 0.3s ease-out;
        display: flex;
        flex-direction: column;
        max-height: 85vh;
    }

    #chatTitle {
        padding: 18px 24px 16px 24px;
        margin: 0;
        text-align: center;
        border-bottom: 1.5px solid #e3ecf6;
        flex-shrink: 0;
        font-size: 17px;
        font-weight: 700;
    }
    
    #chatHistory {
        padding: 10px;
        overflow-y: auto;
        flex-grow: 1;
    }
    .chat-container {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }
    .chat-bubble {
        max-width: 70%;
        padding: 10px 14px;
        border-radius: 18px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        text-align: left;
        word-break: keep-all;
        overflow-wrap: break-word;
        white-space: normal;
    }
    .bubble-me {
        align-self: flex-end;
        background-color: #FFFBE7;
        border: 1px solid #FFEAC4;
        border-bottom-right-radius: 4px;
    }
    .bubble-other {
        align-self: flex-start;
        background-color: #fff;
        border: 1px solid #eef1f5;
        border-bottom-left-radius: 4px;
    }
    .bubble-text {
        font-size: 14px;
        color: #000;
        margin: 0 0 4px 0;
        padding: 0;
    }
    .bubble-time {
        font-size: 11px;
        color: #999;
        text-align: right;
    }
    .chat-input-row {
      display: flex;
      align-items: center;
      gap: 8px;
      margin: 12px;
      background: #fff;
      border-radius: 12px;
      border: 1.5px solid #e2e5ea;
      padding: 7px 12px;
      box-shadow: 0 1px 4px rgba(80,110,140,0.08);
      flex-shrink: 0;
    }
    #chatInput {
      flex: 1;
      border: none;
      font-size: 15px;
      color: #23272f;
      outline: none;
      padding: 8px 0;
      height: 38px;
      background: none;
    }
    #chatInput::placeholder {
      color: #b7b8bd;
      font-size: 14px;
    }
    #sendMessageBtn {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 38px;
      height: 38px;
      background: #7fa6c9;
      border: none;
      border-radius: 50%;
      transition: background 0.16s;
      cursor: pointer;
      padding: 0;
    }
    #sendMessageBtn:hover {
      background: #45607d;
    }
    .chat-date-separator {
      display: inline-block;
      padding: 4px 12px;
      margin: 16px auto;
      font-size: 12px;
      color: #666;
      background: #e9ecef;
      border-radius: 12px;
      text-align: center;
    }
  </style>
  
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="user">
    <input type="hidden" id="profileUserAcIdx" value="${userPageData.userProfile.ac_idx}">
    <input type="hidden" id="profileUserNickname" value="${userPageData.userProfile.nickname}">
    <%-- 무한스크롤용 --%>
    <input type="hidden" id="currentPageNumber" value="${userPageData.nextPageNumber - 1}">
    <%-- 현재 로드된 페이지 번호 --%>
    <input type="hidden" id="hasMorePosts" value="${userPageData.hasMorePosts ? 'true' : 'false'}">

    <div class="notion-app-inner">
      <jsp:include page="./includes/sidebar.jsp" flush="true"></jsp:include>

      <div id="content_wrapper">
        <section id="content">
          <div id="user_wrapper">
            <div id="userInfo">
              <div class="user_profile_img">
                <c:choose>
                  <c:when test="${not empty userPageData.userProfile.img}">
                    <img src="<%=contextPath %>/${userPageData.userProfile.img}" alt="프로필">
                  </c:when>
                  <c:otherwise>
                    <img src="<%=contextPath %>/sources/default/default_user.jpg" alt="기본 프로필">
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="userInfo_detail">
                <div class="name_function">
                  <p>${userPageData.userProfile.nickname}</p>
                  <%-- 팔로우 버튼: 현재 로그인한 사용자가 프로필 사용자가 아닌 경우에만 표시 --%>
                  <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx != userPageData.userProfile.ac_idx}">
                    <button type="button" id="profileFollowBtn"
                            class="btn_follow_1"
                            data-author-id="${userPageData.userProfile.ac_idx}"
                            data-following="${userPageData.userProfile.followedByCurrentUser ? 'true' : 'false'}">
                      ${userPageData.userProfile.followedByCurrentUser ? 'UNFOLLOW' : 'FOLLOW'}
                    </button>
                  </c:if>
                  <!-- Message 버튼 -->
                  <button id="up_msg_btn"><i class="fa-solid fa-paper-plane"></i> Message</button>
                  <%-- Watch Party 버튼 (기능 구현 시 활성화) --%>
                  <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx}">
                     <button class="wp_btn" onclick="location.href='waList.jsp'">Watch Party</button>
                  </c:if>
                </div>
                <div class="user_count">
                  <p>POST <span>${userPageData.userProfile.postCount}</span></p>
                  <p>FOLLOWER <span id="profileFollowerCount">${userPageData.userProfile.followerCount}</span></p>
                  <p>FOLLOW <span>${userPageData.userProfile.followingCount}</span></p>
                </div>
              </div>
            </div>

            <div class="line"></div>

            <div id="con_wrapper">
              <c:forEach var="post" items="${userPageData.posts}">
                  <a href="<%=contextPath %>/postView.do?nidx=${post.note_idx}">
                   <div class="con_item">
                    <c:choose>
                      <c:when test="${not empty post.thumbnail_img}">
                        <img src="${pageContext.request.contextPath}/${post.thumbnail_img}" alt="${post.title} 썸네일" >
                      </c:when>
                      <c:otherwise>
                        <img src="${pageContext.request.contextPath}/sources/images/default_thumbnail.png" alt="기본 썸네일">
                      </c:otherwise>
                    </c:choose>             
                   </div>
                  </a>
              </c:forEach>
            </div>
            <div id="loadingIndicator" style="display: none; text-align: center; padding: 20px;">로딩 중...</div>
          </div>
        </section>
      </div>
    </div>
  </div>
  
  <!-- 페이지 생성 모달 트리거 버튼 -->
  <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx}">
     <button id="pageCreateBtn">＋</button>
  </c:if>

  <!-- 모달 오버레이 및 컨텐츠 -->
  <div id="pageModalOverlay" class="modal-overlay">
    <div id="modalWrapper">
       <div class="modal-content" id="pageModalContent">
       <button class="modal-close" id="pageModalClose">&times;</button>
       <!-- AJAX로 로드된 <select> + 버튼들 삽입 -->
    </div>
    </div>
  </div>
  
  <!-- 메시지 목록 모달창 -->
  <div id="msgListModal" class="modal-msglist">
    <div class="modal-msg" style="min-width:350px; max-width:430px;">
      <span class="close-modal" onclick="closeMsgListModal()"> &times; </span>
      <h3 id="msgRoomTitle"></h3>
      <div id="msgList"></div>
    </div>
  </div>
  
  <!-- 채팅방 모달창 -->
  <div id="chatModal" class="chat-modal-super-container">
     <div class="chat-modal-content">
       <span class="close-modal" onclick="closeChatModal()"> &times; </span>
       <h4 id="chatTitle"></h4>
       <div id="chatHistory"></div>
       <div class="chat-input-row">
         <input type="text" id="chatInput" placeholder="메시지를 입력하세요..." autocomplete="off" />
         <button type="button" id="sendMessageBtn" title="전송">
             <i class="fa-solid fa-paper-plane" style="color:white; font-size: 16px;"></i>
         </button>
       </div>
     </div>
  </div>

  <script>
    // 채팅 기능에 사용할 전역변수 (상대방 ac_idx)
    let currentChatSenderIdx = 0;
    
    /*무한스크롤 함수*/
    
    var isLoading = false; // 중복 요청 방지 플래그
    function loadMorePosts(){
       // 중복 로딩 방지 및 더 이상 게시물이 없는 경우 실행 중단
       var hasMore = ($('#hasMorePosts').val() === 'true');
        if (!hasMore || isLoading) return;
    
    isLoading = true;
    $('#loadingIndicator').show();
    var nextPage = parseInt($('#currentPageNumber').val()) + 1;
    var profileUserId = $('#profileUserAcIdx').val();
    
    $.ajax({
          url: '${pageContext.request.contextPath}/loadMorePosts.do', 
          type: 'GET', 
          data: {
            userId: profileUserId,
            page: nextPage
          },
          dataType: 'json',
          success: function(response) {
            if (response.posts && response.posts.length > 0) {
                  var postsHtml = '';
                var contextPath = '${pageContext.request.contextPath}';
                
                $.each(response.posts, function(index, post) {
                    var thumbnailUrl = post.thumbnail_img 
                                     ? contextPath + post.thumbnail_img 
                                     : contextPath + 'vibesync/sources/default/default_thumbnail.png';
                    
                    // JSP와 동일한 구조로 만들고, 불필요한 <p> 태그와 인라인 스타일을 제거합니다.
                    postsHtml += '<a href="' + contextPath + '/vibesync/postView.do?nidx=' + post.note_idx + '">';
                    postsHtml += '    <div class="con_item">';
                    postsHtml += '        <img src="' + thumbnailUrl + '" alt="' + post.title + ' 썸네일">';
                    postsHtml += '    </div>';
                    postsHtml += '</a>';
                });
                $('#con_wrapper').append(postsHtml);
                $('#currentPageNumber').val(nextPage); // 현재 페이지 번호 업데이트
            }
            
            if (!response.hasMore) {
              $('#hasMorePosts').val('false');
              $('#loadingIndicator').text('더 이상 게시물이 없습니다.');
            } else {
              $('#loadingIndicator').hide();
              setTimeout(function() {
                  checkAndLoadIfNeeded();
              }, 100);
            }
            isLoading = false;
          },
          error: function() {
            alert('게시물을 추가로 불러오는 중 오류가 발생했습니다.');
            $('#loadingIndicator').hide();
            isLoading = false;
          }
        });
      }
    
   function checkAndLoadIfNeeded() {
        // 문서 전체 높이가 브라우저 창 높이보다 작거나 같고 (스크롤바가 없고),
        // 더 불러올 게시물이 있다면
        if ($(document).height() <= $(window).height() && ($('#hasMorePosts').val() === 'true')) {
            console.log("콘텐츠가 부족하여 새 게시물을 자동으로 로드합니다.");
            loadMorePosts();
        }
    }
  
    $(document).ready(function() {
      // 프로필 페이지의 팔로우 버튼 처리
      $('#profileFollowBtn').on('click', function() {
        var $button = $(this);
        var authorId = $button.data('author-id');
        var isLoggedIn = ${sessionScope.userInfo != null}; 

        if (!isLoggedIn) {
          alert("로그인이 필요합니다.");
          location.href = "${pageContext.request.contextPath}/login.jsp"; 
          return;
        }

        $.ajax({
          url: '${pageContext.request.contextPath}/followToggle.do', 
          type: 'POST',
          data: { authorId: authorId },
          dataType: 'json',
          success: function(response) {
            if (response.success) {
              if (response.following) {
                $button.data('following', true).text('UNFOLLOW');
              } else {
                $button.data('following', false).text('FOLLOW');
              }
              // 팔로워 수 업데이트
              if (typeof response.newFollowerCount !== 'undefined') {
                $('#profileFollowerCount').text(response.newFollowerCount);
              }
            } else {
              alert('오류: ' + (response.message || '팔로우 처리에 실패했습니다.'));
            }
          },
          error: function() {
            alert('팔로우 요청 중 오류가 발생했습니다.');
          }
        });
      });

      // 무한 스크롤 로직
     var isLoading = false; 
     $(window).scroll(function() {
         if ($(window).scrollTop() + $(window).height() >= $(document).height() - 200) {
             loadMorePosts();
         }
     });
     
     $(window).on('resize', function() {
         checkAndLoadIfNeeded();
     });
      
      // 모달 열기: 페이지 목록 로드
      $('#pageCreateBtn').on('click', function() {
        var acIdx = $('#profileUserAcIdx').val();
        $.get('${pageContext.request.contextPath}/page/modalList.do', { ac_idx: acIdx }, function(html) {
          $('#pageModalContent').children(':not(.modal-close)').remove();
          $('#pageModalContent').append(html);
          $('#pageModalOverlay').fadeIn();
        });
      });

      // 모달 닫기
      $('#pageModalOverlay').on('click', '#pageModalClose, .modal-overlay', function(e) {
        e.stopPropagation();
        $('#pageModalOverlay').fadeOut(function() {
          $('#pageModalContent').children(':not(.modal-close)').remove();
        });
      });

      // '＋ 새 페이지' 클릭 시 JS로 폼 전환 (페이지 생성 폼)
      $('#pageModalOverlay').on('click', '#newPageBtn', function() {
        $('#pageModalContent').children(':not(.modal-close)').remove();
        var formHtml = ''
          + '<h3>새 페이지 생성</h3>'
          + '<form id="pageCreateForm" enctype="multipart/form-data">'
          + '  <label>Subject&nbsp<input type="text" id="subject" name="subject" required/></label><br/>'
          + '  <button type="submit" class="btn_deco">Create</button>'
          + '</form>';
        $('#pageModalContent').append(formHtml);
      });
      
      $('#pageModalOverlay').on('click', '#newNoteBtn', function() {
         // select 박스에서 현재 선택된 페이지 idx
         var selectedIdx = $('#pageSelect').val();
         // 새 글쓰기 링크 href 업데이트
         $('#newNoteLink').attr('href', 'notecreate.do?pageidx=' + selectedIdx);
         // 실제 이동
         window.location.href = $('#newNoteLink').attr('href');
       });

      // 폼 제출 시 pageCreateHandler 호출
      $('#pageModalOverlay').on('submit', '#pageCreateForm', function(e) {
        e.preventDefault();
        var formData = new FormData(this);
        let subject = document.getElementById("subject").value;
        $.ajax({
          url: '${pageContext.request.contextPath}/page/create.do?subject=' + subject,
          type: 'GET',
          data: formData,
          processData: false,
          contentType: false,
          dataType: 'json',
          success: function(res) {
            if (res.success) {
              $('#pageModalOverlay').fadeOut();
            } else {
              alert('페이지 생성 실패: ' + (res.message || ''));
            }
          },
          error: function() {
            alert('페이지 생성 중 오류가 발생했습니다.');
          }
        });
      });
      
      // 내 메시지 목록을 볼건지, 메시지 창을 열건지 선택
      const isOwnProfile = ${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx};
      
      // 메시지 목록 모달창 열기
     $('#up_msg_btn').on('click', function () {
        const isLoggedIn = ${sessionScope.userInfo != null};
          if (!isLoggedIn) {
              alert("로그인이 필요합니다.");
              location.href = "${pageContext.request.contextPath}/vibesync/user.do";
              return;
          }

          if (isOwnProfile) {
              // 내 프로필: 메시지 목록 모달 열기
              openMessageModal();
          } else {
              // 다른 유저 프로필: 1:1 채팅 모달 열기
              const profileUserId = $('#profileUserAcIdx').val();
              const profileUserNickname = $('#profileUserNickname').val();
              openChatWithUser(profileUserId, profileUserNickname);
          }
     });
      
     // 메시지 목록의 아이템 클릭 시 채팅방 열기 (이벤트 위임)
      $('#msgList').on('click', '.msg_item', function() {
          const senderIdx = $(this).data('sender-idx');
          const nickname = $(this).data('nickname');
          openChatWithUser(senderIdx, nickname);
      });
     
      // 채팅 메시지 전송 (버튼 클릭)
      $("#sendMessageBtn").on("click", sendChatMessage);
   
      // 채팅 메시지 전송 (엔터 키)
     $("#chatInput").on("keydown", function(e) {
         if (e.key === "Enter" && !e.shiftKey) {
           e.preventDefault();
           sendChatMessage();
         }
     });
     
     checkAndLoadIfNeeded();
    }); // DOM
    
    // 메시지 모달창 새로고침
    $(window).on('load', function() {
       if (window.location.hash === "#msg") {
            openMessageModal();
        }
    });
    
  </script>
  
  <script> /* 함수 */
  
  // 메시지 모달창 열기 함수 : 내 프로필에서만 사용
  function openMessageModal() {
      window.location.hash = "msg";

      const acIdx = ${sessionScope.userInfo.ac_idx};
      const basePath = '${pageContext.request.contextPath}/vibesync/sources/';

      $.ajax({
          url: '${pageContext.request.contextPath}/message.do',
          type: 'GET',
          data: {
              view: 'LISTALL'
          },
          dataType: 'json',
          success: function(msgList) {
              $('#msgListModal').css('display', 'flex');
              $('#msgRoomTitle').html('<i class="fa-solid fa-comment-dots"></i> 메시지 목록');
              $('#msgList').empty();

              if (!msgList || !Array.isArray(msgList) || msgList.length === 0) {
                  const placeholderHtml = `
                      <div class="no-message-placeholder">
                          <i class="fa-regular fa-comments"></i>
                          <p>메시지 내역이 없습니다.</p>
                      </div>
                  `;
                  $('#msgList').html(placeholderHtml);
                  return;
              }

              const msgContainer = $('<div class="msg-container"></div>');
              msgList.forEach(msg => {
                  let profileImgHtml = msg.other.profile_img ?
                      `<img src="\${basePath}profile/\${msg.other.profile_img}" alt="profile">` :
                      `<img src="\${basePath}default/default_user.jpg" alt="기본 프로필">`;

                  let unreadBadgeHtml = '';
                  if (msg.numOfUnreadMessages > 0) {
                      unreadBadgeHtml = `<span class="unread-badge">\${msg.numOfUnreadMessages}</span>`;
                  }
                      
                  const messageHtml = `
                      <div class="msg_item" data-sender-idx="\${msg.other.ac_idx}" data-nickname="\${msg.other.nickname}">
                          <div class="msg_profile">
                              \${profileImgHtml}
                          </div>
                          <div class="msg_text_area">
                              <div class="msg_sender_row">
                                  <div class="msg_sender">\${msg.other.nickname}</div>
                                  \${unreadBadgeHtml}
                              </div>
                              <div class="msg_preview">\${msg.latestMessage.text}</div>
                              <div class="msg_time">\${msg.latestMessage.relativeTime}</div>
                          </div>
                      </div>
                  `;
                  msgContainer.append(messageHtml);
              });
              $('#msgList').append(msgContainer);
          },
          error: function() {
              alert('메시지 내역 불러오기 실패');
          }
      });
  }

  // 메시지 목록 모달창 닫기 함수
  function closeMsgListModal() {
      window.location.hash = "";
      $('#msgListModal').hide();
  }
  
  // 특정 유저와의 채팅창 열기 함수
  function openChatWithUser(userIdx, nickname) {
      currentChatSenderIdx = userIdx;
      $('#chatTitle').text(nickname + '님과의 대화');
      $('#chatHistory').html('<p style="text-align:center; padding: 20px;">대화 내역을 불러오는 중...</p>'); // 로딩 표시
      
      closeMsgListModal(); // 메시지 목록이 열려있었다면 닫기

      $.ajax({
          url: '${pageContext.request.contextPath}/message.do',
          type: 'GET',
          data: { sender_idx: userIdx, view: 'CHAT' },
          dataType: 'json',
          success: function (chatList) {
              $('#chatHistory').empty();
              
              if (!chatList || !Array.isArray(chatList) || chatList.length === 0) {
                  $('#chatHistory').html('<p style="text-align:center; color:grey; padding: 20px;">아직 대화 내역이 없습니다.</p>');
              } else {
                  const chatContainer = $('<div class="chat-container"></div>');
                  let lastDate = null;
                  chatList.forEach(msg => {
                      if (msg.date !== lastDate) {
                          lastDate = msg.date;
                          const dateLabel = $('<div class="chat-date-separator"></div>').text(lastDate);
                          chatContainer.append(dateLabel);
                      }
                      const who = msg.isMine ? 'bubble-me' : 'bubble-other';
                      const formattedText = msg.text.replace(/\n/g, '<br>');
                      const messageHtml = `
                          <div class="chat-bubble \${who}">
                              <div class="bubble-text">\${formattedText}</div>
                              <div class="bubble-time">\${msg.relativeTime}</div>
                          </div>`;
                      chatContainer.append(messageHtml);
                  });
                  $('#chatHistory').append(chatContainer);
              }

              $('#chatModal').css('display', 'flex');
              $('#chatHistory').scrollTop($('#chatHistory')[0].scrollHeight); // 스크롤 맨 아래로
          },
          error: function () {
              alert('채팅 내역을 불러오는 데 실패했습니다.');
          }
      });
  }
  
  // 채팅 모달 닫기
  function closeChatModal() {
      $('#chatModal').hide();
      currentChatSenderIdx = null; // 현재 채팅 상대 초기화
      // 만약 내 프로필에서 채팅했다면, 메시지 목록을 다시 열어서 unread 카운트를 갱신
      if (${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx}) {
          openMessageModal();
      }
  }
  
  // 채팅 메시지 전송
  function sendChatMessage() {
      const message = $("#chatInput").val().trim();
      if (!message || !currentChatSenderIdx) return;

      $.ajax({
          url: '${pageContext.request.contextPath}/message.do',
          type: 'POST',
          data: JSON.stringify({
             receiver_idx: currentChatSenderIdx,
              text: message
          }),
          contentType: "application/json; charset=utf-8",
          dataType: 'json',
          success: function(res) {
              if(res.success) {
                  $("#chatInput").val(""); // 입력창 비우기
                  reloadChatHistory(); // 채팅 내역 갱신
              } else {
                  alert('메시지 전송에 실패했습니다.');
              }
          },
          error: function() { alert('메시지 전송 중 오류 발생!'); }
      });
  }
  
  // 채팅 내역 새로고침
  function reloadChatHistory() {
     if (currentChatSenderIdx) {
         const currentNickname = $('#chatTitle').text().replace('님과의 대화', '');
         openChatWithUser(currentChatSenderIdx, currentNickname);
      }
  }
  
  </script>
  
</body>
<jsp:include page="/vibesync/includes/footer.jsp" />
</html>