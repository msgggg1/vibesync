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
    ul li a {
      display:flex;
      justify-content:center;
      align-items: center;
      color: white;
    }
  </style>
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="main">
    <div class="notion-app-inner">
      <button id="toggle-btn">☰</button>
      <!-- sidebar -->
      <nav class="notion-sidebar-container" id="sidebar">
        <div class="notion-sidebar">
          <div class="menu_content">
            <a class="nickname icon_wrap" href="./user.html">
              <span>Duck Hammer</span>
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
                  <li><a href="postView.html">PostView</a></li>
                  <li><a href="list.html">List</a></li>
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
                    <a>
                      <div class="post-index"><%= note.getNote_idx() %></div>
                      <div class="post-title"><%= note.getTitle() %></div>
                    </a>
                  </li>
                <% } %>
              </ul>
            </div>
            <div class="grid_item">
              <ul>
                <% for (NoteVO note : latest_notes) { %>
                  <li>
                    <a>
                      <div class="post-index"><%= note.getNote_idx() %></div>
                      <div class="post-title"><%= note.getTitle() %></div>
                    </a>
                  </li>
                <% } %>
              </ul>
            </div>
            <div class="grid_item">
              <ul>
                <% for (UserVO user : follow_user) { %>
                  <li>
                    <a>
                      <div class="post-index"><%= user.getAc_idx() %></div>
                      <div class="post-title"><%= user.getNickname() %></div>
                    </a>
                  </li>
                <% } %>
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
                        <a>
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
                        <a>
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
                        <a>
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
                        <a>
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
