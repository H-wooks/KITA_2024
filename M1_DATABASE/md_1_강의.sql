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


-- TASK1.0517. ���ǻ簡 "�½�����" Ȥ�� "���� �̵��"�� ������ �˻��Ͻÿ� (3����)
-- OPTION1
SELECT * FROM BOOK
WHERE PUBLISHER='�½�����' OR PUBLISHER='���ѹ̵��';
-- OPTION2
SELECT * FROM BOOK
WHERE PUBLISHER LIKE '%������%' OR PUBLISHER LIKE  '%����%';
-- OPTION3
SELECT * FROM BOOK
WHERE PUBLISHER IN ('�½�����','���ѹ̵��');
-- Option4
SELECT * FROM BOOK
WHERE PUBLISHER='�½�����' 
UNION
SELECT * FROM BOOK
WHERE PUBLISHER='���ѹ̵��';

-- Task2_0517. ���ǻ簡 '�½�����' Ȥ�� '���ѹ̵��'�� �ƴ� ������ �˻�
SELECT * FROM BOOK
WHERE PUBLISHER !='�½�����' AND PUBLISHER != '���ѹ̵��';
SELECT * FROM BOOK
WHERE PUBLISHER NOT IN ('�½�����','���ѹ̵��');

-- Task3_0517. �౸�� ���� ���� �� ������ 20,000�� �̻��� ������ �˻��Ͻÿ�.
-- %: 0�� �̻��� ������ ����, _ ��Ȯ�� 1���� ������ ����
SELECT * FROM BOOK
WHERE BOOKNAME LIKE '%�౸%' AND PRICE >= 20000;

--Task4_0517. 2�� �迬�� ���� �ֹ��� ������ �� �Ǹž��� ���Ͻÿ�.
SELECT CUSTOMER.NAME, ORDERS.CUSTID, SUM(ORDERS.SALEPRICE) AS "�� �Ǹž�"
FROM ORDERS
JOIN CUSTOMER ON CUSTOMER.CUSTID = ORDERS.CUSTID
WHERE CUSTOMER.NAME = '�迬��'
GROUP BY CUSTOMER.NAME,ORDERS.CUSTID;

-- �����
SELECT  ORDERS.CUSTID, CUSTOMER.NAME, SUM(ORDERS.SALEPRICE) AS "�� �Ǹž�"
FROM ORDERS, CUSTOMER
WHERE CUSTOMER.CUSTID=2 AND ORDERS.CUSTID = CUSTOMER.CUSTID
GROUP BY CUSTOMER.NAME,ORDERS.CUSTID;

SELECT  CUSTOMER.NAME, ORDERS.CUSTID, SUM(ORDERS.SALEPRICE) AS "�� �Ǹž�"
FROM ORDERS
INNER JOIN CUSTOMER ON ORDERS.CUSTID = CUSTOMER.CUSTID
WHERE CUSTOMER.CUSTID=2
GROUP BY CUSTOMER.NAME,ORDERS.CUSTID;

--CF Task4_0517. 2�� �迬�� ���� �ֹ��� ������ �� ������ �� �Ǹž��� ���Ͻÿ�.
SELECT  CUSTOMER.NAME, ORDERS.CUSTID, SUM(ORDERS.SALEPRICE) AS "�� �Ǹž�", COUNT(ORDERS.ORDERID) AS "�� ���� ���� ��"
FROM ORDERS
INNER JOIN CUSTOMER ON ORDERS.CUSTID = CUSTOMER.CUSTID
WHERE CUSTOMER.CUSTID=2
GROUP BY CUSTOMER.NAME,ORDERS.CUSTID;

--Task5_0517. ������ 8,000�� �̻��� ������ ������ ���� ���Ͽ� ���� �ֹ� ������ �� ������ ���Ͻÿ�. 
--��, �� �� �̻� ������ ���� ���Ͻÿ�.
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMER;
SELECT * FROM BOOK;

SELECT CUSTOMER.NAME,CUSTOMER.CUSTID, COUNT(*) AS ��������
FROM CUSTOMER
JOIN ORDERS ON 
CUSTOMER.CUSTID = ORDERS.CUSTID
WHERE ORDERS.SALEPRICE >= 8000
GROUP BY CUSTOMER.CUSTID, CUSTOMER.NAME
HAVING COUNT(*) >= 2
ORDER BY CUSTOMER.CUSTID;

-- �����
SELECT CUSTID, COUNT(*) AS "��������"
FROM ORDERS
WHERE SALEPRICE >= 8000
GROUP BY CUSTID
HAVING COUNT(*) >=2;


-- ������ TIP
SELECT B.CUSTID, COUNT(*)
FROM BOOK A,ORDERS B
WHERE
A.BOOKID = B.BOOKID
AND A.PRICE >= 8000
GROUP BY B.CUSTID
HAVING COUNT(*) >= 2;

--Task6_0517. ���� �̸��� ���� �ֹ��� ������ �ǸŰ����� �˻��Ͻÿ�.
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMER;
SELECT * FROM BOOK;

SELECT CUSTOMER.NAME, ORDERS.SALEPRICE, ORDERS.BOOKID
FROM CUSTOMER
JOIN ORDERS ON 
CUSTOMER.CUSTID = ORDERS.CUSTID
ORDER BY NAME, SALEPRICE;

--Task7_0517. ������ �ֹ��� ��� ������ �� �Ǹž��� ���ϰ�, ������ �����Ͻÿ�.
SELECT CUSTOMER.NAME, SUM(ORDERS.SALEPRICE) AS "�Ѿ�"
FROM CUSTOMER
JOIN ORDERS ON 
CUSTOMER.CUSTID = ORDERS.CUSTID
GROUP BY NAME
ORDER BY "�Ѿ�";

-- �����
SELECT CUSTID, SUM(SALEPRICE) AS  "���Ǹž�"
FROM ORDERS
GROUP BY CUSTID
ORDER BY "���Ǹž�";

SELECT NAME, SUM(SALEPRICE) AS "���Ǹž�"
FROM ORDERS O, CUSTOMER C
WHERE C.CUSTID=O.CUSTID
GROUP BY C.NAME
ORDER BY C.NAME;

-- 5/20 (��)
-- Q. ���� �̸��� ���� �ֹ��� ������ �̸��� ���Ͻÿ�
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

-- Q. ������ 20000���� ������ �ֹ��� ���� �̸��� ������ �̸��� ���Ͻÿ�
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C 
INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
INNER JOIN BOOK B ON O.BOOKID = B.BOOKID;

SELECT C.NAME, B.BOOKNAME, O.SALEPRICE
FROM CUSTOMER C 
INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
INNER JOIN BOOK B ON O.BOOKID = B.BOOKID
WHERE O.SALEPRICE = 20000;

SELECT C.NAME, SUM(O.SALEPRICE) AS "�ѱ��ž�"
FROM CUSTOMER C 
INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
INNER JOIN BOOK B ON O.BOOKID = B.BOOKID
WHERE O.SALEPRICE > 4000
GROUP BY C.NAME;

--JOIN�� �� �� �̻��� ���̺��� �����Ͽ� ���õ� �����͸� ������ �� ���
--���� ���� (Inner Join)
SELECT CUSTOMER.NAME, ORDERS.SALEPRICE
FROM CUSTOMER
INNER JOIN ORDERS ON CUSTOMER.CUSTID=ORDERS.CUSTID;

--���� �ܺ� ���� (Left Outer Join) : . �� ��° ���̺� ��ġ�ϴ� �����Ͱ� ���� ��� NULL ���� ���
SELECT CUSTOMER.NAME, ORDERS.SALEPRICE
FROM CUSTOMER
LEFT OUTER JOIN ORDERS ON CUSTOMER.CUSTID=ORDERS.CUSTID;

--������ �ܺ� ���� (Right Outer Join) : ù ��° ���̺� ��ġ�ϴ� �����Ͱ� ���� ��� NULL ���� ���
SELECT CUSTOMER.NAME, ORDERS.SALEPRICE
FROM CUSTOMER
RIGHT OUTER JOIN ORDERS ON CUSTOMER.CUSTID=ORDERS.CUSTID;

--FULL OUTER JOIN : ��ġ�ϴ� �����Ͱ� ���� ��� �ش� ���̺����� NULL ���� ���
SELECT CUSTOMER.NAME, ORDERS.SALEPRICE
FROM CUSTOMER
FULL OUTER JOIN ORDERS ON CUSTOMER.CUSTID=ORDERS.CUSTID;

--CROSS JOIN : �� ���̺� ���� ��� ������ ������ ����
SELECT CUSTOMER.NAME, ORDERS.SALEPRICE
FROM CUSTOMER
CROSS JOIN ORDERS;

-- Q. ������ ��������; ���� ���� �����Ͽ� ���� �̸��� ���� �ֹ��� ������ �ǸŰ����� ���Ͻÿ� (2���� ���, WHERE, JOIN)
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

-- �μ� ���� (SUB QUERY)
-- Q. ������ ������ ���� �ִ� ���� �̸��� �˻��Ͻÿ�
SELECT NAME
FROM CUSTOMER
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS);

-- Q. ���� �̵��� ������ ������ ������ ���� �̸��� ���̽ÿ�
SELECT CUSTOMER.NAME
FROM CUSTOMER
WHERE CUSTID IN (
SELECT ORDERS.CUSTID 
FROM ORDERS 
INNER JOIN BOOK 
ON BOOK.BOOKID=ORDERS.BOOKID 
WHERE BOOK.PUBLISHER='���ѹ̵��');

-- �����
SELECT NAME
FROM CUSTOMER
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS
WHERE BOOKID IN (SELECT BOOKID FROM BOOK
WHERE PUBLISHER ='���ѹ̵��'));

--Q. ���ǻ纰�� ���ǻ��� ��� ���� ���ݺ��� ��� ������ ���Ͻÿ�.
SELECT B1.BOOKNAME 
FROM BOOK B1 
WHERE B1.PRICE > (SELECT AVG(B2.PRICE) 
FROM BOOK B2 
WHERE B2.PUBLISHER = B1.PUBLISHER);

--Q. ������ �ֹ����� ���� ���� �̸��� ���̽ÿ�.
SELECT C.NAME
FROM CUSTOMER C
WHERE C.CUSTID NOT IN (
SELECT ORDERS.CUSTID FROM ORDERS);

--�����
SELECT NAME
FROM CUSTOMER
WHERE CUSTID NOT IN (
SELECT CUSTID FROM ORDERS);

--Q. �ֹ��� �ִ� ���� �̸��� �ּҸ� ���̽ÿ�.
SELECT NAME ���̸�, ADDRESS ���ּ�
FROM CUSTOMER 
WHERE CUSTID IN (
SELECT CUSTID FROM ORDERS);

SELECT NAME "�� �̸�", ADDRESS "�� �ּ�"
FROM CUSTOMER 
WHERE CUSTID IN (
SELECT CUSTID FROM ORDERS);


-- Re-Try
--Q. �����ѹ̵����� ������ ������ ������ ���� �̸��� ���̽ÿ�.
SELECT NAME
FROM CUSTOMER
WHERE CUSTID IN ( SELECT CUSTID FROM ORDERS
WHERE BOOKID IN ( SELECT BOOKID FROM BOOK
WHERE PUBLISHER = '���ѹ̵��'));

--Q. ���ǻ纰�� ���ǻ��� ��� ���� ���ݺ��� ��� ������ ���Ͻÿ�.
SELECT BOOKNAME
FROM BOOK
WHERE PRICE > (
SELECT PUBLISHER, AVG(PRICE) 
FROM BOOK
GROUP BY PUBLISHER;

--Q. ������ �ֹ����� ���� ���� �̸��� ���̽ÿ�.

--Q. �ֹ��� �ִ� ���� �̸��� �ּҸ� ���̽ÿ�.



-- ������ Ÿ��
-- ������ (Numeric Types)
-- NUMBER: ���� �������� ���� ������ Ÿ��. ����, �Ǽ�, ���� �Ҽ���, �ε� �Ҽ��� ���� ����
-- NUMBER�� NUMBER(38,0)�� ���� �ǹ̷� �ؼ�; PRECISION 38�� �ڸ��� , SCALE 0�� �Ҽ��� ���� �ڸ���: 0
-- NUMBER(10): �ڸ����� 10 �Ҽ��� 0, NUMBER(8,2): �ڸ��� 2, �Ҽ��� 2==> 8���� �Ҽ��� ���� 2�� ���Ե�.
--������ (Character Types)
--VARCHAR2(size): ���� ���� ���ڿ��� ����. size�� �ִ� ���� ���̸� ����Ʈ Ȥ�� ���ڼ��� ����
--NVARCHAR2(size)�� ����� ������ ���� ����Ʈ ���� ��� �׻� ���� ������ ũ�Ⱑ ����
--CHAR(size): ���� ���� ���ڿ��� ����. ������ ���̺��� ª�� ���ڿ��� �ԷµǸ� �������� �������� ä����
--��¥ �� �ð��� (Date and Time Types)
--DATE: ��¥�� �ð��� ����. ������ Ÿ���� ��, ��, ��, ��, ��, �ʸ� ����
--DATE Ÿ���� ��¥�� �ð��� YYYY-MM-DD HH24:MI:SS �������� �����մϴ�.
--���� ���, 2024�� 5�� 20�� ���� 3�� 45�� 30�ʴ� 2024-05-20 15:45:30���� ����

--TIMESTAMP: ��¥�� �ð��� �� ���� ������ �������� ����
--���� �������� (Binary Data Types)
--BLOB: �뷮�� ���� �����͸� ����. �̹���, ����� ���� ���� �����ϴ� �� ����
--��Ը� ��ü�� (Large Object Types)
--CLOB: �뷮�� ���� �����͸� ����
--NCLOB: �뷮�� ������ ���� ���� �����͸� ����

--���� ���ڵ��� �ǹ�
--��ǻ�ʹ� ���ڷ� �̷���� �����͸� ó��. ���ڵ��� ���� ����(��: 'A', '��', '?')�� 
--����(�ڵ� ����Ʈ)�� ��ȯ�Ͽ� ��ǻ�Ͱ� �����ϰ� ������ �� �ְ� �Ѵ�.
--���� ���, ASCII ���ڵ������� �빮�� 'A'�� 65��, �ҹ��� 'a'�� 97�� ���ڵ�. 
--�����ڵ� ���ڵ������� 'A'�� U+0041, �ѱ� '��'�� U+AC00, �̸�Ƽ�� '?'�� U+1F60A�� ���ڵ�
--�ƽ�Ű�� 7��Ʈ�� ����Ͽ� �� 128���� ���ڸ� ǥ���ϴ� �ݸ� �����ڵ�� �ִ� 1,114,112���� ���ڸ� ǥ��

--ASCII ���ڵ�:
--���� 'A' -> 65 (10����) -> 01000001 (2����)
--���� 'B' -> 66 (10����) -> 01000010 (2����)

--�����ڵ�(UTF-8) ���ڵ�: 
--���� 'A' -> U+0041 -> 41 (16����) -> 01000001 (2����, ASCII�� ����)
--���� '��' -> U+AC00 -> EC 95 80 (16����) -> 11101100 10010101 10000000 (2����)

--CLOB: CLOB�� �Ϲ������� �����ͺ��̽��� �⺻ ���� ����(��: ASCII, LATIN1 ��)�� ����Ͽ� �ؽ�Ʈ �����͸� ����. 
--�� ������ �ַ� ����� ���� ���� ����Ʈ ���ڷ� �̷���� �ؽ�Ʈ�� �����ϴ� �� ���.
--NCLOB: NCLOB�� �����ڵ�(UTF-16)�� ����Ͽ� �ؽ�Ʈ �����͸� ����. ���� �ٱ��� ������ �ʿ��� ��, \
--�� �پ��� ���� ������ �ؽ�Ʈ �����͸� ������ �� ����. �ٱ��� ���ڰ� ���Ե� �����͸� ȿ�������� ó���� �� �ִ�.

--�������� :  
--DEFAULT : ���� ������� ���� �������� ���� ��� ���� �⺻���� ����


----------------------------------------------------------------------------------------
-- VARCHAR2�� �� ���� ������� ���̸� ����: ����Ʈ�� ����
-- ���� Ȯ�� ���
SELECT *
FROM V$NLS_PARAMETERS
WHERE PARAMETER = 'NLS_LENGTH_SEMANTICS';
-- NLS_LENGTH_SEMANTICS�� ����Ʈ(Byte) �Ǵ� ����(Char)���̸� ����Ͽ� char, varchar2 Ÿ���� �÷��� ����� �ֽ��ϴ�. 
�̶� ������ �÷��� ������ ���� �ʽ��ϴ�.
-- ALTER [SYSTEM|SESSION] SET NLS_LENGTH_SEMANTICS=[CHAR|BYTE]


--AUTHOR ���̺� ����
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

-- Q. NEWBOOK�̶�� ���̺��� �����ϼ���
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

-- �Ʒ��� ���� �����ϰ� ������ BOOKID�� PRIMARY�� DEFINE�Ǿ� �����Ƿ� �ߺ� x ==> ����
INSERT INTO NEWBOOK VALUES (1, 9781234567890, 'SQL Guide', 'John Doe', 'TechBooks', 15000, TO_DATE('2024-05-20', 'YYYY-MM-DD'));

INSERT INTO NEWBOOK VALUES (2, 9781234567890, 'SQL Guide', 'John Doe', 'TechBooks', 15000, TO_DATE('2024-05-20 15:45:30', 'YYYY-MM-DD HH24:MI:SS'));

--ISBN�� �ڸ����� 13�� �Ѿ�Ƿ� ����
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

-- ���¸� ������.. DESCRIPTION
DESC NEWBOOK;

ALTER TABLE NEWBOOK MODIFY (ISBN VARCHAR2(10));
ALTER TABLE NEWBOOK ADD AUTHOR_ID NUMBER;
ALTER TABLE NEWBOOK DROP COLUMN AUTHOR_ID;

SELECT * FROM NEWBOOK;


---------------------------------------------------------------------------
-- ON DELETE CASCADE �ɼ��� �����Ǿ� �־�, NEWCUSTOMER ���̺��� � ���� ���ڵ尡 �����Ǹ�, �ش� ���� ��� �ֹ��� NEWORDERS ���̺����� �ڵ����� ����

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

-- Q. 10���� �Ӽ����� �����Ǵ� ���̺� 2���� �ۼ��ϼ���, �� FOREIGN KEY�� �����Ͽ� ���� TABLE�� �����͸� ���� �� �ٸ� ���̺��� ���õ�
-- �����͵� ��� �����ǵ��� �ϼ���. (��� ���� ������ ���)
-- ��, �� ���̺� 5���� �����͸� �Է��ϰ� �ι�° ���̺� ù��° �����͸� �����ϰ� �ִ� �Ӽ��� �����Ͽ� ������ ����

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

-- NEWCUSTOMER���� PRIMARY KEY�� CUSTID=1�� DATA�� ������ �ϸ� NEWORDERS���� CUSTID=1�� �ش��ϴ� ORDERS DATA�� ��� ����..
DELETE FROM NEWCUSTOMER WHERE CUSTID=1;

-- NEWORDERS���� CUSTID=3�� DATA�� ���� �ϸ� NEWORDERS������ ����������, NEWCUSTOMER���� CUSTID=3�� DATA���� ���� x.. �״�� ����..
DELETE FROM NEWORDERS WHERE CUSTID=3;
DELETE FROM NEWORDERS WHERE CUSTID=1;

-- NEWORDERS���� CUSTID �÷��� �����ϴ��� NEWCUSTOMER������ ���� �ȵǰ� �״�� ���� ����
ALTER TABLE NEWORDERS DROP COLUMN CUSTID;

-- �ݸ�, NEWCUSTOMER������ CUSTID �÷��� NEWORDERS���� FOREIGN Ű�� �����Ǿ� �־ �ƿ� ������ �ȵ�
-- �ٸ�, NEWORDERS���� FOREIGN Ű�� �����Ǿ� �ִ�  CUSTID�� ���� DROP��Ű�� ���� NEWCOSTOMER���� CUSTID COLUMN�� DROP���� ������ ����
ALTER TABLE NEWCUSTOMER DROP COLUMN CUSTID;

----------------------------------------------------------------------------------------------------------
--  ����
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



-- TASK1_0520. 10���� �Ӽ����� �����Ǵ� ���̺� 2���� �ۼ��ϼ���, �� FOREIGN KEY�� �����Ͽ� ���� TABLE�� �����͸� ���� �� �ٸ� ���̺��� ���õ�
-- �����͵� ��� �����ǵ��� �ϼ���. (��� ���� ������ ���)
-- ��, �� ���̺� 5���� �����͸� �Է��ϰ� �ι�° ���̺� ù��° ���̺��� �����͸� �����ϰ� �ִ� �Ӽ��� �����Ͽ� ������ ����
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
-- NEWORDERS�� 'CUSTID' KEY�� NEWCUSTOMER�� PRIMARY KEY�� 'CUSTID'�� REFERENCING�ؼ� FOREIGN KEY�� ������ ��.
SELECT * FROM NEWORDERS;
SELECT * FROM NEWCUSTOMER;
DROP TABLE NEWORDERS;
DROP TABLE NEWCUSTOMER;

-- NEWCUSTOMER���� PRIMARY KEY�� CUSTID=1�� DATA�� ������ �ϸ� NEWORDERS���� CUSTID=1�� �ش��ϴ� ORDERS DATA�� ��� ����..
DELETE FROM NEWCUSTOMER WHERE CUSTID=1;

-- NEWORDERS���� CUSTID=3�� DATA�� ���� �ϸ� NEWORDERS������ ����������, NEWCUSTOMER���� CUSTID=3�� DATA���� ���� x.. �״�� ����..
DELETE FROM NEWORDERS WHERE CUSTID=3;
DELETE FROM NEWORDERS WHERE CUSTID=1;

-- NEWORDERS���� CUSTID �÷��� �����ϴ��� NEWCUSTOMER������ ���� �ȵǰ� �״�� ���� ����
ALTER TABLE NEWORDERS DROP COLUMN CUSTID;

-- �ݸ�, NEWCUSTOMER������ CUSTID �÷��� NEWORDERS���� FOREIGN Ű�� �����Ǿ� �־ �ƿ� ������ �ȵ�
-- �ٸ�, NEWORDERS���� FOREIGN Ű�� �����Ǿ� �ִ�  CUSTID�� ���� DROP��Ű�� ���� NEWCOSTOMER���� CUSTID COLUMN�� DROP���� ������ ����
ALTER TABLE NEWCUSTOMER DROP COLUMN CUSTID;

DROP TABLE NEWORDERS;
DROP TABLE NEWCUSTOMER;


---------------------------- ����� Task1_0520. 10���� �Ӽ����� �����Ǵ� ���̺� 2���� �ۼ��ϼ���. �� FOREIGN KEY�� �����Ͽ� ���� ���̺��� �����͸� ���� �� 
-- �ٸ� ���̺��� ���õǴ� �����͵� ��� �����ǵ��� �ϼ���. (��� ���������� ���)
-- ��, �� ���̺� 5���� �����͸� �Է��ϰ� �ι�° ���̺� ù��° �����͸� �����ϰ� �ִ� �Ӽ��� �����Ͽ� ������ ���� 

DROP table mart;
DROP table department;
create table mart(
    custid number primary key
    , name varchar2(20)
    , age number
    , sx varchar2(20)
    , phone number not null
    , address varchar2(100)
    , frequency number -- �湮 ��
    , amount_num number
    , amount_price number
    , parking varchar2(20) -- ��������
    , family number -- ���� ������ ��
);

alter table mart drop column amount_num;
alter table mart modify (name varchar2(30));
alter table mart modify (phone varchar2(20));

DESC mart;
insert into mart values(1, '��浿', 32, '��', '010-1234-1234', '���� ����', 5, 1500000, 'N', 3);
insert into mart values(2, '�����', 31, '��', '010-7777-1234', '���� ��õ', 5, 200000000, 'Y', 4);
insert into mart values(3, '�̼���', 57, '��', '010-1592-1234', '�泲 �뿵', 5, 270000, 'N', 1);
insert into mart values(4, '������', 30, '��', '010-0516-1234', '���� ����', 5, 750000000, 'Y', 4);
insert into mart values(5, '�ӿ���', 30, '��', '010-0517-1235', '���� ����', 5, 75000000, 'Y', 2);

select * from mart;

create table department(
    custid number primary key
    , name varchar(20)
    , age number
    , sx varchar2(20)
    , phone number not null
    , address varchar2(100)
    , use_store varchar2(100) -- ���� ã�� ����
    , amount_num number
    , amount_price number
    , valet varchar2(20) -- �߷���ŷ ���� ��뿩��
    , rounge varchar2(20) -- vip ����� ��뿩��
    , foreign key (custid) references mart(custid) on delete cascade
);

alter table department modify (amount_price check (amount_price > 100000000));
alter table department modify (rounge default 'Y');
alter table department modify (valet default 'Y');
alter table department modify (phone varchar2(100));
alter table department drop column amount_num;
--alter table department add (custid number);
select * from department;

insert into department values(1, '�����', 31, '��', '010-7777-1234', '���� ��õ', 'LV', 900000000,'','');
insert into department values(2, '������', 30, '��', '010-0516-1234', '���� ����', 'GUCCI', 1500000000,'','');
insert into department values(3, '������', 31, '��', '010-7775-1235', '���� ��õ', 'LV', 900000000,'','');
insert into department values(4, '�ڼ���', 30, '��', '010-0516-1234', '���� ����', 'GUCCI', 1500000000,'','');
insert into department values(5, '�ӿ���', 30, '��', '010-0517-1235', '���� ����', 'ROLEX', 150000000,'','');

DELETE mart
WHERE custid = 1;


-- Task2_0520. Customer ���̺��� �ڼ��� ���� �ּҸ� �迬�� ���� �ּҷ� �����Ͻÿ�.
UPDATE CUSTOMER SET ADDRESS=(SELECT ADDRESS FROM CUSTOMER WHERE NAME='�迬��') WHERE NAME='�ڼ���';
SELECT * FROM CUSTOMER;
-- ������� ����
UPDATE CUSTOMER SET ADDRESS='���ѹα� ����' WHERE NAME='�ڼ���';

-- Task3_0520.���� ���� ���߱����� ���Ե� ������ ���󱸡��� ������ �� ���� ���, ������ ���̽ÿ�.
UPDATE BOOK SET BOOKNAME=REPLACE(BOOKNAME,'�߱�','��');
SELECT * FROM BOOK;

---- DATA�� ����� �ٲ����� �ʰ� �˻� �ÿ� ���游 �Ǽ�.. TABLE�� ���� �������..
SELECT BOOKID, REPLACE(BOOKNAME,'�߱�','��') BOOKNAME, PUBLISHER, PRICE
FROM BOOK;

-- ������� ����
UPDATE BOOK SET BOOKNAME=REPLACE(BOOKNAME,'��','�߱�');

-- Task4_0520. ���缭���� �� �߿��� ���� ��(��)�� ���� ����� �� ���̳� �Ǵ��� ���� �ο����� ���Ͻÿ�.
-- SUBSTR(�������ڿ� Ȥ�� �÷�, ������ġ, ���ⰳ��)
SELECT ��, COUNT(��) FROM (SELECT SUBSTR(NAME, 1, 1) as �� FROM CUSTOMER)
GROUP BY ��
ORDER BY ��;
-- �����
SELECT SUBSTR(NAME, 1, 1) ��, COUNT(*) �ο� 
FROM CUSTOMER
GROUP BY SUBSTR(NAME, 1, 1)
ORDER BY SUBSTR(NAME, 1, 1);

-- Task5_0520. ���缭���� �ֹ��Ϸκ��� 10�� �� ������ Ȯ���Ѵ�. �� �ֹ��� Ȯ�����ڸ� ���Ͻÿ�.
SELECT ORDERDATE AS "�ֹ� ����", TO_DATE(ORDERDATE,'yyyy-mm-dd') + 10 AS "Ȯ�� ����" FROM ORDERS;

-- �����
SELECT ORDERDATE "�ֹ� ����", ORDERDATE + 10 "Ȯ�� ����" FROM ORDERS;

-- Q. ���缭���� �ֹ��Ϸκ��� 2���� �� ������ Ȯ���Ѵ�. �� �ֹ��� Ȯ�����ڸ� ���Ͻÿ�.
SELECT ORDERDATE "�ֹ� ����", add_months(ORDERDATE, 2) "Ȯ�� ����" FROM ORDERS;

-- Task6_0520.���缭���� 2020�� 7�� 7�Ͽ� �ֹ����� ������ �ֹ���ȣ, �ֹ���, ����ȣ, ������ȣ�� ��� ���̽ÿ�. 
-- �� �ֹ����� ��yyyy-mm-dd ���ϡ� ���·� ǥ���Ѵ�.
SELECT ORDERID, TO_CHAR(ORDERDATE, 'yyyy-mm-dd-DAY') AS "�ֹ���", CUSTID, BOOKID
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

-- Task7_0520. ��� �ֹ��ݾ� ������ �ֹ��� ���ؼ� �ֹ���ȣ�� �ݾ��� ���̽ÿ�.
SELECT ORDERID, SALEPRICE 
FROM ORDERS
WHERE SALEPRICE < (SELECT AVG(SALEPRICE)
FROM ORDERS);

SELECT O1.ORDERID, O1.SALEPRICE 
FROM ORDERS O1
WHERE O1.SALEPRICE < (SELECT AVG(O2.SALEPRICE)
FROM ORDERS O2);


-- ���� ������ O2��Ī���� ����, ���� ������ SALEPRICE�� ��� ���� AVG_SALEPRICE�� ����ؼ� O2��
SELECT O1.ORDERID, O1.SALEPRICE 
FROM ORDERS O1
JOIN (SELECT AVG(SALEPRICE) AS AVG_SALEPRICE FROM ORDERS) O2
ON O1.SALEPRICE < O2.AVG_SALEPRICE;

-- Task8_0520. ���ѹα����� �����ϴ� ������ �Ǹ��� ������ �� �Ǹž��� ���Ͻÿ�.
-- USING WHERE
SELECT SUM(O.SALEPRICE) AS "���Ǹž�"
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID
AND C.ADDRESS LIKE '%���ѹα�%';

-- USING JOIN
SELECT SUM(O.SALEPRICE) AS "���Ǹž�"
FROM ORDERS O
INNER JOIN CUSTOMER C ON O.CUSTID=C.CUSTID
WHERE C.ADDRESS LIKE '%���ѹα�%';

-- USING SUB-QUERY
SELECT SUM(SALEPRICE) AS "���Ǹž�"
FROM ORDERS
WHERE CUSTID IN (SELECT CUSTID FROM CUSTOMER WHERE ADDRESS LIKE '%���ѹα�%');

---- ���ѹα� �� �����ϴ�...
SELECT SUM(O.SALEPRICE) AS "���Ǹž�"
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID
AND C.ADDRESS NOT LIKE '%���ѹα�%';

-----------------------------------------------------------------------------------------
-- �ܼ� ��� �� �� DUMMY�� DUAL�� ����.
-- ���밪
SELECT ABS(-78), ABS(+78) FROM DUAL;
-- �ݿø�
SELECT ROUND(4.897,1) FROM DUAL;

-- Q. ���� ��� �ֹ� �ݾ��� ��� ������ �ݿø��� ���� ���Ͻÿ�
SELECT * FROM ORDERS;
SELECT CUSTID AS ����ȣ, ROUND(AVG(SALEPRICE), -2) AS "��� �ֹ� �ݾ�"
FROM ORDERS
GROUP BY CUSTID;

-- Q. �½��������� ������ ������ ����� ������ ���ڼ� ����Ʈ ���� ���̽ÿ�
SELECT BOOKNAME ����, LENGTH(BOOKNAME) ���ڼ�, LENGTHB(BOOKNAME) ����Ʈ��
FROM BOOK
WHERE PUBLISHER = '�½�����';


-------------------------------------- SYSTEM �ð� DATE ��������
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS DAY') SYSDATE1
FROM DUAL;

-------------------------------------- DEFAULT �����ϱ�
SELECT NAME �̸�, nvl(PHONE, '����ó ����') ��ȭ��ȣ
FROM CUSTOMER;


-------------------------------------- ���� ��� ���̽��� ���ؼ��� �˻��ϱ�  ==> ������ ROWNUM
SELECT ROWNUM ����,  CUSTID ����ȣ, NAME �̸�,  PHONE ��ȭ��ȣ
FROM CUSTOMER
WHERE ROWNUM < 3;





