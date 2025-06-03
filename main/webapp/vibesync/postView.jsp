<%@page import="org.doit.dao.UserNoteDAO"%>
<%@page import="org.doit.domain.UserNoteVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   String contextPath = request.getContextPath();
%>
<%
Cookie[] cookies = request.getCookies();
String useridx_str = null;
int useridx = 0;
if (cookies != null) {
    for (Cookie c : cookies) {
        if ("login_user_idx".equals(c.getName())) {
        	useridx_str = c.getValue();
        	useridx = Integer.parseInt(useridx_str);
        }
    }
}

String note_idx_str = request.getParameter("note_idx");
int note_idx = 0;
if (note_idx_str != null || note_idx_str != "") {
	note_idx = Integer.parseInt(note_idx_str);
}
System.out.print(note_idx);

UserNoteVO note = null;
note = UserNoteDAO.getUserNoteById(note_idx);

int writerIdx = 0;
if (note != null) {
	writerIdx = note.getUpac_idx();
}
boolean following = UserNoteDAO.isFollowing(useridx, writerIdx);
boolean liking = UserNoteDAO.isLiked(useridx, note_idx);
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
                
                <form action="<%=contextPath%>/toggleFollow" method="post" style="display:inline;margin:0; background:#99bc85;border-radius:5px;">
                  <input type="hidden" name="userIdx" value="<%= useridx %>" />
                  <input type="hidden" name="writerIdx" value="<%= writerIdx %>" />
                  <input type="hidden" name="noteIdx" value="<%= note_idx %>" />
                  <button type="submit" class="btn_like_follow" 
                          style="border:none; background:none; cursor:pointer;">
                    <%= following ? "Unfollow" : "Follow" %>
                  </button>
                </form>
                
              </div>
              <div class="like_share">
                <form action="<%=contextPath %>/toggleLike" method="post" style="display:inline;">
				  <input type="hidden" name="noteIdx" value="<%=note.getNote_idx()%>"/>
				  <input type="hidden" name="userIdx" value="<%=useridx%>"/>				  
				  <button type="submit" class="like" style="border:none; background:none; cursor:pointer;">
				    <img src="<%= liking ? "./sources/icons/fill_heart.png" : "./sources/icons/heart.svg" %>" alt="heart">
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
