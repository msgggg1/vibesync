package mvc.command.handler;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson; // Gson 라이브러리 추가 필요 (JSON 변환용)

import mvc.command.CommandHandler;
import mvc.command.service.NoteService;
import mvc.domain.dto.NoteDTO;

public class LoadMorePostsHandler implements CommandHandler {

    private NoteService noteService = new NoteService();
    private static final int POSTS_PER_PAGE = 9; // userProfileHandler와 동일하게 유지

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8"); // JSON 응답 지정

        int ac_idx = 0;
        int page = 1;

        // 요청 파라미터에서 사용자 ID와 페이지 번호를 가져옴
        String acIdxParam = request.getParameter("ac_idx");
        String pageParam = request.getParameter("page");

        try {
            if (acIdxParam != null) {
                ac_idx = Integer.parseInt(acIdxParam);
            }
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 파라미터 형식입니다.");
            return null;
        }

        if (ac_idx <= 0 || page <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 요청입니다.");
            return null;
        }

        // 해당 페이지의 게시물 목록 조회
        List<NoteDTO> morePosts = noteService.getNotesByAcIdxPaged(ac_idx, page, POSTS_PER_PAGE);

        // Gson 라이브러리를 사용하여 List<NoteDTO>를 JSON 문자열로 변환
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(morePosts);

        // JSON 응답 전송
        response.getWriter().write(jsonResponse);

        return null; // AJAX 요청이므로 뷰 페이지로 포워딩할 필요 없음
    }
}