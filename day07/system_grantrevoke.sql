--system_grantrevoke.sql
--����� ���� - ������: 'test', ���: 'abc'
CREATE USER test IDENTIFIED BY abc;
--conn test/abc; --�����߻�
--���� �޽��� = ORA-01045: user TEST lacks CREATE SESSION privilege; logon denied

--���� ���� ���
GRANT CREATE SESSION TO test;
conn test/abc; --SQLPLUS

--���� test�������� ���̺� �����ϱ�
CREATE TABLE t1(a number); --ERROR

--�ý��۰������� ���̺����̽� ������, ���̺�������� ���
--GRANT UNLIMITED TABLESPACE TO test;
--GRANT CREATE TABLE TO test;

--CONNECT, RESOURCE���� ROLE�� Ȱ��
--GRANT connect, resource TO test;

--test�������� ���̺� �����ϱ�
CREATE TABLE t1(a number); --OK
---------------------------------------------------------
--���� ���: REVOKE
REVOKE CREATE SESSION FROM test; --���ӱ��� ���

