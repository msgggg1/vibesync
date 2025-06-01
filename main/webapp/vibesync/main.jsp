<!-- main.jsp -->
<%@page import="javax.servlet.http.Cookie"%>
<%@page import="org.doit.dao.CategoryDAO"%>
<%@page import="org.doit.domain.CategoryVO"%>
<%@page import="org.doit.domain.UserVO"%>
<%@page import="org.doit.dao.FollowUserDAO"%>
<%@page import="java.util.List"%>
<%@page import="org.doit.dao.NoteDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.doit.domain.NoteVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- 로그인 체크: userEmail, category_idx 쿠키 없으면 login.jsp 로 리디렉션 ---
    Cookie[] cookies = request.getCookies();
    String userEmail = null;
    String categoryIdx_str = null;
    String nickname = null;
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("userEmail".equals(c.getName())) {
                userEmail = c.getValue();
            }
            if ("category_idx".equals(c.getName())) {
                categoryIdx_str = c.getValue();
            }
        }
    }
    if (userEmail == null || categoryIdx_str == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 기존 로직: category 인자 파싱
    int category = Integer.parseInt(categoryIdx_str);
    int[] catArray = new int[4];
    int idx = 0;
    for (int i = 1; i <= 5; i++) {
        if (i != category) {
            catArray[idx++] = i;
        }
    }
    
    ArrayList<CategoryVO> category_list = CategoryDAO.CategoryAll(category);
    ArrayList<NoteVO> popular_notes = NoteDAO.MainList("view_count", category, 5);
    ArrayList<NoteVO> latest_notes  = NoteDAO.MainList("create_at",   category, 5);
    ArrayList<UserVO> follow_user   = FollowUserDAO.getTopFollowed(category, 5);
    ArrayList<NoteVO> diff_notes1  = NoteDAO.MainList("view_count", catArray[0], 5);
    ArrayList<NoteVO> diff_notes2  = NoteDAO.MainList("view_count", catArray[1], 5);
    ArrayList<NoteVO> diff_notes3  = NoteDAO.MainList("view_count", catArray[2], 5);
    ArrayList<NoteVO> diff_notes4  = NoteDAO.MainList("view_count", catArray[3], 5);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>main</title>
  <link rel="icon" href="./sources/favicon.ico" />
  <!-- swiper -->
  <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
  <link
    rel="stylesheet"
    href="https://unpkg.com/swiper/swiper-bundle.min.css"
  />
  <!-- css,js -->
  <link rel="stylesheet" href="./css/style.css">
  <script defer src="./js/script.js"></script>
  <style>
     ul li {
      height: 40px;
      display: flex;
      align-items: center;
     
     }
  
    ul li:hover{
    }

    ul li a {
        padding: 0px 10px;
      width: 100%;
      display:flex;
      justify-content:space-between;
      align-items: center;
    }
  </style>
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="main">
    <div class="notion-app-inner">
      <jsp:include page="./includes/sidebar.jsp"></jsp:include>

      <!-- content -->
      <div id="content_wrapper">
        <section id="content">
          <!-- banner -->
          <div class="slider-container">
            <div class="swiper" id="swiper1">
              <div class="swiper-wrapper">
                <div class="swiper-slide">Card 1</div>
                <div class="swiper-slide">Card 2</div>
                <div class="swiper-slide">Card 3</div>
                <div class="swiper-slide">Card 4</div>
                <div class="swiper-slide">Card 5</div>
              </div>
              <div class="swiper-button-prev" id="prev"></div>
              <div class="swiper-button-next" id="next"></div>
            </div>
          </div>
  
          <!-- category btn -->
          <div class="category_btn_group">
            <% for (CategoryVO ca : category_list) { %>
              <button style="background-image: url(<%= ca.getImg() %>); background-size: cover;">
                <p><%= ca.getC_name() %></p>
              </button>
            <% } %>
          </div>
  
          <!-- grid -->
          <div class="grid_wrapper">
            <div class="grid_item">
              <ul>
                <% for (NoteVO note : popular_notes) { %>
                  <li>
                    <a href="./postView.jsp?note_idx=<%= note.getNote_idx() %>" >
                      <div class="post-index"><%= note.getNote_idx() %></div>
                      <div class="post-title"><%= note.getTitle() %></div>
                    </a>
                  </li>
                <% } %>
              </ul>
            </div>
            <div class="grid_item">
              <ul>
                <% int i = 1; for (NoteVO note : latest_notes) { %>
                  <li>
                    <a href="./postView.jsp?note_idx=<%= note.getNote_idx() %>" >
                      <div class="post-index"><%= i %></div>
                      <div class="post-title"><%= note.getTitle() %></div>
                    </a>
                  </li>
                <% i++;} %>
              </ul>
            </div>
            <div class="grid_item">
              <ul>
                <% int j = 1; for (UserVO user : follow_user) { %>
                  <li>
                    <a href="" >
                      <div class="post-index"><%= j %></div>
                      <div class="post-title"><%= user.getNickname() %></div>
                    </a>
                  </li>
                <% j++; } %>
              </ul>
            </div>
          </div>
  
          <!-- other category -->
          <div class="slider-container">
            <div class="swiper" id="swiper2">
              <div class="swiper-wrapper">
                <%-- catArray[0] --%>
                <div class="swiper-slide">
                  <ul>
                    <% for (NoteVO note : diff_notes1) { %>
                      <li>
                        <a href="./postView.jsp?note_idx=<%= note.getNote_idx() %>" >
                          <div class="post-index"><%= note.getNote_idx() %></div>
                          <div class="post-title"><%= note.getTitle() %></div>
                        </a>
                      </li>
                    <% } %>
                  </ul>
                </div>
                <%-- catArray[1] --%>
                <div class="swiper-slide">
                  <ul>
                    <% for (NoteVO note : diff_notes2) { %>
                      <li>
                        <a href="./postView.jsp?note_idx=<%= note.getNote_idx() %>" >
                          <div class="post-index"><%= note.getNote_idx() %></div>
                          <div class="post-title"><%= note.getTitle() %></div>
                        </a>
                      </li>
                    <% } %>
                  </ul>
                </div>
                <%-- catArray[2] --%>
                <div class="swiper-slide">
                  <ul>
                    <% for (NoteVO note : diff_notes3) { %>
                      <li>
                        <a href="./postView.jsp?note_idx=<%= note.getNote_idx() %>" >
                          <div class="post-index"><%= note.getNote_idx() %></div>
                          <div class="post-title"><%= note.getTitle() %></div>
                        </a>
                      </li>
                    <% } %>
                  </ul>
                </div>
                <%-- catArray[3] --%>
                <div class="swiper-slide">
                  <ul>
                    <% for (NoteVO note : diff_notes4) { %>
                      <li>
                        <a href="./postView.jsp?note_idx=<%= note.getNote_idx() %>" >
                          <div class="post-index"><%= note.getNote_idx() %></div>
                          <div class="post-title"><%= note.getTitle() %></div>
                        </a>
                      </li>
                    <% } %>
                  </ul>
                </div>
              </div>
              <div class="swiper-button-prev" id="prev2"></div>
              <div class="swiper-button-next" id="next2"></div>
            </div>
          </div>
  
        </section>
      </div>

    </div>
  </div>
</body>
</html>
