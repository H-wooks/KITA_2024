----------------------------------------- DDL/DML/DCL/TCL
DDL(Data Definition Lang): CREATE/ALTER/DROP
DML (Data Manipulation Lang): SELECT/INSERT/UPDATE/DELETE
DCL(Data Control Lang): GRANT/REVOKE
TCL(Transaction Control Lag): COMMIT/ROLLBACK/SAVEPOINT

----------------------------------------- 최초 USER 계정 생성, 권한 설정
DROP USER c##md CASCADE;
CREATE USER c##md IDENTIFIED BY md DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp PROFILE DEFAULT;
GRANT CONNECT, RESOURCE TO c##md;
GRANT CREATE VIEW, CREATE SYNONYM TO c##md;
GRANT UNLIMITED TABLESPACE TO c##md;
ALTER USER c##md ACCOUNT UNLOCK;

---------------------------------------- TABLE을 휴지통에 버리지 않고 완전히 삭제할 때
DROP TABLE Orders cascade constraints purge;

---------------------------------------- TABLE 생성
CREATE TABLE NEWORDERS (
ORDERID NUMBER,
CUSTID NUMBER NOT NULL,
BOOKID NUMBER NOT NULL,
SALEPRICE NUMBER,
ORDERDATE DATE,
PRIMARY KEY(ORDERID),
FOREIGN KEY(CUSTID) REFERENCES NEWCUSTOMER(CUSTID) ON DELETE CASCADE);

---------------------------------------- CREATE VIEW (단순/추상화/보안....): 쿼리문 자체를 저장
CREATE VIEW EMPLOYEE_DETAILS AS
SELECT EMPLOYEE_ID, LAST_NAME, DEPARTMENT_ID FROM EMPLOYEES;
-- CALL 할 때는 
SELECT * FROM EMPLOYEE_DETAILS;

---------------------------------------- 수정하기: DATA DEFINITION-ALTER/DROP, MANIPULATION-DELETE
ALTER TABLE TEACHERS DROP COLUMN SUBJECT;
ALTER TABLE TEACHERS MODIFY (CLASS_ASSIGNED VARCHAR2(15));
DELETE FROM teachers WHERE name = '김철호';

---------------------------------------- REPLACE 
---- 실재 변경
UPDATE BOOK SET BOOKNAME=REPLACE(BOOKNAME,'야구','농구');
---- DATA가 실재로 바뀌지는 않고 검색 시에 변경만 되서.. TABLE의 값은 원래대로..
SELECT BOOKID, REPLACE(BOOKNAME,'야구','농구') BOOKNAME, PUBLISHER, PRICE
FROM BOOK;

---------------------------------------- UPDATE 
UPDATE CUSTOMER SET ADDRESS='대한민국 대전' WHERE NAME='박세리';
UPDATE CUSTOMER SET ADDRESS=(SELECT ADDRESS FROM CUSTOMER WHERE NAME='김연아') WHERE NAME='박세리';
UPDATE SCOREBOARD SET
SCORE_MATH = ROUND((MATH1 * 0.3 + MATH2 * 0.3 + MATH3 * 0.3) - ABSENCE),
SCORE_PHYS = ROUND((PHYS1 * 0.3 + PHYS2 * 0.3 + PHYS3 * 0.3) - ABSENCE);

---------------------------------------- 저장하기: 보류중인 모든 데이터 변경사항을 영구적으로 적용
COMMIT;
---------------------------------------- 되돌리기: 현재 트랜잭션 종료, 직전 커밋 직후의 단계로 회귀(되돌아가기)
ROLLBACK;                                -- 직전 COMMIT 까지.. 모두 다 날아갈 수 있음.
---------------------------------------- ROLLBACK할 중간 체크 포인트 지정
SAVEPOINT SP1;
~~~~
ROLLBACK TO SP1;

---------------------------------------- TABLE에 DATA VALUE 넣기
--테이블에 데이터를 입력하는 방법은 두 가지 유형이 있으며 한 번에 한 건만 입력된다.
-- a.INSERT INTO 테이블명 (COLUMN_LIST) VALUES (COLUMN_LIST에 넣을 VALUE_LIST);
-- b.INSERT INTO 테이블명 VALUES (전체 COLUMN에 넣을 VALUE_LIST);

INSERT INTO NEWORDERS VALUES (1,1,1,14000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NEWORDERS VALUES (5,1,6,3000, SYSDATE);

---------------------------------------- FOREIGN KEY 관련
-- NEWORDERS에 CUSTID를 NEWCUSTOMER 테이블의 CUSTID 키를 REFERENCE로 해서 FOREIGN 키로 설정하면,
-- 부모인 NEWCUSTOMER 테이블의 CUSTID와 관련된 DATA가 삭제되면 NEWORDERS에서도 삭제
CREATE TABLE NEWORDERS (
~
FOREIGN KEY(CUSTID) REFERENCES NEWCUSTOMER(CUSTID) ON DELETE CASCADE);
test) 
-- NEWCUSTOMER에서 PRIMARY KEY인 CUSTID=1인 DATA를 삭제를 하면 NEWORDERS에서 CUSTID=1에 해당하는 ORDERS DATA도 모두 삭제..
 FROM NEWCUSTOMER WHERE CUSTID=1;
-- NEWORDERS에서 CUSTID=3인 DATA를 삭제 하면 NEWORDERS에서는 삭제되지만, NEWCUSTOMER에서 CUSTID=3인 DATA들은 삭제 x.. 그대로 존재..
 FROM NEWORDERS WHERE CUSTID=1;
-- NEWORDERS에서 CUSTID 컬럼을 삭제하더라도 NEWCUSTOMER에서는 삭제 안되고 그대로 남아 있음
ALTER TABLE NEWORDERS DROP COLUMN CUSTID;
-- 반면, NEWCUSTOMER에서는 CUSTID 컬럼은 NEWORDERS에서 FOREIGN 키로 설정되어 있어서 아예 삭제가 안됨
-- 다만, NEWORDERS에서 FOREIGN 키로 설정되어 있던  CUSTID를 먼저 DROP시키고 나서 NEWCOSTOMER에서 CUSTID COLUMN을 DROP으로 삭제는 가능
ALTER TABLE NEWCUSTOMER DROP COLUMN CUSTID;

---------------------------------------- 검색하기/중복없이 검색하기
-- 중복 없이 출력 DISTINCT
SELECT PUBLISHER FROM BOOK;
SELECT DISTINCT PUBLISHER FROM BOOK;      

---------------------------------------- 조건으로 검색하기
SELECT * FROM BOOK WHERE  PRICE >= 10000 AND PRICE <= 20000;
SELECT * FROM BOOK WHERE PRICE BETWEEN 10000 AND 20000;
SELECT BOOKNAME, PUBLISHER FROM BOOK WHERE BOOKNAME LIKE '%축구%';
SELECT * FROM BOOK WHERE PUBLISHER IN ('굿스포츠','대한미디어');

-------------------- 정렬, HEIERACHICAL하게 복수로 줘도 되고 각각에 대해서 오름/내림 차순 설정 가능
SELECT * FROM BOOK ORDER BY PRICE DESC;
SELECT * FROM EMPLOYEES ORDER BY SALARY ASC, LAST_NAME DESC;

-------------------------------------- DEFAULT 정의하기
SELECT NAME 이름, nvl(PHONE, '연락처 없음') 전화번호
FROM CUSTOMER;

-------------------------------------- 앞의 몇가지 케이스에 대해서만 검색하기  ==> 가상의 ROWNUM
SELECT ROWNUM 순번,  CUSTID 고객번호, NAME 이름,  PHONE 전화번호
FROM CUSTOMER
WHERE ROWNUM < 3;

---------------------------------------- 간단한 함수
SELECT SUM(SALEPRICE) AS TOTAL, AVG(SALEPRICE) AS AVERAGE,
MAX(SALEPRICE) AS MAXIMUM, MIN(SALEPRICE) AS MINIMUM
FROM ORDERS;

---------------------------------------- GROUP BY / HAVING 사용 예
-- 도서 수량이 2보다 조건
SELECT CUSTID, COUNT(*) AS 도서수량, SUM(SALEPRICE) AS "총 판매액"
FROM ORDERS
WHERE BOOKID > 5 GROUP BY CUSTID
HAVING COUNT(*) > 2;

---------------------------------------- GROUP BY 할때 ROLLUP
---------------------------------------- ROLLUP은 복수 GROUP을 사용할 때 소그룹/전체 그룹의 합계를 보여줌
SELECT E.DEPARTMENT_ID, D.DEPARTMENT_NAME, NVL(E.JOB_ID, 'TOTAL') JOB_ID, COUNT(*) 직원수
FROM EMPLOYEES E
LEFT OUTER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY ROLLUP((E.DEPARTMENT_ID, D.DEPARTMENT_NAME), E.JOB_ID)
ORDER BY E.DEPARTMENT_ID;


---------------------------------------- INNER JOIN 사용
-- Q. 도서 구매 가격이 20000원인 주문의 고객명, 도서명, 판매 가격 검색
-- OPTION 1 USING JOIN
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C 
INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
INNER JOIN BOOK B ON O.BOOKID = B.BOOKID
WHERE O.SALEPRICE = 20000;

-- OPTION 2 USING WHERE
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C, ORDERS O, BOOK B
WHERE  C.CUSTID = O.CUSTID AND O.BOOKID = B.BOOKID
AND O.SALEPRICE = 20000;

-- Q. 대한민국에 거주하는 고객에게 판매한 도서의 총 판매액
-- USING WHERE
SELECT SUM(O.SALEPRICE) AS "총판매액"
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID
AND C.ADDRESS LIKE '%대한민국%';

-- USING JOIN
SELECT SUM(O.SALEPRICE) AS "총판매액"
FROM ORDERS O
INNER JOIN CUSTOMER C ON O.CUSTID=C.CUSTID
WHERE C.ADDRESS LIKE '%대한민국%';

-- USING SUB-QUERY
-- USING SUB-QUERY
SELECT SUM(SALEPRICE) AS "총판매액"
FROM ORDERS
WHERE CUSTID IN (SELECT CUSTID FROM CUSTOMER WHERE ADDRESS LIKE '%대한민국%');

-- Q. 대한민국 외에 거주하는 고객에게 판매한 도서의 총 판매액
SELECT SUM(O.SALEPRICE) AS "총판매액"
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID
AND C.ADDRESS NOT LIKE '%대한민국%';
---------------------------------------- OUTER JOIN  (LEFT) 사용
-- OPTION 1 USING JOIN
-- LEFT가 기준이 되므로 LEFT (처음 테이블)의 모든 행은 나오는 JOIN형태 (없으면 NULL로...)
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C
LEFT OUTER JOIN ORDERS O ON C.CUSTID=O.CUSTID
LEFT OUTER JOIN BOOK B ON B.BOOKID=O.BOOKID
ORDER BY C.NAME;

-- OPTION 2 USING WHERE
-- 기준이 되는 반대 TABLE에 (+)를 표시해서 없더라도 더 추가해서 NULL로라도 표기함
SELECT C.NAME,B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C, BOOK B, ORDERS O
WHERE C.CUSTID=O.CUSTID(+)
AND B.BOOKID(+) = O.BOOKID
ORDER BY C.NAME;

---------------------------------------- SUB QUERY (부속 질의) 추가 예정
-- Q. ‘대한미디어’에서 출판한 도서를 구매한 고객의 이름을 보이시오.
-- BOOK 테이블에서 PUBLISHER가 '대한미디어'인 BOOKID 중에 주문 정보에 들어가 있는 것 + 여기서 주문한 CUSTID를 추리고 CUSTOMER
-- 테이블에서 NAME을 검색
SELECT NAME FROM CUSTOMER
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS
WHERE BOOKID IN (SELECT BOOKID FROM BOOK
WHERE PUBLISHER = '대한미디어'));

-- Q. 가장 비싼 책의 정보를 검색 
SELECT BOOKNAME, PRICE, PUBLISHER FROM BOOK 
WHERE PRICE = (SELECT MAX(PRICE) FROM BOOK);

---------------------------------------- TRIPLE JOIN + SUB-QUERY 결합 예제
---------------------------------------- Q.반별 평균 점수가 가장 높은 반 순서로 정렬 (1학년 만)
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

--------------------------------------- Q. 평균 주문금액 이하의 주문에 대해서 주문번호와 금액 검색 <== 전체 평균 대비
SELECT ORDERID, SALEPRICE 
FROM ORDERS
WHERE SALEPRICE < (SELECT AVG(SALEPRICE)
FROM ORDERS);
-- 다른 방식 i
SELECT O1.ORDERID, O1.SALEPRICE 
FROM ORDERS O1
WHERE O1.SALEPRICE < (SELECT AVG(O2.SALEPRICE)
FROM ORDERS O2);

-- 다른 방식 ii
-- 서브 쿼리를 O2별칭으로 지정, 서브 쿼리인 SALEPRICE의 평균 값을 AVG_SALEPRICE로 계산해서 O2로
SELECT O1.ORDERID, O1.SALEPRICE 
FROM ORDERS O1
JOIN (SELECT AVG(SALEPRICE) AS AVG_SALEPRICE FROM ORDERS) O2
ON O1.SALEPRICE < O2.AVG_SALEPRICE;

--Q. 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.<== 출판사별 평균 대비,,,
-- 이를 위해 B2.PUBLISHER = B1.PUBLISHER 같은 출판사에 대해 AVG 모두 계산하기 위해...
SELECT B1.PUBLISHER, B1.BOOKNAME, B1.PRICE 
FROM BOOK B1
WHERE B1.PRICE > (SELECT AVG(B2.PRICE)
FROM BOOK B2
WHERE B2.PUBLISHER = B1.PUBLISHER);
--GROUP BY PUBLISHER ==> 필요 없어 각각이 도서에 대해서 평균 보다 비싼 개별 도서 이므로 

--Q. 도서를 주문하지 않은 고객의 이름을 보이시오.
SELECT NAME FROM CUSTOMER WHERE CUSTID NOT IN (
SELECT CUSTID FROM ORDERS);

---------------------------------------- WITH AS: 과도한 서브 쿼리는 메인 쿼리의 복잡하게 
---------------------------------------- ==> 복잡한 부분의 쿼리를 WITH AS로 분리
---------------------------------------- Q. 학년 별 학생 수와 선생님 수, 선생님 한 명당 학생 수 비율이 높은 순으로 정리
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

---------------------------------------- UNION
-- UNION (합집합), INTERSECT (교집합), MINUS(차집합) UNION ALL(겹치는 것까지 포함)
-- 두개의 쿼리문을 사용, 데이터 타입이 일치해야
SELECT FIRST_NAME 이름, SALARY 급여 FROM EMPLOYEES
WHERE SALARY < 5000
UNION                                                  -- UNION/INTERSECT/MINUS/UNION ALL
SELECT FIRST_NAME 이름, SALARY 급여 FROM EMPLOYEES
WHERE HIRE_DATE < '99/01/01';

---------------------------------------- DECODE
-- if문이나 case문과 같이 여러 경우를 선택할 수 있도록 하는 함수
-- DECODE(expression, search1, result1, ..., searchN, resultN, default) 
SELECT LAST_NAME, DEPARTMENT_ID, DECODE(DEPARTMENT_ID,90, '경영지원실',60, '프로그래머',100, '인사부', '기타') AS 부서 FROM EMPLOYEES;
SELECT COMMISSION_PCT AS COMMISSION, DECODE(COMMISSION_PCT, NULL, 'N', 'A') AS 변환 FROM EMPLOYEES ORDER BY 변환 DESC;

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
----------------------------------------
SELECT NAME, STDID, SCORE_MATH, CASE
   WHEN SCORE_MATH >= 65 THEN 'A' WHEN SCORE_MATH BETWEEN 55 AND 64 THEN 'B'  WHEN SCORE_MATH BETWEEN 45 AND 54 THEN 'C'
   WHEN SCORE_MATH BETWEEN 36 AND 44 THEN 'D'  ELSE 'F' END AS GRADE_MATH, ABSENCE, FLUNK
FROM SCOREBOARD;

---------------------------------------- UPDATE + CASE - WHEN - THEN
UPDATE SCOREBOARD
SET FLUNK = CASE
WHEN TO_NUMBER(SCORE_MATH) <= 35 AND TO_NUMBER(SCORE_PHYS) <= 35 THEN '유급'
WHEN TO_NUMBER(SCORE_MATH) <= 35 OR TO_NUMBER(SCORE_PHYS) <= 35 THEN '경고'
ELSE 'PASS'
END;
SELECT * FROM SCOREBOARD;

---------------------------------------- 글자 추출
-- Q. 같은 성(姓)을 가진 사람이 몇 명이나 되는지 성별 인원수를 구하시오.
-- SUBSTR(원본문자열 혹은 컬럼, 시작위치, 추출개수)
SELECT 성, COUNT(성) FROM (SELECT NAME, SUBSTR(NAME, 1, 1) as 성 FROM CUSTOMER) 
GROUP BY 성 
ORDER BY 성;

SELECT SUBSTR(NAME, 1, 1) 성, COUNT(*) 인원 
FROM CUSTOMER
GROUP BY SUBSTR(NAME, 1, 1)
ORDER BY SUBSTR(NAME, 1, 1);


---------------------------------------- 시간 추출 
-- Q. 마당서점은 주문일로부터 10일 후 매출을 확정한다. 각 주문의 확정일자를 구하시오.
SELECT ORDERDATE "주문 일자", ORDERDATE + 10 "확정 일자" FROM ORDERS;
SELECT ORDERDATE AS "주문 일자", TO_DATE(ORDERDATE,'yyyy-mm-dd') + 10 AS "확정 일자" FROM ORDERS;
-- 2달 후는...
SELECT ORDERDATE "주문 일자", add_months(ORDERDATE, 2) "확정 일자" FROM ORDERS;

-- Q. 마당서점이 2020년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 보이시오. 
-- 단 주문일은 ‘yyyy-mm-dd 요일’ 형태로 표시한다.
SELECT ORDERID, TO_CHAR(ORDERDATE, 'yyyy-mm-dd-DAY') AS "주문일", CUSTID, BOOKID
FROM ORDERS
WHERE ORDERDATE = '2020-07-07';
-- WHERE ORDERDATE = TO_DATE('2020-07-07', 'YYYY-MM-DD');  
-- WHERE ORDERDATE = TO_DATE('07/07/24', 'DD/MM/YY');

-- ALL PRINT
SELECT ORDERID, ORDERDATE, CUSTID, BOOKID, TO_CHAR(ORDERDATE, 'day'), TO_CHAR(ORDERDATE, 'yyyy-mm-dd DAY')
FROM ORDERS
WHERE ORDERDATE = '2020-07-07';

SELECT ORDERID, ORDERDATE, CUSTID, BOOKID, TO_CHAR(ORDERDATE, 'day'), TO_DATE(ORDERDATE, 'yyyy-mm-dd')
FROM ORDERS
WHERE ORDERDATE = '2020-07-07';

-------------------------------------- Q. 2005년 상반기에 입사한 사랍들 QUERY
SELECT FIRST_NAME ||' ' ||LAST_NAME FULL_NAME, HIRE_DATE 입사일
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YY/MM') BETWEEN '05/01' AND '05/06';


-------------------------------------- SYSTEM 시간 DATE 가져오기
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS DAY') SYSDATE1
FROM DUAL;

---------------------------------------- 단순 계산 할 때 DUMMY로 DUAL을 쓴다.
-- 절대값
SELECT ABS(-78), ABS(+78) FROM DUAL;
-- 반올림
SELECT ROUND(4.897,1) FROM DUAL;
------------------------------------------- 날짜 관련
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE + 1 FROM DUAL;
SELECT SYSDATE - 1 FROM DUAL;

--ROUND-TRUNC---------------------------- Q. 근무한 날짜 계산
SELECT LAST_NAME, SYSDATE, HIRE_DATE, ROUND(SYSDATE-HIRE_DATE) 근무시간 FROM EMPLOYEES;
SELECT LAST_NAME, SYSDATE, HIRE_DATE, TRUNC(SYSDATE-HIRE_DATE) 근무시간 FROM EMPLOYEES;

--ADD_MONTHS----------------------------- Q. 특정 개월 수를 더한 출력
SELECT LAST_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) REVISED_DATE FROM EMPLOYEES;

--LAST_DAY------------------------------- Q. 해당 월의 마지막 날짜를 반환
SELECT LAST_NAME, HIRE_DATE, LAST_DAY(ADD_MONTHS(HIRE_DATE, 1)) "월의 마지막 일" FROM EMPLOYEES;

--NEXT_DAY------------------------------- Q. 해당 날짜를 기준으로 다음에 오는 특정 요일
SELECT LAST_NAME, HIRE_DATE, NEXT_DAY(HIRE_DATE, '월') "다음 월요일" FROM EMPLOYEES;
SELECT LAST_NAME, HIRE_DATE, NEXT_DAY(HIRE_DATE, 2) "다음 월요일" FROM EMPLOYEES;

--MONTHS_BETWEEN------------------------- Q. 날짜와 날짜 사이의 개월수를 구한다. (개월 수를 소수점 첫째 자리까지 반올림)
SELECT HIRE_DATE, ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE), 1) FROM EMPLOYEES;

--형 변환 : TO_DATE---------------------- Q. 문자를 날짜로 변경한다.
SELECT TO_DATE('2023-01-01', 'YYYY-MM-DD') FROM DUAL;

--TO_CHAR------------------------------- Q. 날짜를 문자로 변경
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD') FROM DUAL;

--TO_DATE ==> TO_CHAR------------------- Q. 문자열로 부터 날짜 받아들이고 이를 문자로 형 변경
SELECT TO_DATE('2023-01-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS') DATE1, TO_CHAR(TO_DATE('2023-01-01 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'YY/MM/DD AM HH:MI:SS') "형식 변경된 시간" FROM DUAL;


--------------------------------------------- 시간 형식 ----------------------------------------------
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

--------------------------------------------- to_char( 숫자 )   숫자를 문자로 변환 ---------------------------------------------
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

SELECT SALARY, TO_CHAR(-SALARY, '0999999PR') FROM EMPLOYEES; ==> -2600: <2600>으로 표기

---------------------------------------- Q. 고객별 평균 주문 금액을 백원 단위로 반올림한 값을 구하시오
SELECT CUSTID AS 고객번호, ROUND(AVG(SALEPRICE), -2) AS 평균주문금액
FROM ORDERS
GROUP BY CUSTID;

-- Q. 굿스포츠에서 출판한 도서의 제목과 제목의 글자수 바이트 수를 보이시오
SELECT BOOKNAME 제목, LENGTH(BOOKNAME) 글자수, LENGTHB(BOOKNAME) 바이트수
FROM BOOK
WHERE PUBLISHER = '굿스포츠';

----------------------------- CONCATENATION
-- FIRST_NAME||' '||LAST_NAME AS 이름: 성과 이름을 공백으로 연결하여 RETURN
SELECT LAST_NAME, 'IS A ', JOB_ID FROM EMPLOYEES;
SELECT LAST_NAME || 'IS A ' || JOB_ID FROM EMPLOYEES;
SELECT E.EMPLOYEE_ID 사번, E.FIRST_NAME ||' ' ||E.LAST_NAME FULL_NAME,

---------------------------------------- _는 와일드카드 (1자)가 아닌 문자로 취급하고 싶을 때 ESCAPE 옵션을 사용 (LIKE 구문에만)
SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%\_A%';                      -- SQL에서는 ESCAPE로 자동으로 인식 X
SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%\_A%' ESCAPE '\';           -- SQL에서는 ESCAPE로 뭘로 쓸건지 정의 해줘야
SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%#_A%' ESCAPE '#';           -- \뿐만 아니라 #도 지정해주는 것에 따라

---------------------------------------- IN : OR 대신 사용
SELECT * FROM EMPLOYEES WHERE MANAGER_ID =101 OR MANAGER_ID=102 OR MANAGER_ID=103;
SELECT * FROM EMPLOYEES WHERE MANAGER_ID IN (101,102,103);


---------------------------------------- IS NULL / IS NOT NULL
SELECT * FROM EMPLOYEES WHERE COMMISSION_PCT IS NULL;
SELECT * FROM EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL;

---------------------------------------- IS NULL / IS NOT NULL
SELECT ROUND(355.9555) FROM DUAL; SELECT TRUNC(355.9555,1) FROM DUAL; SELECT CEIL(45.333) FROM DUAL;
  
----MOD--------------------------------- DUAL 테이블, 참조할 테이블이 없이 간단한 연산을 할 때 (홀 수 일때)
SELECT * FROM EMPLOYEES WHERE MOD(EMPLOYEE_ID, 2) = 1;
SELECT MOD(10,3) FROM DUAL;

----ROUND / TRUNC / CEIL / FLOOR ---------------- DUAL 테이블, 참조할 테이블이 없이 간단한 연산을 할 때 (홀 수 일때)
SELECT ROUND(355.9555,2) FROM DUAL;
SELECT TRUNC(355.9555,1) FROM DUAL;
SELECT CEIL(45.333) FROM DUAL;
SELECT FLOOR(45.333) FROM DUAL;

------------------------------------------- 기타 -----------------------------------------------------------
SELECT COUNT(*) FROM EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL;


--WIDTH_BUCKET()------------- 지정값, 최소값, 최대값, BUCKET 개수
SELECT WIDTH_BUCKET(92,0,100,10) FROM DUAL;
-- 0~100까지 숫자를 10개의 구간으로 나누어서 나타냈을때, 92가 속해있는 구간 ==> 10번째 구간

SELECT WIDTH_BUCKET(82,0,100,10) FROM DUAL;         -- 9번째
-- 100은 그다음으로 넘어간다. 
SELECT WIDTH_BUCKET(100,0,100,10) FROM DUAL;       -- 100은 그다음으로 넘어간다.  

--UPPER()--------------------------- 소문자/ 혹은 대만자로 출력
--LOWER()--------------------------- 문자 함수 CHARACTER FUNCTIONS
SELECT UPPER('hello world') from DUAL;
SELECT LOWER('HELLO WORLD') from DUAL;

----------------------------- Q. 첫글자만 대문자
SELECT JOB_ID, INITCAP (JOB_ID) FROM EMPLOYEES;

--LENGTH--------------------- Q.
SELECT JOB_ID, LENGTH(JOB_ID) FROM EMPLOYEES;

--INSTR--------------------- 
SELECT INSTR('Hello Word', 'o', 3, 2) from dual;            --문자열, 찾을 문자, 찾을 위치, 찾는 전체 문자 중 몇번 째 인지
-------------------------- 문자열 'O'를 'Hello Word'에서 찾는데, 3에서부터 다 찾는데, 2번째의 위치 
SELECT INSTR('Hello Word', 'o', 1, 1) from dual;            --문자열, 찾을 문자, 찾을 위치, 찾는 전체 문자 중 몇번 째 인지

-- substr------------------- 
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

--trim------------- 양쪽 공백 제거
select trim('   Hello World   ') from dual;         
select last_name, trim('A' from last_name) from employees;
select last_name, trim('a' from last_name) from employees;

--nvl()-------------  null을 0또는 다른 값으로 변환하는 함수
select last_name, manager_id, nvl(to_char(manager_id), 'ceo') from employees;





--------------------------------------- EMPLOYEES 테이블에서 DEPARTMENT_ID가 없는 직원을 추출해서 POSITION을 '신입'으로 출력
--------------------------------------- 컬럼을 새로 만들어서 '신입'으로 채워서 RETURN
SELECT EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME FULL_NAME, '신입' POSISTION
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NULL;

------------------------------------------- ERD -----------------------------------------------------------
Entity-Relationship Diagram (ERD)는 데이터베이스 설계에서 사용되는 시각적 도구
데이터베이스의 구조와 테이블 간의 관계를 보여줌, 구성 요소로는 ENTITY/ATTRIBUTES/RELATIONSHIPS/CARDINALITY가 있음

Entity(개체): 실세계에서 구별할 수 있는 개별적인 객체나 사물
주로 테이블로 매핑되며, 각 엔티티는 해당 테이블의 레코드로 표현됩니다. 예를 들어, 학생, 강사, 과목 등

Attributes(속성): 각 엔티티가 가지는 특성이나 속성을 나타냄.
열(column)로 표현되며, 테이블의 각 열은 해당 엔티티의 속성을 나타냄 
예를 들어, 학생 엔티티의 속성으로는 학번, 이름, 성별 등이 있을 수 있습니다.

Relationships(관계): 엔티티 간의 관계
주로 외래 키(foreign key)로 표현되며, 한 엔티티가 다른 엔티티와 어떻게 연결되는지를 보여줌. 
예를 들어, 학생과 강의 간의 관계는 학생이 특정 강의를 수강한다는 것을 나타낼 수 있습니다.

Cardinality(기수): 관계에서 한 엔티티의 인스턴스가 다른 엔티티의 인스턴스와 얼마나 연관되지를 나타냄. 
1:1, 1:N, N:M과 같이 표현 예를 들어, 한 강의에 여러 명의 학생이 있을 수 있으므로 강의와 학생 사이의 관계는 1:N 관계

