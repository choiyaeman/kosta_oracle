# day05

UNION은 행을 결합하는 연산자

JOIN은 특정 칼럼 값과 같은 값을 갖는 애를 찾아 결합하는 연산자

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled.png)

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%201.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%201.png)

employee_id, manager_id 를 보면 100사원은 관리자가 없는 사원, 다른 사원들은 다 관리자가 있다.

사원 입장에서 바라보자. 101정보 사원을 찾다 보면 매니저 아이디와 같은 사원의 아디를 찾아보면 관리자 이름을 찾아낼 수 있다.  사원의 사번과 이름 사원의 관리자 이름까지 출력하고 싶은 거다. 자기 참조 관계라 부른다. 관리자가 사번을 참조하는 것. 매니저 아이디가 fk employee_id가 pk가 된다.

- hr_selfjoin.sql

```sql
--사원의 사번, 이름, 관리자번호, 관리자 이름을 출력하시오
SELECT e.employee_id 사번, e.first_name 이름,
       m.employee_id 관리자번호, m.first_name 관리자이름
FROM employees e JOIN employees m ON (e.manager_id = m.employee_id)
ORDER BY e.employee_id;

--'Davies'사원과 같은 부서에 근무하는 사원들을 출력하시오
SELECT e.employee_id, e.first_name, e.department_id --사원들의 정보를 알고싶은것, 부서아이디는 50번이 출력되어야 한다.
FROM employees e JOIN employees davies ON (e.department_id = davies.department_id) --데이비스부서와 같은 부서를 의미
WHERE davies.last_name = 'Davies';

--데이브 성을 갖고있는 사원의 부서아이디 확인
SELECT department_id
FROM employees
WHERE last_name='Davies'; --데이브 성을 갖고있는 사원의 부서는 50번
```

- hr_outjoin.sql

```sql
--사원 중 부서 배치 받지못한 사원(사번, 이름, 부서번호)을 출력
-- -> employees테이블의 행 중 department_id가 null인 행을 추출하라는 의미
SELECT *
FROM employees  
WHERE department_id IS NULL;

--사원의 사번, 이름, 부서번호, 부서명을 출력하시오: 사원수-107명, 부서배치받지못한사원수-1, 총 106명. 부서번호178이 null인것을 확인 할 수 있다.
SELECT employee_id, first_name, e.department_id, department_name
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
ORDER BY employee_id;
----------------------------------------------------------------------------------------
--107명 사원을 다 보고싶으면 두 테이블 관계중 부족한 쪽이 어딘지 확인해야한다. 
--사원들의 사번, 이름, 부서번호, 부서명을 출력하시오. 단, 부서가 없는 사원도 출력하시오
SELECT employee_id, first_name, e.department_id, department_name
FROM employees e LEFT JOIN departments d ON (e.department_id = d.department_id)
ORDER BY employee_id;

--오라클 JOIN 표기법
SELECT employee_id, first_name, e.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+)
ORDER BY employee_id;

--지역ID와 도시명을 출력하시오
SELECT location_id, city
FROM locations; --23건

--부서ID와 지역ID를 출력하시오:27건
SELECT department_id, location_id
FROM departments; 

--도시에 속한 부서명들을 출력하시오.:27건
SELECT city, department_name
FROM departments d JOIN locations l ON (d.location_id = l.location_id);

--도시에 속한 부서명들을 출력하시오. 부서가 없는 도시도 출력하시오.:43건
SELECT city, department_name
FROM departments d RIGHT JOIN locations l ON (d.location_id = l.location_id); --부서가 없는 도시가 다 출력되게 해야하므로 locations테이블이 기준이 되어야한다. 기준이 오른쪽이니깐 Right 

--오라클 JOIN 표기법
SELECT city, department_name
FROM departments d, locations l
WHERE d.location_id(+) = l.location_id; --자료가 부족한쪽에 +표시를 해주면 된다.(null에 해당하는 자료가 없는 쪽)

--부서번호와 부서명을 출력하시오:27건
SELECT department_id, department_name
FROM departments;
220	NOC
230	IT Helpdesk
240	Government Sales
250	Retail Sales
260	Recruiting
270	Payroll

--사원의 사번, 이름, 부서번호, 부서명을 출력하시오.:123건
--단, 부서가 없는 사원도 모두 출력하고
--사원이 없는 부서도 모두 출력하시오
SELECT employee_id, d.department_id, department_name
FROM employees e FULL JOIN departments d ON (e.department_id = d.department_id); --FULL OUTER JOIN으로 양쪽 자료를 모두 출력할 수 있다. 부서가 없는 사원178번, 사원이 없는 부서
```

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%202.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%202.png)

관리자 아이디가 null인 경우 매니저 아이디에 해당하는 사원 정보가 없다. 총 사원수가 107명인데 추출된 결과 값은 106명이 출력이 된다.

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%203.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%203.png)

departments테이블의 기준이 될 수 있는게 department_id이므로 pk가 되고 employees테이블의 department_id는 fk가 된다. employees(자식) , departments(부모) 

fk를 하는 이유는 부모 쪽의 department_id가 갖고 있는 번호 중에 없는 걸 참조하게 되면 안됨으로 설정해준다.

departments에 null이 없으니 자료 부족이며, 기준이 되는 테이블이 employees쪽이고 기준이 되는 테이블이 있는 쪽을OUTER로 설정한다. 양 테이블 중에서 왼쪽에 있는 테이블이 기준이면 LEFT OUTER, 오른쪽이면 RIGHT OUTER로 설정! 여기서 outer는 생략 가능하다.

사원의 부서 아이디는 null이 들어갈 수 있다. 조인 처리 시에 결과를 나타나게 하려면 outer처리를 해야 한다.

FULL OUTER 는 양쪽 자료를 모두 출력

---

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%204.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%204.png)

WHERE절에서 사용하는 서브 쿼리. 연산 우선순위가 서브 쿼리가 먼저 처리된다!!

동시에 여러 테이블을 처리: JOIN, 순차 처리되는 방식을 서브 쿼리라 한다.

- hr_subquery.sql

```sql
--부서별 부서ID, 최대급여를 출력
SELECT department_id, MAX(salary)
FROM employees
GROUP BY department_id;

--최대급여를 출력하시오
SELECT MAX(salary) FROM employees;

--최대급여를 받는 사원의 사번, 이름, 급여를 출력하시오
1)최대급여계산:결과가 1개의 행을 반환
2)1)과 같은 급여를 받는 사원의 정보출력
SELECT employee_id, first_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

--부서별 최대급여를 받는 사원의 사번, 이름, 급여를 출력하시오.
1)부서별 최대급여계산:결과가 여러행을 반환. 일반 비교연산자 사용 안됨! -> 부서별이니깐 여러행을 반환
                                        IN, ANY,ALL
2)1)과 같은 급여를 받는 사원의 정보 출력
SELECT employee_id, first_name, salary, department_id
FROM employees
WHERE salary IN (SELECT MAX(salary) --10번부서: 4400, 20번부서: 13000, 30번부서: 11000, 40번부서: 6500
                FROM employees 
                GROUP BY department_id)
ORDER BY department_id, salary;

--부서별 최대급여를 받는 사원의 사번, 이름, 급여를 출력하시오.
--1)부서별 최대급여계산된 부서번호와 최대급여를 반환 : 여러행반환, 여러컬럼반환 
SELECT employee_id, first_name, salary, department_id
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, MAX(salary)  --서브쿼리와 메인절 컬럼개수를 똑같이 맞춰준다
                                  FROM employees 
                                  GROUP BY department_id);

--서브쿼리의 종류
행기준
    단일행서브쿼리
    다중행서브쿼리 IN, ANY, ALL, EXISTS
위치기준
    서브쿼리 (WHERE)
    인라인뷰 (FROM)
    스칼라쿼리 (SELECT)
---------------------------
인라인뷰
--사원의 사번, 입사일, 급여를 출력하시오.
SELECT employee_id, hire_date, salary
FROM employees;

--오라클제공 의사컬럼 : rownum -행번호
SELECT rownum, employee_id, hire_date, salary
FROM employees;

--사원의 사번, 입사일, 급여를 출력하시오. 급여가 많은 사원부터 출력하시오
SELECT rownum, employee_id, hire_date, salary
FROM employees
ORDER BY salary DESC; --급여가 많은 순서대로 행번호가 붙지 않는다. 행번호가 정렬 대상이 되지못하고있다. SELECT절이 먼저 처리되고 마지막으로 ORDERBY가 처리 됨으로.. SELECT로 발급된걸 가지고 처리했기때문에 순서가 뒤죽박죽

--SELECT처리순서 : FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
--사원의 사번, 입사일, 급여를 출력하시오. 급여가 많은 사원부터 출력하시오
--행번호는 급여 많은 순서대로 1씩증가한다.(정렬 후 행번호 발급)
SELECT rownum, emps.* -- 별칭.* 프로젝션에 해당하는 모든 컬럼
FROM (SELECT employee_id, hire_date, salary
      FROM employees
      ORDER BY salary DESC) emps; --emps별칭 별칭을 이용해서 바깥쪽 SELECT에 사용

--사원의 사번, 입사일, 급여를 출력하시오. 급여가 많은 사원부터 출력하시오
--행번호는 급여 많은 순서대로 1씩증가한다.(정렬 후 행번호 발급)
--행번호가 1~10인 사원들을 출력하시오
SELECT rownum, emps.* -- 별칭.* 프로젝션에 해당하는 모든 컬럼
FROM (SELECT employee_id, hire_date, salary
      FROM employees
      ORDER BY salary DESC) emps
 WHERE rownum BETWEEN 1 AND 10; --탑n쿼리
 
 --행번호가 1~20인 사원들을 출력하시오
SELECT rownum, emps.* -- 별칭.* 프로젝션에 해당하는 모든 컬럼
FROM (SELECT employee_id, hire_date, salary
      FROM employees
      ORDER BY salary DESC) emps
 WHERE rownum BETWEEN 11 AND 20; --건수가 0건 왜?? rownum은 기본값이 1인상태고 행을만나면 1증가시켜서 발급하는거다. 근데 11~20조건에 만족하지 않죠? rownum이 1이므로

SELECT *
FROM (SELECT rownum rno, emps.* --rno별칭 바깥쪽where절에서 사용 
      FROM (SELECT employee_id, hire_date, salary
            FROM employees
            ORDER BY salary DESC) emps)
WHERE rno BETWEEN 21 AND 30;
---------------------------------------------------------
--스칼라쿼리
--사원의 사번, 급여, 부서번호, 부서명을 출력하시오
SELECT employee_id, salary, department_id,
      (SELECT department_name 
       FROM departments
       WHERE department_id=employees.department_id) 
FROM employees; 
---------------------------------------------------------
--111번 사원의 급여보다 많은 급여를 받는 
--같은 부서의 사원사번, 급여, 부서번호를 출력하시오
SELECT employee_id, salary, department_id
FROM employees
WHERE (department_id,salary) > (SELECT department_id, salary  --비교 대상이 될 수 없다. 쌍을 맞출때는 비교연산자가 in, equals로 비교해줘야한다!
                FROM employees 
                WHERE employee_id=111); --(X)
--상호연관서브쿼리
SELECT employee_id, salary, department_id
FROM employees e
WHERE salary > (SELECT salary  
                FROM employees e111
                WHERE employee_id=111
                AND e.department_id = e111.department_id --메인쿼리에서 쓰이는 테이블을 서브쿼리에서 사용~
                ); 
---------------------------------------------------------
--EXISTS연산자
-사원이 있는 부서들을 출력하시오.
SELECT *
FROM departments
WHERE EXISTS 
    (SELECT department_id 
     FROM employees
     WHERE department_id = departments.department_id); 

--NOT EXISTS연산자
-사원이 없는 부서들을 출력하시오.
SELECT *
FROM departments
WHERE NOT EXISTS 
    (SELECT department_id 
     FROM employees
     WHERE department_id = departments.department_id); 
---------------------------------------------------------
--NULL값을 갖는 SUBQUERY
--홀수 사번만 갖는 부서아이디를 출력하시오. 중복되는 부서번호는 제외
(SELECT DISTINCT department_id 
 FROM employees 
 WHERE MOD(employee_id,2) = 1);
--짝수번 사원의 부선번호와 부서명을 출력하시오.
SELECT department_id, department_name
FROM departments
WHERE department_id
      IN(SELECT DISTINCT department_id --NULL포함
         FROM employees 
         WHERE MOD(employee_id,2) = 0);
         
--짝수번 사원이 근무하지 않는 부서를 출력하시오
SELECT department_id, department_name
FROM departments
WHERE department_id
      NOT IN(SELECT DISTINCT department_id --NULL포함할경우 연산을 한번더 필터링 해줘야한다.
         FROM employees 
         WHERE MOD(employee_id,2) = 0);--0건 결과

SELECT department_id, department_name
FROM departments
WHERE department_id
      NOT IN(SELECT DISTINCT NVL(department_id, 0) --NULL포함할경우 연산을 한번더 필터링 -> NVL
         FROM employees 
         WHERE MOD(employee_id,2) = 0);--17건 결과
```

일 처리를 나누자 부서별 최대 급여를 1번, 사원의 사번, 이름, 급여 출력을 2번 처리 순으로..최대 급여하고 같은 급여를 받는 사원 정보를 출력하려면 서브쿼리로 만들어야 한다.

salary      department_id

6500	   40

6500	   50
8200	   50

40번 부서는 최대 급여와 같은 6500을 추출하므로 50번 부서도 반환하게 된다

결과가 여러 행, 칼럼도 다중으로 해결해야 한다.

## 서브쿼리란?

sql문을 실행하는 데 필요한 데이터를 추가로 조회하기 위해 sql문 내부에서 사용하는 select문을 의미. 서브쿼리의 결과 값을 사용하여 기능을 수행하는 영역은 메인쿼리라 부른다.

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/20210113_120435.jpg](day05%20d41d984a7fd44a86801f1e22fcd22c2d/20210113_120435.jpg)

> **서브쿼리의 특징**

1. 연산자와 같은 비교 또는 조회 대상의 오른쪽에 놓이면 괄호 ()로 묶어서 사용한다.
2. 특수한 몇몇 경우를 제외한 대부분의 서브쿼리에서는 ORDER BY절 사용할 수 없다.
3. 서브쿼리의 SELECT절에 명시한 열은 메인쿼리의 비교 대상과 같은 자료형과 같은 개수로 지정해야함.
4. 서브쿼리에 있는 SELECT문의 결과 행 수는 함께 사용하는 메인쿼리의 연산자 종류와 호환 가능해야함. 단 하나의 데이터로만 연산이 가능한 연산자라면 서브쿼리의 결과 행 수는 반드시 하나

> **단일행 서브쿼리는 실행 결과가 단 하나의 행으로 나오는 서브쿼리를 뜻한다.**

단일행 연산자를 사용하여 비교 ex) >,≥,<>,...

> **다중행 서브쿼리는 실행 결과 행이 여러 개로 나오는 서브쿼리를 가리킨다.**

결과가 여러 개이므로 단일행 연산자는 사용할수 없고 다중행 연산자를 사용해야 메인쿼리와 비교할 수 있다. ex) IN, ANY, SOME, ALL, EXISTS

**IN** : 메인쿼리의 데이터가 서브쿼리의 결과 중 하나라도 일치한 데이터가 있다면 true

**ANY, SOME** : 메인쿼리의 조건식을 만족하는 서브쿼리의 결과가 하나 이상이면 true

**ALL** : 메인쿼리의 조건식을 서브쿼리의 결과 모두가 만족하면 true

**EXISTS** : 서브쿼리의 결과가 존재하면(즉, 행이 1개 이상일 경우) true

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%205.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%205.png)

서브쿼리의 결과 값 중 값의 범위가 950, 1250, 15000, 160, 2850

=ANY : IN연산자와 같다

>ANY : 최소값보다 크다

<ANY : 최대값보다 작다

>ALL : 최대값보다 크다

<ALL : 최소값보다 작다

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%206.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%206.png)

NOT IN연산자가 IN연산자의 반대인데 NULL값을 포함하고 있는 경우에 큰 문제를 일으킬 수 있다.

AND연산은 좌측, 우측 모두 true일 때만 true를 반환한다. a<>NULL 만족하는 행은 하나도 없다 false이므로 하나가 false이면 모두 false가 된다. 문제 발생!

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%207.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%207.png)

NULL일 경우 해결 방법은 NVL으로 치환 시켜줘야 한다.

> **FROM절에 사용하는 서브쿼리와 WITH절**

FROM절에 사용하는 서브쿼리는 인라인뷰라고 부른다. 인라인 뷰는 특정 테이블 전체 데이터가 아닌 SELECT문을 통해 일부 데이터를 먼저 추출해 온 후 별칭을 주어 사용할 수 있다.

> **SELECT절에 사용하는 서브쿼리**

서브쿼리는 SELECT절에서도 사용할 수 있다. 흔히 스칼라 서브쿼리라고 부른다. 이 서브쿼리는 SELECT절에 하나의 열 영역으로서 결과를 출력할 수 있다. SELECT절에 명시하는 서브쿼리는 반드시 하나의 결과만 반환하도록 작성!

- **서브쿼리의 종류**

    행기준

    단일행서브쿼리

    다중행서브쿼리 IN, ANY, ALL, EXISTS

    위치기준

    서브쿼리 (WHERE)

    인라인뷰 (FROM)   → 인라인뷰에서 SELECT한 프로젝션만 쓸 수 있다.

    스칼라쿼리 (SELECT)

상호연관서브쿼리

---

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%208.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%208.png)

건수가 0건 왜?? rownum은 기본값이 1인상태고 행을만나면 1증가시켜서 발급하는거다. 근데 11~20조건에 만족하지 않죠? rownum이 1이므로

인라인뷰를 사용해서 페이지 그룹핑을 할 수 있다.

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%209.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%209.png)

SELECTIONS 절차에서 찾아온 그 행이 갖고 있는 department_id와 부서 아이디 정보를 추출하는 것

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%2010.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%2010.png)

상호연관서브쿼리는 메인쿼리에 있는 from한 행을 찾아서 그 행을 where조건에 사용하려 하는데 그 행을 서브쿼리에서 사용하는 거다. 처리된 결과 값이salary가 where조건에 salary 비교대상으로 삼는 것이다.

EXISTS 상호연관서브쿼리에서만 쓸 수 있는 연산자이다.

![day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%2011.png](day05%20d41d984a7fd44a86801f1e22fcd22c2d/Untitled%2011.png)

메인쿼리의 departments테이블을 exists연산자의 서브쿼리에서 이용.. 부서가 있는 사원의 부서 번호가 존재여부를 묻는 거다.  존재 한다면 departments의 department_id를 출력해라~! exists가 존재 한다면의 의미

부서의 부서 번호를 출력 ⇒ 사원이 존재하는 부서를 출력하라는 문제이다. 

NOT EXISTS이면 사원 없는 부서를 출력하라는 뜻이다.

실습2)

1. 관리자급여보다 많은 급여를 받는 사원의사번, 성명, 급여, 관리자번호, 관리자성명, 관리자급여를 출력하시오
2. 사원과 관리자가 다른부서에서 근무하는 사원들의 사번, 성명, 부서명, 관리자번호, 관리자성명, 관리자부서명을 출력하시오
3. 사원들의 사번, 이름, 부서ID, 부서명,도시명을 출력하시오(SUBQUERY사용)
4. 성이 'Davies'인 사원과 같은 부서에 근무하는 사원들의 사번, 성, 이름을 출력하시오. 단 Davies사원정보는 출력하지 않는다.(SUBQUERY사용)
5. 부서명이 'Sales'부서의 평균급여보다 많은 급여를 받는 'Sales'부서의 사원의 사번, 급여를 출력하시오.(SUBQUERY사용)
6. 'Seattle', 'Toronto'도시에  근무하는 사원들의 도시명,사번, 이름, 부서ID, 부서명을 출력하시오.

    (SUBQUERY사용)

```sql
1. 관리자급여보다 많은 급여를 받는 사원의사번, 성명, 급여, 관리자번호, 관리자성명, 관리자급여를 출력하시오
SELECT e.employee_id 사번, e.first_name||' '||e.last_name 성명
      ,e.salary 급여
      ,m.employee_id 관리자번호, m.first_name||' '||m.last_name 관리자성명
      ,m.salary 관리자급여
FROM employees e
     JOIN employees m ON (e.manager_id = m.employee_id)
WHERE e.salary > m.salary; 

2. 사원과 관리자가 다른부서에서 근무하는 사원들의 사번, 성명, 부서명, 관리자번호, 관리자성명, 관리자부서명을 출력하시오
SELECT e.employee_id 사번
     , e.first_name||' '||e.last_name 성명
     , ed.department_name "부서명"
     , e.manager_id 관리자번호
     , m.first_name||' '||m.last_name 관리자성명
     , md.department_name "관리자부서명"
FROM employees e
     JOIN employees m ON (e.manager_id = m.employee_id )
     JOIN departments ed ON (e.department_id = ed.department_id)
     JOIN departments md ON (m.department_id = md.department_id)
WHERE ed.department_id <> md.department_id;

3. 사원들의 사번, 이름, 부서ID, 부서명,도시명을 출력하시오(SUBQUERY사용)
SELECT employee_id, first_name, department_id
      ,(SELECT department_name FROM departments d
        WHERE d.department_id = e.department_id)부서명
      ,(SELECT city
        FROM locations
        WHERE location_id =(SELECT location_id 
                            FROM departments
                            WHERE department_id = e.department_id)
        ) 도시명                   
FROM employees e;

4. 성이 'Davies'인 사원과 같은 부서에 근무하는 사원들의 사번, 성, 이름을 출력하시오. 단 Davies사원정보는 출력하지 않는다.(SUBQUERY사용)
SELECT employee_id 사번,
       last_name 성,
       first_name 이름
FROM employees e
WHERE department_id = (SELECT department_id
                       FROM employees
                       WHERE last_name = 'Davies')
      AND last_name <> 'Davies';

5. 부서명이 'Sales'부서의 평균급여보다 많은 급여를 받는 'Sales'부서의 사원의 사번, 급여을 출력하시오.(SUBQUERY사용)
 SELECT department_id, employee_id, salary
FROM employees 
WHERE department_id = (SELECT department_id 
                       FROM departments 
                       WHERE department_name='Sales')
AND salary > (SELECT AVG(salary) FROM employees
                     WHERE department_id = 
                       (SELECT department_id 
                        FROM departments 
                        WHERE department_name='Sales'));
                        
--상호연관서브쿼리로 해결
SELECT department_id, employee_id, salary
FROM employees maine
WHERE department_id = (SELECT department_id 
                       FROM departments 
                       WHERE department_name='Sales')
AND salary > (SELECT AVG(salary) FROM employees
                     WHERE department_id = 
                            maine.department_id);

6. 'Seattle', 'Toronto'도시에  근무하는 사원들의 도시명,사번, 이름, 부서ID, 부서명을 출력하시오.
(SUBQUERY사용)
SELECT employee_id, first_name, department_id
      ,(SELECT department_name FROM departments d
        WHERE d.department_id = e.department_id)
      ,(SELECT city
        FROM locations
        WHERE location_id =(SELECT location_id 
                            FROM departments
                            WHERE department_id = e.department_id)
        )        
FROM employees e
WHERE department_id IN (SELECT department_id
                       FROM departments
                       WHERE location_id IN (SELECT location_id
                                             FROM locations
                                             WHERE city IN('Seattle', 'Toronto')
                                             )
                       );
```