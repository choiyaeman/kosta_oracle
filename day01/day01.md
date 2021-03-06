# day01 

### DBMS(Database Management System)

- 데이터베이스 관리 시스템

**관계형 데이터베이스란?**

데이터를 저장, 관리하는 데이터베이스를 의미

### SQL(Structured Query Language)

- RDBMS에서 데이터를 다루고 관리하는 데 사용하는 데이터베이스 질의 언어

SQL영역

-DQL : 조회용도

-DML : rdbms 내 테이블의 데이터 저장, 수정, 삭제 하는 명령어

-DDL : rdbms 내 테이블을 포함한 여러 객체를 생성, 수정, 삭제하는 명령어

-TCL : 트랜잭션 데이터의 영구 저장, 취소 등과 관련된 명령어

-DCL : 데이터 사용 권한과 관련된 명령어

![1](https://user-images.githubusercontent.com/63957819/103893575-db08d000-5130-11eb-8f9a-06d4bd731a77.png)

오라클 안에는 데이터들이 들어가 있을 거다.  오라클 내에 계정 즉 사용자가 있다. hr 계정이 제공이 되고 system, scott 등 여러 계정이 있는데 그 계정 안 쪽에 물리적 스키마가 있다. 물리적 스키마란 객체들의 집합을 말한다. 객체가 오라클에는 객체의 형태가 고정되어 있다.  객체 종류로는 테이블, 뷰, 인덱스, 시퀀스로 구성되어 있다. 다른 db와 다르게 oracle은 계정 별로 스키마가 딱 한개씩 제공한다. 포트를 열고 접속을 기다리는 구조이다. 

테이블 객체는 실제 자료가 저장된다. 그 외의 객체들은 테이블을 도와주는 역할이라 보면 된다.

데이터는 0,1로 저장이 된다. 편집기로도 볼 수가 없고 윈도우 탐색기로도 찾아 낼 수 없다. 같은 테이블에 첫 번째, 두 번째, 세 번째 클라이언트가 접속한다고 보자. 첫 번째TOAD 라는 것을 이용해서 접속 두 번째 SQLDeveloper, 세 번째 JAVA App만들어서 계정에 접속. 특정 문법을 이용해서 요청을 해야 한다. 첫 번째 용 소켓, 두 번째 용 소켓, 세 번째 용 소켓이 있어야 한다. oracle에 있는 자료를 주고 받을 때는 표준 프로토콜이 있어야 한다. 그 규약을 SQL이라 부른다. 반드시 표준화 된 문법을 이용해서 물어봐야 oracle이 그 내용을 이해해서 검색하고 응답을 해준다.

db에서만 쓰이는 종속적인 문법과 표준화 된 문법 중 될 수 있으면 표준화 된 문법을 사용하는 걸 권장한다. 

---

### Oracle 설치

컴퓨터 이름은 한글이 아닌 영어로 써야 한다.

![2](https://user-images.githubusercontent.com/63957819/103893581-dcd29380-5130-11eb-86bb-a23a286ba295.png)

→ OracleXE112_Win64 download > 여기서 XE는 교육용을 의미 11버전

![3](https://user-images.githubusercontent.com/63957819/103893583-dcd29380-5130-11eb-865f-7bf0885b4d89.png)

→ ORACLE이라는 이름의 새 파일을 만들고 안에 압축 해제 후 DISK1 파일 안에 들어가서 setup실행

비번: kosta

![4](https://user-images.githubusercontent.com/63957819/103893584-dd6b2a00-5130-11eb-9c6d-77d000b64957.png)

→ 서비스에 들어가면 oracle 실행 상태 확인 가능

![5](https://user-images.githubusercontent.com/63957819/103893585-dd6b2a00-5130-11eb-8b47-d11f459d78c5.png)

→ 명령 프롬프트 창 실행.. 유저 이름은 system, 패스워드는 kosta

```java
sqlplus //oracle 설치 되어야만 쓸 수 있는 명령어
select * from tab;
conn hr/hr //다른계정 이동. sample이 제공되나 현재 잠겨있는 상태 hr 관리자 계정이 아닌 일반계정이다. 사용하려면 잠금 해제 하여야 한다.
conn system/kosta //시스템 계정으로 다시 돌아가자 시스템 계정에서 hr계정 lock을풀자
alter user hr identified by hr account unlock;// alter user로 계정을 변경하겠다 hr로 비번도 hr 그리고 계정을 잠금 해제 하겠다
conn hr/hr
show user //계정확인. db쪽에서는 대소문자 구분을 안한다.
select * from tab; //hr계정에는 사원에 대한 기본정보, 속해있는 부서정보, 담당하고 있는 직무/직책, 지역등이 담겨있다.
```

![6](https://user-images.githubusercontent.com/63957819/103893586-de03c080-5130-11eb-9c7e-d588c8740958.png)

![7](https://user-images.githubusercontent.com/63957819/103893588-de9c5700-5130-11eb-9f7c-1a492459c744.png)

위의 그림에는 7개의 데이터가 있는데 여기서 가상 데이터의 view를 포함하여 총 8개이다. 

선이 많이 연결되어 있고 중앙에 위치한 테이블이 핵심 테이블이다. Employee 사원 정보를 담고 있는 테이블이다. SALARY: 급여를 의미,  COMMISSION_PCT: 수당물을 의미, MANAGER_ID: 관리자ID

![8](https://user-images.githubusercontent.com/63957819/103893589-de9c5700-5130-11eb-9e8b-4e76c57abf22.png)

![9](https://user-images.githubusercontent.com/63957819/103893590-df34ed80-5130-11eb-893b-84afb94b009f.png)

개념→논리(엔터티타입, 엔터티, 어트리뷰트)→물리→구현(테이블, 행, 컬럼)

엔터티타입, 엔터티, 어트리뷰트가 있는데 물리적 모델을 통해서 구현이 되면 엔터티 타입이 테이블이고 엔터티는 행이고 어트리뷰트는 컬럼이다. EMPLOYEES안에는 여러 행이 있을 거다. 

한 행을 행 또는 로우라 부른다. 로우 하나를 논리 모델링에서는 엔터티라 부른다. 행을 구성하는 구성 요소는 컬럼이다.  employee_id, first_name, last_name 컬럼이 모여서 행을 이루는 것 이다. 

가끔씩 엔터티 타입을 생략해서 엔터티라 부르는 경우도 있으니 잘 문맥을 이해 해야 한다.

행과 레코드는 같은 말이다.  oracle에서 사용되는 자료형은 문자 형, 숫자 형, 날짜 형이 있다.

문자 타입은 크게 두개로 쪼개진다. 컬럼들의 자료형은 CHAR, VARCHAR2이 있다. 숫자 형 자료형은 NUMBER이고, 날짜 형은 DATE 자료형이다.  NUMBER(6,0) → 숫자 형 6개 자리를 확보하고 그 중에서  소수점 이하 자리수는 0개다라는 의미. → NUMBER(자리수, 소수점이하 자리수)

CHAR와 VARCHAR2의 차이점은 무엇일까? CHAR은 무조건 고정 길이이고 VARCHAR2 가변길이 문자형이다. VARCHAR2(40BYTE)는 최대 40byte까지 문자를 확보할 수 있다라는 의미이다.

컬럼별로 자료형들이 다르게 저장될 수 있다.

행은 저장하려는 하나의 개체(엔터티)를 구성하는 여러 값을 가로로 늘어뜨린 형태.

열은 저장하려는 데이터를 대표하는 이름과 공통 특성을 정의. 컬럼은 쪼갤 수 없는 데이터이며 원자성을 유지해야 한다.

키는 하나의 테이블 구성하는 여러 열 중에 특별한 의미를 구별할 수 있는 유일한 값.

기본키(Primary Key)는 다른 행과 구별해주는 식별자 역할을 하고 중복 값이 없어야 하며 null 즉 아무 값도 아닌 상태를 말한다. 값이 안보이면 null값인 것 이다. not null이 표현 안되어있으면 null값 일 수도 있고 아닐 수도 있다.

일반 칼럼에서는 중복된 값이 충분히 들어갈 수 있다.

보조키는 대체키라고도 부르며 후보키에 속해 있는 키이다.

employee_id, email은 후보키 또는 보조키, 대체키가 될 수 있다.

 부모 엔터티는 먼저 자료가 추가 되어야 하는 테이블, 자식 엔터티는 나중에 자료가 추가 되어야 하는 테이블. 부모 엔터티의 pk정보를 자식 엔터티에선 참조한다. 즉 자식이 부모를 참조하는 것이다.

![10](https://user-images.githubusercontent.com/63957819/103893592-df34ed80-5130-11eb-9081-2f3e6e302290.png)

Employees와 JOBS중 JOBS 테이블이 먼저 추가가 되어야 한다. 담당하는 직무가 먼저 추가가 되어야 사무원들이 직무를 할당 받아서 쓸 거다. JOBS테이블이 부모 엔터티, Employees테이블이 자식 엔터티 역할이다. Employees라는 자식이 Jobs라는 부모를 참조하는 거다. 

부모 테이블을 자식 테이블이 참조해야 하는데 없는 자료를 참조하면 안된다. 없는 자료를 참조하지 못하도록 설정한 것이 foreign key라 한다. 제약을 거는 이유? 자식 입장에서 올바른 값만 참조 될 수 있도록 하기 위함이다. 

복합키란 여러 컬럼이 pk로 구성되어 있는 것을  말한다.
 
