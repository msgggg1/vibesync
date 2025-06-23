<%@page import="mvc.domain.vo.UserVO"%>
<%@page import="mvc.domain.vo.WatchPartyVO"%>
<%@page import="mvc.persistence.daoImpl.WatchPartyDAOImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String contextPath = request.getContextPath();
UserVO user = (UserVO) session.getAttribute("userInfo");
String nickname = "익명";
if (user != null) {
    nickname = user.getNickname(); // getter로 접근
}
    // 1) 파라미터로 전달된 watchPartyIdx를 가져옴
    String strIdx = request.getParameter("watchPartyIdx");
    int watchPartyIdx = Integer.parseInt(strIdx);

    // 2) DAO를 통해 해당 WatchParty 정보(제목, video_id 등)를 가져옴
    WatchPartyDAOImpl wpDao = new WatchPartyDAOImpl();
    WatchPartyVO wp = wpDao.selectOne(watchPartyIdx);
%>
<!DOCTYPE html>    
<html>
<head>
    <meta charset="UTF-8">
    <title>Watch Party - <%= wp.getTitle() %></title>
    <link rel="icon" href="./sources/favicon.ico" />
    <style>
        body { background: #000; color: #fff; font-family: Arial, sans-serif; width: 100%; height: 100vh; margin: 0;}
        h1 {margin: 0; height: 6%;}
        section.container {height: 94%; display: flex; justify-content: center; align-items: center;}
        .videowrapper {flex: 7; height: 100%; display: flex; flex-direction: column;}
        .chatting-wrapper {flex: 2; height: 100%;} 
        #video-container { text-align: center; width: 100%; height: 94%;}
        iframe {width: 100%; height: 100%;}
        #chat-container { 
            -ms-overflow-style: none;
            border: 1px solid #ccc;
            height: 92.48%;
            overflow-y: scroll;
            padding: 0.5rem;
        }
        #chat-container::-webkit-scrollbar {
            display:none;
        }
        #chat-input { width: calc(100% - 110px); padding: 0.5rem; }
        #sync-wrapper {
            display: flex;
            justify-content: space-between;
            padding-inline: 12px;
            margin-top: 16px;
        }
        #send-btn { width: 80px; padding: 0.5rem; }
        #status { margin-top: 0.5rem; font-size: 0.9rem; color: gray; }
        #sync-button {
            padding: 0.5rem 1rem;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        #sync-status-message {
            margin-top: 0.5rem;
            color: #d9534f; /* 빨간색 경고 메시지 */
        }
        .host-chat {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>
    <h1><%= wp.getTitle() %></h1>

    <section class="container">
        <div class="videowrapper">
            <div id="video-container">
                <iframe id="youtube-player"
                        src="https://www.youtube.com/embed/<%= wp.getVideoId() %>?enablejsapi=1"
                        frameborder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowfullscreen>
                </iframe>
            </div>
            
            <div id="sync-wrapper">
                <div id="sync-status-message"></div>
                <button id="sync-button">Sync</button>
            </div>
        </div>
    
        <div class="chatting-wrapper">
            <div id="chat-container"></div>
            <div style="margin-top: 12px;">
                <input type="text" id="chat-input" placeholder="메시지를 입력하세요..." />
                <button id="send-btn">전송</button>
            </div>
        </div>
    </section>

    <script src="https://www.youtube.com/iframe_api"></script>
    <script>
        // JSP 표현식으로 서버 변수 주입
        const CONTEXT_PATH   = '<%= contextPath %>';
        const watchPartyIdx  = <%= watchPartyIdx %>;
        const hostIdx        = '<%= wp.getHost() %>';

        let player, wsSync, wsComment;
        let playState        = false;   // DB 기준 현재 play 상태 저장
        let latestTimeline   = 0.0;
        let isSynced         = false;   // <<<<< 수정: 최초 Sync 버튼 클릭 여부 판단
        
        // [신규] 타임라인 기반 댓글 표시를 위한 전역 변수
        let allComments = []; // 서버에서 받은 모든 댓글 저장
        let commentDisplayInterval = null; // 댓글 표시용 setInterval ID
        let nextCommentIndex = 0; // 다음에 표시할 댓글의 인덱스

        // 1) YouTube IFrame API 준비
        function onYouTubeIframeAPIReady() {
            player = new YT.Player('youtube-player', {
                events: {
                    onReady: onPlayerReady,
                    onStateChange: onPlayerStateChange
                }
            });
        }

        // 2) 플레이어 준비 완료 시: 마지막 동기화 상태 가져오기
        function onPlayerReady(event) {
            connectWebSocket();
            fetch(`<%= contextPath %>/GetSyncStatusServlet?watchPartyIdx=<%= watchPartyIdx %>`)
            .then(res => res.json())
            .then(data => {
                playState = (data.play === "PLAY");
                latestTimeline = data.timeline;
                if (playState) {
                    document.getElementById('sync-status-message').textContent = '호스트가 재생 중입니다. Sync 버튼을 눌러주세요.';
                } else {
                    document.getElementById('sync-status-message').textContent = '';
                }
            })
            .catch(err => console.error(err));
        }

        // 3) 플레이어 상태 변경 시
        function onPlayerStateChange(event) {
            // [수정] 재생 상태에 따라 댓글 타임라인 타이머 제어
            if (event.data === YT.PlayerState.PLAYING) {
                startCommentDisplay();
            } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
                stopCommentDisplay();
            }

            if (!isSynced) return; // Sync 이전에는 stateChange 무시
            
            if (event.data === YT.PlayerState.PLAYING || event.data === YT.PlayerState.PAUSED) {
                const timeline = player.getCurrentTime();
                const playStr = (event.data === YT.PlayerState.PLAYING) ? "PLAY" : "PAUSE";
                const syncMsg = JSON.stringify({ type: "sync", watchPartyIdx: watchPartyIdx, timeline: timeline, play: playStr });
                wsSync.send(syncMsg);
            }
        }

        // 4) WebSocket 연결 함수
        function connectWebSocket() {
            // 4-1) 재생 동기화 WS
            wsSync = new WebSocket("ws://" + location.host + CONTEXT_PATH + "/waSyncEndpoint");
            wsSync.onopen = () => {
                 const initMsg = JSON.stringify({ type: "initSync", watchPartyIdx: watchPartyIdx });
                 wsSync.send(initMsg);
            };
            wsSync.onmessage = (event) => {
                const msg = JSON.parse(event.data);
                if (msg.type === "sync" && msg.watchPartyIdx === watchPartyIdx) {
                    latestTimeline = msg.timeline;
                    playState = (msg.play === "PLAY");
                    if (isSynced) {
                        if (playState) { player.playVideo(); } else { player.pauseVideo(); }
                    }
                }
            };

            // 4-2) 채팅 WS
            wsComment = new WebSocket("ws://" + location.host + CONTEXT_PATH + "/waCommentEndpoint");
            wsComment.onopen = () => {
                const initMsg = JSON.stringify({ type: "initComment", watchPartyIdx: watchPartyIdx });
                wsComment.send(initMsg);
            };
            wsComment.onmessage = (event) => {
                const msg = JSON.parse(event.data);
                
                // [수정] 실시간 댓글과 초기 댓글 로딩 로직 분리
                if (msg.type === "comment") {
                    // 실시간으로 받은 새 댓글은 즉시 표시만 하고, allComments 배열에 추가하지 않아 중복을 방지.
                    appendChat(msg.nickname, msg.chatting, msg.timeline, msg.timestamp);

                } else if (msg.type === "initCommentList") {
                    // 초기 댓글 목록은 전역 변수에 저장하고 정렬.
                    allComments = msg.comments.sort((a, b) => a.timeline - b.timeline);
                    nextCommentIndex = 0; // 인덱스 초기화
                    document.getElementById("chat-container").innerHTML = ''; // 채팅창 비우기
                }
            };

            // 5) 채팅 전송 버튼 이벤트
            document.getElementById("send-btn").addEventListener("click", () => {
                const input = document.getElementById("chat-input");
                const text = input.value.trim();
                if (text === "") return;
                const currentTime = player.getCurrentTime();
                const nickname = `<%=nickname %>`;
                const chatMsg = JSON.stringify({
                    type: "comment",
                    watchPartyIdx: watchPartyIdx,
                    nickname: nickname,
                    chatting: text,
                    timeline: currentTime
                });
                wsComment.send(chatMsg);
                input.value = "";
            });
        }
        
        // 6) Sync 버튼 클릭 핸들러
        document.getElementById("sync-button").addEventListener("click", () => {
            fetch(`<%= contextPath %>/GetSyncStatusServlet?watchPartyIdx=<%= watchPartyIdx %>`)
            .then(res => res.json())
            .then(data => {
                playState = (data.play === "PLAY");
                latestTimeline = data.timeline;
                if (playState) {
                    player.seekTo(latestTimeline, true);
                    player.playVideo();
                    isSynced = true; 
                    document.getElementById("sync-status-message").textContent = '';
                } else {
                    document.getElementById("sync-status-message").textContent = '아직 재생 중이 아닙니다.';
                }
            })
            .catch(err => {
                console.error(err);
                document.getElementById("sync-status-message").textContent = '동기화 상태를 가져오는 중 오류가 발생했습니다.';
            });
        });

        // 7) 채팅 메시지를 화면에 추가하는 헬퍼 함수
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
        
        // [신규] 타임라인 기반 댓글 표시를 시작하는 함수
        function startCommentDisplay() {
            if (commentDisplayInterval) { // 이미 타이머가 실행 중이면 중복 실행 방지
                clearInterval(commentDisplayInterval);
            }
            commentDisplayInterval = setInterval(() => {
                const currentTime = player.getCurrentTime();
                // 아직 표시할 댓글이 남아있고, 다음 댓글의 타임라인이 현재 재생시간보다 작거나 같으면
                while (nextCommentIndex < allComments.length && allComments[nextCommentIndex].timeline <= currentTime) {
                    const comment = allComments[nextCommentIndex];
                    appendChat(comment.nickname, comment.chatting, comment.timeline, comment.createdAt);
                    nextCommentIndex++;
                }
            }, 1000); // 1초마다 체크
        }

        // [신규] 타임라인 기반 댓글 표시를 중지하는 함수
        function stopCommentDisplay() {
            if (commentDisplayInterval) {
                clearInterval(commentDisplayInterval);
                commentDisplayInterval = null;
            }
        }

        // 시간(초)을 mm:ss 형태로 변환
        function formatTime(sec) {
            const m = Math.floor(sec / 60);
            const s = Math.floor(sec % 60);
            return (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);
        }
    </script>
</body>
</html>