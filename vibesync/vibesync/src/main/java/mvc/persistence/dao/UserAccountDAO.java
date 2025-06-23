package mvc.persistence.dao;

import java.sql.SQLException;
import mvc.domain.vo.UserDetailVO;

public interface UserAccountDAO {
    /**
     * ac_idx를 사용하여 사용자의 모든 계정 정보를 조회합니다.
     * @param acIdx 조회할 사용자의 ID
     * @return 사용자의 상세 정보가 담긴 UserDetailVO 객체, 없으면 null
     * @throws SQLException
     */
    UserDetailVO getUserAccountById(int acIdx) throws SQLException;
    
    /**
     * [신규] 사용자의 프로필 이미지 경로를 업데이트합니다.
     * @param acIdx 사용자 ID
     * @param newImagePath DB에 저장할 새 이미지 경로
     * @throws SQLException
     */
    void updateProfileImagePath(int acIdx, String newImagePath) throws SQLException;
    
    /**
     * [신규] 사용자의 비밀번호와 salt를 업데이트합니다.
     * @param acIdx 사용자 ID
     * @param newHashedPassword 새로 해싱된 비밀번호
     * @param newSalt 새로 생성된 salt
     * @throws SQLException
     */
    void updatePassword(int acIdx, String newHashedPassword, String newSalt) throws SQLException;
    
    /**
     * [신규] ac_idx를 기준으로 사용자 계정을 삭제합니다.
     * @param acIdx 삭제할 사용자 ID
     * @throws SQLException
     */
    void deleteAccount(int acIdx) throws SQLException;
    
}