# day07

- scott_transaction.sql

```sql
CREATE TABLE account(
 no CHAR(3),
 balance NUMBER(5) DEFAULT 0 NOT NULL,--잔액을 생략하면 자동 0값으로 설정 되도록 할거다. 설정 안할 시 기본값이 NULL이 되기 때문이다. NULL값을 강제로 넣지 못하도록 NOT NULL
 CONSTRAINT account_no_pk PRIMARY KEY(no)
);

--계좌추가 : 계좌번호101, 잔액 100원
--계좌추가 : 계좌번호202, 잔액 100원
INSERT INTO account (no, balance) VALUES ('101', 100);
INSERT INTO account (no, balance) VALUES ('202', 100);

--계좌이체 : 101번 계좌에서 202번 계좌로 10원 이체
UPDATE account SET balance = balance-10 WHERE no='101'; --90
UPDATE account SET balance = balance+10 WHERE no='202'; --110
commit; --트랜잭션 성공을 알림. DB에 반영
SELECT * FROM account;

--계좌이체 : 101번계좌에서 303번계좌(없는계좌)로 10원 이체
UPDATE account SET balance = balance-10 WHERE no='101'; --80
UPDATE account SET balance = balance+10 WHERE no='303';
rollback; --트랜잭션 실패를 알림. DB에 반영안됨
SELECT * FROM account;
--101 90
--202 110
------------------------------------------------------------------------
INSERT INTO account VALUES('909', 100);

SELECT * FROM account;
commit;

DELETE account WHERE no='909';
rollback;

------------------------------------------------------------------------
DataDicView
SELECT * FROM user_tables; --사용자 테이블 목록
SELECT * FROM user_constraints; --scott계정이 갖고있는 제약조건. p:primary, r:foreign, c:check,not null
------------------------------------------------------------------------
```

트랜잭션은 작업 단위이다. 많이 예를 드는게 계좌이체, 주문 등이 있다.

작업 단위를 주문하기로 생각해 보자면, 

1)주문기본 정보 추가 (order_info)추가

2)주문상세 정보 추가 (order_line)추가

이 두 작업이 성공 되면 완료를 시켜줘야 하고, 문제가 발생하면 원 상태로 복구를 해줘야 한다.

계좌이체

1)A계좌에서 출금

2)B계좌로 입금

이 두 개의 일 처리가 완벽히 성공이 돼야 DB에 반영이 되는 거고 문제가 발생하면 복구를 해야 한다. 

트랜잭션의 원자성을 유지해야 한다.

- DML(INSERT, UPDATE, DELETE) : 트랜잭션 자동 완료 안됨.
- DDL(CREATE, ALTER, DROP, TRUNCATE) : 트랜잭션 자동 완료 →취소 개념 자체가 없다.
- SELECT : 트랜잭션 자동 완료 →취소 개념 자체가 없다.

DELETE와 TRUNCATE의 차이는 무엇일까? 

DELETE 트랜잭션이 완료되지 않기 때문에 롤백,커밋 여지가 있지만, TRUNCATE는 행을 삭제를 하자마자 트랜잭션이 자동 완료되어서 롤백을 할 수 가 없다.

![1](https://user-images.githubusercontent.com/63957819/104811409-ac7caa80-583e-11eb-8aec-f9dbd13c9fef.png)

![2](https://user-images.githubusercontent.com/63957819/104811410-adadd780-583e-11eb-8efe-f72201a6dfcc.png)

![3](https://user-images.githubusercontent.com/63957819/104811411-adadd780-583e-11eb-939c-84b4665063aa.png)

DML구문을 수행하게 되면 트랜잭션 시작되고 자동 완료 안되고 아직 DB에 반영되지 않은 상태로 있는거고 sqlplus 자료를 확인하면 909번이 나타나지 않을 것으로  나타난다.

실제 db에는 반영되지 안았으나 지금 사용되고 있는 섹션에는 그 자료를 충분히 볼 수 있다.

select는 dml과 다른 형태로 새로운 트랜잭션이 만들어졌다가 select구문 수행 후에 트랜잭션이 자동 수행 완료된다. 새로운 트랜잭션이 끝날 때 까지 잠깐 기다리는 거다.  끝나면 기존 첫 번째 트랜잭션이 작업을 하는거다. 

![4](https://user-images.githubusercontent.com/63957819/104811413-ae466e00-583e-11eb-962f-582b98a058db.png)

![5](https://user-images.githubusercontent.com/63957819/104811414-ae466e00-583e-11eb-8a7b-5a84148fb126.png)

커밋을 해주면 sqlplus에서 자료를 확인하면 909번 나타난 것을 볼 수 있다.

![6](https://user-images.githubusercontent.com/63957819/104811415-aedf0480-583e-11eb-824d-084796c180c5.png)

sqldeveloper에서 delete해주고 sqlplus에서도 똑같이 delete해주면 sqlplus에서 데드락 상태가 된다.

sqldeveoper delete한 자료가 db에 반영이 완료가 되어야 다른 트랜잭션이 처리 될 수 있는 것 이다. 

rollback을 해서 취소 완료가 되면 기다리던 트랜잭션이 처리된다.

![7](https://user-images.githubusercontent.com/63957819/104811416-aedf0480-583e-11eb-9589-24258cdf1cdc.png)

sqldeveloper에서 rollback을 했으니 delete를 안 한 것이므로 원 상태로 둔 거다. 909번이 존재하는 상태에서 sqlplus에서 1건이 삭제된 것을 볼 수 있다.

![8](https://user-images.githubusercontent.com/63957819/104811417-af779b00-583e-11eb-9b38-430f78df901e.png)

중간중간 SAVEPOINT를 할 수 있는데 예를들어, 마지막에 ROLLBACK TO SAVEPOINT C 하면 C지점까지만 롤백을 하는 거다. 중간중간 SAVEPOINT지정해서 롤백 할 영역을 설정 해주면 된다.

나머지 위에 남아있는 내용들은 아직 트랜잭션이 완료되지 않은거다

순서대로 C지점 A지점까지 다시 롤백을 하겠다라는 뜻 INSERT, UPDATE아직 트랜잭션이 완료되지 않은 상태로 COMMIT을 해준다.

## 객체 종류

테이블은 SQL문과 더불어 오라클에서 가장 많이 사용하는 객체 중 하나 이다. 테이블 외의 객체들 중에 인덱스, 뷰, 시퀀스 등등 있다.

> **데이터 사전이란?**

테이블에 대한 정보들이 저장되는 곳이 데이터 사전이다.

데이터 사전은 데이터베이스를 구성하고 운영하는데 필요한 모든 정보를 저장하는 특수한 테이블로 데이터베이스가 생성되는 시점에 자동으로 만들어진다.

EX) 고객 자료는 고객 테이블에 저장된다. 고객 테이블에 대한 정보는 데이터 사전에 저장된다.

문제가 발생한다면, 직접 접근은 못하지만 데이터 사전 뷰를 제공하여 SELECT문으로 정보 열람 가능

→ SELECT * FROM DICT;

USER_XXXX : 현재 데이터베이스에 접속한 사용자가 소유한 객체 정보

> **USER_접두어를 가진 데이터 사전**

SELECT TABLE_NAME FROM USER_TABLES;

## **인덱스란?**

데이터 검색 성능의 향상을 위해 테이블 열에 사용하는 객체를 뜻한다.

인덱스 사용 여부에 따라 데이터 검색 방식을 TABLE FULL SCAN, INDEX SCAN으로 구분

-TABLE FULL SCAN : 테이블 데이터를 처음부터 끝까지 검색하여 원하는 데이터를 찾는 방식

-INDEX SCAN : 인덱스를 통해 데이터를 찾는 방식

인덱스 스캔은 데이터 양이 많을 경우에 좋은 거지 항상 좋은 것은 아니다. 

**인덱스 생성 지침**

![9](https://user-images.githubusercontent.com/63957819/104811419-af779b00-583e-11eb-9dc1-29de3b0881f7.png)

**interview question) 언제 인덱스를 만들고 만들지 말아야 되는가??**

![10](https://user-images.githubusercontent.com/63957819/104811420-b0103180-583e-11eb-901b-16f6bb4e81ac.png)

UNIQUE제약 조건을 설정하면 그 컬럼에 인덱스가 만들어 지듯이 PRIMARY제약 조건도 설정하면 자동 인덱스가 만들어진다. 

### **뷰란?**

하나 이상 테이블을 조회하는 SELECT문을 저장한 객체를 뜻한다. SELECT문을 저장하기 때문에 물리적 데이터를 따로 저장하지 않는다. 따라서 뷰를 SELECT문의 FROM절에 사용하면 특정 테이블을 조회하는 것과 같은 효과를 얻을 수 있다.

뷰 이름만 없을 뿐 충분히 SELECT구문을 쓸 수 있다.  뷰 이름이 있으면 FROM절에 쓸 수 있고, 뷰 이름없이 FROM절에 SELECT절을 사용하는 방법이다.

뷰의 사용 목적?  편리성, 보안성

> **뷰 생성**

CREATE [OR REPLACE] [FORCE | NOFORCE} VIEW 뷰 이름 (열 이름1, 열 이름2, ...)

AS (저장할SELECT문)

[WITH CHECK OPTION] [CONSTRAINT 제약조건]]

[WITH READ ONLY [CONSTRAINT 제약조건]];

- scott_view.sql

```sql
--system(관리자계정)에서 scott계정 생성 후 권한설정!
--CREATE USER scott IDENTIFIED BY tiger; --계정생성
--GRANT connect, resource TO scott; --권한설정                  resource는 view를 생성할 수 있는 권한이 없다
--GRANT create view TO scott; --뷰 생성 권한설정(o)

--뷰 생성 : 주문번호, 주문ID, 주문자 이름, 주문일자, -->주문 기본 테이블
--         주문 상품번호, 상품명, 가격, 주문수량 -->주문 상세 테이블
CREATE VIEW vw_order
AS SELECT info.order_no "no", order_id "id", c.name "name", order_dt "dt",
          line.order_prod_no, p.prod_name, p.prod_price, order_quantity
   FROM  order_info info JOIN customer c ON (info.order_id = c.id)
                         JOIN order_line line ON (info.order_no = line.order_no)
                         JOIN product p ON (line.order_prod_no = p.prod_no);

--vw_order뷰 구조변경 --VIEW객체는 ALTER VIEW 안됨, CREATE OR REPLACE사용 -> 기존에 있으면 구조르 바꿔라 의미
CREATE OR REPLACE VIEW vw_order
AS SELECT info.order_no "no", order_id "id", c.name "name", order_dt "dt", -- "별칭" 큰따음표 있이 별칭을 줄때 대소문자를 구분하겠다라는 뜻
          line.order_prod_no, p.prod_name, p.prod_price, order_quantity --oracle에서 HEADING은 모두 대문자로 표현한다.
   FROM  order_info info JOIN customer c ON (info.order_id = c.id)
                         JOIN order_line line ON (info.order_no = line.order_no)
                         JOIN product p ON (line.order_prod_no = p.prod_no);

-----------------------------------------------------------------------------------------
--뷰 사용
SELECT *
FROM vw_order; --0건 HEADING을 보면 별칭명이 나타난다. 별칭명이 보이기 때문에 보안상 컬럼이름을 외부에 노출하지 않는다 -> 편리성, 보안성

SELECT no, order_prod_no
FROM vw_order;
-----------------------------------------------------------------------------------------
--뷰 삭제
DROP VIEW vw_order;
-----------------------------------------------------------------------------------------
--뷰 종류
단순뷰 : 1개 테이블 --CREATE VIEW a AS SELECT FROM emp
 --뷰에 데이터추가, 삭제, 수정가능
복합뷰 : 여러 테이블 --CREATE VIEW b AS SELECT FROM emp JOIN dept
 --뷰에 데이터추가, 삭제, 수정 불가능 INSERT INTO b VALUES (~~); X
-----------------------------------------------------------------------------------------
SELECT *
FROM user_views; --데이터 사전 보기
```

![11](https://user-images.githubusercontent.com/63957819/104811421-b0a8c800-583e-11eb-84ca-c7c26c3115a7.png)

LocalSYSTEM에서 view권한 설정을 해줘야 한다. ⇒ GRANT create view TO scott;

![12](https://user-images.githubusercontent.com/63957819/104811422-b0a8c800-583e-11eb-8b5e-88ec28f28bfb.png)

뷰에 VW_ORDER클릭해서 SQL을 보면 만든 view를 확인해 볼 수 있다.

시퀀스란?

오라클 데이터베이스에서 특정 규칙에 맞는 연속 숫자를 생성하는 객체이다.

단순히 번호 생성을 위한 객체이지만 지속적이고 효율적인 번호 생성이 가능하므로 자주 사용하는 객체이다.

CREATE SEQUENCE 시퀀스 이름

[INCREMENT BY n]

[START WITH n]

[MAXVALUE n | NOMAXVALUE]

[MINVALUE n | NOMINVALUE]

[CYCLE n | NOCYCLE]

[CACHE n | NOCACHE]

시퀀스 사용

CURRVAL은 시퀀스에서 마지막으로 생성한 번호를 반환하며 NEXTVAL는 다음 번호를 생성

CURRVAL 사용 하려면 NEXTVAL을 먼저 해야 한다.

시퀀스 수정

ALTER명령어로 시퀀스를 수정하고 DROP명령어로 시퀀스를 삭제

MAXVALUE보다 현 큰 시퀀스가 있으면 MAXVALUE보다더 작은값으로수정할수없다.

시퀀스 삭제

DROP SEQUENCE를 사용하면 시퀀스를 삭제할 수 있다.

- scott_sequence.sql

```sql
--시퀀스 생성 : 주문 번호용 일련번호 객체
CREATE SEQUENCE order_seq
INCREMENT BY 3 --3씩증가
START WITH 2 --2부터 시작하겠다
MAXVALUE 10
MINVALUE 1
CYCLE
NOCACHE;
---------------------------------------------------
--시퀀스 일련번호 발급
SELECT order_seq.NEXTVAL FROM dual; --2
SELECT order_seq.NEXTVAL FROM dual; --5
SELECT order_seq.NEXTVAL FROM dual; --8
--시퀀스 일련번호 확인(NEXTVAL사용 후 에만 가능)
SELECT order_seq.CURRVAL FROM dual; --8

--최대값까지 도달
SELECT order_seq.NEXTVAL FROM dual; --1
SELECT order_seq.NEXTVAL FROM dual; --4
SELECT order_seq.NEXTVAL FROM dual; --7
SELECT order_seq.NEXTVAL FROM dual; --10
---------------------------------------------------
--시퀀스 구조변경 : maxvalue를 5로 변경
ALTER SEQUENCE order_seq
MAXVALUE 5;--(X)

--시퀀스 삭제
DROP SEQUENCE order_seq;

--시퀀스 생성:
CREATE SEQUENCE order_seq; --시작값이 1, 1씩 증가 최대 맥스값까지 도달..
---------------------------------------------------
--DataDicView[관리자계정:SYS계정]
--USER_TABLES
--USER_CONSTRAINTS
--USER_VIEWS
---------------------------------------------------
```

![13](https://user-images.githubusercontent.com/63957819/104811423-b1415e80-583e-11eb-9383-83ffcf7628b1.png)

CURRVAL 먼저 사용하면 오류가 뜬다.  먼저 NEXTVAL 를 하고 CURRVAL 를 해야 한다.

## 동의어란?

테이블, 뷰, 시퀀스 등 객체 이름 대신 사용할 수 있는 다른 이름을 부여하는 객체이다.

주로 테이블 이름이 너무 길어 사용이 불편할 때 좀 더 간단하고 짧은 이름을 하나 더 만들어 죽 위해 사용

CREAT [PUBLIC] SYNONYM 동의어 이름

FOR [사용자.][객체이름];

동의어 삭제

DROP SYNONYM을 사용하여 동의어를 삭제

GRANT(권한 부여) ↔ REVOKE(권한 취소)

![14](https://user-images.githubusercontent.com/63957819/104811424-b1415e80-583e-11eb-9c1b-e8de88a35eda.png)

다른 유저가 갖고 있는 테이블을 쉽게  참조할 수 있다.

PUBLIC : 모든 유저가 액세스할 수 있는 동의어를 생성

SYNONYM : 생성할 동의어의 이름

object : 동의어를 생성할 객체를 식별

public을 붙이지 않으면 private이 된다. 그 동의어는 동일한 유저가 소유한 모든 다른 객체와 구분되어야 한다. 

![15](https://user-images.githubusercontent.com/63957819/104811425-b1d9f500-583e-11eb-9a5b-4a384d9b2792.png)

동의어를만드는목적? 다른 유저가 소유한 테이블을 쉽게 참조하기위해

CREATE OR REPLACE PUBLIC SYNONYM "USER_CONSTRAINTS" FOR "SYS"."USER_CONSTRAINTS";

sys계정이 갖고 있는 user_constarint 뷰에 대한 공용 동의어를 제공해주고 있다. user_constarints 동으어로만들어져있고  sys계정에서 제공되는 데이터 딕션어리를 public synonym으로 쉽게 접근

## 사용자, 권한, 롤 관리

> **사용자 생성**

CREATE USER문을 사용

> **권한 부여하기**

GRANT ~TO

> **사용자 정보 조회**

SELECT * FROM ~

> **오라클 사용자의 변경과 삭제**

ALTER USER문을 사용

DROP USER문을 사용

> **사용자와 객체 모두 삭제**

DROP USER ~ CASCADE;

> **권한**

객체 권한 부여

GRANT [객체 권한/ALL PRIVILEGES]

ON [스키마, 객체이름]

TO[사용자 이름/롤(Role)이름/PUBLIC]

[WITH GRANT OPTION]

> **롤 관리**

롤이란?

권한들이 너무 많아서 묶음 처리 한 것을 의미한다.

CONNECT 롤

: 사용자가 데이터베이스에 접속하는 데 필요한 CREATE SESSION 권한을 가지고 있다.

RESOURCE 롤

: 사용자가 테이블, 시퀀스를 비롯한 여러 객체를 생성할 수 있는 기본 시스템 권한을 묶어 놓은 롤

DBA 롤

데이터베이스 관리하는 시스템 권한을 대부분 가지고 있다.

sqlplus로 실행

```sql
SQL> CREATE USER test IDENTIFIED BY abc;
SQL> conn test/abc;
SQL> show user;
SQL> CREATE TABLE t1(a number); --test계정에서 테이블 생성하기
```

- system_grantrevoke.sql

```sql
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

--시스템계정에서 테이블스페이스 사용권한, 테이블생성권한 허용ㄱ뭇 ㅊ
--GRANT UNLIMITED TABLESPACE TO test;
--GRANT CREATE TABLE TO test;

--CONNECT, RESOURCE등의 ROLE을 활용
--GRANT connect, resource TO test;

--test계정에서 테이블 생성하기
CREATE TABLE t1(a number); --OK

--권한 취소: REVOKE
REVOKE CREATE SESSION FROM test; --접속권한 취소
```

![16](https://user-images.githubusercontent.com/63957819/104811427-b1d9f500-583e-11eb-841d-fbda69413635.png)

![17](https://user-images.githubusercontent.com/63957819/104811428-b2728b80-583e-11eb-896f-14c85b9367d2.png)

## PL/SQL 구조

SQL만으로는 구현 어려운 것을 oracle에서 제공하는 언어이다.

**블록이란?**

PL/SQL은 데이터베이스 관련 특정 작업을 수행하는 명령어와 실행에 필요한 여러 요소를 정의하는 명령어 등으로 구성, 이러한 명령어를 모아 둔 PL/SQL 프로그램의 기본 단위를 블록이라 한다.

**DECLARE**

[실행에 필요한 여러 요소 선언];

**BEGIN**

[작업을 위해 실제 실행하는 명령어];

**EXCEPTION**

[PL/SQL수행 도중 발생하는 오류 처리];

END;

PL/SQL 실행 결과를 화면에 출력하기 위해서는 SERVEROUTPUT환경 변수 값을 ON으로 변경

→ SET SERVEROUTPUT ON;

1. PL/SQL 블록을 구성하는 DECLARE, BEGIN, EXCEPTION키워드에는 세미콜론을 사용X

 2.  PL/SQL블록의 각 부분에서 실행해야 하는 문장 끝에는 세미콜론(;)을 사용 

 3.  PL/SQL문 내부에서 한 줄 주석(—)과 여러 줄 주석(/*~*/)을 사용 가능. SQL문에서도 사용 가능

 4.  PL/SQL문 작성을 마치고 실행하기 위해 마지막에 슬래시를사용

## 변수와 상수

변수 이름 앞에 자료 이름이 뒤에 선언, := 대입 연산자를 의미.

변수 이름 자료형 := 값 또는 값이 도출되는 여러 표현식;

### **상수 정의하기**

상수를 선언할 때 기존 변수 선언에 CONSTANT키워드를 지정

변수 이름 CONSTANT 자료형 := 값 또는 값을 도출하는 여러 표현식;

### 변수 이름 정하기

1. 같은 블록 안에는 식별자는 고유해야 하며 중복X
2. 대 소문자를 구별하지 X

### 변수의 자료형 스칼라, 복합, 참조, LOB타입으로 구분된다.

**스칼라형**은 숫자, 문자열, 날짜 등을 기본으로정의해놓은 자료형

**참조형**은 특정 테이블 열의 자료형이나 하나의 행 구조를 참조하는 자료형

![18](https://user-images.githubusercontent.com/63957819/104811429-b2728b80-583e-11eb-9e6c-b51c5c5bb005.jpg)

변수 이름 테이블이름.열이름**%TYPE**;  ex) dept **컬럼**의 자료형~

![19](https://user-images.githubusercontent.com/63957819/104811430-b30b2200-583e-11eb-92fa-6cbe14624776.jpg)

변수 이름 테이블 이름**%ROWTYPE**; ex) dept **행** 자료형

- scott_plsql.sql

```sql
SET SERVEROUTPUT ON --실행 결과를 화면에 출력
DECLARE --(선언부) 실행에 사용될 변수, 상수, 커서 등을 선언
    v_num number := 123; --변수 이름 자료형 := 값 또는 값이 도출되는 여러 표현식;
BEGIN -- 조건문, 반복문, SELECT, DML, 함수 등을 정의
    DBMS_OUTPUT.PUT_LINE(v_num); --출력
END;

DECLARE
    v_emp_no emp.empno%TYPE; --emp테이블의 사번과 같은 자료형으로 설정 참조형 자료로 쓰자. 열 참조
    v_emp emp%ROWTYPE; -- 사원이름, 급여.. 행 참조
BEGIN
    v_emp_no := 999;
    v_emp.empno := 100;
    v_emp.ename := 'TEST';
    v_emp.sal := 1000;
    DBMS_OUTPUT.PUT_LINE(v_emp_no); --999
    DBMS_OUTPUT.PUT_LINE(v_emp.empno); --100
    DBMS_OUTPUT.PUT_LINE(v_emp.ename ||','|| v_emp.sal);--TEST,1000 --v_emp변수 자체가 행 자료형
END;
----------------------------------------------------------------
DECLARE
    v_num number := 10;
BEGIN
    IF MOD(v_num, 2) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('홀수입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('짝수입니다');
    END IF;

    IF v_num > 10 THEN
        DBMS_OUTPUT.PUT_LINE('10보다 큽니다');
    ELSIF v_num > 5 THEN
        DBMS_OUTPUT.PUT_LINE('5보다 큽니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('5이하입니다');
    END IF; --IF를 종료
END;

DECLARE
    v_num number := 10;
begin
    CASE MOD(v_num, 2)
     WHEN 0 THEN
        DBMS_OUTPUT.PUT_LINE('짝수');
     ELSE
        DBMS_OUTPUT.PUT_LINE('홀수');      
    END CASE;
END;
------------------------------------------
DECLARE
    v_dname dept.dname%TYPE := 'SALES';
    v_deptno dept.deptno%TYPE;
    v_emp emp%ROWTYPE;

   CURSOR c1 IS        -- 명시적 커서 선언
    SELECT * 
    FROM emp
    WHERE deptno = 30;

BEGIN
    SELECT deptno INTO v_deptno 
    FROM dept
    WHERE dname = v_dname;

    DBMS_OUTPUT.PUT_LINE(v_dname || '부서의 부서번호는' || v_deptno);
    FOR emp_row IN c1 LOOP --30번부서에 속해있는 사원들의 정보를emp_row에 담아서 출력해라
      DBMS_OUTPUT.PUT_LINE(emp_row.empno ||'-' || emp_row.ename);  
END;
```

보기>DBMS출력 그리고 LocalSCOTT으로 접속

![20](https://user-images.githubusercontent.com/63957819/104811431-b30b2200-583e-11eb-870d-75e427f47790.png)

## 조건 제어문

JAVA에서는 IF ELSE 이지만, PL/SQL에서는 IF THEN END IF로 구성

### **IF 조건문**

IF-THEN : 특정 조건을 만족하는 경우 작업 수행

IF-THEN-ELSE : 특정 조건을 만족하는 경우와 반대 경우에 각각 지정한 작업 수행

IF-THEN-ELSIF : 여러 조건에 따라 각각 지정한 작업 수행

## 반복 제어문

### **기본 LOOP**

LOOP

반복 수행작업;

END LOOP;

### **WHILE LOOP**

WHILE 조건식 LOOP

반복 수행 작업;

END LOOP;

### **FOR LOOP**

FOR i IN 시작 값 .. 종료 값 LOOP

반복 수행 작업;

END LOOP;

### CONTINUE문, CONTINUE-WHEN문

반복 수행 중 CONTINUE가 실행되면 현재 반복 주기에 수행해야 할 남은 작업을 건너뛰고 다음 반복 주기로 바로 넘어가는 효과

CONTINUE-WHEN문은 특정 조건식을 만족할 때 다음 반복 주기로 넘어가게 된다.

**커서와 예외처리**

SELECT INTO 방식

SELECT 열1, 열2, ..., 열n INTO 변수1, 변수2, ..., 변수n

FROM ...

PL/SQL구문에서 SELECT 구문을 처리할 때 반드시 INTO절로처리하고 세미콜론으로 마무리 하여야 한다. INTO절에는 변수 이름을 적어주는데 변수의 자료형을 행 타입으로도 만들수있고 일반 자료형으로도 만들어서 쓸 수 있다.

![21](https://user-images.githubusercontent.com/63957819/104811433-b43c4f00-583e-11eb-82d1-a93a584f2f70.png)

처음 select에서 부서 번호를 찾아 v_deptno대입시켜놓고deptno랑 같은 사원정보를 추출

SALES값을DNME대입 DNAME값을DNAME값을비교하고DEPTNO검색이 될거고V_DEPTNO INTO로 대입 V_DEPTNO값은 30이 되버린다. 첫 번째 SELECT 구문은 한개의 행만 검색해온다.

 두 번째 SELECT 부서번호 30번호 해당하는 사원을 반환 즉 여러 행 검색이 되는 경우 V_EMP담는다? 논리적으로 문제 되지 않을까?있을 수 가 없다 실행하면 에러가 난다. 여러행 검색해서 V_EMP 대입 할때 에러 여러 행을 검색하는 값을 갖고 있으려면 반복문을 사용해야 한다. 여러 행을 반환하는SELECT구문을 쓸 때는 명시적 커서가 있다. FOR LOOP문을 이용하자!

> **명시적 커서**

사용자가 직접 커서를 선언하고 사용하는 커서를 뜻한다.

DECLARE

CURSOR 커서이름 IS SQL문;

BEGIN

OPEN 커서이름;

FETCH 커서이름 INTO 변수

CLOSE 커서이름;

END;

**여러 개의 행이 조회되는 경우(FOR LOOP문)**

FOR 루프 인덱스 이름 IN 커서 이름 LOOP

결과 행별로 반복 수행할 작업;

END LOOP;
