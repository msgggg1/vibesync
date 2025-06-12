package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import mvc.domain.dto.DailyStatsDTO;
import mvc.domain.dto.NoteDetailDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.vo.UserNoteVO;

public interface NoteDAO {
	
	// 전체 카테고리 - 인기글
	Map<Integer, List<NoteSummaryDTO>> popularNoteByAllCategory(int limit) throws SQLException;
	
    // 선호 카테고리 - 최신글
    List<NoteSummaryDTO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException;

    // 선호 카테고리 - 인기글
    List<NoteSummaryDTO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException;
    
    // 포스트 뷰 출력
 	NoteDetailDTO printNote(int noteIdx);
 	
 	// 포스트 뷰 출력 2
 	UserNoteVO getUserNoteById(int noteIdx);
 	
 	// 조회수 증가
 	void increaseViewCount(int noteIdx) throws SQLException; 
 	
 	// 특정 사용자가 작성한 게시글 목록을 페이징 처리하여 조회. (최신순 정렬)
    List<NoteSummaryDTO> getPostsByUser(int userAcIdx, int offset, int limit) throws SQLException;
     
    // 특정 사용자가 작성한 게시글 조회수 총합
    int getViewCountsForNotesAllByUser(int userAcIdx) throws SQLException;
    
    // 특정 사용자가 작성한 게시글 note_idx 조회
    List<Integer> getNoteIdxListByUser(int userAcIdx) throws SQLException;
    
    // 게시글들의 조회수 총합 조회
    int getViewCountsForMultipleNotes(List<Integer> noteIdx) throws SQLException;
    
    // 특정 사용자의 최근 N일간의 일별 게시글 작성 수 (일별 통계)
    List<DailyStatsDTO> getDailyPostCounts(int acIdx, int days) throws SQLException;
    
    // 특정 사용자의 최근 N일간의 일별 게시글 조회 수 (일별 통계)
    List<DailyStatsDTO> getDailyViewCounts(int acIdx, int days) throws SQLException;
    
}