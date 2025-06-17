package mvc.command.handler;

import java.io.IOException;
import java.io.PrintWriter;
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
	
	SidebarDTO sidebarDTO = null;
	
	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		System.out.println("> SidebarHandler.process()...");
		
		String method = request.getMethod();
		
        if ("GET".equalsIgnoreCase(method)) {
            doGet(request, response);
        } else if ("POST".equalsIgnoreCase(method)) {
            doPost(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
        
        return null;
	}

	private void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
		UserVO userInfo = (UserVO) session.getAttribute("userInfo");
		int userIdx = userInfo.getAc_idx();
		
		SidebarService sidebarService = new SidebarService();
		sidebarDTO = sidebarService.loadSidebar(userIdx);
		
		UserProfileViewDTO UserProfileViewDTO = sidebarDTO.getUserProfile();
		UserProfileViewDTO.setNickname(userInfo.getNickname());
		System.out.println("> nickname : " + userInfo.getNickname());
		UserProfileViewDTO.setImg(userInfo.getImg());
		
		sidebarDTO.setUserProfile(UserProfileViewDTO);
		
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = null;
        Gson gson = new Gson();
        Object result = null;
		
		result = sidebarDTO;
		System.out.println(result.toString());
        
        request.setAttribute("sidebarDTO", sidebarDTO);
		
        out = response.getWriter();
		out.print(gson.toJson(result));
	}

	private void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String action = request.getParameter("action");
		
		if ("getFollowing".equals(action)) {
	        try {
	        	List<UserSummaryVO> followingList = sidebarDTO.getFollowingList();
	            
	            StringBuilder sb = new StringBuilder();
	            sb.append("{\"followingList\":[");

	            for (int i = 0; i < followingList.size(); i++) {
	            	UserSummaryVO u = followingList.get(i);
	                sb.append("{")
	                  .append("\"ac_idx\":").append(u.getAc_idx()).append(",")
	                  .append("\"nickname\":\"").append(u.getNickname()).append("\",")
	                  .append("\"profile_img\":\"").append(u.getProfile_img()).append("\",")
	                  .append("\"category_idx\":").append(u.getCategory_idx())
	                  .append("}");
	                if (i < followingList.size() - 1) {
	                    sb.append(",");
	                }
	            }

	            sb.append("]}");
	            
		         // 4) JSON 응답 
	            response.setContentType("application/json;charset=UTF-8");
	            PrintWriter out = response.getWriter();
	            out.write(sb.toString());
	            out.flush();
	            System.out.println(sb.toString());
	            // AJAX용이므로 JSP 포워딩 없이 바로 null 리턴
	            
	        } catch (NumberFormatException e) {
	            // useridx가 잘못된 경우, 빈 리스트 반환
	            response.setContentType("application/json;charset=UTF-8");
	            PrintWriter out = response.getWriter();
	            out.write("{\"followingList\":[]}");
	            out.flush();
	        }
			
        } else {
        	// 다른 action 요청 시 빈 결과 리턴
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.write("{\"followingList\":[]}");
            out.flush();
        }
	}
}
