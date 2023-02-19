id <- c(101,201,301,401,501)
sex <- c('F','F','M','F','M')
height <- c(170,162,183,158,182) 
weight <- c(62,60,75,48,80) 
grade <- c("A+","B","A","C","B???") 
(A <- data.frame(ID=id,SEX=sex,HEI=height,WEI=weight,GRADE=grade))

A[,c(1,3,4)] # 프레임 A의 1, 3, 4 열 데이터 추출
A$GRADE # 프레임 A의 GRADE (변수)표시
A[-2] # 두 번째 열을 제외하고 데이터 추출
A[2:4,] # 프레임 A의 2~4번째 열 데이터 추출
A[2:4,3] # 2~4 번째 열 데이터 중 세 번째 열 추출

A[A$WEI >=65, ]

x <- 20 
if(x%%2 ==0) {
  print('x는 짝수입니다.')
} else {
  print('x는 홀수입니다.')
}

exam <- 30
if (exam >=90){
  print('성적은 A+입니다.')
} else if(exam >=80) {
  print('성적은 Ao입니다.')
} else if(exam >=70) {
  print('성적은 B+입니다.')
} else if(exam >=60) {
  print('성적은 Bo입니다.')
} else if(exam >=50) {
  print('성적은 C+입니다.')
} else {
  print('성적은 F입니다.')
}

for(i in 1:10){
  print(i)
}

sum <- 0
for(i in 1:10){
  sum <-sum + i
}
print(sum)

x <- 1
while(x <= 10){
  print(x)
  x <- x+1
}

x <- 1
sum <- 0
while(x <= 10){
  sum <-sum + x
  x <- x+1  
}
print(sum)

x <- 0
while(x <= 10){
  x <- x+1
  if(x==7)
    break
  print(x)
}

i <- 0
sum <- 0
while(i <= 9){
  i <- i+1
  if(i%%2==1){
    next
  }
  print(i)
  sum <-sum + i
}
print(sum)

df1<-data.frame(name = c('Park','Lee','Kim','Kang'), gender = c('f','m','f','m')) 
df2<-data.frame(name = c('Min','Ahn','Choi','Kyeon'), gender = c('m','m','f','f'))
df1
df2
rbind(df1,df2)

df1<-data.frame(name = c('Park','Lee','Kim','Kang'), gender = c('f','m','f','m')) 
df3<-data.frame(age = c(22,24,28,25), city = c('Seoul','Incheon','Seoul','Busan')) 
df1
df3
cbind(df1,df3)

df4<-data.frame(name = c('Yoon', 'Seo', 'Park', 'Lee', 'Kim', 'Kang'), age = c(30, 31, 22, 24, 28, 25)) 
df5<-data.frame(name = c('Park', 'Lee', 'Kim', 'Kang', 'Ahn', 'Go'), gender=c('f', 'f', 'm', 'm', 'f', 'm'), city = c('Seoul', 'Incheon', 'Seoul', 'Busan', 'Gwangju', 'Deagu')) 
df4
df5
merge(df4, df5, by='name', all=FALSE) #name을 기준으로 겹치는 데이터만 추출해 데이터를 결합

df4<-data.frame(name = c('Yoon', 'Seo', 'Park', 'Lee', 'Kim', 'Kang'), age = c(30, 31, 22, 24, 28, 25)) 
df5<-data.frame(name = c('Park', 'Lee', 'Kim', 'Kang', 'Ahn', 'Go'), gender=c('f', 'f', 'm', 'm', 'f', 'm'), city = c('Seoul', 'Incheon', 'Seoul', 'Busan', 'Gwangju', 'Deagu')) 
df4
df5
merge(df4, df5, by='name', all.x=TRUE) #name을 기준으로 df4의 값은 모두 나타냄, 없는 값은 <NA>로 나타냄

df4<-data.frame(name = c('Yoon', 'Seo', 'Park', 'Lee', 'Kim', 'Kang'), age = c(30, 31, 22, 24, 28, 25)) 
df5<-data.frame(name = c('Park', 'Lee', 'Kim', 'Kang', 'Ahn', 'Go'), gender=c('f', 'f', 'm', 'm', 'f', 'm'), city = c('Seoul', 'Incheon', 'Seoul', 'Busan', 'Gwangju', 'Deagu')) 
df4
df5
merge(df4, df5, by='name', all.y=TRUE) #name을 기준으로 df5의 값은 모두 나타냄, 없는 값은 <NA>로 나타냄

df4<-data.frame(name = c('Yoon', 'Seo', 'Park', 'Lee', 'Kim', 'Kang'), age = c(30, 31, 22, 24, 28, 25)) 
df5<-data.frame(name = c('Park', 'Lee', 'Kim', 'Kang', 'Ahn', 'Go'), gender=c('f', 'f', 'm', 'm', 'f', 'm'), city = c('Seoul', 'Incheon', 'Seoul', 'Busan', 'Gwangju', 'Deagu')) 
df4
df5
merge(df4, df5, by='name', all=TRUE) #name을 기준으로 df4, df5의 값은 모두 나타냄, 없는 값은 <NA>로 나타냄

setwd("C:/data") # 작업 폴더 지정, 이제 부터 이 폴더에서 데이터를 읽고 씀

install.packages("dplyr") # 패키지 설치

library(dplyr) # 패키지 불러오기

test <- read.csv("test.csv", header=TRUE) # 데이터 파일 읽기
test # 데이터 출력 해 보기
names(test) # 변수명 보기
# 새로운 변수 만들어 보기
test$total <- test$CLASS+test$KOREAN+test$ENGLISH+test$MATH+test$SCIENCE+test$MUSIC

# 등수 계산
test$rank <- rank(-test$total, ties.method="min") 

nrow(test) # 행의 수를 출력
(test$rank /nrow(test))
test

# filter : 행에 조건을 주고 조건에 만족하는 행만 추출
# 예: 7반 (CLASS==7)의 성적을 알고 싶다면

filter(test, CLASS == 7)

# 7반의 성적을 test_7이라는 변수에 넣고 싶다면
test_7 <- filter(test, CLASS == 7)

# 복잡한 조건을 주고 싶다면 AND OR ! 등을 이용하자.
# 한국어 점수가 50점 이하 (KOREANN <= 50) 이거나 (|) 영어 점수가 50점 이하 (ENGLISH <= 50) 인 학생은 누구?
filter(test, KOREAN <= 50 | ENGLISH <= 50)

# 한국어 점수가 50점 이상 (KOREANN >= 50) 이고 (&) 영어 점수가 50점 이상  (ENGLISH >= 50) 인 학생은 누구?
filter(test, KOREAN >= 50 & ENGLISH >= 50)

# 5반과 9반 학생의 점수를 알고 싶은 경우
filter(test, CLASS == 5 | CLASS ==9)

# 7반을 제외한 학생의 점수를 알고 싶은 경우
filter(test, CLASS == !7)

# %in% c()를 이용하여 목록 중 일치하는 경우 추출하기
# 2반, 4반, 7반, 9반의 성적을 알고 싶다면
filter(test, CLASS %in% c(2, 4, 7, 9))

# arrange() 함수를 이용한 정렬(sorting)
# CLASS 우선 기준, ID를 차선 기준으로 하여 정방향으로 정렬한 것이다. 
# 괄호 안에 첫 번째 인자로 데이터 프레임명을 지정하고, 
# 두 번째 인자로 가장 우선순위로 정렬할 변수 명을 지정하고 나머지는 차선 순위대로 지정하면 된다.
arrange(test, CLASS, ID, desc(KOREAN))

# select() 함수를 활용한 열 데이터 추출하기
select(test, KOREAN,ENGLISH,MATH)
select(test, KOREAN : MATH)
select(test, -MUSIC)

# pipe 이용하기, %>% 왼쪽 결과를 오른쪽에 넘겨주기
test %>% filter(MUSIC >= 95) %>% select(CLASS,ID)

# mutate() 함수를 활용한 파생변수 추가하기
test %>% mutate(TOTAL=KOREAN+ENGLISH+MATH+SCIENCE+MUSIC)

test %>% 
  mutate(TOTAL=KOREAN+ENGLISH+MATH+SCIENCE+MUSIC,MEAN=(KOREAN+ENGLISH+MATH+SCIENCE+MUSIC)/5) %>%
  head

# 한국어가 80점 이상이면 "P"로 아니면 "F"로 쓰기
test%>%
  mutate(result=ifelse(KOREAN >= 80, "P","F")) %>%
  head

# mutate() 함수를 활용하면 기존 데이터 열 맨 끝에 파생변수를 만들어 새로운 열을 추가할 수 있다
test %>%
  mutate(TOTAL=KOREAN+ENGLISH+MATH+SCIENCE+MUSIC)

test%>%
  mutate(TOTAL=KOREAN+ENGLISH+MATH+SCIENCE+MUSIC,
         MEAN=(KOREAN+ENGLISH+MATH+SCIENCE+MUSIC)/5) %>%
  head

# mutate() 함수를 ifelse() 와 같은 조건문과 함께 사용하여 조건에 따라 다른 값을 부여한 변수를 추가할 수 있다. 
test%>%
  mutate(result=ifelse(KOREAN >= 80, "P","F"))%>%
  head

# group_by(범주형_변수명) 함수는 범주형 변수에 따라 데이터를 여러 개로 분할한다.
# 주로 집단별로 나눈다면 집단 별 특징을 요약하기 위해 사용하며 요약을 위해서는 summarise( ) 함수가 사용된다. 
test %>% 
  group_by(CLASS) %>%
  summarise(C_mean_K_ = mean(KOREAN))

# 평균을 구해보자.
test %>% summarise(mean_K = mean(KOREAN))

# 반별로 국어 점수 평균, 중앙값,  표준편차, 학생수를 요약하기
# ~별이라는 단어가 나오면 group_by( )를 사용

test %>% 
  group_by(CLASS) %>%
  summarise(
    C_mean_K_ = mean(KOREAN),
    C_med_K = median(KOREAN),
    C_sd_K = sd(KOREAN),
    C_student = n()
  )

# 한국어, 영어, 수학 과목의 점수 평균을 계산하고 점수별로 정렬해보자.
test %>%
  group_by(ID, CLASS) %>%
  summarise(mean_KEM = mean(KOREAN,ENGLISH,MATH)) %>%
  arrange(mean_KEM)

# 위의 결과를 mean_KEM이라는 변수에 넣고 이를 "mean_KEM.csv"에 저장해 보자.
mean_KEM <- test %>%
  group_by(ID, CLASS) %>%
  summarise(mean_KEM = mean(KOREAN,ENGLISH,MATH)) %>%
  arrange(mean_KEM)

write.csv(mean_KEM, "mean_KEM.csv")