package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.domain.vo.NoteVO;
import mvc.persistence.dao.NoteDAO;

public class NoteDAOImpl implements NoteDAO {

	Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
	
	public NoteDAOImpl(Connection conn) {
		this.conn = conn;
	}
	
	@Override
	// 전체 카테고리 - 인기글
	public Map<Integer, List<NoteVO>> popularNoteByAllCategory(int limit) throws SQLException {
		Map<Integer, List<NoteVO>> map = new LinkedHashMap<Integer, List<NoteVO>>();
		
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		
		// 전체 글 중 (좋아요 수 + 조회수) 합산 점수 높은 순, 동점 시 최신순
		String sql = " SELECT " +
				"        n.note_idx, " + 
				" 		  n.title, " + 
				" 		  n.text, " + 
				"		  n.img, " + 
				"		  n.create_at, " + 
				"		  n.edit_at, " + 
				"		  n.view_count, " + 
				"		  n.content_idx, " + 
				"		  n.genre_idx, " +
				"		  n.category_idx, " + 
				"		  n.userPg_idx " +
				" FROM ( " +
				"    SELECT " +
				"        n.note_idx, " + 
			    "        n.category_idx, " + 
				"        ROW_NUMBER() OVER ( " +
				"				PARTITION BY n.category_idx " +
				" 				ORDER BY (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) DESC, n.create_at DESC " + 
				" 		) AS rn " +
				"    FROM note n " + 
				" 	 LEFT JOIN likes l ON n.note_idx = l.note_idx " +
				"    GROUP BY n.note_idx, n.view_count, n.create_at, n.category_idx " +
				" ) rnk " +
				" JOIN note n ON rnk.note_idx = n.note_idx " +
				" WHERE rnk.rn <= ? " + 
				" ORDER BY rnk.category_idx, rnk.rn ";
		
		try {
			conn = ConnectionProvider.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, limit); 
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				do {
					int categoryId = rs.getInt("category_idx");
					NoteVO note = NoteVO.builder()
							.note_idx(rs.getInt("note_idx"))
							.title(rs.getString("title"))
							.text(rs.getString("text"))
							.img(rs.getString("img"))
							.create_at(rs.getDate("create_at"))
							.edit_at(rs.getDate("edit_at"))
							.view_count(rs.getInt("view_count"))
							.content_idx(rs.getInt("content_idx"))
							.genre_idx(rs.getInt("genre_idx"))
							.category_idx(categoryId)
							.userPg_idx(rs.getInt("userPg_idx"))
							.build();
					
					if(!map.containsKey(categoryId)) {
						ArrayList<NoteVO> list = new ArrayList<NoteVO>();
						list.add(note);
						map.put(categoryId, list);
					} else {
						map.get(categoryId).add(note);
					}
					
				} while (rs.next());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		}
		
		return map;
	}

	// 선호 카테고리 - 최신글
	@Override
	public List<NoteVO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException {

		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		
	    List<NoteVO> posts = new ArrayList<>();
	    String sql = "SELECT note_idx, title, img " +
                   "FROM ( " +
                   "    SELECT note_idx, title, img, ROW_NUMBER() OVER (ORDER BY create_at DESC) as rn " +
                   "    FROM note " +
                   "    WHERE category_idx = ? " +
                   ") " +
                   "WHERE rn <= ?";

	     try {
	            conn = ConnectionProvider.getConnection();
	    	 	pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, categoryIdx);
	            pstmt.setInt(2, limit);
	            rs = pstmt.executeQuery();

	            while (rs.next()) {
	            	NoteVO post = new NoteVO();
	                post.setNote_idx(rs.getInt("note_idx"));
	                post.setTitle(rs.getString("title"));
	                post.setImg(rs.getString("img")); // CLOB에서 문자열로 읽는다고 가정
	                posts.add(post);
	            }
	     } catch (Exception e) {
				e.printStackTrace();
		 } finally {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
	     }
	     
	     return posts;
	 }

	// 선호 카테고리 - 인기글
	@Override
	public List<NoteVO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException {
		List<NoteVO> posts = new ArrayList<>();
		
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		
		String sql = "SELECT " +
	             "    rnk.note_idx, n_orig.title, rnk.popularity_score, n_orig.img " + 
	             " FROM ( " +
	             "    SELECT " +
	             "        n.note_idx, " +
	             "        (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) AS popularity_score, " +
	             "        ROW_NUMBER() OVER (ORDER BY (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) DESC, n.create_at DESC) as rn " +
	             "    FROM note n LEFT JOIN likes l ON n.note_idx = l.note_idx " +
	             "    WHERE n.category_idx = ? " + 
	             "    GROUP BY n.note_idx, n.view_count, n.create_at " +
	             "		) rnk " +
	             " JOIN note n_orig ON rnk.note_idx = n_orig.note_idx " +
	             " WHERE rnk.rn <= ? " + 
	             " ORDER BY rnk.rn ";

        try {
            conn = ConnectionProvider.getConnection();
        	pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryIdx);
            pstmt.setInt(2, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	NoteVO post = new NoteVO();
                post.setNote_idx(rs.getInt("note_idx"));
                post.setTitle(rs.getString("title"));
                post.setImg(rs.getString("img"));
                posts.add(post);
            }
        } catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
        }
        
        return posts;
    }

}