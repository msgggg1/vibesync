package mvc.command.service; 

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;
import com.util.ConnectionProvider; 
import mvc.domain.dto.UserProfileViewDTO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.FollowDAO; 
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.daoImpl.FollowDAOImpl; 
import mvc.persistence.daoImpl.NoteDAOImpl;


public class UserService {

	public UserProfileViewDTO getUserProfileForView(int ac_idx, UserVO user) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection(); 

            NoteDAO noteDAO = new NoteDAOImpl(conn); 
            FollowDAO followDAO = new FollowDAOImpl(conn); 

            int postCount = noteDAO.countNotesByAcIdx(ac_idx);
            int followerCount = followDAO.countFollowers(ac_idx); 
            int followingCount = followDAO.countFollowing(ac_idx); 

            return UserProfileViewDTO.builder()
                    .ac_idx(user.getAc_idx())
                    .nickname(user.getNickname())
                    .img(user.getImg())
                    .postCount(postCount)
                    .followerCount(followerCount)
                    .followingCount(followingCount)
                    .build();

        } catch (SQLException e) {
            // SQL 예외 처리 (로그 기록 등)
            e.printStackTrace(); 
            throw new RuntimeException("유저 프로필 정보를 가져오는 중 DB 오류 발생", e); 
        } catch (NamingException e) {
			e.printStackTrace();
			throw new RuntimeException("DB 커넥션 설정(JNDI) 오류 발생: " + e.getMessage(), e);
		} finally {
            if (conn != null) {
                try {
                    conn.close(); 
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}