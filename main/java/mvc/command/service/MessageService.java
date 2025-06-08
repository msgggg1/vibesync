package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.dto.MessageDTO;
import mvc.domain.dto.MessageListDTO;
import mvc.domain.vo.MessageVO;
import mvc.persistence.dao.MessageDAO;
import mvc.persistence.daoImpl.MessageDAOImpl;

public class MessageService {
	
	// 안읽은 메시지 목록
	public List<MessageListDTO> getUnreadMessageList(int acIdx) {
		List<MessageListDTO> unreadMessageList = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			MessageDAO messageDAO = new MessageDAOImpl(conn);
			unreadMessageList = messageDAO.getUnreadMessages(acIdx);
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return unreadMessageList;
	}

	// 채팅방 채팅 내역 열람
	public List<MessageDTO> getChatHistory(int ac_idx, int sender_idx) {
		List<MessageDTO> chatHistory = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			MessageDAO messageDAO = new MessageDAOImpl(conn);
			chatHistory = messageDAO.getChatHistory(ac_idx, sender_idx);
			if (chatHistory != null) {
				List<Integer> msg_idxList = new ArrayList<Integer>();
				Iterator<MessageDTO> ir = chatHistory.iterator();
				while (ir.hasNext()) {
					MessageDTO messageDTO = ir.next();
					msg_idxList.add(messageDTO.getMsg_idx());
				}
				messageDAO.updateChkMessage(msg_idxList);
				conn.commit();
			}
			
		} catch (NamingException e) {
			JdbcUtil.rollback(conn);
			e.printStackTrace();
		} catch (SQLException e) {
			JdbcUtil.rollback(conn);
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return chatHistory;
	}
	
	

}
