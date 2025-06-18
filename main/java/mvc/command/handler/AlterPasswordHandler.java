package mvc.command.handler;

import java.io.PrintWriter;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import mvc.command.service.SettingService;
import mvc.domain.vo.UserVO;

public class AlterPasswordHandler implements CommandHandler {

    private SettingService settingService = new SettingService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        HttpSession session = request.getSession(false);
        UserVO loginUser = (session != null) ? (UserVO) session.getAttribute("userInfo") : null;

        if (loginUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(Map.of("success", false, "message", "로그인이 필요합니다.")));
            return null;
        }

        String newPassword = request.getParameter("newPassword");
        if (newPassword == null || newPassword.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(Map.of("success", false, "message", "새 비밀번호를 입력해주세요.")));
            return null;
        }

        try {
            boolean success = settingService.alterUserPassword(loginUser.getAc_idx(), newPassword);
            if (success) {
                out.print(gson.toJson(Map.of("success", true)));
            } else {
                throw new Exception("비밀번호 변경에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("success", false, "message", "서버 오류로 비밀번호 변경에 실패했습니다.")));
        } finally {
            if (out != null) out.flush();
        }
        
        return null;
    }
}