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

public class SidebarHandler implements CommandHandler {
	
	private SidebarService sidebarService = new SidebarService();
    private FollowService followService = new FollowService();
	
	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		System.out.println("> SidebarHandler.process()...");
		
		String method = request.getMethod();
		
        if ("GET".equalsIgnoreCase(method)) {
            doGet(request, response);
        } else if ("POST".equalsIgnoreCase(method)) {
        	response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            // doPost(request, response);
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
        try {
    		SidebarDTO sidebarDTO = sidebarService.loadSidebar(userIdx);
    		
    		UserProfileViewDTO userProfile = sidebarDTO.getUserProfile();
            if (userProfile == null) { // UserProfileViewDTO가 null일 경우 새로 생성
                userProfile = new UserProfileViewDTO();
            }
            userProfile.setNickname(userInfo.getNickname());
    		userProfile.setImg(userInfo.getImg());
			userProfile.setFollowingCount(followService.getFollowingCount(userIdx));
	        userProfile.setFollowerCount(followService.getFollowerCount(userIdx));
			
			sidebarDTO.setUserProfile(userProfile);
			result = sidebarDTO;
        	
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
