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
        <div class="accountData" id="accountData-display"></div>
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
            <input type="hidden" name="action" value="getFollowing" />
            <input type="hidden" name="useridx" id="useridx" 
                   value="${sessionScope.userInfo.ac_idx}" />
          </form>

          <ul class="follow_items">
            </ul>

        </div>
      </div>

    </div>
  </div>
</nav>

<script>
$(document).ready(function() {
   // 페이지 로드될 때 팔로워 수 불러오기
   updateFollowerCount();
   
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

        var formData = {
            action: $('input[name="action"]').val(),
            useridx: $('input[name="useridx"]').val()
        };

        $.ajax({
            type: 'POST',
            url: '<%= request.getContextPath() %>/sidebar.do',
            data: formData,
            dataType: 'json',
            success: function(response) {
                var items = response.followingList;
                console.log(items)
                $ul.empty();

                if (!items || items.length === 0) {
                    $ul.append('<li><p>No Follower</p></li>');
                } else {
                    $.each(items, function(i, user) {
                        var liHtml = ''
                            + '<li class="sidebar-profile">'
                            +   '<a href="userPage.do?acIdx=' + user.ac_idx + '">' 
                            +     '<img src="'+ user.profile_img +'" alt="profileImg">'
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
});
</script>

<script> /* 함수 */

function updateFollowerCount() {
    $.ajax({
        type: 'GET',
        url: '<%= request.getContextPath() %>/sidebar.do',
        dataType: 'json',
        success: function(sidebarDTO) {
            var followingCnt = sidebarDTO.userProfile.followingCount;
            var followerCnt = sidebarDTO.userProfile.followerCount;
            var postCnt = sidebarDTO.userProfile.postCount;
            var viewCnt = sidebarDTO.userProfile.postViewCount;
            
            var fHtml = `<div>
                         <span class="accountDataValue">\${followingCnt}</span> <span class="accountDataLabel">팔로잉</span>
                         <span class="accountDataValue">\${followerCnt}</span> <span class="accountDataLabel">팔로워</span>
                      </div>
                      
            `;
            /* 총 게시글 수, 조회수
                       <div>
                         <span class="accountDataValue">\${postCnt}</span> <span class="accountDataLabel">posts</span>
                         <span class="accountDataValue">\${viewCnt}</span> <span class="accountDataLabel">views</span>
                      </div>
            */
            
            $(".accountData").empty();
            $(".accountData").append(fHtml);
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error:', error);
        }
    });
}

</script>
<script src="<%= request.getContextPath() %>/vibesync/js/theme.js"></script>
