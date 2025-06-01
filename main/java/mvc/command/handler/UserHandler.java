package mvc.command.handler;

import java.sql.Connection;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.util.ConnectionProvider;

import mvc.command.service.LoginService;
import mvc.command.service.SignUpService;
import mvc.domain.dto.LoginDTO;
import mvc.domain.dto.SignUpDTO;
import mvc.domain.vo.UserSessionVO;
import mvc.persistence.dao.UserDAO;
import mvc.persistence.daoImpl.UserDAOImpl;

public class UserHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        String accessType = request.getParameter("accessType");
        String contextPath = request.getContextPath();
        String requestMethod = request.getMethod();
        
        // 에러, 성공 처리, 회원가입 실패 시 상태관리
        // 로그인 에러 메세지
        String loginErrorForDisplay = null; // 화면 표시에 사용할 에러 메시지 변수
        if (session.getAttribute("sessionLoginError") != null) {
            loginErrorForDisplay = (String) session.getAttribute("sessionLoginError");
            session.removeAttribute("sessionLoginError"); // 세션에서 즉시 삭제 (일회성 표시 위함)
        }
        // 회원가입 에러 메세지
        String signupErrorForDisplay = null;
        if (session.getAttribute("signupErrorMsg") != null) {
            signupErrorForDisplay = (String) session.getAttribute("signupErrorMsg");
            session.removeAttribute("signupErrorMsg");
        }

        // 회원가입 성공 메시지
        String signupSuccessForDisplay = null;
        if (session.getAttribute("signupSuccessMsg") != null) {
            signupSuccessForDisplay = (String) session.getAttribute("signupSuccessMsg");
            session.removeAttribute("signupSuccessMsg");
        }
        
        // 이전 회원가입 시도 시 입력 값 가져오기
        String prevSignupName = (String) session.getAttribute("prevSignupName");
        String prevSignupNickname = (String) session.getAttribute("prevSignupNickname");
        String prevSignupEmail = (String) session.getAttribute("prevSignupEmail");

        //사용 후 세션에서 제거
        if (prevSignupName != null) session.removeAttribute("prevSignupName");
        if (prevSignupNickname != null) session.removeAttribute("prevSignupNickname");
        if (prevSignupEmail != null) session.removeAttribute("prevSignupEmail");

        // null일 경우 빈 문자열로 초기화 (input value에 "null" 문자열 출력 방지)
        prevSignupName = (prevSignupName == null) ? "" : prevSignupName;
        prevSignupNickname = (prevSignupNickname == null) ? "" : prevSignupNickname;
        prevSignupEmail = (prevSignupEmail == null) ? "" : prevSignupEmail;

        // 회원가입 등 오류 났을 때 보여줄 폼 (login.js에서 사용)
        String formToShow = request.getParameter("formToShow");
        
        // 기존 쿠키 확인
        String autoLoginUserEmail = null; // userEmail 쿠키에서 읽어온 값 (자동 로그인용)
        String rememberedEmail = null; // rememberEmail 쿠키에서 읽어온 값 (폼 채우기용)
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
        	for (Cookie c : cookies) {
        		if ("userEmail".equals(c.getName())) {
        			autoLoginUserEmail = c.getValue();
        		} else if ("rememberEmail".equals(c.getName())) {
        			rememberedEmail = c.getValue();
        		}
        	}
        }
        
        // rememberedEmailForForm이 null일 경우 빈 문자열로 
        rememberedEmail = (rememberedEmail == null) ? "" : rememberedEmail;
        UserSessionVO userInfo = null;
        Connection conn = null;
        
        // 로그인 및 회원가입 기능
        try {
        	conn = ConnectionProvider.getConnection();
        	UserDAO userAccountDAO = new UserDAOImpl(conn);
        	LoginService loginService = new LoginService(userAccountDAO);
        	
        	conn.setAutoCommit(false);
        	
        	if (!"POST".equalsIgnoreCase(requestMethod)) { // GET 방식
        		if(session.getAttribute("userInfo") != null) { // 로그인 되어 있는 상태
        			// 이미 세션에 로그인 정보가 있다면 (그리고 POST 요청이 아니라면) main.jsp로 리디렉션
        			// (로그인된 사용자가 login.jsp에 접근하는 것을 막음)
        			response.sendRedirect(contextPath + "/vibesync/main.do");
        		} else {
        			if (autoLoginUserEmail != null && !autoLoginUserEmail.isEmpty()) {
        				// userEmail 쿠키(자동 로그인용)가 있고, 현재 세션에 로그인 정보가 없으면 자동 로그인 처리
                		userInfo = loginService.autoLogin(autoLoginUserEmail);
                		session.setAttribute("userInfo", userInfo);
                		response.sendRedirect(contextPath + "/vibesync/main.do");
					} else {
						return "login.jsp";
					}
        		}
        	} else { // POST 방식
                if (accessType.equals("login")) { // 로그인
                	// 요청 방식이 POST인 경우
    			    	String emailParam = request.getParameter("userId"); // 폼에서 전달된 이메일
    			        String pwParam = request.getParameter("userPw"); // 폼에서 전달된 비밀번호 (평문)
    			        
    			        LoginDTO loginDTO = new LoginDTO(emailParam, pwParam);
    			        userInfo = loginService.login(loginDTO);
                	
                    if (userInfo != null) { // 로그인 성공
                        // "Remember Email" 기능 처리
                        String rememberEmail = request.getParameter("RememEmail"); // 체크박스 값 가져오기
                        if ("on".equals(rememberEmail)) { // 체크박스가 선택되었다면 (HTML에서 checkbox가 check되면 "on" 값을 가짐)
                            Cookie emailCookie = new Cookie("rememberedUserEmail", emailParam);
                            emailCookie.setMaxAge(60 * 60 * 24 * 30); // 쿠키 유효 기간: 30일 (초 단위)
                            emailCookie.setPath("/"); // 웹 애플리케이션 전체 경로에서 사용 가능하도록 설정
                            response.addCookie(emailCookie);
                        } else { // 체크박스가 선택되지 않았다면 기존 쿠키 삭제
                            Cookie emailCookie = new Cookie("rememberedUserEmail", "");
                            emailCookie.setMaxAge(0); // 쿠키 즉시 만료
                            emailCookie.setPath("/");
                            response.addCookie(emailCookie);
                        }
                        
                        // 자동 로그인
                        String autoLogin = request.getParameter("autoLogin");
                        if ("on".equals(autoLogin)) {
                        	Cookie autoLoginCookie = new Cookie("userEmail", emailParam);
                        	autoLoginCookie.setMaxAge(60 * 60 * 24 * 30); // 쿠키 유효 기간: 30일 (초 단위)
                        	autoLoginCookie.setPath("/"); // 웹 애플리케이션 전체 경로에서 사용 가능하도록 설정
                            response.addCookie(autoLoginCookie);
                        }
                    	
                        session.setAttribute("userInfo", userInfo); // 세션에 사용자 정보 저장
                        response.sendRedirect(contextPath + "/vibesync/main.do");
                    } else {
                    	session.setAttribute("sessionLoginError", "로그인 중 오류가 발생했습니다.");
                    	response.sendRedirect(contextPath + "/vibesync/user.do");
                    }
                
                } else if (accessType.equals("signUp")) { // 회원가입
                	
                    String name = request.getParameter("signupName");
                    String nickname = request.getParameter("signupNickname");
                    String email = request.getParameter("signupEmail");
                    String pw = request.getParameter("signupPw");
                    String cpw = request.getParameter("confirmPw");
                    int category_idx = Integer.parseInt(request.getParameter("category"));

                    SignUpDTO signUpDTO = new SignUpDTO().builder()
                    									 .name(name)
                    									 .nickname(nickname)
                    									 .email(email)
                    									 .password(pw)
                    									 .confirmPassword(cpw)
                    									 .category_idx(category_idx)
                    									 .build();
                	
                    SignUpService signUpService = new SignUpService(userAccountDAO);

                    userInfo = signUpService.register(signUpDTO);
                    
                    if (userInfo != null) {
                    	conn.commit();
                    	session.setAttribute("signupSuccessMsg", "회원가입이 성공적으로 완료되었습니다.");
                    	return "login.jsp";
    				} else {
    					conn.rollback();
    					session.setAttribute("signupErrorMsg", "회원가입에 실패하였습니다.");
    		            response.sendRedirect("login.jsp?formToShow=signup");
    				}
                }
        	}
		} catch (Exception e) {
			e.printStackTrace();
			conn.rollback();
		} finally {
			conn.close();
		}
        
		return null;
	}

}
