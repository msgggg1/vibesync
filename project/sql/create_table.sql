--------------------------------------------------------------------------------
-- 테이블 삭제 (제약조건 순서에 유의)
--------------------------------------------------------------------------------
DROP TABLE commentlist;
DROP TABLE noteAccess;
DROP TABLE likes;
DROP TABLE bookmark;
DROP TABLE notification;
DROP TABLE note;
DROP TABLE follows;
DROP TABLE todolist;
DROP TABLE message;
DROP TABLE watchParty;
DROP TABLE genrePerUser;
DROP TABLE setting;
DROP TABLE userPage;
DROP TABLE contents;
DROP TABLE genre;
DROP TABLE category;
DROP TABLE userAccount;

--------------------------------------------------------------------------------
-- 1. userAccount (계정)
--------------------------------------------------------------------------------
CREATE TABLE userAccount (
    ac_idx INT PRIMARY KEY,
    email VARCHAR2(255) NOT NULL UNIQUE,
    pw VARCHAR2(255) NOT NULL,
    nickname VARCHAR2(50) NOT NULL UNIQUE,
    img VARCHAR2(255),
    name VARCHAR2(100) NOT NULL,
    created_at TIMESTAMP
);

--------------------------------------------------------------------------------
-- 2. category (카테고리)
--------------------------------------------------------------------------------
CREATE TABLE category (
    category_idx INT PRIMARY KEY,
    c_name VARCHAR2(100) NOT NULL
);

--------------------------------------------------------------------------------
-- 3. genre (장르)
--------------------------------------------------------------------------------
CREATE TABLE genre (
    genre_idx INT PRIMARY KEY,
    gen_name VARCHAR2(100) NOT NULL
);

--------------------------------------------------------------------------------
-- 4. contents (콘텐츠)
--------------------------------------------------------------------------------
CREATE TABLE contents (
    content_idx INT PRIMARY KEY,
    title VARCHAR2(255),
    img VARCHAR2(255),
    dsc CLOB,
    category_idx INT NOT NULL,
    CONSTRAINT FK_contents_TO_category FOREIGN KEY (category_idx) REFERENCES category(category_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 5. userPage (페이지)
--------------------------------------------------------------------------------
CREATE TABLE userPage (
    userPg_idx INT PRIMARY KEY,
    subject VARCHAR2(100),
    thumbnail VARCHAR2(255),
    created_at TIMESTAMP DEFAULT SYSDATE,
    ac_idx INT NOT NULL,
    re_userPg_idx INT,
    CONSTRAINT FK_userPage_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE,
    CONSTRAINT FK_userPage_TO_userPage FOREIGN KEY (re_userPg_idx) REFERENCES userPage(userPg_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 6. setting (설정)
--------------------------------------------------------------------------------
CREATE TABLE setting (
    setting_idx INT PRIMARY KEY,
    font VARCHAR2(100) NOT NULL,
    theme VARCHAR2(50) NOT NULL,
    noti VARCHAR2(50) NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_setting_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 7. genrePerUser (유저별 장르 목록)
--------------------------------------------------------------------------------
CREATE TABLE genrePerUser (
    ac_gen_idx INT PRIMARY KEY,
    ac_idx INT NOT NULL,
    genre_idx INT NOT NULL,
    CONSTRAINT FK_genrePerUser_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE,
    CONSTRAINT FK_genrePerUser_TO_genre FOREIGN KEY (genre_idx) REFERENCES genre(genre_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 8. watchParty (워치파티)
--------------------------------------------------------------------------------
CREATE TABLE watchParty (
    watchParty_idx INT PRIMARY KEY,
    video_id VARCHAR2(255) NOT NULL,
    created_at TIMESTAMP DEFAULT SYSDATE,
    host INT NOT NULL,
    CONSTRAINT FK_watchParty_TO_userAccount FOREIGN KEY (host) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 9. message (메시지)
--------------------------------------------------------------------------------
CREATE TABLE message (
    msg_idx INT PRIMARY KEY,
    text CLOB,
    time TIMESTAMP NOT NULL,
    img VARCHAR2(255),
    chk NUMBER(1) NOT NULL,
    ac_receiver INT NOT NULL,
    ac_sender INT NOT NULL,
    CONSTRAINT FK_message_TO_userAccount_rcvr FOREIGN KEY (ac_receiver) REFERENCES userAccount(ac_idx) ON DELETE CASCADE,
    CONSTRAINT FK_message_TO_userAccount_sndr FOREIGN KEY (ac_sender) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 10. todolist (투두리스트)
--------------------------------------------------------------------------------
CREATE TABLE todolist (
    todo_idx INT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    text CLOB,
    todo_group VARCHAR2(100) NOT NULL,
    color VARCHAR2(100) NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_todolist_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 11. follows (팔로우목록)
--------------------------------------------------------------------------------
CREATE TABLE follows (
    follows_idx INT PRIMARY KEY,
    ac_follow INT NOT NULL,
    ac_following INT NOT NULL,
    CONSTRAINT FK_follows_TO_userAccountFw FOREIGN KEY (ac_follow) REFERENCES userAccount(ac_idx) ON DELETE CASCADE,
    CONSTRAINT FK_follows_TO_userAccountFwing FOREIGN KEY (ac_following) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 12. note (글)
--------------------------------------------------------------------------------
CREATE TABLE note (
    note_idx INT PRIMARY KEY,
    title varchar2(2000),
    text CLOB,
    img CLOB,
    create_at TIMESTAMP,
    edit_at TIMESTAMP,
    view_count INT DEFAULT 0,
    content_idx INT NOT NULL,
    genre_idx INT NOT NULL,
    CONSTRAINT FK_note_TO_contents FOREIGN KEY (content_idx) REFERENCES contents(content_idx) ON DELETE CASCADE,
    CONSTRAINT FK_note_TO_genre FOREIGN KEY (genre_idx) REFERENCES genre(genre_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 13. notification (알람)
--------------------------------------------------------------------------------
CREATE TABLE notification (
    notifi_idx INT PRIMARY KEY,
    time TIMESTAMP NOT NULL,
    text CLOB,
    chk NUMBER(1) NOT NULL,
    ac_idx INT NOT NULL,
    setting_idx INT,
    CONSTRAINT FK_notification_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE,
    CONSTRAINT FK_notification_TO_setting FOREIGN KEY (setting_idx) REFERENCES setting(setting_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 14. bookmark (북마크)
--------------------------------------------------------------------------------
CREATE TABLE bookmark (
    bkmark_idx INT PRIMARY KEY,
    userPg_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    created_at TIMESTAMP,
    CONSTRAINT FK_bookmark_TO_userPage FOREIGN KEY (userPg_idx) REFERENCES userPage(userPg_idx) ON DELETE CASCADE,
    CONSTRAINT FK_bookmark_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 15. likes (좋아요)
--------------------------------------------------------------------------------
CREATE TABLE likes (
    likes_idx INT PRIMARY KEY,
    created_at TIMESTAMP,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_likes_TO_note FOREIGN KEY (note_idx) REFERENCES note(note_idx) ON DELETE CASCADE,
    CONSTRAINT FK_likes_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 16. noteAccess (노트 권한 리스트)
--------------------------------------------------------------------------------
CREATE TABLE noteAccess (
    ntGrant_idx INT PRIMARY KEY,
    ntGrant CHAR(3),
    created_at TIMESTAMP,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_noteAccess_TO_note FOREIGN KEY (note_idx) REFERENCES note(note_idx) ON DELETE CASCADE,
    CONSTRAINT FK_noteAccess_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 17. commentlist (댓글)
--------------------------------------------------------------------------------
CREATE TABLE commentlist (
    commentlist_idx INT PRIMARY KEY,
    text CLOB,
    like_count INT,
    create_at TIMESTAMP DEFAULT SYSDATE,
    re_commentlist_idx INT,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_comment_TO_comment FOREIGN KEY (re_commentlist_idx) REFERENCES commentlist(commentlist_idx) ON DELETE CASCADE,
    CONSTRAINT FK_comment_TO_note FOREIGN KEY (note_idx) REFERENCES note(note_idx) ON DELETE CASCADE,
    CONSTRAINT FK_comment_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);


SELECT COUNT(*)
FROM USER_TABLES;
