package mvc.command.service;

import java.util.ArrayList;
import java.util.List;

import mvc.domain.dto.NoteStatsDTO;
import mvc.domain.dto.NoteSummaryDTO;

public class NoteService {

	public List<NoteSummaryDTO> getMyPosts(int acIdx) {
		List<NoteSummaryDTO> myPosts = new ArrayList<NoteSummaryDTO>();
		
		return myPosts;
	}

	public List<NoteSummaryDTO> getLikedPosts(int acIdx) {
		List<NoteSummaryDTO> likedPosts = new ArrayList<NoteSummaryDTO>();
		
		return likedPosts;
	}
	
	public List<NoteSummaryDTO> getPostsByCategory(int categoryIdx, String sortType) {
		List<NoteSummaryDTO> postsByCategory = new ArrayList<NoteSummaryDTO>();
		
		return postsByCategory;
	}

	public NoteStatsDTO getUserNoteStats(int acIdx) {
		NoteStatsDTO userNoteStats = null;
		
		return userNoteStats;
	}

}
