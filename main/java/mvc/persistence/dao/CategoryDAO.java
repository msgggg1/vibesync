package mvc.persistence.dao;

import java.util.ArrayList;

import mvc.domain.vo.CategoryVO;

public interface CategoryDAO {
	
	ArrayList<CategoryVO> CategoryAll(int category_idx);
	
}
