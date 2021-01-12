--����� ���, �̸�, �޿�, ����ID, �μ�ID�� ����Ͻÿ�.
SELECT employee_id,
       first_name,
       salary,
       job_id,
       department_id
FROM employees;

--����� ���, �̸�, �޿�, ����ID, ������, �μ�ID�� ����Ͻÿ�. --�������̶�� JOBS���̺� �ִ�. --job_id�� EMPLOYEES, JOBS���̺��� ������ ��� ���̺����� ��Ī�� ��Ȯ�� ������Ѵ�.
SELECT employee_id,
       first_name,
       salary,
       e.job_id,
       job_title,
       department_id
FROM employees e JOIN jobs j ON e.job_id = j.job_id; -- e, j�� ��Ī�� �ǹ�.

SELECT employee_id,
       first_name,
       salary,
       job_id,
       job_title,
       department_id
FROM employees NATURAL JOIN jobs; --�����ϸ� SELECT������ e.job_id���� ������ �߻�! �ߺ��� �÷��� �տ� ��Ī���� �ٿ��ߵǴ°��� join on���̳� natural�� ��Ī�� ���� �ȵǰ� ���� �÷����� �����ؾ��Ѵ�.

--����� ���, �̸�, �μ�ID, �μ����� ����Ͻÿ�. JOIN-ON
SELECT employee_id,
       first_name,
       d.department_id, --d�� e �ƹ��ų� �ᵵ �������
       department_name
FROM employees e JOIN departments d ON e.department_id = d.department_id; --106������� ����� ��

--����� ���, �̸�, �μ�ID, �μ����� ����Ͻÿ�. NATURAL JOIN
SELECT employee_id,
       first_name,
       department_id,
       department_name
FROM employees NATURAL JOIN departments; --32������� ����� ��
--FROM employee e JOIN departmets d 
--ON e.department_id = d.department_id
--AND e.manager_id = d.mager_id;

--����� ���, �̸�, �μ�ID, �μ����� ����Ͻÿ�. USING
SELECT employee_id,
       first_name,
       department_id,
       department_name
FROM employees JOIN departments USING(department_id); --106��

--����� ���, �̸�, �μ�ID, �μ���, ����ID, �������� ����Ͻÿ� ****************
SELECT employee_id,
       first_name,
       e.department_id,
       department_name,
       j.job_id,
       job_title
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
                 JOIN jobs j ON (e.job_id = j.job_id);

--����� ���, �̸��� �ٹ��ϴ� �μ���, �μ��� ���� ���ø��� ����Ͻÿ�.
SELECT employee_id,
       first_name,
       department_name,
       city
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
                 JOIN locations l ON (d.location_id = l.location_id);
                 
--����� ���, �̸��� �ٹ��ϴ� �μ���, �μ��� ���� ���ø��� ����Ͻÿ�.
--���ø� �������, ���� ������ ��� �μ��� ������� ���
SELECT employee_id,
       first_name,
       department_name,
       city
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
                 JOIN locations l ON (d.location_id = l.location_id)
ORDER BY city, department_name;

--Ȧ���� ����� ��� �������
--���, �̸��� �ٹ��ϴ� �μ���, �μ��� ���� ���ø��� ����Ͻÿ�.
	--���ø� �������, ���� ������ ��� �μ��� ������� ���
SELECT employee_id,
       first_name,
       department_name,
       city
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
                 JOIN locations l ON (d.location_id = l.location_id)
WHERE MOD(employee_id, 2)=1
ORDER BY city, department_name;

--�μ��� �μ���� �����, �ѱ޿��� ����Ͻÿ�
SELECT department_name, COUNT(*), SUM(salary)
FROM employees e JOIN departments d USING(department_id)
GROUP BY department_name;