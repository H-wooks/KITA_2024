import pandas as pd
from sqlalchemy import create_engine

# MySQL 연결 설정
engine = create_engine('mysql+pymysql://hwooks2:hwooks2@localhost:3306/movies_db')

# CSV 파일 로드
ratings = pd.read_csv('ratings.csv')
movies = pd.read_csv('movies.csv')

# 데이터베이스에 테이블로 저장
ratings.to_sql('ratings', con=engine, if_exists='replace', index=False)
movies.to_sql('movies', con=engine, if_exists='replace', index=False)
