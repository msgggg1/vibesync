<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<% String contextPath = request.getContextPath() + "/vibesync"; %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>main</title>

  <!-- swiper -->
  <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
  <link
    rel="stylesheet"
    href="https://unpkg.com/swiper/swiper-bundle.min.css"
  />
  <!-- css,js -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <script defer src="${pageContext.request.contextPath}/js/script.js"></script>
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

            <a class="nickname icon_wrap" href="../html/user.html">
              <span>${ userInfo.nickname }</span>
            </a>

            <div class="search icon_wrap">
              <img src="./sources/icons/search.svg" alt="search icon" class="sidebar_icon">
              <input type="text" class="search-input" placeholder="Search…">
            </div>

            <a href="main.html" class="home icon_wrap">
              <img src="./sources/icons/home.svg" alt="" class="sidebar_icon">
              <span>HOME</span>
            </a>

            <a href="workspace.html" class="workspace icon_wrap">
              <img src="./sources/icons/work.svg" alt="" class="sidebar_icon">
              <span>WORKSPACE</span>
            </a>

            <div id="follow">
              <div class="follow_list">
                <div class="follow_tag icon_wrap">
                  <img src="./sources/icons/follow.svg" alt="follow icon" class="sidebar_icon">
                  <!-- label 클릭 시 체크박스 토글 -->
                  <label for="follow_toggle">FOLLOW</label>
                </div>
                <!-- 체크박스를 follow_items 형제 요소로 이동 -->
                <input type="checkbox" id="follow_toggle">
                <ul class="follow_items">
                  <li><a href="postView.html">PostView</a></li>
                  <li><a href="list.html">List</a></li>
                </ul>
              </div>
            </div>

          </div>
          
		<form action="user.do" method="post">
		    <input type="hidden" name="accessType" value="logout">
	          <div id="logout">
	            <button type="submit">Logout</button>
	          </div>
		</form>

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
            <c:forEach items="${ categoryVOList }" var="categoryVO">
            	<c:if test="${categoryVO.category_idx != userInfo.category_idx}">
	            	<button style="background-image: url( <%= contextPath %>${ categoryVO.img }); background-size: cover;"
	            			onclick="location.href='./list.jsp?category_idx=${categoryVO.category_idx}'">
	            		<p>${ categoryVO.c_name }</p>
	            	</button>
            	</c:if>
            </c:forEach>
          </div>
  
          <!-- grid -->
          <div class="grid_wrapper">
            <div class="grid_item" id="recent_posts_container" >
	            <c:forEach items="${latestNotes}" var="post" varStatus="status">
		            <div class="list-entry" data-id="${post.note_idx}">
		            	<a href="./postView.jsp?note_idx=${post.note_idx}" >
			                <img class="entry-image" src="https://placehold.co/300x200.png?text=${post.title}" alt="${post.title}">
			                <span class="entry-number">${status.count}.</span><span class="entry-title">${post.title}</span>
			            </a>
		            </div>
        		</c:forEach>
            </div>
            <div class="grid_item" id="popular_posts_container">
	             <c:forEach items="${popularNotes}" var="post" varStatus="status">
	            	<div class="list-entry" data-id="${post.note_idx}">
	                	<a href="./postView.jsp?note_idx=${ post.note_idx }">
		                	<img class="entry-image" src="https://placehold.co/300x200.png?text=${post.title}" alt="${post.title}">
		                	<span class="entry-number">${status.count}.</span><span class="entry-title">${post.title}</span>
	            		</a>
	            	</div>
	        	</c:forEach>
            </div>
            <div class="grid_item" id="popular_users_container">
            	  <c:forEach items="${popularUsers}" var="user" varStatus="status">
	            	<div class="list-entry" data-id="${status.count}">
	            		<a href="./user.jsp?ui=${ user.ac_idx }" >
	               	 		<img class="entry-image" src="https://placehold.co/100x100.png?text=${user.nickname}" alt="${user.nickname}">
	                		<span class="entry-number">${status.count}</span>
	                		<span class="entry-title">${user.nickname}</span>
	            		</a>
	            	</div>
        		 </c:forEach>
            </div>
          </div>

          <!-- other category -->
          <div class="slider-container">
            <div class="swiper" id="swiper2">
              <div class="swiper-wrapper">
              	<c:forEach items="${ popularNotesNotByMyCategory }" var="posts">
              		<div class="swiper-slide">
              		<ul>
              		<c:forEach items="${ posts.value }" var="post">
              			<li>
              			<a href="./postView.jsp?note_idx=${ post.note_idx }">
              				<div class="post-index" style="display: inline-block; align-self: left;">${ post.note_idx }</div>
		              		<div class="post-title" style="display: inline-block; align-self: right;">${ post.title }</div>
              			</a>
              			</li>
              		</c:forEach>
              		</ul>
              		</div>
              	</c:forEach>
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