## 2024 4 24 (Wed.) M1_DataBase ==> M2_Python (due to 결석자..)
## Python EX. 구글 드라이브내 00_KITA_2404_M2_program에 기초테스트_최환욱으로 저장, 1_자료형.ipynb에 요점 저장
  - 기초 테스트의 문제들 다시 한번 복습해봐
  - PD, Numpy, SchiPy...
  - Scikit-learn: 머신러닝을 위한 프레임워크
  - 텐서플로와 파이토치: 딥러닝을 위한 프레임워크 quick review 해봐~
  - 케라스도 한번 quick review 필요
  - gradio와 위의 library들 quick review 해봐~
  - Django, Flask.. 좀더 lite한 웹... 프레임 개발 솔루션
  - Hugging face: Llama, Solar... 여러 open source들이 올라와 있으니 나중에 참고해봐야..
     https://huggingface.co/
  - solar (SLM)의 업스테이지 홈페이지 : https://www.upstage.ai/
     솔라 논문 요약 리뷰: https://dajeblog.co.kr/%EB%85%BC%EB%AC%B8-%EB%A6%AC%EB%B7%B0-solar-10-7b-scaling-large-language-models-with-simple-yet-effective-depth-up-scaling/
    Main theme: Depth Up-Scaling (DUS)
  - 식별자, 키워드 들에 대한 설명은 1_자료형.ipynb 참고.
    
## List [] vs. Tuple () 차이점 정리
  - 리스트의 경우에는 append와 remove 등과 같이 내부 항목을 추가하거나 제거 가능
  - 반면, 튜플은 변경, 추가, 삭제를 할 수 없다. count나 index와 같은 내부적으로 조사를 하는 함수만 사용 가능함, 동일한 항목을 그대로 가져와 새로운 리스트에 대입을 한다거나 튜플을 리스트화, 혹은 튜플을 리스트로 변환을 시켜서 새로운 메모리에 할당
  - List 관련 함수: append(), sort(), sorted(), reverse(), len(), insert(), remove(), pop(), del(), count(), extend(), 
## Python Class 공부 & 정리
  - 데이터와 함수를 정의해서 새로운 데이터 타입의 정의; 클래스란 변수와 메소드로 구성된 새로운 데이터 타입
![image](https://github.com/hwooks96/KITA_2024/assets/167948347/4c6fd718-6167-486d-ba41-b20b08fda9b5)
![image](https://github.com/hwooks96/KITA_2024/assets/167948347/dee36dfa-4625-4d6e-b418-a849e1d4d243)

  - 함수와 메소드의 차이:
    메소드는 특정 객체에 종속되어 적용 호출 (클래스 내에 정의된 함수) 되고, 함수는 어떠한 객체와 무관하게 적용 호출 (독립적인 코드)
  - sort() method와 sorted() function 차이: sort() method는 반환 X, 변환O only for List to List vs. sorted() function는 반환 O, 변환 X , not only for List but for everything, to List
  - colab에서 !pip install fastai 이렇게 설치해보면 설치된 경로가 나오게 된다. /user/local/lib/python3.10/~에 있어
  - 설치되어 있는 것들은 import xx , 혹은 import xx simple로 불러서 쓰기만 하면 된다.

## 5.1 AI 엑스포 코리아 참관: 참관 신청 완료

## ASCII code(미국 정보 교환 표준 부호): 영문기준 문자나 character의 mapping table
![image](https://github.com/hwooks96/KITA_2024/assets/167948347/43e066a8-1811-459a-b91b-21df74540b64)
-https://namu.wiki/w/%EC%95%84%EC%8A%A4%ED%82%A4%20%EC%BD%94%EB%93%9C 참고
- 한국(한글)의 경우 UTF-8로 사용...

## 변수명,함수명,클래스명 정할 때 규칙을 확실히 하자.. 
- 카멜(Camel) 표기: 두번째 단어부터 첫글자 대문자로 작성, 파스칼(Pascal) 표기: 단어 첫 글자 마다 대문자로 작성, 팟홀(Pothole) 표기: 단어마다 '_'를 넣어 표기
- 카멜: myNameIsHwook, 파스칼: MyNameIsHwook, 팟홀: my_name_is_apple
- **앞으로 함수명, 클래스명은 파스칼 타입 (MyNameIsHwook)으로, 그 외 변수들은 팟홀 타입 (my_name_is_apple)으로...**
-
