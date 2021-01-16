--����� : �ֹ���ȣ, �ֹ���ID, �ֹ����̸�, �ֹ�����,
--           �ֹ���ǰ��ȣ, ��ǰ��, ����, �ֹ�����
--            
CREATE VIEW vw_order
AS SELECT info.order_no "no", order_id "id", c.name "name", order_dt "dt",
               line.order_prod_no, p.prod_name, p.prod_price, order_quantity
     FROM  order_info info JOIN customer c ON (info.order_id = c.id)
                               JOIN order_line line ON (info.order_no = line.order_no)
                               JOIN product p   ON (line.order_prod_no = p.prod_no);

--vw_order�� �������� : ALTER VIEW �ȵ�, CREATE OR REPLACE���
CREATE OR REPLACE VIEW vw_order
AS SELECT info.order_no "no", order_id "id", c.name "name", order_dt "dt",
               line.order_prod_no, p.prod_name, p.prod_price, order_quantity
     FROM  order_info info JOIN customer c ON (info.order_id = c.id)
                               JOIN order_line line ON (info.order_no = line.order_no)
                               JOIN product p   ON (line.order_prod_no = p.prod_no);
--------------------------------------------------------
--�� ���
SELECT *
FROM vw_order;

SELECT "no", order_prod_no
FROM vw_order;      
--------------------------------------------------------
--����� 
DROP VIEW vw_order;
--------------------------------------------------------
--������
�ܼ��� : 1�����̺� --CREATE VIEW a AS SELECT FROM emp
  --�信 �������߰�,����,��������  INSERT INTO a VALUES (~~); 
���պ� : �������̺� --CREATE VIEW b AS SELECT FROM emp JOIN dept
  --�信 �������߰�,����,���� �Ұ��� INSERT INTO b VALUES (~~); X
------------------------------------------------------
SELECT *
FROM user_views;