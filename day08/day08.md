# day08

1. 오라클 설치 확인 c:\oraclexe 
2. 오라클 서비스 확인 OracleServiceXE, OracleXETNSListener 시작됨
3. 오라클 SQLDeveloper확인/시작 

   3-1)접속 확인-localSYSTEM, localSCOTT, localHR

   3-2)SCOTT계정에 테이블 존재 확인 - CUSTOMER, PRODUCT, ORDER_INFO, ORDER_LINE

customer, product는 부모 테이블 order_info, order_line은 자식 테이블이다 부모가 참조되어 있는 경우 부모를 삭제할 수 없다. 자식 테이블부터 먼저 삭제를 해줘야 한다.

   3-3)자식엔터티테이블부터 삭제

   ORDER_LINE -0 건

   ORDER_INFO -1건

   PRODUCT -0건

   CUSTOMER -7건

   3-4) SCOTT계정에 VIEW생성 권한을 추가

   -SYSTEM계정으로 접속 ex) sqlplus system/kosta 

   -scott계정에 권한 부여 grant create view TO scott;

   3-5) 익스포트된 SQL파일을 sqlplus에서 로드 ex)sqlplus scott/tiger
                                                @실습

```sql
SELECT * FROM order_line;
SELECT *FROM order_info;
DROP TABLE customer; --오류발생. 자식쪽에서 참조되는 부모테이블 자료는 삭제 불가능!
DROP TABLE order_line;
DROP TABLE order_info;
DROP TABLE product;
DROP TABLE ACCOUNT;
```

```sql
C:\CYM\MYSQL>sqlplus scott/tiger
SQL> @실습
```

sql 파일은 그냥 파일이고 그 파일 내용을 실행해서 oracle객체 형태로 저장 시킬 수 있는데 이때까지 한 파일에 있기는 하나 oracle에 객체로 저장 시킨 거는 아니다. 저장할 수 있는 방법은 프로시저,  function형태로 할 수 있다.

## 저장 서브프로그램

> **저장 서브프로그램이란?**

여러 번 사용할 목적으로 이름을 지정하여 오라클에 저장해 두는 PL/SQL 프로그램을 저장 서브프로그램이라고 한다.

오라클에서는 용도에 따라 여러 가지 방식으로 저장 서브프로그램을 구현할 수 있는데 대표적인 구현 방식은 프로시저, 함수, 패키지, 트리거가 있다.

프로시저는 반환형이 없고 함수는 반환형이 있다. 결과를 반환하지 않아도 되는 기능이라면 프로시저를 사용하면 된다.

> **파라미터를 사용하지 않는 프로시저**

CREATE [OR REPALCE] PROCEDURE 프로시저 이름

IS | AS

선언부

BEGIN

실행부

EXCEPTION

예외 처리부

END [프로시저 이름];

SQL*PLUS로 프로시저 실행하기

EXECUTE 프로시저 이름;

> **파라미터를 사용하는 프로시저**

→ 매개변수를 갖는 프로시저 의미.

CREATE [OR REPLACE] PROCEDURE 프로시저 이름

[(파라미터 이름1 [modes] 자료형 [ := | DEFAULT 기본값],

파라미터 이름2 [modes] 자료형 [ := | DEFAULT 기본값],

...

파라미터 이름N [modes] 자료형 [ := | DEFAULT 기본값]

)]

IS | AS

선언부

BEGIN

실행부

EXCEPTION

예외 처리부

END [프로시저 이름];

**IN 모드 파라미터**

프로시저 실행에 필요한 값을 직접 입력받는 형식의 파라미터를 지정할 때 IN을 사용

IN은 기본값이기 때문에 생략 가능

**OUT 모드 파라미터**

OUT모드를 사용한 파라미터는 프로시저 실행 후 호출한 프로그램으로 값을 반환한다.

- scott_procedure.sql

```sql
--홀/짝 구분하는 프로시져를 생성한다
CREATE OR REPLACE PROCEDURE pro_evenodd(v_num NUMBER)
IS
BEGIN
--v_num이 짝수인 경우 '짝수입니다', 홀수인 경우 '홀수입니다'를 출력
    IF MOD(V_NUM,2)=0 THEN
        DBMS_OUTPUT.PUT_LINE(v_num ||'짝수입니다.');
    ELSE 
         DBMS_OUTPUT.PUT_LINE(v_num || '홀수입니다.');
    END IF;
END;
SET SERVEROUTPUT ON
EXECUTE pro_evenodd(127);

--부서이름에 해당 부서번호 찾고 부서번호에 속한 사원의 사번, 이름을 출력하는
--프로시져 생성하기 **참고** => 여러행을 반환하는 경우 pl/sql경우 커서 처리를 해줘야 한다.
CREATE OR REPLACE PROCEDURE pro_emp_for_dept(v_dname VARCHAR2) --varcahr2(14)(x) 매개변수의 자릿수는 지정 못한다.
IS
 v_deptno dept.deptno%TYPE;
 v_empno emp.empno%TYPE;
 v_ename emp.ename%TYPE;
 
 CURSOR c1 IS
 SELECT empno, ename
 FROM emp
 WHERE deptno = v_deptno;
 
BEGIN
 SELECT deptno INTO v_deptno
 FROM dept
 WHERE dname = v_dname;
 /* 커서로 처리되어야함!
 SELECT empno,  ename INTO v_empno, v_ename
 FROM emp
 WHERE deptno = v_deptno
 */
 FOR result IN c1 LOOP
    DBMS_OUTPUT.PUT_LINE(result.empno ||'-'|| result.ename);
 END LOOP;
END;

EXECUTE pro_emp_for_dept('SALES');

--계좌 이체용 프로시져를 생성
CREATE OR REPLACE PROCEDURE pro_transfer(from_account VARCHAR
                                                             , to_account VARCHAR
                                                             , amount NUMBER) 
IS
   v_balance account.balance%TYPE;

   transfer_exception EXCEPTION; --사용자정의 예외
BEGIN   
   SELECT balance INTO v_balance
   FROM account
   WHERE no = from_account;
   DBMS_OUTPUT.PUT_LINE(from_account||'계좌의 잔액' || v_balance);
  
   IF  v_balance <  amount  THEN --출금액보다 잔액이 작은경우는 강제로 예외발생
       RAISE transfer_exception; 
   END IF;

   DBMS_OUTPUT.PUT_LINE('출금시작');   
   UPDATE account
   SET balance = balance - amount
   WHERE no = from_account;
   DBMS_OUTPUT.PUT_LINE('출금종료');

   SELECT balance  INTO v_balance
   FROM account
   WHERE no = from_account;
   DBMS_OUTPUT.PUT_LINE(from_account||'계좌의 잔액' || v_balance);

   SELECT balance  INTO v_balance
   FROM account
   WHERE no = to_account;
   DBMS_OUTPUT.PUT_LINE(to_account||'계좌의 잔액' || v_balance);

   DBMS_OUTPUT.PUT_LINE('입금시작');
   UPDATE account
   SET balance = balance + amount
   WHERE no = to_account;   
   DBMS_OUTPUT.PUT_LINE('입금종료');

   SELECT balance  INTO v_balance
   FROM account
   WHERE no = to_account; 
   DBMS_OUTPUT.PUT_LINE(to_account||'계좌의 잔액' || v_balance);

   DBMS_OUTPUT.PUT_LINE('이체 완료');
   COMMIT;

EXCEPTION 
   WHEN NO_DATA_FOUND THEN
       ROLLBACK;
       DBMS_OUTPUT.PUT_LINE('이체 실패:계좌없음');
  WHEN transfer_exception THEN
       ROLLBACK;
       DBMS_OUTPUT.PUT_LINE('이체 실패:잔액부족');       
END;

EXECUTE pro_transfer('101', '202', 10); --성공
EXECUTE pro_transfer('999', '202', 10); --실패
EXECUTE pro_transfer('101', '999', 10); --실패
--현재101계좌의 잔액이 60인 경우 이체금액을 1000으로 설정하려면 트랜잭션실패
EXECUTE pro_transfer('101', '202', 1000); --실패
```

sqlplus

```sql
sqlplus scott/tiger
@실습
```

## 예외종류

내부 예외와 사용자 정의 예외로 나뉜다.

내부 예외는 오라클에서 미리 정의한 예외를 뜻하며  사용자 정의 예외는 사용자가 필요에 따라 추가로 정의한 예외를 의미한다. 내부 예외는 이름이 정의되어 있는 예외인 사전 정의된 예외와 이름이 정해지지 않는 예외로 다시 나뉜다.

> **예외 처리부 작성**

EXCEPTION

WHEN 예외 이름1 [OR 예외 이름2 - ] THEN

예외 처리에 사용할 명령어;

WHEN 예외 이름3 [OR 예외 이름 4 - ] THEN

예외 처리에 사용할 명령어;

...

WHEN OTHERS THEN

예외 처리에 사용할 명령어;

**이름 없는 예외 사용**

DECLARE

예외 이름1 EXCEPTION;

PRAGMA EXCEPTION_INIT(예외 이름1, 예외 번호);

.

.

.

EXCEPTION

WHEN 예외 이름1 THEN

예외 처리에 사용할 명령어;

...

END;

**사용자 정의 예외 사용**

DECLARE

사용자 예외 이름 EXCEPTION;

...

BEGIN

IF 사용자 예외를 발생시킬 조건 TEHN

RAISE 사용자 예외 이름

...

END IF;

EXCEPTION

WHEN 사용자 예외 이름 THEN

예외 처리에 사용할 명령어;

...

END;

- scott_function1.sql

```sql
--홀짝을 판별하는 함수 생성하기
CREATE OR REPLACE FUNCTION fun_evenodd(num number)
RETURN varchar2
IS
BEGIN
    IF MOD(num, 2) = 0 THEN
     RETURN '짝수';
    ELSE
     RETURN '홀수';
    END IF;
END;

SELECT fun_evenodd(127), fun_evenodd(12)
FROM dual;

--fun_start_row(현재페이지, 페이지별 보여줄 목록수)
--페이지에 해당하는 시작행을 반환하는 함수 : fun_start_row
CREATE OR REPLACE FUNCTION fun_start_row(curr_page number, cnt_per_page number)
RETURN number
IS
  fun_start_row_exception EXCEPTION; --사용자 정의 예외 선언
BEGIN
  IF curr_page < 1 THEN  --현재 페이지가 1보다 작은경우 강제예외 발생!
     RAISE fun_start_row_exception;
  END IF;
  RETURN (curr_page - 1) * cnt_per_page + 1;  
EXCEPTION
  WHEN fun_start_row_exception THEN --발생되는 예외를 잡는다
     RAISE_APPLICATION_ERROR(-20001, '페이지는 1이상이어야합니다');  --오라클 사용자에러코드범위 : -20000~20999
END;

SELECT fun_start_row(1, 10) FROM dual; --1
SELECT fun_start_row(2, 10) FROM dual; --11
SELECT fun_start_row(3, 10) FROM dual; --21
SELECT fun_start_row(2, 5) FROM dual; --6
SELECT fun_start_row(2, 7) FROM dual; --8
--페이지에 해당하는 끝행을 반환하는 함수 : fun_end_row
CREATE OR REPLACE FUNCTION fun_end_row(curr_page number, cnt_per_page number)
RETURN number
IS
  fun_start_row_exception EXCEPTION; 
BEGIN
  IF curr_page < 1 THEN 
     RAISE fun_start_row_exception;
  END IF;
  RETURN curr_page  * cnt_per_page;  
EXCEPTION
  WHEN fun_start_row_exception THEN
     RAISE_APPLICATION_ERROR(-20001, '페이지는 1이상이어야합니다');     
END;

--전체행 검색해보기
SELECT *
FROM emp
ORDER BY sal;

--페이지별 5행씩 검색되는 2페이지에 해당하는 사원들 출력하기
SELECT *
FROM (SELECT rownum rno, a.*
          FROM (SELECT *
                    FROM emp
                    ORDER BY sal ) a)
WHERE rno BETWEEN fun_start_row(2, 5)  AND fun_end_row(2, 5);

-- 옳지 않은 페이지에 해당하는 사원들 출력하기
SELECT *
FROM (SELECT rownum rno, a.*
          FROM (SELECT *
                    FROM emp
                    ORDER BY sal ) a)
WHERE rno BETWEEN fun_start_row(-1, 5)  AND fun_end_row(-1, 5);
```

FUNCTION은 결과 값이 리턴 되어야 하는데 정상 리턴 아니면 예외 결과 값이 리턴 되기도 가능하다. 이 RAISE_APPLICATION_ERROR함수가 강제로 예외를 발생 시키는 함수이다. PRIMARY키 중복일 경우 에러 코드 번호 1번이다. 사용자 정의 에러를 발생 시킬 때에는 에러 코드 범위가 있는데 -20000~20999이다.

![1](https://user-images.githubusercontent.com/63957819/104920127-b1766100-59da-11eb-8f20-ba9b4ae4aebf.png)

## 함수

크게 내장 함수와 사용자 정의 함수로 분류할 수 있다.

반드시 하나의 값을 반환해야 하며 값의 반환은 프로시저와 달리 OUT, INT OUT모드의 파라미터를 사용하는 것이 아니라 RETURN절과 RETURN문을 통해 반환

CREATE [OR REPLACE] FRUNCTION 함수 이름

[(파라미터 이름 [IN] 자료형1,

  파라미터 이름2 [IN] 자료형2,

  ...

 파라미터 이름N [IN] 자료형N

)]

RETURN 자료형

IS  | AS

선언부

BEGIN

실행부

RETURN (반환 값);

EXCEPTION

예외 처리부

END [함수 이름];

- scott_trigger.sql

```sql
--포인트 테이블 생성 --기본값먼저 설정하고 제약조건 설정하는 것
CREATE TABLE POINT(
    ID VARCHAR2(5) PRIMARY KEY,
    SCORE NUMBER(5) DEFAULT 0 NOT NULL,
    CONSTRAINT POINT_ID_FK FOREIGN KEY(ID) REFERENCES CUSTOMER(ID));
    
INSERT INTO point(id, score) VALUES ('id1', 0);
INSERT INTO point(id) VALUES ('id2');
INSERT INTO point(id) VALUES ('id3');
INSERT INTO point(id) VALUES ('id4');
INSERT INTO point(id) VALUES ('id5');
INSERT INTO point(id) VALUES ('id6');
INSERT INTO point(id) VALUES ('id7');

commit;

--고객행이 추가될때마다 포인트행도 자동 추가되는 트리거 생성
CREATE OR REPLACE TRIGGER trg_insert_customer --커스터머 테이블이 인설트될때 자동생성되는 트리거
  AFTER INSERT ON customer
  FOR EACH ROW --인설트가 된 행별로 트리거 처리 하겠다라는 의미
BEGIN
  INSERT INTO point(id) VALUES ( :NEW.id ); --1번 작업에서 추가된 새로운행이 :new이다.
END;

--고객행 추가
INSERT INTO customer(id, pwd, name) VALUES ('id9', 'p9', 'n9');
SELECT * FROM customer;
SELECT * FROM point;

--트리거 생성: 
--주문기본(order_info)행 추가될때마다 포인트(point)행의 점수(score)가 자동 1점씩 누적
--트리거명: trg_order_info
CREATE OR REPLACE TRIGGER trg_order_info
    AFTER INSERT ON order_info
    FOR EACH ROW
BEGIN
    UPDATE point SET score = score+1 WHERE id = :NEW.order_id;
END;
--주문기본행 추가
INSERT INTO order_info(order_no, order_id) VALUES (999, 'id1');
SELECT * FROM order_info; --추가 확인
SELECT * FROM point; --'id1'의 점수가 1점 증가확인
```

## 패키지

### **패키지란?**

업무나 기능 면에서 연관성이 높은 프로시저, 함수 등 여러 개의 PL/SQL 서브프로그램을 하나의 논리 그룹으로 묶어 통합 관리하는 데 사용하는 객체를 뜻한다.

**패키지 명세**

패키지 명세서는 패키지에 포함할 변수, 상수, 예외, 커서 그리고 PL/SQL 서브프로그램을 선언하는 용도

CREATE [OR REPLACE] PACKAGE 패키지 이름

IS | AS

서브프로그램을 포함한 다양한 객체 선언

END [패키지 이름];

**패키지 본문**

패키지 본문에는 패키지 명세에서 선언한 서브프로그램 코드를 작성. 그리고 패키지 명세에 선언하지 않은 객체나 서브프로그램을 정의하는 것도 가능.

CREATE [OR REPALCE] PACKAGE BODY 패키지 이름

IS | AS

패키지 명세에서 선언한 서브프로그램을 포함한 여러 객체를 정의

경우에 따라 패키지 명세에 존재하지 않는 객체 및 서브프로그램도 정의 가능

END [패키지 이름];

## 트리거

### 트리거란?

데이터베이스 안의 특정 상황이나 동작, 즉 이벤트가 발생할 경우에 자동으로 실행되는 기능을 정의하는 PL/SQL 서브프로그램이다.

**DML 트리거**

특정 테이블에 DML명령어를 실행했을 때 작동하는 트리거

CREATE [OR REPLACE] TRIGGER 트리거 이름

BEFORE | AFTER

INSERT | UPDATE | DELETE ON 테이블 이름

REFERENCING OLD as old | NEW new

FOR EACH ROW WEHN 조건식

FOLLOWS 트리거 이름2, 트리거 이름3 ...

ENABLE | DISABLE

DECLARE

선언부

BEGIN

실행부

**트리거 변경**

ALTER TRIGGER 트리거 이름 ENABLE | DISABLE;

**트리거 삭제**

DROP TRIGGER 트리거 이름;

![2](https://user-images.githubusercontent.com/63957819/104920131-b2a78e00-59da-11eb-8a5f-0a30d66f07ae.png)

1번 작업에서 추가된 새로운 행이 2번 작업 :NEW이다. 

:OLD는 업데이트나 delete시에 수정 되기 전 또는 삭제 되기 전의 행을 의미한다.

:NEW는 업데이트나 insert시에 수정 후 또는 추가 후의 행을 의미한다.
