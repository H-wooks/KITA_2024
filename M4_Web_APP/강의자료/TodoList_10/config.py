import os

# 현재 파일의 절대 경로를 기반으로 basedir 변수를 설정 이 변수는 포로젝트 기본 디렉토리를 나타낸다.
# os.path.abspath(path): 주어진 경로 path의 절대 경로를 반환
# __file__의 디렉토리 부분만을 추출, D:\kdt_240424\workspace\M4_Web_App\TodoList_10
basedir=os.path.abspath(os.path.dirname(__file__))
# Flask configuration
# 세션 데이터 암호화, CSRF 보호 등을 위해 사용

class Config:
    SECRET_KEY = '9ec5baed759580e8747e1bcfe5cb83a05365fcdd075ab89f'
    #SQLALCHEMY_DATABASE_URI = 'sqlite:///tasks.db'
    SQLALCHEMY_DATABASE_URI='mysql+pymysql://hwooks:hwooks@localhost:3306/hwooks_db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    UPLOADED_FILES_DEST = os.path.join(basedir, "uploads")


## os.path.join(basedir, "uploads")
## os.path.join함수는 여러 경로 요소를 하나의 경로로 결합
## 파일 업로드 시 저장할 기본 경로를 설정
## D:\kdt_240424\workspace\M4_Web_App\TodoList_10\uploads
