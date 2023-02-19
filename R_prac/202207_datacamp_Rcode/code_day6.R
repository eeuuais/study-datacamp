setwd("N:/. Personal_folder/내 문서/강의/세미나/서울과기대/")

######## 사전 준비
# 1. 주제
# 2. 관련연구 찾기 및 설문 추출
# 3. 설문 배포 및 회수
# 4. 탐색적 요인분석 & 신뢰도 분석 : 숨겨진 구조 탐색
# 5. 확인적 요인분석
# 6. 구조방정식 모형 분석

################# 탐색적 요인분석 & 신뢰도 분석
if(!require("readxl")){install.packages("readxl"); library(readxl)}

data <- read_excel("car_data.xlsx")
str(data)

if(!require("psych")){install.packages("psych"); library(psych)}
if(!require("dplyr")){install.packages("dplyr"); library(dplyr)}
if(!require("GPArotation")){install.packages("GPArotation"); library(GPArotation)}
if(!require("Hmisc")){install.packages("Hmisc"); library(Hmisc)}
if(!require("ltm")){install.packages("ltm"); library(ltm)}

factor_data <- principal(data, rotate='none')
str(factor_data)

# Eigen value : 하나의 고유값이 설명하는 변수의 수, 보통 1이상이 중요
factor_data$values
# 총 4개의 고유근이 1을 넘음 -> 요인이 4개 정도 있을 가능성이 높음

factor_data_varimax <- principal(data, nfactor=5, rotate='varimax')
factor_data_varimax

# h2는 communality(공통성)을 나타냄 0.4 이상 권장
# RC1~RC3은 요인부하량(Factor Loading)
# SS Loading은 요인이 설명하는 분산의 양
# Proportion Var는 각 요인이 설명하는변동비율 약 79% 설명

# Bartlett’s Test of Sphericity
# Ho: 상관행렬이 아이덴티티 행렬이다. 변수간 상관관계가 없다.
# H1: 상관행렬이 아이덴티티 행렬이 아니다. 변수간 상관관계가 있다.
# 곧 일부 변수들은 요인으로 묶일 가능성이 있다.
cortest.bartlett(cor(data), nrow(data))

# Kaiser-Meyer-Olkin's Measure of Sampling Adequacy, KMO's MSA
rcorr(as.matrix(data))
rcorr(as.matrix(data))$r
KMO(rcorr(as.matrix(data))$r) # KMO's MSA 0.92

# Cronbach's alpha
data[, 1:3] %>% cronbach.alpha() # raw_alpha 0.910
data[, 4:6] %>% cronbach.alpha() # raw_alpha 0.929
data[, 7:9] %>% cronbach.alpha() # raw_alpha 0.897
data[, 10:12] %>% cronbach.alpha() # raw_alpha 0.887
data[, 13:15] %>% cronbach.alpha() # raw_alpha 0.879

################# 확인적 요인분석

if(!require(lavaan)){install.packages("lavaan"); library(lavaan)}

CFA_model <- '자동차이미지 =~ 디자인 + 각종기능 + 승차감
브랜드이미지 =~ 유명한차 + 독일차 +고급차
사회적지위 =~ 사회인정 + ceo + 소수공유
만족도 =~  만족1+ 만족2 + 만족3
재구매 =~ 재구매1 + 재구매2 + 재구매3'
CFA_fit <- cfa(CFA_model, data =data)
summary(CFA_fit, standardized = TRUE, fit.measure=TRUE)

if(!require(semPlot)){install.packages("semPlot"); library(semPlot)}

diagram<-semPlot::semPaths(CFA_fit,
                           whatLabels="std", intercepts=FALSE, style="lisrel",
                           nCharNodes=0, 
                           nCharEdges=0,
                           curveAdjacent = TRUE,title=TRUE, layout="tree2", curvePivot=TRUE)

################# 구조방정식 모형 분석

SEM_model <- '자동차이미지 =~ 디자인 + 각종기능 + 승차감
브랜드이미지 =~ 유명한차 + 독일차 +고급차
사회적지위 =~ 사회인정 + ceo + 소수공유
만족도 =~  만족1+ 만족2 + 만족3
재구매 =~ 재구매1 + 재구매2 + 재구매3
만족도 ~ 자동차이미지 + 브랜드이미지 + 사회적지위
재구매 ~ 만족도'
SEM_fit <- sem(SEM_model, data =data)
summary(SEM_fit, standardized = TRUE, fit.measures=TRUE)

######## 수정모형 찾기
mi <- modindices(SEM_fit)
mi[mi$op =="~",]

# 수정모델 코드
SEM_model2 <- '자동차이미지 =~ 디자인 + 각종기능 + 승차감
브랜드이미지 =~ 유명한차 + 독일차 +고급차
사회적지위 =~ 사회인정 + ceo + 소수공유
만족도 =~  만족1+ 만족2 + 만족3
재구매 =~ 재구매1 + 재구매2 + 재구매3
만족도 ~ 자동차이미지 + 브랜드이미지 + 사회적지위
재구매 ~ 만족도 + 브랜드이미지'
SEM_fit2 <- sem(SEM_model2, data =data)
summary(SEM_fit2, standardized = TRUE, fit.measures=TRUE)

# 수정모델과 초기 모델의 차이를 통계적으로 검정
# Ho: 모델간 차이는 없다.
# H1: 모델간 차이는 있다. 
# p-value는 
1-pchisq(156.109-131.542, df=1)
# 차이가 있음

######## 주요 통계량 만들기
fitMeasures(SEM_fit2) # 모형적합도 보기
parameterEstimates(SEM_fit2) # Unstandardized Estimates (비표준화계수 보기)
standardizedSolution(SEM_fit2) # Standardized Estimates (표준화계수 보기)

# 표준화 계수 표시 그림
diagram<-semPlot::semPaths(SEM_fit2, whatLabels = "std", fade=F, edge.label.cex = 1, edge.color = "black")

# 비표준화 계수 표시 그림
diagram<-semPlot::semPaths(SEM_fit2, whatLabels = "est", fade=F, edge.label.cex = 1, edge.color = "black")