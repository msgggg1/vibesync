package mvc.command.service; 

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.vo.UserSummaryVO;
import mvc.persistence.dao.FollowDAO;
import mvc.persistence.daoImpl.FollowDAOImpl;

public class FollowService {
	
	 Connection conn = null;

    public FollowService() {
    }


    //팔로우 상태를 토글.
    public Map<String, Object> toggleFollow(int followerAcIdx, int targetUserAcIdx) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        boolean originallyFollowing = false;
        boolean autoCommitOriginalState = true;
        int newFollowerCount = 0; // 새로운 팔로워 수를 담을 변수 

        try {
            conn = ConnectionProvider.getConnection();
            FollowDAO followDAO = new FollowDAOImpl(conn);
            autoCommitOriginalState = conn.getAutoCommit();
            conn.setAutoCommit(false); // 트랜잭션 시작

            originallyFollowing = followDAO.isFollowing(followerAcIdx, targetUserAcIdx);

            if (originallyFollowing) {
                followDAO.removeFollow(followerAcIdx, targetUserAcIdx);
                result.put("following", false); // 이제 팔로우 안함
            } else {
                followDAO.addFollow(followerAcIdx, targetUserAcIdx);
                result.put("following", true);  // 이제 팔로우 함
            }
            
         // 팔로우/언팔로우 작업 후, 대상 사용자의 최신 팔로워 수 조회
            newFollowerCount = followDAO.getFollowerCount( targetUserAcIdx);
            result.put("newFollowerCount", newFollowerCount); // 결과 맵에 추가

            conn.commit(); // 트랜잭션 커밋
            result.put("success", true);

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                    System.err.println("Transaction rolled back in FollowService due to: " + e.getMessage());
                } catch (SQLException ex) {
                    System.err.println("Rollback failed in FollowService: " + ex.getMessage());
                }
            }
            result.put("success", false);
            // 핸들러에서 오류 메시지를 포함하여 최종 JSON 응답을 생성하도록 예외를 다시 던짐
            throw e;
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
            if (conn != null) {
                try {
                    if (!conn.isClosed()) {
                        conn.setAutoCommit(autoCommitOriginalState);
                    }
                } catch (SQLException e) {
                    System.err.println("Failed to reset auto-commit in FollowService: " + e.getMessage());
                } finally {
                    JdbcUtil.close(conn);
                }
            }
        }
        return result;
    }

    // 특정 사용자가 다른 사용자를 팔로우하고 있는지 상태를 조회합니다. (페이지 로딩 시 NoteDetailDTO 채우기용)
    public boolean getFollowStatus(int followerAcIdx, int targetUserAcIdx) throws SQLException {
        boolean isUserFollowing = false; // 결과를 담을 변수, 기본값은 false
        try {
        	conn = ConnectionProvider.getConnection();
        	FollowDAO followDAO = new FollowDAOImpl(conn);
            isUserFollowing = followDAO.isFollowing(followerAcIdx, targetUserAcIdx);
        } catch (SQLException e) {
            throw e;
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
            if (conn != null) {
            	JdbcUtil.close(conn);
            }
        }
		return isUserFollowing;
    }
    
 // 팔로잉 수 조회
    public int getFollowingCount(int userIdx) throws SQLException {
    	int followingCnt = 0;
    	
    	Connection conn = null;
    	
        try {
        	conn = ConnectionProvider.getConnection();
        	FollowDAO followDAO = new FollowDAOImpl(conn);
        	followingCnt = followDAO.getFollowingCount(userIdx) ;
        } catch (SQLException e) {
            throw e;
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
            JdbcUtil.close(conn);
        }
    	
		return followingCnt;
    }
    
    // 팔로워 수 조회
    public int getFollowerCount(int userIdx) throws SQLException {
    	int followerCnt = 0;
    	
    	Connection conn = null;
    	
        try {
        	conn = ConnectionProvider.getConnection();
        	FollowDAO followDAO = new FollowDAOImpl(conn);
        	followerCnt = followDAO.getFollowerCount(userIdx) ;
        } catch (SQLException e) {
            throw e;
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
            JdbcUtil.close(conn);
        }
    	
		return followerCnt;
    }
    
    // 팔로잉 목록 조회
    public List<UserSummaryVO> getFollowingList(int userIdx) throws SQLException {
    	List<UserSummaryVO> followingList = new ArrayList<UserSummaryVO>();
    	
    	Connection conn = null;
    	
        try {
        	conn = ConnectionProvider.getConnection();
        	FollowDAO followDAO = new FollowDAOImpl(conn);
        	followingList = followDAO.userFollowingList(userIdx);
        } catch (SQLException e) {
            throw e;
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
            JdbcUtil.close(conn);
        }
    	
    	return followingList;
    }
    
    // 팔로워 목록 조회
    public List<UserSummaryVO> getFollowerList(int userIdx) throws SQLException {
    	List<UserSummaryVO> followerList = new ArrayList<UserSummaryVO>();
    	
    	Connection conn = null;
    	
        try {
        	conn = ConnectionProvider.getConnection();
        	FollowDAO followDAO = new FollowDAOImpl(conn);
        	followerList = followDAO.userFollowerList(userIdx);
        } catch (SQLException e) {
            throw e;
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
            JdbcUtil.close(conn);
        }
    	
    	return followerList;
    }
}