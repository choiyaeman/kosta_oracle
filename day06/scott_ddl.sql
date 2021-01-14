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

