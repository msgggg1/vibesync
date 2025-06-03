package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.LoginDTO;
import mvc.domain.dto.SignUpDTO;
import mvc.domain.vo.UserSessionVO;
import mvc.domain.vo.UserVO;

public interface UserDAO {
	
	// 회원가입
	UserSessionVO insertUser(SignUpDTO dto);
	
	// 로그인
	UserSessionVO login(LoginDTO dto);
	
	// 이메일로 계정 정보 조회
	UserSessionVO findByEmail(String email);
	
	// 회원가입 시 중복 검사
	// 닉네임 중복 검사
	boolean isNicknameExists(String nickname);
	// 이메일 중복 검사
	boolean isEmailExists(String email);
	
	// 전체 카테고리의 인기 유저 조회
	List<UserVO> findPopularUsers(int limit) throws SQLException;
    
	// 특정 카테고리의 인기 유저 조회
	List<UserVO> findPopularUsersByCategory(int categoryIdx, int limit) throws SQLException;
	
	// ac_idx로 user 정보 가져오기
	UserVO findById(int ac_idx) throws SQLException;
}