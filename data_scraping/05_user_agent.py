import requests

url = "http://nadocoding.tistory.com"

#헤더 정보를 주기 전에는 티스토리에서 막았었는데 우리가 user-agent를 넣어줌으로써 실제로 크롬에서 접속했을 때와 동일한 결과를 받아오는 것을 알 수 있다

# https://www.whatismybrowser.com/detect/what-is-my-user-agent/
headers = {"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36"}

res = requests.get(url, headers=headers)
res.raise_for_status()


with open("nadocoding.html", "w", encoding='utf-8') as f:
    f.write(res.text)
