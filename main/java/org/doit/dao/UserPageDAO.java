package org.doit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.util.DBConn_vibesync;

import org.doit.domain.NoteVO;
import org.doit.domain.UserPage_UserVO;

public class UserPageDAO {

    /**
     * 주어진 user_idx로부터 사용자 정보와 팔로워/팔로우 수를 가져와 UserPage_UserVO에 담아 반환한다.
     *
     * @param userIdx 조회할 사용자 ac_idx
     * @return        UserPage_UserVO 객체 (없으면 null)
     */
    public static UserPage_UserVO getUserData(int userIdx) {
        UserPage_UserVO vo = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
            "SELECT "
          + "  u.ac_idx, u.email, u.nickname, u.img, u.name, u.created_at, u.category_idx, "
          + "  (SELECT COUNT(*) FROM follows WHERE ac_following = ?) AS follower, "
          + "  (SELECT COUNT(*) FROM follows WHERE ac_follow = ?) AS follow "
          + "FROM userAccount u "
          + "WHERE u.ac_idx = ?";

        try {
            conn = DBConn_vibesync.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userIdx); // follower 계산용: ac_following = userIdx
            pstmt.setInt(2, userIdx); // follow 계산용: ac_follow = userIdx
            pstmt.setInt(3, userIdx); // 메인 쿼리 WHERE u.ac_idx = userIdx

            rs = pstmt.executeQuery();
            if (rs.next()) {
                vo = UserPage_UserVO.builder()
                    .ac_idx(      rs.getInt("ac_idx"))
                    .email(       rs.getString("email"))
                    .nickname(    rs.getString("nickname"))
                    .img(         rs.getString("img"))
                    .name(        rs.getString("name"))
                    .created_at(  rs.getDate("created_at"))
                    .category_idx(rs.getInt("category_idx"))
                    .follower(    rs.getInt("follower"))
                    .follow(      rs.getInt("follow"))
                    .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs   != null) try { rs.close();   } catch (Exception ignored) {}
            if (pstmt!= null) try { pstmt.close();} catch (Exception ignored) {}
            // Connection은 닫지 않음
        }

        return vo;
    }
    
    /**
     * 주어진 사용자(ac_idx)가 작성한 모든 노트를 조회하여 반환한다.
     *
     * @param userIdx 조회할 사용자 ac_idx
     * @return        해당 사용자가 작성한 NoteVO 리스트 (없으면 빈 리스트)
     */
    public static ArrayList<NoteVO> getNotesByUser(int userIdx) {
        ArrayList<NoteVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
            "SELECT "
          + "  n.note_idx, n.title, n.text, n.img,"
          + "  TO_CHAR(n.create_at,'YYYY-MM-DD HH24:MI:SS') AS create_at, "
          + "  n.view_count, n.content_idx, n.genre_idx, "
          + "  n.category_idx, n.userPg_idx "
          + "FROM note n "
          + "JOIN userPage up ON n.userPg_idx = up.userPg_idx "
          + "WHERE up.ac_idx = ?";

        try {
            conn = DBConn_vibesync.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userIdx);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                NoteVO vo = NoteVO.builder()
                    .note_idx(   rs.getInt("note_idx"))
                    .title(      rs.getString("title"))
                    .text(       rs.getString("text"))
                    .img(        rs.getString("img"))			
                    .create_at(  rs.getString("create_at"))
                    .view_count( rs.getInt("view_count"))
                    .content_idx(rs.getInt("content_idx"))
                    .genre_idx(  rs.getInt("genre_idx"))
                    .category_idx(rs.getInt("category_idx"))
                    .userPg_idx( rs.getInt("userPg_idx"))
                    .build();
                list.add(vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs   != null) try { rs.close();   } catch (Exception ignored) {}
            if (pstmt!= null) try { pstmt.close();} catch (Exception ignored) {}
            // Connection은 닫지 않음
        }

        return list;
    }
    
}
