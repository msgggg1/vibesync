<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%
    try {
        // 파일 저장 경로 설정
        String savePath = application.getRealPath("/project/source");
        File dir = new File(savePath);
        if (!dir.exists()) {
            dir.mkdirs(); // 디렉토리가 없으면 생성
        }
        
        int maxSize = 5 * 1024 * 1024; // 5MB
        String encoding = "UTF-8";
        
        // MultipartRequest 생성
        MultipartRequest multi = new MultipartRequest(
            request, savePath, maxSize, encoding, new DefaultFileRenamePolicy()
        );
        
        // 업로드된 파일 이름 가져오기
        String fileName = multi.getFilesystemName("file");
        
        // 파일 URL 생성
        String url = request.getContextPath() + "/project/source/" + fileName;
        
        // 클라이언트에 URL 반환
        out.print(url);
    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(500);
        out.print("파일 업로드 실패: " + e.getMessage());
    }
%>