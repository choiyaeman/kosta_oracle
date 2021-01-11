--����Ŭ���� �����ϴ� �Լ�
--�����Լ�
SELECT ename, LENGTH(ename)
FROM emp;

--�׽�Ʈ�뵵�� ���̺� : dual���̺�
SELECT LENGTH('������'), 
       INSTR('ABCABC', 'B'), INSTR('ABCABC', 'X'),
       SUBSTR('ABCABC', 2, 3)       
FROM dual;

--FROM emp;

--����� �̸��� 4��° ���ڰ� 'E'�� �����ϴ� ����� ���, �̸��� ����Ͻÿ�. �� �̸��� ���������� ����Ѵ�
--1)LIKE �����ڻ��
SELECT empno, ename
FROM emp
WHERE ename LIKE '___E%'
ORDER BY ename;

--2)INSTR�Լ����
SELECT empno, ename
FROM emp
WHERE  INSTR(ename, 'E') = 4
ORDER BY ename;

--3)SUBSTR�Լ����
SELECT empno, ename
FROM emp
WHERE SUBSTR(ename, 4, 1) = 'E'
ORDER BY ename;

----------------------------------------------------------------
--�����Լ�
�� ����� �޿�, ����, �Ǳ޿��� ����Ͻÿ�. �Ǳ޿��� �޿�+����
SELECT sal, comm, sal+comm
FROM emp;

--NULL�����Լ�
--NVL()
SELECT sal, comm, sal+NVL(comm, 0)
FROM emp;

�� ����� �޿�, ����, �Ǳ޿��� ����Ͻÿ�. 
��, �Ǳ޿��� ��10�ڸ��� ǥ���ϵ� �տ� ������� #���� ä���
��) �Ǳ޿��� 2850�� ���  ######2850�� ��µȴ�
SELECT sal, comm, LPAD(sal+NVL(comm, 0), 10, '#')
FROM emp;

--��¥�Լ�
--���ó�¥, ����, ���ϳ�¥�� ����Ͻÿ�
SELECT  SYSDATE, SYSDATE-1, SYSDATE+1
FROM  dual;

--���ó�¥���� 3������, 3�������� ��¥�� ����Ͻÿ�
SELECT SYSDATE,  ADD_MONTHS(SYSDATE, 3)
         , ADD_MONTHS(SYSDATE, -3)
FROM dual;

--'20/12/08'�Ϻ��� ���ñ����� �ϼ��� ����Ͻÿ�
--����('20/12/08')�� ��¥�� �ڷ�����ȯ�� �ʿ�! : TO_DATE()
SELECT SYSDATE,   SYSDATE-TO_DATE('20/12/08')
FROM dual;

--����� �Ի���, �ٹ��ϼ�, �ٹ��������� ����Ͻÿ�
--��°���� �Ҽ��������ڸ��� ������

SELECT hiredate
         , TRUNC(SYSDATE-hiredate) �ٹ��ϼ�
         , TRUNC(MONTHS_BETWEEN( SYSDATE,hiredate)) �ٹ�������
FROM emp;

--���ƿ��� ������� ��¥�� ����Ͻÿ�
SELECT NEXT_DAY(SYSDATE, '��')
FROM dual;

--�̴��� ���������ڿ� �������� ���������ڸ� ����Ͻÿ�
SELECT LAST_DAY(SYSDATE)
         , LAST_DAY(ADD_MONTHS(SYSDATE, 1)) 
         , LAST_DAY(TO_DATE('21/02/01'))
FROM dual;
--------------------------------------------------------------------------
�ڵ�����ȯ
SELECT 1+'1', 1 || '1'
FROM dual;

SELECT empno, hiredate
FROM emp
WHERE hiredate BETWEEN '82/01/01' AND '82/12/31';

��������ȯ �Լ�

    ��¥��<--TO_DATE() --������ --TO_NUMBER()--> ������
             -- TO_CHAR()-->         <--TO_CHAR() --

����->���� TO_CHAR()
SELECT 1234567890,
           TO_CHAR(1234567890, '999,999,999,999,999'),
           TO_CHAR(1234567890, '9,999'),
           TO_CHAR(1234567890, 'L999,999,999,999,999'),
           TO_CHAR(1234567890, '000,000,000,000')
FROM  dual;

--�� ����� �޿�, ����, �Ǳ޿��� ����Ͻÿ�. �Ǳ޿��� �޿�+����
�Ǳ޿��� 3�ڸ����� ,�� ����Ѵ�
SELECT sal, comm, TO_CHAR(sal+NVL(comm, 0), '9,999,999')
FROM emp;
-------------------------
����->���� TO_NUMBER()
SELECT  TO_NUMBER('123'),  TO_NUMBER('1,234', '9,999')
FROM dual;
-------------------------
��¥->���� TO_CHAR()
SELECT  TO_CHAR(SYSDATE, 'YYYY'),
             TO_CHAR(SYSDATE, 'MM-DD HH24:MI:SS DAY')
FROM dual;
--21�� 12�� 25���� ������ ����Ͻÿ�
SELECT TO_CHAR(TO_DATE('21/12/25'), 'DAY')
FROM dual; 
---------------------------------------------------------------
NULL�����Լ�: NVL(�÷�, ��ȯ��), NVL2(�÷� ,null�ƴѰ�캯ȯ��,null�ΰ�� ��ȯ��)
--������ �޴� ����� ������ ����ϰ�
--������ �ȹ޴� ����� 0�� ����Ͻÿ�
SELECT empno, comm,  NVL(comm, 0)  FROM emp;

--������ �޴� ����� '�������'�� ����ϰ�
--������ �ȹ޴� ����� '����ȹ���'�� ����Ͻÿ�
SELECT empno, comm,  NVL2(comm, '�������', '����ȹ���') FROM emp;

--������ �޴� ����� '�������'�� ���簪�� ����ϰ� ex) �������1500
--������ �ȹ޴� ����� '����ȹ���'�� ����Ͻÿ�
SELECT empno, comm,  NVL2(comm, '�������'||comm, '����ȹ���') ���翩�� FROM emp;

--��������� �����Ͻÿ�
SELECT empno, comm
FROM emp
ORDER BY comm ASC;
---------------------------------
IF~ELSE�� ���� ȿ�� : DECODE(), CASE��:ǥ��
--����� ������ MANAGER�� ����� �޿��� 10%�����Ͽ� ����ϰ�
             ������ SALEMAN�� ����� �޿��� 50%�����Ͽ� ����Ͻÿ�
SELECT empno, job, sal, DECODE(job, 'MANAGER', sal*1.1, 'SALESMAN', sal*1.5, sal) ����޿��λ�
FROM  emp;

SELECT empno, job, sal,
           CASE job WHEN 'MANAGER'  THEN sal*1.1
                         WHEN 'SALESMAN' THEN sal*1.5
                         ELSE sal
           END   ����޿��λ�           
FROM emp;

--����� �޿��� 3000�̻��̸� 'A'���, 1000�̻��̸� 'B'���, �׿��̸� 'C'������� ����Ͻÿ�
SELECT empno, sal,
           CASE WHEN sal >= 3000 THEN 'A'
                   WHEN sal >= 1000 THEN 'B'
                   ELSE 'C'
           END �޿����
FROM emp;
------------------------------------------------------------------------------------------
�������Լ� : SUM(), AVG(), COUNT(), MAX(), MIN(), STDDEV() 
--������� �ѻ����, ������ �޴� �����,
               �ѱ޿�, ��ձ޿�, �ִ�޿���, �ּұ޿����� ����Ͻÿ�
SELECT  COUNT(empno),  COUNT(comm), --NULL�������ϰ� ����� ���
            COUNT(*), --NULL�������Ͽ� ����� ���
            SUM(sal),  AVG(sal), MAX(sal), MIN(sal)
FROM emp;
-------------------------------------------------------------------------------------------
�׷�ó�� : GROUP BY
               �Ի����ں� ������� ����Ͻÿ�.
               �μ��� �μ���ȣ, �ѱ޿��� ����Ͻÿ�
               ������ �ִ�޿��� ����Ͻÿ�
SELECT  hiredate, COUNT(*)
FROM emp
GROUP BY hiredate
ORDER BY hiredate;

DESC emp;

--�μ��� �����, �ѱ޿�, �ִ�/�ּұ޿�, ��ձ޿��� ����Ͻÿ�
SELECT deptno, COUNT(*), SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM emp
GROUP BY deptno;

--GROUP BY�� UNION�� ����--
SELECT  COUNT(*), SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM emp
WHERE deptno=10
UNION
SELECT COUNT(*), SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM emp
WHERE deptno=20
UNION
SELECT  COUNT(*), SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM emp
WHERE deptno=30;

--�Ի�⵵�� �Ի�⵵,�Ի��ڼ��� ����Ͻÿ�
SELECT TO_CHAR(hiredate, 'YY') �Ի�⵵, COUNT(*) �Ի��ڼ�
FROM emp
GROUP BY TO_CHAR(hiredate, 'YY');


SELECT SUBSTR(TO_CHAR(hiredate, 'YY'), 1, 2) �Ի�⵵, COUNT(*) �Ի��ڼ�
FROM emp
GROUP BY SUBSTR(TO_CHAR(hiredate, 'YY'), 1, 2);

--�Ի���� �Ի��, �Ի��ڼ��� ����Ͻÿ�. 1������ ���ʷ� ����Ͻÿ�. 
                                                           �� 1���� 01�� �ƴ϶� 1���� ���
                                                                2      02�� �ƴ϶� 2���� ���
                                                                3       03��          3�� "       
SELECT TO_CHAR(hiredate, 'MM') �Ի��, COUNT(*)
FROM emp
GROUP BY TO_CHAR(hiredate, 'MM')
ORDER BY �Ի��;

SELECT TO_NUMBER(TO_CHAR(hiredate, 'MM')) || '��' �Ի��, COUNT(*)
FROM emp
GROUP BY TO_NUMBER(TO_CHAR(hiredate, 'MM'))
ORDER BY TO_NUMBER(TO_CHAR(hiredate, 'MM'));
--���Ľ� ���ڿ� ������������: 1��, 10��, 11��, 12��, 2��
--          ���� ������������:  1, 2, 3, 4, 10, 11, 12
----------------------------------------------------------------------

������ : WHERE - �Ϲ�����
            HAVING - GROUP BY�� ���� ����

--�޿��� 2000�̻��� ����� �μ��� ������� ����Ͻÿ�
SELECT deptno, COUNT(*)
FROM emp
WHERE sal>=2000
GROUP BY deptno;

--�μ��� ��ձ޿��� 2000�̻��� �μ����� ������� ����Ͻÿ�
SELECT deptno, COUNT(*), AVG(sal)
FROM emp
GROUP BY deptno
HAVING  AVG(sal) >= 2000;
---------------------------------------------------------------------------













