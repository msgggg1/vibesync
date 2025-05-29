package org.doit.domain;

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
@ToString
@Builder
public class UserAccountVO {
   private int ac_idx;
   private String email;
   private String pw;
   private String nickname; 
   private String img;
   private String name;
   private String created_at;
   private String salt;
}