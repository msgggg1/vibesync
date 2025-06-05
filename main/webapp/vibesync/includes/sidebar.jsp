<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- CSS 및 JS를 모두 이 파일 내에 포함 -->
<style>
  .nickname-container {
    position: relative; 
    display: inline-block; /* 모달을 닉네임 바로 아래에 띄우기 위해 필요 */
  }

  .nickname {
    display: inline-block;
    max-width: 150px;            /* 최대 너비 */
    white-space: nowrap;         /* 한 줄로 표시 */
    overflow: hidden;            /* 넘치는 부분 숨김 */
    text-overflow: ellipsis;     /* 말줄임표 처리 */
    cursor: pointer;             /* 클릭 가능한 것처럼 보이게 */
    padding: 2px 4px;            /* 필요에 따라 여백 조절 */
  }

  /* ==================================================
     2. 모달 기본 스타일
  =================================================== */
  .modal {
    display: none;               /* 기본적으로 숨김 */
    position: absolute;
    top: 100%;                   /* 닉네임 바로 아래 */
    left: 0;
    background-color: #fff;      /* 흰색 배경 */
    border: 1px solid #ccc;      /* 테두리 */
    border-radius: 4px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
    padding: 8px 12px;
    z-index: 1000;               /* 위로 떠 있도록 */
    white-space: nowrap;         /* 모달 안의 내용도 한 줄로 */
  }

  .modal-nickname {
    display: block;
    text-decoration: none;
    color: #333;
  }

  .modal-nickname:hover {
    text-decoration: underline;
  }
  
	#logout form {
	  width: 100%;
	  display: flex;
	  justify-content: center;
	  height: 40px;
	  margin-bottom: 20px;
	}
	
	#logout form > button {
	  width: 150px;
	  border: none;
	  background-color: red;
	  border-radius: 5px;
	  font-size: 14px;
	  text-transform: uppercase;
	  font-weight: bold;
	  color: var(--w-fff);
	  cursor: pointer;
	}

</style>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    var nicknameDisplay = document.getElementById('nickname-display');
    var modal = document.getElementById('nickname-modal');

    if (nicknameDisplay && modal) {
      // 1) 닉네임 클릭 시 모달 토글
      nicknameDisplay.addEventListener('click', function(event) {
        event.stopPropagation(); // 문서 클릭 이벤트 전달 차단
        if (modal.style.display === 'block') {
          modal.style.display = 'none';
        } else {
          modal.style.display = 'block';
        }
      });

      // 2) 문서 어딘가 클릭하면 모달 닫기
      document.addEventListener('click', function(event) {
        if (modal.style.display === 'block') {
          modal.style.display = 'none';
        }
      });

      // 3) 모달 내부를 클릭해도 모달이 닫히지 않도록
      modal.addEventListener('click', function(event) {
        event.stopPropagation();
      });
    }
  });
</script>

<button id="toggle-btn">☰</button>

<nav class="notion-sidebar-container" id="sidebar">
  <div class="notion-sidebar">
    <div class="menu_content">

      <!-- 닉네임 영역: 클릭 시 모달 토글 -->
      <div class="nickname-container">
        <span class="nickname" id="nickname-display">
          ${userInfo.nickname}
        </span>

        <!-- 모달: 기본 숨김, 클릭 시 보임 -->
        <div id="nickname-modal" class="modal">
          <!-- 모달 내부 닉네임 클릭 시 user.jsp?ui=로 이동 -->
          <a href='userPage.do?acIdx=${userInfo.ac_idx}' class="modal-nickname">
            ${userInfo.nickname}
          </a>
        </div>
      </div>
      <!-- // 닉네임 영역 끝 -->

      <!-- 검색 -->
      <div class="search icon_wrap">
        <img src="./sources/icons/search.svg" alt="search icon" class="sidebar_icon">
        <input type="text" class="search-input" placeholder="Search…">
      </div>

      <!-- HOME -->
      <a href="main.do" class="home icon_wrap">
        <img src="./sources/icons/home.svg" alt="home icon" class="sidebar_icon">
        <span>HOME</span>
      </a>

      <!-- WORKSPACE -->
      <a href="./workspace.html" class="workspace icon_wrap">
        <img src="./sources/icons/work.svg" alt="workspace icon" class="sidebar_icon">
        <span>WORKSPACE</span>
      </a>

      <!-- FOLLOW 목록 -->
      <div id="follow">
        <div class="follow_list">
          <div class="follow_tag icon_wrap">
            <img src="./sources/icons/follow.svg" alt="follow icon" class="sidebar_icon">
            <label for="follow_toggle">FOLLOW</label>
          </div>
          <input type="checkbox" id="follow_toggle">
          <ul class="follow_items">
          	<c:forEach items="${sidebarDTO.followingList}" var="user">
          		<li><a href="./user.jsp?ui=${user.ac_idx}">${user.nickname}</a></li>
          	</c:forEach>
          </ul>
        </div>
      </div>

    </div>

    <!-- 로그아웃 -->
    <div id="logout">
      <form action="user.do" method="post">
		    <input type="hidden" name="accessType" value="logout">
            <button type="submit">Logout</button>
	  </form>
    </div>
  </div>
</nav>