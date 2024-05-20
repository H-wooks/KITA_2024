SELECT * FROM BOOK;
SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;

--Q. �����ѹ̵����� ������ ������ ������ ���� �̸��� ���̽ÿ�.
SELECT NAME FROM CUSTOMER
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS
WHERE BOOKID IN (SELECT BOOKID FROM BOOK
WHERE PUBLISHER = '���ѹ̵��'));


-- Q. ���� ��� å�� ������ �˻� 
SELECT BOOKNAME, PRICE, PUBLISHER FROM BOOK 
WHERE PRICE = (SELECT MAX(PRICE) FROM BOOK);

--Q. ���ǻ纰�� ���ǻ��� ��� ���� ���ݺ��� ��� ������ ���Ͻÿ�.
SELECT B1.PUBLISHER, B1.BOOKNAME, B1.PRICE 
FROM BOOK B1
WHERE B1.PRICE > (SELECT AVG(B2.PRICE)
FROM BOOK B2
WHERE B2.PUBLISHER = B1.PUBLISHER);
--GROUP BY PUBLISHER ==> �ʿ� ���� ������ ������ ���ؼ� ��� ���� ��� ���� ���� �̹Ƿ� 

--Q. ������ �ֹ����� ���� ���� �̸��� ���̽ÿ�.
SELECT NAME FROM CUSTOMER
WHERE CUSTID NOT IN (
SELECT CUSTID FROM ORDERS);

SELECT NAME FROM CUSTOMER
WHERE CUSTID IN (
SELECT CUSTID FROM ORDERS);

--Q. �ֹ��� �ִ� ���� �̸��� �ּҸ� ���̽ÿ�.
SELECT NAME, ADDRESS FROM CUSTOMER
WHERE CUSTID IN (
SELECT CUSTID FROM ORDERS);


-- Task2_0520. Customer ���̺��� �ڼ��� ���� �ּҸ� �迬�� ���� �ּҷ� �����Ͻÿ�.
UPDATE CUSTOMER SET ADDRESS=(SELECT ADDRESS FROM CUSTOMER WHERE NAME='�迬��') WHERE NAME='�ڼ���';
SELECT * FROM CUSTOMER;
-- ������� ����
UPDATE CUSTOMER SET ADDRESS='���ѹα� ����' WHERE NAME='�ڼ���';


-- Task3_0520.���� ���� ���߱����� ���Ե� ������ ���󱸡��� ������ �� ���� ���, ������ ���̽ÿ�.
UPDATE BOOK SET BOOKNAME=REPLACE(BOOKNAME,'�߱�','��');
SELECT * FROM BOOK;
-- ������� ����
UPDATE BOOK SET BOOKNAME=REPLACE(BOOKNAME,'��','�߱�');

-- Task4_0520. ���缭���� �� �߿��� ���� ��(��)�� ���� ����� �� ���̳� �Ǵ��� ���� �ο����� ���Ͻÿ�.
SELECT ��, COUNT(��) FROM (SELECT SUBSTR(NAME, 1, 1) as �� FROM CUSTOMER)
GROUP BY ��
ORDER BY ��;

-- Task5_0520. ���缭���� �ֹ��Ϸκ��� 10�� �� ������ Ȯ���Ѵ�. �� �ֹ��� Ȯ�����ڸ� ���Ͻÿ�.
SELECT ORDERDATE AS "�ֹ� ����", TO_DATE(ORDERDATE,'yyyy-mm-dd') + 10 AS "Ȯ�� ����" FROM ORDERS;

-- Task6_0520.���缭���� 2020�� 7�� 7�Ͽ� �ֹ����� ������ �ֹ���ȣ, �ֹ���, ����ȣ, ������ȣ�� ��� ���̽ÿ�. 
-- �� �ֹ����� ��yyyy-mm-dd ���ϡ� ���·� ǥ���Ѵ�.
SELECT ORDERID, TO_CHAR(ORDERDATE, 'yyyy-mm-dd-DAY') AS "�ֹ���", CUSTID, BOOKID
FROM ORDERS
WHERE ORDERDATE = '2020-07-07';

-- ALL PRINT
SELECT ORDERID, ORDERDATE, CUSTID, BOOKID, TO_CHAR(ORDERDATE, 'day'), TO_CHAR(ORDERDATE, 'yyyy-mm-dd DAY')
FROM ORDERS
WHERE ORDERDATE = '2020-07-07';

SELECT ORDERID, ORDERDATE, CUSTID, BOOKID, TO_CHAR(ORDERDATE, 'day'), TO_DATE(ORDERDATE, 'yyyy-mm-dd')
FROM ORDERS
WHERE ORDERDATE = '2020-07-07';


-- Task7_0520. ��� �ֹ��ݾ� ������ �ֹ��� ���ؼ� �ֹ���ȣ�� �ݾ��� ���̽ÿ�.
SELECT ORDERID, SALEPRICE 
FROM ORDERS
WHERE SALEPRICE < (SELECT AVG(SALEPRICE)
FROM ORDERS);

-- Task8_0520. ���ѹα����� �����ϴ� ������ �Ǹ��� ������ �� �Ǹž��� ���Ͻÿ�.
SELECT SUM(O.SALEPRICE) AS "���Ǹž�"
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID
AND C.ADDRESS LIKE '%���ѹα�%';

SELECT SUM(O.SALEPRICE) AS "���Ǹž�"
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID
AND C.ADDRESS NOT LIKE '%���ѹα�%';