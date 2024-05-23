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
-- 1-i. DB가 너무 나누어져 있다. 정보 관리 측면에서 (EMPLOYEES/DEPARTMENTS/JOBS/JOB_HISTORY) (LOCATIONS/COUNTRIES/REGIONS) 통합관리하는게 좋을 것 같다
-- 1-ii. 인력 관리 측면에서 근태 관리 DB가 추가로 더 필요함
-- 1-iii. 개인별 성과 목표 대비 이행률, 부서별 성과 목표 대비 이행률을 모니터링 할 수 있는 DB 추가 필요
-- 1-iV. 직원 건강 체크를 위한 DB 추가
-------------------- 2. 인력 관리/평가 측면 (근태, 개인 성과지표에 관한 어떠한 자료가 없음)
-- 2-i. 개인별, 부서별 목표 대비 이행률 관련된 자료가 없음. 인력 관리/평가 측면에서 data가 필요 
-- 2-ii
-- 2-iii
-- 2-iV 
-------------------- 3. 인력 역량, 직원 성취욕, 업무 능력 강화 (직원 건강:장기적 회사의 perf.에 영향, 교육-직원의 역량 강화)
-- 3-i. 개인별, 부서별 목표 대비 이행률로 부터 성취가 미진한 직원을 선별하고 역량 강화/교육 프로그램을 개설 하기 위한 DB가 필요
-- 3-ii. 직급 그룹 별 능력이 뛰어난 사람을 선별해서 교육 프로그램 계획/실행
-- 3-iii. ==> 현재 DB에서는 년차별 직급별 salary를 바탕으로 상위자들을 mentor로 해서 교육 프로그램 만들 필요 있음
-- 3-iV. 건강 관리 DB 추가 필요
-------------------- 4. GWP (Great Work Place), Work-Life Balance를 통한 영속성 추구 방면 고민 필요
-- 4-i. 근태 DB로부터 근무 시간이 과다한 직원, 근무시간이 평균 보다 현저히 적은 직원 발굴해서 balance 필요
-- 4-ii. 부서별로 근무시간도 위의 개인과 마찬가지로 balance 필요
-- 4-iii
-- 4-iV 

---------------------************** Check List
-- 1. 위의 data를 REDUNDANCY를 없애고 COMPACT하게 table 정리:
SAVEPOINT SP1;

DROP VIEW EMPLOYEE_DETAILS;
CREATE VIEW EMPLOYEE_DETAILS AS
SELECT 
    E.EMPLOYEE_ID 사번,
    E.FIRST_NAME || ' ' || E.LAST_NAME 이름,
    E.EMAIL 이메일,
    E.PHONE_NUMBER 핸드폰번호,
    E.HIRE_DATE 입사일자,
    FLOOR(MONTHS_BETWEEN(SYSDATE, E.HIRE_DATE) / 12) 연차,
    E.SALARY 급여,
    DECODE(E.COMMISSION_PCT, NULL, 'N', E.COMMISSION_PCT) 매출성과,
    E.JOB_ID  담당업무,
    E.MANAGER_ID 담당매니저ID,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS 담당매니저,
    E.DEPARTMENT_ID 부서ID,
    D.DEPARTMENT_NAME 부서명,
    D.MANAGER_ID 담당매니저ID2,
    DECODE(E.MANAGER_ID, D.MANAGER_ID, '정합', '부정합') AS 매니저정합성,
    D.LOCATION_ID 근무지ID
FROM 
    EMPLOYEES E
LEFT JOIN 
    EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
LEFT JOIN 
    DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY E.EMPLOYEE_ID;
 
SELECT * FROM EMPLOYEE_DETAILS
ORDER BY 부서ID;

INSIGHT 1: 인사 DB 관리 측면에서 현재 7개의 EMPLOYEES,DEPARTMENTS,JOBS,JOB_HISTORY,LOCATIONS,COUNTRIES,REGIONS TABLE은 REDUNDANCY가 있고 비효율적임 
    - ROCATION/CONTRY/REGION 는 한 TABLE로 통합관리하는게 효율적, EMPLOYEES/DEPARTMENT는 일부 중복 요소를 EMPLOYEES로 통합 관리할 필요가 있음
    - 
INSIGHT 2: 인력 관리/평가 측면에서 HR 부서가 알고 있어야할 DB가 전혀 준비되어 있지 않음. 
    - 근태 관리 DB BUILDING이 필요 ==> TA_MANAGEMENT (TIME AND ATTENDANCE MANAGEMENT)
      과다 근무자, 잉여 근무자 관리를 위한 DATA 부재
    - 성과 관리 DB BUILDING이 필요 (개인별 ==> INDIVIDUAL_PERF, 부서별: DEPARTMENTS==> DEPARTMENT_PERF)
      부서별, 개인 (연차별, 지역별..) SALARY 분석 쿼리 필요
      + 저역량 직원들에 대한 업무 SKILL-UP 기회를 보장: 저평가자(저연봉자)을 위한 교육/MENTORING 제도 필요 (MENTOR:상위평가자/선배, MENTEE: 저평가자)
    - HR의 가장 중요한 것이 가용 인력 확보/유지인데, 퇴사자들에대한 정보의 부재. (JOB-HISTORY ==> RESIGNATION (퇴직원인 분석, 근속,부서,연봉,...에 따른 퇴사자 분석)
    - 업무 성과에 관해서는 SALE 부서만 일부 COMMISSION PERCENT를 정해놓고 나머지는 상여금이 없음

INSIGHT 3: GREAT WORK PLACE (GWP), WORK - LIFE BALANCE를 위한 HR-DB나 관리 프로그램 부재(회사/조직의 영속성을 위해 필요)
    - 개인 역량 향상을 위한 교육 프로그램
    - 근무 시간 조정 (부서멸 인력 충원 및 재분배..)
    - HR 부서에서 그 외 명상/... 프로그램 개설/관리 



-- 2. (i) 퇴사자들 리스트 업: (2) 퇴사 이유에 대한 면담 자료 (퇴사 이유 pool 생성해서 count해야함)
--   (iii) 퇴사자들의 지역/급여/직급/직무에 대한 특이성 조사
-- 3. sales 부서에만 commission pct가 있다 나머지 부서들은?
-- 4. 급여 관련해서.. 체크할 사항
--  (i) 년차별로 평균 대비 특이점 있는 직원 + 연차가 동일한 사람들 간 직급이나 급여 차이 review
--  (ii) 부서 (직무)별 평균 급여
--  (ii) 지역별 평균 급여
-- 5. 부서/매니저가 assign 안된 직원 존재 (관리 부재)
-- 6. 지역별 편차가 있다면 지역별 manager/leader.. 관리자 (인력 운영/관리/교육 담당)
-- 7. 
 

--------------------------------------------- KPI (Key Performance Indicator/index) ---------------------------------------------
Key: (1) 중요성, (2) 측정 가능한 정량적 지표, (3) 시기별 관리 가능

인사 관리 측면에서의 KPI: DB의 효율성, 인력유지/인력 로스율/평균 근속/인력비용/인적자원 효율성.....
 ==> (1) DB merge, DB 추가 (근태, 성과, 건강...), 교육/세미나 프로그램 필요, WL-balance를 위한 인사 프로그램 추가 필요


서보선:
1. LOCATION/NATION/REGION TABLE COMPACT화
2. 근태 TABLE (결근일수/주당 근무시간-주당 40시간 기준으로/......)
3. 퇴사자 id/START/END/JOB/근속연수/퇴사이유

최환욱
1. EMPLOYEES/DEPARTMENTS TABLE COMPACT화
2. 업무이행률 <--- SALARY (평균 샐러리) 로 환산해서 만들고, 여기다 SALARY를 넣어야... 
3. 복지/건강관련 TABLE 가라로 만들기... 
4. 기존 DEPARTE + 부서 업무 성과 지표

