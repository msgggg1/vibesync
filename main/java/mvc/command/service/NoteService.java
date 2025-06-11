package mvc.command.service;

import java.sql.Connection;
import java.util.List;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.dto.NoteStatsDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.persistence.dao.LikeDAO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.daoImpl.LikeDAOImpl;
import mvc.persistence.daoImpl.NoteDAOImpl;

public class NoteService {
	public List<NoteSummaryDTO> getLikedPosts(int acIdx) {
		
		// 민선님 파트
		
		return null;
	}
	
	public List<NoteSummaryDTO> getMyPosts(int acIdx) {
		
		// 민선님 파트
		
		return null;
	}
	
	public List<NoteSummaryDTO> getPostsByCategory(int categoryIdx, String sortType) {
		List<NoteSummaryDTO> postsByCategory = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			NoteDAO noteDAO = new NoteDAOImpl(conn);
			
			if (sortType.equals("popular")) {
				postsByCategory = noteDAO.popularNoteByMyCategory(categoryIdx, 5);
				
			} else if (sortType.equals("latest")) {
				postsByCategory = noteDAO.recentNoteByMyCategory(categoryIdx, 5);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return postsByCategory;
	}

	public NoteStatsDTO getUserNoteStats(int acIdx) {
		NoteStatsDTO userNoteStats = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			// 유저가 작성한 전체 게시글 note_idx
			NoteDAO noteDAO = new NoteDAOImpl(conn);
			List<Integer> noteIdList = noteDAO.getNoteIdxListByUser(acIdx);
			
			// 전체 게시글의 총 좋아요 수
			LikeDAO likeDAO = new LikeDAOImpl(conn);
			int likeCnt = likeDAO.getLikesCountForMultipleNotes(noteIdList);
			
			// 전체 게시글의 조회수
			int viewCnt = noteDAO.getViewCountsForNotesAllByUser(acIdx);
			
			userNoteStats = NoteStatsDTO.builder()
										.totalLikes(likeCnt)
										.totalViews(viewCnt)
										.totalPosts(noteIdList.size())
										.build();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return userNoteStats;
	}

}
