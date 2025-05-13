
-- category (카테고리)
CREATE TABLE category (
    category_idx INT PRIMARY KEY NOT NULL,
    c_name VARCHAR2(100)NOT NULL
    );
    
-- genre (장르)
CREATE TABLE genre (
    genre_idx INT PRIMARY KEY NOT NULL,
    gen_name VARCHAR2(100) NOT NULL
    );


-- contents (콘텐츠)
CREATE TABLE contents (
    content_idx INT PRIMARY KEY NOT NULL,
    title VARCHAR2(255),
    img VARCHAR2(255),
    dsc CLOB,
    category_idx INT NOT NULL,
    CONSTRAINT FK_category_TO_contents FOREIGN KEY (category_idx)REFERENCES category(category_idx)
    );

-- likes (좋아요)
CREATE TABLE likes (
    likes_idx INT PRIMARY KEY NOT NULL,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_note_TO_likes FOREIGN KEY (note_idx)REFERENCES note(note_idx),
    CONSTRAINT FK_userAccount_TO_likes FOREIGN KEY (ac_idx)REFERENCES userAccount(ac_idx)
    );


-- comment (댓글)
CREATE TABLE comment (
    coment_idx INT PRIMARY KEY NOT NULL,
    text CLOB NOT NULL,
    like_count INT,
    create_at DATE DEFAULT SYSDATE,
    re_coment_idx INT,
    note_idx INT,
    ac_idx INT,
    CONSTRAINT FK_comment_TO_comment FOREIGN KEY (re_coment_idx)REFERENCES comment(coment_idx),
    CONSTRAINT FK_note_TO_comment FOREIGN KEY (note_idx)REFERENCES note(note_idx),
    CONSTRAINT FK_userAccount_TO_comment FOREIGN KEY (ac_idx)REFERENCES userAccount(ac_idx)
    );

-- pageAccessible(페이지 권한 리스트)
CREATE TABLE pageAccessible (
    pgGrant_idx INT PRIMARY KEY,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_note_TO_pageAccessible FOREIGN KEY (note_idx)REFERENCES note(note_idx),
    CONSTRAINT FK_userAccount_TO_pageAccessible FOREIGN KEY (ac_idx)REFERENCES userAccount(ac_idx)
    );   

-- userPage (페이지)
CREATE TABLE userPage (
    userPg_idx INT PRIMARY KEY NOT NULL,
    subject VARCHAR2(100),
    thumbnail VARCHAR2(255),
    create_at DATE DEFAULT SYSDATE,
    ac_idx INT NOT NULL,
    re_userPg_idx INT NOT NULL,
    CONSTRAINT FK_userPage_TO_userPage FOREIGN KEY (re_userPg_idx)REFERENCES userPage(userPg_idx),
    CONSTRAINT FK_userAccount_TO_userPage FOREIGN KEY (ac_idx)REFERENCES userAccount(ac_idx)
    );    

-- bookmark (북마크)
CREATE TABLE bookmark (
    bkmark_idx INT NOT NULL,
    userPg_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_userPage_TO_bookmark FOREIGN KEY (userPg_idx)REFERENCES userPage(userPg_idx),
    CONSTRAINT FK_userAccount_TO_bookmark FOREIGN KEY (ac_idx)REFERENCES userAccount(ac_idx)
    ); 

-- note (글)
CREATE TABLE note (
    note_idx INT PRIMARY KEY NOT NULL,
    text CLOB,
    img VARCHAR2(255),
    userPg_idx INT NOT NULL,
    contents_idx INT NOT NULL,
    genre_idx INT NOT NULL,
    category_idx INT NOT NULL,
    CONSTRAINT FK_userPage_TO_note FOREIGN KEY (userPg_idx)REFERENCES userPage(userPg_idx),
    CONSTRAINT FK_content_TO_note FOREIGN KEY (contents_idx)REFERENCES contents(contents_idx),
    CONSTRAINT FK_genre_TO_note FOREIGN KEY (genre_idx)REFERENCES genre(genre_idx),
    CONSTRAINT FK_category_TO_note FOREIGN KEY (category_idx)REFERENCES category(category_idx)
    );



