--���̺� ����: customer���̺� ����
DROP TABLE customer;

-------------------------------------
--��(customer)���̺� ����.   -->���̺� �̸�(customer, member, user) �߿� user�� ������̹Ƿ� ���̺� ������ �������� �ʴ�.
CREATE TABLE customer(
 id VARCHAR2(5), --id�� �׻� ������ �ڸ����� �����ʹٸ� CHAR, �ִ��ڸ������� ���Ѿ��� ������ �Ϸ��� VACHAR2Ÿ���� ���°� ���� --�ڷ����� number�� �Ǹ� 0...id�� ù ���ڰ� 0�� �� �� ����.
 pwd VARCHAR2(5),
 name VARCHAR2(15) --()�ȿ� ���ڴ� ����Ʈ ���̴�. 
);

DESC customer;

-------------------------------------
--���̺� ��������
--�÷��߰� : zipcode CHAR(5)    --�����ȣ�� �׻� ������ �ڸ���
ALTER TABLE customer
ADD zipcode CHAR(5); --���� ���� �÷��� �߰��� ���� �� �� �ִ�.

--�÷��߰�: addr VARCHAR2(10)
ALTER TABLE customer
ADD addr VARCHAR2(10);

--�÷��̸� �ٲٱ� : addr�÷� �̸��� addr1�� �ٲٱ�
ALTER TABLE customer
RENAME COLUMN addr TO addr1;

--�÷��ڷ��� �Ǵ� ���� �����ϱ� : addr1 �÷��� ���̸� 30���� ����
ALTER TABLE customer
MODIFY addr1 VARCHAR2(30);

--�÷������ϱ�
ALTER TABLE customer
ADD test number;

ALTER TABLE customer
DROP COLUMN test;

-------------------------------------
--�� �ڷ� �߰� : �����ڷ�
INSERT INTO customer(id, pwd, name) VALUES ('id1','p1','n1');

--����ȸ
SELECT * FROM customer;

--�� �ڷ� �߰� : �������ڷ�
INSERT INTO customer(id, pwd, name) VALUES ('id1','p1','n1');
SELECT * FROM customer; --id1���� 2�� -->�������� ������ �� �԰ݿ� �����ʴ� �������̴�.

--�� �ڷ� ����
DELETE FROM customer WHERE id='id1';

-------------------------------------
--�������� �����ϱ�
--1.PRIMARY KEY : NOT NULL + UNIQUE
ALTER TABLE customer 
ADD CONSTRAINT customer_id_pk PRIMARY KEY(id); --id�� pk�� PRIMARY KEY�� ����

--�� �ڷ� �߰� : �����ڷ�
INSERT INTO customer(id, pwd, name) VALUES ('id1','p1','n1');

--�� �ڷ� �߰� : �������ڷ�: ���̵� �ߺ�
INSERT INTO customer(id, pwd, name) VALUES ('id1','p1','n1'); --ERROR�߻�
SELECT * FROM customer; --1�Ǹ� ����Ǿ��ְ� pk�ߺ����� �߰��Ǿ����� �ʴ�.

--�� �ڷ� �߰� : �������ڷ�: ���̵�NULL
INSERT INTO customer(id, pwd, name) VALUES (null,'p1','n1'); --ERROR�߻�
INSERT INTO customer(id, pwd, name) VALUES ('','p1','n1'); --ERROR�߻�

--2.NOT NULL ��������
--�� �ڷ� �߰� : �������ڷ� : ��� NULL
INSERT INTO customer(id, pwd, name) VALUES ('id2','','n1'); -- ERROR�� �ȳ���...�������� ���ϰ� �ؾ��Ѵ�.
DELETE FROM customer WHERE id='id2';

--NOT NULL ��������
ALTER TABLE customer 
MODIFY pwd NOT NULL;
--�� �ڷ� �߰� : �������ڷ� : ��� NULL
INSERT INTO customer(id, pwd, name) VALUES ('id2','','n1'); --ERROR!
DELETE FROM customer WHERE id='id2';

--3.FOREGIN KYE �������� : �θ���Ƽ�� PK�� �ڽĿ���Ƽ���� ����. --�θ�(��)�� PK�� �ڽ�(�ֹ�)���� �����ؾ��ϹǷ� ����(�θ�) ���� �ڷᰡ �߰��Ǿ��־�ߵȴ� foreingŰ�� �ڽ��ʿ��� ����������Ѵ�.
--�ֹ����̺����: order_info
CREATE TABLE order_info(
order_no NUMBER,
order_id VARCHAR2(5),
order_dt DATE);

--�ֹ� �ڷ� �߰� : �������ڷ� : ���� ���� id999�� �߰�
INSERT INTO order_info (order_no, order_id, order_dt)
VALUES (1, 'id999', SYSDATE); --OK �׷��� �� �ڷῡ�� ���� ���� ���� ����ִ�. �ֹ��� ���̵� �� ���̺��� id1�� id999�� �������� �ʴ�. �� ���� �߰��ž� �ֹ�����! �׷��Ƿ� ������ �ڷ�
DELETE FROM order_info WHERE order_no=1;

ALTER TABLE order_info
ADD CONSTRAINT order_info_id_fk FOREIGN KEY (order_id) REFERENCES customer(id);
--�ֹ� �ڷ� �߰� : �������ڷ� : ���� ���� id999�� �߰�
INSERT INTO order_info (order_no, order_id, order_dt)
VALUES (1, 'id999', SYSDATE);--ERROR 

--4.CHECK�������� : ���� ����, ����
--�� �ڷ� �߰� : �������ڷ� : ����� 1�ڸ��� ���
INSERT INTO customer(id,pwd, name) VALUES('id2', 'p', 'n1'); --OK
DELETE FROM customer WHERE id='id2';
ALTER TABLE customer
ADD CONSTRAINT customer_pwd_ck CHECK (LENGTH(pwd) > 1);
--�� �ڷ� �߰� : �������ڷ� : ����� 1�ڸ��� ���
INSERT INTO customer(id,pwd, name) VALUES('id2', 'p', 'n1'); --ERROR!

-------------------------------------
--��ǰ���̺� ����
DROP TABLE product;

--���̺��� �����ϸ鼭 ���������� ���� ���� �׶� �÷������� ���̺����� ���������� ���� �� �� �ִ�. �̹� ���̺��� ������������� ALTER TABLE�� �̿��ؼ� �߰��ϴ� ����� �ִ�.
--��ǰ���̺� ���� : product
CREATE TABLE product(
 prod_no VARCHAR2(5) CONSTRAINT product_no_pk PRIMARY KEY, --�÷����� �������� ����
 prod_name VARCHAR2(50) NOT NULL, --NOT NULL ���������� �ݵ�� �÷������θ� ����, CONSTRAINT product_name_nn ��������
 prod_price NUMBER(7),
 CONSTRAINT product_price_ck CHECK (prod_price >= 0) --���̺��� ��������
);

-------------------------------------
--�ֹ��� �⺻ ���̺��� order_no�÷��� PRIMARY KEY�������� �߰�
ALTER TABLE order_info
ADD CONSTRAINT order_info_no_pk PRIMARY KEY(order_no);

--�ֹ��� �⺻ ���̺��� order_id�� NOT NULL�������� �߰�
ALTER TABLE order_info
MODIFY order_id NOT NULL; 

-------------------------------------
--�ֹ������̺� ����: order_line
CREATE TABLE order_line(
order_no NUMBER,
order_prod_no VARCHAR2(5) NOT NULL,
order_quantity NUMBER(2) NOT NULL,
--���̺��� �������Ǽ���
CONSTRAINT order_line_no_prod_no_pk PRIMARY KEY (order_no, order_prod_no),
CONSTRAINT order_ilne_order_no_fk
 FOREIGN KEY (order_no) REFERENCES order_info(order_no),
CONSTRAINT order_ilne_prod_no_fk
 FOREIGN KEY (order_prod_no) REFERENCES product(prod_no),
CONSTRAINT order_line_quantity_ck CHECK (order_quantity > 0)
);

-------------------------------------
--DEFAULT : �⺻�� ����, ���� ���ϸ� NULL�� �⺻���� ��
ALTER TABLE order_info
MODIFY order_dt DEFAULT SYSDATE; --���� ��¥���� �⺻���� �ȴ�.

INSERT INTO order_info (order_no, order_id) VALUES (2, 'id1'); --�ֹ����ڴ� default�� ������ ��¥�� ��µȴ�.

SELECT * fROM order_info;

