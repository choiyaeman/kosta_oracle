--오라클에서 지원하는 함수
--문자함수
SELECT ename, LENGTH(ename)
FROM emp;

--테스트용도의 테이블 : dual테이블
SELECT LENGTH('오문정'), 
       INSTR('ABCABC', 'B'), INSTR('ABCABC', 'X'),
       SUBSTR('ABCABC', 2, 3)       
FROM dual;

--FROM emp;

--사원의 이름중 4번째 문자가 'E'를 포함하는 사원의 사번, 이름을 출력하시오. 단 이름을 사전순으로 출력한다
--1)LIKE 연산자사용
SELECT empno, ename
FROM emp
WHERE ename LIKE '___E%'
ORDER BY ename;

--2)INSTR함수사용
SELECT empno, ename
FROM emp
WHERE  INSTR(ename, 'E') = 4
ORDER BY ename;

--3)SUBSTR함수사용
SELECT empno, ename
FROM emp
WHERE SUBSTR(ename, 4, 1) = 'E'
ORDER BY ename;

----------------------------------------------------------------
--숫자함수
각 사원의 급여, 수당, 실급여를 출력하시오. 실급여는 급여+수당
SELECT sal, comm, sal+comm
FROM emp;

--NULL관련함수
--NVL()
SELECT sal, comm, sal+NVL(comm, 0)
FROM emp;

각 사원의 급여, 수당, 실급여를 출력하시오. 
단, 실급여는 총10자리로 표현하되 앞에 빈공간은 #으로 채운다
예) 실급여가 2850인 경우  ######2850로 출력된다
SELECT sal, comm, LPAD(sal+NVL(comm, 0), 10, '#')
FROM emp;

--날짜함수
--오늘날짜, 어제, 내일날짜를 출력하시오
SELECT  SYSDATE, SYSDATE-1, SYSDATE+1
FROM  dual;

--오늘날짜기준 3개월후, 3개월전의 날짜를 출력하시오
SELECT SYSDATE,  ADD_MONTHS(SYSDATE, 3)
         , ADD_MONTHS(SYSDATE, -3)
FROM dual;

--'20/12/08'일부터 오늘까지의 일수를 출력하시오
--문자('20/12/08')를 날짜로 자료형변환이 필요! : TO_DATE()
SELECT SYSDATE,   SYSDATE-TO_DATE('20/12/08')
FROM dual;

--사원의 입사일, 근무일수, 근무개월수를 출력하시오
--출력결과에 소수점이하자리는 버린다

SELECT hiredate
         , TRUNC(SYSDATE-hiredate) 근무일수
         , TRUNC(MONTHS_BETWEEN( SYSDATE,hiredate)) 근무개월수
FROM emp;

--돌아오는 토요일의 날짜를 출력하시오
SELECT NEXT_DAY(SYSDATE, '토')
FROM dual;

--이달의 마지막일자와 다음달의 마지막일자를 출력하시오
SELECT LAST_DAY(SYSDATE)
         , LAST_DAY(ADD_MONTHS(SYSDATE, 1)) 
         , LAST_DAY(TO_DATE('21/02/01'))
FROM dual;
--------------------------------------------------------------------------
자동형변환
SELECT 1+'1', 1 || '1'
FROM dual;

SELECT empno, hiredate
FROM emp
WHERE hiredate BETWEEN '82/01/01' AND '82/12/31';

강제형변환 함수

    날짜형<--TO_DATE() --문자형 --TO_NUMBER()--> 숫자형
             -- TO_CHAR()-->         <--TO_CHAR() --

숫자->문자 TO_CHAR()
SELECT 1234567890,
           TO_CHAR(1234567890, '999,999,999,999,999'),
           TO_CHAR(1234567890, '9,999'),
           TO_CHAR(1234567890, 'L999,999,999,999,999'),
           TO_CHAR(1234567890, '000,000,000,000')
FROM  dual;

--각 사원의 급여, 수당, 실급여를 출력하시오. 실급여는 급여+수당
실급여는 3자리마다 ,를 출력한다
SELECT sal, comm, TO_CHAR(sal+NVL(comm, 0), '9,999,999')
FROM emp;
-------------------------
문자->숫자 TO_NUMBER()
SELECT  TO_NUMBER('123'),  TO_NUMBER('1,234', '9,999')
FROM dual;
-------------------------
날짜->문자 TO_CHAR()
SELECT  TO_CHAR(SYSDATE, 'YYYY'),
             TO_CHAR(SYSDATE, 'MM-DD HH24:MI:SS DAY')
FROM dual;
--21년 12월 25일의 요일을 출력하시오
SELECT TO_CHAR(TO_DATE('21/12/25'), 'DAY')
FROM dual; 
---------------------------------------------------------------
NULL관련함수: NVL(컬럼, 변환값), NVL2(컬럼 ,null아닌경우변환값,null인경우 변환값)
--수당을 받는 사원은 수당을 출력하고
--수당을 안받는 사원은 0을 출력하시오
SELECT empno, comm,  NVL(comm, 0)  FROM emp;

--수당을 받는 사원은 '수당받음'을 출력하고
--수당을 안받는 사원은 '수당안받음'을 출력하시오
SELECT empno, comm,  NVL2(comm, '수당받음', '수당안받음') FROM emp;

--수당을 받는 사원은 '수당받음'과 수당값을 출력하고 ex) 수당받음1500
--수당을 안받는 사원은 '수당안받음'을 출력하시오
SELECT empno, comm,  NVL2(comm, '수당받음'||comm, '수당안받음') 수당여부 FROM emp;

--수당순으로 정렬하시오
SELECT empno, comm
FROM emp
ORDER BY comm ASC;
---------------------------------
IF~ELSE와 같은 효과 : DECODE(), CASE절:표준
--사원중 직무가 MANAGER인 사원은 급여를 10%증가하여 출력하고
             직무가 SALEMAN인 사원은 급여를 50%증가하여 출력하시오
SELECT empno, job, sal, DECODE(job, 'MANAGER', sal*1.1, 'SALESMAN', sal*1.5, sal) 예상급여인상
FROM  emp;

SELECT empno, job, sal,
           CASE job WHEN 'MANAGER'  THEN sal*1.1
                         WHEN 'SALESMAN' THEN sal*1.5
                         ELSE sal
           END   예상급여인상           
FROM emp;

--사원의 급여가 3000이상이면 'A'등급, 1000이상이면 'B'등급, 그외이면 'C'등급으로 출력하시오
SELECT empno, sal,
           CASE WHEN sal >= 3000 THEN 'A'
                   WHEN sal >= 1000 THEN 'B'
                   ELSE 'C'
           END 급여등급
FROM emp;
------------------------------------------------------------------------------------------
다중행함수 : SUM(), AVG(), COUNT(), MAX(), MIN(), STDDEV() 
--사원들의 총사원수, 수당을 받는 사원수,
               총급여, 평균급여, 최대급여값, 최소급여값을 출력하시오
SELECT  COUNT(empno),  COUNT(comm), --NULL값제외하고 행수를 계산
            COUNT(*), --NULL값포함하여 행수를 계산
            SUM(sal),  AVG(sal), MAX(sal), MIN(sal)
FROM emp;
-------------------------------------------------------------------------------------------
그룹처리 : GROUP BY
               입사일자별 사원수를 출력하시오.
               부서별 부서번호, 총급여를 출력하시오
               직무별 최대급여를 출력하시오
SELECT  hiredate, COUNT(*)
FROM emp
GROUP BY hiredate
ORDER BY hiredate;

DESC emp;

--부서별 사원수, 총급여, 최대/최소급여, 평균급여를 출력하시오
SELECT deptno, COUNT(*), SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM emp
GROUP BY deptno;

--GROUP BY는 UNION과 같다--
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

--입사년도별 입사년도,입사자수를 출력하시오
SELECT TO_CHAR(hiredate, 'YY') 입사년도, COUNT(*) 입사자수
FROM emp
GROUP BY TO_CHAR(hiredate, 'YY');


SELECT SUBSTR(TO_CHAR(hiredate, 'YY'), 1, 2) 입사년도, COUNT(*) 입사자수
FROM emp
GROUP BY SUBSTR(TO_CHAR(hiredate, 'YY'), 1, 2);

--입사월별 입사월, 입사자수를 출력하시오. 1월부터 차례로 출력하시오. 
                                                           단 1월이 01이 아니라 1월로 출력
                                                                2      02가 아니라 2월로 출력
                                                                3       03이          3월 "       
SELECT TO_CHAR(hiredate, 'MM') 입사월, COUNT(*)
FROM emp
GROUP BY TO_CHAR(hiredate, 'MM')
ORDER BY 입사월;

SELECT TO_NUMBER(TO_CHAR(hiredate, 'MM')) || '월' 입사월, COUNT(*)
FROM emp
GROUP BY TO_NUMBER(TO_CHAR(hiredate, 'MM'))
ORDER BY TO_NUMBER(TO_CHAR(hiredate, 'MM'));
--정렬시 문자열 오름차순정렬: 1월, 10월, 11월, 12월, 2월
--          숫자 오름차순정렬:  1, 2, 3, 4, 10, 11, 12
----------------------------------------------------------------------

조건절 : WHERE - 일반조건
            HAVING - GROUP BY에 대한 조건

--급여가 2000이상인 사원의 부서별 사원수를 출력하시오
SELECT deptno, COUNT(*)
FROM emp
WHERE sal>=2000
GROUP BY deptno;

--부서별 평균급여가 2000이상인 부서들의 사원수를 출력하시오
SELECT deptno, COUNT(*), AVG(sal)
FROM emp
GROUP BY deptno
HAVING  AVG(sal) >= 2000;
---------------------------------------------------------------------------













