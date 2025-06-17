package mvc.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import mvc.domain.vo.MessageVO;
import mvc.domain.vo.UserSummaryVO;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MessageListDTO {

	private int ac_sender;
	private UserSummaryVO other;
	private int numOfUnreadMessages;
	private MessageDTO latestMessage;
	
}
