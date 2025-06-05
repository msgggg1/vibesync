package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.util.ConnectionProvider;

import mvc.domain.dto.MainPageDTO;
import mvc.domain.vo.CategoryVO;
import mvc.domain.vo.NoteVO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.CategoryDAO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.dao.UserDAO;
import mvc.persistence.daoImpl.CategoryDAOImpl;
import mvc.persistence.daoImpl.NoteDAOImpl;
import mvc.persistence.daoImpl.UserDAOImpl;

public class MainPageService {

    public MainPageDTO loadMainPage(int preferredCategory) {
    	MainPageDTO mainPageDTO = null;
    	
    	List<CategoryVO> allCategories = null; // 카테고리 정보
    	List<NoteVO> latestNotes = null; // 선호 카테고리 - 최신글
    	List<NoteVO> popularNotesByMyCategory = null; // 선호 카테고리 - 인기글
    	List<UserVO> popularUsers = null; // 선호 카테고리 - 인기유저
    	Map<Integer, List<NoteVO>> popularNotesNotByMyCategory = null; // 비선호 카테고리 인기글
    	
    	// private 유저가 팔로우하고 있는 계정 목록 UserVO
    	
    	// 전체 카테고리 인기글
    	Map<Integer, List<NoteVO>> popularNotes = null;
    	
    	Connection conn = null;
    	
		try {
    		conn = ConnectionProvider.getConnection();
            
            CategoryDAO categoryDAO = new CategoryDAOImpl(conn);
            NoteDAO noteDAO = new NoteDAOImpl(conn);
    		UserDAO userDAO = new UserDAOImpl(conn);
            
			popularNotes = noteDAO.popularNoteByAllCategory(5);
			
			allCategories = categoryDAO.CategoryAll();
			latestNotes = noteDAO.recentNoteByMyCategory(preferredCategory, 5);
			popularUsers = userDAO.findPopularUsersByCategory(preferredCategory, 5);
			popularNotesNotByMyCategory = new LinkedHashMap<Integer, List<NoteVO>>(popularNotes);
			popularNotesByMyCategory = popularNotesNotByMyCategory.remove(preferredCategory);
            
			mainPageDTO = MainPageDTO.builder()
						            .categoryVOList(allCategories)
						            .latestNotes(latestNotes)
						            .popularNotes(popularNotesByMyCategory)
						            .popularUsers(popularUsers)
						            .popularNotesNotByMyCategory(popularNotesNotByMyCategory)
						            .build();
			
		} catch (Exception e) {
        	e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		
        return mainPageDTO;
    }
	
}
