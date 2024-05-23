-- �ǽ�
-- ���� hr�� �ִ� 7�� ���̺��� �м��ؼ� �λ������ �ǹ��ִ� �λ���Ʈ 5�� �̻��� ����ϼ���
-- �λ���� ������ ���� KPI 2���� �����ϰ� �̰͵��� ���̺��� �����Ϳ� �ݿ��� �� �ٽ� �м��ؼ� �ݿ� ���θ� �����ϼ���

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
SELECT * FROM JOB_HISTORY;
SELECT * FROM LOCATIONS;
SELECT * FROM REGIONS;
SELECT * FROM COUNTRIES;

---------------------- Entities: EMPLOYEES,DEPARTMENTS,JOBS,JOB_HISTORY,LOCATIONS,COUNTRIES,REGIONS
---------------------- Attributes:  
-- EMPLOYEES: EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
-- DEPARTMENTS: DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID
-- JOBS: JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY
-- JOB_HISTORY: EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID
-- LOCATIONS: LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID
-- COUNTRIES: COUNTRY_ID, COUNTRY_NAME, COUNTRY_NAME, REGION_ID
-- REGIONS: REGION_ID, REGION_NAME

--------------------------------------------- HR TABLES ������ INSIGHTs ---------------------------------------------
-------------------- 1. DB ���� ����
-- 1-i. DB�� �ʹ� �������� �ִ�. ���� ���� ���鿡�� (EMPLOYEES/DEPARTMENTS/JOBS/JOB_HISTORY) (LOCATIONS/COUNTRIES/REGIONS) ���հ����ϴ°� ���� �� ����
-- 1-ii. �η� ���� ���鿡�� ���� ���� DB�� �߰��� �� �ʿ���
-- 1-iii. ���κ� ���� ��ǥ ��� �����, �μ��� ���� ��ǥ ��� ������� ����͸� �� �� �ִ� DB �߰� �ʿ�
-- 1-iV. ���� �ǰ� üũ�� ���� DB �߰�
-------------------- 2. �η� ����/�� ���� (����, ���� ������ǥ�� ���� ��� �ڷᰡ ����)
-- 2-i. ���κ�, �μ��� ��ǥ ��� ����� ���õ� �ڷᰡ ����. �η� ����/�� ���鿡�� data�� �ʿ� 
-- 2-ii
-- 2-iii
-- 2-iV 
-------------------- 3. �η� ����, ���� �����, ���� �ɷ� ��ȭ (���� �ǰ�:����� ȸ���� perf.�� ����, ����-������ ���� ��ȭ)
-- 3-i. ���κ�, �μ��� ��ǥ ��� ������� ���� ���밡 ������ ������ �����ϰ� ���� ��ȭ/���� ���α׷��� ���� �ϱ� ���� DB�� �ʿ�
-- 3-ii. ���� �׷� �� �ɷ��� �پ ����� �����ؼ� ���� ���α׷� ��ȹ/����
-- 3-iii. ==> ���� DB������ ������ ���޺� salary�� �������� �����ڵ��� mentor�� �ؼ� ���� ���α׷� ���� �ʿ� ����
-- 3-iV. �ǰ� ���� DB �߰� �ʿ�
-------------------- 4. GWP (Great Work Place), Work-Life Balance�� ���� ���Ӽ� �߱� ��� ��� �ʿ�
-- 4-i. ���� DB�κ��� �ٹ� �ð��� ������ ����, �ٹ��ð��� ��� ���� ������ ���� ���� �߱��ؼ� balance �ʿ�
-- 4-ii. �μ����� �ٹ��ð��� ���� ���ΰ� ���������� balance �ʿ�
-- 4-iii
-- 4-iV 

---------------------************** Check List
-- 1. ���� data�� REDUNDANCY�� ���ְ� COMPACT�ϰ� table ����:
SAVEPOINT SP1;

DROP VIEW EMPLOYEE_DETAILS;
CREATE VIEW EMPLOYEE_DETAILS AS
SELECT 
    E.EMPLOYEE_ID ���,
    E.FIRST_NAME || ' ' || E.LAST_NAME �̸�,
    E.EMAIL �̸���,
    E.PHONE_NUMBER �ڵ�����ȣ,
    E.HIRE_DATE �Ի�����,
    FLOOR(MONTHS_BETWEEN(SYSDATE, E.HIRE_DATE) / 12) ����,
    E.SALARY �޿�,
    DECODE(E.COMMISSION_PCT, NULL, 'N', E.COMMISSION_PCT) ���⼺��,
    E.JOB_ID  ������,
    E.MANAGER_ID ���Ŵ���ID,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS ���Ŵ���,
    E.DEPARTMENT_ID �μ�ID,
    D.DEPARTMENT_NAME �μ���,
    D.MANAGER_ID ���Ŵ���ID2,
    DECODE(E.MANAGER_ID, D.MANAGER_ID, '����', '������') AS �Ŵ������ռ�,
    D.LOCATION_ID �ٹ���ID
FROM 
    EMPLOYEES E
LEFT JOIN 
    EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
LEFT JOIN 
    DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY E.EMPLOYEE_ID;
 
SELECT * FROM EMPLOYEE_DETAILS
ORDER BY �μ�ID;

INSIGHT 1: �λ� DB ���� ���鿡�� ���� 7���� EMPLOYEES,DEPARTMENTS,JOBS,JOB_HISTORY,LOCATIONS,COUNTRIES,REGIONS TABLE�� REDUNDANCY�� �ְ� ��ȿ������ 
    - ROCATION/CONTRY/REGION �� �� TABLE�� ���հ����ϴ°� ȿ����, EMPLOYEES/DEPARTMENT�� �Ϻ� �ߺ� ��Ҹ� EMPLOYEES�� ���� ������ �ʿ䰡 ����
    - 
INSIGHT 2: �η� ����/�� ���鿡�� HR �μ��� �˰� �־���� DB�� ���� �غ�Ǿ� ���� ����. 
    - ���� ���� DB BUILDING�� �ʿ� ==> TA_MANAGEMENT (TIME AND ATTENDANCE MANAGEMENT)
      ���� �ٹ���, �׿� �ٹ��� ������ ���� DATA ����
    - ���� ���� DB BUILDING�� �ʿ� (���κ� ==> INDIVIDUAL_PERF, �μ���: DEPARTMENTS==> DEPARTMENT_PERF)
      �μ���, ���� (������, ������..) SALARY �м� ���� �ʿ�
      + ������ �����鿡 ���� ���� SKILL-UP ��ȸ�� ����: ������(��������)�� ���� ����/MENTORING ���� �ʿ� (MENTOR:��������/����, MENTEE: ������)
    - HR�� ���� �߿��� ���� ���� �η� Ȯ��/�����ε�, ����ڵ鿡���� ������ ����. (JOB-HISTORY ==> RESIGNATION (�������� �м�, �ټ�,�μ�,����,...�� ���� ����� �м�)
    - ���� ������ ���ؼ��� SALE �μ��� �Ϻ� COMMISSION PERCENT�� ���س��� �������� �󿩱��� ����

INSIGHT 3: GREAT WORK PLACE (GWP), WORK - LIFE BALANCE�� ���� HR-DB�� ���� ���α׷� ����(ȸ��/������ ���Ӽ��� ���� �ʿ�)
    - ���� ���� ����� ���� ���� ���α׷�
    - �ٹ� �ð� ���� (�μ��� �η� ��� �� ��й�..)
    - HR �μ����� �� �� ���/... ���α׷� ����/���� 



-- 2. (i) ����ڵ� ����Ʈ ��: (2) ��� ������ ���� ��� �ڷ� (��� ���� pool �����ؼ� count�ؾ���)
--   (iii) ����ڵ��� ����/�޿�/����/������ ���� Ư�̼� ����
-- 3. sales �μ����� commission pct�� �ִ� ������ �μ�����?
-- 4. �޿� �����ؼ�.. üũ�� ����
--  (i) �������� ��� ��� Ư���� �ִ� ���� + ������ ������ ����� �� �����̳� �޿� ���� review
--  (ii) �μ� (����)�� ��� �޿�
--  (ii) ������ ��� �޿�
-- 5. �μ�/�Ŵ����� assign �ȵ� ���� ���� (���� ����)
-- 6. ������ ������ �ִٸ� ������ manager/leader.. ������ (�η� �/����/���� ���)
-- 7. 
 

--------------------------------------------- KPI (Key Performance Indicator/index) ---------------------------------------------
Key: (1) �߿伺, (2) ���� ������ ������ ��ǥ, (3) �ñ⺰ ���� ����

�λ� ���� ���鿡���� KPI: DB�� ȿ����, �η�����/�η� �ν���/��� �ټ�/�ηº��/�����ڿ� ȿ����.....
 ==> (1) DB merge, DB �߰� (����, ����, �ǰ�...), ����/���̳� ���α׷� �ʿ�, WL-balance�� ���� �λ� ���α׷� �߰� �ʿ�


������:
1. LOCATION/NATION/REGION TABLE COMPACTȭ
2. ���� TABLE (����ϼ�/�ִ� �ٹ��ð�-�ִ� 40�ð� ��������/......)
3. ����� id/START/END/JOB/�ټӿ���/�������

��ȯ��
1. EMPLOYEES/DEPARTMENTS TABLE COMPACTȭ
2. ��������� <--- SALARY (��� ������) �� ȯ���ؼ� �����, ����� SALARY�� �־��... 
3. ����/�ǰ����� TABLE ����� �����... 
4. ���� DEPARTE + �μ� ���� ���� ��ǥ

