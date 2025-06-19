<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="mvc.domain.vo.UserVO" %>
<%
  String contextPath = request.getContextPath(); // ex) "/MyApp"
  // [추가] 세션에서 로그인한 사용자 정보와 닉네임 가져오기
  UserVO user = (UserVO) session.getAttribute("userInfo");
  String nickname = "익명"; // 기본값
  if (user != null) {
      nickname = user.getNickname();
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>User Page - Watch Party</title>
  <script>
      const CONTEXT_PATH = '<%= contextPath %>';
      // [추가] JSP에서 가져온 닉네임을 JS 변수로 설정
      const NICKNAME = '<%= nickname %>'; 
  </script>
  <link rel="icon" href="./sources/favicon.ico" />
  <script src="https://www.youtube.com/iframe_api"></script>
  <script defer src="./js/watchparty.js"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Cal+Sans&family=National+Park:wght@200..800&display=swap');
    @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap');
    @import url('https://fonts.googleapis.com/css2?family=Kulim+Park:ital,wght@0,200;0,300;0,400;0,600;0,700;1,200;1,300;1,400;1,600;1,700&display=swap');

      /* 최소한의 스타일 */
      body { font-family: "National Park", sans-serif; background: #000; color: #fff; width: 100%; margin: 0; }
      #content-wrapper {padding: 40px; max-width: 1200px; margin: 0 auto;}
      .waList-header {display: flex; justify-content: space-between; align-items: center;}
      .tab-buttons { display: flex; gap: 20px; }
      .tab-buttons button { 
        padding: 8px 16px;
        border: 2px solid #fff;
        cursor: pointer;
        border-radius: 9px;
        color: #fff;
        background: #000; 
      }
      .tab-buttons button.active { background-color: #5087ffe8; }
      .tab-buttons button:hover { background-color: #82a5f1e8; }
      #list-container{ height: 300px; }
      #list-container, #host-container {
        border: 1px solid #ccc;
        padding: 1rem;
        max-height: 80vh;
        overflow-y: auto;
      }
      ul { list-style: none; padding: 0; }
      li { display: flex; justify-content: space-between; align-items: center;padding: 0.5rem; border-bottom: 1px solid #ddd; cursor: pointer; }
      li:hover { background: linear-gradient(90deg, rgb(63 98 133) 0%, rgb(96 21 159 / 64%) 50%, rgb(52 12 65 / 56%) 100%); }
      li img {width: 30px; height: 30px; object-fit: cover; border: 4px solid transparent; border-radius: 50%;
background-image: linear-gradient(#000, #000), linear-gradient(90deg, rgba(138, 196, 255, 1) 0%, rgba(227, 176, 255, 1) 50%, rgba(165, 250, 120, 1) 100%);
    background-origin: border-box;
    background-clip: content-box, border-box;}
      li div { display: flex; align-items: center; gap: 20px; }
      #btn-add-video { position: absolute; top: 1rem; right: 1rem; font-size: 1.2rem; background: #28a745; color: white; border: none; border-radius: 4px;
          width: 32px;  height: 32px; line-height: 32px; text-align: center; cursor: pointer; display: none;}
      /* [추가] 호스트 채팅 관련 스타일 */
      #host-container thead { background: black; }
      #chat-wrapper {width: 400px; margin: 0 auto;}
      .host-chat-log { height: 66vh; width: 97%;  overflow-y: auto; border: 1px solid #eee;  margin-bottom: 5px; padding: 5px; font-size: 14px; word-break:break-all; }
      .host-chat-log p { margin: 2px 0; }
      .host-chat { font-weight: bold; color: #ed3030; }
      .chat-input-wrapper input { width: calc(100% - 60px); }
      .chat-input-wrapper button { width: 50px; }
      .chat-input-submit { display: flex; }
      #wp_delete { position: fixed; width: 40px; height: 40px; bottom: 20px; right: 20px; background: #ed3030; border-radius: 50%; border-color: #fff; }
      #wp_delete a img {width: 80%; height: 80%; margin: 0 auto;}
  </style>
</head>
<body>
  <section id="content-wrapper">
    <div class="waList-header">
      <h1>Watch Party</h1>
  
      <div class="tab-buttons">
          <button id="btn-list">전체 영상 목록</button>
          <button id="btn-host">내가 올린 영상</button>
      </div>
    </div>
  
    <div id="list-container"></div>
  
    <button id="btn-add-video">＋</button>
    <div id="host-container" style="display:none;">
    </div>
    
    <div id="add-modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; 
                                background:rgba(0,0,0,0.5); z-index:1000;">
        <div id="add-modal-content" style="background: #2f2f2f; width:360px; padding:2rem; border-radius:8px;
                                            position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);">
            <h2>새 WatchParty 추가</h2>
            <form id="add-form">
                <div style="margin-bottom:0.5rem;">
                    <label for="wp-title">제목:</label><br/>
                    <input type="text" id="wp-title" name="title" style="width:100%;background: transparent;border-bottom: solid 2px #fff;border-top: none;height: 24px;border-left: none;border-right: none;color: #fff;outline: none;" placeholder="Title" required />
                </div>
                <div style="margin-bottom:0.5rem;">
                    <label for="wp-url">YouTube URL:</label><br/>
                    <input type="text" id="wp-url" name="url" style="width:100%;background: transparent;border-bottom: solid 2px #fff;border-top: none;height: 24px;border-left: none;border-right: none;color: #fff;outline: none;" placeholder="https://www.youtube.com/watch?v=..." required />
                </div>
                <div style="text-align:right;">
                    <button type="button" id="add-cancel" style="background-color: #e90000; color: #fff; font-weight: bold; border: none; border-radius: 4px; padding: 4px 10px; cursor: pointer;">취소</button>
                    <button type="submit" id="add-submit" style="background-color: #0086e9; color: #fff; font-weight: bold; border: none; border-radius: 4px; padding: 4px 10px; cursor: pointer;">추가</button>
                </div>
            </form>
        </div>
    </div>
    
   <button id="wp_delete">
   <a href="${pageContext.request.contextPath}/watchparty/watchpartyDelete.do?hostIdx=<%= user.getAc_idx() %>" onclick="return confirm('내가 올린 모든 파티를 삭제하시겠습니까?');"><img src="./sources/icons/off.svg" alt="off"></a>
   </button>

  </section>
  

</body>
</html>