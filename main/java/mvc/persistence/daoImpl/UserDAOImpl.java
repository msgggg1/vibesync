package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.util.PasswordMigrator;

import mvc.domain.dto.LoginDTO;
import mvc.domain.dto.SignUpDTO;
import mvc.domain.dto.UserDTO;
import mvc.domain.vo.UserSessionVO;
import mvc.persistence.dao.UserDAO;

public class UserDAOImpl implements UserDAO {
    private Connection conn;
    private PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    public UserDAOImpl(Connection conn) {
    	this.conn = conn;
    }

    // 회원가입
    @Override
    public UserSessionVO insertUser(SignUpDTO dto) {
    	UserSessionVO userInfo = null;
    	
    	String sql = "INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at, salt, category_idx) " +
    				 " VALUES (useraccount_seq.nextval, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?, ?) ";
    	
    	try {
    		pstmt = conn.prepareStatement(sql);
    		
    		String email = dto.getEmail();
    		String hashedPw = null;
    		String nickname = dto.getNickname();
    		String img = null;
    		String name = dto.getName();
    		int category_idx = 1;
    		
    		String salt;
    		try {
    			salt = PasswordMigrator.generateSalt();
    		} catch (Exception e) {
    			e.printStackTrace();
    			salt = null;
    		}
    		
    		hashedPw = PasswordMigrator.hashPassword(dto.getPassword(), salt);
    		
    		pstmt.setString(1, email);
    		pstmt.setString(2, hashedPw);
    		pstmt.setString(3, nickname);
    		pstmt.setString(4, img); // 기본 이미지 없음
    		pstmt.setString(5, name);
    		pstmt.setString(6, salt);
    		pstmt.setInt(7, dto.getCategory_idx());
    		
    		if (pstmt.executeUpdate() > 0) {
    			userInfo = new UserSessionVO().builder()
    					.email(email)
    					.nickname(nickname)
    					.img(img)
    					.category_idx(category_idx)
    					.build();
    		}
    		
    	} catch (SQLException e) {
    		throw new RuntimeException(e);
    	} finally {
    		try {
    			if (pstmt != null) pstmt.close();
    		} catch (Exception e) {
				e.printStackTrace();
			}
    	}
    	
    	return userInfo;
    }
    
    // 로그인
    @Override
    public UserSessionVO login(LoginDTO dto) {
    	UserSessionVO userInfo = null;
    	
    	String sql = "SELECT pw, name, salt FROM userAccount WHERE email = ? ";
    	
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
                	userInfo = this.findByEmail(emailParam);
                }
            }
		} catch (SQLException e) {
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
    
	// 이메일로 계정 정보 조회
	@Override
	public UserSessionVO findByEmail(String email) {
		UserSessionVO userInfo = null;
		
		String sql = "SELECT nickname, img, category_idx FROM userAccount WHERE email = ? ";
		
		try {
			pstmt = conn.prepareStatement(sql);
	 		pstmt.setString(1, email);
	 		rs = pstmt.executeQuery();
	 		
	 		if (rs.next()) {
	 			String nickname = rs.getString("nickname");
	 			String img = rs.getString("img");
	 			int category_idx = rs.getInt("category_idx");
	 			
	 			userInfo = new UserSessionVO().builder()
	 										  .email(email)
	 										  .nickname(nickname)
	 										  .img(img)
	 										  .category_idx(category_idx)
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
	
	// 이메일 중복 검사
	@Override
	public boolean isEmailExists(String email) {
		Boolean isEmailExists = false;
		
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
	
	// 닉네임 중복 검사
	@Override
	public boolean isNicknameExists(String nickname) {
		Boolean isNicknameExists = false;
		
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
	
	// 인기 유저 조회
	@Override
	public List<UserDTO> findPopularUsers(int limit) throws SQLException {
		 List<UserDTO> users = new ArrayList<>();
	        // 인기 유저: (받은 좋아요 수 + 팔로워 수) 합산 기준, Oracle TOP-N 쿼리
	        String sql = "SELECT ac_idx, nickname, img, popularity_score " +
	                "FROM ( " +
	                "    SELECT " +
	                "        ua.ac_idx, " +
	                "        ua.nickname, " +
	                "        ua.img, " +
	                "        COALESCE(follower_counts.total_followers, 0) AS popularity_score, " + // 인기도 점수를 팔로워 수로만 계산
	                "        ROW_NUMBER() OVER (ORDER BY COALESCE(follower_counts.total_followers, 0) DESC, ua.created_at DESC) as rn " +
	                "    FROM " +
	                "        userAccount ua " +
	                "    LEFT JOIN " +
	                "        (SELECT ac_following, COUNT(follows_idx) AS total_followers " +
	                "         FROM follows " +
	                "         GROUP BY ac_following) follower_counts ON ua.ac_idx = follower_counts.ac_following " +
	                ") " +
	                "WHERE rn <= ?";
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	            pstmt = this.conn.prepareStatement(sql);
	            pstmt.setInt(1, limit);
	            rs = pstmt.executeQuery();

	            while (rs.next()) {
	                UserDTO user = new UserDTO();
	                user.setAc_idx(rs.getInt("ac_idx"));
	                user.setNickname(rs.getString("nickname"));
	                user.setImg(rs.getString("img"));
	                user.setPopularityScore(rs.getInt("popularity_score")); // UserDTO에 필드가 있다면 설정
	                users.add(user);
	            }
	        } catch (Exception e) {
				e.printStackTrace();
			} finally {
	        	rs.close();
	        	pstmt.close();
	        }
	        
	        return users;
	    }

}