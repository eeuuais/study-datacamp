data(iris)
table(iris$Species)
prop.table(table(iris$Species))
prop.table(table(iris$Species))*100

if(!require(MASS)){install.packages("MASS"); library(MASS)}
tbl = table(survey$Smoke, survey$Exer) 
tbl                 # the contingency table 
chisq.test(tbl) 


if(!require(gmodels)){install.packages("gmodels"); library(gmodels)}
CrossTable(x=survey$Smoke,y=survey$Exer, chisq=TRUE, expected=TRUE, fisher=FALSE)
CrossTable(x=survey$Smoke,y=survey$Exer, chisq=TRUE, expected=TRUE, fisher=FALSE)

rnd <- c(75, 70)
not_rnd <- c(25, 30)
test <- cbind(rnd , not_rnd) #벡터 두개 결합 
rownames(test) <- c("Theory","Actual") #데이터 이름 부여
test
chisq.test(test)

# 필요한 패키지를 필요시 설치하고 불러옵니다
if(!require(dplyr)){install.packages("dplyr"); library(dplyr)}

###############################################################################
########              일원분산분석(one-way ANOVA) 시작                 ########
###############################################################################

# 데이터를 불러옵니다
data(PlantGrowth)

# 데이터의 구조를 살펴봅니다
str(PlantGrowth)

# 기술통계량을 살펴봅니다
summary(PlantGrowth)

# group 변수별로 데이터를 나누고 나뉜 집단별로 사례 수, 평균, 표준편차 계산
PlantGrowth %>%
  group_by(group) %>%
  summarise(
    count = n(),
    mean = mean(weight, na.rm = TRUE),
    sd = sd(weight, na.rm = TRUE)
  )

# 필요한 패키지를 필요시 설치하고 불러옵니다
if(!require(ggpubr)){install.packages("ggpubr"); library(ggpubr)}

# 설치된 패키지를 이용하여 그림을 그려봅니다.
# Box plots
# ++++++++++++++++++++
# Plot weight by group and color by group
PlantGrowth %>%
  ggboxplot(x = "group", y = "weight", 
            color = "group", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
            order = c("ctrl", "trt1", "trt2"),
            ylab = "Weight", xlab = "Treatment")

PlantGrowth %>%
  ggline(x = "group", y = "weight", 
         add = c("mean_se", "jitter"), 
         order = c("ctrl", "trt1", "trt2"),
         ylab = "Weight", xlab = "Treatment")


# # Box plot
# boxplot(weight ~ group, data = PlantGrowth,
#         xlab = "Treatment", ylab = "Weight",
#         frame = FALSE, col = c("#00AFBB", "#E7B800", "#FC4E07"))
# # plotmeans
# library("gplots")
# plotmeans(weight ~ group, data = PlantGrowth, frame = FALSE,
#           xlab = "Treatment", ylab = "Weight",
#           main="Mean Plot with 95% CI") 


# Compute the analysis of variance
res.aov <- aov(weight ~ group, data = PlantGrowth)
# Summary of the analysis
summary(res.aov)

# p-value는?
# Ho: 독립변수에 따라 종속변수 값에 차이가 없다.
# H1: 독립변수에 따라 종속변수 값에 차이가 있다.

# 만일 차이가 있다면 독립변수의 어떤 범주값 사이에 차이가 있나?
# Tukey(튜키) 방법으로 살펴봅시다
TukeyHSD(res.aov)
?pairwise.t.test

# 다른 방법도 있습니다
pairwise.t.test(PlantGrowth$weight, PlantGrowth$group, p.adjust.method = "BH")
pairwise.t.test(PlantGrowth$weight, PlantGrowth$group, p.adjust.method = "BY")
pairwise.t.test(PlantGrowth$weight, PlantGrowth$group, p.adjust.method = "BH")
pairwise.t.test(PlantGrowth$weight, PlantGrowth$group, p.adjust.method = "bonferroni")
# p.adjust.methods
# c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none")

############################ ANOVA 검정이 가능한지 살펴봅시다
########## 분산동질성 (homogeneity of variance) 
plot(res.aov, 1)
# 원의 분포 점검
if(!require(car)){install.packages("car"); library(car)}
leveneTest(weight ~ group, data = PlantGrowth)

# p-value는?
# Ho: 분산에 차이가 없다.(동질하다)
# H1: 분산에 차이가 있다.

########## 정규성(normality assumption) 검정
plot(res.aov, 2)
# Extract the residuals
aov_residuals <- residuals(object = res.aov )
# Run Shapiro-Wilk test
shapiro.test(x = aov_residuals )

# p-value는?
# Ho: 데이터는 정규성과 차이가 없다.(정규성을 나타낸다)
# H1: 데이터는 정규성과 차이가 있다.

###############################################################################
########              이원분산분석(one-way ANOVA) 시작                 ########
###############################################################################

data(ToothGrowth)
# 60개 기니 피그의 치아 성장에 비타민 C가 미치는 영향을 조사한 결과 
# len은 치아 길이, supp은 비타민 공급 종류, dose는 복용량
# OJ는 오렌지주스, VC는 비타민C

str(ToothGrowth)
# 두 개의 범주형(factor) 변수

summary(ToothGrowth)
# 결측 없음

# Convert dose as a factor and recode the levels
# as "D0.5", "D1", "D2"
my_data <- ToothGrowth
my_data$dose <- factor(my_data$dose, 
                       levels = c(0.5, 1, 2),
                       labels = c("D0.5", "D1", "D2"))
head(my_data)

# 교차 표 생성
table(my_data$supp, my_data$dose)

# Box plot with multiple groups
# +++++++++++++++++++++
# Plot tooth length ("len") by groups ("dose")
# Color box plot by a second group: "supp"
if(!require(ggpubr)){install.packages("ggpubr"); library(ggpubr)}
my_data %>%
  ggboxplot(x = "dose", y = "len", color = "supp",
            palette = c("#00AFBB", "#E7B800"))
?ggboxplot

my_data %>%
  ggline(x = "dose", y = "len", color = "supp",
         add = c("mean_se", "dotplot"),
         palette = c("#00AFBB", "#E7B800"))

# # Box plot with two factor variables
# boxplot(len ~ supp * dose, data=my_data, frame = FALSE, 
#         col = c("#00AFBB", "#E7B800"), ylab="Tooth Length")
# # Two-way interaction plot
# interaction.plot(x.factor = my_data$dose, trace.factor = my_data$supp, 
#                  response = my_data$len, fun = mean, 
#                  type = "b", legend = TRUE, 
#                  xlab = "Dose", ylab="Tooth Length",
#                  pch=c(1,19), col = c("#00AFBB", "#E7B800"))

res.aov2 <- aov(len ~ supp + dose, data = my_data)
summary(res.aov2)

# p-value는?
# Ho: 독립변수에 따라 종속변수 값에 차이가 없다.
# H1: 독립변수에 따라 종속변수 값에 차이가 있다.

# dose를 사후분석(post-hoc analysis) 하여 multiple pairwise-comparisons해 봅시다
TukeyHSD(res.aov2, which = "dose")

# supp, dose별로 특징을 살펴봅시다
my_data %>%
  group_by(supp, dose) %>%
  summarise(
    count = n(),
    mean = mean(len, na.rm = TRUE),
    sd = sd(len, na.rm = TRUE)
  )

# 이원 이상의 분산분석은 상호작용 효과를 확인해야 합니다

# These two calls are equivalent
res.aov3 <- aov(len ~ supp*dose, data = my_data)
res.aov3 <- aov(len ~ supp + dose + supp:dose, data = my_data)
summary(res.aov3)

# 상호작용 효과항의 p-value는?
# 상호작용 항은 유의한가?

# dose를 사후분석(post-hoc analysis) 하여 multiple pairwise-comparisons해 봅시다
TukeyHSD(res.aov3, which = "dose")

############################ ANOVA 검정이 가능한지 살펴봅시다
########## 분산동질성 (homogeneity of variance) 
plot(res.aov3, 1)
# 원의 분포 점검
if(!require(car)){install.packages("car"); library(car)}
leveneTest(len ~ supp*dose, data = my_data)

# p-value는?
# Ho: 분산에 차이가 없다.(동질하다)
# H1: 분산에 차이가 있다.

########## 정규성(normality assumption) 검정
# Extract the residuals
plot(res.aov3, 2) 
aov_residuals <- residuals(object = res.aov3)
# Run Shapiro-Wilk test
shapiro.test(x = aov_residuals)

# p-value는?
# Ho: 데이터는 정규성과 차이가 없다.(정규성을 나타낸다)
# H1: 데이터는 정규성과 차이가 있다.

################### 집단내 사례 수가 불균형한 경우
my_anova <- aov(len ~ supp*dose, data = my_data)
Anova(my_anova, type = "III")

pairwise.t.test(my_data$len, my_data$dose, p.adjust.method = "BH")


if(!require(agricolae)){install.packages("agricolae"); library(agricolae)}
?scheffe.test
scheffe.test(my_anova,  # anova model 이름
             "dose", # name of independent variable
             alpha = 0.05, # significant level
             group=TRUE,
             console=TRUE, # print out
             main="Yield of sweetpotato\nDealt with different virus")
# 같은 그룹으로 나온 범주는 차이가 없음