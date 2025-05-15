-- 1. userAccount (계정)
CREATE TABLE userAccount (
    ac_idx INT PRIMARY KEY,
    email VARCHAR2(255) NOT NULL UNIQUE,
    pw VARCHAR2(255) NOT NULL,
    nickname VARCHAR2(50) NOT NULL UNIQUE,
    img VARCHAR2(255),
    name VARCHAR2(100),
    created_at DATE
);

-- 2. category (카테고리)
CREATE TABLE category (
    category_idx INT PRIMARY KEY,
    c_name VARCHAR2(100) NOT NULL
);
    
-- 3. genre (장르)
CREATE TABLE genre (
    genre_idx INT PRIMARY KEY,
    gen_name VARCHAR2(100) NOT NULL
);

-- 4. contents (콘텐츠)
CREATE TABLE contents (
    content_idx INT PRIMARY KEY,
    title VARCHAR2(255),
    img VARCHAR2(255),
    dsc CLOB,
    category_idx INT NOT NULL,
    CONSTRAINT FK_contents_TO_category FOREIGN KEY (category_idx) REFERENCES category(category_idx) 
);

-- 5. userPage (페이지)
CREATE TABLE userPage (
    userPg_idx INT PRIMARY KEY,
    subject VARCHAR2(100),
    thumbnail VARCHAR2(255),
    created_at TIMESTAMP DEFAULT SYSDATE,
    ac_idx INT NOT NULL,
    re_userPg_idx INT, 
    CONSTRAINT FK_userPage_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx), 
    CONSTRAINT FK_userPage_TO_userPage FOREIGN KEY (re_userPg_idx) REFERENCES userPage(userPg_idx) 
);

-- 6. setting (설정)
CREATE TABLE setting (
    setting_idx INT PRIMARY KEY,
    font VARCHAR2(100) NOT NULL,
    theme VARCHAR2(50) NOT NULL,
    noti VARCHAR2(50) NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_setting_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount (ac_idx) 
);

-- 7. genrePerUser (유저별 장르 목록)
CREATE TABLE genrePerUser (
    ac_gen_idx INT PRIMARY KEY,
    ac_idx INT NOT NULL,
    gen_fk INT NOT NULL,
    CONSTRAINT FK_genrePerUser_TO_genre FOREIGN KEY (gen_fk) REFERENCES genre(genre_idx), 
    CONSTRAINT FK_genrePerUser_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount (ac_idx) 
);

-- 8. watchParty (워치파티)
CREATE TABLE watchParty (
    watchParty_idx INT PRIMARY KEY,
    video_id VARCHAR2(255) NOT NULL,
    created_at TIMESTAMP DEFAULT SYSDATE,
    host INT NOT NULL, 
    CONSTRAINT FK_watchParty_TO_userAccount FOREIGN KEY (host) REFERENCES userAccount (ac_idx) 
);

-- 9. message (메시지)
CREATE TABLE message (
    msg_idx INT PRIMARY KEY,
    text CLOB NOT NULL,
    time TIMESTAMP NOT NULL, 
    img VARCHAR2(255),
    chk NUMBER(1) NOT NULL,
    ac_receiver INT NOT NULL,
    ac_sender INT NOT NULL,
    CONSTRAINT FK_message_TO_userAccount_rcvr FOREIGN KEY (ac_receiver) REFERENCES userAccount (ac_idx), 
    CONSTRAINT FK_message_TO_userAccount_sndr FOREIGN KEY (ac_sender) REFERENCES userAccount (ac_idx) 
);

-- 10. todolist (투두리스트)
CREATE TABLE todolist (
    todo_idx INT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL, 
    text CLOB NOT NULL,
    todo_group VARCHAR2(100) NOT NULL,
    color VARCHAR2(100) NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_todolist_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount (ac_idx) 
);

-- 11. follows (팔로우목록)
CREATE TABLE follows (
    follows_idx INT PRIMARY KEY,
    ac_follow INT NOT NULL,
    ac_following INT NOT NULL,
    CONSTRAINT FK_follows_TO_userAccountFw FOREIGN KEY (ac_follow) REFERENCES userAccount (ac_idx), 
    CONSTRAINT FK_follows_TO_userAccountFwing FOREIGN KEY (ac_following) REFERENCES userAccount (ac_idx) 
);

-- 12. note (글)
CREATE TABLE note (
    note_idx INT PRIMARY KEY,
    text CLOB,
    img CLOB,
    create_at TIMESTAMP,
    edit_at TIMESTAMP,
    content_idx INT NOT NULL,
    genre_idx INT NOT NULL,
    CONSTRAINT FK_note_TO_contents FOREIGN KEY (content_idx) REFERENCES contents(content_idx), 
    CONSTRAINT FK_note_TO_genre FOREIGN KEY (genre_idx) REFERENCES genre(genre_idx)
);

-- 13. notification (알람)
CREATE TABLE notification (
    notifi_idx INT PRIMARY KEY,
    time TIMESTAMP NOT NULL,
    text CLOB NOT NULL,
    chk NUMBER(1) NOT NULL,
    ac_idx INT NOT NULL,
    setting_idx INT,
    CONSTRAINT FK_notification_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount (ac_idx), 
    CONSTRAINT FK_notification_TO_setting FOREIGN KEY (setting_idx) REFERENCES setting (setting_idx) 
);

-- 14. bookmark (북마크)
CREATE TABLE bookmark (
    bkmark_idx INT PRIMARY KEY,
    userPg_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    created_at TIMESTAMP,
    CONSTRAINT FK_bookmark_TO_userPage FOREIGN KEY (userPg_idx) REFERENCES userPage(userPg_idx), 
    CONSTRAINT FK_bookmark_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) 
);

-- 15. likes (좋아요)
CREATE TABLE likes (
    likes_idx INT PRIMARY KEY,
    created_at TIMESTAMP,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_likes_TO_note FOREIGN KEY (note_idx) REFERENCES note(note_idx), 
    CONSTRAINT FK_likes_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) 
);

-- 16. noteAccess(페이지(노트) 권한 리스트) 
CREATE TABLE noteAccess (
    ntGrant_idx INT PRIMARY KEY,
    ntGrant CHAR(3),
    created_at TIMESTAMP,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_noteAccess_TO_note FOREIGN KEY (note_idx) REFERENCES note(note_idx), 
    CONSTRAINT FK_noteAccess_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) 
);

-- 17. coment (댓글)
CREATE TABLE coment (
    coment_idx INT PRIMARY KEY,
    text CLOB NOT NULL,
    like_count INT,
    create_at TIMESTAMP DEFAULT SYSDATE,
    re_coment_idx INT,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_coment_TO_coment FOREIGN KEY (re_coment_idx) REFERENCES coment(coment_idx), 
    CONSTRAINT FK_coment_TO_note FOREIGN KEY (note_idx) REFERENCES note(note_idx), 
    CONSTRAINT FK_coment_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) 
);

--------------------------------------------------------------------------------
-- 테이블 삭제
-- 17. coment (댓글)
DROP TABLE coment;

-- 16. noteAccess(페이지(노트) 권한 리스트) 
DROP TABLE noteAccess;

-- 15. likes (좋아요)
DROP TABLE likes;

-- 14. bookmark (북마크)
DROP TABLE bookmark;

-- 13. notification (알람)
DROP TABLE notification;

-- 12. note (글)
DROP TABLE note;

-- 11. follows (팔로우목록)
DROP TABLE follows;

-- 10. todolist (투두리스트)
DROP TABLE todolist;

-- 9. message (메시지)
DROP TABLE message;

-- 8. watchParty (워치파티)
DROP TABLE watchParty;

-- 7. genrePerUser (유저별 장르 목록)
DROP TABLE genrePerUser;

-- 6. setting (설정)
DROP TABLE setting;

-- 5. userPage (페이지)
DROP TABLE userPage;

-- 4. contents (콘텐츠)
DROP TABLE contents;

-- 3. genre (장르)
DROP TABLE genre;

-- 2. category (카테고리)
DROP TABLE category;

-- 1. userAccount (계정)
DROP TABLE userAccount;