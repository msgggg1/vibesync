package mvc.command.handler;

import java.sql.Connection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import mvc.persistence.dao.WatchPartyDAO;
import mvc.persistence.daoImpl.WatchPartyDAOImpl;

public class watchpartyDeleteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 요청 파라미터에서 hostIdx 가져오기
        String hostIdxStr = request.getParameter("hostIdx");
        if (hostIdxStr == null || hostIdxStr.trim().isEmpty()) {
            // hostIdx가 없는 경우, 에러 처리 또는 특정 페이지로 리다이렉트
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "hostIdx가 필요합니다.");
            return null;
        }
        
        int hostIdx = Integer.parseInt(hostIdxStr);
        Connection conn = null;
        
        try {
            // 2. DB 커넥션 가져오기 및 DAO 생성
            conn = ConnectionProvider.getConnection();
            WatchPartyDAO dao = new WatchPartyDAOImpl(conn);
            
            // 3. DAO를 통해 데이터 삭제
            dao.deleteByHost(hostIdx);

        } catch (Exception e) {
            e.printStackTrace();
            // 에러 발생 시 롤백 등의 처리가 필요할 수 있습니다.
            // 여기서는 간단히 에러를 출력하고 넘어갑니다.
            throw e; // 또는 에러 페이지로 이동
        } finally {
            JdbcUtil.close(conn);
        }
        
        // 4. 처리 완료 후, 목록 페이지로 리다이렉트
        // waList.jsp로 돌아가서 '내가 올린 영상' 탭이 보이도록 파라미터를 추가할 수 있습니다.
        String contextPath = request.getContextPath();
        response.sendRedirect(contextPath + "/vibesync/waList.jsp");
        
        return null; // 리다이렉트 했으므로 null 반환
    }
}