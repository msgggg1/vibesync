package mvc.command.service;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.NoteDTO;
import mvc.domain.dto.NoteDetailDTO; 
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.daoImpl.NoteDAOImpl; 

public class NoteService { 

	private NoteDAO noteDAO; 


	public NoteService() {
		this.noteDAO = new NoteDAOImpl(); 
	}

	public NoteService(NoteDAO noteDAO) {
		this.noteDAO = noteDAO;
	}

	// 특정 게시글의 상세 정보 가져오기
	public NoteDetailDTO getNoteDetailById(int noteIdx) {
		NoteDetailDTO noteDetail = null;
        try {
            // 먼저 게시글의 조회수를 증가.
            noteDAO.increaseViewCount(noteIdx);
            noteDetail = noteDAO.printNote(noteIdx);

            if (noteDetail == null) {
                System.out.println("Service: 게시글 ID " + noteIdx + "에 해당하는 데이터를 찾을 수 없습니다 (조회수 증가 시도 후).");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null; 
        }
        return noteDetail;
    }

	// 페이지네이션을 지원하는 게시물 조회 메서드
    public List<NoteDTO> getNotesByAcIdxPaged(int ac_idx, int page, int pageSize) {
        // offset은 (페이지 번호 - 1) * 페이지당 게시물 수
        int offset = (page - 1) * pageSize;
        try {
            return noteDAO.findNotesByAcIdxPaged(ac_idx, offset, pageSize);
        } catch (SQLException e) {
            System.err.println("게시물 조회 중 DB 오류: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("게시물 조회에 실패했습니다.", e);
        }
    }
    
    // 특정 사용자의 전체 게시물 수를 가져오는 메서드
    public int getUserNoteCount(int ac_idx) {
        try {
            return noteDAO.countNotesByAcIdx(ac_idx);
        } catch (SQLException e) {
            System.err.println("게시물 수 조회 중 DB 오류: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("게시물 수 조회에 실패했습니다.", e);
        }
    }

}
