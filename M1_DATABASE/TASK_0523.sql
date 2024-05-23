
--Task1_0523. 
--orders��� ���̺��� �����ϰ�, order_id, customer_id, order_date, amount, status��� �Ӽ��� �����ϼ���.
--�����͸� 5�� �Է��ϼ���.
--�Է��� ������ �� 2���� �����ϼ���.
--������ �����͸� ����ϱ� ���� �ѹ��� ����ϼ���.
--3���� ���ο� �����͸� �Է��ϰ�, �� �� ������ ������ �Է¸� ����� �� �������� Ŀ���ϼ���.

--------------     1. orders��� ���̺��� ����, order_id, customer_id, order_date, amount, status �Ӽ� ����
DROP TABLE ORDERS cascade constraints purge;
CREATE TABLE ORDERS(
    ORDER_ID NUMBER PRIMARY KEY,
    CUSTOMER_ID NUMBER,
    ORDER_DATE DATE,
    AMOUNT NUMBER,
    STATUS VARCHAR2(100)
);
--------------     2. ������ 5�� �Է�
INSERT INTO ORDERS VALUES(10001, 1, TO_DATE('2024-05-23 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7500, '�Ϸ�');
INSERT INTO ORDERS VALUES(10002, 2, TO_DATE('2024-05-23 10:01:00', 'YYYY-MM-DD HH24:MI:SS'), 12500, '�غ���');
INSERT INTO ORDERS VALUES(10003, 3, TO_DATE('2024-05-23 10:01:30', 'YYYY-MM-DD HH24:MI:SS'), 3500, '�غ���');
INSERT INTO ORDERS VALUES(10004, 4, TO_DATE('2024-05-23 10:02:30', 'YYYY-MM-DD HH24:MI:SS'), 6500, '�ֹ��Ϸ�');
INSERT INTO ORDERS VALUES(10005, 5, TO_DATE('2024-05-23 10:04:30', 'YYYY-MM-DD HH24:MI:SS'), 15500, '�ֹ��Ϸ�');

SELECT * FROM ORDERS;
SAVEPOINT SP1;

--------------     3. �Է��� ������ �� 2���� ����
UPDATE ORDERS SET STATUS='�غ���' WHERE ORDER_ID=10004;
UPDATE ORDERS SET STATUS='�غ���' WHERE ORDER_ID=10005;
SELECT * FROM ORDERS;

--------------     4. ������ �����͸� ����ϱ� ���� �ѹ� ���
ROLLBACK TO SP1;
SELECT * FROM ORDERS;

--------------     5. 3���� ���ο� ������ �Է�
INSERT INTO ORDERS VALUES(10006, 6, TO_DATE('2024-05-23 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 2500, '�ֹ��Ϸ�');
INSERT INTO ORDERS VALUES(10007, 7, TO_DATE('2024-05-23 10:06:00', 'YYYY-MM-DD HH24:MI:SS'), 7500, '�ֹ��Ϸ�');
SAVEPOINT SP2;
INSERT INTO ORDERS VALUES(10008, 1, TO_DATE('2024-05-23 10:08:20', 'YYYY-MM-DD HH24:MI:SS'), 20500,'�ֹ��Ϸ�');
SELECT * FROM ORDERS;
--------------     6. �� �� ������ ������ �Է¸� ���
ROLLBACK TO SP2;
SELECT * FROM ORDERS;
--------------     7. Ŀ��
COMMIT;