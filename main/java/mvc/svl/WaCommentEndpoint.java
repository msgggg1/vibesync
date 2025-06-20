package mvc.svl;

import javax.naming.NamingException;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;

import java.sql.SQLException;
import java.util.*;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import mvc.domain.vo.WaCommentVO;
import mvc.persistence.dao.WaCommentDAO;

/**
 * 클라이언트 간 채팅(댓글) 기능을 담당하는 Endpoint
 * URL: ws://[HOST]/[CONTEXT]/waCommentEndpoint
 */
@ServerEndpoint("/waCommentEndpoint")
public class WaCommentEndpoint {

    // watchPartyIdx 별 세션들
    private static Map<Integer, Set<Session>> partySessions = Collections.synchronizedMap(new HashMap<>());

    // DAO 객체를 멤버 변수로 생성 (DAO 내부는 상태를 가지지 않으므로 스레드에 안전)
    private WaCommentDAO commentDao = new WaCommentDAO(); 
    private Gson gson = new Gson();

    @OnOpen
    public void onOpen(Session session) {
        // 대기, 메시지에서 watchPartyIdx를 받아 등록
    }

    @OnMessage
    public void onMessage(String message, Session session) { // throws 절 제거
        JsonObject json = gson.fromJson(message, JsonObject.class);
        String type = json.get("type").getAsString();
        int wpIdx = json.get("watchPartyIdx").getAsInt();

        // 1) initComment: 최초 접속
        if ("initComment".equals(type)) {
            addSession(wpIdx, session);

            List<WaCommentVO> oldComments;
            try {
                // [수정] DAO 호출부를 try-catch로 감싸 예외를 처리합니다.
                oldComments = commentDao.selectByWatchParty(wpIdx);
            } catch (NamingException | SQLException e) {
                e.printStackTrace();
                // 오류 발생 시 클라이언트에 에러 메시지를 보내거나, 여기서 처리를 중단합니다.
                // 이 예외 처리가 없어 서버 스레드가 죽는 것이 문제의 원인이었습니다.
                return;
            }

            JsonArray arr = new JsonArray();
            for (WaCommentVO c : oldComments) {
                JsonObject obj = new JsonObject();
                obj.addProperty("nickname", c.getNickname());
                obj.addProperty("chatting", c.getChatting());
                obj.addProperty("timeline", c.getTimeline());
                if (c.getCreatedAt() != null) {
                    obj.addProperty("createdAt", c.getCreatedAt().toString());
                }
                arr.add(obj);
            }
            JsonObject resp = new JsonObject();
            resp.addProperty("type", "initCommentList");
            resp.add("comments", arr);
            session.getAsyncRemote().sendText(gson.toJson(resp));

        }
        // 2) comment: 신규 채팅
        else if ("comment".equals(type)) {
            String nickname = json.get("nickname").getAsString();
            String chatText = json.get("chatting").getAsString();
            double timeline = json.get("timeline").getAsDouble();

            WaCommentVO wc = new WaCommentVO();
            wc.setWatchPartyIdx(wpIdx);
            wc.setNickname(nickname);
            wc.setChatting(chatText);
            wc.setTimeline(timeline);

            try {
                // [수정] DAO 호출부를 try-catch로 감싸 예외를 처리합니다.
                commentDao.insert(wc);
            } catch (NamingException | SQLException e) {
                e.printStackTrace();
                return;
            }

            JsonObject broadcastMsg = new JsonObject();
            broadcastMsg.addProperty("type", "comment");
            broadcastMsg.addProperty("nickname", nickname);
            broadcastMsg.addProperty("chatting", chatText);
            broadcastMsg.addProperty("timeline", timeline);
            broadcastMsg.addProperty("timestamp", new Date().toString());

            broadcastToParty(wpIdx, gson.toJson(broadcastMsg));
        }
    }

    @OnClose
    public void onClose(Session session, CloseReason reason) {
        // [수정] 연결 종료 시 반드시 세션을 제거해야 합니다.
        removeSession(session);
    }

    @OnError
    public void onError(Session session, Throwable thr) {
        thr.printStackTrace();
        removeSession(session);
    }

    private void addSession(int wpIdx, Session session) {
        partySessions.computeIfAbsent(wpIdx, k -> Collections.synchronizedSet(new HashSet<>())).add(session);
        session.getUserProperties().put("watchPartyIdx", wpIdx);
    }

    private void removeSession(Session session) {
        Integer wpIdx = (Integer) session.getUserProperties().get("watchPartyIdx");
        if (wpIdx != null && partySessions.containsKey(wpIdx)) {
            partySessions.get(wpIdx).remove(session);
            if (partySessions.get(wpIdx).isEmpty()) {
                partySessions.remove(wpIdx);
            }
        }
    }

    private void broadcastToParty(int wpIdx, String message) {
        if (partySessions.containsKey(wpIdx)) {
            Set<Session> sessions = new HashSet<>(partySessions.get(wpIdx));
            for (Session s : sessions) {
                if (s.isOpen()) {
                    s.getAsyncRemote().sendText(message);
                }
            }
        }
    }
}