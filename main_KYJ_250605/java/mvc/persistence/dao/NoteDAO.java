package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import mvc.domain.vo.NoteVO;

public interface NoteDAO {
	
	// 전체 카테고리 - 인기글
	Map<Integer, List<NoteVO>> popularNoteByAllCategory(int limit) throws SQLException;
	
    // 선호 카테고리 - 최신글
    List<NoteVO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException;

    // 선호 카테고리 - 인기글
    List<NoteVO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException;

}