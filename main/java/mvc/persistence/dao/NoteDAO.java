package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.NoteDTO;

public interface NoteDAO {
	List<NoteDTO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException;
    List<NoteDTO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException;
	List<NoteDTO> recentAllNotes(int limit) throws SQLException;
}