package mvc.command.handler; 

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mvc.command.handler.CommandHandler;
import mvc.command.service.NoteService; 
import mvc.command.service.UserService;
import mvc.domain.dto.NoteDTO; // 게시물 미리보기에 사용될 DTO 
import mvc.domain.dto.UserProfileViewDTO;
import mvc.domain.vo.UserVO;


public class UserProfileHandler implements CommandHandler {

    private UserService userService = new UserService();
    private NoteService noteService = new NoteService();
    
    // 한 번에 로드할 게시물 수 (9개)
    private static final int POSTS_PER_PAGE = 9;

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false); // 세션이 없으면 새로 만들지 않음

        String userIdParam = request.getParameter("userId"); // 다른 사용자 프로필 조회 시 URL 파라미터 (예: /profile.do?userId=123)
        int ac_idx = 0;

        UserVO loggedInUser = null;
        if (session != null) {
            loggedInUser = (UserVO) session.getAttribute("userInfo");
        }

        if (userIdParam != null && !userIdParam.isEmpty()) {
            try {
            	ac_idx = Integer.parseInt(userIdParam);
            } catch (NumberFormatException e) {
                // 잘못된 사용자 ID 형식
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 사용자 ID 형식입니다.");
                return null; // 에러 발생 시 null 반환 
            }
        } else if (loggedInUser != null) {
            // URL 파라미터가 없고, 로그인된 사용자가 있는 경우 (자신의 프로필 보기)
            if (loggedInUser.getAc_idx() == 0) { // ac_idx가 없다면 로그인 페이지로 (또는 에러)
                response.sendRedirect(request.getContextPath() + "/vibesync/user.do");
                 return null;
            }
            ac_idx = loggedInUser.getAc_idx();
        } else {
            // 프로필을 볼 사용자 ID도 없고, 로그인도 되어있지 않은 경우 -> 로그인 페이지로 리디렉션
            response.sendRedirect(request.getContextPath() + "/vibesync/user.do"); 
            return null;
        }

        if (ac_idx <= 0) {
            // 유효하지 않은 사용자 ID
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "사용자를 찾을 수 없습니다.");
            return null;
        }

        // 1. 사용자 프로필 정보 조회
        System.out.println("ac_idx : "+ ac_idx);
        UserProfileViewDTO userProfile = userService.getUserProfileForView(ac_idx, loggedInUser);

        if (userProfile == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "사용자 프로필을 찾을 수 없습니다.");
            return null;
        }

     // 2. 해당 사용자의 게시물 목록 조회 (첫 페이지: 1페이지, 9개)
        List<NoteDTO> userPosts = noteService.getNotesByAcIdxPaged(ac_idx, 1, POSTS_PER_PAGE);

        // 3. 해당 사용자의 전체 게시물 수 조회 (무한 스크롤에서 더 불러올 게시물이 있는지 판단하기 위해 필요)
        int totalPosts = noteService.getUserNoteCount(ac_idx);

        // 4. 조회된 데이터를 request attribute에 저장
        request.setAttribute("userProfile", userProfile);
        request.setAttribute("userPosts", userPosts);
        request.setAttribute("currentPage", 1); // 현재 페이지 번호 (초기 로드)
        request.setAttribute("postsPerPage", POSTS_PER_PAGE); // 페이지당 게시물 수
        request.setAttribute("totalPosts", totalPosts); // 전체 게시물 수
        request.setAttribute("targetUserAcIdx", ac_idx); // JavaScript에서 사용할 사용자 ID

        // 5. 사용자 프로필 JSP 페이지로 포워딩
        return "/vibesync/profile.jsp"; // 실제 JSP 파일 경로에 맞게 수정하세요.
    }
}