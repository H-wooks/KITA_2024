SELECT * FROM BOOK;
SELECT * FROM CUSTOMER;
SELECT * FROM IMPORTED_BOOK;
SELECT * FROM ORDERS;
SELECT PRICE, BOOKID FROM BOOK;
SELECT NAME,address, PHONE FROM CUSTOMER;


-- �ߺ� ���� ��� DISTINCT
SELECT PUBLISHER FROM BOOK;
SELECT DISTINCT PUBLISHER FROM BOOK;           

--Q. ������ 10,000�̻��� ������ �˻�
-- ���� �˻��ؼ� SELECT�� "WHERE"
SELECT * FROM BOOK 
WHERE  PRICE > 20000;

-- ������ 10000�̻� 20000������ ������ �˻��Ͻÿ� (2���� ���)
-- OPTION1
SELECT * FROM BOOK 
WHERE  PRICE >= 10000 AND PRICE <= 20000;
-- OPTION2
SELECT * FROM BOOK 
WHERE PRICE BETWEEN 10000 AND 20000;

-- LIKE�� ��Ȯ�� '�౸�� ����'�� ��ġ�ϴ� �ุ ����: LIKE
SELECT BOOKNAME, PUBLISHER FROM BOOK
WHERE BOOKNAME LIKE '�౸�� ����';

-- '�౸'�� ���Ե� ���ǻ�: '%xx%'
SELECT BOOKNAME, PUBLISHER FROM BOOK
WHERE BOOKNAME LIKE '%�౸%';

-- �����̸��� ���� �� ��° ��ġ�� '��'��� ���ڿ��� ���� ����: '_X%'
SELECT BOOKNAME ,PUBLISHER FROM BOOK
WHERE BOOKNAME LIKE '_��%';


-- ���� �������� ORDERED BY
SELECT * FROM BOOK
ORDER BY BOOKNAME;

-- ���� ��������: DESC
SELECT * FROM BOOK
ORDER BY PRICE DESC;

-- Q. ������ ���ݼ����� �˻��ϰ�, ������ ������ �̸������� �˻�
SELECT * FROM BOOK
ORDER BY PRICE, BOOKNAME;

-- Q. 2�� �迬�� ���� �ֹ��� ������ �� �Ǹž��� ���Ͻÿ�
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMER;
-- ������ �ʿ��ؼ� ������ x

-- (STEP1) �ϴ� �迬���� COSTID�� 2�̹Ƿ�
SELECT SUM(SALEPRICE) AS "�� �Ǹž�"
FROM ORDERS
WHERE CUSTID = 2;

-- (STEP2) GROUP BY: �����͸� Ư�� ���ؿ� ���� �׷�ȭ�ϴµ� ���. �̸� ���� ���� �Լ� (SUM, AVG, MAX, MIN, COUNT)�� �̿�
SELECT SUM(SALEPRICE) AS TOTAL,
AVG(SALEPRICE) AS AVERAGE,
MAX(SALEPRICE) AS MAXIMUM,
MIN(SALEPRICE) AS MINIMUM
FROM ORDERS;


SELECT * FROM ORDERS;

-- �� �Ǹž��� CUSTID�� �������� �׷�ȭ
-- �Ʒ� �ڵ��� ����; ORDERS ���̺�� ���� COL�� (1)CUSTID, (2) COUNT(*), (3) SUM(SALEPRICE)�� �˻��ϴµ�..
-- �̶� BOOKID�� 5�ʰ��� �������� CUSTID �������� �˻�
SELECT CUSTID, COUNT(*) AS ��������, SUM(SALEPRICE) AS "�� �Ǹž�"
FROM ORDERS
WHERE BOOKID > 5
GROUP BY CUSTID;
-- <== ���⼭ GROUP BY CUSTID�� ������ ERROR�� �����µ�, �̰� CUSTID�� �˻� �÷��� ���ԵǾ� ������ �����ϱ� �Ұ���


-- CF) �׷� CUSTID�� �˻� COL���� ���Ÿ� �ϰ� "GROUP BY CUSTID"�� ���ϸ� ERORR�� �߻� ���ϳ�? ==> ���� ����
SELECT COUNT(*) AS ��������, SUM(SALEPRICE) AS "�� �Ǹž�"
FROM ORDERS
WHERE BOOKID > 5;

-- ���� ������ 2���� ����
SELECT CUSTID, COUNT(*) AS ��������, SUM(SALEPRICE) AS "�� �Ǹž�"
FROM ORDERS
WHERE BOOKID > 5
GROUP BY CUSTID
HAVING COUNT(*) > 2;

