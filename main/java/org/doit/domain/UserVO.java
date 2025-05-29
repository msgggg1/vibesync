package org.doit.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserVO {
	private int ac_idx;
	private String email;
	private String nickname;
	private String img;
	private String name;
	private Date created_at;
	private int category_idx;
}
