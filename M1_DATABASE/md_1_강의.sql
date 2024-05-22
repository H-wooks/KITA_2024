SELECT * FROM BOOK;
SELECT * FROM CUSTOMER;
SELECT * FROM IMPORTED_BOOK;
SELECT * FROM ORDERS;
SELECT PRICE, BOOKID FROM BOOK;
SELECT NAME,address, PHONE FROM CUSTOMER;


-- 중복 없이 출력 DISTINCT
SELECT PUBLISHER FROM BOOK;
SELECT DISTINCT PUBLISHER FROM BOOK;           

--Q. 가격이 10,000이상인 도서를 검색
-- 조건 검색해서 SELECT는 "WHERE"
SELECT * FROM BOOK 
WHERE  PRICE > 20000;

-- 가격이 10000이상 20000이하인 도서를 검색하시오 (2가지 방법)
-- OPTION1
SELECT * FROM BOOK 
WHERE  PRICE >= 10000 AND PRICE <= 20000;
-- OPTION2
SELECT * FROM BOOK 
WHERE PRICE BETWEEN 10000 AND 20000;

-- LIKE는 정확히 '축구의 역사'와 일치하는 행만 선택: LIKE
SELECT BOOKNAME, PUBLISHER FROM BOOK
WHERE BOOKNAME LIKE '축구의 역사';

-- '축구'가 포함된 출판사: '%xx%'
SELECT BOOKNAME, PUBLISHER FROM BOOK
WHERE BOOKNAME LIKE '%축구%';

-- 도서이름의 왼쪽 두 번째 위치에 '구'라는 문자열을 갖는 도서: '_X%'
SELECT BOOKNAME ,PUBLISHER FROM BOOK
WHERE BOOKNAME LIKE '_구%';


-- 정렬 오름차순 ORDERED BY
SELECT * FROM BOOK
ORDER BY BOOKNAME;

-- 정렬 내림차순: DESC
SELECT * FROM BOOK
ORDER BY PRICE DESC;

-- Q. 도서를 가격순으로 검색하고, 가격이 같으면 이름순으로 검색
SELECT * FROM BOOK
ORDER BY PRICE, BOOKNAME;

-- Q. 2번 김연아 고객이 주문한 도서의 총 판매액을 구하시오
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMER;
-- 조인이 필요해서 지금은 x

-- (STEP1) 일단 김연아의 COSTID가 2이므로
SELECT SUM(SALEPRICE) AS "총 판매액"
FROM ORDERS
WHERE CUSTID = 2;

-- (STEP2) GROUP BY: 데이터를 특정 기준에 따라 그룹화하는데 사용. 이를 통해 집계 함수 (SUM, AVG, MAX, MIN, COUNT)를 이용
SELECT SUM(SALEPRICE) AS TOTAL,
AVG(SALEPRICE) AS AVERAGE,
MAX(SALEPRICE) AS MAXIMUM,
MIN(SALEPRICE) AS MINIMUM
FROM ORDERS;


SELECT * FROM ORDERS;

-- 총 판매액을 CUSTID를 기준으로 그룹화
-- 아래 코드의 설명; ORDERS 테이블로 부터 COL을 (1)CUSTID, (2) COUNT(*), (3) SUM(SALEPRICE)로 검색하는데..
-- 이때 BOOKID가 5초과인 조건으로 CUSTID 기준으로 검색
SELECT CUSTID, COUNT(*) AS 도서수량, SUM(SALEPRICE) AS "총 판매액"
FROM ORDERS
WHERE BOOKID > 5
GROUP BY CUSTID;
-- <== 여기서 GROUP BY CUSTID가 없으면 ERROR가 나오는데, 이건 CUSTID가 검색 컬럼에 포함되어 있으니 수행하기 불가능


-- CF) 그럼 CUSTID를 검색 COL에서 제거를 하고 "GROUP BY CUSTID"를 안하면 ERORR가 발생 안하나? ==> 에러 없음
SELECT COUNT(*) AS 도서수량, SUM(SALEPRICE) AS "총 판매액"
FROM ORDERS
WHERE BOOKID > 5;

-- 도서 수량이 2보다 조건
SELECT CUSTID, COUNT(*) AS 도서수량, SUM(SALEPRICE) AS "총 판매액"
FROM ORDERS
WHERE BOOKID > 5
GROUP BY CUSTID
HAVING COUNT(*) > 2;


-- TASK1.0517. 출판사가 "굿스포츠" 혹은 "대한 미디어"인 도서를 검색하시오 (3가지)
-- OPTION1
SELECT * FROM BOOK
WHERE PUBLISHER='굿스포츠' OR PUBLISHER='대한미디어';
-- OPTION2
SELECT * FROM BOOK
WHERE PUBLISHER LIKE '%스포츠%' OR PUBLISHER LIKE  '%대한%';
-- OPTION3
SELECT * FROM BOOK
WHERE PUBLISHER IN ('굿스포츠','대한미디어');
-- Option4
SELECT * FROM BOOK
WHERE PUBLISHER='굿스포츠' 
UNION
SELECT * FROM BOOK
WHERE PUBLISHER='대한미디어';

-- Task2_0517. 출판사가 '굿스포츠' 혹은 '대한미디어'가 아닌 도서를 검색
SELECT * FROM BOOK
WHERE PUBLISHER !='굿스포츠' AND PUBLISHER != '대한미디어';
SELECT * FROM BOOK
WHERE PUBLISHER NOT IN ('굿스포츠','대한미디어');

-- Task3_0517. 축구에 관한 도서 중 가격이 20,000원 이상인 도서를 검색하시오.
-- %: 0개 이상의 임의의 문자, _ 정확히 1개의 임의의 문자
SELECT * FROM BOOK
WHERE BOOKNAME LIKE '%축구%' AND PRICE >= 20000;

--Task4_0517. 2번 김연아 고객이 주문한 도서의 총 판매액을 구하시오.
SELECT CUSTOMER.NAME, ORDERS.CUSTID, SUM(ORDERS.SALEPRICE) AS "총 판매액"
FROM ORDERS
JOIN CUSTOMER ON CUSTOMER.CUSTID = ORDERS.CUSTID
WHERE CUSTOMER.NAME = '김연아'
GROUP BY CUSTOMER.NAME,ORDERS.CUSTID;

-- 강사님
SELECT  ORDERS.CUSTID, CUSTOMER.NAME, SUM(ORDERS.SALEPRICE) AS "총 판매액"
FROM ORDERS, CUSTOMER
WHERE CUSTOMER.CUSTID=2 AND ORDERS.CUSTID = CUSTOMER.CUSTID
GROUP BY CUSTOMER.NAME,ORDERS.CUSTID;

SELECT  CUSTOMER.NAME, ORDERS.CUSTID, SUM(ORDERS.SALEPRICE) AS "총 판매액"
FROM ORDERS
INNER JOIN CUSTOMER ON ORDERS.CUSTID = CUSTOMER.CUSTID
WHERE CUSTOMER.CUSTID=2
GROUP BY CUSTOMER.NAME,ORDERS.CUSTID;

--CF Task4_0517. 2번 김연아 고객이 주문한 도서의 총 갯수와 총 판매액을 구하시오.
SELECT  CUSTOMER.NAME, ORDERS.CUSTID, SUM(ORDERS.SALEPRICE) AS "총 판매액", COUNT(ORDERS.ORDERID) AS "총 도서 구매 수"
FROM ORDERS
INNER JOIN CUSTOMER ON ORDERS.CUSTID = CUSTOMER.CUSTID
WHERE CUSTOMER.CUSTID=2
GROUP BY CUSTOMER.NAME,ORDERS.CUSTID;

--Task5_0517. 가격이 8,000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하시오. 
--단, 두 권 이상 구매한 고객만 구하시오.
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMER;
SELECT * FROM BOOK;

SELECT CUSTOMER.NAME,CUSTOMER.CUSTID, COUNT(*) AS 도서수량
FROM CUSTOMER
JOIN ORDERS ON 
CUSTOMER.CUSTID = ORDERS.CUSTID
WHERE ORDERS.SALEPRICE >= 8000
GROUP BY CUSTOMER.CUSTID, CUSTOMER.NAME
HAVING COUNT(*) >= 2
ORDER BY CUSTOMER.CUSTID;

-- 강사님
SELECT CUSTID, COUNT(*) AS "도서수량"
FROM ORDERS
WHERE SALEPRICE >= 8000
GROUP BY CUSTID
HAVING COUNT(*) >=2;


-- 보선씨 TIP
SELECT B.CUSTID, COUNT(*)
FROM BOOK A,ORDERS B
WHERE
A.BOOKID = B.BOOKID
AND A.PRICE >= 8000
GROUP BY B.CUSTID
HAVING COUNT(*) >= 2;

--Task6_0517. 고객의 이름과 고객이 주문한 도서의 판매가격을 검색하시오.
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMER;
SELECT * FROM BOOK;

SELECT CUSTOMER.NAME, ORDERS.SALEPRICE, ORDERS.BOOKID
FROM CUSTOMER
JOIN ORDERS ON 
CUSTOMER.CUSTID = ORDERS.CUSTID
ORDER BY NAME, SALEPRICE;

--Task7_0517. 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객별로 정렬하시오.
SELECT CUSTOMER.NAME, SUM(ORDERS.SALEPRICE) AS "총액"
FROM CUSTOMER
JOIN ORDERS ON 
CUSTOMER.CUSTID = ORDERS.CUSTID
GROUP BY NAME
ORDER BY "총액";

-- 강사님
SELECT CUSTID, SUM(SALEPRICE) AS  "총판매액"
FROM ORDERS
GROUP BY CUSTID
ORDER BY "총판매액";

SELECT NAME, SUM(SALEPRICE) AS "총판매액"
FROM ORDERS O, CUSTOMER C
WHERE C.CUSTID=O.CUSTID
GROUP BY C.NAME
ORDER BY C.NAME;

-- 5/20 (월)
-- Q. 고객의 이름과 고객이 주문한 도서의 이름을 구하시오
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMER;
SELECT * FROM BOOK;

SELECT C.NAME, B.BOOKNAME
FROM CUSTOMER C, 
ORDERS O, 
BOOK B
WHERE C.CUSTID = O.CUSTID
AND O.BOOKID = B.BOOKID
ORDER BY C.NAME;

SELECT C.NAME, B.BOOKNAME
FROM CUSTOMER C 
INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
INNER JOIN BOOK B ON O.BOOKID = B.BOOKID
ORDER BY C.NAME;

-- Q. 가격이 20000원인 도서를 주문한 고객의 이름과 도서의 이름을 구하시오
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C 
INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
INNER JOIN BOOK B ON O.BOOKID = B.BOOKID;

SELECT C.NAME, B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C 
INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
INNER JOIN BOOK B ON O.BOOKID = B.BOOKID
WHERE O.SALEPRICE = 20000;

SELECT C.NAME, SUM(O.SALEPRICE) AS "총구매액"
FROM CUSTOMER C 
INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
INNER JOIN BOOK B ON O.BOOKID = B.BOOKID
WHERE O.SALEPRICE > 4000
GROUP BY C.NAME;

--JOIN은 두 개 이상의 테이블을 연결하여 관련된 데이터를 결합할 때 사용
--내부 조인 (Inner Join)
SELECT CUSTOMER.NAME, ORDERS.SALEPRICE
FROM CUSTOMER
INNER JOIN ORDERS ON CUSTOMER.CUSTID=ORDERS.CUSTID;

--왼쪽 외부 조인 (Left Outer Join) : . 두 번째 테이블에 일치하는 데이터가 없는 경우 NULL 값이 사용
SELECT CUSTOMER.NAME, ORDERS.SALEPRICE
FROM CUSTOMER
LEFT OUTER JOIN ORDERS ON CUSTOMER.CUSTID=ORDERS.CUSTID;

--오른쪽 외부 조인 (Right Outer Join) : 첫 번째 테이블에 일치하는 데이터가 없는 경우 NULL 값이 사용
SELECT CUSTOMER.NAME, ORDERS.SALEPRICE
FROM CUSTOMER
RIGHT OUTER JOIN ORDERS ON CUSTOMER.CUSTID=ORDERS.CUSTID;

--FULL OUTER JOIN : 일치하는 데이터가 없는 경우 해당 테이블에서는 NULL 값이 사용
SELECT CUSTOMER.NAME, ORDERS.SALEPRICE
FROM CUSTOMER
FULL OUTER JOIN ORDERS ON CUSTOMER.CUSTID=ORDERS.CUSTID;

--CROSS JOIN : 두 테이블 간의 모든 가능한 조합을 생성
SELECT CUSTOMER.NAME, ORDERS.SALEPRICE
FROM CUSTOMER
CROSS JOIN ORDERS;

-- Q. 도서를 구매하지; 않은 고객을 포함하여 고객의 이름과 고객이 주문한 도서의 판매가격을 구하시오 (2가지 방법, WHERE, JOIN)
-- OPTION 1 USING WHERE
SELECT C.NAME,B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C, BOOK B, ORDERS O
WHERE C.CUSTID=O.CUSTID(+)
AND B.BOOKID(+) = O.BOOKID
ORDER BY C.NAME;

-- OPTION 2 USING JOIN
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C
LEFT OUTER JOIN ORDERS O ON C.CUSTID=O.CUSTID
LEFT OUTER JOIN BOOK B ON B.BOOKID=O.BOOKID
ORDER BY C.NAME;

-- 부속 질의 (SUB QUERY)
-- Q. 도서를 구매한 적이 있는 고객의 이름을 검색하시오
SELECT NAME
FROM CUSTOMER
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS);

-- Q. 대한 미디어에서 출판한 도서를 구매한 고객의 이름을 보이시오
SELECT CUSTOMER.NAME
FROM CUSTOMER
WHERE CUSTID IN (
SELECT ORDERS.CUSTID 
FROM ORDERS 
INNER JOIN BOOK 
ON BOOK.BOOKID=ORDERS.BOOKID 
WHERE BOOK.PUBLISHER='대한미디어');

-- 강사님
SELECT NAME
FROM CUSTOMER
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS
WHERE BOOKID IN (SELECT BOOKID FROM BOOK
WHERE PUBLISHER ='대한미디어'));

--Q. 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.
SELECT B1.BOOKNAME 
FROM BOOK B1 
WHERE B1.PRICE > (SELECT AVG(B2.PRICE) 
FROM BOOK B2 
WHERE B2.PUBLISHER = B1.PUBLISHER);

--Q. 도서를 주문하지 않은 고객의 이름을 보이시오.
SELECT C.NAME
FROM CUSTOMER C
WHERE C.CUSTID NOT IN (
SELECT ORDERS.CUSTID FROM ORDERS);

--강사님
SELECT NAME
FROM CUSTOMER
WHERE CUSTID NOT IN (
SELECT CUSTID FROM ORDERS);

--Q. 주문이 있는 고객의 이름과 주소를 보이시오.
SELECT NAME 고객이름, ADDRESS 고객주소
FROM CUSTOMER 
WHERE CUSTID IN (
SELECT CUSTID FROM ORDERS);

SELECT NAME "고객 이름", ADDRESS "고객 주소"
FROM CUSTOMER 
WHERE CUSTID IN (
SELECT CUSTID FROM ORDERS);


-- Re-Try
--Q. ‘대한미디어’에서 출판한 도서를 구매한 고객의 이름을 보이시오.
SELECT NAME
FROM CUSTOMER
WHERE CUSTID IN ( SELECT CUSTID FROM ORDERS
WHERE BOOKID IN ( SELECT BOOKID FROM BOOK
WHERE PUBLISHER = '대한미디어'));

--Q. 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.
SELECT BOOKNAME
FROM BOOK
WHERE PRICE > (
SELECT PUBLISHER, AVG(PRICE) 
FROM BOOK
GROUP BY PUBLISHER;

--Q. 도서를 주문하지 않은 고객의 이름을 보이시오.

--Q. 주문이 있는 고객의 이름과 주소를 보이시오.



-- 데이터 타입
-- 숫자형 (Numeric Types)
-- NUMBER: 가장 범용적인 숫자 데이터 타입. 정수, 실수, 고정 소수점, 부동 소수점 수를 저장
-- NUMBER는 NUMBER(38,0)와 같은 의미로 해석; PRECISION 38은 자리수 , SCALE 0는 소수점 이하 자리수: 0
-- NUMBER(10): 자리수가 10 소수점 0, NUMBER(8,2): 자리수 2, 소수점 2==> 8에는 소수점 이하 2도 포함됨.
--문자형 (Character Types)
--VARCHAR2(size): 가변 길이 문자열을 저장. size는 최대 문자 길이를 바이트 혹은 글자수로 지정
--NVARCHAR2(size)의 사이즈를 지정할 때는 바이트 단위 대신 항상 문자 단위로 크기가 지정
--CHAR(size): 고정 길이 문자열을 저장. 지정된 길이보다 짧은 문자열이 입력되면 나머지는 공백으로 채워짐
--날짜 및 시간형 (Date and Time Types)
--DATE: 날짜와 시간을 저장. 데이터 타입은 년, 월, 일, 시, 분, 초를 포함
--DATE 타입은 날짜와 시간을 YYYY-MM-DD HH24:MI:SS 형식으로 저장합니다.
--예를 들어, 2024년 5월 20일 오후 3시 45분 30초는 2024-05-20 15:45:30으로 저장

--TIMESTAMP: 날짜와 시간을 더 상세히 나노초 단위까지 저장
--이진 데이터형 (Binary Data Types)
--BLOB: 대량의 이진 데이터를 저장. 이미지, 오디오 파일 등을 저장하는 데 적합
--대규모 객체형 (Large Object Types)
--CLOB: 대량의 문자 데이터를 저장
--NCLOB: 대량의 국가별 문자 집합 데이터를 저장

--문자 인코딩의 의미
--컴퓨터는 숫자로 이루어진 데이터를 처리. 인코딩을 통해 문자(예: 'A', '가', '?')를 
--숫자(코드 포인트)로 변환하여 컴퓨터가 이해하고 저장할 수 있게 한다.
--예를 들어, ASCII 인코딩에서는 대문자 'A'를 65로, 소문자 'a'를 97로 인코딩. 
--유니코드 인코딩에서는 'A'를 U+0041, 한글 '가'를 U+AC00, 이모티콘 '?'를 U+1F60A로 인코딩
--아스키는 7비트를 사용하여 총 128개의 문자를 표현하는 반면 유니코드는 최대 1,114,112개의 문자를 표현

--ASCII 인코딩:
--문자 'A' -> 65 (10진수) -> 01000001 (2진수)
--문자 'B' -> 66 (10진수) -> 01000010 (2진수)

--유니코드(UTF-8) 인코딩: 
--문자 'A' -> U+0041 -> 41 (16진수) -> 01000001 (2진수, ASCII와 동일)
--문자 '가' -> U+AC00 -> EC 95 80 (16진수) -> 11101100 10010101 10000000 (2진수)

--CLOB: CLOB은 일반적으로 데이터베이스의 기본 문자 집합(예: ASCII, LATIN1 등)을 사용하여 텍스트 데이터를 저장. 
--이 때문에 주로 영어와 같은 단일 바이트 문자로 이루어진 텍스트를 저장하는 데 사용.
--NCLOB: NCLOB은 유니코드(UTF-16)를 사용하여 텍스트 데이터를 저장. 따라서 다국어 지원이 필요할 때, \
--즉 다양한 언어로 구성된 텍스트 데이터를 저장할 때 적합. 다국어 문자가 포함된 데이터를 효율적으로 처리할 수 있다.

--제약조건 :  
--DEFAULT : 열에 명시적인 값이 제공되지 않을 경우 사용될 기본값을 지정


----------------------------------------------------------------------------------------
-- VARCHAR2는 두 가지 방식으로 길이를 정의: 바이트와 문자
-- 설정 확인 방법
SELECT *
FROM V$NLS_PARAMETERS
WHERE PARAMETER = 'NLS_LENGTH_SEMANTICS';
-- NLS_LENGTH_SEMANTICS는 바이트(Byte) 또는 문자(Char)길이를 사용하여 char, varchar2 타입의 컬럼을 만들수 있습니다. 
이때 기존의 컬럼은 영향을 받지 않습니다.
-- ALTER [SYSTEM|SESSION] SET NLS_LENGTH_SEMANTICS=[CHAR|BYTE]


--AUTHOR 테이블 생성
CREATE TABLE AUTHORS(
ID NUMBER PRIMARY KEY,
FIRST_NAME VARCHAR2(50) NOT NULL,
LAST_NAME VARCHAR2(50) NOT NULL,
NATIONALITY VARCHAR2(50)
);

INSERT INTO AUTHORS VALUES(1,'HWANWOOK','CHOI','ROK');
INSERT INTO AUTHORS VALUES(2,'YONWOO','CHOI','');

SELECT * FROM AUTHORS;
DROP TABLE AUTHORS;

-- Q. NEWBOOK이라는 테이블을 생성하세요
CREATE TABLE NEWBOOK (
    BOOKID NUMBER,
    ISBN NUMBER(13),
    BOOKNAME VARCHAR2(50) NOT NULL,
    AUTHOR VARCHAR2(50) NOT NULL,
    PUBLISHER VARCHAR2(30) NOT NULL,
    PRICE NUMBER DEFAULT 10000 CHECK(PRICE>10000),
    PUBLISHED_DATE DATE,
    PRIMARY KEY(BOOKID)
);

INSERT INTO NEWBOOK VALUES (1, 9781234567890, 'SQL Guide', 'John Doe', 'TechBooks', 15000, TO_DATE('2024-05-20', 'YYYY-MM-DD'));

-- 아래와 같이 동일하게 넣으면 BOOKID가 PRIMARY로 DEFINE되어 있으므로 중복 x ==> 에러
INSERT INTO NEWBOOK VALUES (1, 9781234567890, 'SQL Guide', 'John Doe', 'TechBooks', 15000, TO_DATE('2024-05-20', 'YYYY-MM-DD'));

INSERT INTO NEWBOOK VALUES (2, 9781234567890, 'SQL Guide', 'John Doe', 'TechBooks', 15000, TO_DATE('2024-05-20 15:45:30', 'YYYY-MM-DD HH24:MI:SS'));

--ISBN의 자리수가 13을 넘어가므로 에러
INSERT INTO NEWBOOK VALUES (3, 97812345678909342, 'SQL Guide', 'John Doe', 'TechBooks', 15000, TO_DATE('2024-05-20 15:45:30', 'YYYY-MM-DD HH24:MI:SS'));

DELETE FROM  NEWBOOK;
ALTER TABLE NEWBOOK MODIFY (ISBN VARCHAR2(50));
SELECT * FROM NEWBOOK;

SELECT * FROM NEWBOOK;
    
DROP TABLE NEWBOOK;

CREATE TABLE NEWBOOK (
    BOOKID NUMBER,
    ISBN NUMBER(13),
    BOOKNAME VARCHAR2(50) NOT NULL,
    AUTHOR VARCHAR2(50) NOT NULL,
    PUBLISHER VARCHAR2(50) NOT NULL,
    PRICE NUMBER DEFAULT 10000 CHECK(PRICE >10000),
    PUBLISHED_DATE DATE,
    PRIMARY KEY(BOOKID)
);

INSERT INTO NEWBOOK VALUES (1, '12345567909', 'BOOKNAME1', 'JANE DOE', 
'PRENTICEHALL',15000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:Mi:SS'));
INSERT INTO NEWBOOK VALUES (2, '1245567909', 'BOOKNAME2', 'JOHN DOE', 
'ELSVIER',25000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:Mi:SS'));
SELECT * FROM NEWBOOK;
ALTER TABLE NEWBOOK MODIFY (ISBN NUMBER(20));
DESC NEWBOOK;

INSERT INTO NEWBOOK VALUES (3, 124534345909, 'BOOKNAME3', 'HUGH GRANT', 
'FERGAMON',35000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));

-- 형태를 볼려면.. DESCRIPTION
DESC NEWBOOK;

ALTER TABLE NEWBOOK MODIFY (ISBN VARCHAR2(10));
ALTER TABLE NEWBOOK ADD AUTHOR_ID NUMBER;
ALTER TABLE NEWBOOK DROP COLUMN AUTHOR_ID;

SELECT * FROM NEWBOOK;


---------------------------------------------------------------------------
-- ON DELETE CASCADE 옵션이 설정되어 있어, NEWCUSTOMER 테이블에서 어떤 고객의 레코드가 삭제되면, 해당 고객의 모둔 주문이 NEWORDERS 테이블에서도 자동으로 삭제

CREATE TABLE NEWCUSTOMER(
CUSTID NUMBER PRIMARY KEY,
NAME VARCHAR2(40),
ADDRESS VARCHAR2(40),
PHONE VARCHAR2(30));

CREATE TABLE NEWORDERS(
ORDERID NUMBER,
CUSTID NUMBER NOT NULL,
BOOKID NUMBER NOT NULL,
SALEPRICE NUMBER,
ORDERDATE DATE,
PRIMARY KEY(ORDERID),
FOREIGN KEY(CUSTID) REFERENCES NEWCUSTOMER(CUSTID) ON DELETE CASCADE);
DESC NEWORDERS;

SELECT * FROM NEWCUSTOMER;
SELECT * FROM NEWORDERS;

-- Q. 10개의 속성으로 구성되는 테이블 2개를 작성하세요, 단 FOREIGN KEY를 적용하여 한쪽 TABLE의 데이터를 삭제 시 다른 테이블의 관련된
-- 데이터도 모두 삭제되도록 하세요. (모든 제약 조건을 사용)
-- 단, 각 테이블에 5개의 데이터를 입력하고 두번째 테이블에 첫번째 데이터를 참조하고 있는 속성을 선택하여 데이터 삭제

--------------------------------------------------------------------------------
CREATE TABLE NEWCUSTOMER(
CUSTID NUMBER PRIMARY KEY,
NAME VARCHAR2(40),
ADDRESS VARCHAR2(40),
PHONE VARCHAR2(30));
INSERT INTO NEWCUSTOMER VALUES (1, 'JOHN DOE', 'APT-1', '000-000-0001');
INSERT INTO NEWCUSTOMER VALUES (2, 'JANE DOE', 'APT-2', '000-000-0002');
INSERT INTO NEWCUSTOMER VALUES (3, 'HUGH GRANT', 'APT-3', '000-000-0003');
INSERT INTO NEWCUSTOMER VALUES (4, 'JULIA ROBERTS', 'APT-4', '000-000-0004');
INSERT INTO NEWCUSTOMER VALUES (5, 'NICOLE KIDMAN', 'APT-5', '000-000-0005');

CREATE TABLE NEWORDERS (
ORDERID NUMBER,
CUSTID NUMBER NOT NULL,
BOOKID NUMBER NOT NULL,
SALEPRICE NUMBER,
ORDERDATE DATE,
PRIMARY KEY(ORDERID),
FOREIGN KEY(CUSTID) REFERENCES NEWCUSTOMER(CUSTID) ON DELETE CASCADE);

INSERT INTO NEWORDERS VALUES (1,1,1,14000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NEWORDERS VALUES (2,1,3,24000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NEWORDERS VALUES (3,2,2,24000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NEWORDERS VALUES (4,3,4,32000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NEWORDERS VALUES (5,1,6,3000, SYSDATE);

SELECT * FROM NEWORDERS;
SELECT * FROM NEWCUSTOMER;
DROP TABLE NEWORDERS;
DROP TABLE NEWCUSTOMER;

-- NEWCUSTOMER에서 PRIMARY KEY인 CUSTID=1인 DATA를 삭제를 하면 NEWORDERS에서 CUSTID=1에 해당하는 ORDERS DATA도 모두 삭제..
DELETE FROM NEWCUSTOMER WHERE CUSTID=1;

-- NEWORDERS에서 CUSTID=3인 DATA를 삭제 하면 NEWORDERS에서는 삭제되지만, NEWCUSTOMER에서 CUSTID=3인 DATA들은 삭제 x.. 그대로 존재..
DELETE FROM NEWORDERS WHERE CUSTID=3;
DELETE FROM NEWORDERS WHERE CUSTID=1;

-- NEWORDERS에서 CUSTID 컬럼을 삭제하더라도 NEWCUSTOMER에서는 삭제 안되고 그대로 남아 있음
ALTER TABLE NEWORDERS DROP COLUMN CUSTID;

-- 반면, NEWCUSTOMER에서는 CUSTID 컬럼은 NEWORDERS에서 FOREIGN 키로 설정되어 있어서 아예 삭제가 안됨
-- 다만, NEWORDERS에서 FOREIGN 키로 설정되어 있던  CUSTID를 먼저 DROP시키고 나서 NEWCOSTOMER에서 CUSTID COLUMN을 DROP으로 삭제는 가능
ALTER TABLE NEWCUSTOMER DROP COLUMN CUSTID;

----------------------------------------------------------------------------------------------------------
--  연습
SELECT * FROM BOOK;
SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;

--Q. ‘대한미디어’에서 출판한 도서를 구매한 고객의 이름을 보이시오.
SELECT NAME FROM CUSTOMER
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS
WHERE BOOKID IN (SELECT BOOKID FROM BOOK
WHERE PUBLISHER = '대한미디어'));


-- Q. 가장 비싼 책의 정보를 검색 
SELECT BOOKNAME, PRICE, PUBLISHER FROM BOOK 
WHERE PRICE = (SELECT MAX(PRICE) FROM BOOK);

--Q. 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.
SELECT B1.PUBLISHER, B1.BOOKNAME, B1.PRICE 
FROM BOOK B1
WHERE B1.PRICE > (SELECT AVG(B2.PRICE)
FROM BOOK B2
WHERE B2.PUBLISHER = B1.PUBLISHER);
--GROUP BY PUBLISHER ==> 필요 없어 각각이 도서에 대해서 평균 보다 비싼 개별 도서 이므로 

--Q. 도서를 주문하지 않은 고객의 이름을 보이시오.
SELECT NAME FROM CUSTOMER
WHERE CUSTID NOT IN (
SELECT CUSTID FROM ORDERS);

SELECT NAME FROM CUSTOMER
WHERE CUSTID IN (
SELECT CUSTID FROM ORDERS);

--Q. 주문이 있는 고객의 이름과 주소를 보이시오.
SELECT NAME, ADDRESS FROM CUSTOMER
WHERE CUSTID IN (
SELECT CUSTID FROM ORDERS);



-- TASK1_0520. 10개의 속성으로 구성되는 테이블 2개를 작성하세요, 단 FOREIGN KEY를 적용하여 한쪽 TABLE의 데이터를 삭제 시 다른 테이블의 관련된
-- 데이터도 모두 삭제되도록 하세요. (모든 제약 조건을 사용)
-- 단, 각 테이블에 5개의 데이터를 입력하고 두번째 테이블에 첫번째 테이블의 데이터를 참조하고 있는 속성을 선택하여 데이터 삭제
CREATE TABLE NEWCUSTOMER(
CUSTID NUMBER PRIMARY KEY,
NAME VARCHAR2(40),
ADDRESS VARCHAR2(40),
PHONE VARCHAR2(30));
INSERT INTO NEWCUSTOMER VALUES (1, 'JOHN DOE', 'APT-1', '000-000-0001');
INSERT INTO NEWCUSTOMER VALUES (2, 'JANE DOE', 'APT-2', '000-000-0002');
INSERT INTO NEWCUSTOMER VALUES (3, 'HUGH GRANT', 'APT-3', '000-000-0003');
INSERT INTO NEWCUSTOMER VALUES (4, 'JULIA ROBERTS', 'APT-4', '000-000-0004');
INSERT INTO NEWCUSTOMER VALUES (5, 'NICOLE KIDMAN', 'APT-5', '000-000-0005');

CREATE TABLE NEWORDERS (
ORDERID NUMBER,
CUSTID NUMBER NOT NULL,
BOOKID NUMBER NOT NULL,
SALEPRICE NUMBER,
ORDERDATE DATE,
PRIMARY KEY(ORDERID),
FOREIGN KEY(CUSTID) REFERENCES NEWCUSTOMER(CUSTID) ON DELETE CASCADE);

INSERT INTO NEWORDERS VALUES (1,1,1,14000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NEWORDERS VALUES (2,1,3,24000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NEWORDERS VALUES (3,2,2,24000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NEWORDERS VALUES (4,3,4,32000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NEWORDERS VALUES (5,1,6,3000, SYSDATE);
------------------------------------------------------------------------------------------------
-- NEWORDERS의 'CUSTID' KEY는 NEWCUSTOMER의 PRIMARY KEY인 'CUSTID'를 REFERENCING해서 FOREIGN KEY로 설정해 둠.
SELECT * FROM NEWORDERS;
SELECT * FROM NEWCUSTOMER;
DROP TABLE NEWORDERS;
DROP TABLE NEWCUSTOMER;

-- NEWCUSTOMER에서 PRIMARY KEY인 CUSTID=1인 DATA를 삭제를 하면 NEWORDERS에서 CUSTID=1에 해당하는 ORDERS DATA도 모두 삭제..
DELETE FROM NEWCUSTOMER WHERE CUSTID=1;

-- NEWORDERS에서 CUSTID=3인 DATA를 삭제 하면 NEWORDERS에서는 삭제되지만, NEWCUSTOMER에서 CUSTID=3인 DATA들은 삭제 x.. 그대로 존재..
DELETE FROM NEWORDERS WHERE CUSTID=3;
DELETE FROM NEWORDERS WHERE CUSTID=1;

-- NEWORDERS에서 CUSTID 컬럼을 삭제하더라도 NEWCUSTOMER에서는 삭제 안되고 그대로 남아 있음
ALTER TABLE NEWORDERS DROP COLUMN CUSTID;

-- 반면, NEWCUSTOMER에서는 CUSTID 컬럼은 NEWORDERS에서 FOREIGN 키로 설정되어 있어서 아예 삭제가 안됨
-- 다만, NEWORDERS에서 FOREIGN 키로 설정되어 있던  CUSTID를 먼저 DROP시키고 나서 NEWCOSTOMER에서 CUSTID COLUMN을 DROP으로 삭제는 가능
ALTER TABLE NEWCUSTOMER DROP COLUMN CUSTID;

DROP TABLE NEWORDERS;
DROP TABLE NEWCUSTOMER;


---------------------------- 강사님 Task1_0520. 10개의 속성으로 구성되는 테이블 2개를 작성하세요. 단 FOREIGN KEY를 적용하여 한쪽 테이블의 데이터를 삭제 시 
-- 다른 테이블의 관련되는 데이터도 모두 삭제되도록 하세요. (모든 제약조건을 사용)
-- 단, 각 테이블에 5개의 데이터를 입력하고 두번째 테이블에 첫번째 데이터를 참조하고 있는 속성을 선택하여 데이터 삭제 

DROP table mart;
DROP table department;
create table mart(
    custid number primary key
    , name varchar2(20)
    , age number
    , sx varchar2(20)
    , phone number not null
    , address varchar2(100)
    , frequency number -- 방문 빈도
    , amount_num number
    , amount_price number
    , parking varchar2(20) -- 주차여부
    , family number -- 가족 구성원 수
);

alter table mart drop column amount_num;
alter table mart modify (name varchar2(30));
alter table mart modify (phone varchar2(20));

DESC mart;
insert into mart values(1, '고길동', 32, '남', '010-1234-1234', '서울 강남', 5, 1500000, 'N', 3);
insert into mart values(2, '손흥민', 31, '남', '010-7777-1234', '강원 춘천', 5, 200000000, 'Y', 4);
insert into mart values(3, '이순신', 57, '남', '010-1592-1234', '경남 통영', 5, 270000, 'N', 1);
insert into mart values(4, '아이유', 30, '여', '010-0516-1234', '서울 서초', 5, 750000000, 'Y', 4);
insert into mart values(5, '임영웅', 30, '남', '010-0517-1235', '서울 역삼', 5, 75000000, 'Y', 2);

select * from mart;

create table department(
    custid number primary key
    , name varchar(20)
    , age number
    , sx varchar2(20)
    , phone number not null
    , address varchar2(100)
    , use_store varchar2(100) -- 자주 찾는 매장
    , amount_num number
    , amount_price number
    , valet varchar2(20) -- 발렛파킹 서비스 사용여부
    , rounge varchar2(20) -- vip 라운지 사용여부
    , foreign key (custid) references mart(custid) on delete cascade
);

alter table department modify (amount_price check (amount_price > 100000000));
alter table department modify (rounge default 'Y');
alter table department modify (valet default 'Y');
alter table department modify (phone varchar2(100));
alter table department drop column amount_num;
--alter table department add (custid number);
select * from department;

insert into department values(1, '손흥민', 31, '남', '010-7777-1234', '강원 춘천', 'LV', 900000000,'','');
insert into department values(2, '아이유', 30, '여', '010-0516-1234', '서울 서초', 'GUCCI', 1500000000,'','');
insert into department values(3, '박지성', 31, '남', '010-7775-1235', '강원 춘천', 'LV', 900000000,'','');
insert into department values(4, '박세리', 30, '여', '010-0516-1234', '서울 서초', 'GUCCI', 1500000000,'','');
insert into department values(5, '임영웅', 30, '남', '010-0517-1235', '서울 역삼', 'ROLEX', 150000000,'','');

DELETE mart
WHERE custid = 1;


-- Task2_0520. Customer 테이블에서 박세리 고객의 주소를 김연아 고객의 주소로 변경하시오.
UPDATE CUSTOMER SET ADDRESS=(SELECT ADDRESS FROM CUSTOMER WHERE NAME='김연아') WHERE NAME='박세리';
SELECT * FROM CUSTOMER;
-- 원래대로 복구
UPDATE CUSTOMER SET ADDRESS='대한민국 대전' WHERE NAME='박세리';

-- Task3_0520.도서 제목에 ‘야구’가 포함된 도서를 ‘농구’로 변경한 후 도서 목록, 가격을 보이시오.
UPDATE BOOK SET BOOKNAME=REPLACE(BOOKNAME,'야구','농구');
SELECT * FROM BOOK;

---- DATA가 실재로 바뀌지는 않고 검색 시에 변경만 되서.. TABLE의 값은 원래대로..
SELECT BOOKID, REPLACE(BOOKNAME,'야구','농구') BOOKNAME, PUBLISHER, PRICE
FROM BOOK;

-- 원래대로 복구
UPDATE BOOK SET BOOKNAME=REPLACE(BOOKNAME,'농구','야구');

-- Task4_0520. 마당서점의 고객 중에서 같은 성(姓)을 가진 사람이 몇 명이나 되는지 성별 인원수를 구하시오.
-- SUBSTR(원본문자열 혹은 컬럼, 시작위치, 추출개수)
SELECT 성, COUNT(성) FROM (SELECT SUBSTR(NAME, 1, 1) as 성 FROM CUSTOMER)
GROUP BY 성
ORDER BY 성;
-- 강사님
SELECT SUBSTR(NAME, 1, 1) 성, COUNT(*) 인원 
FROM CUSTOMER
GROUP BY SUBSTR(NAME, 1, 1)
ORDER BY SUBSTR(NAME, 1, 1);

-- Task5_0520. 마당서점은 주문일로부터 10일 후 매출을 확정한다. 각 주문의 확정일자를 구하시오.
SELECT ORDERDATE AS "주문 일자", TO_DATE(ORDERDATE,'yyyy-mm-dd') + 10 AS "확정 일자" FROM ORDERS;

-- 강사님
SELECT ORDERDATE "주문 일자", ORDERDATE + 10 "확정 일자" FROM ORDERS;

-- Q. 마당서점은 주문일로부터 2개월 후 매출을 확정한다. 각 주문의 확정일자를 구하시오.
SELECT ORDERDATE "주문 일자", add_months(ORDERDATE, 2) "확정 일자" FROM ORDERS;

-- Task6_0520.마당서점이 2020년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 보이시오. 
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

-- Task7_0520. 평균 주문금액 이하의 주문에 대해서 주문번호와 금액을 보이시오.
SELECT ORDERID, SALEPRICE 
FROM ORDERS
WHERE SALEPRICE < (SELECT AVG(SALEPRICE)
FROM ORDERS);

SELECT O1.ORDERID, O1.SALEPRICE 
FROM ORDERS O1
WHERE O1.SALEPRICE < (SELECT AVG(O2.SALEPRICE)
FROM ORDERS O2);


-- 서브 쿼리를 O2별칭으로 지정, 서브 쿼리인 SALEPRICE의 평균 값을 AVG_SALEPRICE로 계산해서 O2로
SELECT O1.ORDERID, O1.SALEPRICE 
FROM ORDERS O1
JOIN (SELECT AVG(SALEPRICE) AS AVG_SALEPRICE FROM ORDERS) O2
ON O1.SALEPRICE < O2.AVG_SALEPRICE;

-- Task8_0520. 대한민국’에 거주하는 고객에게 판매한 도서의 총 판매액을 구하시오.
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
SELECT SUM(SALEPRICE) AS "총판매액"
FROM ORDERS
WHERE CUSTID IN (SELECT CUSTID FROM CUSTOMER WHERE ADDRESS LIKE '%대한민국%');

---- 대한민국 외 거주하는...
SELECT SUM(O.SALEPRICE) AS "총판매액"
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID
AND C.ADDRESS NOT LIKE '%대한민국%';

-----------------------------------------------------------------------------------------
-- 단순 계산 할 때 DUMMY로 DUAL을 쓴다.
-- 절대값
SELECT ABS(-78), ABS(+78) FROM DUAL;
-- 반올림
SELECT ROUND(4.897,1) FROM DUAL;

-- Q. 고객별 평균 주문 금액을 백원 단위로 반올림한 값을 구하시오
SELECT * FROM ORDERS;
SELECT CUSTID AS 고객번호, ROUND(AVG(SALEPRICE), -2) AS "평균 주문 금액"
FROM ORDERS
GROUP BY CUSTID;

-- Q. 굿스포츠에서 출판한 도서의 제목과 제목의 글자수 바이트 수를 보이시오
SELECT BOOKNAME 제목, LENGTH(BOOKNAME) 글자수, LENGTHB(BOOKNAME) 바이트수
FROM BOOK
WHERE PUBLISHER = '굿스포츠';


-------------------------------------- SYSTEM 시간 DATE 가져오기
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS DAY') SYSDATE1
FROM DUAL;

-------------------------------------- DEFAULT 정의하기
SELECT NAME 이름, nvl(PHONE, '연락처 없음') 전화번호
FROM CUSTOMER;


-------------------------------------- 앞의 몇가지 케이스에 대해서만 검색하기  ==> 가상의 ROWNUM
SELECT ROWNUM 순번,  CUSTID 고객번호, NAME 이름,  PHONE 전화번호
FROM CUSTOMER
WHERE ROWNUM < 3;





