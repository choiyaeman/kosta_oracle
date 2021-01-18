scott_procedure.sql
scott_procedure.sql
--홀/짝 구분하는 프로시져를 생성한다
CREATE OR REPLACE PROCEDURE pro_evenodd(v_num NUMBER)
IS
BEGIN
  --v_num이 짝수인경우 '짝수입니다', 홀수인 경우 '홀수입니다'를 출력
  IF MOD(v_num, 2) = 0 THEN
     DBMS_OUTPUT.PUT_LINE(v_num || '짝수입니다');
  ELSE 
     DBMS_OUTPUT.PUT_LINE(v_num || '홀수입니다');
  END IF; 
END;

SET SERVEROUTPUT ON
EXECUTE pro_evenodd(127);

--부서이름에 해당 부서번호 찾고 부서번호에 속한 사원의 사번, 이름을 출력하는
--프로시져 생성하기

CREATE OR REPLACE PROCEDURE pro_emp_for_dept(v_dname VARCHAR2)
IS
   v_deptno dept.deptno%TYPE;   

   CURSOR c1 IS 
   SELECT empno, ename  
   FROM emp
   WHERE deptno = v_deptno;

BEGIN
   SELECT deptno INTO v_deptno 
   FROM dept
   WHERE dname = v_dname;
   
   FOR result IN  c1 LOOP
      DBMS_OUTPUT.PUT_LINE(result.empno || '-' || result.ename);
   END LOOP;
END;


EXECUTE pro_emp_for_dept('SALES');
--7499-ALLEN
--7521-WARD
--7654-MARTIN
--7698-BLAKE
--7844-TURNER
--7900-JAMES

--계좌이체용 프로시져를 생성
CREATE OR REPLACE PROCEDURE pro_transfer(from_account VARCHAR
                                                             , to_account VARCHAR
                                                             , amount NUMBER) 
IS
   v_balance account.balance%TYPE;

   transfer_exception EXCEPTION;
BEGIN   
   SELECT balance  INTO v_balance
   FROM account
   WHERE no = from_account;
   DBMS_OUTPUT.PUT_LINE(from_account||'계좌의 잔액' || v_balance);
  
   IF  v_balance <  amount  THEN
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
  WHEN transfer_exception  THEN
       ROLLBACK;
       DBMS_OUTPUT.PUT_LINE('이체 실패:잔액부족');       
END;

EXECUTE pro_transfer('101', '202', 10); --성공
EXECUTE pro_transfer('999', '202', 10); --실패
EXECUTE pro_transfer('101', '999', 10); --실패
--현재101계좌의 잔액이 60인 경우 이체금액을 1000으로 설정하려면 트랜잭션실패
EXECUTE pro_transfer('101', '202', 1000); --실패