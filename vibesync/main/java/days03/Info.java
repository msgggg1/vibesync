package days03;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(
		description = "두 번째 서블릿", 
		urlPatterns = { 
				"/info", 
				"/method/info.html"
		})
public class Info extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public Info() {
    }

    // doGet => get방식으로 서블릿을 요청
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		System.out.println("> Info.doGet()... 호출됨");
		
		PrintWriter out = response.getWriter();
		String name = request.getParameter("name");
		System.out.println("name : " + name);
		int age = Integer.parseInt(request.getParameter("age"));
		out.println("<html>");
		out.println("<head>");
		out.println("<title>2025. 5. 23. 오후 12:15:36</title>");
		out.println("<body>");
		out.println("> 이름 : " + name + "<br>");
		out.println("> 나이 : " + age + "<br>");
		out.println("</body>");
		out.println("</html>");
	}

	// doPost => post 방식으로 서블릿 요청
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		System.out.println("> Info.doPost()... 호출됨");
		
		PrintWriter out = response.getWriter();
		String name = request.getParameter("name");
		System.out.println("name : " + name);
		int age = Integer.parseInt(request.getParameter("age"));
		out.println("<html>");
		out.println("<head>");
		out.println("<title>2025. 5. 23. 오후 12:15:36</title>");
		out.println("<body>");
		out.println("> 안녕하세요 <br>");
		out.println("> 이름 : " + name + "<br>");
		out.println("> 나이 : " + age + "<br>");
		out.println("</body>");
		out.println("</html>");
	}

}
