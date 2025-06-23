package mvc.command.handler;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import mvc.command.service.FollowService;
import mvc.command.service.SidebarService;
import mvc.domain.dto.SidebarDTO;
import mvc.domain.dto.UserProfileViewDTO;
import mvc.domain.vo.UserSummaryVO;
import mvc.domain.vo.UserVO;

public class FollowHandler implements CommandHandler {
	
    private FollowService followService = new FollowService();
	
	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		System.out.println("> FollowHandler.process()...");
		
		String method = request.getMethod();
		
        if ("GET".equalsIgnoreCase(method)) {
            doGet(request, response);
        } else if ("POST".equalsIgnoreCase(method)) {
        	// doPost(request, response);
        	response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
        
        return null;
	}

	private void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Object result = null;
		
		HttpSession session = request.getSession(false);
		UserVO userInfo = (UserVO) session.getAttribute("userInfo");
		int userIdx = userInfo.getAc_idx();
		String action = request.getParameter("action");
		
        try {
        	if ("getFollowingCount".equals(action)){
				result = followService.getFollowingCount(userIdx);
				
			} else if ("getFollowerCount".equals(action)) {
				result = followService.getFollowerCount(userIdx);
				
			} else if ("getFollowing".equals(action)) {
				result = followService.getFollowingList(userIdx);
				
			} else if ("getFollower".equals(action)) {
				result = followService.getFollowerList(userIdx);
				
			}
        	
			out.print(gson.toJson(result));
        } catch (SQLException e) {
			e.printStackTrace();
		} finally {
            if (out != null) {
                out.flush();
            }
        }
	}

/*
	private void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
			
	}
*/
	
}