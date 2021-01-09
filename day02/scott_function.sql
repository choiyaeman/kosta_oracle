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


--숫자함수
--날짜함수