--����Ʈ ���̺� ���� --�⺻������ �����ϰ� �������� �����ϴ� ��
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

--������ �߰��ɶ����� ����Ʈ�൵ �ڵ� �߰��Ǵ� Ʈ���� ����
CREATE OR REPLACE TRIGGER trg_insert_customer
    AFTER INSERT ON customer
    FOR EACH ROW
BEGIN
    INSERT INTO point(id) VALUES ( :NEW.id );
END;

--���� �߰�
INSERT INTO customer(id, pwd, name) VALUES ('id9', 'p9', 'n9');
SELECT * FROM customer;
SELECT * FROM point;

--Ʈ���� ����: 
--�ֹ��⺻(order_info)�� �߰��ɶ����� ����Ʈ(point)���� ����(score)�� �ڵ� 1���� ����
--Ʈ���Ÿ�: trg_order_info
CREATE OR REPLACE TRIGGER trg_order_info
    AFTER INSERT ON order_info
    FOR EACH ROW
BEGIN
    UPDATE point SET score = score + 1 WHERE id = :NEW.order_id;
END;
--�ֹ��⺻�� �߰�
INSERT INTO order_info(order_no, order_id) VALUES (999, 'id1');
SELECT * FROM order_info;
SELECT * FROM point;




