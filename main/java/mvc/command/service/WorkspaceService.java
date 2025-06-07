package mvc.command.service;

import java.time.LocalDate;
import java.util.List;

import mvc.domain.dto.NoteStatsDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.dto.WatchPartyDTO;
import mvc.domain.dto.WorkspaceDTO;
import mvc.domain.vo.MessageVO;
import mvc.domain.vo.TodolistVO;

public class WorkspaceService {

    private TodolistService todolistService = new TodolistService();
    private NoteService noteService = new NoteService();
    private MessageService messageService = new MessageService();
    private WatchPartyService watchPartyService = new WatchPartyService();

    public WorkspaceDTO getInitialData(int acIdx) {
        WorkspaceDTO dto = null;
        
        List<TodolistVO> todolists = todolistService.getTodolists(acIdx, LocalDate.now().getYear(), LocalDate.now().getMonthValue());
        List<NoteSummaryDTO> myPosts = noteService.getMyPosts(acIdx);
        List<NoteSummaryDTO> likedPosts = noteService.getLikedPosts(acIdx);
        List<MessageVO> unreadMessages = messageService.getUnreadMessages(acIdx);
        // List<NoteSummaryDTO> postsByCategory = noteService.getPostsByCategory(acIdx, null);
        // List<WatchPartyDTO> followingWatchParties = watchPartyService.getFollowingWatchParties(acIdx);
        // NoteStatsDTO userNoteStats = noteService.getUserNoteStats(acIdx);
        
        dto = new WorkspaceDTO().builder()
        					    .todolists(todolists)
        					    .myPosts(myPosts)
        					    .likedPosts(likedPosts)
        					    .unreadMessages(unreadMessages)
        					    // .postsByCategory(postsByCategory)
        					    // .followingWatchParties(followingWatchParties)
        					    // .userNoteStats(userNoteStats)
        					    .build();

        return dto;
    }
}

