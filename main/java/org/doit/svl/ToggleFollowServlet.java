// 2. ToggleFollowServlet.java
package org.doit.svl;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.doit.dao.UserNoteDAO;

@WebServlet("/toggleFollow")
public class ToggleFollowServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ToggleFollowServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String contextPath = request.getContextPath();
        int userIdx = Integer.parseInt(request.getParameter("userIdx"));
        int writerIdx = Integer.parseInt(request.getParameter("writerIdx"));

        // 이미 팔로우 중인지 체크
        boolean following = UserNoteDAO.isFollowing(userIdx, writerIdx);

        if (following) {
        	UserNoteDAO.deleteFollow(userIdx, writerIdx);
        } else {
        	UserNoteDAO.addFollow(userIdx, writerIdx);
        }
        // 팔로우 토글 후 원래 화면(예: postView.jsp)으로 돌아간다
        int noteIdx = Integer.parseInt(request.getParameter("noteIdx"));
        response.sendRedirect(contextPath + "/vibesync/postView.jsp?note_idx=" + noteIdx);
    }
}
