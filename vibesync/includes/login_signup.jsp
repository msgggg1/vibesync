<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

String email = request.getParameter("userId");
String pw = request.getParameter("userPw");

String mode = request.getParameter("mode");

System.out.printf("email = %s, pw = %s, mode = %s", email, pw, mode);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>