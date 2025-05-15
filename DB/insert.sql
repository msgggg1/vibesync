--  INSERT 문 (더미데이터)

SELECT * FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER = 'NLS_CHARACTERSET'; -- UTF-8 인지 확인

SELECT text FROM note; -- 한글과 이모지가 올바르게 표시되는지 조회:
SELECT text FROM message;
---------------------------------------------------------------------------------
-- userAccount (계정)
INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES
(1, 'user1@example.com', 'pw123!김', '음악팬1', 'user1.jpg', '김민수', TO_DATE('2025-05-01', 'YYYY-MM-DD')),
(2, 'user2@example.com', 'pw456#이', '락스타', 'user2.jpg', '이영희', TO_DATE('2025-05-02', 'YYYY-MM-DD')),
(3, 'user3@example.com', 'pw789$박', '팝러버', 'user3.jpg', '박지훈', TO_DATE('2025-05-03', 'YYYY-MM-DD'));

-- category (카테고리)
INSERT INTO category (category_idx, c_name) VALUES
(1, '음악'),
(2, '팟캐스트'),
(3, '플레이리스트');

-- genre (장르)
INSERT INTO genre (genre_idx, gen_name) VALUES
(1, '팝'),
(2, '락'),
(3, '재즈'),
(4, '힙합');

-- contents (콘텐츠)
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES
(1, '2025 팝 히트곡', 'pop_hit.jpg', '최신 팝 음악 컬렉션입니다. 🎵', 1),
(2, '락 클래식', 'rock_classics.jpg', '영원한 락 명곡 모음. 🤘', 1),
(3, '재즈 바이브', 'jazz_vibes.jpg', '편안한 재즈 음악. ☕', 1);

-- userPage (페이지)
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES
(1, '나의 음악 여정', 'thumbnail1.jpg', SYSDATE, 1, NULL),
(2, '락 플레이리스트', 'thumbnail2.jpg', SYSDATE, 2, 1), -- 참조 User1의 페이지
(3, '팝 즐겨찾기', 'thumbnail3.jpg', SYSDATE, 3, NULL);

-- setting (설정)
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES
(1, 'Arial', 'Dark', 'On', 1),
(2, 'Times New Roman', 'Light', 'Off', 2),
(3, 'Verdana', 'Dark', 'On', 3);

-- note (글)
INSERT INTO note (note_idx, text, img, userPg_idx, content_idx, genre_idx, category_idx) VALUES
(1, '새로운 팝 히트곡 너무 좋아요! 🎤', 'note1.jpg', 1, 1, 1, 1),
(2, '락 클래식은 언제 들어도 최고! 🤟', 'note2.jpg', 2, 2, 2, 1),
(3, '재즈로 저녁을 보내는 중... ☕', 'note3.jpg', 3, 3, 3, 1);

-- genrePerUser (유저별 장르 목록)
INSERT INTO genrePerUser (ac_gen_idx, ac_idx, gen_fk) VALUES
(1, 1, 1), -- 김민수: 팝
(2, 2, 2), -- 이영희: 락
(3, 3, 3); -- 박지훈: 재즈

-- watchParty (워치파티)
INSERT INTO watchParty (watchParty_idx, video_id, created_at, host) VALUES
(1, 'video_pop123', SYSDATE, 1),
(2, 'video_rock456', SYSDATE, 2);

-- message (메시지)
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES
(1, '이 노래 들어봤어? 정말 좋아! 🎶', SYSTIMESTAMP, NULL, 0, 2, 1),
(2, '너 플레이리스트 짱이야! 😎', SYSTIMESTAMP, NULL, 1, 3, 2),
(3, '재즈 추천 좀 해줘~ 🙏', SYSTIMESTAMP, NULL, 0, 1, 3);

-- todolist (투두리스트)
INSERT INTO todolist (todo_idx, datetime, text, todo_group, color, ac_idx) VALUES
(1, SYSTIMESTAMP, '새 팝 앨범 듣기', '음악', '파랑', 1),
(2, SYSTIMESTAMP, '락 플레이리스트 만들기', '음악', '빨강', 2),
(3, SYSTIMESTAMP, '재즈 아티스트 탐색', '음악', '초록', 3);

-- notification (알람)
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES
(1, SYSTIMESTAMP, '노트에 새 댓글! 확인해보세요 📬', 0, 1, 1),
(2, SYSTIMESTAMP, '락스타님이 팔로우했어요 😊', 1, 3, 3),
(3, SYSTIMESTAMP, '워치파티 시작! 참여하세요 🎉', 0, 2, 2);

-- follows (팔로우목록)
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES
(1, 1, 2), -- 김민수 follows 이영희
(2, 2, 3), -- 이영희 follows 박지훈
(3, 3, 1); -- 박지훈 follows 김민수

-- likes (좋아요)
INSERT INTO likes (likes_idx, note_idx, ac_idx) VALUES
(1, 1, 2), -- 이영희 likes 김민수의 노트
(2, 2, 3), -- 박지훈 likes 이영희의 노트
(3, 3, 1); -- 김민수 likes 박지훈의 노트

-- noteAccess(페이지 권한 리스트) 
INSERT INTO noteAccess (pgGrant_idx, note_idx, ac_idx) VALUES
(1, 1, 2), -- 이영희 can access 김민수의 노트
(2, 2, 3); -- 박지훈 can access 이영희의 노트

-- comment (댓글)
INSERT INTO coment (coment_idx, text, like_count, create_at, re_coment_idx, note_idx, ac_idx) VALUES
(1, '정말 좋은 취향이네요! 😍', 2, SYSDATE, NULL, 1, 2),
(2, '완전 공감해요! 🤘', 1, SYSDATE, NULL, 2, 3),
(3, '추천 감사합니다! 🙌', 0, SYSDATE, 1, 3); -- 답글 to comment 1

-- bookmark (북마크)
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx) VALUES
(1, 1, 2), -- 이영희 bookmarks 김민수의 페이지
(2, 2, 3), -- 박지훈 bookmarks 이영희의 페이지
(3, 3, 1); -- 김민수 bookmarks 박지훈의 페이지


-- 중복 삽입 방지
SELECT * FROM userAccount WHERE ac_idx IN (1, 2, 3);

-- FK 무결성 테스트:
SELECT n.note_idx, n.text, u.nickname
FROM note n
JOIN userPage up ON n.userPg_idx = up.userPg_idx
JOIN userAccount u ON up.ac_idx = u.ac_idx;