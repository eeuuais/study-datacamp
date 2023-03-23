# 네이버 웹툰

import requests
from bs4 import BeautifulSoup

url = "https://comic.naver.com/webtoon/list?titleId=799793"
res = requests.get(url)
res.raise_for_status()

soup = BeautifulSoup(res.text, "lxml")
cartoons = soup.find_all("td", attrs={"class":"title"})


# # 연습
# title = cartoons[0].a.get_text()
# link = cartoons[0].a["href"]
# print(title)
# print("https://comic.naver.com" + link)


# 만화제목과 링크 가져오기
# for cartoon in cartoons:
#     title = cartoon.a.get_text()
#     link = "https://comic.naver.com" + cartoon.a["href"] #href 속성에 해당하는 것만 가져옴
#     print(title, link)


# # 평점 구하기
# total_rates = 0
# cartoons = soup.find_all("div", attrs={"class":"rating_type"})

# for cartoon in cartoons:
#     rate = cartoon.find("strong").get_text()
#     print(rate)
#     total_rates += float(rate) #가져온 평점이 string일 것이므로 실수형 변수로 바꿔줘서 total_rates에 더해지도록
# print("전체 점수: ", total_rates)
# print("평균 점수: ", total_rates / len(cartoons))