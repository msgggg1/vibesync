<%@page import="mvc.domain.vo.UserVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%

   String contextPath = request.getContextPath() + "/vibesync";

%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>
.notion-sidebar {
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  height: 100%;
  width: 100%;
}

.notion-sidebar .menu_content {
  display: flex;
  justify-content: center;
  align-items: start;
  flex-direction: column;
  gap: 40px;
  font-size: 20px;
  font-weight: bold;
  margin-left: 10px;
  margin-block: 60px;
}
.notion-sidebar .menu_content .nickname {
  text-decoration: none;
  text-transform: uppercase;
  color: var(--font-color);
}

.search {
  display: inline-flex;
  align-items: center;
  position: relative;
  cursor: pointer;
}

/* 입력창 숨김 상태 */
.search-input {
  width: 100px;
  height: 22px;
  background: none;
  border: none;
  border-bottom: var(--border-color) 2px solid;
  color: var(--font-color);
}

input:focus {
  outline: none;
}

#follow {
  display: flex;
  justify-content: start;
  align-items: center;
  flex-direction: column;
  padding: 0;
  height: auto;
  overflow: hidden;
}

/* 레이블 스타일 */
.follow_list label {
  text-decoration: none;
  color: var(--font-color);
  cursor: pointer;
}

/* 체크박스 숨김 */
#follow_toggle {
  display: none;
}

.follow_items {
  list-style: none;
  padding: 0;
  margin: 20px 0 0;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease-out;
}
.follow_items.show {
  max-height: 500px;
  transition: max-height 0.3s ease-in;
}

.follow_items li {
  margin: 4px 0;
}

.icon_wrap {
  display: flex;
  gap: 10px;
}

.nickname-container {
  width: 100%;
  position: relative;
  display: inline-block;
}

.profile img {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 50%;
  aspect-ratio: 1/1;
  margin-bottom: 13px;
  border: 4px solid transparent;
  display: block;
  background-image: linear-gradient(var(--card-back), var(--card-back)), linear-gradient(90deg, rgba(138, 196, 255, 1) 0%, rgba(227, 176, 255, 1) 50%, rgba(165, 250, 120, 1) 100%);
  background-origin: border-box;
  background-clip: content-box, border-box;
}

.nickname {
  display: inline-block;
  max-width: 150px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  cursor: pointer;
  padding: 2px 4px;
}

#following-btn, #follower-btn {
	border: 0;
	background: none;
	margin: 0;
	padding: 0;
	gap: 0;
}

.accountDataLabel {
  font-weight: 400;
  font-size: medium;
  color: grey !important;
}

.accountDataValue {
  font-weight: 500;
  font-size: medium;
}

.modal-sidebar {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    background-color: var(--card-back);
    border: 1px solid var(--border-color);
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    z-index: 1000;
    white-space: nowrap;
    width: 210px;
    height: auto;
    padding: 15px;
    box-sizing: border-box;
}

.modal-nickname {
  display: block;
  text-decoration: none;
  color: var(--modal-font);
  padding: 4px 10px;
  margin-bottom: 10px;
}

.modal-nickname:hover {
  text-decoration: underline;
}

#nickname-modal-2 {
    display: none;
}
#nickname-modal-2 .theme-selector-container {
    width: 100%;
    padding: 0;
    border: none;
    margin-top: 10px;
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.modal-btn{
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  text-align: center;
  
  background: #f8f8fa;
  color: #222;
  font-weight: 700;
  font-size: 17px;
  height: 38px;
  border-radius: 12px;
  border: 1.8px solid #e1e4ea;
  margin-bottom: 7px;
  transition: background 0.18s, box-shadow 0.18s;
  box-shadow: 0 1.5px 6px rgba(180,180,200,0.05);
  letter-spacing: 0.2px;
  outline: none;
  cursor: pointer;
}
.modal-btn i {
  font-size: 18px;
  margin-right: 2px;
  color: var(--font-color);
}
.modal-btn img {
   max-height: 22px;
   max-width: 22px;
}

/* 
#logout form > button {
  border-color: #ffb7c5;
  color: #e35a6d;
}
#logout form > button:hover {
  background: #fff1f4;
}

#setting button {
  border-color: #8cd9c9;
  color: #2b8c7e;
}
#setting button:hover {
  background: #e6f7f2;
}
 */

#setting .modal-btn:hover {
  background: #e6f0fa;
  color: #1a81d6;
  border-color: #b9d3ec;
}
#logout .modal-btn:hover {
  background: #f3e7ea;
  color: #ed5e68;
  border-color: #eabec9;
}

</style>

<style> /* 설정 모드 */
  /* 전체 테마 선택 영역 컨테이너 */
  .theme-selector-container {
    display: flex;
    flex-direction: column;
    gap: 10px;
    width: 220px; /* 너비 조절 */
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-family: sans-serif;
  }

  /* 각 옵션을 감싸는 label. 이제 div가 아니라 label입니다. */
  .theme-option-label {
    display: flex;
    align-items: center;
    padding: 6px 10px;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.2s;
    border: 1px solid transparent;
    position: relative;
  }

  .theme-option-label:hover {
    background-color: var(--hover-color);
  }
  
  /* 기본 라디오 버튼 숨기기 */
  .theme-option-label input[type="radio"] {
    position: absolute;
    opacity: 0;
    width: 0;
    height: 0;
  }

  /* 직접 디자인한 동그라미 (커스텀 라디오 버튼) */
  .custom-radio {
    width: 20px;
    height: 20px;
    border: 2px solid #ccc;
    border-radius: 50%; /* 완벽한 원으로 만들기 */
    margin-right: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: border-color 0.2s;
  }

  /* 선택되었을 때의 내부 원 */
  .custom-radio .inner-circle {
    width: 10px;
    height: 10px;
    background-color: #3498db;
    border-radius: 50%;
    transform: scale(0); /* 평소에는 안 보이게 축소 */
    transition: transform 0.2s ease-in-out;
  }
  
  /* --- 핵심 로직 --- */
  /* 숨겨진 라디오 버튼이 체크되면(:checked), 바로 다음에 오는(.custom-radio) 요소의 스타일을 변경 */
  .theme-option-label input[type="radio"]:checked + .custom-radio {
    border-color: #3498db;
    background-color: #ddeafd;
  }

  /* 체크되면 내부 원을 다시 보이게 확대 */
  .theme-option-label input[type="radio"]:checked + .custom-radio .inner-circle {
    transform: scale(1);
  }

  /* 'Light', 'Dark' 텍스트 레이블 */
  .theme-label-text {
    font-weight: 500;
    font-size: 14px;
    margin-left: 10px;
  }

  /* 우측의 SVG 아이콘 컨테이너 */
  .theme-icon-svg {
    margin-left: auto; /* 왼쪽의 모든 요소를 밀어내고 오른쪽 끝으로 이동 */
  }

  .theme-icon-svg img {
    width: 50px;
    height: auto;
    display: block;
  }
  
  #nickname-modal-2 #back-btn {
    margin-bottom: 10px;
  }
  
  .sidebar-profile img {
	min-width: 30px;
    max-width: 30px;
    height: 30px;
    object-fit: cover;
    border-radius: 50%;
    margin-right: 10px;
    border: 2px solid transparent;
    display: block;
    background-image: linear-gradient(var(--card-back), var(--card-back)), linear-gradient(90deg, rgba(138, 196, 255, 1) 0%, rgba(227, 176, 255, 1) 50%, rgba(165, 250, 120, 1) 100%);
    background-origin: border-box;
    background-clip: content-box, border-box;
  }
</style>
<style> /* 팔로잉/팔로워/메시지목록 모달창 */
    .modal-overlay-follow {
    	display: none;
        position: fixed;
        top: 0;
        left: 0;
		width: 100vw; height: 100vh;
        background: rgba(0,0,0,0.6);
        justify-content: center;
        align-items: center;
        z-index: 2000;
        backdrop-filter: blur(2.5px);
    }

    .modal-follow-content {
        background: #f5f8fb;
        border-radius: 20px;
        box-shadow: 0 4px 32px 0 rgba(80,110,150,0.10), 0 0 0 1.5px #c7d3e8;
        width: 92%; max-width: 415px; min-width: 330px;
        min-height: 390px; max-height: 78vh;
        display: flex;
        flex-direction: column;
        padding-bottom: 13px;
        border: none;
        animation: zoomIn 0.21s;
        position: relative;
    }

    .modal-follow-header {
        display: flex;
        justify-content: space-around;
        border-bottom: 2px solid var(--border-color);
        padding: 18px 0 12px 0;
        flex-shrink: 0;
        
        color: var(--font-size);
        font-size: 18px;
        font-weight: 700;
        background: transparent;
        text-align: center;
        letter-spacing: 0.02em;
    }

    .modal-follow-tab-btn {
        background: none;
        border: none;
        font-size: 18px;
        font-weight: 700;
        color: #888;
        cursor: pointer;
        padding: 5px 10px;
        transition: color 0.2s;
    }

    .modal-follow-tab-btn.active {
        color: var(--font-color); /* 활성화된 탭 색상 */
        border-bottom: 2px solid #3498db; /* 활성화된 탭 밑줄 */
    }

    .modal-follow-list-container {
        flex-grow: 1;
        overflow-y: auto;
        padding: 13px 25px 10px 25px;
        min-height: 150px;
        display: flex;
        flex-direction: column;
        gap: 15px; /* 각 항목 간의 간격 */
        align-items: stretch;
        justify-content: flex-start;
        background: transparent;
    }
    
    /* 팔로잉/팔로워 목록 아이템 스타일 */
    .follow-list-item {
        display: flex;
        align-items: center;
        padding: 10px 15px;
        background: var(--card-back);
        border-radius: 11px;
        border: 2px solid var(--border-color);
        transition: background-color 0.14s ease-in-out;
    }
    .follow-list-item:hover {
        background-color: #f0f0f0; /* 호버 시 배경색 */
    }
    .follow-list-item img {
        width: 44px;
        height: 44px;
        object-fit: cover;
        border-radius: 50%;
        margin-right: 15px;
        border: 1.5px solid lightgrey;
    }
    .follow-list-item .user-info {
        flex-grow: 1;
    }
    .follow-list-item .user-info .nickname {
        font-weight: 700;
        font-size: 17px;
        color: #2d3440;
        margin-bottom: 2px;
        cursor: pointer; /* 닉네임 클릭 가능 */
        text-decoration: none; /* 링크 기본 스타일 제거 */
    }
    .follow-list-item .user-info .nickname:hover {
        text-decoration: underline;
    }
    .follow-list-item .action-buttons {
        display: flex;
        gap: 8px;
        align-items: center;
    }
    .follow-list-item .action-buttons .follow-toggle-btn {
        background: #4CAF50; /* FOLLOW */
        color: white;
        border: none;
        border-radius: 5px;
        padding: 8px 12px;
        cursor: pointer;
        font-weight: 600;
        transition: background-color 0.2s;
    }
    .follow-list-item .action-buttons .follow-toggle-btn.unfollow {
        background: #f44336; /* UNFOLLOW */
    }
    .follow-list-item .action-buttons .follow-toggle-btn:hover {
        opacity: 0.9;
    }
    .follow-list-item .action-buttons .message-btn {
        background: #2196F3; /* MESSAGE */
        color: white;
        border: none;
        border-radius: 5px;
        padding: 8px 10px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: background-color 0.2s;
    }
    .follow-list-item .action-buttons .message-btn i {
        font-size: 16px;
    }
    .follow-list-item .action-buttons .message-btn:hover {
        opacity: 0.9;
    }
</style>

<style> /* 메시지 목록 */
    
    @keyframes zoomIn {
        from { transform: scale(0.97); opacity: 0; }
        to { transform: scale(1); opacity: 1; }
    }
    
    #messageRoomTitle i {
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
    
    .message_item {
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
    .message_item:last-child {
        margin-bottom: 0;
    }
    
    .message_item:hover {
        background-color: #a7ffa193;
        cursor: pointer;
    }
    
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px);}
        to { opacity: 1; transform: translateY(0);}
    }
    
    .message_profile img {
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
        
    .message_text_area {
        flex: 1 1 auto;
        min-width: 0;
        max-width: 100%;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
    }
    
    .message_sender_row {
        display: flex;
        align-items: center;
        gap: 7px;
        margin-bottom: 1px;
        max-width: 100%;
        min-width: 0;
    }
    .message_sender {
        font-weight: 700;
        font-size: 17px;
        color: #2d3440;
        margin-bottom: 1px;
    }
    .message_preview {
        font-size: 14px;
        font-weight: 450;
        color: black;
        margin: 2px 0 0 0;
        opacity: 0.93;
        width: 100%;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .message_time {
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

<style> /* 채팅방 */
    .chatRoom-modal-super-container .modal-overlay-follow {
        background: rgba(0,0,0,0.6);
        backdrop-filter: blur(4px);
    }
    
    .modal-follow-content .chatRoom-modal-content {
        background-color: #f5f8fb;
        color: #223355;
        box-shadow: 0 6px 30px rgba(0, 0, 0, 0.3);
        animation: fadeInUp 0.3s ease-out;
        display: flex;
        flex-direction: column;
        max-height: 85vh;
    }

    #chatRoomTitle {
        padding: 18px 24px 16px 24px;
        margin: 0;
        text-align: center;
        border-bottom: 1.5px solid #e3ecf6;
        flex-shrink: 0;
        font-size: 17px;
        font-weight: 700;
    }
    
    #chatRoomHistory {
        padding: 10px;
        overflow-y: auto;
        flex-grow: 1;
    }
    .chatRoom-container {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }
    .chatRoom-bubble {
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
    .chatRoom-input-row {
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
    #chatRoomInput {
        flex: 1;
        border: none;
        font-size: 15px;
        color: #23272f;
        outline: none;
        padding: 8px 0;
        height: 38px;
        background: none;
    }
    #chatRoomInput::placeholder {
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
    .chatRoom-date-separator {
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

<button id="toggle-btn">☰</button>

<nav class="notion-sidebar-container" id="sidebar">
  <div class="notion-sidebar">
    <div class="menu_content">

      <div class="nickname-container">
        <span class="profile" id="profile-display">
          <c:choose>
             <c:when test="${not empty userInfo.img}">
                <img src="${pageContext.request.contextPath}/vibesync/${userInfo.img}" alt="프로필">
            </c:when>
            <c:otherwise>
               <img src="<%= contextPath %>/sources/default/default_user.jpg" alt="기본 프로필">
            </c:otherwise>
          </c:choose>
        </span>
        <span class="nickname" id="nickname-display">
          ${userInfo.nickname}
        </span>
        <div class="accountData" id="accountData-display">
        	<button type="button" id="following-btn" class="modal-follow-message">
            	<span class="accountDataValue"></span> <span class="accountDataLabel">팔로잉</span>
            </button>
            <button type="button" id="follower-btn" class="modal-follow-message">
            	<span class="accountDataValue"></span> <span class="accountDataLabel">팔로워</span>
			</button>
        </div>
        <div id="nickname-modal" class="modal-sidebar">
          <div id="nickname-modal-1">
             <a href="userPage.do?acIdx=${userInfo.ac_idx}" class="modal-nickname">
               ${userInfo.nickname}
             </a>
             <div id="setting">
               <button type="button" id="setting-btn" class="modal-btn">
                  <img src="./sources/icons/settings.svg" alt="setting icon"> Theme
               </button>
            </div>
            <div id="logout">
              <form action="user.do" method="post">
                <input type="hidden" name="accessType" value="logout">
                <button type="submit" class="modal-btn">
                   <i class="fa-solid fa-right-from-bracket"></i> Logout
                </button>
              </form>
            </div>
         </div>
         <div id="nickname-modal-2">
           <button type="button" id="back-btn" class="modal-btn">
               <i class="fa-solid fa-arrow-left"></i> 뒤로가기
           </button>
         <div class="theme-selector-container">
           
           <label class="theme-option-label">
             <input type="radio" name="theme" value="light" ${sessionScope.theme == 'light' || empty sessionScope.theme ? 'checked' : ''}>
             <div class="custom-radio">
               <div class="inner-circle"></div>
             </div>
             <span class="theme-label-text">Light</span>
             <div class="theme-icon-svg">
               <img src="./sources/sidebar/light_icon.svg">
             </div>
           </label>
         
           <label class="theme-option-label">
             <input type="radio" name="theme" value="dark" ${sessionScope.theme == 'dark' ? 'checked' : ''}>
             <div class="custom-radio">
                 <div class="inner-circle"></div>
             </div>
             <span class="theme-label-text">Dark</span>
             <div class="theme-icon-svg">
               <img src="./sources/sidebar/dark_icon.svg">
             </div>
           </label>
         
         </div>
         </div>
        </div>
      </div>
      <!-- <div class="search icon_wrap">
        <img src="./sources/icons/search.svg" alt="search icon" class="sidebar_icon">
        <input type="text" class="search-input" placeholder="Search…">
      </div> -->

      <a href="main.do" class="home icon_wrap">
        <img src="./sources/icons/home.svg" alt="home icon" class="sidebar_icon">
        <span>HOME</span>
      </a>

      <a href="workspace.do" class="workspace icon_wrap">
        <img src="./sources/icons/work.svg" alt="workspace icon" class="sidebar_icon">
        <span>WORKSPACE</span>
      </a>
      
      <a href="page.do" class="workspace icon_wrap">
        <img src="./sources/icons/page.svg" alt="workspace icon" class="sidebar_icon">
        <span>PAGES</span>
      </a>

      <div id="follow">
        <div class="follow_list" id="followButton">
          <div class="follow_tag icon_wrap">
            <img src="./sources/icons/follow.svg" alt="follow icon" class="sidebar_icon">
            <label for="follow_toggle">FOLLOW</label>
          </div>
          
          <form id="followForm_side">
          </form>

          <ul class="follow_items">
            </ul>

        </div>
      </div>

    </div>
  </div>
  
  <!-- 팔로잉/팔로워/메시지 모달창 -->
<div id="followListModal" class="modal-overlay-follow">
    <div class="modal-follow-content">
        <span class="close-modal">&times;</span>
        <div class="modal-follow-header">
            <button type="button" class="modal-follow-tab-btn" data-tab-type="following">팔로잉</button>
            <button type="button" class="modal-follow-tab-btn" data-tab-type="follower">팔로워</button>
            <button type="button" class="modal-follow-tab-btn" data-tab-type="message">메시지</button>
        </div>
        <div id="followListContent" class="modal-follow-list-container">
        </div>
    </div>
</div>

<!-- 채팅방 모달창 -->
<div id="chatRoomModal" class="chatRoom-modal-super-container modal-overlay-follow">
  <div class="modal-follow-content chatRoom-modal-content">
    <button class="close-modal" onclick="closechatRoomModal()">&times;</button>
    <h2 id="chatRoomTitle"></h2>
    <div id="chatRoomHistory"></div>
    <div class="chatRoom-input-row">
      <input id="chatRoomInput" placeholder="메시지를 입력하세요…" />
      <button id="sendMessageBtn" onclick="sendchatRoomMessage()">
        <i class="fa-solid fa-paper-plane"></i>
      </button>
    </div>
  </div>
</div>
  
</nav>

<script>
$(document).ready(function() {
   // 페이지 로드될 때 팔로워 수 불러오기
   updateFollowCount();
   
   var isExpanded = false;

    $('#followButton').on('click', function(e) {
        // [수정] 클릭된 대상이 <a> 태그이거나 그 자식일 경우, 아무것도 하지 않고 기본 동작(링크 이동)을 허용
        if ($(e.target).closest('a').length) {
            return;
        }

        // 링크가 아닌 다른 곳을 클릭했을 때만 아래 로직 실행
        e.preventDefault();

        var $ul = $('.follow_items');
        var $followDiv = $('#follow');

        if (isExpanded) {
            $ul.empty();
            $ul.removeClass('show');
            isExpanded = false;
            return;
        }

        $.ajax({
            type: 'GET',
            url: '<%= request.getContextPath() %>/follow.do',
            data: {action: 'getFollowing'},
            dataType: 'json',
            success: function(response) {
                var items = response;
                $ul.empty();

                if (!items || items.length === 0) {
                    $ul.append('<li><p>No Follower</p></li>');
                } else {
                    $.each(items, function(i, user) {
                    	let profileImg = user.profile_img != null ? user.profile_img : '${pageContext.request.contextPath}/vibesync/sources/default/default_user.jpg';
                    	
                        var liHtml = ''
                            + '<li class="sidebar-profile">'
                            +   '<a href="userPage.do?acIdx=' + user.ac_idx + '">' 
                            +     '<img src="'+ profileImg +'" alt="profileImg">'
                            +     user.nickname 
                            +   '</a>'
                            + '</li>';
                        $ul.append(liHtml);
                    });
                }
                
                $ul.addClass('show');
                isExpanded = true;
            },
            error: function(xhr, status, error) {
                console.error('AJAX Error:', error);
            }
        });
    });

    // 닉네임 클릭 시 모달 토글
    $('#nickname-display').on('click', function(e) {
        e.stopPropagation(); // 이벤트 버블링 방지
        $('#nickname-modal').toggle();

        // 모달이 열릴 때 항상 첫 화면을 보여주도록 초기화
        $('#nickname-modal-1').show();
        $('#nickname-modal-2').hide();
    });

    // 'Setting' 버튼 클릭 시 설정 화면으로 전환
    $('#setting-btn').on('click', function() {
        $('#nickname-modal-1').hide();
        $('#nickname-modal-2').show();
    });

    // '뒤로가기' 버튼 클릭 시 이전 화면으로 복귀
    $('#back-btn').on('click', function() {
        $('#nickname-modal-2').hide();
        $('#nickname-modal-1').show();
    });

    // 모달 외부 클릭 시 모달 닫기
    $(document).on('click', function(e) {
        // 모달 자신이나 모달을 연 버튼이 아닌 곳을 클릭했을 때
        if ($(e.target).closest('#nickname-modal, #nickname-display').length === 0) {
            $('#nickname-modal').hide();
        }
    });
    
/* 팔로잉/팔로워/메시지 모달창 */
    
    // 팔로잉/팔로워 버튼 클릭 시 모달 열기
    $('#following-btn, #follower-btn').on('click', function() {
        let defaultTab = $(this).attr('id') === 'following-btn' ? 'following' : 'follower';
        openFollowListModal(defaultTab);
    });
    
    // 모달 내 탭 버튼 클릭 이벤트
    $(document).on('click', '.modal-follow-tab-btn', function() {
        $('.modal-follow-tab-btn').removeClass('active');
        $(this).addClass('active');
        let tabType = $(this).data('tab-type');
        loadFollowListData(tabType);
    });
    
    // 팔로우/언팔로우 버튼 클릭 이벤트
    $(document).on('click', '.follow-toggle-btn', function(e) {
        e.stopPropagation(); // 버블링 막기 (상위 아이템 클릭 방지)
        const targetAcIdx = $(this).data('target-ac-idx');
        const isFollowing = $(this).hasClass('unfollow'); // 현재 팔로잉 중이면 unfollow 클래스가 있음
        const $button = $(this);
    
        $.ajax({
            url: '<%= request.getContextPath() %>/followToggle.do',
            type: 'POST',
            data: { 
                authorId: targetAcIdx
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    if (response.following) { // 서버 응답에 따라 상태 변경
                        $button.removeClass('unfollow').text('팔로잉');
                    } else {
                        $button.addClass('unfollow').text('팔로우');
                    }
                    // 사이드바의 팔로워/팔로잉 카운트 업데이트
                    updateFollowCount();
                } else {
                    alert('팔로우/언팔로우 처리 실패: ' + (response.message || '알 수 없는 오류'));
                }
            },
            error: function(xhr, status, error) {
                alert('팔로우 요청 중 오류 발생: ' + error);
            }
        });
    });
    
    // 팔로우/팔로잉 목록 내 메시지 버튼 클릭 이벤트 (동적으로 생성되므로 위임 사용)
    $(document).on('click', '.message-btn-in-modal', function(e) {
        e.stopPropagation();
        const targetAcIdx = $(this).data('target-ac-idx');
        const nickname = $(this).data('nickname');
        openchatRoomWithUser(targetAcIdx, nickname);
    });
    
    // 메시지 목록 내 클릭
	$(document).on('click', '.message_item', function(e){
	  e.stopPropagation();
	  const idx      = $(this).data('sender-idx');
	  const nickname = $(this).data('nickname');
	  openchatRoomWithUser(idx, nickname);
	});
    
    // 모달 닫기 버튼
    $(document).on('click', '#followListModal .close-modal', function() {
        closeFollowListModal();
    });
    
});
</script>

<script> /* 함수 */

function updateFollowCount() {
	updateFollowingCount();
	updateFollowerCount();
}

function updateFollowingCount() {
    $.ajax({
        type: 'GET',
        url: '<%= request.getContextPath() %>/follow.do',
        cache: 'no-store',
        data: {action: 'getFollowingCount'},
        dataType: 'json',
        success: function(followingCount) {
            $("#following-btn").find(".accountDataValue").text(followingCount);
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error:', error);
        }
    });
}

function updateFollowerCount() {
    $.ajax({
        type: 'GET',
        url: '<%= request.getContextPath() %>/follow.do',
        cache: 'no-store',
        data: {action: 'getFollowerCount'},
        dataType: 'json',
        success: function(followerCount) {
            $("#follower-btn").find(".accountDataValue").text(followerCount);
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error:', error);
        }
    });
}

// 팔로잉/팔로워/메시지 모달 열기 함수
function openFollowListModal(defaultTab = 'following') {
    const isLoggedIn = ${sessionScope.userInfo != null};
    if (!isLoggedIn) {
        alert("로그인이 필요합니다.");
        location.href = "<%= request.getContextPath() %>/vibesync/user.do";
        return;
    }

    $('#followListModal').css('display', 'flex');
    $('.modal-follow-tab-btn').removeClass('active');
    
    // 기본 탭 활성화 및 데이터 로드
    $(`.modal-follow-tab-btn[data-tab-type="\${defaultTab}"]`).addClass('active');
    loadFollowListData(defaultTab);
}

// 팔로잉/팔로워/메시지 데이터 로드 함수
function loadFollowListData(tabType) {
    const listContainer = $('#followListContent');
    listContainer.empty().html('<p style="text-align:center; padding: 20px;">로딩 중...</p>'); // 로딩 스피너

    const basePath = '<%= contextPath %>/sources/';

    let apiUrl;
    let requestData;

    if (tabType === 'following') {
        apiUrl = '<%= request.getContextPath() %>/follow.do';
        requestData = { action: 'getFollowing' };
    } else if (tabType === 'follower') {
        apiUrl = '<%= request.getContextPath() %>/follow.do';
        requestData = { action: 'getFollower' };
    } else if (tabType === 'message') {
        apiUrl = '<%= request.getContextPath() %>/message.do';
        requestData = { view: 'LISTALL' };
    } else {
        listContainer.html('<p style="text-align:center; padding: 20px;">잘못된 탭 요청입니다.</p>');
        return;
    }

    $.ajax({
        url: apiUrl,
        type: 'GET',
        data: requestData,
        dataType: 'json',
        success: function(response) {
            listContainer.empty();
            if (tabType === 'following' || tabType === 'follower') {
                const list = response;
                if (!list || list.length === 0) {
                    listContainer.html('<p class="no-message-placeholder"><i class="fa-solid fa-users"></i><p>목록이 비어있습니다.</p></p>');
                    return;
                }
                list.forEach(user => {
                    const profileImg = user.profile_img ? `<%= request.getContextPath() %>/\${user.profile_img}` : `\${basePath}default/default_user.jpg`;
                    const isFollowing = user.followedByCurrentUser;
                    const followButtonText = isFollowing ? '팔로잉' : '팔로우';
                    const followButtonClass = isFollowing ? 'follow-toggle-btn unfollow' : 'follow-toggle-btn';

                    const itemHtml = `
                        <div class="follow-list-item">
                            <img src="\${profileImg}" alt="프로필">
                            <div class="user-info">
                                <a href="userPage.do?acIdx=\${user.ac_idx}" class="nickname">\${user.nickname}</a>
                            </div>
                            <div class="action-buttons">
                            	<button type="button" class="\${followButtonClass}" data-target-ac-idx="\${user.ac_idx}">
                                	\${followButtonText}
                                </button>
                                <button type="button" class="message-btn message-btn-in-modal" data-target-ac-idx="\${user.ac_idx}" data-nickname="\${user.nickname}">
                                	<i class="fa-solid fa-paper-plane"></i>
                                </button>
                            </div>
                        </div>
                    `;
                    listContainer.append(itemHtml);
                });
            } else if (tabType === 'message') {
                const messageList = response;
                if (!messageList || !Array.isArray(messageList) || messageList.length === 0) {
                    const placeholderHtml = `
                        <div class="no-message-placeholder">
                            <i class="fa-regular fa-comments"></i>
                            <p>메시지 내역이 없습니다.</p>
                        </div>
                    `;
                    listContainer.html(placeholderHtml);
                    return;
                }
                messageList.forEach(message => {
                    let profileImgHtml = message.other.profile_img ?
                        `<img src="<%= request.getContextPath() %>/\${message.other.profile_img}" alt="profile">` :
                        `<img src="\${basePath}default/default_user.jpg" alt="기본 프로필">`;

                    let unreadBadgeHtml = '';
                    if (message.numOfUnreadMessages > 0) {
                        unreadBadgeHtml = `<span class="unread-badge">\${message.numOfUnreadMessages}</span>`;
                    }
                    
                    const messageHtml = `
                        <div class="message_item" data-sender-idx="\${message.other.ac_idx}" data-nickname="\${message.other.nickname}">
                            <div class="message_profile">
                                \${profileImgHtml}
                            </div>
                            <div class="message_text_area">
                                <div class="message_sender_row">
                                    <div class="message_sender">\${message.other.nickname}</div>
                                    \${unreadBadgeHtml}
                                </div>
                                <div class="message_preview">\${message.latestMessage.text}</div>
                                <div class="message_time">\${message.latestMessage.relativeTime}</div>
                            </div>
                        </div>
                    `;
                    listContainer.append(messageHtml);
                });
            }
        },
        error: function(xhr, status, error) {
            listContainer.html('<p style="text-align:center; padding: 20px; color: red;">데이터 로드 실패: ' + (xhr.responseJSON ? xhr.responseJSON.message : error) + '</p>');
            console.error('Failed to load follow/message list:', error);
        }
    });
}

//팔로잉/팔로워/메시지 모달 닫기 함수
function closeFollowListModal() {
    $('#followListModal').hide();
    $('#followListContent').empty(); // 내용 비우기
    // 닫을 때 현재 채팅 모달이 열려있다면 닫지 않음
    if ($('#chatRoomModal').is(':visible')) {
        // 이미 채팅 모달이 열려있다면, 메시지 목록 모달만 닫음
    } else {
        window.location.hash = ""; // URL 해시 초기화
    }
}

//특정 유저와의 채팅창 열기 함수
function openchatRoomWithUser(userIdx, nickname) {	
    currentchatRoomSenderIdx = userIdx;
    $('#chatRoomTitle').text(nickname + '님과의 대화');
    $('#chatRoomHistory').html('<p style="text-align:center; padding: 20px;">대화 내역을 불러오는 중...</p>'); // 로딩 표시
    
    closeFollowListModal(); // 팔로잉/팔로워/메시지 목록 모달이 열려있었다면 닫기

    $.ajax({
        url: '<%= request.getContextPath() %>/message.do',
        type: 'GET',
        data: { sender_idx: userIdx, view: 'CHAT' },
        dataType: 'json',
		success: function (chatRoomList) {
		    $('#chatRoomHistory').empty();
		    
		    if (!chatRoomList || !Array.isArray(chatRoomList) || chatRoomList.length === 0) {
		        $('#chatRoomHistory').html('<p style="text-align:center; color:grey; padding: 20px;">아직 대화 내역이 없습니다.</p>');
		    } else {
		        const chatRoomContainer = $('<div class="chatRoom-container"></div>');
		        let lastDate = null;
		        chatRoomList.forEach(message => {
		            if (message.date !== lastDate) {
		                lastDate = message.date;
		                const dateLabel = $('<div class="chatRoom-date-separator"></div>').text(lastDate);
		                chatRoomContainer.append(dateLabel);
		            }
		            const who = message.isMine ? 'bubble-me' : 'bubble-other';
		            const formattedText = message.text.replace(/\n/g, '<br>');
		            const messageHtml = `
		                <div class="chatRoom-bubble \${who}">
		                    <div class="bubble-text">\${formattedText}</div>
		                    <div class="bubble-time">\${message.relativeTime}</div>
		                </div>`;
		            chatRoomContainer.append(messageHtml);
		        });
		        $('#chatRoomHistory').append(chatRoomContainer);
		    }
		
		    $('#chatRoomModal').css('display', 'flex');
		    $('#chatRoomHistory').scrollTop($('#chatRoomHistory')[0].scrollHeight); // 스크롤 맨 아래로
		},
		error: function () {
		    alert('채팅 내역을 불러오는 데 실패했습니다.');
		}
    });
}

//채팅 모달 닫기
function closechatRoomModal() {
    $('#chatRoomModal').hide();
    currentchatRoomSenderIdx = null; // 현재 채팅 상대 초기화
    // 메시지 목록을 다시 열어서 unread 카운트를 갱신
    openFollowListModal('message');
}

//채팅 메시지 전송
function sendchatRoomMessage() {
    const message = $("#chatRoomInput").val().trim();
    if (!message || !currentchatRoomSenderIdx) return;

    $.ajax({
        url: '<%= request.getContextPath() %>/message.do',
        type: 'POST',
        data: JSON.stringify({
            receiver_idx: currentchatRoomSenderIdx,
            text: message
        }),
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function(res) {
            if(res.success) {
                $("#chatRoomInput").val(""); // 입력창 비우기
                reloadchatRoomHistory(); // 채팅 내역 갱신
            } else {
                alert('메시지 전송에 실패했습니다.');
            }
        },
        error: function() { alert('메시지 전송 중 오류 발생!'); }
    });
}

//채팅 내역 새로고침
function reloadchatRoomHistory() {
    if (currentchatRoomSenderIdx) {
        const currentNickname = $('#chatRoomTitle').text().replace('님과의 대화', '');
        openchatRoomWithUser(currentchatRoomSenderIdx, currentNickname);
    }
}


</script>
<script src="<%= request.getContextPath() %>/vibesync/js/theme.js"></script>
