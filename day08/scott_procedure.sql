scott_procedure.sql
scott_procedure.sql
--Ȧ/¦ �����ϴ� ���ν����� �����Ѵ�
CREATE OR REPLACE PROCEDURE pro_evenodd(v_num NUMBER)
IS
BEGIN
  --v_num�� ¦���ΰ�� '¦���Դϴ�', Ȧ���� ��� 'Ȧ���Դϴ�'�� ���
  IF MOD(v_num, 2) = 0 THEN
     DBMS_OUTPUT.PUT_LINE(v_num || '¦���Դϴ�');
  ELSE 
     DBMS_OUTPUT.PUT_LINE(v_num || 'Ȧ���Դϴ�');
  END IF; 
END;

SET SERVEROUTPUT ON
EXECUTE pro_evenodd(127);

--�μ��̸��� �ش� �μ���ȣ ã�� �μ���ȣ�� ���� ����� ���, �̸��� ����ϴ�
--���ν��� �����ϱ�

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

--������ü�� ���ν����� ����
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
   DBMS_OUTPUT.PUT_LINE(from_account||'������ �ܾ�' || v_balance);
  
   IF  v_balance <  amount  THEN
       RAISE transfer_exception; 
   END IF;

   DBMS_OUTPUT.PUT_LINE('��ݽ���');   
   UPDATE account
   SET balance = balance - amount
   WHERE no = from_account;
   DBMS_OUTPUT.PUT_LINE('�������');

   SELECT balance  INTO v_balance
   FROM account
   WHERE no = from_account;
   DBMS_OUTPUT.PUT_LINE(from_account||'������ �ܾ�' || v_balance);


   SELECT balance  INTO v_balance
   FROM account
   WHERE no = to_account;
   DBMS_OUTPUT.PUT_LINE(to_account||'������ �ܾ�' || v_balance);

   DBMS_OUTPUT.PUT_LINE('�Աݽ���');
   UPDATE account
   SET balance = balance + amount
   WHERE no = to_account;   
   DBMS_OUTPUT.PUT_LINE('�Ա�����');

   SELECT balance  INTO v_balance
   FROM account
   WHERE no = to_account; 
   DBMS_OUTPUT.PUT_LINE(to_account||'������ �ܾ�' || v_balance);

   DBMS_OUTPUT.PUT_LINE('��ü �Ϸ�');
   COMMIT;

EXCEPTION 
   WHEN NO_DATA_FOUND THEN
       ROLLBACK;
       DBMS_OUTPUT.PUT_LINE('��ü ����:���¾���');
  WHEN transfer_exception  THEN
       ROLLBACK;
       DBMS_OUTPUT.PUT_LINE('��ü ����:�ܾ׺���');       
END;

EXECUTE pro_transfer('101', '202', 10); --����
EXECUTE pro_transfer('999', '202', 10); --����
EXECUTE pro_transfer('101', '999', 10); --����
--����101������ �ܾ��� 60�� ��� ��ü�ݾ��� 1000���� �����Ϸ��� Ʈ����ǽ���
EXECUTE pro_transfer('101', '202', 1000); --����