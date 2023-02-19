###############################################################################
########                    요인분석과 신뢰도 분석                     ########
###############################################################################

if(!require("psych")){install.packages("psych"); library(psych)}
if(!require("dplyr")){install.packages("dplyr"); library(dplyr)}
if(!require("GPArotation")){install.packages("GPArotation"); library(GPArotation)}
if(!require("Hmisc")){install.packages("Hmisc"); library(Hmisc)}
if(!require("ltm")){install.packages("ltm"); library(ltm)}

str(state.x77)

# Population: 추정인구
# Income: 1인당 소득 
# Illiteracy: 문맹률
# Life Exp: 기대수명
# Murder: 10만명당 살인률
# HS Grad: 고등학교 졸업비율
# Frost: 기온이 0도 이하인 날짜 수
# Area: 지역의 크기

factor_state <- principal(state.x77, rotate='none')
str(factor_state)

# Eigen value : 하나의 고유값이 설명하는 변수의 수, 보통 1이상이 중요
factor_state$values
# 총 3개의 고유근이 1을 넘음 -> 요인이 3개 정도 있을 가능성이 높음

# RC1은 Life Exp, Illiteracy, Murder, HS Grad를 대표하는 요인
# RC2는 Area, Income, HS Grad를 대표하는 요인
# RC3은 Population, Frost를 대표하는 요인

factor_state_varimax <- principal(state.x77, nfactor=3, rotate='varimax')
factor_state_varimax

# h2는 communality(공통성)을 나타냄 0.4 이상 권장
# RC1~RC3은 요인부하량(Factor Loading)
# SS Loading은 요인이 설명하는 분산의 양
# Proportion Var는 각 요인이 설명하는변동비율 약 79% 설명

# Bartlett’s Test of Sphericity
# Ho: 상관행렬이 아이덴티티 행렬이다. 변수간 상관관계가 없다.
# H1: 상관행렬이 아이덴티티 행렬이 아니다. 변수간 상관관계가 있다.
# 곧 일부 변수들은 요인으로 묶일 가능성이 있다.
cortest.bartlett(cor(state.x77), nrow(state.x77))

# Kaiser-Meyer-Olkin's Measure of Sampling Adequacy, KMO's MSA
rcorr(as.matrix(state.x77))
rcorr(as.matrix(state.x77))$r
KMO(rcorr(as.matrix(state.x77))$r) # KMO's MSA 0.66

# Cronbach's alpha
state.x77[, 3:6] %>% cronbach.alpha() # raw_alpha 0.72