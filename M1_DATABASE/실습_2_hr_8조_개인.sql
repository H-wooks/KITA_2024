-- 실습
-- 현재 hr에 있는 7개 테이블을 분석해서 인사관리에 의미있는 인사이트 5개 이상을 기술하세요
-- 인사관리 개선을 위한 KPI 2개를 설정하고 이것들을 테이블의 데이터에 반영한 후 다시 분석해서 반영 여부를 검증하세요

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

--------------------------------------------- HR TABLES 관련한 INSIGHTs ---------------------------------------------
-------------------- 1. DB 관리 측면
-- 1-i. DB가 너무 나누어져 있다. 정보 관리 측면에서 (EMPLOYEES/DEPARTMENTS/JOBS/JOB_HISTORY) (LOCATIONS/COUNTRIES/REGIONS)
-- 1-ii
-- 1-iii
-- 1-iV 
-------------------- 2. 인력 관리/평가 측면 (근태, 개인 성과지표에 관한 어떠한 자료가 없음)
-- 2-i. 
-- 2-ii
-- 2-iii
-- 2-iV 
-------------------- 3. 인력 역량, 직원 성취욕, 업무 능력 강화 (직원 건강:장기적 회사의 perf.에 영향, 교육-직원의 역량 강화)
-- 3-i. 
-- 3-ii
-- 3-iii
-- 3-iV 
-------------------- 4. GWP (Great Work Place), Work-Life Balance를 통한 영속성 추구 방면 고민 필요
-- 4-i. 
-- 4-ii
-- 4-iii
-- 4-iV 

************** Check List
1. 위의 모든 data를 1-table에 보기 좋게 정리 ?
2. (i) 퇴사자들 리스트 업: (2) 퇴사 이유에 대한 면담 자료 (퇴사 이유 pool 생성해서 count해야함)
(iii) 퇴사자들의 지역/급여/직급/직무에 대한 특이성 조사
3.sales 부서에만 commission pct가 있다 나머지 부서들은?
4. 급여 관련해서.. 체크할 사항
 (1) 년차별로 평균 대비 특이점 있는 직원 + 연차가 동일한 사람들 간 직급이나 급여 차이 review
 (2) 부서 (직무)별 평균 급여
 (3) 지역별 평균 급여
5. 부서/매니저가 assign 안된 직원 존재 (관리 부재)
6. 지역별 편차가 있다면 지역별 manager/leader.. 관리자 (인력 운영/관리/교육 담당)
7. 
 

--------------------------------------------- KPI (Key Performance Indicator/index ---------------------------------------------
Key: (1) 중요성, (2) 측정 가능한 정량적 지표, (3) 시기별 관리 가능

인사 관리 측면에서의 KPI: 인력유지/인력 로스율/평균 근속/인력비용/인적자원 효율성.....



