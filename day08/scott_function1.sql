--홀짝을 판별하는 함수생성하기
CREATE OR REPLACE FUNCTION fun_evenodd(num number)
RETURN varchar2
IS
BEGIN
   IF MOD(num, 2) = 0 THEN
      RETURN '짝수';
   ELSE
      RETURN '홀수';
   END IF;
END;

SELECT fun_evenodd(127), fun_evenodd(12)
FROM dual;

--페이지에 해당하는 시작행을 반환하는 함수 : fun_start_row
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
     RAISE_APPLICATION_ERROR(-20001, '페이지는 1이상이어야합니다');     
END;

--페이지에 해당하는 끝행을 반환하는 함수 : fun_end_row
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
     RAISE_APPLICATION_ERROR(-20001, '페이지는 1이상이어야합니다');     
END;

--전체행 검색해보기
SELECT *
FROM emp
ORDER BY sal;

--페이지별 5행씩 검색되는 2페이지에 해당하는 사원들 출력하기
SELECT *
FROM (SELECT rownum rno, a.*
          FROM (SELECT *
                    FROM emp
                    ORDER BY sal ) a)
WHERE rno BETWEEN fun_start_row(2, 5)  AND fun_end_row(2, 5);


-- 옳지 않은 페이지에 해당하는 사원들 출력하기
SELECT *
FROM (SELECT rownum rno, a.*
          FROM (SELECT *
                    FROM emp
                    ORDER BY sal ) a)
WHERE rno BETWEEN fun_start_row(-1, 5)  AND fun_end_row(-1, 5);