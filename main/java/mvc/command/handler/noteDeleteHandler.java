package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.vo.NoteVO; // NoteVO 임포트
import mvc.persistence.dao.UserNoteDAO; // UserNoteDAO 임포트
import mvc.persistence.daoImpl.UserNoteDAOImpl;
import java.io.File; // File 클래스 임포트
import java.sql.Connection;

public class noteDeleteHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String noteIdxStr = request.getParameter("noteidx");
        int noteIdx = Integer.parseInt(noteIdxStr);

        Connection conn = null;
        
        try {
            conn = ConnectionProvider.getConnection();
            UserNoteDAO dao = new UserNoteDAOImpl(conn);

            // 1. DB에서 삭제하기 전에 노트 정보를 먼저 가져옴
            NoteVO note = dao.getNote(noteIdx);

            if (note != null) {
                // 웹 애플리케이션의 실제 경로를 가져옴
                String rootPath = request.getServletContext().getRealPath("/");

                // 2. 썸네일 이미지 파일 삭제
                String titleImgPath = note.getTitleImg();
                if (titleImgPath != null && !titleImgPath.isEmpty()) {
                    File titleImgFile = new File(rootPath, titleImgPath);
                    if (titleImgFile.exists()) {
                        titleImgFile.delete();
                    }
                }

                // 3. 본문 이미지 파일들 삭제 (| 구분자 기준)
                String contentImgsPath = note.getImg();
                if (contentImgsPath != null && !contentImgsPath.isEmpty()) {
                    String[] imgPaths = contentImgsPath.split("\\|"); // 정규식이므로 \\| 사용
                    for (String path : imgPaths) {
                        if (path != null && !path.trim().isEmpty()) {
                            File contentImgFile = new File(rootPath, path.trim());
                            if (contentImgFile.exists()) {
                                contentImgFile.delete();
                            }
                        }
                    }
                }
            }

            // 4. DB에서 노트 레코드 삭제
            dao.deleteNote(noteIdx);
            
        } catch (Exception e) {
            // 예외 처리 (예: 로깅)
            e.printStackTrace();
            // 필요 시 에러 페이지로 리다이렉트
        } finally {
            if (conn != null) try { JdbcUtil.close(conn); } catch(Exception ignored) {}
        }

        response.sendRedirect("page.do");
        return null;
    }
}