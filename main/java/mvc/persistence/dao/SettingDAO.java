package mvc.persistence.dao;

public interface SettingDAO {

	// 테마 변경
	void updateTheme(int userAcIdx, String theme);

	// 기존 테마 조회
	String selectTheme(int userAcIdx);
	
}
