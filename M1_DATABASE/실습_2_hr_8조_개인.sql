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
-- 1-i. DB�� �ʹ� �������� �ִ�. ���� ���� ���鿡�� (EMPLOYEES/DEPARTMENTS/JOBS/JOB_HISTORY) (LOCATIONS/COUNTRIES/REGIONS)
-- 1-ii
-- 1-iii
-- 1-iV 
-------------------- 2. �η� ����/�� ���� (����, ���� ������ǥ�� ���� ��� �ڷᰡ ����)
-- 2-i. 
-- 2-ii
-- 2-iii
-- 2-iV 
-------------------- 3. �η� ����, ���� �����, ���� �ɷ� ��ȭ (���� �ǰ�:����� ȸ���� perf.�� ����, ����-������ ���� ��ȭ)
-- 3-i. 
-- 3-ii
-- 3-iii
-- 3-iV 
-------------------- 4. GWP (Great Work Place), Work-Life Balance�� ���� ���Ӽ� �߱� ��� ��� �ʿ�
-- 4-i. 
-- 4-ii
-- 4-iii
-- 4-iV 

************** Check List
1. ���� ��� data�� 1-table�� ���� ���� ���� ?
2. (i) ����ڵ� ����Ʈ ��: (2) ��� ������ ���� ��� �ڷ� (��� ���� pool �����ؼ� count�ؾ���)
(iii) ����ڵ��� ����/�޿�/����/������ ���� Ư�̼� ����
3.sales �μ����� commission pct�� �ִ� ������ �μ�����?
4. �޿� �����ؼ�.. üũ�� ����
 (1) �������� ��� ��� Ư���� �ִ� ���� + ������ ������ ����� �� �����̳� �޿� ���� review
 (2) �μ� (����)�� ��� �޿�
 (3) ������ ��� �޿�
5. �μ�/�Ŵ����� assign �ȵ� ���� ���� (���� ����)
6. ������ ������ �ִٸ� ������ manager/leader.. ������ (�η� �/����/���� ���)
7. 
 

--------------------------------------------- KPI (Key Performance Indicator/index ---------------------------------------------
Key: (1) �߿伺, (2) ���� ������ ������ ��ǥ, (3) �ñ⺰ ���� ����

�λ� ���� ���鿡���� KPI: �η�����/�η� �ν���/��� �ټ�/�ηº��/�����ڿ� ȿ����.....



