package mvc.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class NoteStatsDTO {
	
    private int totalViews = 0;
    private int totalLikes = 0;
    private int totalPosts = 0;
    
}
