package mvc.command.service;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.UUID;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import com.util.PasswordMigrator;

import mvc.persistence.dao.UserDAO;
import mvc.persistence.daoImpl.UserDAOImpl;

public class PasswordResetService {

    // 생성자를 통해 외부에서 생성된 DAO 객체를 주입받음
    public PasswordResetService() {
    }

    /**
     * 비밀번호 재설정 프로세스를 시작하는 메서드
     */
    public void initiateReset(String email, String requestURL) throws SQLException {
    		Connection conn = null;
        try {
        	conn = ConnectionProvider.getConnection(); 
        	conn.setAutoCommit(false);
        	
        	UserDAO userDAO = new UserDAOImpl(conn);
        	
            // 1. 이메일로 사용자가 존재하는지 확인
            if (userDAO.findByEmail(email) == null) {
                // 존재하지 않는 이메일이면, 보안을 위해 아무 작업도 하지 않고 조용히 종료.
                return;
            }

            // 2. 토큰 생성 및 DB 저장
            String token = UUID.randomUUID().toString();
            userDAO.saveResetToken(email, token);
            
            conn.commit();

            // 3. 이메일로 보낼 재설정 링크 생성
            String resetLink = requestURL + "/vibesync/user.do?accessType=showResetForm&token=" + token;
            
            // 4. 이메일 발송
            EmailService.sendPasswordResetEmail(email, resetLink);

        } catch (SQLException | IOException | NamingException e) {
        	try {
                if (conn != null) conn.rollback();
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
            throw new RuntimeException("비밀번호 재설정 요청 처리 중 오류가 발생했습니다.", e);
        } finally {
        	if (conn != null) JdbcUtil.close(conn);
        } 
    }

    /**
     * 토큰을 검증하고, 유효하다면 새 비밀번호로 업데이트하는 메서드
     * @return 성공 시 true, 실패 시 false
     */
    public boolean finalizeReset(String token, String newPassword) {
    	Connection conn = null;
        boolean isSuccess = false;
        try {
        	conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);
            
            UserDAO userDAO = new UserDAOImpl(conn);
            
            // 1. 유효한 토큰인지 확인하고 이메일 가져오기
            String email = userDAO.findEmailByValidToken(token);

            if (email != null) {
                // 2. ★★★ 새 비밀번호에 대한 새로운 salt 생성 ★★★
                String newSalt = PasswordMigrator.generateSalt();
                // 3. 새 salt로 새 비밀번호를 해싱
                String hashedPassword = PasswordMigrator.hashPassword(newPassword, newSalt);

                // 4. 새 비밀번호와 새 salt를 DB에 업데이트
                userDAO.updatePasswordAndSalt(email, hashedPassword, newSalt);
                
                // 5. 사용된 토큰은 즉시 삭제
                userDAO.deleteToken(token);
                isSuccess = true;
            }
            
            conn.commit();
        } catch (Exception e) { // SQLException 및 해싱 Exception 포함
        	try {
                if (conn != null) conn.rollback();
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
            throw new RuntimeException("비밀번호 업데이트 처리 중 오류가 발생했습니다.", e);
        }finally {
            if (conn != null) JdbcUtil.close(conn);
        }
        return isSuccess;
    }
}
