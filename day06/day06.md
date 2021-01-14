# day06

![1](https://user-images.githubusercontent.com/63957819/104623648-ee3e1180-56d5-11eb-80a8-906d49bcc42b.png)

사원 테이블이 기준 부족한 쪽에 부서 테이블 왼쪽에 기준을 삼고 싶다 하면 Left outer, 오른쪽에 기준을 삼고 싶다 하면 Right outer, 양쪽 테이블에 부족한 정보를 채우고 싶다면 full outer

Self Join는 자기 테이블을 자기가 참조하는 관계를 말한다. 매니저 아이디가 사원 아이디를 참조하도록 구성되어 있는 구조이다. 이런 것을 자기 참조 관계라 한다. Self Join은 employees 사원 테이블을 사원 입장, 매니저 입장에서도 바라 볼 수 있다. 물리적 테이블은 한 개이지만 논리적 테이블을 두 개인 것처럼 하는 것이다.

Join은 동시에 여러 테이블을 검색하는 절차를 한다. 그에 비해 서브 쿼리는 여러 테이블을 순서를 받고 처리되는 검색 방법이다.

![2](https://user-images.githubusercontent.com/63957819/104623653-ef6f3e80-56d5-11eb-8033-a248daeb623f.png)

서브 쿼리가 먼저 처리가 된다. 서브 쿼리 결과 값이 한 개의 행만 반환 되는 경우, 여러 행으로 반환 되는 경우로 나눈다 했다. 이 예제는 단일 행을 반환한다. sales부서를 받는 행은 단 하나밖에 없기 때문이다. 일반 비교 연산자로 메인 쿼리와 비교할 수 있다. sales부서와 같은 부서 아이디를 갖는 결과가 메인 쿼리에 반환 된다. 

메인 쿼리 WHERE절에 서브 쿼리가 올 수 있고, FROM절에 서브 쿼리는 인라인 뷰, SELECT절에 서브 쿼리는 스칼라 서브 쿼리라 한다. EXISTS에는 상호 연관 서브 쿼리에서 쓰인다.

메인 쿼리의 테이블을 서브 쿼리에서 사용하는 것을 상호 연관 서브 쿼리라 한다.

NOT IN연산을 쓸 때 NULL값을 포함하고 있으면 NULL값을 반환한다.

---

## 데이터 정의어란?

객체를 만들거나 기존 객체의 구조를 변경하거나 삭제하는 등의 기능을 수행 하는 명령어를 데이터 정의어라 한다.

> **테이블을 생성하는 CREATE**

**CREATE TABLE** 소유 계정 테이블 이름(  //계정 명은 생략 가능

열1 이름 열1 자료형,

열2 이름 열2 자료형,

...

열N 이름 열N 자료형

);

**테이블 이름 생성 규칙**

1.테이블 이름은 문자로 시작해야 한다.

2.테이블 이름은 30byte이하

3.같은 사용자 소유의 테이블 이름 중복(X)

4.테이블 이름은 영문자, 숫자, 특수 문자($, #, _) 사용 가능

5.SQL 키워드는 테이블 이름으로 사용(X)

컬럼명은 문자로 시작해야 하고 동사가 아닌 명사로 만들어야 한다.

자료형도 컬럼명으로 쓰면 안된다.

DESC는 테이블의 구조를 확인할 때 쓰는 명령어이다.

PK의 구조는 복사 붙여 넣기 될 거고 FK의 제약 조건은 복사 붙여 넣기 되지 않는다.

> **테이블을 변경하는 ALTER**

테이블 구조를 바꾸는 거지 데이터를 바꾸는 게 아니다!!

-테이블에 열 추가하는 ADD

-열 이름을 변경하는 RENAME

-열의 자료형을 변경하는 MODIFY

-특정 열을 삭제할 때 사용하는 DROP

**주의 ⇒ RENAME 컬럼, DROP컬럼

> **테이블 이름을 변경하는 RENAME**

테이블 이름을 변경할 때 사용

> **테이블의 데이터를 삭제하는 TRUNCATE**

데이터만 삭제, 테이블의 자료만 삭제한다.

> **테이블을 삭제하는 DROP**

테이블 자체를 삭제한다. 그 안에 자료도 같이 삭제가 된다.

- scott_ddl.sql

```sql
--테이블 제거: customer테이블 제거
DROP TABLE customer;

-------------------------------------
--고객(customer)테이블 생성.   -->테이블 이름(customer, member, user) 중에 user는 예약어이므로 테이블 명으로 적합하지 않다.
CREATE TABLE customer(
 id VARCHAR2(5), --id가 항상 고정된 자리수로 만들고싶다면 CHAR, 최대자리수까지 제한없이 쓰도록 하려면 VACHAR2타입을 쓰는게 좋다 --자료형이 number가 되면 0...id의 첫 글자가 0이 될 수 없다.
 pwd VARCHAR2(5),
 name VARCHAR2(15) --()안에 숫자는 바이트 수이다. 
);

DESC customer;

-------------------------------------
--테이블 구조변경
--컬럼추가 : zipcode CHAR(5)    --우편번호는 항상 고정된 자릿수
ALTER TABLE customer
ADD zipcode CHAR(5); --가장 끝에 컬럼이 추가된 것을 볼 수 있다.

--컬럼추가: addr VARCHAR2(10)
ALTER TABLE customer
ADD addr VARCHAR2(10);

--컬럼이름 바꾸기 : addr컬럼 이름을 addr1로 바꾸기
ALTER TABLE customer
RENAME COLUMN addr TO addr1;

--컬럼자료형 또는 길이 변경하기 : addr1 컬럼의 길이를 30으로 변경
ALTER TABLE customer
MODIFY addr1 VARCHAR2(30);

--컬럼제거하기
ALTER TABLE customer
ADD test number;

ALTER TABLE customer
DROP COLUMN test;

-------------------------------------
--고객 자료 추가 : 정상자료
INSERT INTO customer(id, pwd, name) VALUES ('id1','p1','n1');

--고객조회
SELECT * FROM customer;

--고객 자료 추가 : 비정상자료
INSERT INTO customer(id, pwd, name) VALUES ('id1','p1','n1');
SELECT * FROM customer; --id1고객이 2명 -->옳지않은 데이터 즉 규격에 맞지않는 데이터이다.

--고객 자료 삭제
DELETE FROM customer WHERE id='id1';

-------------------------------------
--제약조건 설정하기
--1.PRIMARY KEY : NOT NULL + UNIQUE
ALTER TABLE customer 
ADD CONSTRAINT customer_id_pk PRIMARY KEY(id); --id의 pk를 PRIMARY KEY로 설정

--고객 자료 추가 : 정상자료
INSERT INTO customer(id, pwd, name) VALUES ('id1','p1','n1');

--고객 자료 추가 : 비정상자료: 아이디 중복
INSERT INTO customer(id, pwd, name) VALUES ('id1','p1','n1'); --ERROR발생
SELECT * FROM customer; --1건만 정상되어있고 pk중복값이 추가되어있지 않다.

--고객 자료 추가 : 비정상자료: 아이디NULL
INSERT INTO customer(id, pwd, name) VALUES (null,'p1','n1'); --ERROR발생
INSERT INTO customer(id, pwd, name) VALUES ('','p1','n1'); --ERROR발생

--2.NOT NULL 제약조건
--고객 자료 추가 : 비정상자료 : 비번 NULL
INSERT INTO customer(id, pwd, name) VALUES ('id2','','n1'); -- ERROR가 안난다...성공되지 못하게 해야한다.
DELETE FROM customer WHERE id='id2';

--NOT NULL 제약조건
ALTER TABLE customer 
MODIFY pwd NOT NULL;
--고객 자료 추가 : 비정상자료 : 비번 NULL
INSERT INTO customer(id, pwd, name) VALUES ('id2','','n1'); --ERROR!
DELETE FROM customer WHERE id='id2';

--3.FOREGIN KYE 제약조건 : 부모엔터티의 PK를 자식엔터티에서 참조. --부모(고객)의 PK를 자식(주문)에서 참조해야하므로 고객이(부모) 먼저 자료가 추가되어있어야된다 foreing키는 자식쪽에서 설정해줘야한다.
--주문테이블생성: order_info
CREATE TABLE order_info(
order_no NUMBER,
order_id VARCHAR2(5),
order_dt DATE);

--주문 자료 추가 : 비정상자료 : 고객에 없는 id999를 추가
INSERT INTO order_info (order_no, order_id, order_dt)
VALUES (1, 'id999', SYSDATE); --OK 그러나 이 자료에는 옳지 않은 값이 들어있다. 주문자 아이디가 고객 테이블에는 id1이 id999는 존재하지 않다. 즉 고객이 추가돼야 주문가능! 그러므로 비정상 자료
DELETE FROM order_info WHERE order_no=1;

ALTER TABLE order_info
ADD CONSTRAINT order_info_id_fk FOREIGN KEY (order_id) REFERENCES customer(id);
--주문 자료 추가 : 비정상자료 : 고객에 없는 id999를 추가
INSERT INTO order_info (order_no, order_id, order_dt)
VALUES (1, 'id999', SYSDATE);--ERROR 

--4.CHECK제약조건 : 값의 범위, 종류
--고객 자료 추가 : 비정상자료 : 비번이 1자리인 경우
INSERT INTO customer(id,pwd, name) VALUES('id2', 'p', 'n1'); --OK
DELETE FROM customer WHERE id='id2';
ALTER TABLE customer
ADD CONSTRAINT customer_pwd_ck CHECK (LENGTH(pwd) > 1);
--고객 자료 추가 : 비정상자료 : 비번이 1자리인 경우
INSERT INTO customer(id,pwd, name) VALUES('id2', 'p', 'n1'); --ERROR!

-------------------------------------
--상품테이블 제거
DROP TABLE product;

--테이블을 생성하면서 제약조건을 같이 설정 그때 컬럼레벨로 테이블레벨로 제약조건을 설정 할 수 있다. 이미 테이블이 만들어져있으면 ALTER TABLE을 이용해서 추가하는 방법이 있다.
--상품테이블 생성 : product
CREATE TABLE product(
 prod_no VARCHAR2(5) CONSTRAINT product_no_pk PRIMARY KEY, --컬럼레벨 제약조건 설정
 prod_name VARCHAR2(50) NOT NULL, --NOT NULL 제약조건은 반드시 컬럼레벨로만 설정, CONSTRAINT product_name_nn 생략가능
 prod_price NUMBER(7),
 CONSTRAINT product_price_ck CHECK (prod_price >= 0) --테이블레벨 제약조건
);

-------------------------------------
--주문상세 기본 테이블의 order_no컬럼에 PRIMARY KEY제약조건 추가
ALTER TABLE order_info
ADD CONSTRAINT order_info_no_pk PRIMARY KEY(order_no);

--주문상세 기본 테이블의 order_id에 NOT NULL제약조건 추가
ALTER TABLE order_info
MODIFY order_id NOT NULL; 

-------------------------------------
--주문상세테이블 생성: order_line
CREATE TABLE order_line(
order_no NUMBER,
order_prod_no VARCHAR2(5) NOT NULL,
order_quantity NUMBER(2) NOT NULL,
--테이블레벨 제약조건설정
CONSTRAINT order_line_no_prod_no_pk PRIMARY KEY (order_no, order_prod_no),
CONSTRAINT order_ilne_order_no_fk
 FOREIGN KEY (order_no) REFERENCES order_info(order_no),
CONSTRAINT order_ilne_prod_no_fk
 FOREIGN KEY (order_prod_no) REFERENCES product(prod_no),
CONSTRAINT order_line_quantity_ck CHECK (order_quantity > 0)
);

-------------------------------------
--DEFAULT : 기본값 설정, 설정 안하면 NULL이 기본값이 됨
ALTER TABLE order_info
MODIFY order_dt DEFAULT SYSDATE; --오늘 날짜값이 기본값이 된다.

INSERT INTO order_info (order_no, order_id) VALUES (2, 'id1'); --주문일자는 default로 지정한 날짜가 출력된다.

SELECT * fROM order_info;

```

sqlplus로가자 cmd창을 띄어보자

```sql
D:\>cd D:\CYM\MySQL\day06
dir
D:\CYM\MySQL\day06>sqlplus scott/tiger
SQL> @scott_ddl  --sql파일을 load
```

![3](https://user-images.githubusercontent.com/63957819/104623654-ef6f3e80-56d5-11eb-936b-346b234526de.png)

sqldeveloper에 들어가 보면 다시 만들어진 것을 볼 수 있다.

## 제약 조건이란?

제약 조건을 지정한 열에 제약 조건에 부합하지 않는 데이터를 저장할 수 없다.

제약 조건 지정방식에따라기존 데이터의 수정이나 삭제 가능 여부도 영향을 받는다.

**NOT NULL** : 지정한 열에 NULL을 허용(X). NULL을 제외한 데이터의 중복을 허용

**UNIQUE** : 지정한 열이 유일한 값을 가져야 한다. 즉 중복(X), 단 NULL은 값의 중복에서 제외

**PRIMARY KEY** : NOT NULL + UNIQUE 제약조건 효과

**FOREIGN KEY** : 다른 테이블의 열을 참조하여 존재하는 값만 입력

**CHECK** : 설정한 조건식을 만족하는 데이터만 입력 가능

빈값이란 공백이 아니라 NULL을 의미
컬럼 이름 변경할 때는 RENAME, 제약 조건에 이름 변경할 때는 RENAME CONSTRAINT
컬럼을 제거할 때는 DROP, 제약 조건을 삭제할 때는 DROP CONSTRAINT

### FOREIGN KEY 지정하기

1.**컬럼레벨 제약조건**

CREATE TABLE 테이블 이름(

...(다른 열 정의),

열 자료형 CONSTRAINT [제약 조건 이름] REFERENCES 참조 테이블(참조할 열)

);

2.**테이블레벨 제약조건**

CREATE TABLE 테이블 이름(

...(다른 열 정의),

CONSTRAINT [제약 조건 이름] FOREIGN KEY(열)

REFERENCES 참조 테이블(참조할 열)

);

> **기본값을 정하는 DEFAULT**

제약 조건과는 별개로 특정 열에 저장할 값이 지정되지 않았을 경우에 기본값을 지정

## 데이터를 추가, 수정, 삭제하는 데이터 조작어

> **테이블에 데이터를 추가하는 INSERT문**

INSERT INTO 테이블 이름 [(열1, 열2, ... , 열N)]   — 여기서 [(대괄호)의 의미는 생략가능

VALUES (열1에 들어갈 데이터, 열2에 들어갈 데이터, ... , 열N에 들어갈 데이터);

> **테이블에 있는 데이터 수정하기 UPDATE문**

UPDATE문의 기본 사용법

UPDATE [변경할 테이블]

SET        [변경할 열1]=[데이터], [변경할 열2]=[데이터], ..., [변경할 열n]=[데이터]

[WHERE 데이터를 변경할 대상 행을 선별하기 위한 조건];

> **테이블에 있는 데이터 삭제하기 DELETE문**

DELETE문은 테이블에 있는 데이터를 삭제할 때 사용

DROP테이블은 테이블 자체를 날리는거다. 
TRUNCATE테이블을 자료를 제거하는 거다→트렌잭션이 자동 완료

DELETE [FROM] [테이블 이름]

[WHERE 삭제할 대상 행을 선별하기 위한 조건식];

![4](https://user-images.githubusercontent.com/63957819/104623657-f007d500-56d5-11eb-92e8-3d6a18de4ac0.png)

옳지 않은 자료를 추가할 때 제약조건 이름이 나타면서 id,pk에 문제가 있는거구나 라고 생각하면 된다.   계정명.제약조건이름

![5](https://user-images.githubusercontent.com/63957819/104623658-f0a06b80-56d5-11eb-9024-aceb49808fce.png)

제약조건 이름이 보이지 않는다. 제약조건 이름을 굳이 안 줘도 된다. 이유는? 제약조건 이름이 보이는게 아니라 NULL값이 들어왔다는 오류 메시지가 보이기 때문에 설정할 필요는 없다.

![6](https://user-images.githubusercontent.com/63957819/104623660-f0a06b80-56d5-11eb-9f78-6d5efe4523ab.png)

테이블 줄 때에는  컬럼명 다음에 자료형을 결정 자료형 다음에 기본값이 필요하다면 기본값을 설정 할 수 있고 생략이 가능하다. [DEFAULT 'test']  [CONSTRAINT 제약조건명 제약조건 종류]

이런 표현 방법을 컬럼레벨 제약 조건이라 한다.

NOT NULL제약조건은 굳이 쓸 필요 없다.

기존에 테이블이 있으면 DROP TABLE로 제거하면 된다.

![7](https://user-images.githubusercontent.com/63957819/104623663-f1390200-56d5-11eb-99f8-5e52982cadf5.png)

기존에 정보가 다 되어있는 곳 에다 제약조건을 추가하는 거기 때문에 ADD CONSTARINT로 제약조건을 추가

NOT NULL은 컬럼레벨로만 제약조건을 추가하는 것이므로 이미 테이블이 만들어져 있으면 추가하지 못하고 MODIFY로 컬럼레벨을 변경하는 것 이다. 

![8](https://user-images.githubusercontent.com/63957819/104623668-f1390200-56d5-11eb-89f4-fc7c5e921e05.png)

order_linedl order-info하고 product 테이블을 참조할 거다. 

order_line 테이블이 갖고 있는 order_no는 pk역할을 하고 primary제약조건을 갖고 있고

order-info 테이블에도 order-no pk를 가지고 있을 거다. pk들 사이에서도 참조를 할 수 있다.

order_line 테이블이 order_info로 참조할 수 있게 order_line테이블에는 order_prod_no 컬럼이 있고 pk로 참여... pk가 여러 컬럼으로 구성되어 있는 거를 복합키라 한다.  order_prod_no가 product테이블에 prod_no를 참조

order_line 테이블이 자식 쪽으로 fk키로 각각 참조를 할 거다. order_quantity는 음수가 되면 안된다. 주문 수량에 관련 조건은 check로 설정하는데 조건은 0보다 크게 설정을 해야 한다. 이런 제약 조건을 테이블 레벨 제약 조건으로 만들자

![9](https://user-images.githubusercontent.com/63957819/104623669-f1d19880-56d5-11eb-8ac5-94684dbd6b27.png)

상품이 먼저 등록(INSERT)이 되어 있어야 주문을 할 수 있는 거다. 상세 주문을 할 때 Order_line에 들어갈 수 있는 거다. 다른 것이 들어갈 수 있으므로 fk로 지정

테이블레벨로만 만들어야 한다. 주문 번호와 주문 상세 테이블에 order_no가 있는데 둘 다 같은 값으로 채워진다.

- scott_dml.sql

```sql
--데이터 추가
INSERT INTO customer(id, pwd, name, zipcode, addr1)
VALUES ('id2', 'p2', 'n2', '12345', '6층');

INSERT INTO customer(id, pwd, name)
VALUES ('id3', 'p3', 'n3');  --default설정 되어있지 않는 zipxode, addr1은 null값으로 출력

INSERT INTO customer
VALUES ('id4', 'p4', 'n4', '12345', 'KOSTA');

INSERT INTO customer
VALUES ('id5', 'p5', 'n5', '', NULL);

--고객 테이블의 NULL값 포함된 상태에서 NOT NULL 제약조건 추가안됨! 
ALTER TABLE customer
MODIFY zipcode NOT NULL;--(X) --자리수 늘리는거는 관계없으나 이미 NULL값이 들어있는 컬럼 상태에서 테이블 구조를 변경한다? 논리적 문제가 있다 제약조건 설정이 안된다.

--고객 테이블의 이미 저장된 자료의 자릿수보다 작은 자리수로 변경 안됨!
ALTER TABLE customer
MODIFY addr1 VARCHAR2(3); --이미 위에 5자리로 추가 되어있는 상태에서 자릿수를 작게 만들면 불가!

--데이터 수정
UPDATE customer
SET zipcode = '12345', addr1='유플렉스' --여러개 나열할때 ,로 이용
WHERE id = 'id1'; --WHERE이 없으면 모든행을 다 바꿔버리므로 주의!

SELECT * FROM customer;

--데이터 삭제
SELECT * FROM order_info; -- 주문자 아이디가 id1이 있었다 order_info테이블의 주문자아이디order_id가 customer 아이디에 참조하고있으므로 지우면 에러가난다! 자식인 order_info에서 참조하고있었기때문에 
--자식엔터티에서 참조되는 부모엔터티는 삭제불가!
DELETE customer --테이블의 자료가 다 삭제되는거니까 주의!!
WHERE id LIKE '%1%';--(X) --1을 포함하고있는 모든 고객을 삭제 자식이 참조하고있는데 부모를 삭제할수있다? 말이 안된다

DELETE customer
WHERE id='id5'; --(O) 주문 테이블과 연결이 안되어있으므로 가능
------------------------------------------
--DML에서 SUBQUERY사용

--테이블 복사 붙여넣기(원본:customer, 대상본:customer_copy)
--제약조건중 NOT NULL제외한 제약조건은 붙여넣기 안됨
CREATE TABLE customer_copy
AS SELECT * FROM customer WHERE id IN ('id1', 'id2', 'id3'); 

INSERT INTO customer_copy
    SELECT * FROM customer WHERE id='id4'; --원본인 customer테이블의 id4를 찾아서 customer_copy테이블에 붙여넣기를해라

SELECT * FROM customer_copy; --id1, id2, id3,id4

UPDATE customer_copy
SET name='AAA', addr1=(SELECT addr1 FROM customer WHERE id='id1');
SELECT * FROM customer_copy; --AAA, 유플렉스

DELETE customer_copy --delete에서는 from절 생략가능
WHERE id = (SELECT id FROM customer WHERE name= 'n2');
SELECT * FROM customer_copy; --id1, id3, id4
------------------------------------------
SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM order_info;
SELECT * FROM order_line;

SELECT * FROM customer;

INSERT INTO customer(id, pwd, name) VALUES ('id7', 'p7', 'n7');
```

출력 결과>>

![10](https://user-images.githubusercontent.com/63957819/104623671-f1d19880-56d5-11eb-96ed-afc27d8de4dc.png)

![11](https://user-images.githubusercontent.com/63957819/104623674-f26a2f00-56d5-11eb-84ea-118a4035d812.png)

![12](https://user-images.githubusercontent.com/63957819/104623675-f302c580-56d5-11eb-8bcf-3c351e18127a.png)

![13](https://user-images.githubusercontent.com/63957819/104623677-f39b5c00-56d5-11eb-94d2-ad563a449423.png)

sqldeveloper 또 하나 띄어서 접속 해보자 Localscott 더블 클릭

## **트랜잭션이란?**

예를들어 계좌이체 1, 2번 작업 중에 뭐라도 틀렸으면 원 상태로 복구해야 한다. 없었던 일처럼 복구해야 한다.  원 상태로 복구 시키는 방법(rollback)이랑 성공을 시키는 방법(commit) 두 가지가 있다

![14](https://user-images.githubusercontent.com/63957819/104623680-f39b5c00-56d5-11eb-91f8-819993edab6d.png)

트랜잭션이 자동 시작이 된다. 트랜잭션이 완료가 되는데, DML은 자동 완료가 안된다. DDL구문은 트랜잭션이 자동 완료가 된다. 즉 DB에 반영이 된다.

DML은 반드시 실행 후에 트랜잭션의 완료를 알리는 성공 명령어를 써주거나 복구 관련된 롤백 명령어를 써줘야 한다.

```sql
C:\Users\KOSTA>sqlplus scott/tiger
SQL> INSERT INTO customer(id, pwd, name) VALUES ('id5', 'p5', 'n5');
SQL> INSERT INTO customer(id, pwd, name) VALUES ('id6', 'p6', 'n6');
SQL> commit;
SQL> select * from customer;
```

첫 번째, 두 번째에서 INSERT한 작업이 같은 트랜잭션이 이루어진 거다. 트랜잭션이 각각 만들어지는게 아니다 한 트랜잭션이 INSERT구문이 두 번 실행 된 거다. 같은 트랜잭션에서의 작업이라 보면 된다. 실제DB반영하기 위해 commit을 해줘야 한다.

![15](https://user-images.githubusercontent.com/63957819/104623681-f433f280-56d5-11eb-8093-70ff5b8df8cc.png)

sqldeveloper에서 제대로 출력 된 걸 볼 수 있다.

![16](https://user-images.githubusercontent.com/63957819/104623682-f433f280-56d5-11eb-8e81-bd156d140371.png)

sqldeveloper에서 id7번 추가 해보자

![17](https://user-images.githubusercontent.com/63957819/104623684-f4cc8900-56d5-11eb-8f6a-a45d7120136f.png)

sqlplus로 들어가서 보면  sqldevleoper에서 추가한 id7번 고객을 볼 수 없다.
