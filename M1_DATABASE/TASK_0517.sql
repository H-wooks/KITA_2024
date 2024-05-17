
-- TASK1.0517. 출판사가 "굿스포츠" 혹은 "대한 미디어"인 도서를 검색하시오 (3가지)
-- OPTION1
SELECT * FROM BOOK
WHERE PUBLISHER='굿스포츠' OR PUBLISHER='대한 미디어';
-- OPTION2
SELECT * FROM BOOK
WHERE PUBLISHER LIKE '%스포츠%' OR PUBLISHER LIKE  '%대한%';
-- OPTION3
SELECT * FROM BOOK
WHERE PUBLISHER IN ('굿스포츠','대한미디어');

-- Task2_0517. 출판사가 '굿스포츠' 혹은 '대한미디어'가 아닌 도서를 검색
SELECT * FROM BOOK
WHERE PUBLISHER !='굿스포츠' AND PUBLISHER != '대한미디어';
SELECT * FROM BOOK
WHERE PUBLISHER NOT IN ('굿스포츠','대한미디어');

-- Task3_0517. 축구에 관한 도서 중 가격이 20,000원 이상인 도서를 검색하시오.
SELECT * FROM BOOK
WHERE BOOKNAME LIKE '%축구%' AND PRICE >= 20000;

--Task4_0517. 2번 김연아 고객이 주문한 도서의 총 판매액을 구하시오.
SELECT SUM(ORDERS.SALEPRICE) AS "총 판매액"
FROM ORDERS
JOIN CUSTOMER ON
CUSTOMER.CUSTID = ORDERS.CUSTID
WHERE CUSTOMER.NAME = '김연아';

--Task5_0517. 가격이 8,000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하시오. 
--단, 두 권 이상 구매한 고객만 구하시오.
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMER;
SELECT * FROM BOOK;

SELECT CUSTOMER.NAME, COUNT(*) AS 도서수량
FROM CUSTOMER
JOIN ORDERS ON 
CUSTOMER.CUSTID = ORDERS.CUSTID
WHERE ORDERS.SALEPRICE >= 8000
GROUP BY CUSTOMER.NAME
HAVING COUNT(*) >= 2;

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
SELECT CUSTOMER.NAME, SUM(ORDERS.SALEPRICE)
FROM CUSTOMER
JOIN ORDERS ON 
CUSTOMER.CUSTID = ORDERS.CUSTID
GROUP BY NAME
ORDER BY SUM(ORDERS.SALEPRICE)