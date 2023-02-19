# -*- coding: utf-8 -*-
"""
Created on Thu Jul 28 14:02:40 2022

@author: Hyo-J
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
os.chdir('E:/2207 SEOULTECH/')

#########################################################################
#데이터 크롤링
#########################################################################

# !pip install selenium
from selenium import webdriver
from bs4 import BeautifulSoup

# 셀레니움을 이용해서 원하는 페이지 접근
driver = webdriver.Edge('C:/Users/Hyo-J/Downloads/edgedriver_win64/msedgedriver.exe') #웹드라이버 로딩
driver.get('https://play.google.com/store/apps/details?id=com.sampleapp&showAllReviews=true') #웹페이지 열기
show_all = driver.find_element_by_xpath('/html/body/c-wiz[2]/div/div/div[1]/div[2]/div/div[1]/c-wiz[4]/section/div/div/div[5]/div/div/button/span') #See all reviews 버튼 찾기
show_all.click() # See all reviews 버튼 클릭

# 뷰티플스프를 이용해서 원하는 데이터 추
soup = BeautifulSoup(driver.page_source, 'html.parser') #현재 페이지 html소스
reviews_lst = soup.select('div.h3YV2d') #리뷰 선택
date_lst = soup.select('span.bp9Aid') #날짜 선택
reply_lst = soup.select('div.ras4vb') #댓글 선택
reviews = [r.text for r in reviews_lst] #리뷰 테그 때어내기
from datetime import datetime
dates = [datetime.strptime(d.text, '%B %d, %Y') for d in date_lst] #테그 띠고 날짜형식으로 변환
years = [d.year for d in dates] #년도만 추출
replies = [r.text for r in reply_lst] #댓글 테그 때어내기

#추출된 데이터로 데이터 프레임 생성
len(reviews), len(dates), len(replies) #데이터프레임 만들기전 갯수 체크
df = pd.DataFrame({'review': reviews,
              'year': years,
              'reply': replies})

##########################################################################
#데이터 분석
##########################################################################

#년도별 리뷰갯수 카운트
cnt_tab = df.groupby('year').count()['review'] 
cnt_tab.columns=['리뷰수']
cnt_tab

from matplotlib import font_manager, rc
font_name = font_manager.FontProperties(fname="c:/Windows/Fonts/malgun.ttf").get_name()
rc('font', family=font_name)

#년도별 리뷰갯수 시각화
sns.barplot(x=cnt_tab.index, y=cnt_tab)
plt.title('연도별 리뷰수')
plt.show()

#년도별 데이터 프레임 생성
df_2018 = df[df.year==2018]
df_2019 = df[df.year==2019]
df_2020 = df[df.year==2020]
df_2021 = df[df.year==2021]
df_2022 = df[df.year==2022]

#년도별 워드크라우드
from wordcloud import WordCloud, STOPWORDS
def draw_wordcloud(review, filename):
    text = ' '.join(review) #리뷰를 붙여서 하나의 텍스트로 만듬
    wordcloud = WordCloud(font_path = 'c:/Windows/Fonts/malgun.ttf').generate(text)
    fig=plt.figure(figsize=(10,10))
    plt.imshow(wordcloud)
    plt.axis("off")
    plt.show()
    wordcloud.to_file("{}.png".format(filename)) #글자타입으로 바꾼후 .으로 나눠서 앞부분 (에를 들어 df_2018)으로 파일이름 생성해서 저장

draw_wordcloud(df_2018.review, 'wordcloud_2018')
draw_wordcloud(df_2019.review, 'wordcloud_2019')
draw_wordcloud(df_2020.review, 'wordcloud_2020')
draw_wordcloud(df_2021.review, 'wordcloud_2021')
draw_wordcloud(df_2022.review, 'wordcloud_2022')

#년도별 단어빈도표
from nltk.tokenize import word_tokenize
from nltk.probability import FreqDist

#전처리 한꺼번에 하기
import re
import string
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
stop_words = set(stopwords.words("english"))
ps = PorterStemmer()
def clean_text(text):
    text = "".join([char.lower() for char in text if char not in string.punctuation])
    tokens = re.split('\W+', text)
    word = [ps.stem(word) for word in tokens if word not in stop_words]
    return word

def word_frequency(review, filename):
    text = ' '.join(df_2018.review) #리뷰 하나로 붙이기
    words = clean_text(text) #전처리
    fdist = FreqDist(words) #빈도
    freq_tab = pd.DataFrame({'word': fdist.keys(),
                             'freq': fdist.values()}) #빈도표
    freq_tab = freq_tab.sort_values('freq', ascending=False)[:20] #정렬후 상위 20개 단어
    freq_tab.to_csv('{}.csv'.format(filename)) #저장
    fdist.plot(20) #빈도 그래프
    plt.show()

word_frequency(df_2018.review, 'wf_2018')
word_frequency(df_2019.review, 'wf_2019')
word_frequency(df_2020.review, 'wf_2020')
word_frequency(df_2021.review, 'wf_2021')
word_frequency(df_2022.review, 'wf_2022')