SELECT empno, sal
FROM emp;

SELECT * --��������
FROM emp; --������
----------------
--�÷���Ī�ֱ�
SELECT empno ���, ename, sal �޿�
FROM emp;

SELECT empno "��� ��ȣ", ename, sal �޿�
FROM emp;

SELECT empno AS "��� ��ȣ", ename, sal AS �޿�
FROM emp;
---------------------------------
--�÷��� ���տ����� ||
SELECT empno || ename || sal
FROM emp;

SELECT empno || ename || sal "����� �̸��� �޿�"
FROM emp;

--SQL�� ���ڿ����ͷ�, ��¥���ͷ��� '�� ����Ѵ� ex) 'hello', '21/05/07'
SELECT empno ||'-'|| ename ||'-'|| sal "����� �̸��� �޿�"
FROM emp;
------------------------------------
--��������� : +, -, *, /
--�����������ϴ� �Լ�: MOD()
SELECT empno, MOD(empno, 2), ename, sal,  sal*12
FROM emp;
--------------------------
--�ߺ��� ����
SELECT DEPTNO
FROM emp; --14��

SELECT DISTINCT deptno
FROM emp; --3��
----------------------
--�����ϱ�
SELECT empno, ename, sal
FROM emp
ORDER BY sal DESC, ename ASC; --�޿��� ���� ������� ����Ѵ�
                              --��, �޿��� ������ �̸��� ���������� ����Ѵ�
-----------------------------------------------
SELECT���� ó�� ����: 
   [FROM -> WHERE -> GROUP BY -> HAVING] -> [SELECT -> ORDER BY]
-----------------------------------------------
SELECT
FROM
[
WHERE 
GROUP BY
HAVING
ORDER BY
]
--ORDER BY���� ��Ī��밡��
SELECT empno, ename, sal "�޿�"
FROM emp
ORDER BY �޿� DESC, ename;
--ORDER BY���� �������ǿ� �������� ���� �÷���밡��
SELECT empno, ename
FROM emp
ORDER BY sal DESC;

--ORDER BY���� �������ǿ� ������ �÷������� ��밡��
SELECT empno, ename, sal
FROM emp
ORDER BY 3 DESC;
--------------------------------------------
--WHERE�� : ���ǿ� �����ϴ� ���� ������
--�񱳿����� : >, >=, <, <=, =
--�������� : AND, OR, NOT

--�޿��� 1250�� ����� ���,�̸�,�޿��� ����Ͻÿ�
SELECT empno, ename, sal
FROM emp
WHERE sal = 1250;

--�޿��� 1250���� ���� ����� ���,�̸�,�޿��� ����Ͻÿ�. �� �޿��� ���� ������� ����Ѵ�
SELECT empno, ename, sal
FROM emp
WHERE sal > 1250
ORDER BY sal DESC;

--�޿��� 1500�̻� 3000������ ��� ����� ���,�̸�,�޿��� ����ϼ���. 
--�� �޿��� ���� ������� ����Ѵ�
SELECT empno, ename, sal
FROM emp
WHERE sal >= 1500 AND sal <= 3000
ORDER BY sal DESC;

SELECT empno, ename, sal
FROM emp
WHERE sal BETWEEN 1500 AND 3000
ORDER BY sal DESC;


--�޿��� 1500�̸� 3000�ʰ��� ��� ����� ���,�̸�,�޿��� ����ϼ���. 
--�� �޿��� ���� ������� ����Ѵ�
SELECT empno, ename, sal
FROM emp
WHERE sal < 1500 OR sal > 3000
ORDER BY sal DESC;

SELECT empno, ename, sal
FROM emp
WHERE NOT(sal >= 1500 AND sal <= 3000)
ORDER BY sal DESC;

SELECT empno, ename, sal
FROM emp
WHERE NOT sal BETWEEN 1500 AND 3000
ORDER BY sal DESC;
--------------------------------------
--�μ���ȣ�� 10, 30���� ����� ���,�̸�, �޿�, �μ���ȣ�� ����Ͻÿ�
SELECT empno, ename, sal,deptno
FROM emp
WHERE deptno=10 OR deptno=30;

SELECT empno, ename, sal,deptno
FROM emp
WHERE deptno IN(10,30);
