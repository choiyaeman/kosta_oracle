--사원의 사번, 이름, 급여, 직무ID, 부서ID를 출력하시오.
SELECT employee_id,
       first_name,
       salary,
       job_id,
       department_id
FROM employees;

--사원의 사번, 이름, 급여, 직무ID, 직무명, 부서ID를 출력하시오. --직무명이라는 JOBS테이블에 있다. --job_id가 EMPLOYEES, JOBS테이블에도 있으니 어느 테이블인지 별칭을 정확히 해줘야한다.
SELECT employee_id,
       first_name,
       salary,
       e.job_id,
       job_title,
       department_id
FROM employees e JOIN jobs j ON e.job_id = j.job_id; -- e, j는 별칭을 의미.

SELECT employee_id,
       first_name,
       salary,
       job_id,
       job_title,
       department_id
FROM employees NATURAL JOIN jobs; --실행하면 SELECT절에서 e.job_id에서 문제가 발생! 중복된 컬럼의 앞에 별칭점을 붙여야되는것이 join on절이나 natural은 별칭을 쓰면 안되고 공통 컬럼명을 노출해야한다.

--사원의 사번, 이름, 부서ID, 부서명을 출력하시오. JOIN-ON
SELECT employee_id,
       first_name,
       d.department_id, --d나 e 아무거나 써도 관계없다
       department_name
FROM employees e JOIN departments d ON e.department_id = d.department_id; --106명까지만 출력이 됨

--사원의 사번, 이름, 부서ID, 부서명을 출력하시오. NATURAL JOIN
SELECT employee_id,
       first_name,
       department_id,
       department_name
FROM employees NATURAL JOIN departments; --32명까지만 출력이 됨
--FROM employee e JOIN departmets d 
--ON e.department_id = d.department_id
--AND e.manager_id = d.mager_id;

--사원의 사번, 이름, 부서ID, 부서명을 출력하시오. USING
SELECT employee_id,
       first_name,
       department_id,
       department_name
FROM employees JOIN departments USING(department_id); --106명

--사원의 사번, 이름, 부서ID, 부서명, 직무ID, 직무명을 출력하시오 ****************
SELECT employee_id,
       first_name,
       e.department_id,
       department_name,
       j.job_id,
       job_title
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
                 JOIN jobs j ON (e.job_id = j.job_id);

--사원의 사번, 이름과 근무하는 부서명, 부서가 속한 도시명을 출력하시오.
SELECT employee_id,
       first_name,
       department_name,
       city
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
                 JOIN locations l ON (d.location_id = l.location_id);
                 
--사원의 사번, 이름과 근무하는 부서명, 부서가 속한 도시명을 출력하시오.
--도시명 순서대로, 같은 도시인 경우 부서명 순서대로 출력
SELECT employee_id,
       first_name,
       department_name,
       city
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
                 JOIN locations l ON (d.location_id = l.location_id)
ORDER BY city, department_name;

--홀수번 사번의 사원 대상으로
--사번, 이름과 근무하는 부서명, 부서가 속한 도시명을 출력하시오.
	--도시명 순서대로, 같은 도시인 경우 부서명 순서대로 출력
SELECT employee_id,
       first_name,
       department_name,
       city
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
                 JOIN locations l ON (d.location_id = l.location_id)
WHERE MOD(employee_id, 2)=1
ORDER BY city, department_name;

--부서별 부서명과 사원수, 총급여를 출력하시오
SELECT department_name, COUNT(*), SUM(salary)
FROM employees e JOIN departments d USING(department_id)
GROUP BY department_name;