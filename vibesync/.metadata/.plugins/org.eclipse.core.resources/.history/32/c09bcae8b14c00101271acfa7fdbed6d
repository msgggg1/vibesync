package mvc.command.handler;

import java.io.PrintWriter;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import mvc.command.service.SettingService;
import mvc.domain.vo.UserVO;

public class SetProfileHandler implements CommandHandler {

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

        try {
            // [수정] Part 대신 Base64 문자열 파라미터를 받음
            String base64Image = request.getParameter("profileImageBase64");
            System.out.println("base64Image : " + base64Image);
            if (base64Image == null || base64Image.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(Map.of("success", false, "message", "이미지 데이터가 없습니다.")));
                return null;
            }

            String realPath = request.getServletContext().getRealPath("/");
            String newImagePath = settingService.updateProfileImage(loginUser.getAc_idx(), base64Image, realPath);
            
            System.out.println("newImagePath : " + newImagePath);
            if (newImagePath != null) {
                // 세션 정보 업데이트
                loginUser.setImg(newImagePath);
                session.setAttribute("userInfo", loginUser);
                
                out.print(gson.toJson(Map.of("success", true, "newImagePath", newImagePath)));
            } else {
                throw new Exception("프로필 이미지 업데이트에 실패했습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("success", false, "message", e.getMessage())));
        } finally {
            if (out != null) out.flush();
        }

        return null;
    }
}