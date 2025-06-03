package mvc.controller;

import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
// import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvc.command.CommandHandler;

public class DispatcherServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public DispatcherServlet() {
        super();
    }

	@Override
	public void destroy() {
		super.destroy();
		System.out.println("> DispatcherServlet.destroy()...");
	}

	
	// Map 선언 : key=url, value=모델 객체를 생성해서 
	public Map<String, CommandHandler> commandHandlerMap = new HashMap<String, CommandHandler>();
	
	@Override
	public void init() throws ServletException {
		super.init();
		System.out.println("> DispatcherServlet.init()...");
		String mappingPath = this.getInitParameter("mappingPath");
		// > mappingPath : /WEB-INF/commandHandler.properties
		String realPath = this.getServletContext().getRealPath(mappingPath);
		// > realPath : C:\Class\JSPClass\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\jspPro\WEB-INF\commandHandler.properties
		
		// Properties 확장자이기 때문에 Properties클래스 사용
		Properties prop = new Properties();
		
		try( FileReader reader = new FileReader(realPath) ) {			
			prop.load(reader);
		} catch (Exception e) {
			throw new ServletException();
		}
		
		// 명령 객체 만들기
		Set<Entry<Object, Object>> set = prop.entrySet();
		Iterator<Entry<Object, Object>> ir = set.iterator();
		
		while(ir.hasNext()) {
			Entry<Object, Object> entry = ir.next();
			String url = (String)entry.getKey(); // /board/list.do
			String fullName = (String)entry.getValue(); // days08.mvc.command.ListHandler
			
			Class<?> commandHandlerClass = null;
	         try {
	            commandHandlerClass = Class.forName(fullName);
	            try {
	               CommandHandler handler = (CommandHandler) commandHandlerClass.newInstance();
	               this.commandHandlerMap.put(url, handler); // 맵 추가
	            } catch (InstantiationException e) { 
	               e.printStackTrace();
	            } catch (IllegalAccessException e) { 
	               e.printStackTrace();
	            }
	         } catch (ClassNotFoundException e) { 
	            e.printStackTrace();
	         }
		} // while
		
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String contextPath = request.getContextPath();
		// 2. 클라이언트가 요구하는 기능을 분석한다 -> 들어올 때 요청한 주소를 확인한다
		
		// ContextPath 밑에 값만 저장
		String requestURI = request.getRequestURI();
		// 전체 주소
		// request.getRequestURL();
		
		// ContextPath 제거
		int beginIndex = request.getContextPath().length(); // /jspPro문자열
		requestURI = requestURI.substring(beginIndex);
		
		// 3. 로직 처리하는 모델 객체를 commandHandlerMap으로부터 얻어온다.
		CommandHandler handler = this.commandHandlerMap.get(requestURI);
			
		String view = null;
		try {
			view = handler.process(request, response); // throws Exception로 인해 여기서 처리해야되기 때문에
			view = contextPath + view;

			System.out.println(view);
			// 4. request, session 객체 결과를 저장
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// 5단계 ~ 뷰 출력(포워딩, 리다이렉트)
		if (view != null) {
			response.sendRedirect(view);
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
