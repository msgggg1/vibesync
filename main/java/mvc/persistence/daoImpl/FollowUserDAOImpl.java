package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.util.DBConn_vibesync;

import mvc.domain.vo.UserVO;
import mvc.persistence.dao.FollowUserDAO;

public class FollowUserDAOImpl implements FollowUserDAO {

    /**
     * 지정한 카테고리 내에서 팔로우를 가장 많이 받은 사용자들 상위 limit 만큼 가져온다.
     *
     * @param categoryIdx 카테고리 인덱스
     * @param limit       최대 반환할 사용자 수
     * @return            UserVO를 담은 ArrayList
     */
    public ArrayList<UserVO> getTopFollowed(int categoryIdx, int limit) {
        ArrayList<UserVO> list = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
            "SELECT * FROM ( " +
            "  SELECT u.ac_idx, u.email, u.nickname, u.img, u.name, u.created_at, u.category_idx, NVL(f.cnt,0) AS follow_count " +
            "    FROM userAccount u " +
            "    LEFT JOIN ( " +
            "      SELECT ac_following AS ac_idx, COUNT(*) AS cnt " +
            "        FROM follows " +
            "       GROUP BY ac_following " +
            "    ) f ON u.ac_idx = f.ac_idx " +
            "   WHERE u.category_idx = ? " +
            "   ORDER BY follow_count DESC " +
            ") WHERE ROWNUM <= ?";

        try {
            conn = DBConn_vibesync.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryIdx);
            pstmt.setInt(2, limit);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                list = new ArrayList<>();
                do {
                    UserVO vo = UserVO.builder()
                        .ac_idx(rs.getInt("ac_idx"))
                        .email(rs.getString("email"))
                        .nickname(rs.getString("nickname"))
                        .img(rs.getString("img"))
                        .name(rs.getString("name"))
                        .created_at(rs.getDate("created_at"))
                        .category_idx(rs.getInt("category_idx"))
                        .build();
                    list.add(vo);
                } while (rs.next());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // ResultSet, PreparedStatement만 닫고 Connection은 닫지 않음
            if (rs != null)    try { rs.close();    } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
        }

        return list;
    }
}
