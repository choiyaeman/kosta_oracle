SELECT empno, sal
FROM emp;

SELECT * --프로젝션
FROM emp; --셀렉션
----------------
--컬럼별칭주기
SELECT empno 사번, ename, sal 급여
FROM emp;

SELECT empno "사원 번호", ename, sal 급여
FROM emp;

SELECT empno AS "사원 번호", ename, sal AS 급여
FROM emp;
---------------------------------
--컬럼값 결합연산자 ||
SELECT empno || ename || sal
FROM emp;

SELECT empno || ename || sal "사번과 이름과 급여"
FROM emp;

--SQL의 문자열리터럴, 날짜리터럴은 '를 사용한다 ex) 'hello', '21/05/07'
SELECT empno ||'-'|| ename ||'-'|| sal "사번과 이름과 급여"
FROM emp;
------------------------------------
--산술연산자 : +, -, *, /
--나머지값구하는 함수: MOD()
SELECT empno, MOD(empno, 2), ename, sal,  sal*12
FROM emp;
--------------------------
--중복값 제거
SELECT DEPTNO
FROM emp; --14건

SELECT DISTINCT deptno
FROM emp; --3건
----------------------
--정렬하기
SELECT empno, ename, sal
FROM emp
ORDER BY sal DESC, ename ASC; --급여가 많은 순서대로 출력한다
                              --단, 급여가 같으면 이름을 사전순으로 출력한다
-----------------------------------------------
SELECT구문 처리 순서: 
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
--ORDER BY에서 별칭사용가능
SELECT empno, ename, sal "급여"
FROM emp
ORDER BY 급여 DESC, ename;
--ORDER BY에서 프로젝션에 참여하지 않은 컬럼사용가능
SELECT empno, ename
FROM emp
ORDER BY sal DESC;

--ORDER BY에서 프로젝션에 참여한 컬럼순번을 사용가능
SELECT empno, ename, sal
FROM emp
ORDER BY 3 DESC;
--------------------------------------------
--WHERE절 : 조건에 만족하는 행을 셀렉션
--비교연산자 : >, >=, <, <=, =
--논리연산자 : AND, OR, NOT

--급여가 1250인 사원의 사번,이름,급여를 출력하시오
SELECT empno, ename, sal
FROM emp
WHERE sal = 1250;

--급여가 1250보다 많은 사원의 사번,이름,급여를 출력하시오. 단 급여가 많은 사원부터 출력한다
SELECT empno, ename, sal
FROM emp
WHERE sal > 1250
ORDER BY sal DESC;

--급여가 1500이상 3000이하인 모든 사원의 사번,이름,급여를 출력하세요. 
--단 급여가 많은 사원부터 출력한다
SELECT empno, ename, sal
FROM emp
WHERE sal >= 1500 AND sal <= 3000
ORDER BY sal DESC;

SELECT empno, ename, sal
FROM emp
WHERE sal BETWEEN 1500 AND 3000
ORDER BY sal DESC;


--급여가 1500미만 3000초과인 모든 사원의 사번,이름,급여를 출력하세요. 
--단 급여가 많은 사원부터 출력한다
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
--부서번호가 10, 30번인 사원의 사번,이름, 급여, 부서번호를 출력하시오
SELECT empno, ename, sal,deptno
FROM emp
WHERE deptno=10 OR deptno=30;

SELECT empno, ename, sal,deptno
FROM emp
WHERE deptno IN(10,30);
