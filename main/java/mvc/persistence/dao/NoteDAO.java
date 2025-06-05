package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import mvc.domain.dto.NoteDTO;
import mvc.domain.dto.NoteDetailDTO;
import mvc.domain.vo.NoteVO;

public interface NoteDAO {
	
	// 전체 카테고리 - 인기글
	Map<Integer, List<NoteVO>> popularNoteByAllCategory(int limit) throws SQLException;
	
    // 선호 카테고리 - 최신글
    List<NoteVO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException;

    // 선호 카테고리 - 인기글
    List<NoteVO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException;
    
    // 포스트 뷰 출력
  	NoteDetailDTO printNote(int noteIdx);
  	
  	// 조회수 증가
  	void increaseViewCount(int noteIdx) throws SQLException; 
     
	 // 특정 사용자의 게시물을 페이지 단위로 조회하는 메서드 
	 List<NoteDTO> findNotesByAcIdxPaged(int ac_idx, int offset, int limit) throws SQLException;
	
	 // 특정 사용자의 전체 게시물 수를 조회하는 메서드 (총 페이지 계산에 필요)
	 int countNotesByAcIdx(int ac_idx) throws SQLException;
     

}