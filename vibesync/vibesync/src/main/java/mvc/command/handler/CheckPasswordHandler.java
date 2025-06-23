package mvc.command.handler;

import java.io.PrintWriter;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import mvc.command.service.SettingService;
import mvc.domain.vo.UserVO;

public class CheckPasswordHandler implements CommandHandler {

    private SettingService settingService = new SettingService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        UserVO loginUser = (session != null) ? (UserVO) session.getAttribute("userInfo") : null;
        System.out.println(loginUser);
        if (loginUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
            response.getWriter().write("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
            return null;
        }

        String inputPassword = request.getParameter("password");
        if (inputPassword == null || inputPassword.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
            response.getWriter().write("{\"success\": false, \"message\": \"비밀번호를 입력해주세요.\"}");
            return null;
        }
        
        try {
            Map<String, Object> result = settingService.checkUserPasswordAndGetData(loginUser.getAc_idx(), inputPassword);
            String jsonResponse = new Gson().toJson(result);
            
            PrintWriter out = response.getWriter();
            out.print(jsonResponse);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }

        return null; // AJAX 핸들러는 view를 반환하지 않음
    }
}