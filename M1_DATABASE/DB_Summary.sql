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

ALTER TABLE TEACHERS DROP COLUMN SUBJECT;
ALTER TABLE TEACHERS MODIFY (CLASS_ASSIGNED VARCHAR2(15));
ROLLBACK;
---------------------------------------- TABLE에 DATA VALUE 넣기
INSERT INTO NEWORDERS VALUES (1,1,1,14000, TO_DATE('2024-05-20 14:49:30','YYYY-MM-DD HH24:MI:SS'));
INSERT INTO NEWORDERS VALUES (5,1,6,3000, SYSDATE);

---------------------------------------- 저장하기
COMMIT;

---------------------------------------- 검색하기/중복없이 검색하기
-- 중복 없이 출력 DISTINCT
SELECT PUBLISHER FROM BOOK;
SELECT DISTINCT PUBLISHER FROM BOOK;      

---------------------------------------- 조건으로 검색하기
SELECT * FROM BOOK WHERE  PRICE >= 10000 AND PRICE <= 20000;
SELECT * FROM BOOK WHERE PRICE BETWEEN 10000 AND 20000;
SELECT BOOKNAME, PUBLISHER FROM BOOK WHERE BOOKNAME LIKE '%축구%';
SELECT * FROM BOOK WHERE PUBLISHER IN ('굿스포츠','대한미디어');

-------------------- 정렬
SELECT * FROM BOOK ORDER BY PRICE DESC;

-------------------------------------- DEFAULT 정의하기
SELECT NAME 이름, nvl(PHONE, '연락처 없음') 전화번호
FROM CUSTOMER;

-------------------------------------- 앞의 몇가지 케이스에 대해서만 검색하기  ==> 가상의 ROWNUM
SELECT ROWNUM 순번,  CUSTID 고객번호, NAME 이름,  PHONE 전화번호
FROM CUSTOMER
WHERE ROWNUM < 3;

-------------------- 간단한 함수
SELECT SUM(SALEPRICE) AS TOTAL, AVG(SALEPRICE) AS AVERAGE,
MAX(SALEPRICE) AS MAXIMUM, MIN(SALEPRICE) AS MINIMUM
FROM ORDERS;

-------------------- GROUP BY / HAVING 사용 예
-- 도서 수량이 2보다 조건
SELECT CUSTID, COUNT(*) AS 도서수량, SUM(SALEPRICE) AS "총 판매액"
FROM ORDERS
WHERE BOOKID > 5 GROUP BY CUSTID
HAVING COUNT(*) > 2;

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

---------------------------------------- FOREIGN KEY
-- NEWORDERS에 CUSTID를 NEWCUSTOMER 테이블의 CUSTID 키를 REFERENCE로 해서 FOREIGN 키로 설정하면,
-- 부모인 NEWCUSTOMER 테이블의 CUSTID와 관련된 DATA가 삭제되면 NEWORDERS에서도 삭제
CREATE TABLE NEWORDERS (
~
FOREIGN KEY(CUSTID) REFERENCES NEWCUSTOMER(CUSTID) ON DELETE CASCADE);
test) 
-- NEWCUSTOMER에서 PRIMARY KEY인 CUSTID=1인 DATA를 삭제를 하면 NEWORDERS에서 CUSTID=1에 해당하는 ORDERS DATA도 모두 삭제..
DELETE FROM NEWCUSTOMER WHERE CUSTID=1;
-- NEWORDERS에서 CUSTID=3인 DATA를 삭제 하면 NEWORDERS에서는 삭제되지만, NEWCUSTOMER에서 CUSTID=3인 DATA들은 삭제 x.. 그대로 존재..
DELETE FROM NEWORDERS WHERE CUSTID=1;
-- NEWORDERS에서 CUSTID 컬럼을 삭제하더라도 NEWCUSTOMER에서는 삭제 안되고 그대로 남아 있음
ALTER TABLE NEWORDERS DROP COLUMN CUSTID;
-- 반면, NEWCUSTOMER에서는 CUSTID 컬럼은 NEWORDERS에서 FOREIGN 키로 설정되어 있어서 아예 삭제가 안됨
-- 다만, NEWORDERS에서 FOREIGN 키로 설정되어 있던  CUSTID를 먼저 DROP시키고 나서 NEWCOSTOMER에서 CUSTID COLUMN을 DROP으로 삭제는 가능
ALTER TABLE NEWCUSTOMER DROP COLUMN CUSTID;

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


---------------------------------------- UPDATE 
UPDATE CUSTOMER SET ADDRESS='대한민국 대전' WHERE NAME='박세리';
UPDATE CUSTOMER SET ADDRESS=(SELECT ADDRESS FROM CUSTOMER WHERE NAME='김연아') WHERE NAME='박세리';

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

---------------------------------------- REPLACE 
---- 실재 변경
UPDATE BOOK SET BOOKNAME=REPLACE(BOOKNAME,'야구','농구');
---- DATA가 실재로 바뀌지는 않고 검색 시에 변경만 되서.. TABLE의 값은 원래대로..
SELECT BOOKID, REPLACE(BOOKNAME,'야구','농구') BOOKNAME, PUBLISHER, PRICE
FROM BOOK;

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


-------------------------------------- SYSTEM 시간 DATE 가져오기
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS DAY') SYSDATE1
FROM DUAL;

---------------------------------------- 단순 계산 할 때 DUMMY로 DUAL을 쓴다.
-- 절대값
SELECT ABS(-78), ABS(+78) FROM DUAL;
-- 반올림
SELECT ROUND(4.897,1) FROM DUAL;

---------------------------------------- Q. 고객별 평균 주문 금액을 백원 단위로 반올림한 값을 구하시오
SELECT CUSTID AS 고객번호, ROUND(AVG(SALEPRICE), -2) AS 평균주문금액
FROM ORDERS
GROUP BY CUSTID;

-- Q. 굿스포츠에서 출판한 도서의 제목과 제목의 글자수 바이트 수를 보이시오
SELECT BOOKNAME 제목, LENGTH(BOOKNAME) 글자수, LENGTHB(BOOKNAME) 바이트수
FROM BOOK
WHERE PUBLISHER = '굿스포츠';
