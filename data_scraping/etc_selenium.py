# 1. 셀레니움 설치 pip install selenium
# 2. 웹 드라이버 설치(chrome) : chrome버전 확인하기 chrome://version/

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import time

options = Options()
options.add_experimental_option("detach", True)
service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service, options=options)

url = "http://www.naver.com"

driver.get(url)
time.sleep(1)

"""
<input id="query" name="query" type="search" title="검색어 입력" maxlength="255" class="input_text" tabindex="1" accesskey="s" style="ime-mode:active;" autocomplete="off" placeholder="검색어를 입력해 주세요." onclick="document.getElementById('fbm').value=1;" value="" data-atcmp-element="">
"""

# #검색창에 입력
# driver.find_element(By.CLASS_NAME, "input_text").send_keys("블랙핑크")
# time.sleep(1)

# driver.find_element(By.ID, "query").send_keys("뉴진스")
# time.sleep(1)

# driver.find_element(By.NAME, "query").send_keys("트와이스")
# time.sleep(1)

# driver.find_element(By.CSS_SELECTOR, "[title='검색어 입력']").send_keys("에스파")
# time.sleep(1)

# # copy Xpath

# driver.find_element(By.XPATH, '//*[@id="query"]').send_keys("에스파")
# time.sleep(1)

# 클릭해보기
# driver.find_element(By.LINK_TEXT, "쇼핑LIVE").click()

# link text의 일부분이 일치했을 때도 사용가능함
# driver.find_element(By.PARTIAL_LINK_TEXT, "핑LIVE").click() 

# TAG NAME 찾기 : 정말 단독으로 쓰일만 한 태그 찾을 때 사용 (div 이런것이 많기 때문) --> 사용빈도 낮음
# driver.find_element(By.TAG_NAME, "").click() 