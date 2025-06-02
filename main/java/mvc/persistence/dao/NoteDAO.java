package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.NoteDTO;

public interface NoteDAO {
	
	// 선호 카테고리 - 최신글
	List<NoteDTO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException;
	
	// 선호 카테고리 - 인기글
    List<NoteDTO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException;
    
    // 전체 카테고리 - 인기글
	List<NoteDTO> popularNoteByAllCategory(int limit) throws SQLException;
	
}