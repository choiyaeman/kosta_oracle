# day04

> **ROLLUP(대그룹, 소그룹), CUBE(컬럼들에 대한 교차집계), GROUPING SETS 함수**

ROLLUP, CUBE, GROUPING SETS 함수는 GROUP BY절에 지정할 수 있는 특수 함수

ROLLUP함수와 CUBE 함수는 그룹화 데이터의 합계를 출력할 때 유용하게 사용

SELECT [조회할 열1 이름], [열2 이름], .., [열N 이름]

FROM [조회할 테이블 이름]

WHERE [조회할 행을 선별하는 조건식]

GROUP BY **ROLLUP** [그룹화 열 지정(여러 개 지정 가능)];

SELECT [조회할 열1 이름], [열2 이름], .., [열N 이름]

FROM [조회할 테이블 이름]

WHERE [조회할 행을 선별하는 조건식]

GROUP BY **CUBE** [그룹화 열 지정(여러 개 지정 가능)];

> **조인**

집합 vs 조인(컬럼을 결합)

집합 연산자를 사용한 결과는 두 개 이상의 SELECT문의 결과 값을 세로로 연결한 것이고, 조인을 사용한 결과는 두 개 이상의 테이블 데이터를 가로로 연결한 것이라고 볼 수 있다.

SELECT

FROM 테이블1, 테이블2

SELECT

FROM 테이블1 **JOIN** 테이블2  // 표준화된 JOIN표기법

- scott_join.sql

```sql
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
```

- hr_join.sql

```sql
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
```

![1](https://user-images.githubusercontent.com/63957819/104306918-eb92bf00-5511-11eb-8195-14b81bf908f1.png)

이 두 테이블의 자료를 JOIN을 시켜야 하는가?

사원의 사번, 부서 번호까지만 출력해라 하면 emp하나만 가지고 select를 할 수 있으나, 그 사원에 속해 있는 부서 명 까지 출력해라 하면 부서 명을 갖고 있는 테이블은 dept테이블이다. 한 테이블 자료만projection할게 아니라 여러 테이블 자료를 projection을 해야 함으로 JOIN을 해야 한다. 

FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY

emp, deptno 두 개의 테이블을 사용하겠다는 from절을 만들면 selection을 할거다라는 의미. emp테이블의 한 테이블의 한 행을 읽고 dept의 한 행을 읽는다.  그 한 행 읽은 다음에 아무런 조건이 없으므로 2번째 행, 3번째 행, 4번째 행을 다 읽고 없으면 emp테이블 첫 번째 행에서 두 번째 행으로 옮기고 dept도 두 번째 행으로 옮기고, 세 번째..이렇게 14번째 행까지 총 14*4 곱하기 결과가 나온다.

![2](https://user-images.githubusercontent.com/63957819/104306924-ecc3ec00-5511-11eb-9511-8c3887083579.png)

첫 번째 테이블의 같은 값을 가지는 두 번째 테이블 행을 찾아라 해서where절이 들어간다. 14개 행이 부서 번호를 찾는다.

JOIN할 때는 테이블의 관계를 미리 알아야 한다. SCOTT에는 총 4개의 테이블로 구성

EMP테이블은 사원, DEPT테이블은 부서, SALGRADE테이블은 급여 등급, BONUS테이블.

EMP테이블 컬럼을 보면 사원 이름, 직책, 관리자, 입사 일자, 급여, 수당, 사원이 속해있는 부서 번호가 있는데 이 부서 번호(PK)가 DEPT테이블의 부서 번호값이 참조가 되어 있을 거다.

DEPT테이블에 deptno(PK), dename, LOC 컬럼을 갖고 있다.

ERD는 엔터티들 사이에서 관계도를 그리는 다이어그램.

EMP테이블에 deptno(FK) 로 참조한다.  점선을 비식별자 관계라 읽는다.

이렇게 관계 설정되어 있어야 JOIN을 할 수 있다.

SALGRADE 테이블에서 참조x, 참조 관계는 EMP, DEPT만 되어있다. 서로 관계를 맺고 있으니 JOIN을 한 거다.  오라클 전용 조인 표기법과 ANSI 표준 조인 표기법을 쓸 수 있다. 여기서 ANSI표준 조인 표기법 쓰는 걸 권장한다.

조인에 대한 조건절은 =연산자를 쓴다. equlas를 따 eq조인 이라고 부른다.

JOIN ON 양쪽 테이블의 컬럼명이 서로 다를때 쓴다.

NATURAL JOIN 양쪽 테이블의 똑같은 컬럼이 있으면 무조건 on절을 쓰는 것과 같은 효과를 준다. 근데 위험하다. 양쪽 테이블의 똑같은 컬럼이 있다해도 그 테이블이 join절에 참여하지 않을 수도 있다

USING절을 줘서 양쪽 테이블의 같은 컬럼명중 같은 이름이 같은 특정 컬럼만 JOIN에 참여 시키겠다.

![3](https://user-images.githubusercontent.com/63957819/104306927-ed5c8280-5511-11eb-873a-e1f368a485ff.png)

DEPARTMENTS에  MANAGER_ID는 부서장을의미하는매니저 아이디이다.

부모의 PK 컬럼을 자식의 일반 컬럼으로 참조하는 것을 비식별자관계라한다.

DEPARTMENTS테이블의 컬럼 MANAGER_ID는 자식 EMPLOYEES테이블의 컬럼 EMPLOYEE_ID는 부모 비식별자 관계. 

DEPARTMESTS테이블은 부모, 자식의 역할을 할 수 있다.

![4](https://user-images.githubusercontent.com/63957819/104306929-edf51900-5511-11eb-83a4-84bdd23a5d52.png)

EMPLOYEES 테이블의 DEPARTMENT_ID, MANGER_ID와 DEPARTMENTS 테이블의 DEPARTMENT_ID, MANGER_ID는 서로 컬럼이 같아도 다른 의미로 쓰인다.

이 두 테이블 NATURAL JOIN에 참여하면 컬럼명이 같은 두 컬럼들이 ON절에 표기된 것과 같은 효과

다. 컬럼명이 두 개 이상 같을 때는 NATURAL JOIN하면 안된다. 오로지 컬럼명이 한 개만 같을 때 사용.

JOIN절은 FROM절의 세부 항목이라 보면 된다.  

오라클 엔진이 departments, employees 테이블중 어느 테이블이 먼저 읽혀야 될지는 최적화를 따져봐서 결정을 한다. 일단 참여한 테이블을 한 행 한 행 읽어가면서 join조건에 만족하는 것만 행들만 취해 올 거다를 알자!

---

- **HR계정에서 실습***

1. 급여가 10000이상인 사원의 사번, 부서번호, 이름, 급여, 수당을 출력하시오.단, 부서번호가 30번,60번, 90번인 부서는 제외하고 사원을 검색한다.

2. 급여가 4000보다 많은 사원들의 부서별 급여평균를 출력하시오. 단 급여평균은 소숫점이하2자리에서 반올림합니다.

3. 지역별 지역번호(location_id), 부서수를 출력하시오 단, 지역번호가 2000번 이상인 지역만 출력한다

4. 하반기(7~12월) 월별 입사자수를 출력하시오.입사자수가 5명이상인 경우만 출력한다

5. 성이 'Davies'인 사원의 부서ID와 급여를 출력하시오.

6. 성이 'Davies'인 사원과 같은 부서에 근무하는 사원들의 사번, 성, 이름을 출력하시오

7. 'Seattle', 'Toronto'도시에  근무하는 사원들의 도시명,사번, 이름, 부서ID, 부서명 을 출력하시오

8. 'Seattle'을 제외한 도시의 부서별 사원수가 5명미만인 도시명, 부서ID, 부서명, 사원수를 출력하시오

9. 직책(job_title)이 'President'인 사원의 사번, 이름을 출력하시오: (NaturalJOIN으로 표현)

10. 직책(job_title)이 'President'가 아닌 사원의 사번, 이름을 출력하시오(USING으로 표현)

```sql
***HR계정에서 실습***
1. 급여가 10000이상인 사원의 사번, 부서번호, 이름, 급여, 수당을 출력하시오.단, 부서번호가 30번,60번, 90번인 부서는 제외하고 사원을 검색한다.
SELECT employee_id, 
       department_id, 
       last_name, 
       salary, 
       NVL(commission_pct, 0)
FROM employees
WHERE department_id NOT IN(30, 60, 90);

2.급여가 4000보다 많은 사원들의 부서별 급여평균를 출력하시오. 단 급여평균은 소숫점이하2자리에서 반올림합니다. 
SELECT department_id, ROUND(AVG(salary), 1)
FROM employees
WHERE salary>4000
GROUP BY department_id;

3.지역별 지역번호(location_id), 부서수를 출력하시오 --부서수란 지역에 속한 부서행을 의미
단, 지역번호가 2000번 이상인 지역만 출력한다
SELECT location_id, COUNT(*)
FROM locations
WHERE location_id >= 2000
GROUP BY location_id; 

4. 하반기(7~12월) 월별 입사자수를 출력하시오.입사자수가 5명이상인 경우만 출력한다 
SELECT TO_NUMBER(TO_CHAR(hire_date, 'MM'))||'월', COUNT(employee_id)
FROM employees
WHERE TO_NUMBER(TO_CHAR(hire_date, 'MM'))>=7 
GROUP BY TO_NUMBER(TO_CHAR(hire_date, 'MM'))
HAVING COUNT(*) >=5
ORDER BY TO_NUMBER(TO_CHAR(hire_date, 'MM'));

5.성이 'Davies'인 사원의 부서ID와 급여를 출력하시오.
SELECT last_name, department_id, salary
FROM employees
WHERE last_name = 'Davies';

6. 성이 'Davies'인 사원과 같은 부서에 근무하는 사원들의 사번, 성, 이름을 출력하시오
SELECT e.employee_id, 
       e.last_name,
       e.first_name
FROM employees e JOIN employees davis ON e.department_id = davis.department_id --e는 일반사원 
WHERE davis.last_name = 'Davies';

7. 'Seattle', 'Toronto'도시에  근무하는 
사원들의 도시명,사번, 이름, 부서ID, 부서명 을 출력하시오
SELECT city,
       employee_id,
       first_name,
       last_name,
       d.department_id,
       department_name
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
                 JOIN locations l ON (d.location_id = l.location_id)
WHERE city IN ('Seattle', 'Toronto');
     
8. 'Seattle'을 제외한 도시의 부서별 사원수가 5명미만인   
도시명, 부서ID, 부서명, 사원수를 출력하시오 
SELECT city,
       department_id,
       department_name,
       COUNT(*)
FROM employees JOIN departments USING(department_id)
               JOIN locations USING(location_id)
WHERE city <> 'Seattle'
GROUP BY city, department_id, department_name
HAVING COUNT(*) < 5;

9.직책(job_title)이 'President'인 사원의 사번, 이름을 출력하시오: (NaturalJOIN으로 표현)
SELECT job_title, employee_id, first_name, last_name
FROM employees NATURAL JOIN jobs 
WHERE job_title = 'President';

10. 직책(job_title)이 'President'가 아닌 사원의 사번, 이름을 출력하시오(USING으로 표현)
SELECT job_title, employee_id, first_name, last_name
FROM employees e JOIN jobs j USING(job_id)
WHERE job_title <> 'President';
```

<<강사님 comment>>

1번 문제에서 !=30 OR !=60 OR !=90이란 30아니거나 60아니거나 90아니라면 모든것과 같은 의미입니다
따라서 !=30 AND !=60 AND !=90로 바꿔야 할듯.
그보다 좋은 방법은 NOT IN (30, 60, 90)

2번문재. 소숫점이하2자리에서 반올림이란 1자리까지 출력하라는 뜻이니 ROUNT(AVG(salary), 1)

3번 부서수란 지역에 속한 부서행을 의미합니다.
SELECT location_id, COUNT(*)
FROM locations
WHERE location_id >= 2000
GROUP BY location_id;

4번. SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY를 쭉 나열하고 빈칸채우기로 해결
처리순서별로 1) FROM 테이블명 employees
2)WHERE 일반 조건 입사월이 7월부터 12월까지 TO_NUMBER(TO_CHAR(hire_date, 'MM')) >= 7
3)GROUP BY XX별 월별 TO_NUMBER(TO_CHAR(hire_date, 'MM'))

4)HAVING 그룹에 대한 조건 입사자수가 5명 이상 COUNT(*) >= 5

5번. LIKE대신 그냥 = 'Davis'

6번. JOIN으로 해결
FROM employees e JOIN employees davis ON e.department_id = davis.department_id
WHERE davis.last_name = 'Davis'

7번. WHERE city IN ('Seattle', 'Toronto')

8번 10번 같지않다 비교연산자는 <>가 표준입니다. !=는 OS에 따라 실행안될 수 도 있어요
