package org.doit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.util.DBConn_vibesync;
import org.doit.domain.NoteVO;

public class NoteDAO {

    /**
     * MainList 메서드
     * @param criterion   정렬 기준 컬럼명 (예: "create_at", "view_count" 등)
     * @param categoryIdx 가져올 category_idx 값
     * @param limit       최대 레코드 수
     * @return            NoteVO 객체를 담은 ArrayList
     */
    public static ArrayList<NoteVO> MainList(String criterion, int categoryIdx, int limit) {
        ArrayList<NoteVO> list = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // Oracle에서 서브쿼리+ROWNUM 방식으로 limit 처리
        String sql = ""
            + "SELECT * FROM ("
            + "  SELECT * FROM note "
            + "  WHERE category_idx = ? "
            + "  ORDER BY " + criterion
            + ") "
            + "WHERE ROWNUM <= ?";

        try {
            conn = DBConn_vibesync.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryIdx);
            pstmt.setInt(2, limit);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                list = new ArrayList<>();
                do {
                    NoteVO vo = NoteVO.builder()
                        .note_idx(rs.getInt("note_idx"))
                        .title(rs.getString("title"))
                        .text(rs.getString("text"))
                        .create_at(rs.getString("create_at"))
                        .view_count(rs.getInt("view_count"))
                        .content_idx(rs.getInt("content_idx"))
                        .genre_idx(rs.getInt("genre_idx"))
                        .category_idx(rs.getInt("category_idx"))
                        .build();
                    list.add(vo);
                } while (rs.next());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // ResultSet / PreparedStatement만 닫고, Connection은 닫지 않음
            if (rs != null)    try { rs.close();    } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
        }

        return list;
    }
}
