-----------------------------------------------------------------
-----------------------2024-05-22--------------------------------
-----------------------------------------------------------------

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
SELECT * FROM JOB_HISTORY;
SELECT * FROM LOCATIONS;
SELECT * FROM REGIONS;
SELECT * FROM COUNTRIES;

-- Q. ����� 120�� ����� ���, �̸�, ����, ������ QUERY
SELECT E.EMPLOYEE_ID ���, E.FIRST_NAME �̸�, E.LAST_NAME ��, J.JOB_ID ����, J.JOB_TITLE ������
FROM EMPLOYEES E 
INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE E.EMPLOYEE_ID = 120;

-- FIRST_NAME||' '||LAST_NAME AS �̸�: ���� �̸��� �������� �����Ͽ� RETURN
SELECT E.EMPLOYEE_ID ���, E.FIRST_NAME ||' ' ||E.LAST_NAME FULL_NAME, J.JOB_ID ����, J.JOB_TITLE ������
FROM EMPLOYEES E 
INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE E.EMPLOYEE_ID = 120;

SELECT E.EMPLOYEE_ID ���, E.FIRST_NAME ||' ' ||E.LAST_NAME FULL_NAME, J.JOB_ID ����, J.JOB_TITLE ������
FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID = J.JOB_ID 
AND E.EMPLOYEE_ID = 120;

-- Q. 2005�� ��ݱ⿡ �Ի��� ������� �̸��� ���
SELECT FIRST_NAME ||' ' ||LAST_NAME FULL_NAME, HIRE_DATE �Ի���
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YY/MM') BETWEEN '05/01' AND '05/06';

-- _�� ���ϵ�ī�� (1��)�� �ƴ� ���ڷ� ����ϰ� ���� �� ESCAPE �ɼ��� ���
SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%\_A%';                      -- SQL������ ESCAPE�� �ڵ����� �ν� X
SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%\_A%' ESCAPE '\';           -- SQL������ ESCAPE�� ���� ������ ���� �����
SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%#_A%' ESCAPE '#';           -- \�Ӹ� �ƴ϶� #�� �������ִ� �Ϳ� ����

-- IN : OR ��� ���
SELECT * FROM EMPLOYEES WHERE MANAGER_ID =101 OR MANAGER_ID=102 OR MANAGER_ID=103;
SELECT * FROM EMPLOYEES WHERE MANAGER_ID IN (101,102,103);

-- Q. ������ SA_MAN, IT_PROG, ST_MAN�� ����� ���
SELECT * FROM EMPLOYEES WHERE JOB_ID IN ('SA_MAN', 'IT_PROG', 'ST_MAN');

-- IS NULL / IS NOT NULL
-- NULL �������� Ȯ���ϴ� ��� = �� �����ڸ� ������� �ʰ� IS NULL�� ���
SELECT * FROM EMPLOYEES WHERE COMMISSION_PCT IS NULL;
SELECT * FROM EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL;

-- ORDER BY
-- ORDER BY �÷��� [ASC | DESC]    ASC�� DEFAULT
SELECT * FROM EMPLOYEES ORDER BY SALARY ASC;
SELECT * FROM EMPLOYEES ORDER BY SALARY DESC;
SELECT * FROM EMPLOYEES ORDER BY SALARY ASC, LAST_NAME DESC;

-- DUAL ���̺�, ������ ���̺��� ���� ������ ������ �� �� (Ȧ �� �϶�)
SELECT * FROM EMPLOYEES WHERE MOD(EMPLOYEE_ID, 2) = 1;
SELECT MOD(10,3) FROM DUAL;

-- ROUND
SELECT ROUND(355.9555) FROM DUAL;
SELECT ROUND(355.9555,2) FROM DUAL;
SELECT ROUND(355.9555,2) FROM DUAL;


-- TRUNC()  ���� �Լ� ������ �ڸ��� ���ϸ� ������.
SELECT TRUNC(355.9555,1) FROM DUAL;
-- CEIL() �Լ� ������ �ø�, ���� ���� ����
SELECT CEIL(45.333) FROM DUAL;


-- Q. HR EMPLOYEES ���̺��� �̸�, �ݿ�, 10% �λ�� �޿� ���
SELECT LAST_NAME �̸�, SALARY �޿�, SALARY*1.1 "�λ�� �޿�"
FROM EMPLOYEES;

-- Q. EMPLOYEE_ID�� Ȧ���� ������ EMPLOYEE_ID�� LAST_NAME�� ���
SELECT EMPLOYEE_ID, LAST_NAME
FROM EMPLOYEES
WHERE MOD(EMPLOYEE_ID, 2) = 1
ORDER BY EMPLOYEE_ID;

-- SUB-QUERY �̿��ؼ�....
SELECT EMPLOYEE_ID, LAST_NAME
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (
SELECT EMPLOYEE_ID
FROM EMPLOYEES
WHERE MOD(EMPLOYEE_ID, 2) = 1)
ORDER BY EMPLOYEE_ID;

-- Q. EMPLOYEES ���̺��� COMMISSION_PCT�� NULL ���� ������ ����ϼ���
SELECT COUNT(*) FROM EMPLOYEES WHERE COMMISSION_PCT IS NULL;
SELECT COUNT(*) FROM EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL;

-- Q. EMPLOYEES ���̺��� DEPARTMENT_ID�� ���� ������ �����ؼ� POSITION�� '����'���� ��� (POSITION ���� �߰�)
ALTER TABLE EMPLOYEES ADD POSITION VARCHAR2(15);
UPDATE EMPLOYEES SET POSITION='����' WHERE  DEPARTMENT_ID IS NULL;
SELECT POSITION, DEPARTMENT_ID FROM EMPLOYEES;

ALTER TABLE EMPLOYEES DROP COLUMN POSITION;
SELECT * FROM EMPLOYEES; 

SELECT EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME FULL_NAME, '����' POSISTION
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NULL;

------------------------------------------- ��¥ ����
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE + 1 FROM DUAL;
SELECT SYSDATE - 1 FROM DUAL;

--ROUND-TRUNC------------ Q. �ٹ��� ��¥ ���
SELECT LAST_NAME, SYSDATE, HIRE_DATE, ROUND(SYSDATE-HIRE_DATE) �ٹ��ð� FROM EMPLOYEES;
SELECT LAST_NAME, SYSDATE, HIRE_DATE, TRUNC(SYSDATE-HIRE_DATE) �ٹ��ð� FROM EMPLOYEES;

--- �Ʒ� ��������
SELECT LAST_NAME, SYSDATE, HIRE_DATE, DATETIME(TRUNC(SYSDATE-HIRE_DATE)) �ٹ��ð� FROM EMPLOYEES;
--ADD_MONTHS------------- Q. Ư�� ���� ���� ���� ���
SELECT LAST_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) REVISED_DATE FROM EMPLOYEES;

--LAST_DAY------------- Q. �ش� ���� ������ ��¥�� ��ȯ
SELECT LAST_NAME, HIRE_DATE, LAST_DAY(ADD_MONTHS(HIRE_DATE, 1)) "���� ������ ��" FROM EMPLOYEES;

--NEXT_DAY------------- Q. �ش� ��¥�� �������� ������ ���� Ư�� ����
SELECT LAST_NAME, HIRE_DATE, NEXT_DAY(HIRE_DATE, '��') "���� ������" FROM EMPLOYEES;
SELECT LAST_NAME, HIRE_DATE, NEXT_DAY(HIRE_DATE, 2) "���� ������" FROM EMPLOYEES;

--MONTHS_BETWEEN------------- Q. ��¥�� ��¥ ������ �������� ���Ѵ�. (���� ���� �Ҽ��� ù° �ڸ����� �ݿø�)
SELECT HIRE_DATE, ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE), 1) FROM EMPLOYEES;

--�� ��ȯ : TO_DATE------------- Q. ���ڸ� ��¥�� �����Ѵ�.
SELECT TO_DATE('2023-01-01', 'YYYY-MM-DD') FROM DUAL;

--TO_CHAR------------- Q. ��¥�� ���ڷ� ����
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD') FROM DUAL;

------------------------------------------------------ �ð� ���� 
-- YYYY       �� �ڸ� ����
-- YY      �� �ڸ� ����
-- YEAR      ���� ���� ǥ��
-- MM      ���� ���ڷ�
-- MON      ���� ���ĺ�����
-- DD      ���� ���ڷ�
-- DAY      ���� ǥ��
-- DY      ���� ��� ǥ��
-- D      ���� ���� ǥ��
-- AM �Ǵ� PM   ���� ����
-- HH �Ǵ� HH12   12�ð�
-- HH24      24�ð�
-- MI      ��
-- SS      ��

--EX
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD DY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YEAR/MM/DD DY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'yyyy/MON/DD DY AM') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'yyyy/MON/DD DY AM HH') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'yyyy/MON/DD DY AM HH24:MI/SS') FROM DUAL;

----------------------------- Q. ���� ��¥�� "YYYY/MM/DD'�������� ��ȯ
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD') FROM DUAL;

----------------------------- Q. '01-01-2023'�̶� ���ڿ��� ��¥ Ÿ������ ��ȯ
SELECT TO_DATE('01-01-2023', 'DD-MM-YYYY') FROM DUAL;

----------------------------- Q. ���� ��¥�� �ð�(SYSDATE)�� 'YYYY-MM-DD HH24:MI:SS' ������ ���ڿ��� ��ȯ
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;

----------------------------- Q. '2023-01-01 15:30:00'�̶�� ���ڿ��� ��¥ �� �ð� Ÿ������ ��ȯ
SELECT TO_DATE('2023-01-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS') DATE1 FROM DUAL;
SELECT TO_DATE('2023-01-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS') DATE1, TO_CHAR(TO_DATE('2023-01-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'YY/MM/DD AM HH:MI:SS') "���� ����� �ð�" FROM DUAL;

--to_char( ���� )   ���ڸ� ���ڷ� ��ȯ
--9      �� �ڸ��� ���� ǥ��      ( 1111, ��99999�� )      1111   
--0      �� �κ��� 0���� ǥ��      ( 1111, ��099999�� )      001111
--$      �޷� ��ȣ�� �տ� ǥ��      ( 1111, ��$99999�� )      $1111
--.      �Ҽ����� ǥ��         ( 1111, ��99999.99�� )      1111.00
--,      Ư�� ��ġ�� , ǥ��      ( 1111, ��99,999�� )      1,111
--MI      �����ʿ� - ��ȣ ǥ��      ( 1111, ��99999MI�� )      1111-
--PR      �������� <>�� ǥ��      ( -1111, ��99999PR�� )      <1111>
--EEEE      ������ ǥ��         ( 1111, ��99.99EEEE�� )      1.11E+03
--V      10�� n�� ���Ѱ����� ǥ��   ( 1111, ��999V99�� )      111100
--B      ������ 0���� ǥ��      ( 1111, ��B9999.99�� )      1111.00
--L      ������ȭ         ( 1111, ��L9999�� )

-- EX)
SELECT SALARY, TO_CHAR(SALARY, '0999999') FROM EMPLOYEES;
SELECT SALARY, TO_CHAR(-SALARY, '0999999PR') FROM EMPLOYEES;
SELECT SALARY, TO_CHAR(SALARY, '999999MI') FROM EMPLOYEES;
SELECT SALARY, TO_CHAR(SALARY, '9.99EEEE') FROM EMPLOYEES;

--WIDTH_BUCKET()------------- ������, �ּҰ�, �ִ밪, BUCKET ����
SELECT WIDTH_BUCKET(92,0,100,10) FROM DUAL;
-- 0~100���� ���ڸ� 10���� �������� ����� ��Ÿ������, 92�� �����ִ� ���� ==> 10��° ����

SELECT WIDTH_BUCKET(82,0,100,10) FROM DUAL;         -- 9��°
-- 100�� �״������� �Ѿ��. 
SELECT WIDTH_BUCKET(100,0,100,10) FROM DUAL;       -- 

----------------------------- Q. EMPLOYEES ���̺��� SALARY�� 5�� ������� ��������
SELECT MAX(SALARY) MAX, MIN(SALARY) MIN FROM EMPLOYEES;
SELECT SALARY, WIDTH_BUCKET(SALARY, 2100,24001, 5) AS GRADE
FROM EMPLOYEES;


--UPPER()--------------------------- �ҹ���/ Ȥ�� �븸�ڷ� ���
--LOWER()--------------------------- ���� �Լ� CHARACTER FUNCTIONS
SELECT UPPER('hello world') from DUAL;
SELECT LOWER('HELLO WORLD') from DUAL;

----------------------------- Q. ù���ڸ� �빮��
SELECT JOB_ID, INITCAP (JOB_ID) FROM EMPLOYEES;


SELECT LAST_NAME, SALARY FROM EMPLOYEES WHERE LOWER(LAST_NAME)='seo';

--LENGTH--------------------- Q.
SELECT JOB_ID, LENGTH(JOB_ID) FROM EMPLOYEES;

--INSTR--------------------- Q.
SELECT INSTR('Hello Word', 'o', 3, 2) from dual;            --���ڿ�, ã�� ����, ã�� ��ġ, ã�� ��ü ���� �� ��� ° ����
-------------------------- ���ڿ� 'O'�� 'Hello Word'���� ã�µ�, 3�������� �� ã�µ�, 2��°�� ��ġ 
SELECT INSTR('Hello Word', 'o', 1, 1) from dual;            --���ڿ�, ã�� ����, ã�� ��ġ, ã�� ��ü ���� �� ��� ° ����

-- substr ()
select substr('Hello World', 3, 3) from dual;                           -- 'llo'
select substr('Hello World', 9, 3) from dual;                           -- 'rld'
select substr('Hello World', -3, 3) from dual;                          -- 'rld'

--lpad------------- �����ʿ� ���� �� ���ʿ� ���ڸ� ä���.
select lpad('Hello World', 20, '#') from dual;                  -- ��ü 20�� �ڸ��� �Ҵ��ϰ� ���� ���ʿ� '#'�� ä���.
select rpad('Hello World', 20, '#') from dual;                  -- ��ü 20�� �ڸ��� �Ҵ��ϰ� ���� �����ʿ� '#'�� ä���.

--ltrim------------- ���ʿ� �ִ� ������ ����
select ltrim('aaaHello Worldaaa', 'a') from dual;                  --==> Hello Worldaaa
select ltrim('   Hello World   ') from dual;                  --==> Hello 'Hello World      '
select last_name as �̸�, ltrim(last_name, 'A') from employees;                  --==> Hello 'Hello World      '


--rtrim------------- �����ʿ� �ִ� ������ ����
select rtrim('aaaHello Worldaaa', 'a') from dual;                  --==> aaaHello World
select rtrim('   Hello World   ') from dual;                  --==> Hello '   Hello World'

--trim------------- ����
select trim('   Hello World   ') from dual;         
select last_name, trim('A' from last_name) from employees;
select last_name, trim('a' from last_name) from employees;
----------------------------- Q. 
----------------------------- Q. 
----------------------------- Q. 
----------------------------- Q. 

--MONTHS_BETWEEN------------- Q.
--MONTHS_BETWEEN------------- Q.
--MONTHS_BETWEEN------------- Q.
