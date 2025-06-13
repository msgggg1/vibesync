package mvc.command.handler;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.Enumeration;
import java.util.HashSet; // 수정: 세션에 저장할 Set 사용
import java.util.Set;      // 수정: 세션에 저장할 Set 사용

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; // 수정: 세션 사용을 위한 import

import com.util.ConnectionProvider;
import mvc.command.service.PostViewService;
import mvc.domain.dto.UserNoteDTO;
import mvc.domain.vo.UserNoteVO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.UserNoteDAO;
import mvc.persistence.daoImpl.UserNoteDAOImpl;

public class postViewHandler implements CommandHandler {
    
    private PostViewService postviews = new PostViewService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        String method = request.getMethod(); // 요청 메소드 확인 (GET 또는 POST)

        // POST 요청은 AJAX (팔로우/좋아요) 처리
        if ("POST".equalsIgnoreCase(method)) {
            response.setContentType("application/json; charset=UTF-8");
            String action = request.getParameter("action");

            if ("toggleFollow".equals(action)) {
                System.out.println(">>> postViewHandler.process(): toggleFollow 호출됨");
                handleToggleFollow(request, response);
            } else if ("toggleLike".equals(action)) {
                System.out.println(">>> postViewHandler.process(): toggleLike 호출됨");
                handleToggleLike(request, response);
            } else {
                // 정의되지 않은 action에 대한 오류 처리
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                try (PrintWriter out = response.getWriter()) {
                    out.write("{\"error\":\"Invalid action\"}");
                    out.flush();
                }
            }
            return null; // AJAX 처리 후 forward 방지

        // GET 요청은 페이지 렌더링 처리
        } else if ("GET".equalsIgnoreCase(method)) {
            System.out.println("> postViewHandler.process() - 일반 페이지 요청 (GET)");
            response.setContentType("text/html; charset=UTF-8");

            String note_idx_str = request.getParameter("nidx");
            if (note_idx_str == null || note_idx_str.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Note index is required.");
                return null;
            }
            int note_idx = Integer.parseInt(note_idx_str);

            // --- 기존 페이지 로드 로직 시작 ---
            HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            Set<Integer> accessPage = (Set<Integer>) session.getAttribute("accessPage");
            if (accessPage == null) {
                accessPage = new HashSet<>();
                session.setAttribute("accessPage", accessPage);
            }

            if (!accessPage.contains(note_idx)) {
                postviews.updateViewCount(note_idx);
                accessPage.add(note_idx);
            }

            UserNoteVO note = postviews.getUserNoteInfo(note_idx);
            request.setAttribute("note", note);

            UserVO user = (UserVO) session.getAttribute("userInfo");
            if (user != null) {
                UserNoteDTO followLike = postviews.getFollowLike(user.getAc_idx(), note_idx, note.getUpac_idx());
                request.setAttribute("followLike", followLike);
            }
            // --- 기존 페이지 로드 로직 끝 ---

            return "postView.jsp"; // JSP 페이지로 forward
        }

        // GET/POST가 아닌 다른 메소드는 에러 처리
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return null;
    }

    private void handleToggleFollow(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            UserNoteDAO dao = new UserNoteDAOImpl(conn);

            int userIdx = Integer.parseInt(request.getParameter("userIdx"));
            int writerIdx = Integer.parseInt(request.getParameter("writerIdx"));
            int noteIdx = Integer.parseInt(request.getParameter("nidx"));

            // 로그로 파라미터 값 확인
            System.out.println(">>> handleToggleFollow - userIdx: " + userIdx + ", writerIdx: " + writerIdx + ", noteIdx: " + noteIdx);

            boolean following = dao.isFollowing(userIdx, writerIdx);
            if (following) {
                dao.deleteFollow(userIdx, writerIdx);
                following = false;
            } else {
                dao.addFollow(userIdx, writerIdx);
                following = true;
            }

            out.write("{\"following\":" + following + "}");
        } catch (NamingException | java.sql.SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\":\"Unable to toggle follow\"}");
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            out.flush();
            out.close();
        }
    }

    private void handleToggleLike(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            UserNoteDAO dao = new UserNoteDAOImpl(conn);

            int userIdx = Integer.parseInt(request.getParameter("userIdx"));
            int noteIdx = Integer.parseInt(request.getParameter("noteIdx"));

            // 로그로 파라미터 값 확인
            System.out.println(">>> handleToggleLike - userIdx: " + userIdx + ", noteIdx: " + noteIdx);

            boolean liked = dao.isLiked(userIdx, noteIdx);
            if (liked) {
                dao.deleteLike(userIdx, noteIdx);
                liked = false;
            } else {
                dao.addLike(userIdx, noteIdx);
                liked = true;
            }

            out.write("{\"liked\":" + liked + "}");
        } catch (NamingException | java.sql.SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\":\"Unable to toggle like\"}");
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            out.flush();
            out.close();
        }
    }
}