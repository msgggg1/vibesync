package mvc.persistence.dao;

import java.util.ArrayList;

import mvc.domain.vo.CategoryVO;

public interface CategoryDAO {
	
	// 모든 카테고리 정보 조회
	ArrayList<CategoryVO> CategoryAll();
	
}
