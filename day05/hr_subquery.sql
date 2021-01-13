--서브쿼리의 종류
행기준
   단일행서브쿼리
   다중행서브쿼리 IN, ANY, ALL, EXISTS

위치기준
   서브쿼리 (WHERE)
   인라인뷰 (FROM)
   스칼라쿼리(SELECT)

상호연관서브쿼리
---------------------------------
인라인뷰
--사원의 사번, 입사일, 급여를 출력하시오
SELECT employee_id, hire_date, salary
FROM employees;
 
--오라클제공 의사컬럼 : rownum -행번호
SELECT rownum, employee_id, hire_date, salary
FROM employees;
 
--사원의 행번호, 사번, 입사일, 급여를 출력하시오. 급여가 많은 사원부터 출력하시오
SELECT rownum, employee_id, hire_date, salary
FROM employees
ORDER BY salary DESC;

--SELECT처리순서 : FROM -> WHERE-> GROUP BY -> HAVING -> SELECT -> ORDER BY
--사원의 사번, 입사일, 급여를 출력하시오. 급여가 많은 사원부터 출력하시오
--행번호는 급여많은 순서대로 1씩증가한다(정렬후 행번호발급)
SELECT rownum,  emps.*
FROM (SELECT employee_id, hire_date, salary
          FROM employees
          ORDER BY salary DESC) emps;

--사원의 사번, 입사일, 급여를 출력하시오. 급여가 많은 사원부터 출력하시오
--행번호는 급여많은 순서대로 1씩증가한다(정렬후 행번호발급)
--행번호가 1~10인 사원들을 출력하시오
SELECT rownum,  emps.*
FROM (SELECT employee_id, hire_date, salary
          FROM employees
          ORDER BY salary DESC) emps
WHERE rownum BETWEEN 1 AND 10;

--행번호가 11~20인 사원들을 출력하시오
SELECT rownum,  emps.*
FROM (SELECT employee_id, hire_date, salary
          FROM employees
          ORDER BY salary DESC) emps
WHERE rownum BETWEEN 11 AND 20; --???

SELECT *
FROM (SELECT rownum rno, emps.*
          FROM (SELECT employee_id, hire_date, salary
                    FROM employees
                    ORDER BY salary DESC) emps)
WHERE  rno BETWEEN 21 AND 30;
-------------------------------------------------------------------
--스칼라쿼리
--사원의 사번, 급여, 부서번호, 부서명을 출력하시오
SELECT employee_id, salary, department_id,
         (SELECT department_name 
          FROM departments 
          WHERE department_id=employees.department_id)
FROM employees;
---------------------------------------------------------------------
--111번사원의 급여보다 많은 급여를 받는 
--같은부서의 사원사번, 급여, 부서번호를 출력하시오
SELECT employee_id, salary, department_id
FROM employees 
WHERE (department_id, salary) > (SELECT department_id, salary 
                        FROM employees 
                        WHERE employee_id=111);  (X)

--상호연관서브쿼리
SELECT employee_id, salary, department_id
FROM employees e
WHERE salary> (SELECT salary 
                        FROM employees e111
                        WHERE employee_id=111
                        AND e.department_id = e111.department_id
                      ); 
-----------------------------------------
--EXISTS연산자
--사원이 있는 부서들을 출력하시오
SELECT *
FROM departments                      
WHERE  EXISTS 
      (SELECT department_id
       FROM employees 
       WHERE department_id = departments.department_id); 

--사원이 없는 부서들을 출력하시오
SELECT *
FROM departments                      
WHERE  NOT EXISTS 
      (SELECT department_id
       FROM employees 
       WHERE department_id = departments.department_id); 
------------------------------------------------------
--NULL값을 갖는 SUBQUERY
--짝수번 사원의 부서번호와 부서명을 출력하시오
SELECT department_id, department_name
FROM  departments 
WHERE  department_id
             IN (SELECT DISTINCT department_id  --NULL포함
                  FROM employees 
                  WHERE MOD(employee_id,2) = 0 );

--짝수번 사원이 근무하지 않는 부서를 출력하시오
SELECT department_id, department_name
FROM  departments 
WHERE  department_id
             NOT IN (SELECT DISTINCT department_id  --NULL포함
                  FROM employees 
                  WHERE MOD(employee_id,2) = 0 ); --0건 결과

SELECT department_id, department_name
FROM  departments 
WHERE  department_id
             NOT IN (SELECT DISTINCT NVL(department_id, 0)  --NULL포함
                  FROM employees 
                  WHERE MOD(employee_id,2) = 0 );