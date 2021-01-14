--데이터 추가
INSERT INTO customer(id, pwd, name, zipcode, addr1)
VALUES ('id2', 'p2', 'n2', '12345', '6층');

INSERT INTO customer(id, pwd, name)
VALUES ('id3', 'p3', 'n3');

INSERT INTO customer
VALUES ('id4', 'p4', 'n4', '12345', 'KOSTA');

INSERT INTO customer
VALUES ('id5', 'p5', 'n5', '', NULL);

--고객 테이블의 NULL값 포함된 상태에서 NOT NULL 제약조건 추가안됨! 
ALTER TABLE customer
MODIFY zipcode NOT NULL;

--고객 테이블의 이미 저장된 자료의 자릿수보다 작은 자리수로 변경 안됨!
ALTER TABLE customer
MODIFY addr1 VARCHAR2(3);

--데이터 수정
UPDATE customer
SET zipcode ='12345', addr1='유플렉스' --여러개 나열할때 ,로 이용
WHERE id = 'id1';

SELECT * FROM customer;

--데이터 삭제
SELECT * FROM order_info; -- 주문자 아이디가 id1이 있었다 order_info테이블의 주문자아이디order_id가 customer 아이디에 참조하고있으므로 지우면 에러가난다! 자식인 order_info에서 참조하고있었기때문에 
--자식엔터티에서 참조되는 부모엔터티는 삭제불가!
DELETE customer
WHERE id LIKE '%1';

DELETE customer
WHERE id='id5';

-------------------------------------
--DML에서 SUBQUERY사용

--테이블 복사 붙여넣기(원본:customer, 대상본:customer_copy)
--제약조건중 NOT NULL제외한 제약조건은 붙여넣기 안됨
CREATE TABLE customer_copy
AS SELECT * FROM customer WHERE id IN ('id1', 'id2', 'id3');

INSERT INTO customer_copy
    SELECT * FROM customer WHERE id='id4';

SELECT * FROM customer_copy;

UPDATE customer_copy
SET name='AAA', addr1=(SELECT addr1 FROM customer WHERE id='id1');

DELETE customer_copy
WHERE id = (SELECT id FROM customer WHERE name='n2');

SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM order_info;
SELECT * FROM order_line;

SELECT * FROM customer;

INSERT INTO customer(id, pwd, name) VALUES ('id7', 'p7', 'n7');


















