package mvc.persistence.daoImpl; // 실제 프로젝트의 패키지 경로에 맞게 수정하세요.

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import mvc.persistence.dao.FollowDAO;

public class FollowDAOImpl implements FollowDAO {
    private Connection conn;

    public FollowDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public int countFollowers(int ac_idx) throws SQLException {
        // ac_idx를 팔로우하는 사람들의 수 
        String sql = "SELECT COUNT(*) FROM follows WHERE ac_follow = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, ac_idx);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    @Override
    public int countFollowing(int ac_idx) throws SQLException {
        // ac_idx가 팔로우하는 사람들의 수 
        String sql = "SELECT COUNT(*) FROM follows WHERE ac_following = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, ac_idx);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    @Override
    public boolean addFollow(int follower_ac_idx, int followed_ac_idx) throws SQLException {
        // follower_ac_idx가 followed_ac_idx를 팔로우합니다.
        // SQL: ac_following = follower_ac_idx, ac_follow = followed_ac_idx
    	String sql = "INSERT INTO follows (ac_following, ac_follow) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, follower_ac_idx); // 팔로우를 하는 사람
            pstmt.setInt(2, followed_ac_idx); // 팔로우를 받는 사람
            int result = pstmt.executeUpdate();
            return result > 0;
        }
    }

    @Override
    public boolean removeFollow(int follower_ac_idx, int followed_ac_idx) throws SQLException {
        // follower_ac_idx가 followed_ac_idx 팔로우 취소.
        String sql = "DELETE FROM follows WHERE ac_following = ? AND ac_follow = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, follower_ac_idx);
            pstmt.setInt(2, followed_ac_idx);
            int result = pstmt.executeUpdate();
            return result > 0;
        }
    }

    @Override
    public boolean isFollowing(int follower_ac_idx, int followed_ac_idx) throws SQLException {
        // follower_ac_idx가 followed_ac_idx를 팔로우하고 있는지 확인.
        String sql = "SELECT COUNT(*) FROM follows WHERE ac_following = ? AND ac_follow = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, follower_ac_idx);
            pstmt.setInt(2, followed_ac_idx);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}