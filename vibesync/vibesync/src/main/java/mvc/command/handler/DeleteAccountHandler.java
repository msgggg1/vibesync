package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mvc.command.service.SettingService;
import mvc.domain.vo.UserVO;

public class DeleteAccountHandler implements CommandHandler {

    private SettingService settingService = new SettingService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        UserVO loginUser = (session != null) ? (UserVO) session.getAttribute("userInfo") : null;

        if (loginUser == null) {
            // 로그인되어 있지 않으면 로그인 페이지로
            response.sendRedirect(request.getContextPath() + "/vibesync/user.do");
            return null;
        }

        try {
        	String rootPath = request.getServletContext().getRealPath("/") + "vibesync/";
            settingService.deleteUserAccount(loginUser.getAc_idx(), rootPath);

            // 세션 무효화
            session.invalidate();

            // 성공 후 메인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/vibesync/user.do");

        } catch (Exception e) {
            e.printStackTrace();
            // 실패 시 에러 페이지 또는 이전 페이지로 리다이렉트 (필요에 따라 구현)
            // 여기서는 간단하게 다시 유저페이지로 보냅니다.
            response.sendRedirect(request.getContextPath() + "/vibesync/userPage.do?acIdx=" + loginUser.getAc_idx());
        }

        return null; // 리다이렉트 하므로 null 반환
    }
}