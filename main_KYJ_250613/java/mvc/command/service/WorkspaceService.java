package mvc.command.service;

import java.time.LocalDate;
import java.util.List;

import mvc.domain.dto.BlockDTO;
import mvc.domain.dto.MessageListDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.dto.WorkspaceDTO;
import mvc.domain.vo.TodolistVO;

public class WorkspaceService {

    private TodolistService todolistService = new TodolistService();
    private NoteService noteService = new NoteService();
    private MessageService messageService = new MessageService();
    private BlockService blockService = new BlockService();
    

    public WorkspaceDTO getInitialData(int acIdx) {
        WorkspaceDTO dto = null;
        
        List<TodolistVO> todolists = todolistService.getTodolists(acIdx, LocalDate.now().getYear(), LocalDate.now().getMonthValue());
        List<NoteSummaryDTO> myPosts = noteService.getMyPosts(acIdx);
        List<NoteSummaryDTO> likedPosts = noteService.getLikedPosts(acIdx);
        List<MessageListDTO> unreadMessages = messageService.getUnreadMessageList(acIdx);
        List<BlockDTO> blocks = blockService.getBlocksForUser(acIdx);
        
        dto = new WorkspaceDTO().builder()
        					    .todolists(todolists)
        					    .myPosts(myPosts)
        					    .likedPosts(likedPosts)
        					    .unreadMessages(unreadMessages)
        					    .blocks(blocks)
        					    .build();

        return dto;
    }
}

