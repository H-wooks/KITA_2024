• 공부할 것 : numpy/pandas/크롤링/시각화/수학적 background (통계, 선형 대수)

---------- 5/27 -------
• 버전 명시 설치 : conda create –n 가상환경명 python=3.10
• 가상환경 시작 :activate 가상환경명
• Jupyter notebook 설치 : conda install jupyter notebook
• 패키지 설치 : conda install numpy pandas matplotlib seaborn scipy scikit-learn tensorflow keras


• Database와 연결해서 파이썬 사용하기 
- con=cx_Oracle.connect("c##hr","hr","localhost:1521/xe")
- cur=con.cursor()
- cur.execute('select * from EMPLOYEES')
- res=cur.fetchall()
- df=pd.DataFrame(res)
- cur.execute("select column_name from user_tab_columns where table_name='EMPLOYEES'")
- col=cur.fetchall()
- li = []
- for i in col:
-    #print(i)
-    for j in i:
-        #print(j)
-        li.append(j)
- df.columns =li
- print(df.head())
- cur.close()
- con.close()
- df.describe()          ## 통계 요약본을 보여주는 함수

- df.SALARY.plot(kind='hist')
 
