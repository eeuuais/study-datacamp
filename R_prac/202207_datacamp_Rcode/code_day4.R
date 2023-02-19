###############################################################################
########                        로지스틱 회귀분석                      ########
###############################################################################

##################이항로지스틱 분석
# 이항 로지스틱 분석은 종속변수의 범주가 2개인 경우임
# 종속변수 범주를 두개만 추출합시다.
data(iris)
a <- iris %>%
  filter(Species == "setosa" | Species == "versicolor")

# 로지스틱회귀분석에서는 종속변수가 범주형이어야 함
a$Species <- factor(a$Species)
str(a) # Species 가 각각 setosa와 versicolor가 됨

b <- glm(Species~Sepal.Length, data=a, family = binomial)
summary(b) # 로지스틱 회귀분석 결과

coef(b) # 로지스틱 회귀계수만 setosa 대비 versicolor 추정
exp(coef(b)["Sepal.Length"]) 

exp(confint(b, parm = "Sepal.Length"))
fitted(b)[c(1:5,96:100)]

# P(Y=2) / 1 - P(Y=2) = exp(-28.831 + 5.140X)

################## 다중 로지스틱(여러 독립변수, 이항 종속변수) 분석 예

glm.vs <- glm(vs~mpg+am, data=mtcars, family=binomial)
str(glm.vs)
# 결과 확인
summary(glm.vs)

# 로지스틱 모형 적합도 검정 : 카이제곱검정
# Null Deviance(회귀식에서 절편항만 가지는 모형(null 모형)의 이탈도)에 대한 
# 로지스틱회귀모형의 Residual(오차) 감소가 통계적으로 
# 유의하면 제안된 모형이 영 모형에 비해 좋은 적합도를 가지고 있음을 의미
with(glm.vs, pchisq(null.deviance - deviance, 
                    df.null - df.residual, lower.tail = FALSE)) 
# 9.102985e-06 < 0.05
# 따라서 절편 모형보다 회귀모형이 훨씬 좋음

# 범주를 예측해 봅시다.
glm.predict <- predict(glm.vs, data=mtcars, type="response")

# 예측 값이 0.5보다 크면 1로, 작으면 0으로 예측
glm.predict <- ifelse(glm.predict>0.5, 1, 0)

# 범주별 분류로 예측이 정확한지 봅시다.
table(actual=mtcars$vs, predicted=glm.predict)

# 예측성능을 caret 패키지로 알아봅시다.
confusionMatrix(as.factor(glm.predict), as.factor(mtcars$vs))

##################  다항로지스틱(여러 독립변수, 다항 종속변수) 분석
if(!require("nnet")){install.packages("nnet"); library(nnet)}
if(!require("caret")){install.packages("caret"); library(caret)}
if(!require("e1071")){install.packages("e1071"); library(e1071)}

# 다항 로지스틱 회귀 분석(Multinomial Logistic Regression) 은 multinom 함수를 사용
multi.result <- multinom(Species~., data=iris)
summary(multi.result)
str(multi.result)
# 기준은 결과에서 제시되지 않은 범주인 setasa임
# logit("versicolor에")=log(P(Y="versicolor에")/P(Y="setasa")) = 
# 18.69037+(-5.458424)*Sepal.Length+(-8.707401)*Sepal.Width
#       +14.24477*Petal.Length+(-3.097684)*Petal.Width

# Sepal.Length의 versicolor에 대한 계수 -5.458424
exp(-5.458424)
# 0.004260265 
# 해석 : Sepal.Length가 1 증가하면 iris 꽃은 setosa에서 versicolor가 될 가능성이
# 0.004260265 배 증가한다.

# 작성한 모델이 주어진 훈련 데이터에 어떻게 적합되었는지는 fitted( )를 사용해 구할 수 있다.
head(fitted(multi.result))

# 예측된 범주 계산
multi.predict <-predict(multi.result, iris, type="class")

#  예측된 범주별 확률 계산
# multi.predict <-predict(multi.result, iris, type="probs")

table(multi.predict, iris$Species)

confusionMatrix(multi.predict, iris$Species)

###############################################################################
########                            군집분석                          ########
###############################################################################
if(!require("tidyverse")){install.packages("tidyverse"); library(tidyverse)}  # data manipulation
if(!require("cluster")){install.packages("cluster"); library(cluster)} # clustering algorithms
if(!require("factoextra")){install.packages("factoextra"); library(factoextra)} # clustering algorithms & visualization

str(USArrests)
summary(USArrests)

USArrests_scaled <- scale(USArrests) # Normalize data
USArrests_distance <- get_dist(USArrests_scaled)
fviz_dist(USArrests_distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

str(USArrests_distance)
set.seed(123)

# center : 군집의 수, nstart: 
USArrests_cluster <- kmeans(USArrests_distance, centers = 5, nstart = 25)
str(USArrests_cluster)

USArrests_cluster

# cluster: 사례가 속한 군집의 번호 벡터
# centers: 군집의 중심 좌표 벡터
# totss: tot.withinss + betweenss
# withinss: 각 군집내 사례와 군집 중심 사이 벡터
# tot.withinss: 군집내 사례와 군집 중심 사이 거리 합
# betweenss: 군집간 거리 제곱 합
# size: 각 군집내 사례 수

USArrests_cluster$cluster
USArrests_cluster$centers
USArrests_cluster$totss
USArrests_cluster$withinss
USArrests_cluster$tot.withinss
USArrests_cluster$betweenss
USArrests_cluster$size

fviz_cluster(USArrests_cluster, data = USArrests_distance)

USArrests %>%
  mutate(Cluster = USArrests_cluster$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")


# Hierarchical Clustering
USArrests_hc <- hclust(d=dist(USArrests_scaled), method="average")
plot(USArrests_hc, labels=row.names(USArrests_scaled))
rect.hclust(USArrests_hc, k=4)
h_cluster <- cutree(USArrests_hc, k=4)
h_cluster

USArrests %>%
  mutate(Cluster = h_cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")