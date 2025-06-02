package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import mvc.domain.vo.CategoryVO;
import mvc.persistence.dao.CategoryDAO;

public class CategoryDAOImpl implements CategoryDAO {
    private Connection conn = null;
    private PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 생성자
    public CategoryDAOImpl(Connection conn) {
    	this.conn = conn;
    }
    
    // 모든 카테고리 정보 조회
    public ArrayList<CategoryVO> CategoryAll() {
    	ArrayList<CategoryVO> list = new ArrayList<CategoryVO>();

    	String sql = " SELECT category_idx, c_name, img FROM category ";
    	
        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int category_idx = rs.getInt("category_idx");
                String c_name = rs.getString("c_name");
                String img = rs.getString("img");
            	
            	CategoryVO vo = CategoryVO.builder()
            							  .category_idx(category_idx)
            							  .c_name(c_name)
            							  .img(img)
            							  .build();
                list.add(vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null)    try { rs.close();    } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
        }

        return list;
    }
}
