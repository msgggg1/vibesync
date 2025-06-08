<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="mvc.domain.vo.PageVO" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 서블릿(ListHandler)에서 설정해준 속성들
    List<PageVO> list       = (List<PageVO>) request.getAttribute("list");
    int totalCount          = (Integer) request.getAttribute("totalCount");
    int currentPage         = (Integer) request.getAttribute("currentPage");
    int pageSize            = (Integer) request.getAttribute("pageSize");
    String searchType       = (String)  request.getAttribute("searchType");
    String keyword          = (String)  request.getAttribute("keyword");

    // 전체 페이지 수 계산
    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>게시물 목록</title>
  <link rel="stylesheet" href="./css/style.css">
  <link rel="icon" href="./sources/favicon.ico" />
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="board">
    <div class="notion-app-inner">
      <jsp:include page="./includes/sidebar.jsp" flush="true" />

      <!-- content -->
      <div id="content_wrapper">
        <section id="content">
          <div class="back_icon">
            <a href="#"><img src="./sources/icons/arrow_back.svg" alt="arrow_back"></a>
          </div>
          
          <!-- top -->
          <div id="board_all">
            <div class="board_info">
              <p>Title</p>
            </div>

            <div class="line"></div>

            <div id="board_list">
              <section id="page-board-full" class="page">
                <div class="full-list subfont" id="full-list">
                  <c:forEach var="vo" items="${list}">
                    <div class="full-post" data-post-id="${vo.userpg_idx}">
                      <div class="post-index">${vo.userpg_idx}</div>
                      <div class="post-title"><c:out value="${vo.subject}"/></div>
                    </div>
                  </c:forEach>
                  <c:if test="${empty list}">
                    <p>게시물이 없습니다.</p>
                  </c:if>
                </div>
                
                <!-- 검색 바 -->
	            <div class="search-bar" style="margin: 16px 0;">
	              <form action="page.do" method="get">
	                <select name="searchType">
	                  <option value="subject" ${searchType=='subject' ? 'selected':''}>제목</option>
	                  <option value="content" ${searchType=='content' ? 'selected':''}>내용</option>
	                  <option value="subject_content" ${searchType=='subject_content'? 'selected':''}>제목+내용</option>
	                </select>
	                <input type="text" name="keyword" value="<c:out value='${keyword}'/>" placeholder="검색어 입력"/>
	                <button type="submit">검색</button>
	                <button><a href="page.do">list</a></button>
	              </form>
	            </div>
            

                <!-- 서버사이드 페이징 -->
                <div class="pagination" id="pagination" style="font-weight: bold;">
                  <c:if test="${currentPage > 1}">
				      <a href="?page=${currentPage-1}&size=${pageSize}&searchType=${searchType}&keyword=${keyword}">Prev</a>
				    </c:if>
				    <c:forEach begin="1" end="<%= totalPages %>" var="p">
				      <c:choose>
				        <c:when test="${p == currentPage}">
				          <strong>${p}</strong>
				        </c:when>
				        <c:otherwise>
				          <a href="?page=${p}&size=${pageSize}&searchType=${searchType}&keyword=${keyword}">${p}</a>
				        </c:otherwise>
				      </c:choose>
				    </c:forEach>
				    <c:if test="${currentPage < totalPages}">
				      <a href="?page=${currentPage+1}&size=${pageSize}&searchType=${searchType}&keyword=${keyword}">Next</a>
				    </c:if>
                </div>

              </section>
            </div>
          </div>
        </section>
      </div>
    </div>
  </div>
</body>
</html>
