import pymysql

connection = pymysql.connect(
    host='localhost',
    user='hwooks2',
    password='hwooks2',
    database='movies_db'
)

try:
    with connection.cursor() as cursor:
        cursor.execute('SELECT 1')
        result = cursor.fetchone()
        print(result)
finally:
    connection.close()