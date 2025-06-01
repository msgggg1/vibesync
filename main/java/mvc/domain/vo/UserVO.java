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
public class UserVO { // 전체 사용자 정보 (DB와 1:1 대응)
	// DB 테이블과 1:1로 매핑되는 객체
	// 회원 정보 변경 시 DB에서 사용자 전체 정보를 가져올 때 사용
	// 민감한 정보도 포함 (예: 비밀번호 해시, 솔트 등)
	
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
