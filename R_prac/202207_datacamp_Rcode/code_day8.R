###############################################################################
########                            K-최근접이웃                       ########
###############################################################################
wbcd<-read.csv("C:/data/wisc_bc_data.csv", stringsAsFactors=FALSE)
class(wbcd)
str(wbcd)
wbcd <- wbcd[-1] 
table(wbcd$diagnosis)
wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c("B", "M"), labels = c("Benign", "Malignant"))
round(prop.table(table(wbcd$diagnosis))*100, digits= 1)
summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")])
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

normalize(c(1, 2, 3, 4, 5))
normalize(c(10, 20, 30, 40, 50))
wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))
summary(wbcd_n$area_mean)

wbcd_train <- wbcd_n[1:469, ]
wbcd_test <- wbcd_n[470:569, ]

wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]

if(!require(class)){install.packages("class"); library(class)}

wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels,  k=21) 
# k=sqrt(469)=21

if(!require(gmodels)){install.packages("gmodels"); library(gmodels)}
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq=FALSE)

###############################################################################
########                        나이브 베이즈                          ########
###############################################################################

if(!require("caret")){install.packages("caret"); library(caret)}
if(!require("dplyr")){install.packages("dplyr"); library(dplyr)}
if(!require("pROC")){install.packages("pROC"); library(pROC)}
if(!require("e1071")){install.packages("e1071"); library(e1071)}

iris_cat <- iris

# naiveBayes는 범주형 독립변수들로 범주형 종속변수를 분류함
# 입력변수를 범주화 
iris_cat$Sepal.Length <- cut(iris$Sepal.Length, c(-Inf, median(iris$Sepal.Length), Inf))
iris_cat$Sepal.Width <- cut(iris$Sepal.Width, c(-Inf, median(iris$Sepal.Width), Inf))
iris_cat$Petal.Length <- cut(iris$Petal.Length, c(-Inf, median(iris$Petal.Length), Inf))
iris_cat$Petal.Width <- cut(iris$Petal.Width, c(-Inf, median(iris$Petal.Width), Inf))

?naiveBayes
model <- naiveBayes(Species ~ ., data = iris_cat)
model

predict(model, iris_cat[1:5, -5], type = "raw") # class probabilities

# 예측하기
pred <- predict(model, iris_cat[,-5])
# Confusion Matrix
table(pred, iris$Species)

# using laplace smoothing:
model2 <- naiveBayes(Species ~ ., data = iris_cat, laplace = 1)
pred <- predict(model, iris_cat[,-5])
table(pred, iris$Species)

# data partition
trainRowNumbers <- createDataPartition(iris_cat$Species , p=0.7, list=FALSE)

# create the training dataset
trainData <- iris_cat[trainRowNumbers, ]

# creating the test dataset
testData <- iris_cat[-trainRowNumbers, ]

set.seed(12345) # 랜덤 seed

# 학습 모델 만들기
NaiveByes.iris_cat <- naiveBayes(Species ~ ., data = trainData, laplace = 1)

# 확률 예측하기 
testData$predict_prob <- predict(NaiveByes.iris_cat, testData[, -5], type = "raw")

# 범주 예측하기
testData$predict_class <- predict(NaiveByes.iris_cat, testData[, -5], type = "class")

# 훈련자료의 인덱스 추출(비복원 추출), 추출되지 않은 나머지는 검증자료의 인덱스 
tr.idx <- sample(nrow(iris), nrow(iris)*0.5, replace=F)
head(tr.idx)

iris2 <- iris
cut_values <- apply(iris2[, -5], 2, quantile)
# 입력변수를 범주형 변수로 변환 (여기서는 4분위수 이용)
for(i in 1:4) iris2[, i] <- cut(iris2[, i], cut_values[,i])
head(iris2)

model <- naiveBayes(Species ~ ., data = iris2[tr.idx, ], k=5)

# predict
# type = "raw"이면 사후확률 추정, 아니면 클래스범주 출력  
predict(model, iris2[1:5, -5], type = "raw")

# 검증자료에 대해 예측 
pred <- predict(model, iris2[-tr.idx,-5])

# Confusion Matrix
o <- table(pred, iris2$Species[-tr.idx])
o

# using laplace smoothing:
model2 <- naiveBayes(Species ~ ., data = iris2[tr.idx, ], laplace = 3)
pred2 <- predict(model2, iris2[-tr.idx, -5])
table(pred2, iris2$Species[-tr.idx])

###############################################################################
########                      의사결정나무: 분류문제                   ########
###############################################################################

if(!require("caret")){install.packages("caret"); library(caret)}
if(!require("dplyr")){install.packages("dplyr"); library(dplyr)}
if(!require("rpart")){install.packages("rpart"); library(rpart)}
if(!require("rpart.plot")){install.packages("rpart.plot"); library(rpart.plot)}
if(!require("C50")){install.packages("C50"); library(C50)}
if(!require("Epi")){install.packages("Epi"); library(Epi)}
if(!require("ROCR")){install.packages("ROCR"); library(ROCR)}

set.seed(678)
path <- 'https://raw.githubusercontent.com/guru99-edu/R-Programming/master/titanic_data.csv'
titanic <-read.csv(path)
str(titanic)
head(titanic)

# 데이터 해설
# pclass : 1=1등석, 2=2등석, 3=3등석
# Survived : 0=사망, 1=생존
# name : 탑승자 성명
# sex : 탑승자 성명
# age : male=남성, female=여성
# sibsp : 같이 탑승한 자매 또는 배우자 수
# parch : 동승한 부모 떠는 자식의 수
# ticket : 티켓번호
# fare  : 요금
# cabin : 방호수
# embarked : 탑승지 C=세르부르, Q=퀸즈타운, S=사우스햄프턴
# home.dest : 목적지

shuffle_index <- sample(1:nrow(titanic))
head(shuffle_index)

titanic <- titanic[shuffle_index, ]
head(titanic)
str(titanic)

# 사용하지 않는 변수 제거
clean_titanic <- titanic %>%
  select(-c(home.dest, cabin, name, x, ticket)) %>% 
  #Convert to factor level
  mutate(pclass = factor(pclass, levels = c(1, 2, 3), labels = c('Upper', 'Middle', 'Lower')),
         survived = factor(survived, levels = c(0, 1), labels = c('No', 'Yes'))) %>%
  filter(age!="?") %>% # age에 물음표가 있네요. 
  na.omit()

# str()유사한 데이터 구조보기 함수
glimpse(clean_titanic)
# str(clean_titanic)

# age와 fare를 숫자로 바꿉시다.
clean_titanic$age <- as.numeric(clean_titanic$age)
clean_titanic$fare <- as.numeric(clean_titanic$fare)
glimpse(clean_titanic)

set.seed(100)

# data partition
trainRowNumbers <- createDataPartition(clean_titanic$survived , p=0.8, list=FALSE)

# create the training dataset
trainData <- clean_titanic[trainRowNumbers, ]

# creating the test dataset
testData <- clean_titanic[-trainRowNumbers, ]

prop.table(table(trainData$survived))
prop.table(table(testData$survived))

fit <- rpart(survived~., data = trainData, method = 'class')
rpart.plot(fit, extra = 106)
# 그려진 그림을 'Export' -> 'PDF'로 저장 후 열어보기

testData$predict_class <-predict(fit, testData, type = 'class') # 종속변수의 범주 값예측
predict_class

# 혼동행렬
confusionMatrix(data = testData$predict_class, reference = testData$survived)

testData$predict_prob <- predict(fit, testData, type = 'prob')# 종속변수의 범주 확률 예측
testData$predict_prob

dtree_ROC <- ROC(form=survived~testData$predict_prob, data = testData, plot="ROC")
dtree_ROC


##### iris 데이터로 연습해 봅시다.
set.seed(100)
# data partition
trainRowNumbers <- createDataPartition(iris$Species , p=0.8, list=FALSE)

# create the training dataset
trainData <- iris[trainRowNumbers, ]

# creating the test dataset
testData <- iris[-trainRowNumbers, ]

# 최소 분리 사례 수와 최대 트리 깊이 지정
rpart.control(minsplit = 3, maxdepth = 10)

# cp: complexity parameter, 트리의 과성장을 막기 위해 성장시 R-squared 값의 최소증가 크기를 설정
# 값이 크면 나무가 잘 안자람, 너무 작으면 나무가 너무 크게 성장, 0.1~0.2 정도 설정

fit <- rpart(Species~., data = trainData, method = 'class', cp = .02)

rpart.plot(fit, type = 2, extra = 104)
?rpart.plot # extra option보기

testData$predict_class <-predict(fit, testData, type = 'class') # 종속변수의 범주 값예측
testData$predict_class

# 혼동행렬
confusionMatrix(data = testData$predict_class, reference = testData$Species)

testData$predict_prob <-predict(fit, testData, type = 'prob')# 종속변수의 범주 확률 예측
testData$predict_prob
str(testData)

# ROC curve 그리기
dtree_ROC <- ROC(form=Species~testData$predict_prob, data = testData, plot="ROC")
dtree_ROC

# cp에 따라 error가 줄어드는 정도를 값으로
printcp(fit)

# cp에 따라 error가 줄어드는 정도를 그래프로
plotcp(fit)

# 가지치기
prtfit<- prune(fit, cp=0.033) # from cptable 
prtfit

# 가지친 후 그림 그리기
rpart.plot(prtfit, uniform=TRUE, main="Pruned Regression Tree")

write.csv(testData, "C:/data/iris_prediction.csv")

################## C5.0으로 분석하기

fit_iris_C50 <- C5.0(Species~., data=trainData)
testData$predict_class<- predict(fit_iris_C50, testData, type="class")
testData$predict_class
plot(fit_iris_C50) # 그림을 그리는 함수는 알고리듬에 따라 상이함
confusionMatrix(data = testData$predict_class, reference = testData$Species)

dtree_ROC <- ROC(form=Species~testData$predict_prob, data = testData, plot="ROC")
dtree_ROC

# 어떤것이 알고리듬이 IRIS 데이터의 Species 변수를 예측하는데 더 정확한가?
# CA, AUC?

###############################################################################
#                    의사결정나무 : 예측문제                                  #
###############################################################################

if(!require("caret")){install.packages("caret"); library(caret)}
if(!require("dplyr")){install.packages("dplyr"); library(dplyr)}
if(!require("party")){install.packages("party"); library(party)}
if(!require("mlbench")){install.packages("mlbench"); library(mlbench)}

airquality_data <- airquality %>%
  select(-c(Month, Day)) %>%
  na.omit()

str(airquality_data)
fit_ctree <- ctree(Ozone~., data=airquality_data)
fit_ctree

plot(fit_ctree)

# data partition
trainRowNumbers <- createDataPartition(airquality_data$Ozone, p=0.8, list=FALSE)

# create the training dataset
trainData <- airquality_data[trainRowNumbers, ]

# creating the test dataset
testData <- airquality_data[-trainRowNumbers, ]

fit_ctree <- ctree(Ozone~., data=trainData)

testData$predict_value <- predict(fit_ctree , testData) # 종속변수의 값 예측
testData$predict_value
str(testData)

predictions <- model1 %>% predict(swiss)
data.frame(
  R = R2(testData$predict_value, testData$Ozone),
  RMSE = RMSE(testData$predict_value, testData$Ozone),
  MAE = MAE(testData$predict_value, testData$Ozone)
)