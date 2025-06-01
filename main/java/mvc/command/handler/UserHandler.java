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
        
        // accessType : 사용자가 필요로 하는 것이 로그인 처리인지 회원가입 처리인지 구분하기 위한 변수
        // login.jsp에서 input으로 값을 받아옴. type=hidden 으로 지정되어 있어 화면에는 나타나지 않음
        String accessType = request.getParameter("accessType");
        
        // 현재 링크 위치 : 이후 페이지 리디렉션에 활용 예정
        String contextPath = request.getContextPath();
        // 예) http://localhost/vibeSyncTest/vibesync/user.do
        
        // 요청방식 : GET 또는 POST
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
        
        // 기존 쿠키 확인 : 자동로그인 / 이메일 기억하기 기능 적용 목적
        String autoLoginUserEmail = null; // autoLoginUserEmail 쿠키 값 (자동로그인용)
        String rememberedEmail = null; // rememberEmail 쿠키 값 (이메일 기억하기용 : 폼의 email 부분 기본 value값으로 들어감)
        
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
        	for (Cookie c : cookies) {
        		if ("autoLoginUserEmail".equals(c.getName())) {
        			autoLoginUserEmail = c.getValue();
        			
        		} else if ("rememberEmail".equals(c.getName())) {
        			rememberedEmail = c.getValue();
        		}
        	}
        }
        
        // rememberEmail 쿠키 값이 null일 경우 빈 문자열 처리 (폼에 email 정보 채워둘 때 오류 방지 목적)
        rememberedEmail = (rememberedEmail == null) ? "" : rememberedEmail;
        
        // 로그인된 유저인지 확인하는 session Attribute : userInfo
        // UserSessionVO 객체인 userInfo는 로그인된 사용자의 email, nickname, img, category_idx 정보를 담고 있음
        UserSessionVO userInfo = null;
        
        // DB 연결 관리 : Connection 객체
        Connection conn = null;
        
        // 로그인 및 회원가입 기능
        try {
        	// 커넥션 풀을 활용한 DB 연결
        	conn = ConnectionProvider.getConnection();
        	
        	// 유저의 정보를 실제 JDBC에 CRUD 하는 기능들을 담당하는 DAO 클래스 : UserDAO, UserDAOImpl
        	UserDAO userAccountDAO = new UserDAOImpl(conn);
        	
        	// UserHandler에서 로그인 관련 기능들을 담당하는 서비스 클래스 : LoginService
        	LoginService loginService = new LoginService(userAccountDAO);
        	
        	// 자동 commit 해제 (트랜잭션 처리)
        	conn.setAutoCommit(false);
        	
        	// 최초 페이지 로딩 (로그인/회원가입 기능 진입 이전)
        	if (!"POST".equalsIgnoreCase(requestMethod)) { // 요청방식이 POST가 아닌 경우 (GET 방식)
        		if(session.getAttribute("userInfo") != null) { // 로그인 되어 있는 상태
        			// 이미 세션에 로그인 정보가 있고, POST 요청이 아닌 상태
        			response.sendRedirect(contextPath + "/vibesync/main.do"); // main.jsp로 리디렉션
        			// (로그인된 사용자가 login.jsp에 접근하는 것을 막음)
        			
        		} else { // 로그인 되어있지 않은 상태
        			if (autoLoginUserEmail != null && !autoLoginUserEmail.isEmpty()) {
        				// 현재 세션에 로그인 정보가 없고, autoLoginUserEmail 쿠키(자동 로그인용)가 있는 상태
        				// -> 자동 로그인 처리
                		userInfo = loginService.autoLogin(autoLoginUserEmail); // 이메일 정보로 자동로그인
                		session.setAttribute("userInfo", userInfo); // 로그인 처리 + 세션에 로그인된 사용자 정보 저장
                		response.sendRedirect(contextPath + "/vibesync/main.do"); // main.jsp로 리디렉션
                		
					} else { // 현재 세션에 로그인 정보가 없고, 자동 로그인용 쿠키도 존재하지 않는 상태
						return "login.jsp"; // login.jsp로 포워딩
					}
        		}
        	
        	// 로그인/회원가입 기능 진입 (요청방식 : POST)
        	} else {
                if (accessType.equals("login")) { // 로그인
                	String emailParam = request.getParameter("userId"); // 폼에서 전달된 이메일
    			    String pwParam = request.getParameter("userPw"); // 폼에서 전달된 비밀번호 (평문)
    			    
    			    // 사용자가 입력한 로그인 정보는 LoginDTO에 담아서 LoginService 객체에 전달
    			    LoginDTO loginDTO = new LoginDTO(emailParam, pwParam);
    			    userInfo = loginService.login(loginDTO); // 로그인된 사용자의 정보를 userInfo에 저장
                	
                    if (userInfo != null) { // 로그인 성공
                        // 이메일 기억하기 기능 처리
                        String rememberEmail = request.getParameter("RememEmail"); // 체크박스 값 가져오기
                        if ("on".equals(rememberEmail)) { // 체크박스가 선택되었다면 (HTML에서 checkbox가 check되면 "on" 값을 가짐)
                            Cookie emailCookie = new Cookie("rememberedUserEmail", emailParam); // rememberedEmail 쿠키 생성
                            emailCookie.setMaxAge(60 * 60 * 24 * 30); // 쿠키 유효 기간: 30일 (초 단위)
                            emailCookie.setPath("/"); // 웹 애플리케이션 전체 경로에서 사용 가능하도록 설정
                            response.addCookie(emailCookie); // rememberedEmail 쿠키 저장
                            
                        } else { // 체크박스가 선택되지 않았다면 기존 쿠키 삭제
                            Cookie emailCookie = new Cookie("rememberedUserEmail", "");
                            emailCookie.setMaxAge(0); // 쿠키 즉시 만료
                            emailCookie.setPath("/");
                            response.addCookie(emailCookie); // rememberedEmail 쿠키 삭제
                        }
                        
                        // 자동 로그인 기능 처리
                        String autoLogin = request.getParameter("autoLogin");
                        if ("on".equals(autoLogin)) {
                        	Cookie autoLoginCookie = new Cookie("autoLoginUserEmail", emailParam);
                        	autoLoginCookie.setMaxAge(60 * 60 * 24 * 30); // 쿠키 유효 기간: 30일 (초 단위)
                        	autoLoginCookie.setPath("/"); // 웹 애플리케이션 전체 경로에서 사용 가능하도록 설정
                            response.addCookie(autoLoginCookie);
                        }
                        // 자동로그인의 경우 로그아웃 실행 시에만 autoLoginUserEmail 쿠키 삭제가 가능
                    	
                        session.setAttribute("userInfo", userInfo); // 세션에 로그인된 사용자 정보 저장
                        response.sendRedirect(contextPath + "/vibesync/main.do"); // 메인 페이지로 리디렉션
                        
                    } else { // 로그인 실패 (userInfo == null)
                    	session.setAttribute("sessionLoginError", "로그인 중 오류가 발생했습니다.");
                    	return "login.jsp"; // 로그인 페이지로 오류메시지 가지고 포워딩
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
