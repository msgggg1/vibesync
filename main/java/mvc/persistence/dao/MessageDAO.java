package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.MessageDTO;
import mvc.domain.dto.MessageListDTO;

public interface MessageDAO {

    // 안읽은 메시지 목록
	public List<MessageListDTO> getUnreadMessages(int acIdx) throws SQLException;
	
	// 채팅 내역
	public List<MessageDTO> getChatHistory(int ac_idx, int sender_idx) throws SQLException;

	// 채팅 확인한 경우, 읽음 처리
	public boolean updateChkMessage(List<Integer> msg_idxList) throws SQLException;
}
