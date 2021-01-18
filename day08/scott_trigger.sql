--포인트 테이블 생성 --기본값먼저 설정하고 제약조건 설정하는 것
CREATE TABLE point(
    id VARCHAR2(5) PRIMARY KEY,
    score NUMBER(5) DEFAULT 0 NOT NULL,
    CONSTRAINT point_id_fk FOREIGN KEY(id) REFERENCES customer(id));

INSERT INTO point(id, score) VALUES ('id1', 0);
INSERT INTO point(id) VALUES ('id2');
INSERT INTO point(id) VALUES ('id3');
INSERT INTO point(id) VALUES ('id4');
INSERT INTO point(id) VALUES ('id5');
INSERT INTO point(id) VALUES ('id6');
INSERT INTO point(id) VALUES ('id7');

commit;

--고객행이 추가될때마다 포인트행도 자동 추가되는 트리거 생성
CREATE OR REPLACE TRIGGER trg_insert_customer
    AFTER INSERT ON customer
    FOR EACH ROW
BEGIN
    INSERT INTO point(id) VALUES ( :NEW.id );
END;

--고객행 추가
INSERT INTO customer(id, pwd, name) VALUES ('id9', 'p9', 'n9');
SELECT * FROM customer;
SELECT * FROM point;

--트리거 생성: 
--주문기본(order_info)행 추가될때마다 포인트(point)행의 점수(score)가 자동 1점씩 누적
--트리거명: trg_order_info
CREATE OR REPLACE TRIGGER trg_order_info
    AFTER INSERT ON order_info
    FOR EACH ROW
BEGIN
    UPDATE point SET score = score + 1 WHERE id = :NEW.order_id;
END;
--주문기본행 추가
INSERT INTO order_info(order_no, order_id) VALUES (999, 'id1');
SELECT * FROM order_info;
SELECT * FROM point;




