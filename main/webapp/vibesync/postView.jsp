<%@page import="org.doit.dao.UserNoteDAO"%>
<%@page import="org.doit.domain.UserNoteVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   String contextPath = request.getContextPath();
%>
<%
Cookie[] cookies = request.getCookies();
String useridx = null;
if (cookies != null) {
    for (Cookie c : cookies) {
        if ("login_user_idx".equals(c.getName())) {
        	useridx = c.getValue();
        }
    }
}

String note_idx_str = request.getParameter("note_idx");
int note_idx = 0;
if (note_idx_str != null || note_idx_str != "") {
	note_idx = Integer.parseInt(note_idx_str);
}

UserNoteVO note = null;
note = UserNoteDAO.getUserNoteById(note_idx);

%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PostView</title>

  <link rel="stylesheet" href="./css/style.css">
  <script defer src="./js/script.js"></script>
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="postview">
    <div class="notion-app-inner">
      <jsp:include page="./includes/sidebar.jsp"></jsp:include>

      <!-- content -->
      <div id="content_wrapper">
        <section id="content">
          <div class="back_icon">
            <a href="#"><img src="./sources/icons/arrow_back.svg" alt="arrow_back"></a>
          </div>
  
          <div id="postview_Wrapper">
            <p><%= note.getTitle() %></p>
            <div class="writer_info">
              <div class="writer">
                <img src="<%= note.getImg()%>" alt="writer_profile">
                <p><%= note.getNickname() %></p>
                <button class="btn_liek_follow">Follow</button>
              </div>
              <div class="like_share">
                <form action="<%=contextPath %>/toggleLike" method="post" style="display:inline;">
				  <input type="hidden" name="noteIdx" value="<%=note.getNote_idx()%>"/>
				  <input type="hidden" name="userIdx" value="<%=note_idx%>"/>				  
				  <button type="submit" class="like" style="border:none; background:none; cursor:pointer;">
				    <img src="./sources/icons/heart.svg" alt="heart">
				    <span><%=note.getLike_num()%></span>
				  </button>
				</form>
              </div>
            </div>
  
            <div class="line"></div>
  
            <div class="text_content">
              <p><%= note.getText()%></p>
            </div>
  
          </div>
        </section>
      </div>
    </div>
  </div>
</body>
</html>