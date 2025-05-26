package days02;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// 서블릿 클래스 
public class Now extends HttpServlet{

   @Override
   protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      super.doGet(req, resp);
   }

   @Override
   protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      super.doPost(req, resp);
   }

   @Override
   protected void service(HttpServletRequest request
         , HttpServletResponse response) throws ServletException, IOException {
	   response.setContentType("text/html; charset=utf-8");
      // jsp 페이지 : JspWriter out 객체, <%= %> 출력
      PrintWriter out = response.getWriter();
      
      Date now = new Date();
      String pattern = "yyyy-MM-dd hh:mm:ss";
      SimpleDateFormat sdf = new SimpleDateFormat(pattern);
      String strNow = sdf.format(now);
      
      out.write("<!DOCTYPE html>");
      out.write("<html>");
      out.write("<head>");
      out.write("<meta charset='UTF-8'>");
      out.write("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
      out.write("<title>2025. 5. 22. 오후 3:35:05</title>");
      out.write("<link rel='shortcut icon' type='image/x-icon' href='http://localhost:8081/webPro/images/SiSt.ico'>");
      out.write("<link rel='stylesheet' href='http://localhost:8081/jspPro/resources/cdn-main/example.css'>");
      out.write("<script src='http://localhost:8081/jspPro/resources/cdn-main/example.js'></script>");
      out.write("<style>");
      out.write(" span.material-symbols-outlined{");
      out.write("    vertical-align: text-bottom;");
      out.write(" }   ");
      out.write("</style>");
      out.write("</head>");
      out.write("<body>");
      out.write("<header>");
      out.write("  <h1 class='main'><a href='#' style='position: absolute;top:30px;'>kEnik HOme</a></h1>");
      out.write("  <ul>");
      out.write("    <li><a href='#'>로그인</a></li>");
      out.write("    <li><a href='#'>회원가입</a></li>");
      out.write("  </ul>");
      out.write("</header>");
      out.write("<div>");
      out.write("  <xmp class='code'>"); 
      out.write("   ");
      out.write("  </xmp>");
      
      out.write("<h3> 현재 날짜 시간 : " + strNow + "</h3>");
      
      out.write("</div>");
      out.write("</body>");
      out.write("</html>");  
   }
}





