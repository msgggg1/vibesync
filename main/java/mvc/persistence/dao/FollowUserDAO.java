package mvc.persistence.dao;

import java.util.ArrayList;

import mvc.domain.vo.UserVO;

public interface FollowUserDAO {

	ArrayList<UserVO> getTopFollowed(int categoryIdx, int limit);
	
}
