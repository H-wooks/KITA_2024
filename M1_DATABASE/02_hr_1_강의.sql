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

-- Q. 사번이 120인 사람의 사번, 이름, 업무, 업무명 QUERY
SELECT E.EMPLOYEE_ID 사번, E.FIRST_NAME 이름, E.LAST_NAME 성, J.JOB_ID 업무, J.JOB_TITLE 업무명
FROM EMPLOYEES E 
INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE E.EMPLOYEE_ID = 120;

-- FIRST_NAME||' '||LAST_NAME AS 이름: 성과 이름을 공백으로 연결하여 RETURN
SELECT E.EMPLOYEE_ID 사번, E.FIRST_NAME ||' ' ||E.LAST_NAME FULL_NAME, J.JOB_ID 업무, J.JOB_TITLE 업무명
FROM EMPLOYEES E 
INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE E.EMPLOYEE_ID = 120;

SELECT E.EMPLOYEE_ID 사번, E.FIRST_NAME ||' ' ||E.LAST_NAME FULL_NAME, J.JOB_ID 업무, J.JOB_TITLE 업무명
FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID = J.JOB_ID 
AND E.EMPLOYEE_ID = 120;

-- Q. 2005년 상반기에 입사한 사랍들의 이름만 출력
SELECT FIRST_NAME ||' ' ||LAST_NAME FULL_NAME, HIRE_DATE 입사일
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YY/MM') BETWEEN '05/01' AND '05/06';

-- _는 와일드카드 (1자)가 아닌 문자로 취급하고 싶을 때 ESCAPE 옵션을 사용
SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%\_A%';                      -- SQL에서는 ESCAPE로 자동으로 인식 X
SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%\_A%' ESCAPE '\';           -- SQL에서는 ESCAPE로 뭘로 쓸건지 정의 해줘야
SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%#_A%' ESCAPE '#';           -- \뿐만 아니라 #도 지정해주는 것에 따라

-- IN : OR 대신 사용
SELECT * FROM EMPLOYEES WHERE MANAGER_ID =101 OR MANAGER_ID=102 OR MANAGER_ID=103;
SELECT * FROM EMPLOYEES WHERE MANAGER_ID IN (101,102,103);

-- Q. 업무가 SA_MAN, IT_PROG, ST_MAN인 사람만 출력
SELECT * FROM EMPLOYEES WHERE JOB_ID IN ('SA_MAN', 'IT_PROG', 'ST_MAN');

-- IS NULL / IS NOT NULL
-- NULL 값인지를 확인하는 경우 = 비교 연산자를 사용하지 않고 IS NULL을 사용
SELECT * FROM EMPLOYEES WHERE COMMISSION_PCT IS NULL;
SELECT * FROM EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL;

-- ORDER BY
-- ORDER BY 컬럼명 [ASC | DESC]    ASC가 DEFAULT
SELECT * FROM EMPLOYEES ORDER BY SALARY ASC;
SELECT * FROM EMPLOYEES ORDER BY SALARY DESC;
SELECT * FROM EMPLOYEES ORDER BY SALARY ASC, LAST_NAME DESC;

-- DUAL 테이블, 참조할 테이블이 없이 간단한 연산을 할 때 (홀 수 일때)
SELECT * FROM EMPLOYEES WHERE MOD(EMPLOYEE_ID, 2) = 1;
SELECT MOD(10,3) FROM DUAL;

-- ROUND
SELECT ROUND(355.9555) FROM DUAL;
SELECT ROUND(355.9555,2) FROM DUAL;
SELECT ROUND(355.9555,2) FROM DUAL;


-- TRUNC()  버림 함수 지정된 자리수 이하를 버린다.
SELECT TRUNC(355.9555,1) FROM DUAL;
-- CEIL() 함수 무조건 올림, 자지 지정 못함
SELECT CEIL(45.333) FROM DUAL;


-- Q. HR EMPLOYEES 테이블에서 이름, 금여, 10% 인상된 급여 출력
SELECT LAST_NAME 이름, SALARY 급여, SALARY*1.1 "인상된 급여"
FROM EMPLOYEES;

-- Q. EMPLOYEE_ID가 홀수인 직원의 EMPLOYEE_ID와 LAST_NAME을 출력
SELECT EMPLOYEE_ID, LAST_NAME
FROM EMPLOYEES
WHERE MOD(EMPLOYEE_ID, 2) = 1
ORDER BY EMPLOYEE_ID;

-- SUB-QUERY 이용해서....
SELECT EMPLOYEE_ID, LAST_NAME
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (
SELECT EMPLOYEE_ID
FROM EMPLOYEES
WHERE MOD(EMPLOYEE_ID, 2) = 1)
ORDER BY EMPLOYEE_ID;

-- Q. EMPLOYEES 테이블에서 COMMISSION_PCT의 NULL 값의 갯수를 출력하세요
SELECT COUNT(*) FROM EMPLOYEES WHERE COMMISSION_PCT IS NULL;
SELECT COUNT(*) FROM EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL;

-- Q. EMPLOYEES 테이블에서 DEPARTMENT_ID가 없는 직원을 추출해서 POSITION을 '신입'으로 출력 (POSITION 열을 추가)
ALTER TABLE EMPLOYEES ADD POSITION VARCHAR2(15);
UPDATE EMPLOYEES SET POSITION='신입' WHERE  DEPARTMENT_ID IS NULL;
SELECT POSITION, DEPARTMENT_ID FROM EMPLOYEES;

ALTER TABLE EMPLOYEES DROP COLUMN POSITION;
SELECT * FROM EMPLOYEES; 

SELECT EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME FULL_NAME, '신입' POSISTION
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NULL;

------------------------------------------- 날짜 관련
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE + 1 FROM DUAL;
SELECT SYSDATE - 1 FROM DUAL;

--ROUND-TRUNC------------ Q. 근무한 날짜 계산
SELECT LAST_NAME, SYSDATE, HIRE_DATE, ROUND(SYSDATE-HIRE_DATE) 근무시간 FROM EMPLOYEES;
SELECT LAST_NAME, SYSDATE, HIRE_DATE, TRUNC(SYSDATE-HIRE_DATE) 근무시간 FROM EMPLOYEES;

--- 아래 오류난다
SELECT LAST_NAME, SYSDATE, HIRE_DATE, DATETIME(TRUNC(SYSDATE-HIRE_DATE)) 근무시간 FROM EMPLOYEES;
--ADD_MONTHS------------- Q. 특정 개월 수를 더한 출력
SELECT LAST_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) REVISED_DATE FROM EMPLOYEES;

--LAST_DAY------------- Q. 해당 월의 마지막 날짜를 반환
SELECT LAST_NAME, HIRE_DATE, LAST_DAY(ADD_MONTHS(HIRE_DATE, 1)) "월의 마지막 일" FROM EMPLOYEES;

--NEXT_DAY------------- Q. 해당 날짜를 기준으로 다음에 오는 특정 요일
SELECT LAST_NAME, HIRE_DATE, NEXT_DAY(HIRE_DATE, '월') "다음 월요일" FROM EMPLOYEES;
SELECT LAST_NAME, HIRE_DATE, NEXT_DAY(HIRE_DATE, 2) "다음 월요일" FROM EMPLOYEES;

--MONTHS_BETWEEN------------- Q. 날짜와 날짜 사이의 개월수를 구한다. (개월 수를 소수점 첫째 자리까지 반올림)
SELECT HIRE_DATE, ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE), 1) FROM EMPLOYEES;

--형 변환 : TO_DATE------------- Q. 문자를 날짜로 변경한다.
SELECT TO_DATE('2023-01-01', 'YYYY-MM-DD') FROM DUAL;

--TO_CHAR------------- Q. 날짜를 문자로 변경
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD') FROM DUAL;

------------------------------------------------------ 시간 형식 
-- YYYY       네 자리 연도
-- YY      두 자리 연도
-- YEAR      연도 영문 표기
-- MM      월을 숫자로
-- MON      월을 알파벳으로
-- DD      일을 숫자로
-- DAY      요일 표현
-- DY      요일 약어 표현
-- D      요일 숫자 표현
-- AM 또는 PM   오전 오후
-- HH 또는 HH12   12시간
-- HH24      24시간
-- MI      분
-- SS      초

--EX
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD DY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YEAR/MM/DD DY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'yyyy/MON/DD DY AM') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'yyyy/MON/DD DY AM HH') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'yyyy/MON/DD DY AM HH24:MI/SS') FROM DUAL;

----------------------------- Q. 현재 날짜를 "YYYY/MM/DD'형식으로 변환
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD') FROM DUAL;

----------------------------- Q. '01-01-2023'이란 문자열을 날짜 타입으로 변환
SELECT TO_DATE('01-01-2023', 'DD-MM-YYYY') FROM DUAL;

----------------------------- Q. 현재 날짜와 시간(SYSDATE)를 'YYYY-MM-DD HH24:MI:SS' 형식의 문자열로 변환
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;

----------------------------- Q. '2023-01-01 15:30:00'이라는 문자열을 날짜 및 시간 타입으로 변환
SELECT TO_DATE('2023-01-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS') DATE1 FROM DUAL;
SELECT TO_DATE('2023-01-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS') DATE1, TO_CHAR(TO_DATE('2023-01-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'YY/MM/DD AM HH:MI:SS') "형식 변경된 시간" FROM DUAL;

--to_char( 숫자 )   숫자를 문자로 변환
--9      한 자리의 숫자 표현      ( 1111, ‘99999’ )      1111   
--0      앞 부분을 0으로 표현      ( 1111, ‘099999’ )      001111
--$      달러 기호를 앞에 표현      ( 1111, ‘$99999’ )      $1111
--.      소수점을 표시         ( 1111, ‘99999.99’ )      1111.00
--,      특정 위치에 , 표시      ( 1111, ‘99,999’ )      1,111
--MI      오른쪽에 - 기호 표시      ( 1111, ‘99999MI’ )      1111-
--PR      음수값을 <>로 표현      ( -1111, ‘99999PR’ )      <1111>
--EEEE      과학적 표현         ( 1111, ‘99.99EEEE’ )      1.11E+03
--V      10을 n승 곱한값으로 표현   ( 1111, ‘999V99’ )      111100
--B      공백을 0으로 표현      ( 1111, ‘B9999.99’ )      1111.00
--L      지역통화         ( 1111, ‘L9999’ )

-- EX)
SELECT SALARY, TO_CHAR(SALARY, '0999999') FROM EMPLOYEES;
SELECT SALARY, TO_CHAR(-SALARY, '0999999PR') FROM EMPLOYEES;
SELECT SALARY, TO_CHAR(SALARY, '999999MI') FROM EMPLOYEES;
SELECT SALARY, TO_CHAR(SALARY, '9.99EEEE') FROM EMPLOYEES;

--WIDTH_BUCKET()------------- 지정값, 최소값, 최대값, BUCKET 개수
SELECT WIDTH_BUCKET(92,0,100,10) FROM DUAL;
-- 0~100까지 숫자를 10개의 구간으로 나누어서 나타냈을때, 92가 속해있는 구간 ==> 10번째 구간

SELECT WIDTH_BUCKET(82,0,100,10) FROM DUAL;         -- 9번째
-- 100은 그다음으로 넘어간다. 
SELECT WIDTH_BUCKET(100,0,100,10) FROM DUAL;       -- 

----------------------------- Q. EMPLOYEES 테이블의 SALARY를 5개 등급으로 나누세요
SELECT MAX(SALARY) MAX, MIN(SALARY) MIN FROM EMPLOYEES;
SELECT SALARY, WIDTH_BUCKET(SALARY, 2100,24001, 5) AS GRADE
FROM EMPLOYEES;


--UPPER()--------------------------- 소문자/ 혹은 대만자로 출력
--LOWER()--------------------------- 문자 함수 CHARACTER FUNCTIONS
SELECT UPPER('hello world') from DUAL;
SELECT LOWER('HELLO WORLD') from DUAL;

----------------------------- Q. 첫글자만 대문자
SELECT JOB_ID, INITCAP (JOB_ID) FROM EMPLOYEES;


SELECT LAST_NAME, SALARY FROM EMPLOYEES WHERE LOWER(LAST_NAME)='seo';

--LENGTH--------------------- Q.
SELECT JOB_ID, LENGTH(JOB_ID) FROM EMPLOYEES;

--INSTR--------------------- Q.
SELECT INSTR('Hello Word', 'o', 3, 2) from dual;            --문자열, 찾을 문자, 찾을 위치, 찾는 전체 문자 중 몇번 째 인지
-------------------------- 문자열 'O'를 'Hello Word'에서 찾는데, 3에서부터 다 찾는데, 2번째의 위치 
SELECT INSTR('Hello Word', 'o', 1, 1) from dual;            --문자열, 찾을 문자, 찾을 위치, 찾는 전체 문자 중 몇번 째 인지

-- substr ()
select substr('Hello World', 3, 3) from dual;                           -- 'llo'
select substr('Hello World', 9, 3) from dual;                           -- 'rld'
select substr('Hello World', -3, 3) from dual;                          -- 'rld'

--lpad------------- 오른쪽에 정렬 후 왼쪽에 문자를 채운다.
select lpad('Hello World', 20, '#') from dual;                  -- 전체 20개 자리수 할당하고 남는 왼쪽에 '#'를 채운다.
select rpad('Hello World', 20, '#') from dual;                  -- 전체 20개 자리수 할당하고 남는 오른쪽에 '#'를 채운다.

--ltrim------------- 왼쪽에 있는 공백을 제거
select ltrim('aaaHello Worldaaa', 'a') from dual;                  --==> Hello Worldaaa
select ltrim('   Hello World   ') from dual;                  --==> Hello 'Hello World      '
select last_name as 이름, ltrim(last_name, 'A') from employees;                  --==> Hello 'Hello World      '


--rtrim------------- 오른쪽에 있는 공백을 제거
select rtrim('aaaHello Worldaaa', 'a') from dual;                  --==> aaaHello World
select rtrim('   Hello World   ') from dual;                  --==> Hello '   Hello World'

--trim------------- 양쪽
select trim('   Hello World   ') from dual;         
select last_name, trim('A' from last_name) from employees;
select last_name, trim('a' from last_name) from employees;


--nvl()------------- Q. null을 0또는 다른 값으로 변환하는 함수
select last_name, manager_id, nvl(to_char(manager_id), 'ceo') from employees;

-- decode()    if문이나 case문과 같이 여러 경우를 선택할 수 있도록 하는 함수
-- DECODE 함수는 단순한 조건에 기반하여 값을 반환합니다. 구문은 DECODE(expression, search1, result1, ..., searchN, resultN, default) 
-- 여기서 expression은 검사할 값을 나타내고, search와 result는 각각 조건과 해당 조건이 참일 때 반환할 값
-- default는 모든 search 조건이 거짓일 때 반환할 기본 값 출력
SELECT LAST_NAME, DEPARTMENT_ID, 
DECODE(DEPARTMENT_ID,
90, '경영지원실',
60, '프로그래머',
100, '인사부', '기타') 부서
FROM EMPLOYEES;

----------------------------- Q. EMPLOYEES 테이블에서 COMMISSION_PCT가 NULL이 아닌 경우, 'A', NULL인 경우 'N'으로 표시하는 쿼리
SELECT COMMISSION_PCT AS COMMISSION,
DECODE(COMMISSION_PCT, NULL, 'N', 'A') AS 변환
FROM EMPLOYEES
ORDER BY 변환 DESC;


---------------------------------------- CASE - WHEN - THEN
--decode() 함수와 유사하나 decode() 함수는 단순한 조건 비교에 사용되는 반면
--case() 함수는 다양한 비교연산자로 조건을 제시할 수 있다.
--CASE 문은 조건에 따라 다른 값을 반환하는 데 사용되며, DECODE보다 복잡한 조건을 표현할 수 있다. 
--구문은 CASE WHEN condition THEN result ... ELSE default END이다. 
SELECT LAST_NAME, DEPARTMENT_ID, 
CASE WHEN DEPARTMENT_ID=90 THEN '경영지원실'
WHEN DEPARTMENT_ID=60 THEN '프로그래머'
WHEN DEPARTMENT_ID=100 THEN '인사부'
ELSE '기타'
END AS 소속
FROM EMPLOYEES;
----------------------------- Q. EMPLOYEES 테이블에서 SALARY가 20000 이상이면, 'A', 10000과 20000 사이이면, 'B', 그 이하이면 'C'로 표시하는 쿼리
SELECT LAST_NAME, SALARY, CASE
WHEN SALARY>=20000 THEN 'A'
WHEN SALARY>10000 AND SALARY<20000 THEN 'B'
ELSE 'C'
END AS 등급
FROM EMPLOYEES;

----------------------------- CONCATENATION
SELECT LAST_NAME, 'IS A ', JOB_ID FROM EMPLOYEES;
SELECT LAST_NAME || 'IS A ' || JOB_ID FROM EMPLOYEES;


-----------------------------INSERT
--테이블에 데이터를 입력하는 방법은 두 가지 유형이 있으며 한 번에 한 건만 입력된다.
--a. INSERT INTO 테이블명 (COLUMN_LIST) VALUES (COLUMN_LIST에 넣을 VALUE_LIST);
--b. INSERT INTO 테이블명 VALUES (전체 COLUMN에 넣을 VALUE_LIST);

----------------------------- UNION
-- UNION (합집합), INTERSECTION (교집합), MINUS(차집합) UNION ALL(겹치는 것까지 포함)
-- 두개의 쿼리문을 사용, 데이터 타입이 일치해야
SELECT FIRST_NAME 이름, SALARY 급여, HIRE_DATE 입사일자 FROM EMPLOYEES
WHERE SALARY < 5000
UNION
SELECT FIRST_NAME 이름, SALARY 급여, HIRE_DATE 입사일자 FROM EMPLOYEES
WHERE HIRE_DATE < '05/01/01';

SELECT FIRST_NAME 이름, SALARY 급여, HIRE_DATE 입사일자 FROM EMPLOYEES
WHERE SALARY < 5000
MINUS
SELECT FIRST_NAME 이름, SALARY 급여, HIRE_DATE 입사일자 FROM EMPLOYEES
WHERE HIRE_DATE < '05/01/01';

SELECT FIRST_NAME 이름, SALARY 급여, HIRE_DATE 입사일자 FROM EMPLOYEES
WHERE SALARY < 5000
INTERSECT
SELECT FIRST_NAME 이름, SALARY 급여, HIRE_DATE 입사일자 FROM EMPLOYEES
WHERE HIRE_DATE < '05/01/01';

---------------------------------------- CREATE VIEW (추상화/보안....)
--CREATE VIEW 명령어는 오라클 SQL에서 테이블의 특정 부분이나 조인된 결과를 논리적인 뷰(view)로 만들 때 사용
--뷰는 데이터를 요약하거나 복잡한 조인을 단순화하며, 사용자에게 필요한 데이터만을 보여주는 데 유용
--뷰는 실제 테이블 데이터를 저장하지 않고, 대신 쿼리문 자체를 저장
--뷰의 주요 특징
--쿼리 단순화: 복잡한 쿼리를 뷰로 저장함으로써 사용자는 복잡한 쿼리문을 반복해서 작성할 필요 없이 간단하게 뷰를 참조할 수 있다.
--데이터 추상화: 뷰는 기본 테이블의 구조를 숨기고 사용자에게 필요한 데이터만을 보여줄 수 있어, 데이터 추상화를 제공.
--보안 강화: 뷰를 사용하면 특정 데이터에 대한 접근을 제한할 수 있으며, 사용자가 볼 수 있는 데이터의 범위를 제어할 수 있다.
--데이터 무결성 유지: 뷰를 사용하여 데이터를 수정하더라도, 이 변경사항이 기본 테이블의 데이터 무결성 규칙을 위반하지 않도록 관리할 수 있다.
CREATE VIEW EMPLOYEE_DETAILS AS
SELECT EMPLOYEE_ID, LAST_NAME, DEPARTMENT_ID FROM EMPLOYEES;
SELECT * FROM EMPLOYEE_DETAILS;
---------------------------------------- Q. EMPLYEES 테이블에서 SALARY가 10000원 이상인 직원만을 포함하는 뷰 SPECIAL_EMPLOYEE를 생성
DROP VIEW SPECIAL_EMPLOYEE;
CREATE VIEW SPECIAL_EMPLOYEE AS
SELECT EMPLOYEE_ID, LAST_NAME, SALARY FROM EMPLOYEES
WHERE SALARY >= 10000;

SELECT * FROM SPECIAL_EMPLOYEE;
---------------------------------------- Q. EMPLOYEES 테이블에서 각 부서별 직원수를 포함하는 뷰를 생성
DROP VIEW NUM_EMPLOYEE_DEPART;
CREATE VIEW NUM_EMPLOYEE_DEPART AS
SELECT COUNT(*) 부서직원수, DEPARTMENT_ID
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;
SELECT * FROM num_employee_depart;


----------------------- 아래 거 에러 난다. 이거 할 때 GROUP BY는 둘 모두를 적용해야 에러가 안난다
DROP VIEW NUM_EMPLOYEE_DEPART;
CREATE VIEW NUM_EMPLOYEE_DEPART AS
SELECT COUNT(*) 부서직원수, D.DEPARTMENT_NAME, D.DEPARTMENT_ID
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME, D.DEPARTMENT_ID;

SELECT * FROM num_employee_depart;

------------------------------- 이건 괜찮아
DROP VIEW NUM_EMPLOYEE_DEPART;
CREATE VIEW NUM_EMPLOYEE_DEPART AS
SELECT COUNT(*) 부서직원수, D.DEPARTMENT_NAME
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME;

SELECT * FROM num_employee_depart;


---------------------------------------- Q. EMPLOYEES 테이블에서 근속기간이 10년 이상인 직원을 포함하는 뷰
DROP VIEW GOINMUL;
CREATE VIEW GOINMUL AS
SELECT LAST_NAME, TRUNC(SYSDATE-HIRE_DATE) AS 근속기간
FROM EMPLOYEES
WHERE TRUNC(SYSDATE-HIRE_DATE) > 365*10
ORDER BY 근속기간;

SELECT * FROM GOINMUL;

---------------------------------------- TCL (Transaction Control Language)
--COMMIT: 현재 트랜잭션 내에서 수행된 모든 변경(INSERT, UPDATE, DELETE 등)을 데이터베이스에 영구적으로 저장.
--COMMIT 명령을 실행하면, 트랜잭션은 완료되며, 그 이후에는 변경 사항을 되돌릴 수 없다.
--ROLLBACK: 현재 트랜잭션 내에서 수행된 변경들을 취소하고, 데이터베이스를 트랜잭션이 시작하기 전의 상태로 되돌린다. 
--오류가 발생했거나 다른 이유로 트랜잭션을 취소해야 할 경우에 사용된다.
--SAVEPOINT: 트랜잭션 내에서 중간 체크포인트를 생성합니다. 오류가 발생할 경우, ROLLBACK을 사용하여 최근의 SAVEPOINT까지 되돌릴 수 있다.
--트랜잭션을 콘트롤하는 TCL(TRANSACTION CONTROL LANGUAGE)

-------MEMBERS 테이블 생성
DROP TABLE MEMBERS;
CREATE TABLE MEMBERS(
    MEMBER_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(100),
    EMAIL VARCHAR2(100),
    JOIN_DATE DATE,
    STATUS VARCHAR2(20)
);
    
INSERT INTO members (member_id, name, email, join_date, status) VALUES (1, 'John Doe', 'john@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (2, 'Jane Doe', 'jane@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (3, 'Mike Smith', 'mike@example.com', SYSDATE, 'Inactive');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (4, 'Alice Johnson', 'alice@example.com', SYSDATE, 'Active');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (5, 'Bob Brown', 'bob@example.com', SYSDATE, 'Inactive');
INSERT INTO members (member_id, name, email, join_date, status) VALUES (6, 'Bob Brown', 'bob@example.com', SYSDATE, 'Inactive');
SELECT * FROM MEMBERS;
SAVEPOINT SP1;
INSERT INTO members (member_id, name, email, join_date, status) VALUES (7, 'Bob2 Brown', 'bob@example.com', SYSDATE, 'Inactive');
SELECT * FROM MEMBERS;
ROLLBACK TO SP1;
COMMIT;
SELECT * FROM MEMBERS;


---------------------------------------- Q. HR 테이블들을 분석해서 전체 현황을 설명할 수 있는 

---------------------------------------- 강사님 예시
--부서별 급여 현황
--테이블생성, 부서별 급여와 총 급여를 확인 할 수 있음.
--(급여의 합 평균 최솟값 최댓값, 총 직원수, 급여전체총합, 직원평균급여, 부서평균급여)
--table 만들기 부서별 급여를 대략적으로 보기
--사용할 테이블 확인
select * from jobs;
select * from departments;
select * from employees;
select * from job_history;

--부서 목록 확인
SELECT department_id
from employees
group by department_id
order by department_id DESC;
-- 부서 목록 department_id : 10,20,30,40,50,60,70,80,90,100,110 그 외 나머지(120~200등..)는 없고 null 값이 있음.
--department_id 가 null 인 사람은 모두 job_id 에 맞는 department_id 를 부여해주려고함(데이터 무결성)
--1. department_id 가 null 값인 사람 찾기
select *
from employees
where department_id IS NULL;
--한명 밖에 없음. department_id : null, employee_id : 178, Job_id : SA_REP

--2. job_id 가 SA_REP 인 department_id 찾기 (직업에 맞는 부서 찾기)
select job_id, department_id
from job_history
where job_id IN 'SA_REP';
--SA_REP 의 department_id 는 80

--3. 수정 전 savepoint 생성
SAVEPOINT null_to_80;
------------------------SAVEPOINT---------------------------------

--4. 제약조건primary key 인 employee_id 로 찾아서 derpartment_id 를 80으로 수정
UPDATE employees
SET department_id = 80
WHERE employee_id = 178;

select * from employees where employee_id = 178;
--ROLLBACK null_to_80; -- savepoint로 가기
--commit;
--수정끝

------------------------------------------------------------------------------- INSIGHTS 찾기
-- 각 부서별 팀원은 몇명이고, 어떤 포지션 구성은 어떻게
SELECT E.DEPARTMENT_ID, D.DEPARTMENT_NAME, NVL(E.JOB_ID, 'TOTAL') JOB_ID, COUNT(*) 직원수
FROM EMPLOYEES E
LEFT OUTER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY ROLLUP((E.DEPARTMENT_ID, D.DEPARTMENT_NAME), E.JOB_ID)
ORDER BY E.DEPARTMENT_ID;

-- JOB_ID별 몇년차는 얼마를 받는지 년차별 샐러리 평균
SELECT JOB_ID, 연차, ROUND(AVG(SALARY)) 평균급여
FROM (SELECT JOB_ID, FLOOR(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) AS 연차, SALARY FROM EMPLOYEES)
GROUP BY JOB_ID, 연차
ORDER BY JOB_ID, 연차;



----------------------------- Q. 
----------------------------- Q. 
----------------------------- Q. 
----------------------------- Q. 

--MONTHS_BETWEEN------------- Q.
--MONTHS_BETWEEN------------- Q.
--MONTHS_BETWEEN------------- Q.
