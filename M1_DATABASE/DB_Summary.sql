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
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C 
INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
INNER JOIN BOOK B ON O.BOOKID = B.BOOKID
WHERE O.SALEPRICE = 20000;

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

---------------------------------------- UPDATE 추가 예정

---------------------------------------- REPLACE 추가 예정


----------------------------------------
