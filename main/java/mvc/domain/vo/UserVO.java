package mvc.domain.vo;

import java.sql.Date;

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
public class UserVO {
	private int ac_idx;
	private String email;
	private String pw;
	private String salt;
	private String nickname;
	private String img;
	private String name;
	private Date created_at;
	private int category_idx;
}
