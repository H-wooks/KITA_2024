
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



