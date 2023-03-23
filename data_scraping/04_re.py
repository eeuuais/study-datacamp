# 정규식 연습
# ca?e --> 문자열의 일부분이 기억나지 않을 때

import re

# 1. p = re.compile("원하는 형태")
"""
    .(ca.e) : 하나의 문자를 의미 > care(O) caffe(X)
    ^(^de) : 문자열의 시작 > desk, destination(O) fade(X)
    $(se$) : 문자열의 끝 > case, base(O) face(X)
"""
p = re.compile("ca.e")




# 2. m = p.match("비교할 문자열") : 주어진 문자열의 처음부터 일치하는 지 확인
# 첫번째 방법
m = p.match("caffe")
print(m.group()) # 매칭이 안되면 에러 발생

# 두번째 방법
def print_match(m):
    if m:
        print("m.group():", m.group()) # 일치하는 문자열 반환
        print("m.string:", m.string) # 입력받은 문자열
        print("m.start() :", m.start()) # 일치하는 문자열의 시작 index
        print("m.end() :", m.end()) # 일치하는 문자열의 끝 index
        print("m.span():", m.span()) # 일치하는 문자열의 시작 / 끝 index
    else:
        print("매칭되지 않음")

m = p.match("careless") # match : 주어진 문자열의 처음부터 일치하는지 확인
print_match(m)
# print(m.group())




# 3. search("비교할 문자열") : 주어진 문자열 중에 일치하는 게 있는지 확인
m = p.search("good care")
print_match(m)




# 4. findall("비교할 문자열") : 일치하는 모든 것을 "리스트" 형태로 반환
lst  = p.findall("good care cafe")
print(lst)