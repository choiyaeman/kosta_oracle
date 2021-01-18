--Ȧ¦�� �Ǻ��ϴ� �Լ������ϱ�
CREATE OR REPLACE FUNCTION fun_evenodd(num number)
RETURN varchar2
IS
BEGIN
   IF MOD(num, 2) = 0 THEN
      RETURN '¦��';
   ELSE
      RETURN 'Ȧ��';
   END IF;
END;

SELECT fun_evenodd(127), fun_evenodd(12)
FROM dual;

--�������� �ش��ϴ� �������� ��ȯ�ϴ� �Լ� : fun_start_row
CREATE OR REPLACE FUNCTION fun_start_row(curr_page number, cnt_per_page number)
RETURN number
IS
  fun_start_row_exception EXCEPTION;
BEGIN
  IF curr_page < 1 THEN 
     RAISE fun_start_row_exception;
  END IF;
  RETURN (curr_page - 1) * cnt_per_page + 1;  
EXCEPTION
  WHEN fun_start_row_exception THEN
     RAISE_APPLICATION_ERROR(-20001, '�������� 1�̻��̾���մϴ�');     
END;

--�������� �ش��ϴ� ������ ��ȯ�ϴ� �Լ� : fun_end_row
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
     RAISE_APPLICATION_ERROR(-20001, '�������� 1�̻��̾���մϴ�');     
END;

--��ü�� �˻��غ���
SELECT *
FROM emp
ORDER BY sal;

--�������� 5�྿ �˻��Ǵ� 2�������� �ش��ϴ� ����� ����ϱ�
SELECT *
FROM (SELECT rownum rno, a.*
          FROM (SELECT *
                    FROM emp
                    ORDER BY sal ) a)
WHERE rno BETWEEN fun_start_row(2, 5)  AND fun_end_row(2, 5);


-- ���� ���� �������� �ش��ϴ� ����� ����ϱ�
SELECT *
FROM (SELECT rownum rno, a.*
          FROM (SELECT *
                    FROM emp
                    ORDER BY sal ) a)
WHERE rno BETWEEN fun_start_row(-1, 5)  AND fun_end_row(-1, 5);