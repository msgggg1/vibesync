package mvc.persistence.dao;

import java.sql.*;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.vo.WaSyncVO;

public interface WaSyncDAO {

    // 특정 WatchParty의 최근 sync 정보 가져오기 (마지막 재생 상태)
    public WaSyncVO selectLatestByWatchParty(int watchPartyIdx) throws NamingException, SQLException ;

    // 실시간 재생 정보 삽입 (WebSocket에서 호출)
    public int insert(WaSyncVO sync) throws NamingException, SQLException ;

    public int upsertByWatchParty(WaSyncVO vo) throws NamingException, SQLException ;
    
}
