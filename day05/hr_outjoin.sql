--사원들의 사번, 이름, 부서번호, 부서명을 출력하시오. 단, 부서가 없는 사원도 출력하시오
SELECT employee_id, first_name, e.department_id, department_name
FROM employees e  LEFT JOIN departments d ON (e.department_id = d.department_id)
ORDER BY employee_id;

SELECT employee_id, first_name, e.department_id, department_name
FROM employees e,   departments d
WHERE e.department_id = d.department_id(+)
ORDER BY employee_id;

--지역ID와 도시명을 출력하시오:23건
2000	Beijing
2100	Bombay
2200	Sydney
2300	Singapore
:
--부서ID와 지역ID를 출력하시오:27건
SELECT department_id, location_id
FROM departments;

--도시에 속한 부서명들을 출력하시오. :27건
SELECT city, department_name
FROM departments d JOIN locations l ON d.location_id = l.location_id;

--도시에 속한 부서명들을 출력하시오. 부서가 없는 도시도 출력하시오.:43건
SELECT city, department_name
FROM departments d RIGHT JOIN locations l ON d.location_id = l.location_id;

SELECT city, department_name
FROM departments d,  locations l
WHERE d.location_id(+) = l.location_id;

--부서번호와 부서명을 출력하시오:27건
220	NOC
230	IT Helpdesk
240	Government Sales
250	Retail Sales
260	Recruiting
270	Payroll

--사원의 사번, 이름, 부서번호, 부서명을 출력하시오. 
--단, 부서가 없는 사원도 모두 출력하고
--사원이 없는 부서도 모두 출력하시오
SELECT employee_id, d.department_id, department_name
FROM  employees e FULL OUTER JOIN departments d ON (e.department_id = d.department_id)
