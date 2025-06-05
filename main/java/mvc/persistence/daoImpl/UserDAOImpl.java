package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.util.JdbcUtil;
import com.util.PasswordMigrator;

import mvc.domain.dto.LoginDTO;
import mvc.domain.dto.SignUpDTO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.UserDAO;

public class UserDAOImpl implements UserDAO {
    
	private final Connection conn;
	
    // 생성자
    public UserDAOImpl(Connection conn) {
    	this.conn = conn;
    }

    // 회원가입
    @Override
    public boolean insertUser(SignUpDTO dto) {
    	boolean isInserted = false;
    	
        PreparedStatement pstmt = null;
    	
    	String sql = " INSERT INTO userAccount " + 
    				 " (ac_idx, email, pw, nickname, img, name, created_at, salt, category_idx) " +
    				 " VALUES (useraccount_seq.nextval, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?, ?) ";
    	
    	try {
    		pstmt = conn.prepareStatement(sql);
    		
    		String hashedPw = null;
    		String salt = null;
    		
    		try {
    			salt = PasswordMigrator.generateSalt();
    			hashedPw = PasswordMigrator.hashPassword(dto.getPassword(), salt);
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    		
    		pstmt.setString(1, dto.getEmail());
    		pstmt.setString(2, hashedPw);
    		pstmt.setString(3, dto.getNickname());
    		pstmt.setString(4, null); // 기본 이미지 없음
    		pstmt.setString(5, dto.getName());
    		pstmt.setString(6, salt);
    		pstmt.setInt(7, dto.getCategory_idx());
    		
    		if (pstmt.executeUpdate() > 0) {
    			isInserted = true;
    		}
    		
    	} catch (SQLException e) {
    		throw new RuntimeException("회원가입 과정에서 오류가 발생했습니다.");
    	} finally {
    		try {
    			if (pstmt != null) pstmt.close();
    		} catch (Exception e) {
				e.printStackTrace();
			}
    	}
    	
    	return isInserted;
    }
    
    // 로그인
    @Override
    public UserVO login(LoginDTO dto) {
    	UserVO userInfo = null;
    	
        PreparedStatement pstmt = null;
        ResultSet rs = null;
    	
    	String sql = "SELECT ac_idx, pw, salt, nickname, img, name, category_idx " +
    				 " FROM userAccount WHERE email = ? ";
    	
    	try {
    		pstmt = conn.prepareStatement(sql);
			
			String emailParam = dto.getEmail(); // 폼에서 전달된 이메일
			String pwParam = dto.getPassword(); // 폼에서 전달된 비밀번호 (평문)
	 		
			pstmt.setString(1, emailParam);
	 		rs = pstmt.executeQuery();
	 		
            if (rs.next()) { // 이메일 존재
                String storedHashedPassword = rs.getString("pw");
                String storedSalt = rs.getString("salt");
                
                String hashedInputPassword = PasswordMigrator.hashPassword(pwParam, storedSalt);

                if (hashedInputPassword != null && storedHashedPassword.equals(hashedInputPassword)) {
                	// 로그인 성공 (비밀번호 일치)
                	userInfo = new UserVO().builder()
                						   .ac_idx(rs.getInt("ac_idx"))
                						   .email(emailParam)
                						   .nickname(rs.getString("nickname"))
                						   .img(rs.getString("img"))
                						   .name(rs.getString("name"))
                						   .category_idx(rs.getInt("category_idx"))
                						   .build();
                	System.out.println("로그인 성공");
                }
            }
		} catch (SQLException e) {
			throw new RuntimeException("로그인 과정에서 오류가 발생했습니다.");
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
    	
    	return userInfo;
    }
    
	// 이메일로 계정 정보 조회
	@Override
	public UserVO findByEmail(String email) {
		UserVO userInfo = null;
		
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		
		String sql = "SELECT ac_idx, nickname, img, name, category_idx FROM userAccount WHERE email = ? ";
		
		try {
			pstmt = conn.prepareStatement(sql);
	 		pstmt.setString(1, email);
	 		rs = pstmt.executeQuery();
	 		
	 		if (rs.next()) {
            	userInfo = new UserVO().builder()
						   .ac_idx(rs.getInt("ac_idx"))
						   .email(email)
						   .nickname(rs.getString("nickname"))
						   .img(rs.getString("img"))
						   .name(rs.getString("name"))
						   .category_idx(rs.getInt("category_idx"))
						   .build();
	 		}
	 		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return userInfo;
	}
	
	// 중복 검사 : 닉네임, 이메일
	@Override
	public String[] duplicateTest (String nickname, String email) {
		String[] duplicateTest = null;
		
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		
		String sql = "SELECT nickname, email " + 
					 " FROM userAccount " + 
					 " WHERE " + 
					 " nickname = ? OR email = ? ";
		try {
			pstmt = conn.prepareStatement(sql);
	 		pstmt.setString(1, nickname);
	 		pstmt.setString(2, email);
	 		rs = pstmt.executeQuery();
	 		
	 		if(rs.next()) {
	 			duplicateTest = new String[2];
	 			do {
					if (rs.getString("nickname").equals(nickname)) {
						duplicateTest[0] = nickname;
					}
					if (rs.getString("email").equals(email)) {
						duplicateTest[1] = email;
					}
				} while (rs.next());
	 		}
	 		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return duplicateTest;
	}
	
	// 닉네임 중복 검사
	@Override
	public boolean isNicknameExists(String nickname) {
		Boolean isNicknameExists = false;
		
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		
		String sql = "SELECT COUNT(ac_idx) ac_idx FROM userAccount WHERE nickname = ? ";
		try {
			pstmt = conn.prepareStatement(sql);
	 		pstmt.setString(1, nickname);
	 		rs = pstmt.executeQuery();
	 		
	 		if (rs.next()) {
	 			int ac_idx = rs.getInt("ac_idx");
	 			if (ac_idx > 0) isNicknameExists = true;
	 		}
	 		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return isNicknameExists;
	}
	
	// 이메일 중복 검사
	@Override
	public boolean isEmailExists(String email) {
		Boolean isEmailExists = false;
		
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		
		String sql = "SELECT COUNT(ac_idx) ac_idx FROM userAccount WHERE email = ? ";
		try {
			pstmt = conn.prepareStatement(sql);
	 		pstmt.setString(1, email);
	 		rs = pstmt.executeQuery();
	 		
	 		if (rs.next()) {
	 			int ac_idx = rs.getInt("ac_idx");
	 			if (ac_idx > 0) isEmailExists = true;
	 		}
	 		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return isEmailExists;
	}
	
}