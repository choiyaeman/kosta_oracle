--����Ŭ���� �����ϴ� �Լ�
--�����Լ�
SELECT ename, LENGTH(ename)
FROM emp;

--�׽�Ʈ�뵵�� ���̺� : dual���̺�
SELECT LENGTH('������'), 
       INSTR('ABCABC', 'B'), INSTR('ABCABC', 'X'),
       SUBSTR('ABCABC', 2, 3)       
FROM dual;

--FROM emp;


--�����Լ�
--��¥�Լ�