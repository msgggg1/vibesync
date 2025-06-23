package mvc.command.handler;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Objects;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import mvc.command.service.SettingService;
import mvc.domain.vo.UserVO;

public class SettingHandler implements CommandHandler {

	SettingService settingService = new SettingService();
	
	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("> SettingHandler.process()...");
		
		String method = request.getMethod();
        
        if ("GET".equalsIgnoreCase(method)) {
            doGet(request, response);
        } else if ("POST".equalsIgnoreCase(method)) {
            doPost(request, response);
        } else {
            // 허용되지 않은 메소드에 대한 처리
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
		
		return null;
	}

	private void doGet(HttpServletRequest request, HttpServletResponse response) {
		// 라이트/다크 모드 외 설정 관련 (라이트/다크 모드는 theme.js에서 커버)
		
	}

	private void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		// 설정 업데이트
		HttpSession session = request.getSession(false);
		UserVO userInfo = (UserVO) session.getAttribute("userInfo");
		int userAcIdx = userInfo.getAc_idx();
		String theme = Objects.toString(request.getParameter("theme"), "light");
		
		settingService.setTheme(userAcIdx, theme);
		
		session.setAttribute("theme", theme);
	}

}
