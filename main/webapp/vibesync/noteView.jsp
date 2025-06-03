<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
			<button id="toggle-btn"><</button>
			<!-- sidebar -->
			<nav class="notion-sidebar-container" id="sidebar">
				<div class="notion-sidebar">
					<div class="menu_content">

						<a class="nickname icon_wrap" href="./user.html"> <span>Duck
								Hammer</span>
						</a>

						<div class="search icon_wrap">
							<img src="./sources/icons/search.svg" alt="search icon"
								class="sidebar_icon"> <input type="text"
								class="search-input" placeholder="Search…">
						</div>

						<a href="./main.do" class="home icon_wrap"> <img
							src="./sources/icons/home.svg" alt="" class="sidebar_icon">
							<span>HOME</span>
						</a> <a href="./workspace.html" class="workspace icon_wrap"> <img
							src="./sources/icons/work.svg" alt="" class="sidebar_icon">
							<span>WORKSPACE</span>
						</a>

						<div id="follow">
							<div class="follow_list">
								<div class="follow_tag icon_wrap">
									<img src="./sources/icons/follow.svg" alt="follow icon"
										class="sidebar_icon">
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

					<div id="logout">
						<button>Logout</button>
					</div>

				</div>
			</nav>

			<!-- content -->
			<div id="content_wrapper">
				<section id="content">
					<div class="back_icon">
						<a href="#"><img src="./sources/icons/arrow_back.svg"
							alt="arrow_back"></a>
					</div>

					<div id="postview_Wrapper">
						<p>${note.title}</p>
						<div class="writer_info">

							<div class="writer">
								<c:if test="${not empty note.img}">
									<img src="${pageContext.request.contextPath}/${note.img}"
										alt="${note.nickname}">
								</c:if>
								<p>${note.nickname }</p>
								<button class="btn_liek_follow">Follow</button>
							</div>

							<div class="post_meta_info">
								<div>
									<fmt:formatDate value="${note.create_at}"
										pattern="yyyy.MM.dd HH:mm" />
								</div>
							</div>
							<div class="post_meta_info">
								<div>조회수: ${note.view_count}</div>
							</div>

							<div class="like_share">
								<div class="like">
									<img src="./sources/icons/heart.svg" alt="heart_base">
									<p>Like_sum</p>
								</div>
							</div>

						</div>

						<div class="line"></div>

						<div class="text_content">
							<p>${note.text}</p>
						</div>

					</div>
				</section>
			</div>
		</div>
	</div>
	
		<script>
  	$("#logout").on("click", function(){
  		location.href="./logout.jsp";
  	});
  </script>
</body>
</html>