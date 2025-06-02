package mvc.command.service;

import mvc.domain.vo.UserSessionVO;
import mvc.persistence.dao.CategoryDAO;

public class MainPageService {
	private CategoryDAO categoryDAO;

	public MainPageService(CategoryDAO categoryDAO) {
		this.categoryDAO = categoryDAO;
	}
	
	// 관심 카테고리 인기 유저 목록 출력
	public UserSessionVO login(int userInfo) throws Exception {
		UserSessionVO userSessionVO = null;
		userSessionVO = userAccountDAO.login(dto);
		
        return userSessionVO;
    }
	
}
