#구글 문서에 글자 몇개가 있는지 확인
import requests
res = requests.get("http://www.google.com")
print(len(res.text))
print(res.text)

# 터미널에서 보기가 어려우니까 파일로 만들어보기
with open("mygoogle.html", "w", encoding='utf-8') as f:
    f.write(res.text)



#웹 스크래핑을 진행하기 전 사이트 점검 (응답코드 200 : 정상 / 404 : 접근권한없음)
import requests
res = requests.get("http://www.google.com")

#정상적으로 접근되는지 응답코드 찍기
print("응답코드: ", res.status_code)


# 첫번째 방법
if res.status_code == requests.codes.ok:
    print("정상입니다")
else:
    print("문제가 생겼습니다. [에러코드 ", res.status_code, "]")


    

# 두번째 방법 : 문제가 생기면 바로 오류를 내뱉고 프로그램을 끝낼 수 있게 해준다
res.raise_for_status()
print("웹 스크래핑을 진행합니다")