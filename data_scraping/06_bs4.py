#네이버 웹툰 스크래핑

import requests
from bs4 import BeautifulSoup

#pip install lxml : 구문을 분석하는 passer


url = "https://comic.naver.com/webtoon/weekday"
res = requests.get(url)
res.raise_for_status()

# soup : 가져온 html문서를 lxml 파서를 통해 Beautifulsoup객체로 만든 것. 모든 정보를 담고있다
soup = BeautifulSoup(res.text, "lxml")





# # <대상페이지에 대해 잘 알 때>
# print(soup.title)
# print(soup.title.get_text())
# print(soup.a) # soup 객체는 모든 정보를 가지고 있는데, 그 중에서 첫번째로 발견되는 a 태그에 대한 정보를 뿌려줘

# print(soup.a.attrs) # a element의 속성정보를 출력
# print(soup.a["href"]) # a element의 href 속성 '값' 정보를 출력





# <대상페이지에 대해 잘 모를 때>
"""
해당하는 첫 번째 엘리먼트를 가져오는데 조건을 줄 수 있다. 
= class속성 값이 nbn_upload인 a element를 찾아줘
"a"인지 "div"인지 명시를 해주면 더 명확히 찾을 수 있다.
"""

# print(soup.find("a", attrs={"class":"Nbtn_upload"})) 

# print(soup.find(attrs={"class":"Nbtn_upload"})) #class속성 값이 nbn_upload인 어떤 element를 찾아줘

# print(soup.find("li", attr={"class":"rank01"}))

# rank1 = soup.find("li", attrs={"class":"rank01"})
# print(rank1.a)
# print(rank1.a.get_text())
# rank2 = rank1.next_sibling.next_sibling # 개행정보가 있었을 경우 두번 써주면 된다

# rank3 = rank1.next_sibling.next_sibling
# print(rank3.a.get_text())

# rank2 = rank3.previous_sibling.previous_sibling
# print(rank2.a.get_text())

# print(rank1.parent)

# rank2 = rank1.find_next_sibling("li") # 조건에 해당하는 것만 찾아간다
# print(rank2.a.get_text())

# rank3 = rank2.find_next_sibling("li")
# print(rank3.a.get_text())

# rank2 = rank3.find_previous_sibling("li")
# print(rank2.a.get_text())

# print(rank1.find_next_siblings("li"))


# webtoon = soup.find("a", text="한림체육관-시즌2 9화")
# print(webtoon)