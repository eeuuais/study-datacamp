# selenium 연습

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

options = Options()
options.add_experimental_option("detach", True)
service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service, options=options)

# 1. 네이버 이동
browser = webdriver.Chrome("./chromedriver.exe")
browser.get("http:/naver.com")

# 2. 로그인 버튼 클릭
"""<a href="https://nid.naver.com/nidlogin.login?mode=form&amp;url=https%3A%2F%2Fwww.naver.com" class="link_login" data-clk="log_off.login"><i class="ico_naver"><span class="blind">네이버</span></i>로그인</a>"""

driver.find_element(By.ID, "link_login").click()

# 3. id, pw 입력
driver.find_element(By.ID, "id").send_keys("naver_id")
driver.find_element(By.ID, "pw").send_keys("naver_pw")

# 4. 로그인 버튼 클릭
driver.find_element(By.ID, "id").send_keys("log.login").click()