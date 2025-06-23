package mvc.svl;

import com.google.gson.Gson;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.vo.WaSyncVO;
import mvc.persistence.dao.WaSyncDAO;
import mvc.persistence.daoImpl.WaSyncDAOImpl;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/GetSyncStatusServlet")
public class GetSyncStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int wpIdx = Integer.parseInt(request.getParameter("watchPartyIdx"));
        WaSyncVO lastSync = null;
        Connection conn = null; // conn 변수를 try 블록 밖으로 이동

        try {
            conn = ConnectionProvider.getConnection(); // try 블록 안에서 conn 할당
            WaSyncDAO wsDao = new WaSyncDAOImpl(conn);
            lastSync = wsDao.selectLatestByWatchParty(wpIdx);
        } catch (NamingException | SQLException e) {
            e.printStackTrace();
            // 예외 발생 시 서버 에러 응답
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
            return;
        } finally {
            JdbcUtil.close(conn);
        }

        response.setContentType("application/json; charset=UTF-8");
        if (lastSync != null) {
            response.getWriter().write(gson.toJson(lastSync));
        } else {
            response.getWriter().write("{\"play\":\"PAUSE\",\"timeline\":0.0}");
        }
    }
}