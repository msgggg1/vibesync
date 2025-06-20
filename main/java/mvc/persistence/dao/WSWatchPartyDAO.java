package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.WatchPartyDTO;
import mvc.domain.vo.WatchPartyVO;

public interface WSWatchPartyDAO { 
   // 6) 여러 명의 호스트의 WatchParty 목록 조회
   public List<WatchPartyDTO> selectWatchPartyListByHostId(List<Integer> hostList) throws SQLException;

}