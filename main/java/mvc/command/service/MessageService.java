package mvc.command.service;

import java.util.ArrayList;
import java.util.List;

import mvc.domain.vo.MessageVO;

public class MessageService {

	public List<MessageVO> getUnreadMessages(int acIdx) {
		List<MessageVO> unreadMessages = new ArrayList<MessageVO>();
		
		return unreadMessages;
	}

	public List<MessageVO> getChatHistory(int sender_idx, int ac_idx) {
		List<MessageVO> chatHistory = new ArrayList<MessageVO>();
		
		return chatHistory;
	}

}
