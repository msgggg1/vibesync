package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.util.WorkspaceAction;

import mvc.command.service.MessageService;
import mvc.command.service.NoteService;
import mvc.command.service.PostViewService;
import mvc.command.service.UserService;
import mvc.command.service.WatchPartyService;
import mvc.command.service.WorkspaceService;
import mvc.domain.dto.UserPageDataDTO;
import mvc.domain.dto.WorkspaceDTO;
import mvc.domain.vo.UserVO;

public class WorkspaceHandler implements CommandHandler {
	private WorkspaceService workspaceService;
    
    public WorkspaceHandler() {
        this.workspaceService = new WorkspaceService(); // 생성자에서 초기화
    }

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        
        // 현재 링크 위치 : 이후 페이지 리디렉션에 활용
        String contextPath = request.getContextPath();
        
        UserVO userInfo = null; // 로그인된 사용자 정보
        int ac_idx = 0; // 로그인된 사용자 idx
    	
        if(session.getAttribute("userInfo") != null) {
        	userInfo = (UserVO) session.getAttribute("userInfo");
        	ac_idx = userInfo.getAc_idx();
        } else { // 로그인 안되어 있으면 로그인 페이지로
        	response.sendRedirect(contextPath + "/vibesync/user.do"); // 로그인 페이지로 리디렉션
        	return null;
        }
        
        // 요청 파라미터에서 요청(action)값 가져오기
        String actionParam = request.getParameter("action");
        
        // actionParam가 없거나 "view"이면 초기 페이지 로딩
        if (actionParam == null || actionParam.equals("view")) {
            // 초기 페이지 로딩
        	WorkspaceDTO initialData = workspaceService.getInitialData(ac_idx);
        	request.setAttribute("initialData", initialData);
            return "workspace.jsp";
        }
        
        WorkspaceAction action = null;
        try {
        	action = WorkspaceAction.valueOf(actionParam);
        } catch (IllegalArgumentException e) {
        	response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
        	return null;
        }

        // AJAX 요청 처리
        Object result = null; // AJAX 요청 결과를 담을 객체

        switch (action) {
            case getTodolist:
                // ... TodolistService 호출 ...
                break;

            case createTodolist:
                // ... TodolistService 호출 ...
                break;

            case getMyPosts:
            	// ... Post/NoteService 호출 ...
                break;

            case getLikedPosts:
                // ... LikeService 호출 ...
                break;

            case getChatHistory:
            	MessageService messageService = new MessageService();
            	int sender_idx = Integer.parseInt(request.getParameter("sender_idx"));
            	result = messageService.getChatHistory(sender_idx, ac_idx);
                break;

            case getCategoryPosts:
            	NoteService postServiceForBlock = new NoteService();
                int category_idx = Integer.parseInt(request.getParameter("category_idx"));
                String sortType = request.getParameter("sortType");
                result = postServiceForBlock.getPostsByCategory(category_idx, sortType);
                break;
            
            case getFollowingWatchParties:
                WatchPartyService watchPartyService = new WatchPartyService();
                result = watchPartyService.getFollowingWatchParties(ac_idx);
                break;

            case getUserNoteStats:
            	NoteService postServiceForStats = new NoteService();
                result = postServiceForStats.getUserNoteStats(ac_idx);
                break;

            default:
                // 잘못된 action 값에 대한 처리
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
                return null;
        }

        Gson gson = new Gson();
        // AJAX 요청 결과를 JSON으로 변환하여 응답
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(gson.toJson(result));
        
        return null;
    }
}