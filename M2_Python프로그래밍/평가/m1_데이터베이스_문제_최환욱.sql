교과목명 : 데이터베이스 구축 및 활용

- 평가일 : 24.05.24
- 성명 : 최환욱
- 점수 :

※ HR TABLES(EMPLOYEES, DEPARTMENTS, COUNTRIES, JOB_HISSTORY, JOBS, LOCATIONS, REGIONS)를 활용하여 다음 질문들을 수행하세요.
--Q1. EMPLOYEES 테이블에서 이름, 연봉, 10% 인상된 연봉을 출력하세요.
SELECT 
    FIRST_NAME||' '||LAST_NAME 이름, 
    SALARY 연봉, SALARY*1.1 "인상된 연봉" 
FROM EMPLOYEES;
    
--Q2. EMPLOYEES 테이블에서 2005년 상반기에 입사한 사람들만 출력	
SELECT 
    EMPLOYEE_ID 직번,
    FIRST_NAME||' '||LAST_NAME 이름, 
    HIRE_DATE     
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YY/MM') BETWEEN '05/01' AND '05/06';

--Q3. EMPLOYEES 테이블에서 업무 SA_MAN, IT_PROG, ST_MAN 인 사람만 출력
SELECT 
    EMPLOYEE_ID 직번,
    FIRST_NAME||' '||LAST_NAME 이름, 
    JOB_ID 업무
FROM EMPLOYEES
WHERE JOB_ID IN ('SA_MAN', 'IT_PROG', 'ST_MAN');
   
--Q4. EMPLOYEES 테이블에서 manager_id 가 101에서 103인 사람만 출력

SELECT 
    EMPLOYEE_ID 직번,
    FIRST_NAME||' '||LAST_NAME 이름, 
    JOB_ID 업무코드,
    DEPARTMENT_ID 부서코드,
    MANAGER_ID 매니저코드
FROM EMPLOYEES
WHERE MANAGER_ID IN (101,102,103);

--Q5. EMPLOYEES 테이블에서 LAST_NAME, HIRE_DATE 및 입사일의 6개월 후 첫 번째 월요일을 출력하세요.
SELECT 
    LAST_NAME, 
    HIRE_DATE, 
    NEXT_DAY(ADD_MONTHS(HIRE_DATE, 6), '월') REVISED_DATE 
FROM EMPLOYEES;

--Q6. EMPLOYEES 테이블에서 EMPLPYEE_ID, LAST_NAME, SALARY, HIRE_DATE 및 입사일 기준으로 현재일까지의 W_MONTH(근속월수)를 정수로 계산해서 출력하세요.(근속월수 기준 내림차순)
SELECT 
    EMPLOYEE_ID, 
    LAST_NAME, 
    SALARY, 
    HIRE_DATE, 
    FLOOR(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)) AS "W_MONTH(근속월수)"
FROM EMPLOYEES
ORDER BY "W_MONTH(근속월수)" DESC;

--Q7. EMPLOYEES 테이블에서 EMPLPYEE_ID, LAST_NAME, SALARY, HIRE_DATE 및 입사일 기준으로 W_YEAR(근속년수)를 계산해서 출력하세요.(근속년수 기준 내림차순)
SELECT 
    EMPLOYEE_ID, 
    LAST_NAME, 
    SALARY, 
    HIRE_DATE, 
    FLOOR(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) AS "W_YEAR(근속년수)"
FROM EMPLOYEES
ORDER BY "W_YEAR(근속년수)" DESC;

--Q8. EMPLOYEE_ID가 홀수인 직원의 EMPLPYEE_ID와 LAST_NAME을 출력하세요.
SELECT 
    EMPLOYEE_ID, 
    LAST_NAME 
FROM  EMPLOYEES
WHERE MOD(EMPLOYEE_ID, 2) = 1
ORDER BY EMPLOYEE_ID;

--Q9. EMPLOYEES 테이블에서 EMPLPYEE_ID, LAST_NAME 및 M_SALARY(월급)을 출력하세요. 단 월급은 소수점 둘째자리까지만 표현하세요.
-- 테이블의 SALARY가 연봉이라 놓고, /12, SALARY가 월봉이라면 /12 없이 그대로
SELECT 
    EMPLOYEE_ID, 
    LAST_NAME,
    -- SALARY
    ROUND(SALARY/12, 2) "M_SALARY(월급)"
FROM  EMPLOYEES
ORDER BY EMPLOYEE_ID;

--Q10. employees 테이블에서 salary가 10000원 이상인 직원만을 포함하는 뷰 special_employee를 생성하는 SQL 명령문을 작성하시오.

DROP VIEW special_employee;
CREATE VIEW special_employee AS
SELECT 
    EMPLOYEE_ID, 
    LAST_NAME, 
    SALARY
FROM EMPLOYEES
WHERE SALARY >= 10000;

SELECT * FROM special_employee
ORDER BY SALARY;

--Q11. EMPLOYEES 테이블에서 commission_pct 의  Null값 갯수를  출력하세요.
SELECT 
    COMMISSION_PCT, 
    COUNT(*) "NO_NULL"
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NULL
GROUP BY COMMISSION_PCT;

--Q12. EMPLOYEES 테이블에서 deparment_id 가 없는 직원을 추출하여  POSITION을 '신입'으로 출력하세요.
SELECT 
    EMPLOYEE_ID 사번, 
    FIRST_NAME||' '||LAST_NAME 이름, 
    '신입' POSISTION
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NULL;

--Q13. 사번이 120번인 사람의 사번, 이름, 업무(job_id), 업무명(job_title)을 출력(join~on, where 로 조인하는 두 가지 방법 모두)
-- OPTION 1 
SELECT 
    E.EMPLOYEE_ID 사번,
    E.FIRST_NAME||' '||E.LAST_NAME 이름, 
    E.JOB_ID 업무,
    J.JOB_TITLE 업무명
FROM EMPLOYEES E
LEFT JOIN
    JOBS J ON E.JOB_ID = J.JOB_ID
WHERE E.EMPLOYEE_ID=120;
   
    
-- OPTION 2 
SELECT 
    E.EMPLOYEE_ID 사번,
    E.FIRST_NAME||' '||E.LAST_NAME 이름, 
    E.JOB_ID 업무,
    J.JOB_TITLE 업무명
FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID = J.JOB_ID
AND E.EMPLOYEE_ID=120;


--Q14. HR EMPLOYEES 테이블에서 이름에 FIRST_NAME에 LAST_NAME을 붙여서 'NAME' 컬럼명으로 출력하세요.
--예) Steven King
SELECT 
    EMPLOYEE_ID 사번,
    FIRST_NAME||' '||LAST_NAME NAME 
FROM EMPLOYEES;

--Q15. HR EMPLOYEES 테이블에서 근속기간이 10년 이상인 직원을 포함하는 뷰를 생성하세요.

DROP VIEW MASTER;
CREATE VIEW MASTER AS
SELECT 
    LAST_NAME, 
    TRUNC(SYSDATE-HIRE_DATE) AS 근속기간,
    TRUNC((SYSDATE-HIRE_DATE)/365) AS 근속년수
    -- FLOOR(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) AS "W_YEAR(근속년수)" 이렇게 해도 됨
FROM EMPLOYEES
WHERE TRUNC(SYSDATE-HIRE_DATE) > 365*10;

SELECT * FROM MASTER 
ORDER BY 근속년수;

--Q16. HR EMPLOYEES 테이블에서 escape 옵션을 사용하여 아래와 같이 출력되는 SQL문을 작성하세요.
--job_id 칼럼에서  _을 와일드카드가 아닌 문자로 취급하여 '_A'를 포함하는  모든 행을 출력

SELECT * 
FROM EMPLOYEES 
WHERE JOB_ID LIKE '%\_A%' ESCAPE '\';

--Q17. HR EMPLOYEES 테이블에서 SALARY, LAST_NAME 순으로 올림차순 정렬하여 출력하세요.
SELECT * 
FROM EMPLOYEES 
ORDER BY SALARY, LAST_NAME;
-- ORDER BY SALARY ASC, LAST_NAME ASC;
   
--Q18. Seo라는 사람의 부서명을 출력하세요.
SELECT 
    E.EMPLOYEE_ID 사번, 
    E.LAST_NAME 이름, 
    D.DEPARTMENT_NAME 부서명
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND LOWER(E.LAST_NAME)='seo';

--Q19. JOB ID 별 몇년차는 얼마 받는지 각 년차별로 샐러리 평균을 구하세요.

-- OPTION1: 입사 후 년차 ==>  CEIL
SELECT 
    JOB_ID,
    CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) 입사연차,
    ROUND(AVG(SALARY)) AS 평균연봉,
    COUNT(*) 임직원수
FROM EMPLOYEES
GROUP BY JOB_ID,
    CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12)
ORDER BY 
    JOB_ID,
    CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12);
    
-- OPTION2 근속년차는 보통 만으로 따지기도 하는데 그렇다면 ==>  FOOL
SELECT 
    JOB_ID,
    FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) 입사연차,
    ROUND(AVG(SALARY)) AS 평균연봉,
    COUNT(*) 임직원수
FROM EMPLOYEES
GROUP BY JOB_ID,
    FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12)
ORDER BY 
    JOB_ID,
    FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12);
    
--Q20. HR EMPLOYEES 테이블에서 salary가 20000 이상이면 'a', 10000과 20000 미만 사이면 'b', 그 이하면 'c'로 표시하는 쿼리를 
--작성하시오.(case)
SELECT 
    EMPLOYEE_ID 사번, 
    FIRST_NAME||' '||LAST_NAME 이름, 
    SALARY, 
    CASE
        WHEN SALARY>=20000 THEN 'A'
        WHEN SALARY>10000 AND SALARY<20000 THEN 'B'
        ELSE 'C'
    END AS 인사고과
FROM EMPLOYEES;

--Q21. 학교 관리를 위하여 테이블 2개 이상으로 db를 구축하고 3개 이상 활용할 수 있는 case를 만드세요.(20점)
-- 실습 2인 1조 
-- 학교 관리를 위하여 테이블 2개 이상 DB로 구축하고 3개 이상 활용할 수 있는 CASE를 만드세요
-- 출결 관리, 학적관리, 성적 관리
DROP TABLE TEACHERS cascade constraints purge;
CREATE TABLE TEACHERS(
    NAME VARCHAR2(20), -- 이름
    BIRTH DATE, -- 생일
    AGE NUMBER, -- 나이
    SX VARCHAR2(10),    --  성별
    PHONE VARCHAR2(15), --  핸드폰번호
    ADDRESS VARCHAR2(50), -- 주소
    SUBJECT VARCHAR2(10), -- 담당 과목
    CLASS_ASSIGNED VARCHAR2(15), -- 담당 반
    PRIMARY KEY (CLASS_ASSIGNED)
);


DROP TABLE STUDENTS cascade constraints purge;
CREATE TABLE STUDENTS(
    NAME VARCHAR2(20), -- 학생명
    STDID NUMBER(10), -- 학생 번호
    BIRTH DATE, -- 학생 생일
    AGE NUMBER, -- 나이
    SX VARCHAR2(10), -- 성별
    PHONE VARCHAR2(15), -- 핸드폰 번호
    ADDRESS VARCHAR2(50), -- 주소
    FAV_JUBJECT VARCHAR2(10), -- 과목
    CLASS   VARCHAR2(15), -- 반
    FOREIGN KEY (CLASS) REFERENCES TEACHERS(CLASS_ASSIGNED) ON DELETE CASCADE
);

INSERT INTO TEACHERS VALUES ('김영희', '1993-02-03', 29, '여', '010-1234-5678', '서울 강남', '영어', '2학년 3반');
INSERT INTO TEACHERS VALUES ('이철수', '1987-12-15', 34, '남', '010-9876-5432', '부산 해운대', '과학', '1학년 2반');
INSERT INTO TEACHERS VALUES ('박민수', '1990-08-20', 31, '남', '010-1234-5678', '서울 서초', '수학', '3학년 1반');
INSERT INTO TEACHERS VALUES ('정지은', '1985-06-10', 36, '여', '010-5678-1234', '인천 남구', '국어', '2학년 2반');
INSERT INTO TEACHERS VALUES ('홍길동', '1991-03-25', 30, '남', '010-9876-5432', '대전 동구', '역사', '1학년 3반');
INSERT INTO TEACHERS VALUES ('이영수', '1988-11-15', 33, '남', '010-3456-7890', '대구 수성', '체육', '3학년 4반');
INSERT INTO TEACHERS VALUES ('김미영', '1994-09-18', 27, '여', '010-5678-1234', '광주 서구', '미술', '2학년 1반');
INSERT INTO TEACHERS VALUES ('박승호', '1982-07-20', 39, '남', '010-2345-6789', '경기 안양', '음악', '1학년 12반');
INSERT INTO TEACHERS VALUES ('정다영', '1993-05-30', 28, '여', '010-7890-1234', '경북 포항', '한국사', '3학년 3반');
INSERT INTO TEACHERS VALUES ('이지현', '1997-04-08', 24, '여', '010-1234-5678', '경남 창원', '영어', '2학년 17반');
INSERT INTO TEACHERS VALUES ('김철호', '1981-08-10', 40, '남', '010-3456-7890', '전남 목포', '과학', '1학년 1반');
INSERT INTO TEACHERS VALUES ('박지은', '1989-10-05', 32, '여', '010-5678-1234', '서울 강서', '수학', '3학년 2반');
INSERT INTO TEACHERS VALUES ('정승민', '1996-01-12', 25, '남', '010-2345-6789', '인천 연수', '국어', '1학년 5반');
INSERT INTO TEACHERS VALUES ('김민지', '1987-07-22', 34, '여', '010-7890-1234', '경기 고양', '역사', '2학년 4반');
INSERT INTO TEACHERS VALUES ('이영호', '1992-12-14', 29, '남', '010-1234-5678', '대전 중구', '체육', '1학년 4반');
INSERT INTO TEACHERS VALUES ('최현우', '1986-04-30', 35, '남', '010-3456-7890', '광주 동구', '미술', '3학년 19반');
INSERT INTO TEACHERS VALUES ('이가연', '1998-11-05', 23, '여', '010-5678-1234', '부산 사하', '음악', '2학년 8반');
INSERT INTO TEACHERS VALUES ('김동호', '1990-02-28', 31, '남', '010-2345-6789', '경북 경주', '한국사', '3학년 17반');
INSERT INTO TEACHERS VALUES ('장지은', '1983-09-15', 38, '여', '010-7890-1234', '전북 전주', '영어', '1학년 16반');
INSERT INTO TEACHERS VALUES ('정준우', '1995-05-18', 26, '남', '010-1234-5678', '경기 수원', '과학', '2학년 20반');
INSERT INTO TEACHERS VALUES ('이지민', '1980-12-10', 41, '여', '010-3456-7890', '서울 강남', '수학', '3학년 8반');
INSERT INTO TEACHERS VALUES ('최다영', '1988-07-20', 33, '여', '010-9876-5432', '부산 해운대', '국어', '1학년 9반');
INSERT INTO TEACHERS VALUES ('김성호', '1993-04-03', 28, '남', '010-2345-6789', '인천 남구', '역사', '2학년 19반');
INSERT INTO TEACHERS VALUES ('박미영', '1997-01-28', 24, '여', '010-7890-1234', '대구 수성', '체육', '1학년 6반');
INSERT INTO TEACHERS VALUES ('김승호', '1981-10-08', 40, '남', '010-1234-5678', '서울 강서', '미술', '2학년 10반');
INSERT INTO TEACHERS VALUES ('이지은', '1994-09-03', 27, '여', '010-3456-7890', '대전 동구', '음악', '1학년 17반');
INSERT INTO TEACHERS VALUES ('최지우', '1985-03-20', 36, '남', '010-5678-1234', '경기 안양', '한국사', '3학년 20반');
INSERT INTO TEACHERS VALUES ('박영수', '1998-11-22', 23, '남', '010-2345-6789', '경북 포항', '영어', '2학년 9반');
INSERT INTO TEACHERS VALUES ('김민수', '1991-06-07', 30, '여', '010-7890-1234', '전남 목포', '과학', '1학년 10반');

SELECT * FROM TEACHERS;


INSERT INTO STUDENTS VALUES ('김철수', 220634, '2006-03-15', 17, '남', '010-1234-5678', '서울 강남', '영어', '3학년 3반');
INSERT INTO STUDENTS VALUES ('이영희', 230223, '2007-04-20', 15, '여', '010-9876-5432', '부산 해운대', '과학', '2학년 2반');
INSERT INTO STUDENTS VALUES ('박민지', 240312, '2008-06-23', 14, '여', '010-2345-6789', '대구 수성', '수학', '1학년 1반');
INSERT INTO STUDENTS VALUES ('정성호', 250506, '2007-09-08', 15, '남', '010-8765-4321', '인천 남구', '국어', '2학년 1반');
INSERT INTO STUDENTS VALUES ('이수진', 260721, '2006-12-30', 16, '여', '010-3456-7890', '광주 동구', '역사', '3학년 4반');
INSERT INTO STUDENTS VALUES ('김태영', 270830, '2005-11-10', 17, '남', '010-7890-1234', '서울 송파', '음악', '1학년 3반');
INSERT INTO STUDENTS VALUES ('박현수', 280917, '2006-01-20', 16, '남', '010-4567-8901', '대전 중구', '미술', '2학년 2반');
INSERT INTO STUDENTS VALUES ('정지은', 290102, '2007-03-05', 15, '여', '010-2345-6789', '경기 수원', '체육', '3학년 1반');
INSERT INTO STUDENTS VALUES ('김승호', 300206, '2006-11-18', 16, '남', '010-7890-1234', '서울 강동', '한국사', '1학년 2반');
INSERT INTO STUDENTS VALUES ('이수진', 310301, '2008-04-30', 14, '여', '010-3456-7890', '경북 포항', '미술', '2학년 3반');
INSERT INTO STUDENTS VALUES ('박영민', 320413, '2005-06-15', 17, '남', '010-9876-5432', '전남 목포', '음악', '3학년 4반');
INSERT INTO STUDENTS VALUES ('정다영', 330520, '2006-07-20', 16, '여', '010-2345-6789', '서울 마포', '체육', '1학년 1반');
INSERT INTO STUDENTS VALUES ('이재현', 340606, '2005-03-04', 17, '남', '010-7890-1234', '경남 창원', '미술', '2학년 4반');
INSERT INTO STUDENTS VALUES ('김지현', 350707, '2008-01-20', 14, '여', '010-3456-7890', '서울 서초', '수학', '3학년 1반');
INSERT INTO STUDENTS VALUES ('최승호', 360822, '2006-09-18', 16, '남', '010-1234-5678', '부산 사하', '국어', '1학년 4반');
INSERT INTO STUDENTS VALUES ('박수민', 370925, '2007-05-22', 15, '여', '010-9876-5432', '경기 안양', '과학', '2학년 1반');
INSERT INTO STUDENTS VALUES ('김영호', 380107, '2005-08-07', 17, '남', '010-2345-6789', '대전 서구', '한국사', '3학년 2반');
INSERT INTO STUDENTS VALUES ('이현주', 390215, '2006-04-15', 16, '여', '010-3456-7890', '서울 강서', '체육', '1학년 3반');
INSERT INTO STUDENTS VALUES ('정재원', 400330, '2007-06-28', 15, '남', '010-1234-5678', '인천 부평', '영어', '2학년 1반');
INSERT INTO STUDENTS VALUES ('최지훈', 410406, '2005-02-09', 17, '남', '010-9876-5432', '경북 경주', '수학', '3학년 2반');
INSERT INTO STUDENTS VALUES ('김지영', 420502, '2008-01-19', 14, '여', '010-2345-6789', '대구 달서', '미술', '1학년 1반');
INSERT INTO STUDENTS VALUES ('이민재', 430603, '2006-06-12', 16, '남', '010-3456-7890', '서울 송파', '국어', '2학년 3반');
INSERT INTO STUDENTS VALUES ('박수진', 440727, '2005-12-03', 16, '여', '010-1234-5678', '경기 고양', '역사', '3학년 1반');
INSERT INTO STUDENTS VALUES ('정지원', 450817, '2008-06-28', 14, '남', '010-9876-5432', '전북 전주', '체육', '1학년 1반');
INSERT INTO STUDENTS VALUES ('김은지', 460920, '2007-11-18', 15, '여', '010-2345-6789', '광주 북구', '음악', '2학년 2반');
INSERT INTO STUDENTS VALUES ('최준호', 470002, '2006-09-07', 16, '남', '010-3456-7890', '경남 진주', '과학', '3학년 1반');
INSERT INTO STUDENTS VALUES ('이가영', 480106, '2005-08-23', 17, '여', '010-1234-5678', '서울 강북', '수학', '1학년 2반');
INSERT INTO STUDENTS VALUES ('박진우', 490225, '2008-04-12', 14, '남', '010-9876-5432', '인천 연수', '국어', '2학년 3반');
INSERT INTO STUDENTS VALUES ('정미영', 500312, '2007-11-05', 15, '여', '010-1234-5678', '서울 동작', '미술', '1학년 4반');
INSERT INTO STUDENTS VALUES ('김철수', 510406, '2004-03-15', 18, '남', '010-1234-5678', '서울 강남', '영어', '3학년 2반');
INSERT INTO STUDENTS VALUES ('이영희', 520423, '2005-04-20', 17, '여', '010-9876-5432', '부산 해운대', '과학', '2학년 2반');
INSERT INTO STUDENTS VALUES ('박민지', 530523, '2004-06-23', 17, '여', '010-2345-6789', '대구 수성', '수학', '1학년 1반');
INSERT INTO STUDENTS VALUES ('정성호', 540606, '2003-09-08', 18, '남', '010-8765-4321', '인천 남구', '국어', '2학년 1반');
INSERT INTO STUDENTS VALUES ('이수진', 550721, '2004-12-30', 17, '여', '010-3456-7890', '광주 동구', '역사', '3학년 2반');
INSERT INTO STUDENTS VALUES ('김태영', 560830, '2003-11-10', 18, '남', '010-7890-1234', '서울 송파', '음악', '1학년 3반');
INSERT INTO STUDENTS VALUES ('박현수', 570917, '2004-01-20', 18, '남', '010-4567-8901', '대전 중구', '미술', '2학년 2반');
INSERT INTO STUDENTS VALUES ('정지은', 580102, '2005-03-05', 17, '여', '010-2345-6789', '경기 수원', '체육', '3학년 2반');
INSERT INTO STUDENTS VALUES ('김승호', 590206, '2004-11-18', 17, '남', '010-7890-1234', '서울 강동', '한국사', '1학년 1반');
INSERT INTO STUDENTS VALUES ('이수진', 600301, '2006-04-30', 16, '여', '010-3456-7890', '경북 포항', '미술', '2학년 3반');
INSERT INTO STUDENTS VALUES ('박영민', 610413, '2003-06-15', 18, '남', '010-9876-5432', '전남 목포', '음악', '3학년 2반');
INSERT INTO STUDENTS VALUES ('정다영', 620520, '2004-07-20', 17, '여', '010-2345-6789', '서울 마포', '체육', '1학년 1반');
INSERT INTO STUDENTS VALUES ('이재현', 630606, '2003-03-04', 18, '남', '010-7890-1234', '경남 창원', '미술', '2학년 2반');
INSERT INTO STUDENTS VALUES ('김지현', 640707, '2006-01-20', 16, '여', '010-3456-7890', '서울 서초', '수학', '3학년 3반');

SELECT * FROM STUDENTS;


DROP TABLE SCOREBOARD cascade constraints purge;
CREATE TABLE SCOREBOARD(
    NAME VARCHAR2(20),          -- 학생명
    STDID NUMBER(10),           -- 학생 번호
    MATH1 NUMBER(10),           -- 수학 1차 점수
    MATH2 NUMBER(10),           -- 수학 2차 점수
    MATH3 NUMBER(10),           -- 수학 3차 점수
    SCORE_MATH VARCHAR2(10),    -- 수학 점수
    PHYS1 NUMBER(10),           -- 물리 1차 점수
    PHYS2 NUMBER(10),           -- 물리 2차 점수
    PHYS3 NUMBER(10),           -- 물리 3차 점수
    SCORE_PHYS VARCHAR2(10),    -- 물리 점수
    ABSENCE NUMBER(10),         -- 결석 일수
    FLUNK VARCHAR2(10)          -- 유급 여부
);

INSERT	INTO	SCOREBOARD	VALUES	('김철수',220634,74,84,56,NULL,63,78,89,NULL,1,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이영희',230223,30,30,78,NULL,40,64,52,NULL,9,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('박민지',240312,46,33,38,NULL,62,29,31,NULL,1,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('정성호',250506,80,35,47,NULL,70,64,97,NULL,0,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이수진',260721,96,63,96,NULL,56,40,61,NULL,1,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('김태영',270830,81,73,33,NULL,61,51,44,NULL,7,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('박현수',280917,91,58,69,NULL,59,40,85,NULL,8,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('정지은',290102,83,64,63,NULL,63,96,69,NULL,8,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('김승호',300206,89,32,78,NULL,80,53,39,NULL,2,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이수진',310301,37,63,63,NULL,67,27,68,NULL,4,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('박영민',320413,31,27,58,NULL,43,80,51,NULL,3,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('정다영',330520,73,89,26,NULL,99,79,70,NULL,9,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이재현',340606,26,61,62,NULL,40,31,86,NULL,10,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('김지현',350707,84,38,58,NULL,54,51,48,NULL,4,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('최승호',360822,52,55,45,NULL,24,73,62,NULL,10,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('박수민',370925,47,68,44,NULL,72,48,69,NULL,4,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('김영호',380107,56,69,90,NULL,98,49,88,NULL,4,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이현주',390215,20,41,49,NULL,56,32,26,NULL,8,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('정재원',400330,43,21,79,NULL,39,52,24,NULL,2,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('최지훈',410406,56,83,26,NULL,71,75,52,NULL,6,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('김지영',420502,83,83,71,NULL,38,98,44,NULL,2,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이민재',430603,40,77,27,NULL,94,77,73,NULL,9,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('박수진',440727,39,62,48,NULL,74,83,94,NULL,8,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('정지원',450817,91,82,91,NULL,37,45,20,NULL,1,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('김은지',460920,86,22,66,NULL,91,28,79,NULL,0,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('최준호',470002,50,23,40,NULL,62,41,49,NULL,3,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이가영',480106,58,32,43,NULL,58,43,66,NULL,2,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('박진우',490225,27,94,53,NULL,33,36,44,NULL,3,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('정미영',500312,69,78,21,NULL,48,23,61,NULL,5,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('김철수',510406,31,88,99,NULL,54,21,95,NULL,7,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이영희',520423,30,47,27,NULL,57,84,58,NULL,6,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('박민지',530523,24,33,37,NULL,41,68,57,NULL,9,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('정성호',540606,66,41,48,NULL,48,50,25,NULL,9,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이수진',550721,64,86,49,NULL,93,70,67,NULL,1,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('김태영',560830,92,95,56,NULL,23,48,39,NULL,0,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('박현수',570917,64,94,27,NULL,53,92,33,NULL,0,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('정지은',580102,73,83,33,NULL,97,98,58,NULL,8,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('김승호',590206,67,40,92,NULL,71,93,61,NULL,9,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이수진',600301,78,41,57,NULL,21,92,22,NULL,2,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('박영민',610413,75,51,84,NULL,54,76,26,NULL,8,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('정다영',620520,55,33,53,NULL,81,53,51,NULL,9,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('이재현',630606,82,41,25,NULL,40,45,81,NULL,6,NULL);
INSERT	INTO	SCOREBOARD	VALUES	('김지현',640707,30,57,72,NULL,54,32,96,NULL,6,NULL);

DROP TABLE RELOCATEE cascade constraints purge;
-- 교육부 전근자 명단 테이블 생성
CREATE TABLE RELOCATEE(
    NAME VARCHAR2(20),      -- 전근자 이름
    RELO_DATE DATE          -- 전근 일자
);

INSERT	INTO	RELOCATEE	VALUES	('김철호', TO_DATE('2024-07-01','YYYY-MM-DD'));
INSERT	INTO	RELOCATEE	VALUES	('박준혁', TO_DATE('2024-07-01','YYYY-MM-DD'));
INSERT	INTO	RELOCATEE	VALUES	('김지현', TO_DATE('2024-07-01','YYYY-MM-DD'));
INSERT	INTO	RELOCATEE	VALUES	('김소연', TO_DATE('2024-07-01','YYYY-MM-DD'));
INSERT	INTO	RELOCATEE	VALUES	('이지훈', TO_DATE('2024-08-01','YYYY-MM-DD'));
INSERT	INTO	RELOCATEE	VALUES	('박승우', TO_DATE('2024-08-01','YYYY-MM-DD'));
INSERT	INTO	RELOCATEE	VALUES	('최민지', TO_DATE('2024-08-01','YYYY-MM-DD'));
INSERT	INTO	RELOCATEE	VALUES	('윤하은', TO_DATE('2024-08-01','YYYY-MM-DD'));
INSERT	INTO	RELOCATEE	VALUES	('이민준', TO_DATE('2024-09-01','YYYY-MM-DD'));
INSERT	INTO	RELOCATEE	VALUES	('장지우', TO_DATE('2024-09-01','YYYY-MM-DD'));
INSERT	INTO	RELOCATEE	VALUES	('최성민', TO_DATE('2024-09-01','YYYY-MM-DD'));

SELECT * FROM TEACHERS;
SELECT * FROM STUDENTS;
SELECT * FROM SCOREBOARD;
SELECT * FROM RELOCATEE;

------------------------------ Q.분반 별로 소속된 학생들과 담당 선생님을 검색
SELECT S.STDID 학번, S.NAME 이름, S.CLASS "학년/반", T.NAME "담임선생님"
FROM STUDENTS S 
INNER JOIN TEACHERS T ON S.CLASS = T.CLASS_ASSIGNED
ORDER BY "학년/반";


------------------------------ Q.성적 TABLE에서 수학/물리 각각의 과목에서 1차, 2차, 3차, 시험에 대해 가중치 X 0.3을 적용한 시험
------------------------------ 합산 점수에 결석일수를 감해서 최종 수학/물리 과목 점수를 SCORE_MATH와 SCORE_PHYS COLUMN에 UPDATE
UPDATE SCOREBOARD SET
SCORE_MATH = ROUND((MATH1 * 0.3 + MATH2 * 0.3 + MATH3 * 0.3) - ABSENCE),
SCORE_PHYS = ROUND((PHYS1 * 0.3 + PHYS2 * 0.3 + PHYS3 * 0.3) - ABSENCE);

SELECT * FROM SCOREBOARD;



------------------------------ Q. 수학 물리 과목 모두 1,2,3차 시험과 출결점수로 산출된 합산 점수로부터 
------------------------------ 65점 이상: A, 64~55점: B, 54~45점 : C, 44~36점 D, 35점 이하: F 학점으로 성적 처리해서 
------------------------------ GRADE_MATH와 GRADE_PHYS NEW COLUMN 으로 검색 쿼리
SELECT NAME, STDID, SCORE_MATH,
    CASE
    WHEN SCORE_MATH >= 65 THEN 'A'
    WHEN SCORE_MATH BETWEEN 55 AND 64 THEN 'B'
    WHEN SCORE_MATH BETWEEN 45 AND 54 THEN 'C'
    WHEN SCORE_MATH BETWEEN 36 AND 44 THEN 'D'
    ELSE 'F'
    END AS GRADE_MATH,
    SCORE_PHYS,
    CASE
    WHEN SCORE_PHYS >= 65 THEN 'A'
    WHEN SCORE_PHYS BETWEEN 55 AND 64 THEN 'B'
    WHEN SCORE_PHYS BETWEEN 45 AND 54 THEN 'C'
    WHEN SCORE_PHYS BETWEEN 36 AND 44 THEN 'D'
    ELSE 'F'
    END AS GRADE_PHYS,
    ABSENCE,
    FLUNK
FROM SCOREBOARD;

------------------------------ Q.위와 같은 로직에 따라 수학과 물리의 점수를 그래이딩 하고, 각 과목의 낙제자를 검색해서 FLUNK 컬럼 UPDATE
UPDATE SCOREBOARD
SET FLUNK = CASE
WHEN TO_NUMBER(SCORE_MATH) <= 35 AND TO_NUMBER(SCORE_PHYS) <= 35 THEN '유급'
WHEN TO_NUMBER(SCORE_MATH) <= 35 OR TO_NUMBER(SCORE_PHYS) <= 35 THEN '경고'
ELSE 'PASS'
END;
SELECT * FROM SCOREBOARD;

------------------------------ Q.성적이 유급 혹은 잠정 보류에 해당하는 학생과 담임 선생님의 리스트를 쿼리
SELECT
    S.NAME AS 학생이름,
    S.CLASS AS "학년/반",
    T.NAME AS 담당교사,
    SB.FLUNK AS 유급여부
FROM SCOREBOARD SB
INNER JOIN STUDENTS S ON SB.STDID = S.STDID
INNER JOIN TEACHERS T ON S.CLASS = T.CLASS_ASSIGNED
WHERE SB.FLUNK IN ('경고', '유급');


------------------------------ Q.두 과목 모두에서 낙제한 유급 학생과 담임 선생님의 명단 쿼리
SELECT
    S.NAME AS 학생이름,
    S.CLASS AS "학년/반",
    T.NAME AS "하위 고과 예정 교사"
FROM SCOREBOARD SB
INNER JOIN STUDENTS S ON SB.STDID = S.STDID
INNER JOIN TEACHERS T ON S.CLASS = T.CLASS_ASSIGNED
WHERE SB.FLUNK IN ('유급');

------------------------------ Q.반별 평균 점수가 가장 높은 반 순서로 정렬 (학년 구분 없이)
SELECT
    T.CLASS_ASSIGNED AS CLASS,
    ROUND(AVG(SCORE_MATH),2) AS AVG_MATH_SCORE,
    T.NAME AS TEACHER_NAME
FROM TEACHERS T
JOIN STUDENTS S ON T.CLASS_ASSIGNED = S.CLASS
JOIN (SELECT STDID, SCORE_MATH
    FROM SCOREBOARD) SB ON S.STDID = SB.STDID
GROUP BY T.CLASS_ASSIGNED, T.NAME
ORDER BY AVG_MATH_SCORE DESC, T.CLASS_ASSIGNED;

--------------------------------------------------- Q.반별 평균 점수가 가장 높은 반 순서로 정렬 (1학년 만)
SELECT
    T.CLASS_ASSIGNED AS CLASS,
    ROUND(AVG(SCORE_MATH), 2) AS AVG_MATH_SCORE,
    T.NAME AS TEACHER_NAME
FROM TEACHERS T
JOIN STUDENTS S ON T.CLASS_ASSIGNED = S.CLASS
JOIN (SELECT STUDENTS.STDID,SCORE_MATH
    FROM SCOREBOARD
    JOIN STUDENTS ON SCOREBOARD.STDID = STUDENTS.STDID
    AND SUBSTR(STUDENTS.CLASS, 1, 1) = '1') SB ON S.STDID = SB.STDID
GROUP BY T.CLASS_ASSIGNED, T.NAME
ORDER BY AVG_MATH_SCORE DESC;

---------------------------------------------------- Q.반별 평균 점수가 가장 높은 반 순서로 정렬 (3학년 만)
SELECT
    T.CLASS_ASSIGNED AS CLASS,
    ROUND(AVG(SCORE_MATH), 2) AS AVG_MATH_SCORE,
    T.NAME AS TEACHER_NAME
FROM TEACHERS T
JOIN STUDENTS S ON T.CLASS_ASSIGNED = S.CLASS
JOIN (SELECT STUDENTS.STDID,SCORE_MATH
    FROM SCOREBOARD
    JOIN STUDENTS ON SCOREBOARD.STDID = STUDENTS.STDID
    AND SUBSTR(STUDENTS.CLASS, 1, 1) = '3') SB ON S.STDID = SB.STDID
GROUP BY T.CLASS_ASSIGNED, T.NAME
ORDER BY AVG_MATH_SCORE DESC;


------------------------------ Q.STUDENT TABLE에서 학생 명단에 학년을 추출해서 쿼리
SELECT
    NAME AS STUDENT_NAME,
    STDID AS STUDENT_ID,
    AGE AS STUDENT_AGE,
    SUBSTR(CLASS, 1, 1) AS GRADE
FROM STUDENTS
ORDER BY GRADE;

--------------------------------------------------- Q. 학년 별 학생 수와 선생님 수, 선생님 한 명당 학생 수 비율이 높은 순으로 정리
-- WITH AS: 과도한 서브 쿼리는 메인 쿼리의 복잡하게 ==> 복잡한 부분의 쿼리를 WITH AS로 분리

WITH StudentCount AS (
    SELECT SUBSTR(CLASS, 1, 1) AS GRADE, COUNT(*) AS NUM_STUDENTS
    FROM STUDENTS
    GROUP BY SUBSTR(CLASS, 1, 1)),
TeacherCount AS ( 
    SELECT SUBSTR(CLASS_ASSIGNED, 1, 1) AS GRADE, COUNT(*) AS NUM_TEACHERS
    FROM TEACHERS 
    GROUP BY SUBSTR(CLASS_ASSIGNED, 1, 1)),
StudentPerTeacher AS (
    SELECT S.GRADE, S.NUM_STUDENTS AS STUDENT_COUNT, T.NUM_TEACHERS AS TEACHER_COUNT,
        ROUND(S.NUM_STUDENTS / T.NUM_TEACHERS, 2) AS STUDENT_PER_TEACHER
    FROM StudentCount S
    JOIN TeacherCount T ON S.GRADE = T.GRADE)
SELECT SPT.GRADE, SPT.STUDENT_COUNT, SPT.TEACHER_COUNT, SPT.STUDENT_PER_TEACHER
FROM StudentPerTeacher SPT
ORDER BY
    SPT.STUDENT_PER_TEACHER DESC;


--------------------------------------------------- Q. 전근갈 교사의 학생들을 가장 학생이 적은 반으로 배정
UPDATE STUDENTS
SET CLASS = (SELECT  C.CLASS
            FROM (SELECT B.CLASS, COUNT(B.CLASS) AS CNT
                  FROM TEACHERS A, STUDENTS B
                  WHERE A.CLASS_ASSIGNED = B.CLASS AND B.CLASS LIKE '1%' AND A.NAME != '김철호'
                  GROUP BY B.CLASS
                  ORDER BY COUNT(B.CLASS)) C
            WHERE ROWNUM = 1)
WHERE CLASS = (SELECT CLASS_ASSIGNED
            FROM TEACHERS
            WHERE NAME = '김철호');


------------------------------ Q.분반 별로 소속된 학생들과 담당 선생님을 검색
SELECT S.STDID 학번, S.NAME 이름, S.CLASS "학년/반", T.NAME "담임선생님"
    FROM STUDENTS S 
    INNER JOIN TEACHERS T ON S.CLASS = T.CLASS_ASSIGNED
    ORDER BY "학년/반";

ROLLBACK;
DELETE FROM teachers WHERE name = '김철호';

--Q22. 다음 실습과제를 수행하세요.(20점)
-- 1. 현재 hr에 있는 7개 테이블들을 분석해서 인사관리에 의미있는 인사이트 5개 이상을 기술하세요.
-- 2. 인사관리 개선을 위한 KPI 2개를 설정하고 이것들을 테이블들의 데이터에 반영한 후 다시 분석해서 반영 여부를 검증하세요. 

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

