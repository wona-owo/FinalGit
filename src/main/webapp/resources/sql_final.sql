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

alter table tbl_user modify user_image varchar2(200);
commit; 

-- 관리자 계정
insert into tbl_user (user_no, user_id, user_pw, user_nickname, user_name, user_address, user_email, user_phone, acct_level) 
              values (seq_user.nextval, 'admin', '1234','관리자','관리자', '서울시 강남구', 'admin@naver.com', '010-0000-0000', 1);
            
-- 일반 회원 계정 
insert into tbl_user (user_no, user_id, user_pw, user_nickname, user_name, user_address, user_email, user_phone) 
              values (seq_user.nextval, 'user1', '1234','유저1','유저1', '서울시 노원구', 'user1@naver.com', '010-1111-1111');
insert into tbl_user (user_no, user_id, user_pw, user_nickname, user_name, user_address, user_email, user_phone) 
              values (seq_user.nextval, 'user2', '1234','유저2','유저2', '서울시 용산구', 'user2@naver.com', '010-2222-2222');
insert into tbl_user (user_no, user_id, user_pw, user_nickname, user_name, user_address, user_email, user_phone) 
              values (seq_user.nextval, 'user3', '1234','유저3','유저3', '서울시 송파구', 'user3@naver.com', '010-3333-3333');

commit;

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
CREATE TABLE search (
    user_no number references tbl_user(user_no) on delete cascade,
    keyword varchar2(100) not null,
    keyword_date date default sysdate not null,
    search_type char(1)DEFAULT 'G' not null check(search_type in ('G','U','H')), -- G는 검색 U는 userId값 H는 HashTagName값
    search_user_id VARCHAR2(30), -- user 검색시 userId로 
    unique (user_no, keyword) -- user_no가 중복된 키워드 입력할때 새롭게 insert되는거 방지
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
    hash_name varchar2(100) not null unique
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

-- 댓글 테이블 데이터 추가
-- 댓글 추가
insert into tbl_comment (comment_no, user_no, post_no, parent_no, comment_content, comment_date)
values (seq_comment.nextval, 2, 17, null, '첫 번째 부모 댓글입니다.', sysdate);

insert into tbl_comment (comment_no, user_no, post_no, parent_no, comment_content, comment_date)
values (seq_comment.nextval, 3, 17, null, '두 번째 부모 댓글입니다.', sysdate);

-- 답글 추가 (parent_no에 부모 댓글의 comment_no 지정)
insert into tbl_comment (comment_no, user_no, post_no, parent_no, comment_content, comment_date)
values (seq_comment.nextval, 2, 17, 1, '첫 번째 부모 댓글에 대한 답글입니다.', sysdate);

insert into tbl_comment (comment_no, user_no, post_no, parent_no, comment_content, comment_date)
values (seq_comment.nextval, 3, 17, 1, '첫 번째 부모 댓글에 대한 두 번째 답글입니다.', sysdate);

insert into tbl_comment (comment_no, user_no, post_no, parent_no, comment_content, comment_date)
values (seq_comment.nextval, 2, 17, 2, '두 번째 부모 댓글에 대한 답글입니다.', sysdate);

-- 결과 확인
select * from tbl_comment;

commit;

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
    story_file_name varchar2(200) not null
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


CREATE TABLE Breed_cat (
    breed_cat_no NUMBER PRIMARY KEY,
    breed_cat_name VARCHAR2(100) NOT NULL
);

CREATE SEQUENCE seq_breed_cat;
-- DELETE FROM Breed_cat; 
-- 테이블에 있는 값 초기화
-- DROP SEQUENCE seq_breed_cat;ㄴ
-- 시퀀스 삭제

select * from breed_cat;

-- 고양이 품종 인서트
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '아비시니안');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '아메리칸 밥테일');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '아메리칸 컬');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '아메리칸 쇼트헤어');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '아메리칸 와이어헤어');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '오스트레일리안 미스트');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '발리니즈');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '벵갈');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '버먼');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '봄베이');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '브리티시 롱헤어');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '브리티시 쇼트헤어');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '버미즈');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '버밀라');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '샤르트뢰');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '코니시 렉스');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '데본 렉스');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '돈스코이');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '이집션 마우');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '엑조틱 쇼트헤어');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '하바나 브라운');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '히말라얀');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '재패니즈 밥테일');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '카오 마니');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '코랏');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '쿠릴리안 밥테일');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '라팜');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '라이코이');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '메인쿤');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '맨스');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '먼치킨');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '네벨룽');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '노르웨이 숲 고양이');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '오시캣');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '오리엔탈 롱헤어');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '오리엔탈 쇼트헤어');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '페르시안');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '피터볼드');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '픽시밥');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '랙돌');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '러시안 블루');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '사바나');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '스코티시 폴드');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '스코티시 스트레이트');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '셀커크 렉스');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '샴');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '시베리안');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '싱가푸라');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '스노우슈');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '소말리');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '스핑크스');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '태국 고양이');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '통키니즈');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '토이거');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '터키시 앙고라');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '터키시 반');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '아메리칸 링테일');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '아나톨리');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '키프로스');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '아라비안 마우');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '아시안');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '티파니');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '오스트레일리안 티파니');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '바레인 딜문');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '밤비노');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '브램블');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '브라질리안 쇼트헤어');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '캘리포니아 스팽글드');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '세일론');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '샹틸리 티파니');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '치토');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '컬러포인트 쇼트헤어');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '킴릭');
INSERT INTO Breed_cat (breed_cat_no, breed_cat_name) VALUES (seq_breed_cat.NEXTVAL, '코리안 쇼트헤어');

COMMIT;


create sequence seq_breed_dog;
-- 강아지 품종 고유번호 시퀀스

create table breed_dog (breed_dog_no number primary key, breed_dog_name varchar2(100) not null);
-- breed_dog_no 강아지 품종 고유번호
-- breed_dog_name 강아지 품종 이름

INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '치와와');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '말티즈');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '미니어처 핀셔');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '파피용');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '포메라니안');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '시추');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '퍼그');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '이탈리안 그레이하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '요크셔 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '페키니즈');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '토이 푸들');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '러시안 토이');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '실키 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '토이 폭스 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '토이 맨체스터 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '제페니스 친');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '하바니즈');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '잉글리시 토이 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '차이니스 크레스티드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '카발리에 킹 찰스 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '브뤼셀 그리펀');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '뷰어 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아펜핀셔');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '오스트레일리언 캐틀 독');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '오스트레일리언 셰퍼드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '비어디드 콜리');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '보스롱');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '벨지안 라케노이즈');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '벨지안 말리노이즈');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '벨지안 쉽독');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '벨지안 테뷰런');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '베르가마스코');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '베르지 피카드르');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '보더 콜리');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '부비에 데 플랑드르');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '브리아드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '케이넌 독');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '카디건 웰시 코기');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '콜리');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '엔틀버쳐 마운틴 도그');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '피니시 라프훈트');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '저먼 셰퍼드 독');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아이슬랜드 쉽독');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '랭카셔 힐러');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '미니어처 아메이칸 셰퍼드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '무디');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '노르웨이안 부훈트');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '올드 잉글리시 쉽독');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '팸브로크 웰시 코기');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '폴리시 로랜드 쉽독');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '풀리');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '푸미');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '피레니언 셰퍼드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '셔틀랜드 쉽독');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '스패니시 워터 독');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '스위디시 발훈트');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아프간 하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아메리칸 잉글리시 쿤하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아메리칸 폭스하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아자와크');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '바센지');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '바셋 하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '비글');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '블랙 앤 탄 쿤하운');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '블러드 하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '블루틱 쿤하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '보르조이');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '시르네코 델레트나');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '닥스훈트');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '잉글리시 폭스하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '그랜드 바셋 그리폰 반덴');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '그레이 하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '해리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '이비전 하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아이리시 울프하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '노르웨이언 엘크하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '오터 하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '프티 바세 그리폰 방댕');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '파라오 하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '플롯 하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '포르투기스 포덴고 페케노');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '레드본 쿤하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '로디지안 리지백');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '살루키');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '스코티시 디어하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '슬루기');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '트리잉 워커 쿤하운드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '휘핏');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아메리칸 워터 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '바베트');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '보이킨 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '브라코 이탈리아노');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '브리타니');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '체서피크 베이 리트리버');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '클럼버 스파니엘');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '코커 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '컬리 코티드 리트리버');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '잉글리시 코커 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '일글리시 세터');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '잉글리시 스프링어 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '필드 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '플랫 코티드 리트리버');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '저먼 쇼트헤어드 포인터');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '저먼 와이어헤어드 포인터');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '골든 리트리버');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '고든 서터');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아이리시 레드 앤드 화이트 세터');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아이리시 세터');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아이리시 워터 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '래브라도 리트리버');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '라고토 로마그놀로');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '네더르란스 쿠이커혼제');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '노바 스코셔 덕 톨링 레트리버');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '포인터');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '스피노네 이탈리아노');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '서식스 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '비즐라');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '와이마리너');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '웰시 스프링어 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '와이어헤어드 포인팅 그리폰');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '와이어헤어드 비즐라');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아메리칸 에스키모 도그');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '비숑 프리제');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '보스턴 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '불도그');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '차이니스 샤페이');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '차우 차우');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '코통 드 튈레아르');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '달마시안');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '피니시 스피츠');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '프렌치 불도그');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '케이스혼트');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '라사압소');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '로첸');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '노르웨지안 룬데훈트');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '푸들');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '스키퍼키');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '시바 이누');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '티벳탄 스패니얼');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '티벳탄 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '숄로이츠퀸틀');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '에어데일 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아메리칸 헤어리스 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아메리칸 스태퍼드셔 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '오스트레일리안 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '베들링턴 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '보더 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '불 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '케언 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '체스키 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '댄디 딘몬트 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '글랜 오브 이말 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아이리시 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '케리 블루 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '레이크랜드 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '맨체스터 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '미니어처 불 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '미니어처 슈나우저');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '노퍽 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '노리치 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '파슨 러셀 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '랫 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '러셀 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '스코티시 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '실리엄 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '스카이 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '스무스 폭스 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '소프트 코티드 휘튼 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '스타포드셔 불 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '웰시 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '웨스트 하이랜드 화이트 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '와이어 폭스 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아키타');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '알래스칸 맬러뮤트');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '아나톨리아 셰퍼드 도그');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '버니즈 마운틴 도그');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '블랙 러시안 테리어');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '보어보엘');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '복서');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '불마스티프');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '카네 코르소');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '치누크');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '도베르만 핀셔');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '도고 아르넨티노');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '도그 드 보르도');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '저먼 핀셔');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '자이언트 슈나우저');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '그레이트 데인');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '그레이트 피레니즈');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '그레이터 스위스 마운틴 도그');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '코몬도르');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '쿠바츠');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '레온베르거');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '마스티프');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '나폴리탄 마스티프');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '뉴펀들랜드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '포르투기즈 워터 도그');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '로트와일러');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '세인트 버나드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '사모예드');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '시베리안 허스키');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '스탠더드 슈나우저');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '티베탄 마스티프');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '진돗개');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '삽살개');
INSERT INTO breed_dog (breed_dog_no, breed_dog_name) VALUES (seq_breed_dog.NEXTVAL, '풍산개');

COMMIT;
