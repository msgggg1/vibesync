package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.persistence.dao.SettingDAO;
import mvc.persistence.daoImpl.SettingDAOImpl;

public class SettingService {

	// 변경된 테마 설정값 적용
	public void setTheme (int userAcIdx, String theme) {
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			SettingDAO settingDAO = new SettingDAOImpl(conn);
			settingDAO.updateTheme(userAcIdx, theme);
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
	}

	// 기존의 테마 설정값 불러오기
	public String getTheme (int userAcIdx) {
		String theme = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			SettingDAO settingDAO = new SettingDAOImpl(conn);
			theme = settingDAO.selectTheme(userAcIdx);
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return theme;
	}
}
