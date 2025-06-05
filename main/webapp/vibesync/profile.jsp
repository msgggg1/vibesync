<!DOCTYPE html>
<%@page import="mvc.domain.vo.UserVO"%>
<html lang="ko">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${userProfileData.nickname}</title>

  <link rel="stylesheet" href="./css/style.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script> 
  <script defer src="./js/script.js"></script>

</head>
<body>
  <div id="notion-app">
    <input type="hidden" id="mode" value="user">
    <div class="notion-app-inner">
      <jsp:include page="./includes/sidebar.jsp" flush="true"></jsp:include>
      
      <!-- content -->
      <div id="content_wrapper">
        <section id="content">
          <div id="user_wrapper">
            <div id="userInfo">
    
              <div class="user_profile_img">
                <img src="${userProfile.img}" alt="">
              </div>
    
              <div class="userInfo_detail">
                <div class="name_function">
                  <p>${userProfile.nickname}</p>
                  <button class="btn_follow_1">Follow</button>
                  <button class="btn_follow_2">Watch Party</button>
                </div>
                <div class="user_count">
                  <p>Post <span>${userProfileData.postCount}</span></p>
                  <p>Follower <span>${userProfileData.followerCount}</span></p>
                  <p>Following <span>${userProfileData.followingCount}</span></p>
                </div>
              </div>
            </div>
    
            <div class="line"></div>
    
            <div id="con_wrapper">
              <c:forEach var="note" items="${userPosts}">
                   <div class="con_item" data-note-idx="${note.note_idx}">
                       <img src="${note.img}" alt="${note.title}">
                       <p>${note.title}</p>
                   </div>
              </c:forEach>
            </div>
            
          </div>
  
  
        </section>
      </div>
    </div>
  </div>
  
   <script>
        // JavaScript for Infinite Scroll
        $(document).ready(function() {
            // 서버에서 전달받은 초기 데이터 설정
            let currentPage = ${currentPage}; // 현재 페이지 (UserProfileHandler에서 1로 초기화)
            const postsPerPage = ${postsPerPage}; // 페이지당 게시물 수 (UserProfileHandler에서 9로 설정)
            const totalPosts = ${totalPosts}; // 전체 게시물 수
            const targetUserAcIdx = ${targetUserAcIdx}; // 조회할 사용자 ID

            let isLoading = false; // AJAX 요청 중인지 나타내는 플래그

            // 더 이상 불러올 게시물이 있는지 확인하는 함수
            function hasMorePosts() {
                // (현재까지 로드된 게시물 수) < (전체 게시물 수)
                return (currentPage * postsPerPage) < totalPosts;
            }

            // 게시물을 동적으로 로드하는 함수
            function loadMorePosts() {
                // 이미 로딩 중이거나 더 이상 게시물이 없으면 함수 실행 중단
                if (isLoading || !hasMorePosts()) {
                    return;
                }

                isLoading = true; // 로딩 시작
                $('#loadingIndicator').show(); // 로딩 인디케이터 표시

                currentPage++; // 다음 페이지 번호 증가

                // AJAX 요청 (LoadMorePostsHandler로 보낼 요청)
                $.ajax({
                    url: '${pageContext.request.contextPath}/loadMorePosts.do', // 추가 게시물을 가져올 URL
                    type: 'GET',
                    data: {
                        ac_idx: targetUserAcIdx, // 어느 사용자의 게시물을 가져올지
                        page: currentPage,       // 몇 번째 페이지를 가져올지
                        pageSize: postsPerPage   // 페이지당 몇 개를 가져올지
                    },
                    dataType: 'json', // 서버로부터 JSON 데이터를 받을 것임을 명시
                    success: function(response) {
                        $('#loadingIndicator').hide(); // 로딩 인디케이터 숨김
                        isLoading = false; // 로딩 완료

                        if (response && response.length > 0) {
                            // 받아온 게시물 데이터를 반복하여 화면에 추가
                            response.forEach(function(note) {
                                const postItem = `
                                    <div class="con_item" data-note-idx="${note.note_idx}">
                                        <img src="${note.img}" alt="${note.title}">
                                        <p>${note.title}</p>
                                    </div>
                                `;
                                $('#con_wrapper').append(postItem); // 게시물 그리드 컨테이너에 추가
                            });
                        } else {
                            // 더 이상 불러올 게시물이 없을 때 (선택적으로 메시지 표시)
                            console.log("모든 게시물을 불러왔습니다.");
                        }
                    },
                    error: function(xhr, status, error) {
                        $('#loadingIndicator').hide();
                        isLoading = false;
                        console.error("게시물을 불러오는 중 오류 발생:", error);
                        // 사용자에게 오류 메시지 표시
                        alert("게시물을 불러오는 중 오류가 발생했습니다.");
                    }
                });
            }

            // 스크롤 이벤트 리스너: 페이지 하단에 도달했는지 감지
            $(window).scroll(function() {
                // 문서의 끝에서 100px 정도 여유를 두고 감지
                if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
                    loadMorePosts();
                }
            });

            // 페이지 로드 시, 화면에 게시물이 다 채워지지 않을 경우 자동으로 다음 게시물 로드 시도
            // (화면 높이가 문서 높이보다 클 경우, 즉 스크롤이 없는 경우)
            if (hasMorePosts() && $(document).height() <= $(window).height()) {
                loadMorePosts();
            }

            // 로그아웃 버튼 이벤트 리스너 (기존 코드 유지)
            $("#logout > button").on("click", function() {
                location.href="${pageContext.request.contextPath}/logout.do"; // logout.jsp 대신 logout.do로 변경
            });

        });
    </script>
</body>
</html>