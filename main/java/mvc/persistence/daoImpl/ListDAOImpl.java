package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import mvc.domain.vo.PageVO;
import mvc.persistence.dao.ListDAO;

public class ListDAOImpl implements ListDAO {
    private Connection conn;

    public ListDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public int selectCount(String searchType, String keyword) throws SQLException {
        String sql = "SELECT COUNT(*) FROM userPage";

        if (keyword != null) {
            if ("subject".equals(searchType)) {
                sql += " WHERE subject LIKE ?";
            } else if ("content".equals(searchType)) {
                sql += " WHERE content LIKE ?";
            } else if ("subject_content".equals(searchType)) {
                sql += " WHERE subject LIKE ? OR content LIKE ?";
            }
        }

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                if ("subject_content".equals(searchType)) {
                    pstmt.setString(1, kw);
                    pstmt.setString(2, kw);
                } else {
                	System.out.println("keyword: " + sql);
                    pstmt.setString(1, kw);
                }
            }
            System.out.print("sql1 : " + sql);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    @Override
    public List<PageVO> selectAll(String searchType, String keyword) throws SQLException {
        String sql = "SELECT userpg_idx, subject, thumbnail, created_at, ac_idx, re_userpg_idx FROM userPage";

        if (keyword != null && !keyword.isEmpty()) {
            if ("subject".equals(searchType)) {
                sql += " WHERE subject LIKE ?";
            } else if ("content".equals(searchType)) {
                sql += " WHERE content LIKE ?";
            } else if ("subject_content".equals(searchType)) {
                sql += " WHERE subject LIKE ? OR content LIKE ?";
            }
        }

        sql += " ORDER BY userpg_idx DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                if ("subject_content".equals(searchType)) {
                    pstmt.setString(1, kw);
                    pstmt.setString(2, kw);
                } else {
                    pstmt.setString(1, kw);
                }
            }
            System.out.print("sql2 : " + sql);
            try (ResultSet rs = pstmt.executeQuery()) {
                List<PageVO> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(PageVO.builder()
                        .userpg_idx(rs.getInt("userpg_idx"))
                        .subject(rs.getString("subject"))
                        .thumbnail(rs.getString("thumbnail"))
                        .created_at(rs.getTimestamp("created_at"))
                        .ac_idx(rs.getInt("ac_idx"))
                        .re_userpg_idx(rs.getInt("re_userpg_idx"))
                        .build());
                }
                return list;
            }
        }
    }
}
