

python, live server... install
python 가상환경 설정

python --version

가상환경 생성 :
cd my_project
python -m venv myenv
==> 
C:\Users\Administrator\AppData\Local\Programs\Python\Python310\python.exe -m venv myenv

가상환경 활성화:
myenv\Scripts\activate

pip install jupyter notebook pandas numpy scikit-learn matplotlib seaborn


패키지 설치 및 관리:
pip install requests

가상환경 비활성화:
deactivate

가상환경에 설치된 모든 패키지 목록을 requirements.txt 파일로 저장
pip freeze > requirements.txt

requirements.txt 파일을 사용하여 패키지 설치
pip install -r requirements.txt

Python의 패키지 관리자인 pip을 최신 버전으로 업그레이드하는 명령어
python.exe -m pip install --upgrade pip


Live Server Port 이슈
포트 사용 중인 프로세스 확인:
netstat -aon | findstr :5500
프로세스 종료: 죽여야...
taskkill /PID 1234 /F
==> taskkill /PID xxxx /F 


window Key + --> 치면 화면 분할
<body>
    "Hello World!" 이렇게 typing하고 저장하면 127.0.0.1:5500/basic.html에 그대로 출력


    #### 사용
    View/command palette click
    중앙 창에서 python: Select Interpreter에서 내 가상환경 click + new terminal

    새로 만들기에서 XXX.ipynb 하던지 xx.html을 하면 되고 
    html에서는 !tab을 치면 source code로 들어가고 
    여기서 마우스 오른쪽 클릭해서 "Open with Live Server" 하면 html 출력 창 나온다..
    여기서 이원화 split 창 만들어서 작업하면서 보고 싶으면 window key + 오른쪽 방향키 누르면 된다.


웹문서에서 F12 누르면 소스 코드 볼 수 있음
