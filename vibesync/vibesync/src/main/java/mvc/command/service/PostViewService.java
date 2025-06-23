package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.dto.UserNoteDTO;
import mvc.domain.vo.UserNoteVO;
import mvc.persistence.dao.FollowDAO;
import mvc.persistence.dao.LikeDAO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.dao.UserNoteDAO;
import mvc.persistence.daoImpl.FollowDAOImpl;
import mvc.persistence.daoImpl.LikeDAOImpl;
import mvc.persistence.daoImpl.NoteDAOImpl;
import mvc.persistence.daoImpl.UserNoteDAOImpl;

public class PostViewService {
	
	
	
	public UserNoteVO getUserNoteInfo(int note_idx) throws SQLException {
		Connection conn = null;
		try {
            conn = ConnectionProvider.getConnection(); 
            UserNoteDAO dao = new UserNoteDAOImpl(conn);
            UserNoteVO noteInfo = dao.getUserNoteById(note_idx);
            return noteInfo;

        } catch (SQLException e) {
            e.printStackTrace(); 
            JdbcUtil.rollback(conn);
            throw new RuntimeException("노트 정보 오류", e);
        } catch (NamingException e) {
			e.printStackTrace();
			JdbcUtil.rollback(conn);
			throw new RuntimeException("DB 커넥션 설정(JNDI) 오류 발생: " + e.getMessage(), e);
		} finally {
            if (conn != null) {
                JdbcUtil.close(conn);
            }
        }

	}

	public void updateViewCount(int noteidx) throws SQLException {
		Connection conn = null;
		try {
            conn = ConnectionProvider.getConnection(); 
            UserNoteDAO dao = new UserNoteDAOImpl(conn);
            dao.updateViewCount(noteidx);
        } catch (SQLException e) {
            e.printStackTrace(); 
            throw new RuntimeException("노트 조회수 오류", e); 
        } catch (NamingException e) {
			e.printStackTrace();
			throw new RuntimeException("DB 커넥션 설정(JNDI) 오류 발생: " + e.getMessage(), e);
		} finally {
            if (conn != null) {
                JdbcUtil.close(conn);
            }
        }
	}
	
	public UserNoteDTO getFollowLike(int user_idx, int note_idx, int writerIdx) throws SQLException {
		Connection conn = null;
		try {
            conn = ConnectionProvider.getConnection(); 

            FollowDAO followDAO = new FollowDAOImpl(conn);
            LikeDAO likeDAO = new LikeDAOImpl(conn);
            
            boolean following = followDAO.isFollowing(user_idx, writerIdx);
            boolean liking = likeDAO.isLiked(user_idx, note_idx);
            

            return UserNoteDTO.builder()
                    .following(following)
                    .liking(liking)
                    .build();

        } catch (SQLException e) {
            e.printStackTrace(); 
            throw new RuntimeException("노트 정보 오류", e); 
        } catch (NamingException e) {
			e.printStackTrace();
			throw new RuntimeException("DB 커넥션 설정(JNDI) 오류 발생: " + e.getMessage(), e);
		} finally {
            if (conn != null) {
                JdbcUtil.close(conn);
            }
        }
	}
	
	// [추가] 팔로우 상태를 토글하는 서비스 메소드
    public boolean toggleFollow(int userIdx, int writerIdx) throws SQLException {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            FollowDAO dao = new FollowDAOImpl(conn);

            boolean isFollowing = dao.isFollowing(userIdx, writerIdx);
            if (isFollowing) {
                dao.removeFollow(userIdx, writerIdx);
            } else {
                dao.addFollow(userIdx, writerIdx);
            }
            return !isFollowing; // 작업 후 변경된 상태를 반환

        } catch (SQLException | NamingException e) {
            e.printStackTrace();
            // NamingException도 SQLException으로 처리하거나, 더 구체적인 예외로 변환할 수 있습니다.
            throw new RuntimeException("팔로우 처리 중 오류 발생", e);
        } finally {
            JdbcUtil.close(conn);
        }
    }

    // [추가] 좋아요 상태를 토글하는 서비스 메소드
    public boolean toggleLike(int userIdx, int noteIdx) throws SQLException {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            LikeDAO dao = new LikeDAOImpl(conn);

            boolean isLiking = dao.isLiked(userIdx, noteIdx);
            if (isLiking) {
                dao.removeLike(userIdx, noteIdx);
            } else {
                dao.addLike(userIdx, noteIdx);
            }
            return !isLiking; // 작업 후 변경된 상태를 반환

        } catch (SQLException | NamingException e) {
            e.printStackTrace();
            throw new RuntimeException("좋아요 처리 중 오류 발생", e);
        } finally {
            JdbcUtil.close(conn);
        }
    }
}
