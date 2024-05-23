
--Task1_0523. 
--orders라는 테이블을 생성하고, order_id, customer_id, order_date, amount, status라는 속성을 설정하세요.
--데이터를 5개 입력하세요.
--입력한 데이터 중 2개를 수정하세요.
--수정한 데이터를 취소하기 위해 롤백을 사용하세요.
--3개의 새로운 데이터를 입력하고, 그 중 마지막 데이터 입력만 취소한 후 나머지를 커밋하세요.

--------------     1. orders라는 테이블을 생성, order_id, customer_id, order_date, amount, status 속성 설정
DROP TABLE ORDERS cascade constraints purge;
CREATE TABLE ORDERS(
    ORDER_ID NUMBER PRIMARY KEY,
    CUSTOMER_ID NUMBER,
    ORDER_DATE DATE,
    AMOUNT NUMBER,
    STATUS VARCHAR2(100)
);
--------------     2. 데이터 5개 입력
INSERT INTO ORDERS VALUES(10001, 1, TO_DATE('2024-05-23 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7500, '완료');
INSERT INTO ORDERS VALUES(10002, 2, TO_DATE('2024-05-23 10:01:00', 'YYYY-MM-DD HH24:MI:SS'), 12500, '준비중');
INSERT INTO ORDERS VALUES(10003, 3, TO_DATE('2024-05-23 10:01:30', 'YYYY-MM-DD HH24:MI:SS'), 3500, '준비중');
INSERT INTO ORDERS VALUES(10004, 4, TO_DATE('2024-05-23 10:02:30', 'YYYY-MM-DD HH24:MI:SS'), 6500, '주문완료');
INSERT INTO ORDERS VALUES(10005, 5, TO_DATE('2024-05-23 10:04:30', 'YYYY-MM-DD HH24:MI:SS'), 15500, '주문완료');

SELECT * FROM ORDERS;
SAVEPOINT SP1;

--------------     3. 입력한 데이터 중 2개를 수정
UPDATE ORDERS SET STATUS='준비중' WHERE ORDER_ID=10004;
UPDATE ORDERS SET STATUS='준비중' WHERE ORDER_ID=10005;
SELECT * FROM ORDERS;

--------------     4. 수정한 데이터를 취소하기 위해 롤백 사용
ROLLBACK TO SP1;
SELECT * FROM ORDERS;

--------------     5. 3개의 새로운 데이터 입력
INSERT INTO ORDERS VALUES(10006, 6, TO_DATE('2024-05-23 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 2500, '주문완료');
INSERT INTO ORDERS VALUES(10007, 7, TO_DATE('2024-05-23 10:06:00', 'YYYY-MM-DD HH24:MI:SS'), 7500, '주문완료');
SAVEPOINT SP2;
INSERT INTO ORDERS VALUES(10008, 1, TO_DATE('2024-05-23 10:08:20', 'YYYY-MM-DD HH24:MI:SS'), 20500,'주문완료');
SELECT * FROM ORDERS;
--------------     6. 그 중 마지막 데이터 입력만 취소
ROLLBACK TO SP2;
SELECT * FROM ORDERS;
--------------     7. 커밋
COMMIT;