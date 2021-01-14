--������ �߰�
INSERT INTO customer(id, pwd, name, zipcode, addr1)
VALUES ('id2', 'p2', 'n2', '12345', '6��');

INSERT INTO customer(id, pwd, name)
VALUES ('id3', 'p3', 'n3');

INSERT INTO customer
VALUES ('id4', 'p4', 'n4', '12345', 'KOSTA');

INSERT INTO customer
VALUES ('id5', 'p5', 'n5', '', NULL);

--�� ���̺��� NULL�� ���Ե� ���¿��� NOT NULL �������� �߰��ȵ�! 
ALTER TABLE customer
MODIFY zipcode NOT NULL;

--�� ���̺��� �̹� ����� �ڷ��� �ڸ������� ���� �ڸ����� ���� �ȵ�!
ALTER TABLE customer
MODIFY addr1 VARCHAR2(3);

--������ ����
UPDATE customer
SET zipcode ='12345', addr1='���÷���' --������ �����Ҷ� ,�� �̿�
WHERE id = 'id1';

SELECT * FROM customer;

--������ ����
SELECT * FROM order_info; -- �ֹ��� ���̵� id1�� �־��� order_info���̺��� �ֹ��ھ��̵�order_id�� customer ���̵� �����ϰ������Ƿ� ����� ����������! �ڽ��� order_info���� �����ϰ��־��⶧���� 
--�ڽĿ���Ƽ���� �����Ǵ� �θ���Ƽ�� �����Ұ�!
DELETE customer
WHERE id LIKE '%1';

DELETE customer
WHERE id='id5';

-------------------------------------
--DML���� SUBQUERY���

--���̺� ���� �ٿ��ֱ�(����:customer, ���:customer_copy)
--���������� NOT NULL������ ���������� �ٿ��ֱ� �ȵ�
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


















