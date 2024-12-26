-- 시퀀스
create sequence seq_user; -- 유저 고유번호
create sequence seq_mypet; -- 반려동물 고유번호
create sequence seq_report; -- 신고 고유번호
create sequence seq_banlist; -- 밴목록 고유번호

create sequence seq_post; -- 게시물 고유번호
create sequence seq_post_file; -- 게시물 파일 고유번호
create sequence seq_hashtag; -- 해시태그 고유번호
create sequence seq_comment; -- 댓글 고유번호
create sequence seq_story; -- 스토리 고유번호
create sequence seq_story_file; -- 스토리 파일 고유번호

-------------------------------------------------------------------------------
-- 유저 테이블
create table tbl_user(
       user_no number primary key,
       user_id varchar2(30) not null unique,
       user_pw varchar2(100) not null,
       user_nickname varchar2(30) not null unique,
       user_name varchar2(30) not null,
       user_address varchar2(200) not null,
       user_email varchar2(30) not null,
       user_phone char(13) not null unique,
       user_type char(1) default 'G' not null check(user_type in('G','K','N')),
       enroll_date date default sysdate not null,
       acct_level number default 0 not null check(acct_level in(0, 1)),
       ban_yn char(1) default 'N' check(ban_yn in('Y','N')),
       user_image varchar2(50)
);

-- 반려동물 테이블
create table mypet(
    pet_no number primary key,
    user_no number references tbl_user(user_no) on delete cascade,
    pet_name varchar2(20) not null,
    pet_gender char(1) not null check(pet_gender in ('M', 'F')),
    pet_type char(3) not null check(pet_type in ('CAT','DOG')),
    breed_type varchar2(100) not null
);

-- 검색 테이블
create table search(
    user_no number references tbl_user(user_no) on delete cascade,
    keyword varchar2(100) not null
);

-- 밴목록 테이블
create table banlist(
    ban_no number primary key,
    user_no number references tbl_user(user_no) on delete cascade,
    ban_reason varchar2(100) not null,
    ban_start_date date default sysdate not null,
    ban_end_date date
);

-- 신고 테이블
create table report(
    report_no number primary key,
    user_no number not null references tbl_user(user_no),
    target_no number not null,
    target_type char(1) check(target_type in ('P', 'C')),
    report_reason varchar2(100),
    report_date date default sysdate not null,
    report_yn  char(1) default 'N' not null
);

-- 팔로우 테이블
create table follow(
    following_no number references tbl_user(user_no) on delete cascade,
    follower_no number references tbl_user(user_no) on delete cascade,
    primary key(following_no, follower_no)
);

-------------------------------------------------------------------------------
-- 게시물 테이블
create table post(
    post_no number primary key,
    user_no number not null references tbl_user(user_no),
    post_content varchar2(1000),
    post_date date default sysdate not null
);

-- 게시물 파일 테이블
create table post_file(
    post_file_no number primary key,
    post_no number references post(post_no) on delete cascade,
    post_file_name varchar2(100) not null
);

-- 해시태그 테이블
create table hashtag(
    hash_no number primary key,
    post_no number not null references post(post_no) on delete cascade,
    hash_name varchar2(100) not null
);

-- 댓글 테이블
create table tbl_comment( --comment는 oracle 예약어
    comment_no number primary key,
    user_no number not null references tbl_user(user_no) on delete cascade,
    post_no number not null references post(post_no) on delete cascade,
    parent_no number,
    comment_content varchar2(300) not null,
    comment_date date default sysdate not null
);

-- 자가참조 조건 오류 방지 위해 이후 추가
alter table tbl_comment add constraint comment_parent foreign key (parent_no) references tbl_comment(comment_no) on delete cascade;

-- 스토리 테이블
create table story(
    story_no number primary key,
    user_no number not null references tbl_user(user_no) on delete cascade,
    create_date date default sysdate not null,
    end_date date default sysdate+1 not null
);

-- 스토리 파일 테이블
create table story_file(
    story_file_no number primary key,
    story_no number not null references story(story_no) on delete cascade,
    story_file_name varchar2(100) not null
);

-- 좋아요 테이블
create table tbl_like( -- like는 oracle 예약어
    target_no number,
    user_no number references tbl_user(user_no) on delete cascade,
    target_type char(1) not null check(target_type in('P', 'C')),
    primary key(target_no, user_no)
);

-- 북마크 테이블
create table bookmark(
    user_no number references tbl_user(user_no) on delete cascade,
    post_no number references post(post_no) on delete cascade,
    bookmark_date date default sysdate not null,
    primary key(user_no, post_no)
);


-- 검색 테이블
create table search(
    user_no number references tbl_user(user_no) on delete cascade,
    keyword varchar2(100) not null unique,
    keyword_date date default sysdate not null
);

CREATE TABLE search (
    user_no number references tbl_user(user_no) on delete cascade,
    keyword varchar2(100) not null,
    keyword_date date default sysdate not null,
    unique (user_no, keyword) -- user_no가 중복된 키워드 입력할때 새롭게 insert되는거 방지
);

CREATE TABLE search (
    user_no number references tbl_user(user_no) on delete cascade,
    keyword varchar2(100) not null,
    keyword_date date default sysdate not null,
    search_type char(1)DEFAULT 'G' not null check(search_type in ('G','U','H')), -- G는 검색 U는 userId값 H는 HashTagName값
    search_user_id VARCHAR2(30), -- user 검색시 userId로 
    unique (user_no, keyword) -- user_no가 중복된 키워드 입력할때 새롭게 insert되는거 방지
);

alter table tbl_user modify user_image varchar2(100);
commit;


