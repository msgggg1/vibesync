package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.dto.SidebarDTO;
import mvc.domain.dto.UserProfileViewDTO;
import mvc.domain.vo.UserSummaryVO;
import mvc.persistence.dao.FollowDAO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.daoImpl.FollowDAOImpl;
import mvc.persistence.daoImpl.NoteDAOImpl;

public class SidebarService {

    public SidebarDTO loadSidebar(int ac_idx) {
    	SidebarDTO sidebarDTO = null;
    	List<UserSummaryVO> followingList = null;
    	List<UserSummaryVO> followerList = null;
    	
    	Connection conn = null;
    	
    	try {
			conn = ConnectionProvider.getConnection();
			
			FollowDAO followDAO = new FollowDAOImpl(conn);
			followingList = followDAO.userFollowingList(ac_idx);
			followerList = followDAO.userFollowerList(ac_idx);
			
			NoteDAO noteDAO = new NoteDAOImpl(conn);
			int postCount = noteDAO.getNoteIdxListByUser(ac_idx).size();
			int postViewCount = noteDAO.getViewCountsForNotesAllByUser(ac_idx);
			
			UserProfileViewDTO userProfile = UserProfileViewDTO.builder()
															   .ac_idx(ac_idx)
															   .postCount(postCount)
															   .postViewCount(postViewCount)
															   .followingCount(followingList.size())
															   .followerCount(followerList.size())
															   .build();
			
			sidebarDTO = new SidebarDTO().builder()
										 .userProfile(userProfile)
										 .followingList(followingList)
										 .followerList(followerList)
										 .build();
			
		} catch (SQLException e) {
		    System.err.println("[SidebarService] DB 오류 발생: " + e.getMessage());
		    throw new RuntimeException("사이드바 로딩 실패", e);
		} catch (NamingException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
    	
    	return sidebarDTO;
    }
	
}