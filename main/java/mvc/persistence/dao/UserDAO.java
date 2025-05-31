package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.LoginDTO;
import mvc.domain.dto.SignUpDTO;
import mvc.domain.dto.UserDTO;
import mvc.domain.vo.UserSessionVO;

public interface UserDAO {
	
	// 회원가입
	UserSessionVO insertUser(SignUpDTO dto);
	
	// 로그인
	UserSessionVO login(LoginDTO dto);
	
	// 이메일로 계정 정보 조회
	UserSessionVO findByEmail(String email);
	
	// 중복 검사
	// 이메일 중복 검사
	boolean isEmailExists(String email);
	// 닉네임 중복 검사
	boolean isNicknameExists(String nickname);
	
	// 인기 유저 조회
	List<UserDTO> findPopularUsers(int limit) throws SQLException;
    
}