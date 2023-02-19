###############################################################################
########                      상관관계 분석                            ########
###############################################################################
data(mtcars)
str(mtcars)

# pearson에 의한 상관계수 행렬, 수치형 변수가 포함된 경우만 사용
cor(mtcars, method = "pearson")

# spearman에 의한 상관계수 행렬, 서열형 변수가 포함된 경우만 사용
cor(mtcars, method = "spearman")

# 그래프로 나타내기
if(!require(GGally)){install.packages("GGally"); library(GGally)} 

ggpairs(mtcars)

# 상관행렬 만들기
if(!require("Hmisc")){install.packages("Hmisc"); library(Hmisc)}

res2 <- rcorr(as.matrix(mtcars))
res2

###############################################################################
########                       선형회귀 분석                           ########
###############################################################################

if(!require("dplyr")){install.packages("dplyr"); library(dplyr)}

airquality.no.na <- na.omit(airquality)
data <- airquality.no.na[, 1:4]



if(!require("psych")){install.packages("psych"); library(psych)}
airquality.no.na[ , 1:4] %>%
  pairs.panels(lm=TRUE, stars=TRUE)

if(!require("GGally")){install.packages("GGally"); library(GGally)}
airquality.no.na[ , 1:4] %>%
  ggpairs()

lm_fit <- lm(Ozone~Solar.R+Wind+Temp, data=na.omit(airquality))
summary(lm_fit)

# standardized estimate
if(!require("lm.beta")){install.packages("lm.beta"); library(lm.beta)}
lm.beta::lm.beta(lm_fit)

# VIF
if(!require("car")){install.packages("car"); library(car)}
car::vif(lm_fit)

###############################################################################
########                     패널티회귀 분석                           ########
###############################################################################

# Linear, Lasso, and Ridge Regression with R

if(!require("plyr")){install.packages("plyr"); library(plyr)}
if(!require("readr")){install.packages("readr"); library(readr)}
if(!require("dplyr")){install.packages("dplyr"); library(dplyr)}
if(!require("caret")){install.packages("caret"); library(caret)}
if(!require("ggplot2")){install.packages("car"); library(ggplot2)}
if(!require("repr")){install.packages("repr"); library(repr)}
if(!require("mlbench")){install.packages("mlbench"); library(mlbench)}

data(BostonHousing)
glimpse(BostonHousing)
my_BostonHousing <- BostonHousing
set.seed(100) 

index = sample(1:nrow(my_BostonHousing), 0.7*nrow(my_BostonHousing)) 

train = my_BostonHousing[index,] # Create the training data 
test = my_BostonHousing[-index,] # Create the test data

dim(train)
dim(test)

# 1. Linear Regression
lm_fit = lm(medv ~ ., data = train)
summary(lm_fit)

# 유의하지 않은 변수 제거
my_BostonHousing2 <- my_BostonHousing %>%
  select(-c(indus, age))

train = my_BostonHousing2[index,] # Create the training data 
test = my_BostonHousing2[-index,] # Create the test data

# 다시 lm 모델로 분석
lm_fit = lm(medv ~ ., data = train)
summary(lm_fit)

# standardized estimate
if(!require("lm.beta")){install.packages("lm.beta"); library(lm.beta)}
lm.beta::lm.beta(lm_fit)

# VIF
if(!require("car")){install.packages("car"); library(car)}
car::vif(lm_fit)

#Step 1 - create the evaluation metrics function
eval_metrics = function(model, df, predictions, target){
  performance <- c()
  resids = df[,target] - predictions
  resids2 = resids**2
  N = length(predictions)
  r2 = as.character(round(summary(model)$r.squared, 2))
  adj_r2 = as.character(round(summary(model)$adj.r.squared, 2))
  performance <- data.frame(
    RMSE = round(sqrt(sum(resids2)/N), 2),
    R_square = adj_r2
  )
  print(performance)
}

# Step 2 - predicting and evaluating the model on train data
predictions = predict(lm_fit, newdata = train)
eval_metrics(lm_fit, train, predictions, target = 'medv')

# Step 3 - predicting and evaluating the model on test data
predictions = predict(lm_fit, newdata = test)
eval_metrics(lm_fit, test, predictions, target = 'medv')

# Regularization
# eliminate factor variables
my_BostonHousing <- my_BostonHousing %>%
  select(-c(chas))

train = my_BostonHousing[index,] # Create the training data 
test = my_BostonHousing[-index,] # Create the test data

dummies <- dummyVars(medv ~ ., data = my_BostonHousing)
train_dummies = predict(dummies, newdata = train)
test_dummies = predict(dummies, newdata = test)
print(dim(train_dummies)); print(dim(test_dummies))

# Ridge Regression
if(!require("glmnet")){install.packages("glmnet"); library(glmnet)}

x = as.matrix(train_dummies)
y_train = train$medv

x_test = as.matrix(test_dummies)
y_test = test$medv

lambdas <- 10^seq(2, -3, by = -.1)
ridge_reg = glmnet(x, y_train, nlambda = 25, alpha = 0, family = 'gaussian', lambda = lambdas)

summary(ridge_reg)
cv_ridge <- cv.glmnet(x, y_train, alpha = 0, lambda = lambdas)
optimal_lambda <- cv_ridge$lambda.min
optimal_lambda

# Compute R^2 from true and predicted values
eval_results <- function(true, predicted, df) {
  SSE <- sum((predicted - true)^2)
  SST <- sum((true - mean(true))^2)
  R_square <- 1 - SSE / SST
  RMSE = sqrt(SSE/nrow(df))
  
  
  # Model performance metrics
  data.frame(
    RMSE = RMSE,
    R_square = R_square
  )
}

# Prediction and evaluation on train data
predictions_train <- predict(ridge_reg, s = optimal_lambda, newx = x)
eval_results(y_train, predictions_train, train)

# Prediction and evaluation on test data
predictions_test <- predict(ridge_reg, s = optimal_lambda, newx = x_test)
eval_results(y_test, predictions_test, test)

# Lasso Regression
lambdas <- 10^seq(2, -3, by = -.1)

# Setting alpha = 1 implements lasso regression
lasso_reg <- cv.glmnet(x, y_train, alpha = 1, lambda = lambdas, standardize = TRUE, nfolds = 5)

# Best 
lambda_best <- lasso_reg$lambda.min 
lambda_best

lasso_model <- glmnet(x, y_train, alpha = 1, lambda = lambda_best, standardize = TRUE)

predictions_train <- predict(lasso_model, s = lambda_best, newx = x)
eval_results(y_train, predictions_train, train)

predictions_test <- predict(lasso_model, s = lambda_best, newx = x_test)
eval_results(y_test, predictions_test, test)

# Elastic Net Regression
# Set training control
train_cont <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 5,
                           search = "random",
                           verboseIter = TRUE)

# Train the model
elastic_reg <- train(medv ~ .,
                     data = train,
                     method = "glmnet",
                     preProcess = c("center", "scale"),
                     tuneLength = 10,
                     trControl = train_cont)


# Best tuning parameter
elastic_reg$bestTune

# Make predictions on training set
predictions_train <- predict(elastic_reg, x)
eval_results(y_train, predictions_train, train) 

# Make predictions on test set
predictions_test <- predict(elastic_reg, x_test)
eval_results(y_test, predictions_test, test)

###############################################################################
########                    요인분석과 신뢰도 분석                     ########
###############################################################################

if(!require("psych")){install.packages("psych"); library(psych)}
if(!require("dplyr")){install.packages("dplyr"); library(dplyr)}
if(!require("GPArotation")){install.packages("GPArotation"); library(GPArotation)}
if(!require("Hmisc")){install.packages("Hmisc"); library(Hmisc)}

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
cortest.bartlett(cor(state.x77), nrow(state.x77))

# Kaiser-Meyer-Olkin's Measure of Sampling Adequacy, KMO's MSA
rcorr(as.matrix(state.x77))
rcorr(as.matrix(state.x77))$r
KMO(rcorr(as.matrix(state.x77))$r) # KMO's MSA 0.66

# Cronbach's alpha
state.x77[, 3:6] %>% alpha() # raw_alpha 0.72