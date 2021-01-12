SELECT empno FROM emp; --14��(�����)
SELECT deptno FROM dept; --4��(�μ�)

--����Ŭ ���� ǥ���
SELECT empno, ename, emp.deptno, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI ǥ�� ���� ǥ���
SELECT  empno, ename, emp.deptno, dname, loc
FROM emp JOIN dept ON emp.deptno = dept.deptno;

SELECT empno, ename, deptno, dname, loc --���̺� ���� ��Ī�� ���� �ʴ´�. �� ���̺��� ������ �̸��� �÷��� ������ ON���� ���� ȿ���� �ش�.
FROM emp NATURAL JOIN dept;

SELECT empno, ename, deptno, dname, loc 
FROM emp JOIN dept USING(deptno);