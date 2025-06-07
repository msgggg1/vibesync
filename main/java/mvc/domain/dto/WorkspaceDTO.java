package mvc.domain.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import mvc.domain.vo.MessageVO;
import mvc.domain.vo.TodolistVO;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class WorkspaceDTO {
	
    private List<TodolistVO> todolists;
    private List<NoteSummaryDTO> myPosts;
    private List<NoteSummaryDTO> likedPosts;
    private List<MessageVO> unreadMessages;
    // private List<NoteSummaryDTO> postsByCategory;
    // private List<WatchPartyDTO> followingWatchParties;
    // private NoteStatsDTO userNoteStats;
    
}
