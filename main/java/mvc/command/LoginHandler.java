package mvc.command;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.util.DBConn_vibesync;

public class LoginHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String contextPath = request.getContextPath();
		// ── 0. 기존 쿠키 확인 ──
	    String currentUser = null;
	    String rememberedEmail = null;
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        for (Cookie c : cookies) {
	            if ("userEmail".equals(c.getName())) {
	                currentUser = c.getValue();
	            } else if ("rememberEmail".equals(c.getName())) {
	                rememberedEmail = c.getValue();
	            }
	        }
	    }

	    // autoLogin 쿠키가 있으면 바로 메인으로
	    if (currentUser != null) {
	        response.sendRedirect("main.jsp");
	    }

	    String action = request.getParameter("mode");
	    if (action != null) {

	        // ─ 회원가입 처리 ─
	        if ("signup".equals(action)) {
	            Connection conn = null;
	            PreparedStatement pstmt = null;
	            ResultSet rs = null;

	            String name      = request.getParameter("signupName");
	            String nickname  = request.getParameter("signupNickname");
	            String email     = request.getParameter("signupEmail");
	            String password  = request.getParameter("signupPw");
	            String category  = request.getParameter("category");

	            try {
	                conn = DBConn_vibesync.getConnection();

	                // 이메일 중복 확인
	                pstmt = conn.prepareStatement("SELECT 1 FROM useraccount WHERE email = ?");
	                pstmt.setString(1, email);
	                rs = pstmt.executeQuery();
	                if (rs.next()) {
	                	return "/vibesync/login.jsp?state=fail";
	                } else {
	                    // === 랜덤 salt 생성 ===
	                    SecureRandom sr = new SecureRandom();
	                    byte[] saltBytes = new byte[16];
	                    sr.nextBytes(saltBytes);
	                    StringBuilder saltSb = new StringBuilder();
	                    for (byte b : saltBytes) {
	                        saltSb.append(String.format("%02x", b));
	                    }
	                    String salt = saltSb.toString(); // 16바이트 -> 32hex

	                    // 비밀번호 + salt SHA-256 암호화
	                    MessageDigest md = MessageDigest.getInstance("SHA-256");
	                    md.update((password + salt).getBytes("UTF-8"));
	                    byte[] hash = md.digest();
	                    StringBuilder sb = new StringBuilder();
	                    for (byte b : hash) {
	                        sb.append(String.format("%02x", b));
	                    }
	                    String encryptedPassword = sb.toString();

	                    // 시퀀스 조회
	                    int ac_idx = 0;
	                    try (Statement seqStmt = conn.createStatement();
	                         ResultSet seqRs = seqStmt.executeQuery("SELECT useraccount_seq.NEXTVAL FROM dual")) {
	                        if (seqRs.next()) ac_idx = seqRs.getInt(1);
	                    }

	                    // 사용자 INSERT (salt 컬럼 포함) === SALT 추가 ===
	                    String insertSql =
	                      "INSERT INTO useraccount (ac_idx, email, pw, salt, nickname, img, name, category_idx) " +
	                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
	                        insertStmt.setInt(1, ac_idx);
	                        insertStmt.setString(2, email);
	                        insertStmt.setString(3, encryptedPassword);
	                        insertStmt.setString(4, salt);
	                        insertStmt.setString(5, nickname);
	                        insertStmt.setString(6, "./source/img.jpg");
	                        insertStmt.setString(7, name);
	                        insertStmt.setString(8, category);
	                        insertStmt.executeUpdate();
	                    }
	                    return "/vibesync/login.jsp?state=signup";
	                }
	            } catch (Exception e) {
	                e.printStackTrace();	
	            } finally {
	                if (rs != null)    try { rs.close(); }    catch (Exception ignored) {}
	                if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
	                // Connection은 닫지 않음
	            }

	        // ─ 로그인 처리 ─
	        } else if ("login".equals(action)) {
	            Connection conn = null;
	            PreparedStatement pstmt = null;
	            ResultSet rs = null;

	            String email          = request.getParameter("userId");
	            String password       = request.getParameter("userPw");
	            String autoLoginParam = request.getParameter("autoLogin");
	            String rememEmailParam= request.getParameter("RememEmail");
	            
	            System.out.println(email + password + autoLoginParam + rememberedEmail);

	            try {
	                conn = DBConn_vibesync.getConnection();

	                // 먼저 email로 사용자의 salt와 저장된 해시 비밀번호 조회 === SALT 변경 ===
	                String selectSql = "SELECT ac_idx, nickname ,pw, salt, category_idx FROM useraccount WHERE email = ?";
	                pstmt = conn.prepareStatement(selectSql);
	                pstmt.setString(1, email);
	                rs = pstmt.executeQuery();

	                if (rs.next()) {
	                    String storedHash = rs.getString("pw");
	                    String salt       = rs.getString("salt");
	                    int userCategory  = rs.getInt("category_idx");
	                    String nickname   = rs.getString("nickname");
						int ac_idx 		  = rs.getInt("ac_idx");
						
	                    // 입력된 비밀번호 + salt SHA-256 해시
	                    MessageDigest md = MessageDigest.getInstance("SHA-256");
	                    md.update((password + salt).getBytes("UTF-8"));
	                    byte[] hash = md.digest();
	                    StringBuilder sb = new StringBuilder();
	                    for (byte b : hash) {
	                        sb.append(String.format("%02x", b));
	                    }
	                    String encryptedPassword = sb.toString();

	                    // 해시 비교
	                    if (storedHash.equals(encryptedPassword)) {
	                        // ─ userId 쿠키 설정 ─
	                        Cookie loginCookie = new Cookie("userEmail", email);
	                        if (autoLoginParam != null) {
	                            loginCookie.setMaxAge(7 * 24 * 60 * 60); // 7일
	                        }
	                        loginCookie.setPath("/");
	                        response.addCookie(loginCookie);
	                        
	                     	// --userIdx 설정 --
	                        Cookie login_user_idx = new Cookie("login_user_idx", String.valueOf(ac_idx));
	                        login_user_idx.setMaxAge(7 * 24 * 60 * 60); // 7일
	                        login_user_idx.setPath("/");
	                        response.addCookie(login_user_idx);
	                        
	                        // --userNickname 설정 --
	                        Cookie loginNickname = new Cookie("userNickname", nickname);
	                        loginNickname.setMaxAge(7 * 24 * 60 * 60); // 7일
	                        loginNickname.setPath("/");
	                        response.addCookie(loginNickname);

	                        // ─ category_idx 쿠키 설정 ─
	                        Cookie categoryCookie = new Cookie("category_idx", String.valueOf(userCategory));
	                        if (autoLoginParam != null) {
	                            categoryCookie.setMaxAge(7 * 24 * 60 * 60);
	                        }
	                        categoryCookie.setPath("/");
	                        response.addCookie(categoryCookie);

	                        // ─ RememEmail 쿠키 설정 ─
	                        if (rememEmailParam != null) {
	                            Cookie remCookie = new Cookie("rememberEmail", email);
	                            remCookie.setMaxAge(30 * 24 * 60 * 60); // 30일
	                            remCookie.setPath("/");
	                            response.addCookie(remCookie);
	                        } else {
	                            Cookie remCookie = new Cookie("rememberEmail", "");
	                            remCookie.setMaxAge(0);
	                            remCookie.setPath("/");
	                            response.addCookie(remCookie);
	                        }
	                        return "/vibesync/main.jsp";
	                    } else {
	                    	return "/vibesync/login.jsp?state=fail";
	                    }
	                } else {
	                	return "/vibesync/login.jsp?state=fail";
	                }
	            } catch (Exception e) {
	                e.printStackTrace();
	            } finally {
	                if (rs != null)    try { rs.close();    } catch (Exception ignored) {}
	                if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
	                // Connection은 닫지 않음
	            }
	        }
	    }
	    return null;
	}
	
}
