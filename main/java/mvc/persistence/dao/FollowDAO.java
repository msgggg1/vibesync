package mvc.persistence.dao; // 실제 프로젝트의 패키지 경로에 맞게 수정하세요.

import java.sql.SQLException;

public interface FollowDAO {
    // 특정 사용자를 팔로우하는 사용자 수 (나를 팔로우하는 사람 = 내 팔로워 수)
    int countFollowers(int ac_idx) throws SQLException;

    // 특정 사용자가 팔로우하는 사용자 수 (내가 팔로우하는 사람 = 내 팔로잉 수)
    int countFollowing(int ac_idx) throws SQLException;

    // (선택적) 팔로우 관계 추가
    boolean addFollow(int follower_ac_idx, int followed_ac_idx) throws SQLException;

    // (선택적) 팔로우 관계 삭제
    boolean removeFollow(int follower_ac_idx, int followed_ac_idx) throws SQLException;

    // (선택적) 이미 팔로우하고 있는지 확인
    boolean isFollowing(int follower_ac_idx, int followed_ac_idx) throws SQLException;
}