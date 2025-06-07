package mvc.command.service;

import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import mvc.domain.dto.MainPageDTO;
import mvc.domain.vo.CategoryVO;
import mvc.domain.vo.NoteVO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.CategoryDAO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.dao.UserDAO;

public class MainPageService_KYJ {
    private CategoryDAO categoryDAO = null;
    private NoteDAO noteDAO = null;
    private UserDAO userDAO = null;

    public MainPageService_KYJ(CategoryDAO categoryDAO, NoteDAO noteDAO, UserDAO userDAO) {
        this.categoryDAO = categoryDAO;
        this.noteDAO = noteDAO;
        this.userDAO = userDAO;
    }

    public MainPageDTO loadMainPage(int preferredCategory) {
    	List<CategoryVO> allCategories = null; // 카테고리 정보
    	List<NoteVO> latestNotes = null; // 선호 카테고리 - 최신글
    	List<NoteVO> popularNotesByMyCategory = null; // 선호 카테고리 - 인기글
    	List<UserVO> popularUsers = null; // 선호 카테고리 - 인기유저
    	Map<Integer, List<NoteVO>> popularNotesNotByMyCategory = null; // 비선호 카테고리 인기글
    	
    	// 전체 카테고리 인기글
    	Map<Integer, List<NoteVO>> popularNotes = null;
    	
		try {
			popularNotes = noteDAO.popularNoteByAllCategory(5);
			
			allCategories = categoryDAO.CategoryAll();
			latestNotes = noteDAO.recentNoteByMyCategory(preferredCategory, 5);
			popularUsers = userDAO.findPopularUsersByCategory(preferredCategory, 5);
			popularNotesNotByMyCategory = new LinkedHashMap<Integer, List<NoteVO>>(popularNotes);
			popularNotesByMyCategory = popularNotesNotByMyCategory.remove(preferredCategory);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
    	
        return MainPageDTO.builder()
                .categoryVOList(allCategories)
                .latestNotes(latestNotes)
                .popularNotes(popularNotesByMyCategory)
                .popularUsers(popularUsers)
                .popularNotesNotByMyCategory(popularNotesNotByMyCategory)
                .build();
    }
	
}
