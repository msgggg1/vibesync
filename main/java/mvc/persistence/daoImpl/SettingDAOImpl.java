package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.util.JdbcUtil;

import mvc.persistence.dao.SettingDAO;

public class SettingDAOImpl implements SettingDAO {

	Connection conn = null;
	
	public SettingDAOImpl(Connection conn) {
		this.conn = conn;
	}

	// 테마 변경
	@Override
	public void updateTheme(int userAcIdx, String theme) {
		PreparedStatement pstmt = null;
		
		String sql = " UPDATE setting SET theme = ? WHERE ac_idx = ? ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, theme);
			pstmt.setInt(2, userAcIdx);
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}
	
	// 기존 테마 조회
	@Override
	public String selectTheme(int userAcIdx) {
		String theme = "light";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = " SELECT theme FROM setting WHERE ac_idx = ? ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userAcIdx);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				theme = rs.getString("theme");
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(pstmt);
		}
		
		return theme;
	}
	
}
