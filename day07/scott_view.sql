--뷰생성 : 주문번호, 주문자ID, 주문자이름, 주문일자,
--           주문상품번호, 상품명, 가격, 주문수량
--            
CREATE VIEW vw_order
AS SELECT info.order_no "no", order_id "id", c.name "name", order_dt "dt",
               line.order_prod_no, p.prod_name, p.prod_price, order_quantity
     FROM  order_info info JOIN customer c ON (info.order_id = c.id)
                               JOIN order_line line ON (info.order_no = line.order_no)
                               JOIN product p   ON (line.order_prod_no = p.prod_no);

--vw_order뷰 구조변경 : ALTER VIEW 안됨, CREATE OR REPLACE사용
CREATE OR REPLACE VIEW vw_order
AS SELECT info.order_no "no", order_id "id", c.name "name", order_dt "dt",
               line.order_prod_no, p.prod_name, p.prod_price, order_quantity
     FROM  order_info info JOIN customer c ON (info.order_id = c.id)
                               JOIN order_line line ON (info.order_no = line.order_no)
                               JOIN product p   ON (line.order_prod_no = p.prod_no);
--------------------------------------------------------
--뷰 사용
SELECT *
FROM vw_order;

SELECT "no", order_prod_no
FROM vw_order;      
--------------------------------------------------------
--뷰삭제 
DROP VIEW vw_order;
--------------------------------------------------------
--뷰종류
단순뷰 : 1개테이블 --CREATE VIEW a AS SELECT FROM emp
  --뷰에 데이터추가,삭제,수정가능  INSERT INTO a VALUES (~~); 
복합뷰 : 여러테이블 --CREATE VIEW b AS SELECT FROM emp JOIN dept
  --뷰에 데이터추가,삭제,수정 불가능 INSERT INTO b VALUES (~~); X
------------------------------------------------------
SELECT *
FROM user_views;