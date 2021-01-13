--���������� ����
�����
   �����༭������
   �����༭������ IN, ANY, ALL, EXISTS

��ġ����
   �������� (WHERE)
   �ζ��κ� (FROM)
   ��Į������(SELECT)

��ȣ������������
---------------------------------
�ζ��κ�
--����� ���, �Ի���, �޿��� ����Ͻÿ�
SELECT employee_id, hire_date, salary
FROM employees;
 
--����Ŭ���� �ǻ��÷� : rownum -���ȣ
SELECT rownum, employee_id, hire_date, salary
FROM employees;
 
--����� ���ȣ, ���, �Ի���, �޿��� ����Ͻÿ�. �޿��� ���� ������� ����Ͻÿ�
SELECT rownum, employee_id, hire_date, salary
FROM employees
ORDER BY salary DESC;

--SELECTó������ : FROM -> WHERE-> GROUP BY -> HAVING -> SELECT -> ORDER BY
--����� ���, �Ի���, �޿��� ����Ͻÿ�. �޿��� ���� ������� ����Ͻÿ�
--���ȣ�� �޿����� ������� 1�������Ѵ�(������ ���ȣ�߱�)
SELECT rownum,  emps.*
FROM (SELECT employee_id, hire_date, salary
          FROM employees
          ORDER BY salary DESC) emps;

--����� ���, �Ի���, �޿��� ����Ͻÿ�. �޿��� ���� ������� ����Ͻÿ�
--���ȣ�� �޿����� ������� 1�������Ѵ�(������ ���ȣ�߱�)
--���ȣ�� 1~10�� ������� ����Ͻÿ�
SELECT rownum,  emps.*
FROM (SELECT employee_id, hire_date, salary
          FROM employees
          ORDER BY salary DESC) emps
WHERE rownum BETWEEN 1 AND 10;

--���ȣ�� 11~20�� ������� ����Ͻÿ�
SELECT rownum,  emps.*
FROM (SELECT employee_id, hire_date, salary
          FROM employees
          ORDER BY salary DESC) emps
WHERE rownum BETWEEN 11 AND 20; --???

SELECT *
FROM (SELECT rownum rno, emps.*
          FROM (SELECT employee_id, hire_date, salary
                    FROM employees
                    ORDER BY salary DESC) emps)
WHERE  rno BETWEEN 21 AND 30;
-------------------------------------------------------------------
--��Į������
--����� ���, �޿�, �μ���ȣ, �μ����� ����Ͻÿ�
SELECT employee_id, salary, department_id,
         (SELECT department_name 
          FROM departments 
          WHERE department_id=employees.department_id)
FROM employees;
---------------------------------------------------------------------
--111������� �޿����� ���� �޿��� �޴� 
--�����μ��� ������, �޿�, �μ���ȣ�� ����Ͻÿ�
SELECT employee_id, salary, department_id
FROM employees 
WHERE (department_id, salary) > (SELECT department_id, salary 
                        FROM employees 
                        WHERE employee_id=111);  (X)

--��ȣ������������
SELECT employee_id, salary, department_id
FROM employees e
WHERE salary> (SELECT salary 
                        FROM employees e111
                        WHERE employee_id=111
                        AND e.department_id = e111.department_id
                      ); 
-----------------------------------------
--EXISTS������
--����� �ִ� �μ����� ����Ͻÿ�
SELECT *
FROM departments                      
WHERE  EXISTS 
      (SELECT department_id
       FROM employees 
       WHERE department_id = departments.department_id); 

--����� ���� �μ����� ����Ͻÿ�
SELECT *
FROM departments                      
WHERE  NOT EXISTS 
      (SELECT department_id
       FROM employees 
       WHERE department_id = departments.department_id); 
------------------------------------------------------
--NULL���� ���� SUBQUERY
--¦���� ����� �μ���ȣ�� �μ����� ����Ͻÿ�
SELECT department_id, department_name
FROM  departments 
WHERE  department_id
             IN (SELECT DISTINCT department_id  --NULL����
                  FROM employees 
                  WHERE MOD(employee_id,2) = 0 );

--¦���� ����� �ٹ����� �ʴ� �μ��� ����Ͻÿ�
SELECT department_id, department_name
FROM  departments 
WHERE  department_id
             NOT IN (SELECT DISTINCT department_id  --NULL����
                  FROM employees 
                  WHERE MOD(employee_id,2) = 0 ); --0�� ���

SELECT department_id, department_name
FROM  departments 
WHERE  department_id
             NOT IN (SELECT DISTINCT NVL(department_id, 0)  --NULL����
                  FROM employees 
                  WHERE MOD(employee_id,2) = 0 );