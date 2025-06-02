package mvc.command.handler;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mvc.domain.vo.UserSessionVO;

public class MainPageHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		// 로그인 되어 있지 않고, 게스트 계정으로 메인 페이지 오픈하려는 경우
		// HttpSession session = request.getSession();
		
		HttpSession session = request.getSession(false);
		UserSessionVO userInfo = null; // 로그인된 유저 정보 저장할 객체
		
        if (session == null) { // 세션 만료
        	System.err.println("MainPageHandler: session expired.");
        } else if (session.getAttribute("userInfo") == null) {
        	System.err.println("MainPageHandler: User not logged in");
        	
        	// 로그인 되어 있지 않고, 게스트 계정으로 메인 페이지 오픈하려는 경우
        	/*
            userInfo = new UserSessionVO().builder()
            							  .email("")
            							  .nickname("GUEST")
            							  .img(null)
            							  .category_idx(1)
            							  .build();
        	 */
        } else {
        	// 로그인 성공 후 메인페이지로 넘어오면 유저 정보 받아옴
        	userInfo = (UserSessionVO) session.getAttribute("userInfo");
        }
        
        // DB 연결 관리 : Connection 객체
        Connection conn = null;
        
        
        
		
		return null;
	}

}
