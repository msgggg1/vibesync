<%@page import="javax.servlet.http.Cookie"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
Cookie[] cookies = request.getCookies();
String nickname = null;
if (cookies != null) {
    for (Cookie c : cookies) {
        if ("userNickname".equals(c.getName())){
        	nickname = c.getValue();
        }
    }
}
%>
<button id="toggle-btn">☰</button>

<nav class="notion-sidebar-container" id="sidebar">
       <div class="notion-sidebar">
         <div class="menu_content">
           <a class="nickname icon_wrap" href="./user.jsp">
             <span><%= nickname %></span>
      </a>

      <div class="search icon_wrap">
        <img src="./sources/icons/search.svg" alt="search icon" class="sidebar_icon">
        <input type="text" class="search-input" placeholder="Search…">
      </div>

      <a href="./main.jsp" class="home icon_wrap">
        <img src="./sources/icons/home.svg" alt="" class="sidebar_icon">
        <span>HOME</span>
      </a>

      <a href="./workspace.html" class="workspace icon_wrap">
        <img src="./sources/icons/work.svg" alt="" class="sidebar_icon">
        <span>WORKSPACE</span>
      </a>

      <div id="follow">
        <div class="follow_list">
          <div class="follow_tag icon_wrap">
            <img src="./sources/icons/follow.svg" alt="follow icon" class="sidebar_icon">
            <label for="follow_toggle">FOLLOW</label>
          </div>
          <input type="checkbox" id="follow_toggle">
          <ul class="follow_items">
            <li><a href="./postView.html">PostView</a></li>
            <li><a href="./list.html">List</a></li>
          </ul>
        </div>
      </div>

    </div>

    <div id="logout">
      <!-- 로그아웃 버튼: logout.jsp 로 이동 -->
      <form action="./includes/logout.jsp" method="post">
        <button type="submit">Logout</button>
      </form>
    </div>

  </div>
</nav>
