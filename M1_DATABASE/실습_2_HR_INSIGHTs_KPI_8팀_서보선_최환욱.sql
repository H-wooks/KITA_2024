---------------------- Entities: EMPLOYEES,DEPARTMENTS,JOBS,JOB_HISTORY,LOCATIONS,COUNTRIES,REGIONS
---------------------- Attributes:  
-- EMPLOYEES: EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
-- DEPARTMENTS: DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID
-- JOBS: JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY
-- JOB_HISTORY: EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID
-- LOCATIONS: LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID
-- COUNTRIES: COUNTRY_ID, COUNTRY_NAME, COUNTRY_NAME, REGION_ID
-- REGIONS: REGION_ID, REGION_NAME

-- 실습
-- 현재 hr에 있는 7개 테이블을 분석해서 인사관리에 의미있는 인사이트 5개 이상을 기술하세요
-- 인사관리 개선을 위한 KPI 2개를 설정하고 이것들을 테이블의 데이터에 반영한 후 다시 분석해서 반영 여부를 검증하세요

-- VIEW POINTS: (1) 인사 DB 관리 측면 (DATA 간 CONSISTENCY ISSUE, 충분한 DATA 확보 여부) 
--              (2) 인력 관리/평가 측면 (근태, 개인 목표 지표 달성 MONITORING)에서 보완점
--              (3) 인적 역량 향상/경쟁력 강화를 위한 인사관리 SYSTEM의 구축에 필요한 보안점
--              (4) GREAT WORK PLACE(GWP), WORK-LIFE BALANCE를 위한 HR-DB나 인사 관리

-- INSIGHT-1 : 인사 DB 관리 측면에서 현재 7개의 EMPLOYEES,DEPARTMENTS,JOBS,JOB_HISTORY,LOCATIONS,COUNTRIES,REGIONS TABLE이 있지만 REDUNDANCY가 많고 비효율적 
            -- ROCATION/CONTRY/REGION 는 한 TABLE로 통합관리하는게 효율적, EMPLOYEES/DEPARTMENT는 일부 중복 요소를 EMPLOYEES로 통합 관리할 필요가 있음
            -- TABLE 간 PRIMARY/FOREIGN KEY 종속성 부여 필요

-- INSIGHT-2 : DATA간 INCONSISTENCY ISSUE & REDUDANCY 문제
            -- (EMPLOYEES 테이블의 MANAGER_ID와 EMPLOYEES 테이블에 개인별로 ASSIGN된 DEPARTMENT_ID로 DEPARTMENTS 테이블에서의 DEPARTMENT별 MANAGER_ID간 미스매치 
            -- 부서 ASSIGN이 안된 직원 (KIMBERELY GRANT)
            -- DEPARTMENTS에서 DEPARTMENT_ID: 120~270에 대해 MANAGER가 ASSIGN 안됨 (부서원이 존재 하지 않아서 문제는 되지 않지만, 그렇더라도 REDUNDANT DATA)
            -- 직원 핸드폰 번호에 INVALID FORMAT의 전화 번호 미국: XXX.XXX.XXXX (O), 영국: (0XX(X).XXX(X).XXXX TYPE), 

-- INSIGHT-3 : 인력 관리/평가 측면 HR 부서 MANDATORY DB의 부재
            -- (관리) 근태 관리 DB BUILDING이 필요
            -- (관리) 과다 근무자, 잉여 근무자 관리 SYSTEM 필요 ==> 인력 재조정
            -- (관리) HR의 핵심: 인력 확보/유지. 그런 의미에서 퇴사자들에대한 정보의 부재 (JOB-HISTORY, 퇴직원인 분석, 근속,부서,연봉, 이직,..)
            -- (평가) 성과 관리 DB BUILDING이 필요 (개인별 ==> INDIVIDUAL_PERF, 부서별: DEPARTMENTS==> DEPARTMENT_PERF)
            -- (평가) 개인 (개인 연차별, 지역별, 부서별, 직무별,..) SALARY 분석 쿼리 필요
            
-- INSIGHT-4 : 조직원 역량 강화를 위한 관리 DB의 부재            
            -- 저역량 직원들에 대한 업무 SKILL-UP 기회 보장: 
            -- 저평가자(저연봉자)을 위한 교육/MENTORING 제도 (MENTOR:상위평가자/선배, MENTEE: 저평가자)
            -- 업무 성과에 따른 성과금 명복의 COMMISSION PERCENT는 SALES 부서에만 책정
            
-- INSIGHT-5 : GREAT WORK PLACE (GWP), WORK - LIFE BALANCE를 위한 HR-DB나 관리 프로그램 부재(회사/조직의 영속성/개선)
            -- 임직원 건강 (건진/지병/업무/부서 STRESS...) 관련 DB의 부재
            -- 근무 시간 조정 DB(개인별/부서멸 인력 충원 근무시간 BALANCE 유도를 위한 DB)
            -- HR 부서에서 명상/마음건강/건진... 프로그램 개설/관리 

-- REMARKS: DB내 DATA간 INCONSISTENCY ISSUE 중요성

--------------------------------------------- KPI (Key Performance Indicator/index) ---------------------------------------------
-- Key: (1) 중요성, (2) 측정 가능한 정량적 지표, (3) 시기별 관리 가능

-- KPI-1 : (1-1) DEFECT FREE DB의 구현(KPI INDEX: DEFECT당 달성률 -2%): DB의 REDUNDANCY 제거, 기존 TABLE을 COMPACT하게 개선, DATA INCONSISTENCY 제거
              -- EMPLOYEES&(DEPARTMENT 일부 속성) ==> EMPLOYEES_NEW TABLE
              -- LOCATIONS/COUNTRIES/REGIONS ==> LOCATIONS 통합 관리
              -- PRIMARY/FOREIGN KEY 설정
        -- (1-2) 인사관리 개선위한 신규 DATA TABLE 생성/관리
              -- 근태 (TA_MANAGEMENT), 성과 (INDIVIDUAL_PERF,DEPARTMENTS==>DEPARTMENT_PERF), 퇴직자(RESIGNEE) 관리 DB TABLE 생성
              
-- KPI-2 : 인적 자원 관리의 개선 (KPI INDEX: 근무과다자,부실근태자 ZERO 실현 (전년 대비 -10% 각 100% 달성, 역량개선 필요자 전년 대비 -5%가 100%달성)
              -- 근태 (TA_MANAGEMENT) DB ==> 쿼리 ==> 근무 과다자, 부실 근태자 도출 ==> 업무 BALANCE/부서 조정, 명상 프로그램 권고
              -- 목표 대비 성과 관리 (개인/부서 합산) DB ==> 쿼리 ==> 상벌(INCENTIVE 부여)자 선정
              -- 하위 성과자를 위한 교육 프로그램 및 MENTOR/MENTEE 프로그램 기획/ 대상자 선정.
              -- 건강 관리 / 면답 관리 DB ==> 인사 특이점 발굴


--------------------------------------------------------------------------------- FLATTEN ALL DB TO REVIEW DATA CONSISTENCY
DROP VIEW EMPLOYEES_NEW;
DROP TABLE EMPLOYEES_NEW;
CREATE VIEW EMPLOYEES_NEW AS
SELECT 
    E.EMPLOYEE_ID 사번,
    E.FIRST_NAME || ' ' || E.LAST_NAME 이름,
    E.EMAIL 이메일,
    E.PHONE_NUMBER 핸드폰번호,
    E.HIRE_DATE 입사일자,
    FLOOR(MONTHS_BETWEEN(SYSDATE, E.HIRE_DATE) / 12) 연차,
    E.SALARY 급여,
    CASE WHEN E.SALARY BETWEEN J.MIN_SALARY AND J.MAX_SALARY THEN 'IN_RANGE' ELSE 'OUT_RANGE' END AS 급여범위,
    DECODE(E.COMMISSION_PCT, NULL, 'N', E.COMMISSION_PCT) 매출성과,
    E.JOB_ID  담당업무,
    E.MANAGER_ID 담당매니저ID,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS 담당매니저,
    E.DEPARTMENT_ID 부서ID,
    D.DEPARTMENT_NAME 부서명,
    D.MANAGER_ID 담당매니저ID2,
    DECODE(E.MANAGER_ID, D.MANAGER_ID, '정합', '부정합') AS 매니저정합성,
    L.CITY 근무도시,
    C.COUNTRY_ID 근무국가,
    R.REGION_NAME 근무대륙
FROM 
    EMPLOYEES E
LEFT JOIN 
    EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
LEFT JOIN 
    DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN
    JOBS J ON E.JOB_ID = J.JOB_ID
LEFT JOIN
    LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
LEFT JOIN
    COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID    
LEFT JOIN
    REGIONS R ON C.REGION_ID = R.REGION_ID        
ORDER BY E.EMPLOYEE_ID;
-------------------------------------------------------------------------------------
SELECT * FROM EMPLOYEES_NEW;
        -- 담당매니저ID VS. 담당매니저ID2 부터 데이터 부정합성 확인
        -- 모든 인사 관리 DB에는 단순 직원의 정보만 있어 1~2개의 DB로 통합 관리하는 것이 효율적임
        -- DEPARTMENTS에서 DEPARTMENT_ID: 120~270에 대해 MANAGER가 ASSIGN 안됨 (부서원이 존재 하지 않아서 문제는 되지 않지만, 그렇더라도 REDUNDANT DATA) 확인

SELECT * FROM EMPLOYEES_NEW 
WHERE 부서명 IS NULL;            

            -- 직원 핸드폰 번호에 INVALID FORMAT의 전화 번호 미국: XXX.XXX.XXXX (O), 영국: (0XX(X).XXX(X).XXXX TYPE) 확인
SELECT 
    사번,이름,핸드폰번호,근무대륙,
    CASE
        WHEN 근무대륙 = 'Europe' AND (REGEXP_LIKE(핸드폰번호, '^0[0-9]{2}\.[0-9]{4}\.[0-9]{4}$') OR REGEXP_LIKE(핸드폰번호, '^0[0-9]{3}\.[0-9]{3}\.[0-9]{4}$')) THEN 'PASS'
        WHEN 근무대륙 = 'Americas' AND REGEXP_LIKE(핸드폰번호, '^[0-9]{3}\.[0-9]{3}\.[0-9]{4}$') THEN 'PASS'
        ELSE 'FAIL'
    END AS VALID_HP
FROM 
    EMPLOYEES_NEW;

---------------------------------------------------------- 급여 비교 ---------------------------------------------------------------------
SELECT 
    사번, 
    이름, 
    연차, 
    급여,
    담당업무, 
    부서명, 
    근무도시, 
    근무국가, 
    근무대륙,
    ROUND(AVG(급여) OVER (PARTITION BY 연차)) AS 연차별평균급여,
    ROUND(AVG(급여) OVER (PARTITION BY 담당업무)) AS 담당업무별평균급여,
    ROUND(AVG(급여) OVER (PARTITION BY 부서명)) AS 부서별평균급여,
    ROUND(AVG(급여) OVER (PARTITION BY 근무도시)) AS 근무도시별평균급여,
    ROUND(AVG(급여) OVER (PARTITION BY 근무국가)) AS 근무국가별평균급여,
    ROUND(AVG(급여) OVER (PARTITION BY 근무대륙)) AS 근무대륙별평균급여
FROM 
    EMPLOYEES_NEW;

---------------------------------------------------------- 임직원 수 비교 ---------------------------------------------------------------------
-- 연차별
SELECT 연차, COUNT(*) 임직원수 FROM EMPLOYEES_NEW
GROUP BY 연차
ORDER BY 임직원수;

-- 부서별
SELECT 부서명, COUNT(*) 임직원수 FROM EMPLOYEES_NEW
GROUP BY 부서명
ORDER BY 임직원수;

-- 도시별
SELECT 근무도시, COUNT(*) 임직원수 FROM EMPLOYEES_NEW
GROUP BY 근무도시
ORDER BY 임직원수;

-- 국가별
SELECT 근무국가, COUNT(*) 임직원수 FROM EMPLOYEES_NEW
GROUP BY 근무국가
ORDER BY 임직원수;

-- 대륙별
SELECT 근무대륙, COUNT(*) 임직원수 FROM EMPLOYEES_NEW
GROUP BY 근무대륙
ORDER BY 임직원수;

---------------------------------------------------------- 평균 연봉 비교 ---------------------------------------------------------------------
-- 연차별
SELECT 연차, ROUND(AVG(급여)) 평균연봉 FROM EMPLOYEES_NEW
GROUP BY 연차
ORDER BY 평균연봉;

-- 부서별
SELECT 부서명, ROUND(AVG(급여)) 평균연봉 FROM EMPLOYEES_NEW
GROUP BY 부서명
ORDER BY 평균연봉;

-- 도시별
SELECT 근무도시, ROUND(AVG(급여)) 평균연봉 FROM EMPLOYEES_NEW
GROUP BY 근무도시
ORDER BY 평균연봉;

-- 국가별
SELECT 근무국가, ROUND(AVG(급여)) 평균연봉 FROM EMPLOYEES_NEW
GROUP BY 근무국가
ORDER BY 평균연봉;

-- 대륙별
SELECT 근무대륙, ROUND(AVG(급여)) 평균연봉 FROM EMPLOYEES_NEW
GROUP BY 근무대륙
ORDER BY 평균연봉;

-------------------------------------------------------------------------------
DROP VIEW EMPLOYEES_NEW;
DROP TABLE EMPLOYEES_NEW CASCADE CONSTRAINTS PURGE;
--------------------------------------------------------------- VIEW가 아닌 실재 NEW TABLE을 생성
-- EMPLOYEES_NEW 테이블 생성
CREATE TABLE EMPLOYEES_NEW (
    EMPLOYEE_ID NUMBER,
    NAME VARCHAR2(100),
    EMAIL VARCHAR2(100),
    PHONE_NUMBER VARCHAR2(20),
    HIRE_DATE DATE,
    WORK_YEAR NUMBER,
    SALARY NUMBER,
    COMMISSION_PCT VARCHAR2(10),
    JOB_ID VARCHAR2(100),
    MANAGER_ID NUMBER,
    DEPARTMENT_ID NUMBER,
    DEPARTMENT_NAME VARCHAR2(100),
    담당매니저ID2 NUMBER,
    CITY VARCHAR2(100),
    COUNTRY_ID VARCHAR2(2),
    REGION_NAME VARCHAR2(100)
);

-- EMPLOYEES_NEW에 데이터 INSERT
INSERT INTO EMPLOYEES_NEW (
    EMPLOYEE_ID,
    NAME,
    EMAIL,
    PHONE_NUMBER,
    HIRE_DATE,
    WORK_YEAR,
    SALARY,
    COMMISSION_PCT,
    JOB_ID,
    MANAGER_ID,
    DEPARTMENT_ID,
    DEPARTMENT_NAME,
    담당매니저ID2,
    CITY,
    COUNTRY_ID,
    REGION_NAME
)
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME || ' ' || E.LAST_NAME,
    E.EMAIL,
    E.PHONE_NUMBER,
    E.HIRE_DATE,
    FLOOR(MONTHS_BETWEEN(SYSDATE, E.HIRE_DATE) / 12),
    E.SALARY,
    DECODE(E.COMMISSION_PCT, NULL, 'N', E.COMMISSION_PCT),
    E.JOB_ID,
    E.MANAGER_ID,
    E.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    D.MANAGER_ID,
    L.CITY,
    C.COUNTRY_ID,
    R.REGION_NAME
FROM 
    EMPLOYEES E
LEFT JOIN 
    EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
LEFT JOIN 
    DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN
    JOBS J ON E.JOB_ID = J.JOB_ID
LEFT JOIN
    LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
LEFT JOIN
    COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID    
LEFT JOIN
    REGIONS R ON C.REGION_ID = R.REGION_ID;

SELECT * FROM EMPLOYEES_NEW ORDER BY EMPLOYEE_ID;

------------------------------------------------------------- INVALID TYPE 전화 번호 수정
UPDATE EMPLOYEES_NEW
SET PHONE_NUMBER = 
    CASE 
        WHEN REGION_NAME = 'Europe' THEN 
            CASE 
                WHEN REGEXP_LIKE(PHONE_NUMBER, '^0[0-9]{2}\.[0-9]{4}\.[0-9]{4}$') OR 
                     REGEXP_LIKE(PHONE_NUMBER, '^0[0-9]{3}\.[0-9]{3}\.[0-9]{4}$') THEN 
                         PHONE_NUMBER
                ELSE
                    '0' || LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 999)), 3, '0') || '.' ||
                    LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 999)), 3, '0') || '.' ||
                    LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 9999)), 4, '0')
            END
        WHEN REGION_NAME = 'Americas' THEN 
            CASE 
                WHEN REGEXP_LIKE(PHONE_NUMBER, '^[0-9]{3}\.[0-9]{3}\.[0-9]{4}$') THEN 
                    PHONE_NUMBER
                ELSE
                    LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 999)), 3, '0') || '.' ||
                    LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 999)), 3, '0') || '.' ||
                    LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 9999)), 4, '0')
            END
    END;

SELECT * FROM EMPLOYEES_NEW ORDER BY EMPLOYEE_ID;
------------------------------------------------------------- 매니저부정합 수정
UPDATE EMPLOYEES_NEW SET MANAGER_ID = 담당매니저ID2;
ALTER TABLE EMPLOYEES_NEW DROP COLUMN 담당매니저ID2;
------------------------------------------------------------- 부서 누락 직원 (KIMBERELY GRANT) DATA 수정
UPDATE EMPLOYEES_NEW
SET 
    MANAGER_ID = 145,
    DEPARTMENT_ID = 80,
    DEPARTMENT_NAME = 'Sales',
    CITY = 'Oxford',
    COUNTRY_ID = 'UK',
    REGION_NAME = 'Europe'
WHERE EMPLOYEE_ID = 178;


------------------------------------------------- 인사 역량 평가/관리를 위한 INDIVIDUAL_PERF 테이블 생성
DROP TABLE INDIVIDUAL_PERF CASCADE CONSTRAINTS PURGE;
CREATE TABLE INDIVIDUAL_PERF (
    EMPLOYEE_ID NUMBER,
    NAME VARCHAR2(100),
    SALARY NUMBER,
    NEXT_YEAR_SALARY NUMBER,
    ACHIEVEMENT_VERSUS_GOAL NUMBER,
    LAST_YEAR_GRADE VARCHAR2(100),
    GRADE VARCHAR2(100),
    ENHANCEMENT_PROGRAM VARCHAR2(100),
    MENTOR VARCHAR2(100),
    MENTEE VARCHAR2(100)
);

-- EMPLOYEES 테이블로부터 데이터 삽입
INSERT INTO INDIVIDUAL_PERF (EMPLOYEE_ID, NAME, SALARY)
SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME AS NAME, SALARY
FROM EMPLOYEES;

-- 나머지 컬럼은 NULL로 초기화
UPDATE INDIVIDUAL_PERF
SET NEXT_YEAR_SALARY = NULL,
    ACHIEVEMENT_VERSUS_GOAL = NULL,
    LAST_YEAR_GRADE = NULL,
    GRADE = NULL,
    ENHANCEMENT_PROGRAM = NULL,
    MENTOR = NULL,
    MENTEE = NULL;


SELECT * FROM INDIVIDUAL_PERF ORDER BY EMPLOYEE_ID;

-- EMPLOYEES_NEW TABLE에서는 단순 인사 기록만 관리하고 고과,급여 관리는 INDIVIDUAL_PERF TABLE로 
ALTER TABLE EMPLOYEES_NEW DROP COLUMN SALARY;

-- 목표대비성취도를 랜덤하게 업데이트
UPDATE INDIVIDUAL_PERF
SET ACHIEVEMENT_VERSUS_GOAL = FLOOR(DBMS_RANDOM.VALUE(60, 121));
SELECT * FROM INDIVIDUAL_PERF ORDER BY EMPLOYEE_ID;

-- 전년도평가를 랜덤하게 업데이트
UPDATE INDIVIDUAL_PERF
SET LAST_YEAR_GRADE = 
    CASE 
        WHEN DBMS_RANDOM.VALUE(0, 100) <= 10 THEN 'A'
        WHEN DBMS_RANDOM.VALUE(0, 100) <= 20 THEN 'B'
        WHEN DBMS_RANDOM.VALUE(0, 100) <= 95 THEN 'C'
        ELSE 'D'
    END;
    
-- 올해 인사 고과도 랜덤하게 업데이트
UPDATE INDIVIDUAL_PERF
SET GRADE = 
    CASE 
        WHEN DBMS_RANDOM.VALUE(0, 100) <= 10 THEN 'A'
        WHEN DBMS_RANDOM.VALUE(0, 100) <= 20 THEN 'B'
        WHEN DBMS_RANDOM.VALUE(0, 100) <= 95 THEN 'C'
        ELSE 'D'
    END;
    
    
-- NEXT_YEAR_SALARY를 업데이트하는 코드 올해 인사고과를 바탕으로 A/B/C/D에 대해 각각 X 1.2, 1.1, 1, 0.9
UPDATE INDIVIDUAL_PERF
SET NEXT_YEAR_SALARY = 
    CASE 
        WHEN GRADE = 'A' THEN SALARY * 1.2
        WHEN GRADE = 'B' THEN SALARY * 1.1
        WHEN GRADE = 'C' THEN SALARY * 1
        WHEN GRADE = 'D' THEN SALARY * 0.9
    END;
    
SELECT * FROM INDIVIDUAL_PERF ORDER BY EMPLOYEE_ID;


------------------------------------------------------------------ LOCATIONS_NEW 테이블 생성
DROP TABLE LOCATIONS_NEW CASCADE CONSTRAINTS PURGE;
CREATE TABLE LOCATIONS_NEW (
    REGION_ID NUMBER 
    ,REGION_NAME VARCHAR2(25)
    ,COUNTRY_ID CHAR(2)
    ,COUNTRY_NAME VARCHAR2(40)
    ,LOCATION_ID	NUMBER(4,0) PRIMARY KEY
    ,STREET_ADDRESS	VARCHAR2(40 BYTE)
    ,POSTAL_CODE	VARCHAR2(12 BYTE)
    ,CITY	VARCHAR2(30 BYTE)
    ,STATE_PROVINCE	VARCHAR2(25 BYTE)
);

-- 테이블에 들어갈 정보 조회
SELECT
    r.region_id
    ,r.region_name
    ,c.country_id
    ,c.country_name
    ,l.location_id
    ,l.street_address
    ,l.postal_code
    ,l.city
    ,l.state_province
FROM
    regions r
    ,countries c
    ,locations l
WHERE
    r.region_id = c.region_id
    AND c.country_id = l.country_id
ORDER BY
    r.region_id
    ,c.country_id
    ,l.location_id
;

-- 조회된 정보들 테이블에 저장
INSERT INTO 
    LOCATIONS_NEW 
SELECT
    r.region_id
    ,r.region_name
    ,c.country_id
    ,c.country_name
    ,l.location_id
    ,l.street_address
    ,l.postal_code
    ,l.city
    ,l.state_province
FROM
    regions r
    ,countries c
    ,locations l
WHERE
    r.region_id = c.region_id
    AND c.country_id = l.country_id
ORDER BY
    r.region_id
    ,c.country_id
    ,l.location_id
        
;

SELECT * FROM LOCATIONS_NEW;

---------------------------------------------- 복지 테이블 생성
DROP TABLE WELFARE CASCADE CONSTRAINTS PURGE;
CREATE TABLE WELFARE (
    EMPLOYEE_ID NUMBER,
    NAME VARCHAR2(100),
    MEDICAL_CHECK VARCHAR2(50),
    REMARKS VARCHAR2(100)
);

-- EMPLOYEES_NEW TABLE로부터 데이터 삽입
INSERT INTO WELFARE (EMPLOYEE_ID, NAME, MEDICAL_CHECK, REMARKS)
SELECT EMPLOYEE_ID, NAME, 'DONE', NULL
FROM EMPLOYEES_NEW;

SELECT * FROM WELFARE ORDER BY EMPLOYEE_ID;


------------------------------------------------------------------- 근태 테이블 생성   
DROP TABLE TA_MANAGEMENT CASCADE CONSTRAINTS PURGE;
CREATE TABLE TA_MANAGEMENT(
    EMPLOYEE_ID NUMBER
    ,WORK_YEAR VARCHAR2(4) 
    ,ABSENCE_DAYS NUMBER
    ,AVG_WORK_HOURS_PER_WEEK NUMBER
    ,FOREIGN KEY (EMPLOYEE_ID) REFERENCES employees(EMPLOYEE_ID) ON DELETE CASCADE
);

INSERT INTO TA_MANAGEMENT VALUES(118, '2021', 20, 40);
INSERT INTO TA_MANAGEMENT VALUES(136, '2022', 21, 45);
INSERT INTO TA_MANAGEMENT VALUES(157, '2023', 15, 50);
INSERT INTO TA_MANAGEMENT VALUES(203, '2021', 10, 55);
INSERT INTO TA_MANAGEMENT VALUES(148, '2022', 30, 60);
INSERT INTO TA_MANAGEMENT VALUES(128, '2023', 5, 65);
INSERT INTO TA_MANAGEMENT VALUES(190, '2021', 25, 70);
INSERT INTO TA_MANAGEMENT VALUES(101, '2022', 12, 75);
INSERT INTO TA_MANAGEMENT VALUES(159, '2023', 18, 80);
INSERT INTO TA_MANAGEMENT VALUES(148, '2022', 35, 45);
INSERT INTO TA_MANAGEMENT VALUES(128, '2023', 22, 50);
INSERT INTO TA_MANAGEMENT VALUES(204, '2021', 17, 55);
INSERT INTO TA_MANAGEMENT VALUES(175, '2022', 28, 60);
INSERT INTO TA_MANAGEMENT VALUES(197, '2023', 13, 65);
INSERT INTO TA_MANAGEMENT VALUES(124, '2021', 24, 70);
INSERT INTO TA_MANAGEMENT VALUES(147, '2022', 11, 75);
INSERT INTO TA_MANAGEMENT VALUES(193, '2023', 19, 80);
INSERT INTO TA_MANAGEMENT VALUES(135, '2022', 29, 45);
INSERT INTO TA_MANAGEMENT VALUES(202, '2023', 23, 50);
INSERT INTO TA_MANAGEMENT VALUES(194, '2022', 27, 60);
INSERT INTO TA_MANAGEMENT VALUES(146, '2023', 14, 65);
INSERT INTO TA_MANAGEMENT VALUES(192, '2022', 9, 75);
INSERT INTO TA_MANAGEMENT VALUES(163, '2023', 20, 80);
INSERT INTO TA_MANAGEMENT VALUES(202, '2021', 6, 40);
INSERT INTO TA_MANAGEMENT VALUES(143, '2022', 31, 45);
INSERT INTO TA_MANAGEMENT VALUES(179, '2023', 18, 50);

INSERT INTO TA_MANAGEMENT VALUES(169, '2021', 26, 70);
INSERT INTO TA_MANAGEMENT VALUES(165, '2021', 16, 55);
INSERT INTO TA_MANAGEMENT VALUES(149, '2021', 7, 40);
INSERT INTO TA_MANAGEMENT VALUES(161, '2021', 8, 40);
INSERT INTO TA_MANAGEMENT VALUES(156, '2021', 32, 85);

SELECT * FROM TA_MANAGEMENT ORDER BY EMPLOYEE_ID;


--------------------------------------------------------퇴사자 명단 테이블 생성
DROP TABLE resignation CASCADE CONSTRAINTS PURGE;
CREATE TABLE resignation (
    EMPLOYEE_ID NUMBER 
    ,START_DATE	DATE
    ,END_DATE	DATE
    ,JOB_ID	VARCHAR2(10)
    ,JOB_TITLE VARCHAR2(35)
    ,DEPARTMENT_ID	NUMBER
    ,DEPARTMENT_NAME VARCHAR2(30)
    ,RESIGN_REASON VARCHAR2(100)
);

INSERT INTO resignation VALUES (67, TO_DATE('2021-09-05', 'YYYY-MM-DD'), TO_DATE('2022-06-20', 'YYYY-MM-DD'), 'SA_MAN', 'Sales Manager', 50, 'Shipping', '회사 경영 정책 변화');
INSERT INTO resignation VALUES (18, TO_DATE('2022-03-12', 'YYYY-MM-DD'), TO_DATE('2022-10-30', 'YYYY-MM-DD'), 'HR_REP', 'Human Resources Representative', 100, 'Finance', '직무 불만족');
INSERT INTO resignation VALUES (82, TO_DATE('2021-12-30', 'YYYY-MM-DD'), TO_DATE('2022-08-15', 'YYYY-MM-DD'), 'AC_ACCOUNT', 'Public Accountant', 190, 'Contracting', '이직');
INSERT INTO resignation VALUES (57, TO_DATE('2022-04-18', 'YYYY-MM-DD'), TO_DATE('2022-12-05', 'YYYY-MM-DD'), 'FI_MGR', 'Finance Manager', 70, 'Public Relations', '회사 경영 정책 변화');
INSERT INTO resignation VALUES (39, TO_DATE('2022-02-28', 'YYYY-MM-DD'), TO_DATE('2022-10-15', 'YYYY-MM-DD'), 'PU_MAN', 'Purchasing Manager', 160, 'Benefits', '경제적 이유');
INSERT INTO resignation VALUES (67, TO_DATE('2021-10-10', 'YYYY-MM-DD'), TO_DATE('2022-06-25', 'YYYY-MM-DD'), 'ST_CLERK', 'Stock Clerk', 130, 'Corporate Tax', '다른 분야로의 전직');
INSERT INTO resignation VALUES (29, TO_DATE('2021-08-20', 'YYYY-MM-DD'), TO_DATE('2022-05-05', 'YYYY-MM-DD'), 'SH_CLERK', 'Shipping Clerk', 50, 'Shipping', '경제적 이유');
INSERT INTO resignation VALUES (93, TO_DATE('2022-01-15', 'YYYY-MM-DD'), TO_DATE('2022-09-30', 'YYYY-MM-DD'), 'IT_PROG', 'Programmer', 60, 'IT', '회사 퇴행');
INSERT INTO resignation VALUES (50, TO_DATE('2021-11-28', 'YYYY-MM-DD'), TO_DATE('2022-07-15', 'YYYY-MM-DD'), 'MK_MAN', 'Marketing Manager', 20, 'Marketing', '직무 불만족');
INSERT INTO resignation VALUES (15, TO_DATE('2021-07-22', 'YYYY-MM-DD'), TO_DATE('2022-03-10', 'YYYY-MM-DD'), 'PR_REP', 'Public Relations Representative', 250, 'Retail Sales', '경영 철학의 불일치');
INSERT INTO resignation VALUES (107, TO_DATE('2022-06-15', 'YYYY-MM-DD'), TO_DATE('2023-03-30', 'YYYY-MM-DD'), 'IT_PROG', 'Programmer', 60, 'IT', '급여 불만족');
INSERT INTO resignation VALUES (88, TO_DATE('2022-03-05', 'YYYY-MM-DD'), TO_DATE('2022-10-20', 'YYYY-MM-DD'), 'PU_MAN', 'Purchasing Manager', 160, 'Benefits', '직무 불만족');
INSERT INTO resignation VALUES (22, TO_DATE('2021-09-20', 'YYYY-MM-DD'), TO_DATE('2022-05-05', 'YYYY-MM-DD'), 'PR_REP', 'Public Relations Representative', 190, 'Contracting', '경제적 이유');
INSERT INTO resignation VALUES (93, TO_DATE('2021-12-12', 'YYYY-MM-DD'), TO_DATE('2022-07-28', 'YYYY-MM-DD'), 'HR_REP', 'Human Resources Representative', 100, 'Finance', '이직');
INSERT INTO resignation VALUES (55, TO_DATE('2022-02-08', 'YYYY-MM-DD'), TO_DATE('2022-09-23', 'YYYY-MM-DD'), 'IT_PROG', 'Programmer', 200, 'Operations', '경제적 이유');
INSERT INTO resignation VALUES (81, TO_DATE('2021-08-17', 'YYYY-MM-DD'), TO_DATE('2022-03-03', 'YYYY-MM-DD'), 'AC_MGR', 'Accounting Manager', 60, 'IT', '직무 불만족');
INSERT INTO resignation VALUES (19, TO_DATE('2021-10-28', 'YYYY-MM-DD'), TO_DATE('2022-06-12', 'YYYY-MM-DD'), 'AC_ACCOUNT', 'Public Accountant', 70, 'Public Relations', '회사 경영 정책 변화');
INSERT INTO resignation VALUES (61, TO_DATE('2022-01-15', 'YYYY-MM-DD'), TO_DATE('2022-08-30', 'YYYY-MM-DD'), 'SA_MAN', 'Sales Manager', 80, 'Sales', '가족 이유로 인한 퇴사');
INSERT INTO resignation VALUES (37, TO_DATE('2021-07-04', 'YYYY-MM-DD'), TO_DATE('2022-02-18', 'YYYY-MM-DD'), 'MK_MAN', 'Marketing Manager', 160, 'Benefits', '이직');
INSERT INTO resignation VALUES (49, TO_DATE('2022-04-22', 'YYYY-MM-DD'), TO_DATE('2023-01-07', 'YYYY-MM-DD'), 'PU_MAN', 'Purchasing Manager', 100, 'Finance', '경제적 이유');
INSERT INTO resignation VALUES (84, TO_DATE('2021-11-10', 'YYYY-MM-DD'), TO_DATE('2022-06-25', 'YYYY-MM-DD'), 'IT_PROG', 'Programmer', 200, 'Operations', '직무 불만족');
INSERT INTO resignation VALUES (29, TO_DATE('2022-02-20', 'YYYY-MM-DD'), TO_DATE('2022-09-05', 'YYYY-MM-DD'), 'ST_MAN', 'Stock Manager', 120, 'Treasury', '이직');
INSERT INTO resignation VALUES (73, TO_DATE('2021-09-03', 'YYYY-MM-DD'), TO_DATE('2022-04-18', 'YYYY-MM-DD'), 'FI_MGR', 'Finance Manager', 70, 'Public Relations', '경제적 이유');
INSERT INTO resignation VALUES (59, TO_DATE('2022-05-15', 'YYYY-MM-DD'), TO_DATE('2023-01-29', 'YYYY-MM-DD'), 'SH_CLERK', 'Shipping Clerk', 140, 'Control And Credit', '급여 불만족');
INSERT INTO resignation VALUES (15, TO_DATE('2021-08-07', 'YYYY-MM-DD'), TO_DATE('2022-03-22', 'YYYY-MM-DD'), 'IT_PROG', 'Programmer', 150, 'Shareholder Services', '경제적 이유');
INSERT INTO resignation VALUES (78, TO_DATE('2021-10-25', 'YYYY-MM-DD'), TO_DATE('2022-06-09', 'YYYY-MM-DD'), 'MK_MAN', 'Marketing Manager', 160, 'Benefits', '직무 불만족');
INSERT INTO resignation VALUES (43, TO_DATE('2022-03-18', 'YYYY-MM-DD'), TO_DATE('2022-10-02', 'YYYY-MM-DD'), 'MK_REP', 'Marketing Representative', 170, 'Manufacturing', '경제적 이유');
INSERT INTO resignation VALUES (102, TO_DATE('2021-12-01', 'YYYY-MM-DD'), TO_DATE('2022-07-16', 'YYYY-MM-DD'), 'HR_REP', 'Human Resources Representative', 180, 'Construction', '회사 퇴행');
INSERT INTO resignation VALUES (36, TO_DATE('2022-01-05', 'YYYY-MM-DD'), TO_DATE('2022-08-20', 'YYYY-MM-DD'), 'PR_REP', 'Public Relations Representative', 190, 'Contracting', '급여 불만족');
INSERT INTO resignation VALUES (63, TO_DATE('2021-09-14', 'YYYY-MM-DD'), TO_DATE('2022-04-29', 'YYYY-MM-DD'), 'IT_PROG', 'Programmer', 200, 'Operations', '직무 불만족');

SELECT * FROM RESIGNATION;


COMMIT;

    

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
SELECT * FROM JOB_HISTORY;
SELECT * FROM LOCATIONS;
SELECT * FROM REGIONS;
SELECT * FROM COUNTRIES;