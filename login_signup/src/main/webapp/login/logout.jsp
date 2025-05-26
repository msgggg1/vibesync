<%@page import="java.util.Objects"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.util.DBConn"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션에서 email을 먼저 꺼내 저장
	String userEmail = Objects.toString(session.getAttribute("loggedInUserEmail"), "");
	
	// DB에서 자동 로그인 토큰 제거
	Connection conn = null;
	PreparedStatement pstmt = null;
	String sql = null;
	
	try{
        conn = DBConn.getConnection();
        sql = "UPDATE userAccount SET auto_login_token = NULL WHERE email = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userEmail);
        pstmt.executeUpdate();
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("로그아웃 실패");
	} finally {
	    if(pstmt != null) pstmt.close();
	    if(conn != null) DBConn.close();
	}
	
    // 자동 로그인 쿠키 제거
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("autoLoginToken".equals(cookie.getName())) {
                cookie.setMaxAge(0); // 삭제
                cookie.setPath("/"); // 경로 일치시켜야 삭제됨
                response.addCookie(cookie);
            }
        }
    }

    // 세션 초기화
    session.removeAttribute("loggedInEmail");

    // 캐시 방지 헤더 (옵션이지만 좋음)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h3>로그아웃 성공</h3>
	<a href="login.jsp">로그인 페이지로 돌아가기</a>

</body>
</html>