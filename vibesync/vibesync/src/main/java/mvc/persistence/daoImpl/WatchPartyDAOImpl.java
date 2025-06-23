package mvc.persistence.daoImpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.dto.WatchPartyDTO;
import mvc.domain.vo.UserSummaryVO;
import mvc.domain.vo.WatchPartyVO;
import mvc.persistence.dao.WSWatchPartyDAO;
import mvc.persistence.dao.WatchPartyDAO;

public class WatchPartyDAOImpl implements WSWatchPartyDAO {

   Connection conn = null;
   
   public WatchPartyDAOImpl() {}
   
    public WatchPartyDAOImpl(Connection conn) {
      this.conn = conn;
   }

   // 6) 여러 명의 호스트의 WatchParty 목록 조회
   @Override
   public List<WatchPartyDTO> selectWatchPartyListByHostId(List<Integer> hostList) throws SQLException {
      
      // 1. hostList가 비어있는 경우, DB에 접근할 필요 없이 즉시 빈 리스트를 반환합니다. (오류 방지)
       if (hostList == null || hostList.isEmpty()) {
           return new ArrayList<>();
       }
       
      List<WatchPartyDTO> watchPartyListByHost = new ArrayList<WatchPartyDTO>();
      
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer sql = new StringBuffer(" SELECT "
                                  + " watchparty_idx, title, video_id, w.created_at, host, nickname, img AS profile_img, category_idx "
                                  + " FROM watchparty w "
                                  + " JOIN userAccount u ON w.host = u.ac_idx "
                                  + " WHERE w.host IN ( ");
      
        for (int i = 0; i < hostList.size(); i++) {
         sql.append(hostList.get(i));
         if (i != hostList.size() - 1) {
            sql.append(", ");
         } else {
            sql.append(" ) ");
         }
      }
        
        pstmt = conn.prepareStatement(sql.toString());
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
          WatchPartyVO watchPartyVO = WatchPartyVO.builder()
                                       .watchPartyIdx(rs.getInt("watchparty_idx"))
                                       .title(rs.getString("title"))
                                       .videoId(rs.getString("video_id"))
                                       .createdAt(rs.getTimestamp("created_at"))
                                       .build();
         
         UserSummaryVO host = UserSummaryVO.builder()
                                    .ac_idx(rs.getInt("host"))
                                    .nickname(rs.getString("nickname"))
                                    .profile_img(rs.getString("profile_img"))
                                    .category_idx(rs.getInt("category_idx"))
                                    .build();
         
         WatchPartyDTO watchPartDTO = WatchPartyDTO.builder()
                                         .watchparty(watchPartyVO)
                                         .host(host)
                                         .build();
         
         watchPartyListByHost.add(watchPartDTO);
      }
      
      return watchPartyListByHost;
   }

}