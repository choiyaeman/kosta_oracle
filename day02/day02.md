# day02 

![1](https://user-images.githubusercontent.com/63957819/104079332-d8f45d80-5265-11eb-9cfe-c7b198c6299e.png)

SQLDeveloper 오라클에서 무상으로 제공되는 툴을 쓰자 자바로 만들어진 툴 이고 버전에 민감한데 

자바 11버전에는 잘 버전 되나 그 이상은 잘 구동 되지 않을 수 있다. sqldeveloper 실행!!

![2](https://user-images.githubusercontent.com/63957819/104079333-da258a80-5265-11eb-9459-390a1ab964bb.png)

![3](https://user-images.githubusercontent.com/63957819/104079334-dabe2100-5265-11eb-9ef2-cf68f57739bd.png)

새 접속 추가> 접속 이름: LocalSYSTEM, 사용자 이름: system, 비밀번호: kosta

>테스트 누르고 성공 상태 확인 > 접속> 

![4](https://user-images.githubusercontent.com/63957819/104079970-ed862500-5268-11eb-969f-8b1afe6ca8b7.png)

![5](https://user-images.githubusercontent.com/63957819/104079971-ee1ebb80-5268-11eb-8af7-3ec621f6dc24.png)

위와 같은 방법으로 새 접속 추가> 접속이름: LocalHR> 사용자 이름: hr> 비밀번호:hr> 접속

<**scott 계정 생성 및 테이블 만들기>**

```
1) Scott_Create.sql파일을 c:\에 다운로드한다
2) cmd창에서 sqlplus실행
   ex) C:\Users\KITRI> sqlplus

3) 관리자계정에 접속한다
   계정명-system, 암호-kitri
  ex) Enter user-name: system
       Enter password:
4) 계정을 추가한다
    계정명-scott, 암호-tiger
  ex)SQL> create user scott identified by tiger;
5) 계정 권한부여
    scott계정의 접속권한, 자원사용권한을 부여한다
  ex)SQL> grant connect, resource to scott;

6) scott계정에 접속한다
  ex)SQL> conn scott/tiger

7) 테이블 생성및 데이터추가
   Scott_Create.sql파일을 실행해서 한다
  ex)SQL> @c:\Scott_Create
```

![6](https://user-images.githubusercontent.com/63957819/104079972-ee1ebb80-5268-11eb-9705-3d95dbd65028.png)

Scott_Create.sql 다운로드 후 MYSQL파일 하나 만들어서 안에 넣음. 그리고 cmd창에서 테이블 생성 및 데이터를 추가 해보자.

```sql
sqlplus system/kosta
create user scott identified by tiger
grant connect, resource to scott; //scott계정을 접속할 수 있도록 권한을 줘야한다. 누구에게? scott에게
conn scott/tiger
@Scott_Create //현재 경로를 찾아서 실행을 시킬거다. 테이블 생성 및 데이터 추가
							// UTF-8일 경우SQL파일을 실행 시 글자 깨짐 오류 발생함으로 도구>환경설정으로가서 기본 인코딩MS949을 사용해주자.

```

scott계정을 사용하고 싶으면 엔터프라이즈 에디션용 오라클을 설치 안 했으므로 스콥 계정 만들어서 필요한 테이블을 넣어주면 된다. cmd 창 열어서 작업go~

![7](https://user-images.githubusercontent.com/63957819/104079974-eeb75200-5268-11eb-8c53-b4aabd27c017.png)

접속을 만들어주자 접속 추가>접속이름: LocalSCOTT, 계정: scott, 비번: tiger, 호스트: localhost

![8](https://user-images.githubusercontent.com/63957819/104079975-eeb75200-5268-11eb-95fa-2c46ea01fff4.png)

selection이라는 절차가 반복문이라 생각하자! 먼저 selection 을 하고 그리고 나서 projection을 하는 거다.

from절이 selection절차이고 select절이 projection절차이다.

from절부터 사용할 테이블을 채워 놓고 어떤 컬럼들만 projection할거냐는 select절로 한다.

띄어쓰기와 줄 바꿈 적극 사용하자~

![9](https://user-images.githubusercontent.com/63957819/104079976-ef4fe880-5268-11eb-96b6-5f7e4eb17082.png)

![10](https://user-images.githubusercontent.com/63957819/104079977-ef4fe880-5268-11eb-8c28-cf0b7f7a4777.png)

![11](https://user-images.githubusercontent.com/63957819/104079978-efe87f00-5268-11eb-875e-042f8267a283.png)

파일> 새로 만들기> 데이터베이스 파일> 이름, 디렉토리 지정> 확인 후 LocalSCOTT으로 열자

```sql
SELECT empno, sal
FROM emp;

SELECT * --프로젝션
FROM emp; --셀렉션
---------------------------------------
--컬럼별칭주기
SELECT empno 사번, ename, sal 급여 --컬럼별 한칸 띄우고 별칭
FROM emp;

SELECT empno "사원 번호", ename, sal 급여 --공백 다음에는 다음 컬럼이 나오기를 요구한다. --공백을 포함한 별칭 줄때는 ""사용, 문자열 표현할 때만 ''표시.
FROM emp;

SELECT empno AS "사원 번호", ename, sal AS 급여  --AS 생략 가능
FROM emp;
---------------------------------------
--컬럼값 결합 연산자 ||
SELECT empno || ename || sal --3개의 컬럼을 합쳐서 projection
FROM emp;

SELECT empno || ename || sal "사번과 이름과 급여" --3개의 컬럼을 합쳐서 projection 하는데 heading이 맘에 안들면 별칭을 주면 된다.
FROM emp;

--SQL의 문자열 리터럴, 날짜 리터럴은 '를 사용한다 ex) 'hello', '21/05/07'
SELECT empno ||'-'|| ename ||'-'|| sal "사번과 이름과 급여" 
FROM emp;
---------------------------------------
--산술연산자 : +, -, *, / --나머지 값 구하는 연산자가 없다
--나머지값 구하는 함수: MOD()
SELECT empno, MOD(empno, 2), ename, sal, sal*12
FROM emp;
---------------------------------------
--중복값 제거
SELECT DEPTNO
FROM emp; --14건

SELECT DISTINCT deptno --사원들이 속해있는 부서번호를 출력하되 중복번호는 제거한다
FROM emp; --3건
---------------------------------------
--정렬하기
SELECT empno, ename, sal
FROM emp
ORDER BY sal DESC, ename ASC; --급여가 많은 순서대로 출력
                              --급여 같은 경우에는 사원의 이름을 사전순(오름차순)으로 출력한다. ex) A, B, C, D ... --사전역순(내림차순)
                              --ASC 생략가능
-------------------------------------------------------------------------------
SELECT구문 처리 순서: 
    [FROM -> WHERE -> GROUP BY -> HAVING] -> [SELECT -> ORDER BY] 
-------------------------------------------------------------------------------
SELECT
FROM
[
WHERE
GROUP BY
HAVING
ORDER BY
]
--ORDER BY에서 별칭 사용가능
SELECT empno, ename, sal "급여"
FROM emp
ORDER BY 급여 DESC, ename;

--ORDER BY에서 프로젝션에 참여하지 않은 컬럼사용 가능
SELECT empno, ename
FROM emp
ORDER BY sal DESC;
--ORDER BY에서 프로젝션에 참여한 컬럼순번을 사용가능
SELECT empno, ename, sal
FROM emp
ORDER BY 3 DESC; --세번째 컬럼. DB에서는 인덱스가 무조건 1부터 시작한다
-------------------------------------------------------------------------------
--WHERE절 : 조건에 만족하는 행을 셀렉션. if와 같은 효과
--비교연산자 : >, >=, <, <=, =  =은 같다라는 의미 대입x
--논리연산자 : AND, OR, NOT

--급여가 1250인 사원의 사번, 이름, 급여를 출력하시오
SELECT empno, ename, sal
FROM emp
WHERE sal=1250;

--급여가 1250보다 많은 사원의 사번, 이름, 급여를 출력하시오. 단 급여가 많은 사원부터 출력한다.
SELECT empno, ename, sal
FROM emp
WHERE sal > 1250
ORDER BY sal DESC;

--급여가 1500이상 3000이하인 모든 사원의 사번, 이름, 급여를 출력하세요. 
--단 급여가 많은 사원부터 출력한다.
SELECT empno, ename, sal
FROM emp
WHERE sal >= 1500 AND sal <= 3000
ORDER BY sal DESC;

SELECT empno, ename, sal
FROM emp
WHERE sal BETWEEN 1500 AND 3000 --BETWEEN 연산자는 이상 이하에만 쓸 수 있다
ORDER BY sal DESC;

--급여가 1500미만 3000초과인 모든 사원의 사번, 이름, 급여를 출력하세요. 
--단 급여가 많은 사원부터 출력한다.
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
-------------------------------------------------------------------------------
--부서 번호가 10, 30번인 사원의 사번, 이름, 급여, 부서번호를 출력하시오
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno=10 OR deptno=30; --부서번호가 10번이면서 30번 사원은 없겠죠? 그러니까 OR연산을 써야한다.

SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno IN(10,30); --IN연산자 안에는 OR연산자가 들어있는거다.
-------------------------------------------------------------------------------
--부서 번호가 10, 30번인 사원의 
--급여가 1500이상 3000이하인 모든 사원들의 사번, 이름, 급여를 출력하세요. 
SELECT empno, ename, sal, deptno
FROM emp
WHERE (deptno=10 OR deptno=30) AND (sal>=1500 AND sal<=3000);

SELECT empno, ename, sal, deptno
FROM emp
WHERE (deptno IN(10, 30)) AND (sal BETWEEN 1500 AND 3000);
-------------------------------------------------------------------------------
--사원의 사번과 직무를 출력하시오
SELECT empno,job
FROM emp;

--'MAN'단어를 포함한 직무를 갖는 사원의 사번, 직무를 출력하시오.
SELECT empno, job
FROM emp
WHERE job LIKE '%MAN%'; --MAN이라는 단어앞뒤에 어떤 단어가 와도 좋다라는 의미. %: 0개 이상의 단어

SELECT empno, job
FROM emp
WHERE job LIKE '%MAN'; --마무리는 MAN 끝나는 job을 갖는 사람

SELECT empno, job
FROM emp 
WHERE job LIKE 'MAN%'; --MAN으로 시작하되 0개 이상의 단어

--직무가 SALES로 시작하고 8단어로 구성된
--사원의 사번, 직무를 출력하시오
SELECT empno, job
FROM emp
WHERE job LIKE 'SALES___'; --_패턴은 한 개라는 뜻

--사번과 입사일자를 출력하시오
SELECT empno, hiredate
FROM emp;

--입사일자가 81년도인 사원의 사번과, 입사일자를 출력하시오
SELECT empno, hiredate
FROM emp
WHERE hiredate LIKE '81%';

SELECT empno, hiredate
FROM emp
WHERE hiredate>='81/01/01' 
    AND hiredate<='81/12/31';
    
SELECT empno, hiredate
FROM emp
WHERE hiredate BETWEEN '81/01/01' AND '81/12/31';
-------------------------------------------------------------------------------
--NULL관련 연산자: IS NULL, IS NOT NULL
--NULL은 아무값도 아니다
SELECT empno, sal, comm
FROM emp;

--수당이 없는 사원의 사번, 급여, 수당을 출력하시오
SELECT empno, sal, comm
FROM emp
WHERE comm IS NULL;
-------------------------------------------------------------------------------
--집합연산자
-10번 부서사원과 30번 부서사원의 사번, 부서번호 출력하시오
SELECT  empno, deptno
FROM emp
WHERE deptno = 10
UNION
SELECT  empno, deptno
FROM emp
WHERE deptno = 30
```

ctrl+enter : 결과 출력, --: 주석
select절에서 만든 컬럼 별칭을 order by에서 별칭 사용할 수 있을까? 할 수 있다.
select다음에 order by 구문이 수행되기 때문에 충분히 사용 가능하다.
AND는 BETWEEN 연산자로 OR은 IN 연산자로 바꿀 수 있다.
OR, AND 연산자 중에 AND가 먼저 사용됨으로 () 사용하여 연산자 우선 순위를 높여주면 된다.
LIKE연산자는 특정 단어를 포함하고 있는 의미. 그러나 대단히 속도가 느리다.
LIKE연산자는 포퍼먼스가 떨어지므로 웬만하면 비교 연산자를 쓰자!
%: 0개 이상의 단어, _: 한 개라는 뜻
WHERE a LIKE 'AB_C_'  → AB_C다음 글자 1개를 갖는 a컬럼을 찾아라 의미.
WHERE a LIKE 'AB\_C_' ESCAPE '\'; → 어떤 게 패턴이고 글자인 확인하려면 ESCAPE를 쓴다. 탈출한다는 게 ESCAPE 다음에 나오는 문자는 엔진에 의해서 해석되지 않는다(=패턴이 아니다) 라고 생각하면 된다. 즉 백 슬러시 다음에 나오는 문자는 패턴이 아니라 일반 문자라는 뜻이다.
sqlplus에서는 null값이 아무 값도 표현이 안된다. 표현이 이렇게 된 거지 실제 아무 값도 아닌 거다.
수당이 null이면 아무 값도 안 받는다는 의미. =연산자(x) IS NULL 해야 연산자 비교할 수 있다.
합집합 용 연산자가 UNION, UNION ALL이 있다. UNION은 교차되는 중복을 피한다. UNION ALL은 교차되는 중복을 피하지 않는다.
차집합을 알리는 연산자는 MINUS 이다.
교집합을 알리는 연산자는 INTERSECT 이다.
서로 컬럼 개수와 자료형이 모두 같아야 한다.

![12](https://user-images.githubusercontent.com/63957819/104079980-efe87f00-5268-11eb-8e4b-94d1115a4f84.jpg)

AB_C▤ → AB_C 다음 글자 1개를 찾겠다라는 의미인데. 그냥 LIKE로 해주면 위의 해당 테이블 A에서 

AB_CD, ABXCA, AB_CA, AB_CAA 등 모두 문자열이 찾아질 수가 있다. 그러므로 AB_에서 _일반 문자로 표현하기 위해서는 ESCAPE를 쓰면 된다. 그러면 AB_에서 _를 패턴 형식이 아닌 일반 문자로 인식하고 C 다음 글자 1개인 것 중에 AB_CD, AB_CA가 될 수 있다.

![13](https://user-images.githubusercontent.com/63957819/104079981-f0811580-5268-11eb-8a4e-d24b50c7f693.png)

서버까지 가야 한다 네트워크 비용을 쓴다는 건데 금액도 금액이지만 처리 속도가 핵심인데 sql구문이 전송이 빨리 되어야 한다면 단순해야 한다. sql구문이 최적화 되어야 한다.

![14](https://user-images.githubusercontent.com/63957819/104079982-f0811580-5268-11eb-9af6-f7e5937f48b7.png)

![15](https://user-images.githubusercontent.com/63957819/104079984-f119ac00-5268-11eb-8519-a110fb53b47f.png)

JOB HISTORY와 EMPLOYEESS 테이블의 데이터를 보면, JOB HISTORY 란  경력 증명 history를 말한다.  EMPLOYEES 테이블은 현재 업무 기록이 담겨있고 JOB_HISTORY테이블에는 이전 업무 기록이 담겨있는 거다.

---

![16](https://user-images.githubusercontent.com/63957819/104079985-f119ac00-5268-11eb-8c77-3d1d8d63325a.png)

scott_funtion이름이라는 새로운 파일을 또 만들어주자

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

--숫자함수
--날짜함수
```

자바의 INDEX OF랑 ORACLE에서 INSTR 하고 아주 유사하다.
