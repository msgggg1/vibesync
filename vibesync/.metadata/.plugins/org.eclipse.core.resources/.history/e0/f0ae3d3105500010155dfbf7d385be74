<%@page import="mvc.persistence.dao.WatchPartyDAO"%>
<%@page import="com.util.ConnectionProvider"%>
<%@page import="java.sql.Connection"%>
<%@page import="mvc.domain.vo.UserVO"%>
<%@page import="mvc.domain.vo.WatchPartyVO"%>
<%@page import="mvc.persistence.daoImpl.WatchPartyDAOImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String contextPath = request.getContextPath();
UserVO user = (UserVO) session.getAttribute("userInfo");
String nickname = "익명";
if (user != null) {
    nickname = user.getNickname();
}
    String strIdx = request.getParameter("watchPartyIdx");
    int watchPartyIdx = Integer.parseInt(strIdx);

    WatchPartyDAO wpDao = new WatchPartyDAO();
    WatchPartyVO wp = wpDao.selectOne(watchPartyIdx);

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Watch Party - <%= wp.getTitle() %></title>
    <link rel="icon" href="./sources/favicon.ico" />
    <style>
        body { background: #000; color: #fff; font-family: Arial, sans-serif; width: 100%; height: 98vh; margin: 0;}
        h1 {margin: 0; height: 6%; font-size: min(28px, 4vw);}
        section.container {height: 94%; display: flex; justify-content: center; align-items: center;}
       @media (max-width: 768px) { section.container { flex-direction: column; height: 84%; align-items: normal; } .videowrapper { flex: 5 !important; } .chatting-wrapper { margin-top: 14px; flex: 3 !important; } }
        .videowrapper {flex: 7; height: 100%; display: flex; flex-direction: column;}
        .chatting-wrapper {flex: 2; height: 100%;}
        #video-container { text-align: center; width: 100%; height: 94%;}
        iframe {width: 100%; height: 100%;}
        #chat-container { -ms-overflow-style: none; border: 1px solid #ccc; height: 92%; overflow-y: scroll; padding: 0.5rem; word-break: break-all; }
        #chat-container::-webkit-scrollbar { display:none; }
        #chat-input { color: #fff; border: solid 2px #fff; width: 100%; padding: 10px 0.5rem; background-color: transparent; border-top: none; outline: none; }
        #sync-wrapper { display: flex; justify-content: space-between; padding-inline: 12px; margin-top: 16px; }
        #send-btn { padding: 0; border: solid 2px #fff; background-color: transparent; border-left: none; border-top: none; height: 37px; color: #fff; font-size: 10px; }
        #status { margin-top: 0.5rem; font-size: 0.9rem; color: gray; }
        #sync-button { padding: 0.5rem 1rem; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; }
        #sync-status-message { font-size: min(16px, 3.2vw); margin-top: 0.5rem; color: #d9534f; }
        .host-chat { color: red; text-align: center; }
    </style>
</head>
<body>
    <h1><%= wp.getTitle() %></h1>
    <section class="container">
        <div class="videowrapper">
            <div id="video-container">
                <iframe id="youtube-player" src="https://www.youtube.com/embed/<%= wp.getVideoId() %>?enablejsapi=1" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
            </div>
            <div id="sync-wrapper">
                <div id="sync-status-message"></div>
                <button id="sync-button">Sync</button>
            </div>
        </div>
        <div class="chatting-wrapper">
            <div id="chat-container"></div>
            <div style="margin-top: 0px; display: flex; align-items: center;">
                <input type="text" id="chat-input" placeholder="메시지를 입력하세요..." />
                <button id="send-btn">전송</button>
            </div>
        </div>
    </section>

    <script src="https://www.youtube.com/iframe_api"></script>
    <script>
        const CONTEXT_PATH   = '<%= contextPath %>';
        const watchPartyIdx  = <%= watchPartyIdx %>;
        const hostIdx        = '<%= wp.getHost() %>';
        
        console.log("VIEWER: 페이지 시작, wpIdx=", watchPartyIdx);

        let player, wsSync, wsComment;
        let playState        = false;
        let latestTimeline   = 0.0;
        let isSynced         = false;
        let allComments = [], commentDisplayInterval = null, nextCommentIndex = 0;

        function onYouTubeIframeAPIReady() {
            console.log("VIEWER: onYouTubeIframeAPIReady 호출됨");
            player = new YT.Player('youtube-player', {
                events: { onReady: onPlayerReady, onStateChange: onPlayerStateChange }
            });
        }

        function onPlayerReady(event) {
            console.log("VIEWER: onPlayerReady, 플레이어 준비 완료. WS 연결 및 상태 가져오기 시작.");
            connectWebSocket();
            fetch(`<%= contextPath %>/GetSyncStatusServlet?watchPartyIdx=<%= watchPartyIdx %>`)
            .then(res => res.json())
            .then(data => {
                console.log("VIEWER: 초기 Sync 상태 수신", data);
                playState = (data.play === "PLAY");
                latestTimeline = data.timeline;
                if (playState) {
                    document.getElementById('sync-status-message').textContent = '호스트가 재생 중입니다. Sync 버튼을 눌러주세요.';
                } else {
                    document.getElementById('sync-status-message').textContent = '';
                }
            })
            .catch(err => console.error("VIEWER: 초기 Sync 상태 가져오기 실패", err));
        }

        function onPlayerStateChange(event) {
            console.log(`VIEWER: onPlayerStateChange, 상태: ${event.data}`);
            if (event.data === YT.PlayerState.PLAYING) {
                startCommentDisplay();
            } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
                stopCommentDisplay();
            }
        }

        function connectWebSocket() {
            console.log("VIEWER: WebSocket 연결 시도...");
            wsSync = new WebSocket("ws://" + location.host + CONTEXT_PATH + "/waSyncEndpoint");
            wsSync.onopen = () => {
                 console.log("VIEWER: Sync WS 연결 성공. initSync 전송.");
                 const initMsg = JSON.stringify({ type: "initSync", watchPartyIdx: watchPartyIdx });
                 wsSync.send(initMsg);
            };
            wsSync.onmessage = (event) => {
                const msg = JSON.parse(event.data);
                console.log("VIEWER: Sync WS 메시지 수신", msg);
                if (msg.type === "sync" && msg.watchPartyIdx === watchPartyIdx) {
                    latestTimeline = msg.timeline;
                    playState = (msg.play === "PLAY");
                    if (isSynced) {
                        console.log("VIEWER: 동기화된 상태. 플레이어 제어 시도.");
                        const currentTime = player.getCurrentTime();
                        if (Math.abs(currentTime - latestTimeline) > 2) {
                            console.log(`VIEWER: 시간 차이 > 2초. 강제 이동. ${currentTime} -> ${latestTimeline}`);
                            player.seekTo(latestTimeline, true);
                        }
                        if (playState) {
                            console.log("VIEWER: playVideo() 호출");
                            player.playVideo();
                        } else {
                            console.log("VIEWER: pauseVideo() 호출");
                            player.pauseVideo();
                        }
                    } else {
                        console.log("VIEWER: 동기화 전 상태. 플레이어 제어 안함.");
                    }
                }
            };
            wsSync.onclose = () => console.log("VIEWER: Sync WS 연결 종료");
            wsSync.onerror = (err) => console.error("VIEWER: Sync WS 에러", err);

            wsComment = new WebSocket("ws://" + location.host + CONTEXT_PATH + "/waCommentEndpoint");
            wsComment.onopen = () => {
                console.log("VIEWER: Comment WS 연결 성공. initComment 전송.");
                const initMsg = JSON.stringify({ type: "initComment", watchPartyIdx: watchPartyIdx });
                wsComment.send(initMsg);
            };
            wsComment.onmessage = (event) => {
                const msg = JSON.parse(event.data);
                console.log("VIEWER: Comment WS 메시지 수신", msg);
                if (msg.type === "comment") {
                    appendChat(msg.nickname, msg.chatting, msg.timeline, msg.timestamp);
                } else if (msg.type === "initCommentList") {
                    allComments = msg.comments.sort((a, b) => a.timeline - b.timeline);
                    nextCommentIndex = 0;
                    document.getElementById("chat-container").innerHTML = '';
                }
            };
            wsComment.onclose = () => console.log("VIEWER: Comment WS 연결 종료");
            wsComment.onerror = (err) => console.error("VIEWER: Comment WS 에러", err);

            document.getElementById("send-btn").addEventListener("click", () => {
                const input = document.getElementById("chat-input");
                const text = input.value.trim();
                if (text === "") return;
                const currentTime = player.getCurrentTime();
                const nickname = `<%=nickname %>`;
                const chatMsg = JSON.stringify({
                    type: "comment", watchPartyIdx: watchPartyIdx, nickname: nickname,
                    chatting: text, timeline: currentTime
                });
                console.log("VIEWER: 채팅 메시지 전송 ->", chatMsg);
                wsComment.send(chatMsg);
                input.value = "";
            });
            document.getElementById("chat-input").addEventListener("keydown", (event) => {
                // 엔터 키가 눌렸고, 입력 값이 비어있지 않은지 확인합니다.
                if (event.key === 'Enter' && event.target.value.trim() !== "") {
                    // 기본 동작(예: 폼 제출)을 방지합니다.
                    event.preventDefault();
                    // "전송" 버튼의 클릭 이벤트를 강제로 발생시켜 기존 로직을 재사용합니다.
                    document.getElementById("send-btn").click();
                }
            });
        }
       
        document.getElementById("sync-button").addEventListener("click", () => {
            console.log("VIEWER: Sync 버튼 클릭. 최신 상태 다시 요청.");
            fetch(`<%= contextPath %>/GetSyncStatusServlet?watchPartyIdx=<%= watchPartyIdx %>`)
            .then(res => res.json())
            .then(data => {
                console.log("VIEWER: Sync 버튼용 상태 수신", data);
                playState = (data.play === "PLAY");
                latestTimeline = data.timeline;
                if (playState) {
                    console.log("VIEWER: Sync 시작! seekTo 및 playVideo 호출.");
                    player.seekTo(latestTimeline, true);
                    player.playVideo();
                    isSynced = true;
                    document.getElementById("sync-status-message").textContent = '';
                } else {
                    document.getElementById("sync-status-message").textContent = '아직 재생 중이 아닙니다.';
                }
            })
            .catch(err => {
                console.error("VIEWER: Sync 버튼 상태 가져오기 실패", err);
                document.getElementById("sync-status-message").textContent = '동기화 상태를 가져오는 중 오류가 발생했습니다.';
            });
        });
        
        // 이하 나머지 헬퍼 함수들은 수정 없이 그대로 유지됩니다.
        function appendChat(nick, text, timeline, timestamp) {
            const chatContainer = document.getElementById("chat-container");
            const p = document.createElement("p");
            const timeLabel = formatTime(timeline);
            if (nick === "host") {
                p.classList.add('host-chat');
                p.innerHTML = "<strong><< " + text + " >></strong>";
            } else {   
                p.innerHTML = "<strong>[" + timeLabel + "] " + nick + ":</strong> " + text;
            }
            chatContainer.appendChild(p);
            chatContainer.scrollTop = chatContainer.scrollHeight;
        }
       
        function startCommentDisplay() {
            if (commentDisplayInterval) { clearInterval(commentDisplayInterval); }
            commentDisplayInterval = setInterval(() => {
                const currentTime = player.getCurrentTime();
                while (nextCommentIndex < allComments.length && allComments[nextCommentIndex].timeline <= currentTime) {
                    const comment = allComments[nextCommentIndex];
                    appendChat(comment.nickname, comment.chatting, comment.timeline, comment.createdAt);
                    nextCommentIndex++;
                }
            }, 1000);
        }

        function stopCommentDisplay() {
            if (commentDisplayInterval) { clearInterval(commentDisplayInterval); commentDisplayInterval = null; }
        }

        function formatTime(sec) {
            const m = Math.floor(sec / 60);
            const s = Math.floor(sec % 60);
            return (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);
        }
    </script>
</body>
</html>