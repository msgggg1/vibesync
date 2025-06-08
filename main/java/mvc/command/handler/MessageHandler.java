package mvc.command.handler;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import mvc.command.service.MessageService;
import mvc.domain.vo.UserVO;

public class MessageHandler implements CommandHandler {

	private MessageService messageService;
	
	public MessageHandler() {
		this.messageService = new MessageService();
	}

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = null;
        Gson gson = new Gson();
        Object serviceResult = null;

        try {
            out = response.getWriter();

            HttpSession session = request.getSession(false);
            
    		// 요청 파라미터에서 보낸 사람 id값 가져오기 : senderIdx
            String senderIdxParam = request.getParameter("senderIdx");
            int senderIdx = 0, receiverIdx = 0;

            if (session != null) {
                Object attr = session.getAttribute("userInfo"); // "userInfo" 키로 조회
                UserVO userInfo = null;
                if (attr != null) {
                	userInfo = (UserVO) session.getAttribute("userInfo");
                	if (userInfo != null) {
                    	receiverIdx = userInfo.getAc_idx();
                    }
                }
                
            }

            if (senderIdxParam == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print(gson.toJson(Map.of("success", false, "message", "로그인이 필요합니다.")));
                return null;
            } else {
            	senderIdx = Integer.parseInt(senderIdxParam);
            }

            serviceResult = messageService.getChatHistory(receiverIdx, senderIdx);

            out.print(gson.toJson(serviceResult));

        } catch (NumberFormatException e) {
            if (out == null) out = response.getWriter();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(Map.of("success", false, "message", "유효하지 않은 게시글 ID 형식입니다.")));
            e.printStackTrace();
        } catch (Exception e) {
            if (out == null) out = response.getWriter();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("success", false, "message", "서버 내부 오류: " + e.getMessage())));
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.flush();
            }
        }
        
        return null;
	}
	
}
