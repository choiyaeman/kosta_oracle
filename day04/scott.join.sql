SELECT empno FROM emp; --14건(사원수)
SELECT deptno FROM dept; --4건(부서)

--오라클 전용 표기법
SELECT empno, ename, emp.deptno, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI 표준 조인 표기법
SELECT  empno, ename, emp.deptno, dname, loc
FROM emp JOIN dept ON emp.deptno = dept.deptno;

SELECT empno, ename, deptno, dname, loc --테이블에 대한 별칭을 쓰지 않는다. 두 테이블의 동일한 이름의 컬럼이 있으면 ON절의 같은 효과를 준다.
FROM emp NATURAL JOIN dept;

SELECT empno, ename, deptno, dname, loc 
FROM emp JOIN dept USING(deptno);