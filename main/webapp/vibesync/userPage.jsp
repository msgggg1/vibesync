<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<% String contextPath = request.getContextPath() + "/vibesync"; %>
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
        h3 { margin: 0; }
        #left-wrapper {display: flex; height: 100%; gap: 20px; justify-content: center; align-items: center;}
      .wp_btn {background: linear-gradient(90deg, rgba(138, 196, 255, 1) 0%, rgba(227, 176, 255, 1) 50%, rgba(165, 250, 120, 1) 100%);}
        .wp_btn img{width: 24px; height: 25px; margin-right: 6px;}
        #settingBtn { background: #6c757d; color: white; border: none; font-weight: 700; cursor: pointer; transition: background-color 0.18s; }
        #settingBtn img {width: 26px; height: 26px;}
        #settingBtn:hover { background: #5a6268; }
        .name_function button { border-radius: 5px; }
        #pageCreateBtn { position: fixed; bottom: 20px; right: 20px; width: 50px; height: 50px; border-radius: 50%; background: #8ac4ff; color: #fff; font-size: 24px; z-index: 1000; border: none; cursor: pointer; }
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: none; justify-content: center; align-items: center; z-index: 2000; }
        #modalWrapper { width: 100%; height: 100%; display: flex; justify-content: center; align-items: center; }
        .modal-content { display: flex; flex-direction: column; justify-content: space-evenly; align-items: center; background: var(--background-color); padding: 20px; border-radius: 8px; width: 90%; max-width: 400px; min-height: 14rem; position: relative; }
        #pageSelect { width: 100%; height: 2rem; text-align: center; border-radius: 10px; font-weight: bold; text-transform: uppercase; }
        #btn_wrapper { display: flex; gap: 2rem; }
        .btn_deco { background: #8ac4ff; border: none; color: white; padding: 4px 12px; border-radius: 6px; }
        .btn_deco:hover { background: #4da3f9; }
        #pageCreateForm { display: flex; flex-direction: column; }
        .modal-close { position: absolute; top: 10px; right: 10px; cursor: pointer; font-size: 18px; border: none; background: none; color: var(--font-color); }
    </style>
    
    <style> /* Message */
        #up_msg_btn { background-color: #fe4f4f; color: #fff; border: none; padding: 11px 32px 11px 23px; font-weight: 700; font-size: 1.06rem; display: flex; align-items: center; gap: 13px; letter-spacing: 0.3px; cursor: pointer; outline: none; transition: background-color 0.18s ease-in-out, transform 0.12s; }
        #up_msg_btn i { filter: invert(0) !important; font-size: 1.18em; color: #fff; }
        #up_msg_btn:hover { background: #fe1717; color: #fff; }
        .modal-msglist { display: none; position: fixed; z-index: 999; left: 0; top: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.6); backdrop-filter: blur(2.5px); justify-content: center; align-items: center; }
        .modal-msg { position: relative; background: var(--background-color); border-radius: 20px; width: 92%; max-width: 415px; min-width: 330px; min-height: 390px; max-height: 78vh; display: flex; flex-direction: column; padding-bottom: 13px; border: none; animation: zoomIn 0.21s;  }
        @keyframes zoomIn { from { transform: scale(0.97); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        #msgRoomTitle { font-size: 18px; font-weight: 700; color: var(--font-size); padding: 18px 0 12px 0; border-bottom: 2px solid var(--border-color); background: transparent; margin: 0 0 6px 0; text-align: center; letter-spacing: 0.02em; }
        #msgRoomTitle i { margin-right: 9px; color: var(--font-color); font-size: 20px; }
        .close-modal { position: absolute; top: 13px; right: 17px; color: #bcb8ad; font-size: 26px; font-weight: 400; cursor: pointer; background: none; border: none; border-radius: 50%; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; transition: background 0.13s, color 0.12s; }
        .close-modal:hover, .close-modal:focus { font-weight: bold; color: var(--font-color); text-decoration: none; }
        #msgList { padding: 13px 25px 10px 25px; overflow-y: auto; flex-grow: 1; flex-direction: column; min-height: 150px; display: flex; align-items: stretch; justify-content: flex-start; background: transparent; }
        .no-message-placeholder { display: flex; flex-direction: column; align-items: center; justify-content: center; color: #888; text-align: center; padding: 20px; }
        .no-message-placeholder i { font-size: 48px; margin-bottom: 16px; color: #e0e0e0; }
        .no-message-placeholder p { margin: 0; font-size: 1rem; font-weight: 500; }
        .msg_item { display: flex; align-items: flex-start; gap: 15px; width: 100%; background: var(--card-back); padding: 19px 18px 17px 15px; border-radius: 11px; animation: fadeInUp 0.26s; border: 2px solid var(--border-color); margin-bottom: 18px; transition: background-color 0.14s ease-in-out;  } 
        .msg_item:last-child { margin-bottom: 0; }
        .msg_item:hover { background-color: var(--hover-color); cursor: pointer; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px);} to { opacity: 1; transform: translateY(0);} }
        .msg_profile img { width: 44px; height: 44px; object-fit: cover; border-radius: 50%; aspect-ratio: 1/1; margin-left: 8px; margin-right: 5px; border: 1.5px solid lightgrey; background: #faf9f6; display: block; background-image:linear-gradient(var(--card-back), var(--card-back)), linear-gradient(90deg, rgba(138, 196, 255, 1) 0%, rgba(227, 176, 255, 1) 50%, rgba(165, 250, 120, 1) 100%); background-origin: border-box; background-clip: content-box, border-box; border: solid 2px transparent; }
        .msg_text_area { flex: 1 1 auto; min-width: 0; display: flex; flex-direction: column; align-items: flex-start; }
        .msg_sender_row { display: flex; align-items: center; gap: 7px; margin-bottom: 1px; }
        .msg_sender { font-weight: 700; font-size: 17px; color: var(--font-color); margin-bottom: 1px; }
        .msg_preview { font-size: 14px; font-weight: 450; color: var(--msg-sub-font); margin: 2px 0 0 0; word-break: break-all; opacity: 0.93; text-overflow: ellipsis; }
        .msg_time { font-size: 12px; color: var(--msg-date-font); margin-top: 5px; white-space: nowrap; }
        .unread-badge { display: flex; align-items: center; justify-content: center; min-width: 20px; height: 20px; padding: 0 5px; background: #45607d; color: #fff; font-size: 12px; font-weight: 700; border-radius: 50%; box-shadow: 0 1px 3px rgba(175,175,160,0.10); margin-left: 5px; user-select: none; }
    </style>
    
    <style> /* Chat */
        .chat-modal-super-container { display: none; justify-content: center; align-items: center; position: fixed; z-index: 9999; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.6); backdrop-filter: blur(4px); }
        .chat-modal-content { position: relative; max-width: 430px; min-width: 350px; width: 90%; background-color: var(--background-color); padding: 0; border-radius: 16px; color: var(--font-color); box-shadow: 0 6px 30px rgba(0, 0, 0, 0.3); animation: fadeInUp 0.3s ease-out; display: flex; flex-direction: column; max-height: 85vh; }
        #chatTitle { padding: 18px 24px 16px 24px; margin: 0; text-align: center; border-bottom: 1.5px solid #e3ecf6; flex-shrink: 0; font-size: 17px; font-weight: 700; }
        #chatHistory { padding: 10px; overflow-y: auto; flex-grow: 1; }
        .chat-container { display: flex; flex-direction: column; gap: 12px; }
        .chat-bubble { max-width: 70%; padding: 10px 14px; border-radius: 18px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); text-align: left; word-break: keep-all; overflow-wrap: break-word; white-space: normal; }
        .bubble-me { align-self: flex-end; background-color: #FFFBE7; border: 1px solid #FFEAC4; border-bottom-right-radius: 4px; }
        .bubble-other { align-self: flex-start; background-color: #fff; border: 1px solid #eef1f5; border-bottom-left-radius: 4px; }
        .bubble-text { font-size: 14px; color: #000; margin: 0 0 4px 0; padding: 0; }
        .bubble-time { font-size: 11px; color: #999; text-align: right; }
        .chat-input-row { display: flex; align-items: center; gap: 8px; margin: 12px; background: #fff; border-radius: 12px; border: 1.5px solid #e2e5ea; padding: 7px 12px; box-shadow: 0 1px 4px rgba(80,110,140,0.08); flex-shrink: 0; }
        #chatInput { flex: 1; border: none; font-size: 15px; color: #23272f; outline: none; padding: 8px 0; height: 38px; background: none; }
        #chatInput::placeholder { color: #b7b8bd; font-size: 14px; }
        #sendMessageBtn { display: flex; align-items: center; justify-content: center; width: 38px; height: 38px; background: #7fa6c9; border: none; border-radius: 50%; transition: background 0.16s; cursor: pointer; padding: 0; }
        #sendMessageBtn:hover { background: #45607d; }
        .chat-date-separator { display: inline-block; padding: 4px 12px; margin: 16px auto; font-size: 12px; color: var(--chat-date-font); background: var(--chat-date-back); border-radius: 12px; text-align: center; }
    </style>
    
    <style> /* Setting Modal */
        .modal-setting-container { display: none; position: fixed; z-index: 3000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.65); backdrop-filter: blur(3px); justify-content: center; align-items: center; }
        .setting-modal-content { color: #333; background: white; padding: 25px; border-radius: 12px; width: 90%; max-width: 420px; text-align: center; position: relative; animation: zoomIn 0.2s; }
        .setting-modal-content h4 { margin-top: 0; margin-bottom: 20px; font-size: 1.2rem; }
        .setting-modal-content h5 { margin-top: 25px; margin-bottom: 15px; border-top: 1px solid #eee; padding-top: 25px; }
        #passwordCheckForm input[type="password"], #changePasswordForm input[type="password"] { width: calc(100% - 22px); padding: 10px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 5px; }
        #passwordCheckForm button, #profileImageForm button, #changePasswordForm button { width: 100%; padding: 10px; border: none; background: #007bff; color: white; border-radius: 5px; cursor: pointer; font-size: 1rem; margin-top: 10px; }
        .setting-modal-close { position: absolute; top: 10px; right: 15px; font-size: 24px; border: none; background: none; cursor: pointer; color: #888; }
        .setting-error-msg { color: red; font-size: 0.9em; margin-bottom: 10px; height: 1em; }
        #profileImagePreview { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 2px solid #ddd; margin-bottom: 15px; }
        #profileImageInput { margin: 10px 0; }
        #btnDeleteAccount { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; width: 100%; padding: 12px; margin-top: 25px; border-radius: 5px; cursor: pointer; font-weight: bold; }
    </style>
</head>
<body>
    <div id="notion-app">
        <input type="hidden" id="mode" value="user">
        <input type="hidden" id="profileUserAcIdx" value="${userPageData.userProfile.ac_idx}">
        <input type="hidden" id="profileUserNickname" value="${userPageData.userProfile.nickname}">
        <input type="hidden" id="currentPageNumber" value="${userPageData.nextPageNumber - 1}">
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
                                        <img id="mainProfileImage" src="${pageContext.request.contextPath}/vibesync/${userPageData.userProfile.img}" alt="프로필">
                                    </c:when>
                                    <c:otherwise>
                                        <img id="mainProfileImage" src="<%=contextPath %>/sources/default/default_user.jpg" alt="기본 프로필">
                                    </c:otherwise>
                                </c:choose>
                            </div>    
                            <div class="userInfo_detail">
                                <div class="name_function">
                                    <div id="left-wrapper">
                                        <p>${userPageData.userProfile.nickname}</p>
                                        <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx != userPageData.userProfile.ac_idx}">
                                            <button type="button" id="profileFollowBtn" class="btn_follow_1" data-author-id="${userPageData.userProfile.ac_idx}" data-following="${userPageData.userProfile.followedByCurrentUser ? 'true' : 'false'}">
                                                ${userPageData.userProfile.followedByCurrentUser ? 'UNFOLLOW' : 'FOLLOW'}
                                            </button>
                                        </c:if>
                                        <button id="up_msg_btn"><i class="fa-solid fa-paper-plane"></i> Message</button>
                                        <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx}">
                                            <button class="wp_btn" onclick="location.href='waList.jsp'"><img src="./sources/icons/watch.svg">Watch Party</button>
                                       </c:if>
                                    </div>
                                    <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx}">
                                        <button id="settingBtn"><img src="./sources/icons/settings_gear.svg" alt="setting"></button>
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
    
    <c:if test="${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx}">
        <button id="pageCreateBtn">＋</button>
    </c:if>

    <div id="pageModalOverlay" class="modal-overlay">
        <div id="modalWrapper">
            <div class="modal-content" id="pageModalContent" style="border: solid 2px var(--border-color);">
            <button class="modal-close" id="pageModalClose">&times;</button>
            </div>
        </div>
    </div>
    
    <div id="msgListModal" class="modal-msglist">
        <div class="modal-msg" style="min-width:350px; max-width:430px;">
            <span class="close-modal" onclick="closeMsgListModal()"> &times; </span>
            <h3 id="msgRoomTitle"></h3>
            <div id="msgList"></div>
        </div>
    </div>
    
    <div id="chatModal" class="chat-modal-super-container">
         <div class="chat-modal-content">
            <span class="close-modal" onclick="closeChatModal()"> &times; </span>
            <h4 id="chatTitle"></h4>
            <div id="chatHistory"></div>
            <div class="chat-input-row">
                <input type="text" id="chatInput" placeholder="메시지를 입력하세요..." autocomplete="off" />
                <button type="button" id="sendMessageBtn" title="전송">
                    <i class="fa-solid fa-paper-plane" style="color:white; font-size: 16px; filter: invert(0) !important;"></i>
                </button>
            </div>
         </div>
    </div>
    
    <div id="modal-setting-container" class="modal-setting-container">
        <div class="setting-modal-content">
            <button class="setting-modal-close">&times;</button>
            <div id="settingContent"></div>
        </div>
    </div>

    <script>
        let currentChatSenderIdx = 0;
        let currentUserData = null; // 인증 성공 시 사용자 정보를 저장할 전역 변수

        /*무한스크롤 함수*/
        var isLoading = false; // 중복 요청 방지 플래그
        
        $.ajaxSetup({
            cache: false
          });
        
        function loadMorePosts(){
            var hasMore = ($('#hasMorePosts').val() === 'true');
            if (!hasMore || isLoading) return;
            isLoading = true;
            $('#loadingIndicator').show();
            var nextPage = parseInt($('#currentPageNumber').val()) + 1;
            var profileUserId = $('#profileUserAcIdx').val();
            
            $.ajax({
                url: '${pageContext.request.contextPath}/loadMorePosts.do', 
                type: 'GET', 
                data: { userId: profileUserId, page: nextPage },
                dataType: 'json',
                success: function(response) {
                    if (response.posts && response.posts.length > 0) {
                        var postsHtml = '';
                        var contextPath = '${pageContext.request.contextPath}';
                        $.each(response.posts, function(index, post) {
                            var thumbnailUrl = post.thumbnail_img ? contextPath + post.thumbnail_img : contextPath + 'vibesync/sources/default/default_thumbnail.png';
                            postsHtml += '<a href="' + contextPath + '/vibesync/postView.do?nidx=' + post.note_idx + '">';
                            postsHtml += '    <div class="con_item">';
                            postsHtml += '        <img src="' + thumbnailUrl + '" alt="' + post.title + ' 썸네일">';
                            postsHtml += '    </div>';
                            postsHtml += '</a>';
                        });
                        $('#con_wrapper').append(postsHtml);
                        $('#currentPageNumber').val(nextPage);
                    }
                    if (!response.hasMore) {
                        $('#hasMorePosts').val('false');
                        $('#loadingIndicator').text('더 이상 게시물이 없습니다.');
                    } else {
                        $('#loadingIndicator').hide();
                        setTimeout(function() { checkAndLoadIfNeeded(); }, 100);
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
            if ($(document).height() <= $(window).height() && ($('#hasMorePosts').val() === 'true')) {
                console.log("콘텐츠가 부족하여 새 게시물을 자동으로 로드합니다.");
                loadMorePosts();
            }
       }
    
       $(document).ready(function() {
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

            $(window).scroll(function() {
                if ($(window).scrollTop() + $(window).height() >= $(document).height() - 200) {
                    loadMorePosts();
                }
            });
            
            $(window).on('resize', function() {
                checkAndLoadIfNeeded();
            });
            
            $('#pageCreateBtn').on('click', function() {
                var acIdx = $('#profileUserAcIdx').val();
                $.get('${pageContext.request.contextPath}/page/modalList.do', { ac_idx: acIdx }, function(html) {
                    $('#pageModalContent').children(':not(.modal-close)').remove();
                    $('#pageModalContent').append(html);
                    $('#pageModalOverlay').fadeIn();
                });
            });

            $('#pageModalOverlay').on('click', '#pageModalClose, .modal-overlay', function(e) {
                e.stopPropagation();
                $('#pageModalOverlay').fadeOut(function() {
                    $('#pageModalContent').children(':not(.modal-close)').remove();
                });
            });

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
                 var selectedIdx = $('#pageSelect').val();
                 $('#newNoteLink').attr('href', 'notecreate.do?pageidx=' + selectedIdx);
                 window.location.href = $('#newNoteLink').attr('href');
            });

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
            
            const isOwnProfile = ${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx};
            
            $('#up_msg_btn').on('click', function () {
                const isLoggedIn = ${sessionScope.userInfo != null};
                if (!isLoggedIn) {
                    alert("로그인이 필요합니다.");
                    location.href = "${pageContext.request.contextPath}/vibesync/user.do";
                    return;
                }
                if (isOwnProfile) {
                    openMessageModal();
                } else {
                    const profileUserId = $('#profileUserAcIdx').val();
                    const profileUserNickname = $('#profileUserNickname').val();
                    openChatWithUser(profileUserId, profileUserNickname);
                }
           });
            
            $('#msgList').on('click', '.msg_item', function() {
                const senderIdx = $(this).data('sender-idx');
                const nickname = $(this).data('nickname');
                openChatWithUser(senderIdx, nickname);
            });
            
            $("#sendMessageBtn").on("click", sendChatMessage);
        
            $("#chatInput").on("keydown", function(e) {
                if (e.key === "Enter" && !e.shiftKey) {
                    e.preventDefault();
                    sendChatMessage();
                }
            });
           
            $('#settingBtn').on('click', function() {
                showPasswordCheckView();
                $('#modal-setting-container').css('display', 'flex').hide().fadeIn(200);
            });

            $('#modal-setting-container').on('click', '.setting-modal-close, .modal-setting-container', function(e) {
                if (e.target === this) {
                    $('#modal-setting-container').fadeOut(200);
                }
            }).on('click', '.setting-modal-content', function(e) {
                e.stopPropagation();
            });

            $('#modal-setting-container').on('submit', '#passwordCheckForm', function(e) {
                e.preventDefault();
                const password = $(this).find('input[name="password"]').val();
                $.ajax({
                    url: '${pageContext.request.contextPath}/setting/checkPassword.do',
                    type: 'POST',
                    data: { password: password },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            currentUserData = response.userData;
                            showCombinedSettingsView();
                        } else {
                            $('#passwordCheckForm .setting-error-msg').text(response.message || '인증에 실패했습니다.');
                        }
                    },
                    error: function(xhr) {
                        const errorMsg = xhr.responseJSON ? xhr.responseJSON.message : '서버 통신 중 오류가 발생했습니다.';
                        $('#passwordCheckForm .setting-error-msg').text(errorMsg);
                    }
                });
            });
            
            $('#modal-setting-container').on('change', '#profileImageInput', function() {
                if (this.files && this.files[0]) {
                    const reader = new FileReader();
                    
                    reader.onload = function(e) {
                        $('#profileImagePreview').attr('src', e.target.result);
                    }
                    reader.readAsDataURL(this.files[0]);
                }
            });

         // [수정됨] 프로필 이미지 변경 폼 제출 (이미지 미리 로드 기능 추가)
            $('#modal-setting-container').on('submit', '#profileImageForm', function(e) {
                e.preventDefault();
                const fileInput = document.getElementById('profileImageInput');
                if (!fileInput.files || fileInput.files.length === 0) {
                    alert('이미지를 선택해주세요.');
                    return;
                }
                const file = fileInput.files[0];
                const reader = new FileReader();
                
                reader.onload = function(event) {
                    const base64Image = event.target.result;
                    
                    $.ajax({
                        url: '${pageContext.request.contextPath}/setting/setProfile.do',
                        type: 'POST',
                        data: {
                            profileImageBase64: base64Image
                        },
                        dataType: 'json',
                        cache: false,
                        success: function(response) {
                            if (response.success) {
                                // 1. 새 이미지 경로에 캐시 무효화를 위한 타임스탬프 추가
                                const newImgSrc = '${pageContext.request.contextPath}/vibesync/' + response.newImagePath + '?t=' + new Date().getTime();

                                // 4. 화면에 보이는 이미지들의 src를 교체 (이제 즉시 반영됨)
                                $('#mainProfileImage').attr('src', newImgSrc);
                                $('#profileImagePreview').attr('src', newImgSrc);
                                $('#profile-display img').attr('src', newImgSrc);
                                if(currentUserData) currentUserData.img = response.newImagePath;

                                // 5. 모든 시각적 업데이트가 끝난 후 사용자에게 알림
                                alert('프로필 이미지가 변경되었습니다.');
                                
                                // 이미지 로딩 실패 시 에러 처리
                                tempImg.onerror = function() {
                                    alert('새 프로필 이미지를 불러오는 데 실패했습니다.');
                                };
                                
                            } else {
                                alert('오류: ' + response.message);
                            }
                        },
                        error: function() {
                            alert('프로필 이미지 변경 중 서버 오류가 발생했습니다.');
                        }
                    });
                };
                reader.readAsDataURL(file);
            });
            
            $('#modal-setting-container').on('submit', '#changePasswordForm', function(e) {
                e.preventDefault();
                const newPassword = $(this).find('input[name="newPassword"]').val();
                const confirmPassword = $(this).find('input[name="confirmPassword"]').val();
                
                $('.setting-error-msg').text('');
                
                if (newPassword !== confirmPassword) {
                    $(this).find('.setting-error-msg').text('비밀번호가 일치하지 않습니다.');
                    return;
                }
                if (newPassword.length < 8) {
                    $(this).find('.setting-error-msg').text('비밀번호는 8자 이상이어야 합니다.');
                    return;
                }
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/setting/alterPassword.do',
                    type: 'POST',
                    data: { newPassword: newPassword },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            alert('비밀번호가 성공적으로 변경되었습니다. 다시 로그인해주세요.');
                            location.href = '${pageContext.request.contextPath}/main.do';
                        } else {
                            $(this).find('.setting-error-msg').text(response.message || '비밀번호 변경에 실패했습니다.');
                        }
                    },
                    error: function() {
                        alert('서버 오류로 비밀번호 변경에 실패했습니다.');
                    }
                });
            });
            
            $('#modal-setting-container').on('click', '#btnDeleteAccount', function() {
                if (confirm('정말로 탈퇴하시겠습니까? 모든 정보는 복구되지 않습니다.')) {
                    location.href = '${pageContext.request.contextPath}/setting/deleteAccount.do';
                }
            });
         
           checkAndLoadIfNeeded();
        });
        
        $(window).on('load', function() {
            if (window.location.hash === "#msg") {
                openMessageModal();
            }
        });
        
    </script>
    
    <script> /* 함수 */
    
    function openMessageModal() {
        window.location.hash = "msg";
        const acIdx = ${sessionScope.userInfo.ac_idx};
        const basePath = '${pageContext.request.contextPath}/vibesync/sources/';
        $.ajax({
            url: '${pageContext.request.contextPath}/message.do',
            type: 'GET',
            data: { view: 'LISTALL' },
            dataType: 'json',
            success: function(msgList) {
                $('#msgListModal').css('display', 'flex');
                $('#msgRoomTitle').html('<i class="fa-solid fa-comment-dots"></i> 메시지 목록');
                $('#msgList').empty();
                if (!msgList || !Array.isArray(msgList) || msgList.length === 0) {
                    const placeholderHtml = `<div class="no-message-placeholder"><i class="fa-regular fa-comments"></i><p>메시지 내역이 없습니다.</p></div>`;
                    $('#msgList').html(placeholderHtml);
                    return;
                }
                const msgContainer = $('<div class="msg-container"></div>');
                msgList.forEach(msg => {
                    let profileImgHtml = msg.other.profile_img ? `<img src="\${basePath}profile/\${msg.other.profile_img}" alt="profile">` : `<img src="\${basePath}default/default_user.jpg" alt="기본 프로필">`;
                    let unreadBadgeHtml = '';
                    if (msg.numOfUnreadMessages > 0) {
                        unreadBadgeHtml = `<span class="unread-badge">\${msg.numOfUnreadMessages}</span>`;
                    }
                    const messageHtml = `<div class="msg_item" data-sender-idx="\${msg.other.ac_idx}" data-nickname="\${msg.other.nickname}"><div class="msg_profile">\${profileImgHtml}</div><div class="msg_text_area"><div class="msg_sender_row"><div class="msg_sender">\${msg.other.nickname}</div>\${unreadBadgeHtml}</div><div class="msg_preview">\${msg.latestMessage.text}</div><div class="msg_time">\${msg.latestMessage.relativeTime}</div></div></div>`;
                    msgContainer.append(messageHtml);
                });
                $('#msgList').append(msgContainer);
            },
            error: function() { alert('메시지 내역 불러오기 실패'); }
        });
    }

    function closeMsgListModal() {
        window.location.hash = "";
        $('#msgListModal').hide();
    }
    
    function openChatWithUser(userIdx, nickname) {
        currentChatSenderIdx = userIdx;
        $('#chatTitle').text(nickname + '님과의 대화');
        $('#chatHistory').html('<p style="text-align:center; padding: 20px;">대화 내역을 불러오는 중...</p>');
        closeMsgListModal();
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
                        const messageHtml = `<div class="chat-bubble \${who}"><div class="bubble-text">\${formattedText}</div><div class="bubble-time">\${msg.relativeTime}</div></div>`;
                        chatContainer.append(messageHtml);
                    });
                    $('#chatHistory').append(chatContainer);
                }
                $('#chatModal').css('display', 'flex');
                $('#chatHistory').scrollTop($('#chatHistory')[0].scrollHeight);
            },
            error: function () { alert('채팅 내역을 불러오는 데 실패했습니다.'); }
        });
    }
    
    function closeChatModal() {
        $('#chatModal').hide();
        currentChatSenderIdx = null;
        if (${sessionScope.userInfo != null && sessionScope.userInfo.ac_idx == userPageData.userProfile.ac_idx}) {
            openMessageModal();
        }
    }
    
    function sendChatMessage() {
        const message = $("#chatInput").val().trim();
        if (!message || !currentChatSenderIdx) return;
        $.ajax({
            url: '${pageContext.request.contextPath}/message.do',
            type: 'POST',
            data: JSON.stringify({ receiver_idx: currentChatSenderIdx, text: message }),
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            success: function(res) {
                if(res.success) {
                    $("#chatInput").val("");
                    reloadChatHistory();
                } else {
                    alert('메시지 전송에 실패했습니다.');
                }
            },
            error: function() { alert('메시지 전송 중 오류 발생!'); }
        });
    }
    
    function reloadChatHistory() {
       if (currentChatSenderIdx) {
           const currentNickname = $('#chatTitle').text().replace('님과의 대화', '');
           openChatWithUser(currentChatSenderIdx, currentNickname);
        }
    }
    
    function showPasswordCheckView() {
        const passwordCheckHtml = `<h4>비밀번호 확인</h4><p style="font-size:0.9em; color:#555; margin-top:-10px; margin-bottom:20px;">계정 설정을 위해 현재 비밀번호를 입력해주세요.</p><form id="passwordCheckForm"><div class="setting-error-msg"></div><input type="password" name="password" placeholder="비밀번호" required autocomplete="current-password"><button type="submit">확인</button></form>`;
        $('#settingContent').html(passwordCheckHtml);
    }

    function showCombinedSettingsView() {
        const defaultImgSrc = '<%=contextPath %>/vibesync/sources/default/default_user.jpg';
        const currentImgSrc = currentUserData && currentUserData.img ? '${pageContext.request.contextPath}/' + currentUserData.img : defaultImgSrc;
        
        const combinedHtml = `
            <h4>계정 설정</h4>
            
            <h5>프로필 사진 변경</h5>
            <form id="profileImageForm">
                <img id="profileImagePreview" src="/vibesync\${currentImgSrc}" alt="프로필 미리보기">
                <input type="file" name="profileImage" id="profileImageInput" accept="image/*" required>
                <button type="submit">프로필 사진 저장</button>
            </form>

            <h5>비밀번호 변경</h5>
            <form id="changePasswordForm">
                <div class="setting-error-msg"></div>
                <input type="password" name="newPassword" placeholder="새 비밀번호" required autocomplete="new-password">
                <input type="password" name="confirmPassword" placeholder="새 비밀번호 확인" required autocomplete="new-password">
                <button type="submit">비밀번호 변경</button>
            </form>

            <button id="btnDeleteAccount">회원 탈퇴</button>
        `;
        $('#settingContent').html(combinedHtml);
    }
    
    </script>
</body>
<jsp:include page="/vibesync/includes/footer.jsp" />
</html>