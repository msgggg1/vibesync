<%@page import="org.doit.domain.NoteVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.doit.dao.UserPageDAO"%>
<%@page import="org.doit.domain.UserPage_UserVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

Cookie[] cookies = request.getCookies();

String user_idx = null;
int useridx = 0;
if (cookies != null) {
    for (Cookie c : cookies) {
        if ("login_user_idx".equals(c.getName())) {
        	user_idx = c.getValue();
        	useridx = Integer.parseInt(user_idx);
        }
    }
}

UserPage_UserVO user = UserPageDAO.getUserData(useridx);
ArrayList<NoteVO> user_note = UserPageDAO.getNotesByUser(useridx);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>user</title>

  <link rel="stylesheet" href="./css/style.css">
  <script defer src="./js/script.js"></script>

</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="user">
    <div class="notion-app-inner">
      <jsp:include page="./includes/sidebar.jsp"></jsp:include>
      
      <!-- content -->
      <div id="content_wrapper">
        <section id="content">
          <div id="user_wrapper">
            <div id="userInfo">
    
              <div class="user_profile_img">
                <img src="<%= user.getImg() %>" alt="">
              </div>
    
              <div class="userInfo_detail">
                <div class="name_function">
                  <p><%=user.getNickname() %></p>
                  <button class="btn_follow_1">Follow</button>
                  <button class="btn_follow_2">Watch Party</button>
                </div>
                <div class="user_count">
                  <p>Post <span><%= user_note.size() %></span></p>
                  <p>Follower <span><%= user.getFollow() %></span></p>
                  <p>Follow <span><%= user.getFollow() %></span></p>
                </div>
              </div>
            </div>
    
            <div class="line"></div>
    
            <div id="con_wrapper">
            	<% if (user_note.size() == 0)  {
            	%><p>아직 작성된 글이 없습니다.</p><%
            	} else {
            		for (NoteVO note : user_note) {%>
            			<div class="con_item">
            				<div class="note_imte">
                      <img src="<%= note.getImg() %>" alt="<%= note.getImg()%>">
                    </div>
            				<div class="note_info">
                      <p>
                        <span class="category"><%= note.getCategory_idx() %></span>
                        <span class="title"><%= note.getTitle() %></span>
                      </p>
                    </div>
            			</div>
            		<%}
            	}%>

            </div>
            
          </div>
  
  
        </section>
      </div>
    </div>
  </div>
</body>
</html>