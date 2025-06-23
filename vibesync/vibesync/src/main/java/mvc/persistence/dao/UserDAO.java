package mvc.persistence.dao;

import java.sql.SQLException;

import mvc.domain.dto.LoginDTO;
import mvc.domain.dto.SignUpDTO;
import mvc.domain.vo.UserSummaryVO;
import mvc.domain.vo.UserVO;

public interface UserDAO {
	
	// 회원가입
	boolean insertUser(SignUpDTO dto);
	
	// 로그인
	UserVO login(LoginDTO dto);
	
	// 이메일로 계정 정보 조회
	UserVO findByEmail(String email);
	
	// 회원가입 시 중복 검사 : 닉네임, 이메일 한번에
	String[] duplicateTest(String nickname, String email);
	
	/*
	// 닉네임 중복 검사
	boolean isNicknameExists(String nickname);
	
	// 이메일 중복 검사
	boolean isEmailExists(String email);
	*/
	
	//////회원 활동 관련
	int preferredCategoryIdx(int acIdx) throws SQLException;
    
    //특정 사용자의 기본 프로필 정보 (ID, 닉네임, 프로필 이미지 경로)를 조회.
	UserSummaryVO getBasicUserInfoById(int acIdx) throws SQLException;

    //특정 사용자가 작성한 총 게시글 수를 조회
    int getPostCount(int userAcIdx) throws SQLException;
    
    /*비밀번호 재설정*/
    //비밀번호 재설정 토큰 DB저장
    public void saveResetToken(String email, String token) throws SQLException;
    
    // 유효한 토큰 사용하여 이메일 조회
    public String findEmailByValidToken(String token) throws SQLException;
    
    // 사용된 토큰 DB삭제
    public void deleteToken(String token) throws SQLException;
    
    // 이메일 주소를 기준으로 사용자의 비밀번호 업데이트
    public void updatePasswordAndSalt(String email, String hashedPassword , String newSalt);
    
    
}