--����� ���, �̸�, �����ڹ�ȣ, �������̸��� ����Ͻÿ�
SELECT e.employee_id ���, e.first_name �̸�,
          m.employee_id �����ڹ�ȣ, m.first_name �������̸�
FROM employees e JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id;

--'Davies'����� ���� �μ��� �ٹ��ϴ� ������� ����Ͻÿ�
SELECT e.employee_id, e.first_name, e.department_id
FROM employees e JOIN employees davis ON (e.department_id = davis.department_id)
WHERE davis.last_name='Davies';

