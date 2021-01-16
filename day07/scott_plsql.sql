scott_plsql.sql
--
SET SERVEROUTPUT ON

DECLARE 
   v_num number := 123;
BEGIN
   DBMS_OUTPUT.PUT_LINE(v_num); --���
END;

DECLARE
   v_emp_no emp.empno%TYPE;
   v_emp  emp%ROWTYPE;
BEGIN
   v_emp_no := 999;
   v_emp.empno := 100;
   v_emp.ename := 'TEST';
   v_emp.sal := 1000;
   DBMS_OUTPUT.PUT_LINE(v_emp_no); --999
   DBMS_OUTPUT.PUT_LINE(v_emp.empno); --100
   DBMS_OUTPUT.PUT_LINE(v_emp.ename ||','|| v_emp.sal); --TEST,1000
END;
-----------------------------------------
DECLARE
   v_num number := 10;
BEGIN
  IF MOD(v_num, 2) = 1  THEN  
      DBMS_OUTPUT.PUT_LINE('Ȧ���Դϴ�');
  ELSE 
      DBMS_OUTPUT.PUT_LINE('¦���Դϴ�');
  END IF;

  IF v_num > 10 THEN
      DBMS_OUTPUT.PUT_LINE('10���� Ů�ϴ�');
  ELSIF  v_num > 5 THEN
      DBMS_OUTPUT.PUT_LINE('5���� Ů�ϴ�');
  ELSE 
      DBMS_OUTPUT.PUT_LINE('5�����Դϴ�');
  END IF;
END;

DECLARE 
   v_num number := 10;
BEGIN
   CASE MOD(v_num, 2)
     WHEN  0 THEN
          DBMS_OUTPUT.PUT_LINE('¦��');
     ELSE
        DBMS_OUTPUT.PUT_LINE('Ȧ��');
   END CASE;
END;
-------------------------------------------------------
DECLARE
    v_dname dept.dname%TYPE := 'SALES';
    v_deptno dept.deptno%TYPE;
    v_emp emp%ROWTYPE;

   CURSOR c1 IS
    SELECT * 
    FROM emp
    WHERE deptno = 30;

BEGIN
    SELECT deptno INTO v_deptno 
    FROM dept
    WHERE dname = v_dname;

    DBMS_OUTPUT.PUT_LINE(v_dname || '�μ��� �μ���ȣ��' || v_deptno);
    FOR emp_row IN c1 LOOP
      DBMS_OUTPUT.PUT_LINE(emp_row.empno ||'-' || emp_row.ename);
   END LOOP;    
END;