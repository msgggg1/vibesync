package org.doit.svl;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.doit.dao.UserNoteDAO;

/**
 * Servlet implementation class ToggleLikeServlet
 */
@WebServlet("/toggleLike")
public class ToggleLikeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ToggleLikeServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		System.out.println("> toggleLike : doPost...");
		
		String contextPath = request.getContextPath();
		int noteIdx = Integer.parseInt(request.getParameter("noteIdx"));
        int userIdx = Integer.parseInt(request.getParameter("userIdx"));
        // 이미 좋아요가 있는지 체크
        boolean liked = UserNoteDAO.isLiked(userIdx, noteIdx);

        if (liked) {
            UserNoteDAO.deleteLike(userIdx, noteIdx);
        } else {
            UserNoteDAO.addLike(userIdx, noteIdx);
        }
        response.sendRedirect(contextPath + "/vibesync/postView.jsp?note_idx=" + noteIdx);
	}

}
