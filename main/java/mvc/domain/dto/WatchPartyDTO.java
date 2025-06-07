package mvc.domain.dto;

import java.sql.Timestamp;

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
public class WatchPartyDTO {
	
	private int watchParty_idx;
	private String title;
	private String video_id;
	private Timestamp created_at;
	private int host;

}
