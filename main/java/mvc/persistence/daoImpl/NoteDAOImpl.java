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

import mvc.domain.dto.NoteDTO;
import mvc.domain.dto.NoteDetailDTO;
import mvc.domain.vo.NoteVO;
import mvc.persistence.dao.NoteDAO;

public class NoteDAOImpl implements NoteDAO {

	Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
	
    public NoteDAOImpl() {
        
    }

    
	public NoteDAOImpl(Connection conn) {
		this.conn = conn;
	}
	
	@Override
	// 전체 카테고리 - 인기글
	public Map<Integer, List<NoteVO>> popularNoteByAllCategory(int limit) throws SQLException {
		Map<Integer, List<NoteVO>> map = new LinkedHashMap<Integer, List<NoteVO>>();
		
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
			if(pstmt != null) pstmt.close();
			if(rs != null) rs.close();
		}
		
		return map;
	}

	// 선호 카테고리 - 최신글
	@Override
	public List<NoteVO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException {
		
	       List<NoteVO> posts = new ArrayList<>();
	       String sql = "SELECT note_idx, title, img " +
                   "FROM ( " +
                   "    SELECT note_idx, title, img, ROW_NUMBER() OVER (ORDER BY create_at DESC) as rn " +
                   "    FROM note " +
                   "    WHERE category_idx = ? " +
                   ") " +
                   "WHERE rn <= ?";

	        try {
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
	        	rs.close();
	        	pstmt.close();
	        }
	        return posts;
	    }

	// 선호 카테고리 - 인기글
	@Override
	public List<NoteVO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException {
		List<NoteVO> posts = new ArrayList<>();
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
			if(pstmt != null) pstmt.close();
			if(rs != null) rs.close();
        }
        return posts;
    }
	
	
	 @Override
	    public List<NoteDTO> findNotesByAcIdxPaged(int ac_idx, int offset, int limit) throws SQLException {
	        List<NoteDTO> notes = new ArrayList<>();
	        String sql = "SELECT note_idx, title, text, img, popularityScore, content_idx, genre_idx, category_idx " +
	                     "FROM ( " +
	                     "    SELECT " +
	                     "        n.note_idx, n.title, n.text, n.img, " +
	                     "        (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) AS popularityScore, " +
	                     "        n.content_idx, n.genre_idx, n.category_idx, " +
	                     "        ROW_NUMBER() OVER (ORDER BY n.create_at DESC) as rn " + // 최신순 정렬
	                     "    FROM note n " +
	                     "    LEFT JOIN likes l ON n.note_idx = l.note_idx " +
	                     "    WHERE n.ac_idx = ? " + 
	                     "    GROUP BY n.note_idx, n.title, n.text, n.img, n.view_count, n.content_idx, n.genre_idx, n.category_idx, n.create_at " + 
	                     ") " +
	                     "WHERE rn > ? AND rn <= ?"; // offset과 limit을 사용하여 페이지 범위 지정

	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, ac_idx);
	            pstmt.setInt(2, offset); // 시작 로우 (offset)
	            pstmt.setInt(3, offset + limit); 
	            rs = pstmt.executeQuery();

	            while (rs.next()) {
	                NoteDTO note = NoteDTO.builder()
	                               .note_idx(rs.getInt("note_idx"))
	                               .title(rs.getString("title"))
	                               .text(rs.getString("text"))
	                               .img(rs.getString("img"))
	                               .popularityScore(rs.getInt("popularityScore"))
	                               .content_idx(rs.getInt("content_idx"))
	                               .genre_idx(rs.getInt("genre_idx"))
	                               .category_idx(rs.getInt("category_idx"))
	                               .build();
	                notes.add(note);
	            }
	        } finally {
	            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
	        }
	        return notes;
	    }

	    @Override
	    public int countNotesByAcIdx(int ac_idx) throws SQLException {
	        int count = 0;
	        String sql = "SELECT COUNT(*) FROM note WHERE ac_idx = ?";
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, ac_idx);
	            rs = pstmt.executeQuery();
	            if (rs.next()) {
	                count = rs.getInt(1);
	            }
	        } finally {
	            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
	        }
	        return count;
	    }
	    
	    @Override
		  public NoteDetailDTO printNote(int noteIdx) { 
	        String sql = "SELECT "
	                   + "    n.note_idx, "
	                   + "    n.title, "
	                   + "    n.text, "
	                   + "    n.create_at, "
	                   + "    n.view_count, "
	                   + "    ua.ac_idx, "
	                   + "    ua.nickname, "
	                   + "    ua.img, " // 이 값으로 DTO의 img (프로필 사진) 필드를 채웁니다.
	                   + "    ( "
	                   + "        SELECT COUNT(*) "
	                   + "        FROM likes l "
	                   + "        WHERE l.note_idx = n.note_idx "
	                   + "    ) AS like_sum "
	                   + "FROM "
	                   + "    note n "
	                   + "JOIN "
	                   + "    userPage up ON n.userPg_idx = up.userPg_idx "
	                   + "JOIN "
	                   + "    userAccount ua ON up.ac_idx = ua.ac_idx "
	                   + "WHERE "
	                   + "    n.note_idx = ? ";

	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        NoteDetailDTO dto = null; // NoteDetailDTO 타입으로 변경, null로 초기화

	        try {
	            conn = ConnectionProvider.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, noteIdx);
	            rs = pstmt.executeQuery();

	            if (rs.next()) { // 단일 결과를 예상하므로 if 사용
	            	dto = new NoteDetailDTO(); // NoteDetailDTO 객체 생성

	                // DTO 필드명에 맞춰 SQL 별칭을 사용해 값 설정
	                dto.setNote_idx(rs.getInt("note_idx"));
	                dto.setTitle(rs.getString("title"));
	                dto.setText(rs.getString("text"));
	                dto.setCreate_at(rs.getTimestamp("create_at"));
	                dto.setView_count(rs.getInt("view_count"));
	                
	                dto.setAc_idx(rs.getInt("ac_idx"));
	                dto.setNickname(rs.getString("nickname"));
	                dto.setImg(rs.getString("img")); 
	            
	            }
	        } catch (SQLException e) {
	            e.printStackTrace(); 
	        } catch (NamingException e) {
	            e.printStackTrace();
	        } finally {
	            // 
	            try {
	                if (rs != null) rs.close();
	                if (pstmt != null) pstmt.close();
	                if (conn != null) conn.close();
	            } catch (SQLException e) { e.printStackTrace(); }
	            
	        }
	        return dto; 
	    }

		@Override
		public void increaseViewCount(int noteIdx) throws SQLException {
			    String sql = "UPDATE note SET view_count = view_count + 1 WHERE note_idx = ?";
			    Connection conn = null;
			    PreparedStatement pstmt = null;

			    try {
			        conn = ConnectionProvider.getConnection(); 
			        pstmt = conn.prepareStatement(sql);
			        pstmt.setInt(1, noteIdx);
			        pstmt.executeUpdate();
			    } catch (NamingException e) { 
			        e.printStackTrace(); 
			        throw new SQLException("DB 연결 또는 조회수 증가 중 오류 발생 (Naming)", e);
			    } catch (SQLException e) {
			        e.printStackTrace(); 
			        throw e; 
			    } finally {
			        try {
			            if (pstmt != null) pstmt.close();
			            if (conn != null) conn.close();
			        } catch (SQLException e) {
			            e.printStackTrace();
			        }
			    }
			}

}