--system_grantrevoke.sql
--사용자 생성 - 계정명: 'test', 비번: 'abc'
CREATE USER test IDENTIFIED BY abc;
--conn test/abc; --오류발생
--오류 메시지 = ORA-01045: user TEST lacks CREATE SESSION privilege; logon denied

--접속 권한 허용
GRANT CREATE SESSION TO test;
conn test/abc; --SQLPLUS

--현재 test계정에서 테이블 생성하기
CREATE TABLE t1(a number); --ERROR

--시스템계정에서 테이블스페이스 사용권한, 테이블생성권한 허용
--GRANT UNLIMITED TABLESPACE TO test;
--GRANT CREATE TABLE TO test;

--CONNECT, RESOURCE등의 ROLE을 활용
--GRANT connect, resource TO test;

--test계정에서 테이블 생성하기
CREATE TABLE t1(a number); --OK
---------------------------------------------------------
--권한 취소: REVOKE
REVOKE CREATE SESSION FROM test; --접속권한 취소

