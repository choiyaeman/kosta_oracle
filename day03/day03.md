# day03

### **단일행 함수**

: 행 하나 별로 처리돼서 행 별로 결과를 반환하는 함수

### **다중행 함수**

: 여러 행이 입력되어 하나의 행으로 결과를 반환 되는 함수

> **대 소문자를 바꿔주는 Upper, LOWER, INITCAP함수**

UPPER(문자열) : 괄호 안 문자 데이터를 모두 대문자로 변환하여 반환

LOWER(문자열) : 괄호 안 문자 데이터를 모두 소문자로 변환하여 반환

INITCAP(문자열) : 괄호 안 문자 데이터 중 첫 글자는 대문자로, 나머지 문자를 소문자로 변환 후 반환

> **문자열 길이를 구하는 LENGTH함수**

특정 문자열의 길이를 구할 때 LENGTH함수를 사용

> **문자열 일부를 추출하는 SUBSTR함수**

SUBSTR(문자열 데이터, 시작위치, 추출길이)

SUBSTR(문자열 데이터, 시작위치)

> **문자열 데이터 안에서 특정 문자 위치를 찾는 INSTR함수**

INSTR([대상 문자열 데이터(필수)], 

[위치를 찾으려는 부분 문자(필수)], 

[위치를 찾기를 시작할 대상 문자열 데이터 위치(선택, 기본값은 1)], 

[시작 위치에서 찾으려는 문자가 몇 번째인지 지정(선택, 기본값은 1)])

> **특정 문자를 다른 문자로 바꾸는 REPLACE 함수**

REPLACE([문자열 데이터 또는 열 이름(필수)], [찾는 문자(필수)], [대체할 문자(선택)])

REPLACE, TRANSLATE 모두 치환 용 함수이다.

> **데이터의 빈공간을 특정 문자로 채우는 LPAD, RPAD 함수**

LPAD([문자열 데이터 또는 열이름(필수)], [데이터의 자릿수(필수)], [빈 공간에 채울 문자(선택)])

RPAD([문자열 데이터 또는 열이름(필수)], [데이터의 자릿수(필수)], [빈 공간에 채울 문자(선택)])

LPAD는 왼쪽에 데이터의 빈 공간을 특정 문자를 채워라 

RPAD는 오른쪽에 데이터의 빈 공간을 특정 문자를 채워라 

> **두 문자열 데이터를 합치는 CONCAT함수**

두 개의 문자열 데이터를 하나의 데이터로 연결해 주는 역할

> **특정 문자를 지우는 TRIM, LTRIM, RTRIM함수**

TRIM([삭제 옵션(선택)] [삭제할 문자(선택)] FROM [원본 문자열 데이터(필수)])

LEADING [삭제할 문자] FROM [원본 문자열 데이터(필수)] 은 왼쪽에 있는 특정 문자를 제거

TRAILING  [삭제할 문자 FROM [원본 문자열 데이터(필수)] 은 오른쪽에 있는 특정 문자를 제거

BOTH  [삭제할 문자] FROM [원본 문자열 데이터(필수)] 은 양쪽에 있는 특정 문자를 제거

> **특정 위치에서 반올림하는 ROUND함수**

ROUND([숫자(필수)], [반올림 위치(선택)])

> **특정 위치에서 버리는 TRUNC 함수**

TRUNC([숫자(필수)], [버림 위치(선택)])

> **지정한 숫자와 가까운 정수를 찾는 CEIL, FLOOR 함수**

각각 입력된 숫자와 가까운 큰 정수, 작은 정수를 반환하는 함수

CEIL([숫자(필수)])

FLOOR([숫자(필수)])

> **숫자를 나눈 나머지 값을 구하는 MOD함수**

MOD([나눗셈 될 숫자(필수)], [나눌 숫자(필수)])

> **날짜 데이터를 다루는 날짜 함수 SYSDATE함수**

날짜 데이터 + 숫자 : 날짜 데이터보다 숫자만큼 일수 이후의 날짜

날짜 데이터 - 숫자 : 날짜 데이터보다 숫자만큼 일수 이전의 날짜

날짜 데이터 - 날짜 데이터 : 두 날짜 데이터 간의 일수 차이

날짜 데이터 + 날짜 데이터 : 연산 불가, 지원(x)

> **몇 개월 이후 날짜를 구하는 ADD_MONTHS함수**

ADD_MONTHS([날짜 데이터(필수)], [더할 개월 수(정수)(필수)])

> **두 날짜 간의 개월 수 차이를 구하는 MONTHS_BETWEEN 함수**

MONTHS_BETWEEN([날짜 데이터1(필수)], [날짜 데이터2(필수)]

> **돌아오는 요일, 달의 마지막 날짜를 구하는 NEXT_DAY, LAST_DAY함수**

NEXT_DAY([날짜 데이터(필수)], [요일 문자(필수)]) 

LAST_DAY(날짜 데이터(필수)]) 

> **날짜의 반올림, 버림을 하는 ROUND, TRUNC함수**

ROUND([날짜데이터(필수)], [반올림 기준 포맷])

TRUNC([날짜데이터(필수)], [버림 기준 포맷])

Oracle에서는 MM : 월, MI : 분 의미한다.

```sql
--오라클에서 지원하는 함수
--문자함수
SELECT ename, LENGTH(ename)
FROM emp;

--테스트용도의 테이블 : dual테이블
SELECT LENGTH('최예만'), 
    INSTR('ABCABC', 'B'), INSTR('ABCABC', 'X'), --INSTR(찾을 대상 문자열, 찾을 문자) 처음 위치 인덱스값을 반환한다. B라는 문자가 있는 곳은 인덱스 2번이다 라는 의미. 없는 문자를 찾을경우 
    SUBSTR('ABCABC',2,3) --2번 인덱스부터 3개 문자열을 가져와라
FROM dual; --문자열 길이를 반환 해준다 
--FROM emp; --emp 테이블로 결과를 본다하면 최예만이라는 문자열길이가 3인데 14개만큼 출력된다는 거다. 그럴필요없으니 dual테이블을 이용하여 한개의 테이블만 반환하자!

--사원의 이름중 4번째 문자가 'E'를 포함하는 사원의 사번, 이름을 출력하시오. 단 이름을 사전순으로 출력한다.
--1)LIKE연산자 사용
SELECT empno, ename
FROM emp
WHERE ename LIKE '___E%'
ORDER BY ename;

--2)INSTR함수 사용
SELECT empno, ename
FROM emp
WHERE INSTR(ename, 'E') = 4
ORDER BY ename;

--3)SUBSTR함수 사용
SELECT empno, ename
FROM emp
WHERE SUBSTR(ename, 4, 1) = 'E' -- 4번째 인덱스부터 한개인 문자가 E인
ORDER BY ename;

--숫자함수
--각 사원의 급여, 수당, 실급여를 출력하시오. 실급여는 급여+수당 
SELECT sal, comm, sal+comm  --oracle에서는 null값과 연산을 하면 무조건 null이 반환된다
FROM emp;

--NULL관련함수
--NVL()
SELECT sal, comm, sal+NVL(comm, 0) --컬럼을 0으로 변환해라
FROM emp;

--각 사원의 급여, 수당, 실급여를 출력하시오.
--단, 실급여는 총 10자리로 표현하되 앞에 빈공간은  #으로 채운다
--예) 실급여가 2850인 경우 ######2850로 출력된다
SELECT sal,comm, LPAD(2850, 10, '#')
FROM emp;

--날짜함수
--오늘 날짜를 출력하시오
SELECT SYSDATE, SYSDATE-1, SYSDATE+1
FROM dual;

--오늘날짜기준 3개월후, 3개월전의 날짜를 출력하시오
SELECT SYSDATE, ADD_MONTHS(SYSDATE, 3), ADD_MONTHS(SYSDATE, -3)
FROM dual;

--'20/12/08'일부터 오늘까지의 일수를 출력하시오
--날짜-날짜(SYSDATE-'20/12/08') -> oracle엔진이 '열고 닫고를 문자 자료형으로 이해한다. 오늘 날짜 - 문자 로 이해하므로 오류가 발생!
--문자를 날짜로 자료형 변환이 필요! : TO_DATE()
--결과값에 나오는 .은 시간값(시분초)을 의미한다.
SELECT SYSDATE, SYSDATE-TO_DATE('20/12/08')
FROM dual;

--사원의 입사일, 근무일수, 근무개월수를 출력하시오
--출력결과에 소수점이하자리는 버린다.
--hiredate컬럼 자체가 날짜 데이터 타입이므로 날짜-날짜가 가능하다.
SELECT hiredate, 
    TRUNC(SYSDATE-hiredate) AS 근무일수, 
    TRUNC(MONTHS_BETWEEN(SYSDATE,hiredate)) 근무개월수
FROM emp;

--돌아오는 토요일의 날짜를 출력하시오
SELECT NEXT_DAY(SYSDATE, '토')
FROM dual;

--이달의 마지막일자와 다음달의 마지막일자를 출력하시오
-- '열고닫고 표기하는것은 문자타입으로 이해하고 날짜타입으로 변환하고싶으면 무조건 TO_DATE 써줘라
SELECT LAST_DAY(SYSDATE), 
    LAST_DAY(ADD_MONTHS(SYSDATE,1)),
    LAST_DAY(TO_DATE('21/02/01'))
FROM dual;

--자동형변환 
--숫자 + 문자열(숫자) -> 문자가 숫자로 변환
SELECT 1 + '1', 1 || '1'
FROM dual;

SELECT empno, hiredate
FROM emp
WHERE hiredate BETWEEN '82/01/01' AND '82/12/31'; --문자형이 날짜형으로 자동형변환되서 WHERE조건에 처리       

--강제형변환 함수
-- 날짜형 <--TO_DATE()-- 문자형 --TO_NUMBER()-->숫자형
--        --TO_CHAR()-->      <--TO_CHAR()--

--숫자를 문자로 반환하는 TO_CHAR()
SELECT 1234567890,
    TO_CHAR(1234567890, '999,999,999,999'),
    TO_CHAR(1234567890, '9,999'), --#이라는 결과가 출력. 주의)숫자보다 작은 표현 패턴값이면 숫자가 문자로 변환할때 #으로 변환되고 끝난다. 패턴의 자리수를 여유있게 지정 해줘야한다.
    TO_CHAR(1234567890, 'L999,999,999,999'), --L은 \ 기호를 표시.
    TO_CHAR(1234567890, '000,000,000,000') --빈자리수를 0으로 채운다.
FROM dual;

--각 사원의 급여, 수당, 실급여를 출력하시오. 실급여는 급여+수당 
--실급여는 3자리마다,를 출력한다
SELECT sal, comm, TO_CHAR(sal+NVL(comm,0),'9,999,999')
FROM emp;
---------------
문자->숫자 TO_NUMBER()
SELECT TO_NUMBER('123'), TO_NUMBER('1,234', '9,999')
FROM dual;
---------------
날짜->문자 TO_CHAR()
SELECT TO_CHAR(SYSDATE, 'YYYY'), --년도값만 패턴 지정하고싶을때
    TO_CHAR(SYSDATE, 'MM-DD HH24:MI:SS DAY') --월일시분초요일 패턴 지정하고싶을때
FROM dual;

--21년 12월 25일의 요일을 출력하시오
SELECT TO_CHAR(TO_DATE('21/12/25'), 'DAY')
FROM dual;
-----------------------------------------------------------------------
NULL관련함수: NVL(컬럼, 변환값), NVL2(컬럼,null아닌경우 변환값,null인경우 변환값)
--수당을 받는 사원은 수당을 출력하고
--수당을 안받는 사원은 0을 출력하시오
SELECT empno, comm, NVL(comm, 0) FROM emp;

--수당을 받는 사원은 '수당받음'을 출력하고
--수당을 안받는 사원은 '수당안받음'을 출력하시오
SELECT empno, comm, NVL2(comm, '수당받음', '수당안받음') FROM emp;

--수당을 받는 사원은 '수당받음'과 수당값을 출력하고 ex) 수당받음1500
--수당을 안받는 사원은 '수당안받음'을 출력하시오
SELECT empno, comm, NVL2(comm, '수당받음'||comm, '수당안받음') 수당여부 FROM emp;

--수당순으로 정렬하시오
SELECT empno, comm
FROM emp
ORDER BY comm ASC;
--------------------------------
IF~ELSE와 같은 효과 : DECODE(), CASE절 -> 둘의 차이점은 하나는 함수, 하나는 문법(표준화된 문법)
--사원중 직무가 MANAGER인 사원은 급여를 10%증가하여 출력하고
--       직무가 SALEMAN인 사원은 급여를 50%증가하여 출력하시오.
SELECT empno, job, sal, DECODE(job, 'MANAGER', sal*1.1, 'SALESMAN', sal*1.5, sal) 예상급여인상 -- 마지막 최종 else 그 외의 경우는 sal값을 출력
FROM emp;

SELECT empno, job, sal,
    CASE job WHEN 'MANAGER' THEN sal*1.1
             WHEN 'SALESMAN'THEN sal*1.5
             ELSE sal --그 외의 경우는 sal값으로 채워라
    END 예상급여인상
FROM emp;

--사원의 급여가 3000이상이면 'A'등급, 1000이상이면 'B'등갑, 그외이면 'C'등급으로 출력하시오.
SELECT empno, sal,
    CASE WHEN sal>=3000 THEN 'A'
         WHEN sal>=1000 THEN 'B'
         ELSE 'C'
    END 급여등급
FROM emp;
---------------------------------------------------------------------------------------------------
다중행함수 : SUM(), AVG(),COUNT(), MAX(), MIN(), STDDEV()  --STDDEV() -> 표준편차함수
--사원들의 총 사원수, 수당을 받는 사원수,
        총 급여, 평균급여, 최대 급여값,최소 급여값을 출력하시오
SELECT COUNT(empno), COUNT(comm), --NULL값을 제외하고 행수를 계산, 
    COUNT(*), --NULL값 포함하여 행수를 계산
    SUM(sal), AVG(sal), MAX(sal), MIN(sal)   
FROM emp;
---------------------------------------------------------------------------------------------------
그룹처리 : GROUP BY
          입사일자별 사원수를 출력하시오.
          부서별 부서번호, 총급여를 출력하시오.
          직무별 최대급여를 출력하시오
SELECT hiredate, COUNT(*)  --다중행함수를select절에서 사용할때 groupby절에서 사용한 컬럼과 같이 사용할 수 있다. 그러나 SLECCT empno, Count(*) FROM emp  GROUP BY hiredate; (x) : hiredate컬럼 그룹핑한것을 empno랑 컬럼이랑 다중행 함수랑 같이쓰면 error발생!
FROM emp
GROUP BY hiredate --입사일자별로 묶음처리
ORDER BY hiredate;

DESC emp;
--부서별 사원수, 총급여, 최대/최소급여, 평균급여를 출력하시오.
SELECT  deptno, COUNT(*), SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM emp
GROUP BY deptno;

--GROUP BY는 UNION과 같다--
SELECT COUNT(*), SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM emp
WHERE deptno=10
UNION
SELECT COUNT(*), SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM emp
WHERE deptno=20
UNION
SELECT COUNT(*), SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM emp
WHERE deptno=30;

--입사년도별 입사년도, 입사자수를 출력하시오
SELECT TO_CHAR(hiredate, 'YY') 입사년도, COUNT(*) 입사자수
FROM emp
GROUP BY TO_CHAR(hiredate, 'YY');

SELECT SUBSTR(TO_CHAR(hiredate, 'YY'), 1, 2) 입사년도, COUNT(*) 입사자수
FROM emp
GROUP BY SUBSTR(TO_CHAR(hiredate, 'YY'), 1, 2); --문자 타입으로 바꾼뒤에 년도 두자리만 가져오기

--입사월별 입사월, 입사자수를 출력하시오. 1월부터 차례로 출력하시오. 
SELECT TO_CHAR(hiredate, 'MM') 입사월, COUNT(*) 입사자수
FROM emp 
GROUP BY TO_CHAR(hiredate, 'MM')
ORDER BY 입사월;

--입사월별 입사월, 입사자수를 출력하시오. 1월부터 차례로 출력하시오. 
--단 1월이 01이 아니라 1월로 출력
SELECT TO_NUMBER(TO_CHAR(hiredate, 'MM')) ||'월' 입사월, COUNT(*) 입사자수
FROM emp 
GROUP BY TO_NUMBER(TO_CHAR(hiredate, 'MM'))
ORDER BY TO_NUMBER(TO_CHAR(hiredate,'MM'));
--정렬시 문자열 오름차순정렬: 1월, 10월, 11월, 12월, 2월
--       숫자 오름차순정렬: 1, 2, 3, 4, 19, 11, 12
---------------------------------------------------------------------------------------------------
조건절 : WHERE - 일반조건
        HAVING - GROUP BY에 대한 조건
        
--급여가 2000이상인 사원의 부서별 사원수를 출력하시오. ->부서에대한 조건이 아닌 일반 사원들에 대한 조건 WHERE절로 설정
SELECT deptno, COUNT(*)
FROM emp
WHERE sal>=2000
GROUP BY deptno;

--부서별 평균급여가 2000이상인 부서들의 사원수를 출력하시오. ->부서별 즉 GROUP BY에 대한 조건이므로  HAVING절로 설정 해줘야한다.
SELECT deptno, COUNT(*), AVG(sal)
FROM emp
GROUP BY deptno
HAVING AVG(sal) >= 2000;
```

1,234,567,890 --하나의 컬럼씩으로 이해해버린다. oracle엔진에게 얘가 숫자 타입이 아니라 문자 타입을 알리기 위해 앞뒤에 '열고 닫고('1,234,567,890') 해줘야 한다.
오라클의 경우 정렬할 때 오름차순 시 null값은 뒤에 나오고 내림차순 시 null값은 앞에 나온다 
단일 행 함수는 행 별로 각각 처리되는 함수이며 다중 행 함수는 여러 행을 한번에 처리해주는 함수를 말한다. 다중 행 함수는 거의 대부분 집계 함수, 그룹 함수라 한다.