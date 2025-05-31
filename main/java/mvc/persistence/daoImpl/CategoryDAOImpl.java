package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.util.DBConn_vibesync;

import mvc.domain.vo.CategoryVO;
import mvc.persistence.dao.CategoryDAO;

public class CategoryDAOImpl implements CategoryDAO {

    /**
     * 주어진 category_idx를 제외한 모든 카테고리 정보를 조회하여
     * CategoryVO 객체 리스트로 반환한다.
     *
     * @param category_idx 제외할 카테고리 인덱스
     * @return ArrayList<CategoryVO>
     */
    public ArrayList<CategoryVO> CategoryAll(int category_idx) {
        ArrayList<CategoryVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConn_vibesync.getConnection();
            String sql = "SELECT category_idx, c_name, img FROM category WHERE category_idx <> ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, category_idx);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                CategoryVO vo = CategoryVO.builder()
                    .category_idx(rs.getInt("category_idx"))
                    .c_name(rs.getString("c_name"))
                    .img(rs.getString("img"))
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
