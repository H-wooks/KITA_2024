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
----------------------------- Q. 
----------------------------- Q. 
----------------------------- Q. 
----------------------------- Q. 

--MONTHS_BETWEEN------------- Q.
--MONTHS_BETWEEN------------- Q.
--MONTHS_BETWEEN------------- Q.
