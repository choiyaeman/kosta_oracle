--������� ���, �̸�, �μ���ȣ, �μ����� ����Ͻÿ�. ��, �μ��� ���� ����� ����Ͻÿ�
SELECT employee_id, first_name, e.department_id, department_name
FROM employees e  LEFT JOIN departments d ON (e.department_id = d.department_id)
ORDER BY employee_id;

SELECT employee_id, first_name, e.department_id, department_name
FROM employees e,   departments d
WHERE e.department_id = d.department_id(+)
ORDER BY employee_id;

--����ID�� ���ø��� ����Ͻÿ�:23��
2000	Beijing
2100	Bombay
2200	Sydney
2300	Singapore
:
--�μ�ID�� ����ID�� ����Ͻÿ�:27��
SELECT department_id, location_id
FROM departments;

--���ÿ� ���� �μ������ ����Ͻÿ�. :27��
SELECT city, department_name
FROM departments d JOIN locations l ON d.location_id = l.location_id;

--���ÿ� ���� �μ������ ����Ͻÿ�. �μ��� ���� ���õ� ����Ͻÿ�.:43��
SELECT city, department_name
FROM departments d RIGHT JOIN locations l ON d.location_id = l.location_id;

SELECT city, department_name
FROM departments d,  locations l
WHERE d.location_id(+) = l.location_id;

--�μ���ȣ�� �μ����� ����Ͻÿ�:27��
220	NOC
230	IT Helpdesk
240	Government Sales
250	Retail Sales
260	Recruiting
270	Payroll

--����� ���, �̸�, �μ���ȣ, �μ����� ����Ͻÿ�. 
--��, �μ��� ���� ����� ��� ����ϰ�
--����� ���� �μ��� ��� ����Ͻÿ�
SELECT employee_id, d.department_id, department_name
FROM  employees e FULL OUTER JOIN departments d ON (e.department_id = d.department_id)
