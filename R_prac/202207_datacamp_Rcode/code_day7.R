###############################################################################
########                         Web Data Scraping                     ########
###############################################################################

####################################################
# Web Data Scraping

# ÇÊ¿ä ÆÐÅ°Áö ¼³Ä¡ ¹× ºÒ·¯¿À±â 
if(!require(devtools)) {install.packages("devtools"); library(devtools)} 
# if(!require(RSelenium)) {install.packages("RSelenium"); library(RSelenium)} 
if(!require(rvest)) {install.packages("rvest"); library(rvest)} 
if(!require(httr)) {install.packages("httr"); library(httr)} 
if(!require(stringr)) {install.packages("stringr"); library(stringr)} 
if(!require(dplyr)) {install.packages("dplyr"); library(dplyr)} 

################# Ãµ¸¸ °ü°´ ÀÌ»óÀÌ º» ¿µÈ­¸¸ ÀÌ¿ëÇØ º¾½Ã´Ù.
# ¸í·®
# ±ØÇÑÁ÷¾÷
# ½Å°úÇÔ²²-ÁË¿Í ¹ú
# ±¹Á¦½ÃÀå
# ¾îº¥Á®½º: ¿£µå°ÔÀÓ
# °Ü¿ï¿Õ±¹ 2
# ¾Æ¹ÙÅ¸
# º£Å×¶û
# µµµÏµé
# 7¹ø¹æÀÇ ¼±¹°
# ¾Ë¶óµò
# ¾Ï»ì
# ±¤ÇØ, ¿ÕÀÌ µÈ ³²ÀÚ
# ½Å°úÇÔ²²-ÀÎ°ú ¿¬
# ÅÃ½Ã¿îÀü»ç
# ÅÂ±Ø±â ÈÖ³¯¸®¸ç
# ºÎ»êÇà
# º¯È£ÀÎ
# ÇØ¿î´ë
# ¾îº¥Á®½º: ÀÎÇÇ´ÏÆ¼ ¿ö
# ½Ç¹Ìµµ
# ±«¹°
# ¿ÕÀÇ ³²ÀÚ
# ¾îº¥Á®½º: ¿¡ÀÌÁö ¿Àºê ¿ïÆ®·Ð
# ±â»ýÃæ
# ÀÎÅÍ½ºÅÚ¶ó
# °Ü¿ï¿Õ±¹
################ ÇÏ³ªÀÇ ¿µÈ­¿¡ ´ëÇÑ °³¿ä µ¥ÀÌÅÍ¸¦ ½ºÅ©·¡ÇÎ ÇØ º¾´Ï´Ù.
# https://movie.naver.com/movie/bi/mi/basic.nhn?code=93756 ¸í·®ÀÇ °³¿ä ÆäÀÌÁö

# url »ý¼º
url1 <- 'https://movie.naver.com/movie/bi/mi/basic.nhn?code='
movie_code <- 93756
url <- paste(url1, movie_code, sep='')

html <- url %>%
  read_html()

# ¿µÈ­Á¦¸ñ °¡Á®¿À±â
movie_title <- html %>%
  html_node("div.mv_info > h3.h_movie > a") %>% 
  html_text()
movie_title

# °ü¶÷°´ ÆòÁ¡Æò±Õ
avg_score <- html %>%
  html_nodes("div.star_score") %>% 
  html_text()
avg_score <- gsub("(\\r|\\n|\\t)", "", avg_score) # ÁÙ¹Ù²Þ ¹®ÀÚ, ÅÇ Á¦°Å
avg_score
avg_score <- avg_score[1:3] # Ã¹ 3°³¸¸ ÃßÃâ
avg_score
# avg_score <- str_sub(avg_score, -4, -1) 
avg_score <-substr(avg_score, nchar(avg_score)-3, nchar(avg_score)) # ³¡ 4°³ ±ÛÀÚ¸¸ ÃßÃâ
avg_score
avg_score <- as.numeric(avg_score)
avg_score

avg_viewer_score <- avg_score[1] # °ü¶÷°´ ÆòÁ¡Æò±Õ
avg_reporter_score <- avg_score[2] # ±âÀÚ Æò·Ð°¡ ÆòÁ¡Æò±Õ
avg_netizen_score <- avg_score[3] # ³×Æ¼Áð ÆòÁ¡Æò±Õ

# ¿¬·É´ëº° Æò°¡ ºñÀ²
age_ratio <- html %>%
  html_nodes("strong.graph_percent") %>% 
  html_text()
age_ratio
age_ratio <- age_ratio[1:5]
age_ratio
age_ratio <-gsub("%", "", age_ratio)
age_ratio
age_ratio <- as.numeric(age_ratio)
age_ratio

# review ¼ö¸¦ °¡Á®¿É´Ï´Ù.
review_count <- html %>%
  html_nodes("strong.total > em") %>% 
  html_text()
review_count
review_count <- as.numeric(gsub(",", "", review_count))
review_count

movie_summary <- c() # ÃÊ±âÈ­

# µ¥ÀÌÅÍ ÇÁ·¹ÀÓ »ý¼º
movie_summary <- data.frame(movie_title = movie_title,
                            movie_code= movie_code, 
                            avg_viewer_score = avg_viewer_score,
                            avg_reporter_score = avg_reporter_score,
                            avg_netizen_score = avg_netizen_score,
                            age_ratio_10 = age_ratio[1], 
                            age_ratio_20 = age_ratio[2], 
                            age_ratio_30 = age_ratio[3], 
                            age_ratio_40 = age_ratio[4], 
                            age_ratio_50 = age_ratio[5],
                            review_count = review_count)

# ÃÑ ¸®ºä ÆäÀÌÁö ¼ö´Â?
num_page <- ceiling(review_count/10) # ¸®ºä ¼ö¸¦ 10À¸·Î ³ª´©¾î ¿Ã¸²
num_page
################# 

# url »ý¼º
url1 <- 'https://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code='
url2 <- '&type=after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject=false&page='
movie_code <- 93756

##################################################################
# double ## is reserved for scraping multiple pages
single_movie_review_total <- c() # ¿©·¯ ÆäÀÌÁö ½ºÅ©·¡ÇÎ °á°ú ÇÕÄ§
# page<-1

for (page in 1:num_page){
  url <- paste(url1, movie_code, url2, page, sep='')
  url
  html <- url %>%
    read_html()
  
  # review ¼ö¸¦ °¡Á®¿É´Ï´Ù.
  review_count <- html %>%
    html_nodes("strong.total > em") %>% 
    html_text()
  review_count
  review_count <- as.numeric(gsub(",", "", review_count))
  review_count
  
  # ÆòÁ¡À» °¡Á®¿É½Ã´Ù.
  star_score <- html %>%
    html_nodes("div.star_score") %>% 
    html_text()
  star_score
  star_score <- gsub("(\\r|\\n|\\t)", "", star_score) # ÁÙ¹Ù²Þ ¹®ÀÚ, ÅÇ Á¦°Å
  star_score # ¹®ÀÚÀÌ³×¿ä. ¼ý¤¸·Î ¹Ù²Ù¾î º¾½Ã´Ù.
  star_score <- as.numeric(star_score)
  star_score 
  
  # ¸®ºä º»¹®À» °¡Á®¿Í º¾½Ã´Ù.
  review_contnents <- html %>%
    html_nodes("div.score_reple > p") %>% # ÇÏÀ§ element´Â >·Î ¿¬°á
    html_text()
  review_contnents
  review_contnents <- gsub("(\\r|\\n|\\t)", "", review_contnents) # ÁÙ¹Ù²Þ ¹®ÀÚ, ÅÇ Á¦°Å
  review_contnents
  
  # ±Û¾´ ½Ã°£À» °¡Á®¿Í º¾½Ã´Ù.
  review_time <- html %>%
    html_nodes("dl> dt > em:nth-child(2)") %>% 
    html_text()
  review_time
  review_time <- substr(review_time, 1, 10) # ³¯Â¥¸¸ ³ª¿À°Ô °¢ ³¯Â¥ÀÇ Ã³À½ 10°³ ¹®ÀÚ¸¸ Àß¶ó º¾½Ã´Ù.
  review_time
  
  # ¸®ºä±Û¿¡ ´ëÇÑ °ø°¨ ¼ö¸¦ °¡Á®¿É½Ã´Ù.
  sympathy_count <- html %>%
    html_nodes("a._sympathyButton") %>% 
    html_text()
  sympathy_count
  sympathy_count <- gsub("(\\r|\\n|\\t)", "", sympathy_count) # ÁÙ¹Ù²Þ ¹®ÀÚ, ÅÇ Á¦°Å
  sympathy_count
  sympathy_count <- gsub("°ø°¨", "", sympathy_count) # ÁÙ¹Ù²Þ ¹®ÀÚ, ÅÇ Á¦°Å
  sympathy_count
  sympathy_count <- as.numeric(sympathy_count) # ¼ýÀÚ·Î º¯È¯
  sympathy_count
  
  # ¸®ºä±Û¿¡ ´ëÇÑ ºñ°ø°¨ ¼ö¸¦ °¡Á®¿É½Ã´Ù.
  unsympathy_count <- html %>%
    html_nodes("a._notSympathyButton") %>% 
    html_text()
  unsympathy_count
  unsympathy_count <- gsub("(\\r|\\n|\\t)", "", unsympathy_count) # ÁÙ¹Ù²Þ ¹®ÀÚ, ÅÇ Á¦°Å
  unsympathy_count
  unsympathy_count <- gsub("ºñ°ø°¨", "", unsympathy_count) # ÁÙ¹Ù²Þ ¹®ÀÚ, ÅÇ Á¦°Å
  unsympathy_count
  unsympathy_count <- as.numeric(unsympathy_count) # ¼ýÀÚ·Î º¯È¯
  unsympathy_count
  
  review_one_page <- data.frame(star_score=star_score, review_contnents=review_contnents, review_time=review_time, sympathy_count=sympathy_count, unsympathy_count=unsympathy_count )
  str(review_one_page)
  single_movie_review_total <- rbind(single_movie_review_total, review_one_page)
} # For loop ³¡
str(single_movie_review_total)
nrow(single_movie_review_total)

write.csv(single_movie_review_total, paste(movie_title, ".csv", sep=''))


############################################################################### 
# Text Mining # 
############################################################################### 

setwd("C:/data/") 

# JAVA ¼³Ä¡ ¹× ¼³Á¤
# www.java.com ¹æ¹®
# Á¦¾îÆÇ ¡æ ½Ã½ºÅÛ ¹× º¸¾È ¡æ ½Ã½ºÅÛ ¡æ ½Ã½ºÅÛ ¼Ó¼º ¡æ °í±Þ ½Ã½ºÅÛ ¼³Á¤¡æ È¯°æ º¯¼ö(N) 
# ½Ã½ºÅÛ º¯¼ö¿¡ JAVA_HOME Ãß°¡, °ª¿¡ C:\Program Files\Java\jrexxxxxx Ãß°¡
# user¿¡ ´ëÇÑ »ç¿ëÀÚ º¯¼ö¿¡ CLASSPATH Ãß°¡, °ª¿¡ C:\Program Files\Java\jrexxxxxx Ãß°¡
# user¿¡ ´ëÇÑ »ç¿ëÀÚ º¯¼ö¿¡ Path Ãß°¡, °ª¿¡ C:\Program Files\Java\jrexxxxxx Ãß°¡

# RTools ¼³Ä¡
# https://cran.r-project.org/bin/windows/Rtools/ ¹æ¹® ÈÄ ¼³Ä¡

# RStudio Á¾·á ÈÄ ´Ù½Ã ½ÇÇà
if(!require("rlang")){install.packages("rlang"); library(rlang)} 
if(!require("tidyverse")){install.packages("tidyverse"); library(tidyverse)} 
if(!require("tidytext")){install.packages("tidytext"); library(tidytext)} 
if(!require("stringr")){install.packages("stringr"); library(stringr)} 
if(!require("dplyr")){install.packages("dplyr"); library(dplyr)} 
if(!require("reshape2")){install.packages("reshape2"); library(reshape2)} 
if(!require("tm")){install.packages("tm"); library(tm)} 
if(!require("SnowballC")){install.packages("SnowballC"); library(SnowballC)} 
if(!require("multilinguer")){install.packages("multilinguer"); library(multilinguer)} 
if(!require("remotes")){install.packages("remotes"); library(remotes)} 
# if(!require("rJava")){install.packages("rJava"); library(rJava)} 
# rJava ¼³Ä¡½Ã Ãß°¡·Î ¼³Á¤ : Sys.setenv("JAVA_HOME"='C:/Program Files/Java/jre1.8.0_291') 
# remove.packages("testthat") 
# install.packages("testthat") 

remotes::install_github('haven-jeon/KoNLP', force = TRUE, upgrade = "never", INSTALL_opts=c("--no-multiarch")) 
library(KoNLP) #ÃÖÁ¾ÀûÀ¸·Î "KoNLP" ÆÐÅ°Áö¸¦ ºÒ·¯¿É´Ï´Ù

# Á¤º¸È­ ÁøÈï¿ø¿¡¼­ Ãß°¡ÇÑ ¸í»ç»çÀüÀ» È°¿ëÇØ º¾½Ã´Ù.
# »çÀüÀ» ºÒ·¯¿É´Ï´Ù.

useNIADic() # "NIADic" dicÀ» ºÒ·¯¿É´Ï´Ù. 121¸¸°³ ´Ü¾î»çÀü

text <- 'ÇÏ´ÃÀº ÆÄ¶þ°Ô ±¸¸§Àº ÇÏ¾é°Ô ½Ç¹Ù¶÷µµ ºÒ¾îºÁ ºÎÇ®Àº ³» ¸¶À½ ¾Æ¸§´Ù¿î °­»ê' 
SimplePos09(text) 
SimplePos22(text) 

text <- read.csv("¸í·®.csv", header=TRUE) 

SimplePos09(text$review_contnents[1]) 

# ÁÙ¹Ù²ÞÀ» °ø¹éÀ¸·Î ¹Ù²Ù¾î ÇÑ ÁÙ·Î ¸¸µê
?str_replace_all 
text$review_contnents <- str_replace_all(string=text$review_contnents, pattern="[\r\n]" , " ") 

text$review_contnents <- text$review_contnents %>% 
  str_replace_all("[^°¡-ÆR]", " ") %>% # ÇÑ±Û¸¸ ³²±â±â
  str_squish() # ¹®ÀÚ ½ÃÀÛ°ú ³¡ÀÇ °ø¹é Á¦°Å, ¿¬¼Ó °ø¹é Á¦°Å

text %>% 
  unnest_tokens(input = review_contnents, # ÅäÅ«È­ÇÒ ÅØ½ºÆ®
                output = word, # ÅäÅ«À» ´ãÀ» º¯¼ö¸í
                token = "word", 
                drop=F) %>% # ÅäÅ«È­ ÇÔ¼ö
  filter(str_count(word) > 1) %>% # ÇÑ±ÛÀÚ ÀÌ»ó¸¸ ÃßÃâ
  select(review_contnents, word)

my_text <- text %>% 
  unnest_tokens(input = review_contnents, # ÅäÅ«È­ÇÒ ÅØ½ºÆ®
                output = word, # ÅäÅ«À» ´ãÀ» º¯¼ö¸í
                token = "words", 
                drop=F) %>% # ÅäÅ«È­ ÇÔ¼ö
  filter(str_count(word) > 1) %>% # ÇÑ±ÛÀÚ ÀÌ»ó¸¸ ÃßÃâ
  select(review_contnents, word) 

# Æ¯Á¤ ´Ü¾î°¡ »ç¿ëµÈ ¹®Àå 10°³ ÃßÃâ
my_text %>% 
  filter(str_detect(word, "ÀÌ¼ø½Å")) %>% 
  select(review_contnents) %>% 
  head(10) 

# ¾î¶² ´Ü¾îÀÇ ºóµµ°¡ ³ôÀº°¡?
my_text %>% 
  group_by(word) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n)) 

# °¨Á¤»çÀü ÀÐ±â
dic <- read.csv("knu_sentiment_lexicon.csv", fileEncoding = "UTF-8", header=TRUE) 

str(text) 
# °¨Á¤ »çÀüÀº ´Ü¾î±âÁØÀÌ¹Ç·Î ¿ø¹®À» ´Ü¾î ±âÁØÀ¸·Î ÅäÅ«È­ ÇÊ¿ä
emotional_text <- text %>% 
  unnest_tokens(input = review_contnents, # ÅäÅ«È­ÇÒ ÅØ½ºÆ®
                output = word, # ÅäÅ«À» ´ãÀ» º¯¼ö¸í
                token = "words", # ´Ü¾î±âÁØ ÅäÅ«È­
                drop=F) %>% # ÅäÅ«È­ ÇÔ¼ö
  filter(str_count(word) > 1) %>% # ÇÑ±ÛÀÚ ÀÌ»ó¸¸ ÃßÃâ
  select(review_contnents, word) 

# dplyr::left_join() : word ±âÁØ °¨Á¤ »çÀü °áÇÕ
# °¨Á¤ »çÀü¿¡ ¾ø´Â ´Ü¾î polarity NA ¡æ 0 ºÎ¿©
emotional_text <- emotional_text %>% 
  left_join(dic, by = "word") %>% 
  mutate(polarity = ifelse(is.na(polarity), 0, polarity)) 
str(emotional_text) 

score_df <- emotional_text %>% 
  group_by(review_contnents) %>% 
  summarise(score = sum(polarity)) 
score_df

# ÀÚÁÖ »ç¿ëµÈ °¨Á¤ ´Ü¾î »ìÆìº¸±â
emotional_text <- emotional_text %>% 
  mutate(sentiment = ifelse(polarity == 2, "pos", 
                            ifelse(polarity == -2, "neg", "neu"))) 

# ¾î¶² °¨Á¤ÀÌ ¸¹ÀÌ »ç¿ëµÇ¾ú³ª?
emotional_text %>%
  count(sentiment)

# ¸·´ë ±×·¡ÇÁ ¸¸µé±â
top10_sentiment <- emotional_text %>% 
  filter(sentiment != "neu") %>% 
  count(sentiment, word) %>% 
  group_by(sentiment) %>% 
  slice_max(n, n = 10) 
top10_sentiment 

ggplot(top10_sentiment, aes(x = reorder(word, n), 
                            y = n, 
                            fill = sentiment)) + 
  geom_col() + 
  coord_flip() + 
  geom_text(aes(label = n), hjust = -0.3) + 
  facet_wrap(~ sentiment, scales = "free") + 
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.15))) + 
  labs(x = NULL) + 
  theme(text = element_text(family = "nanumgothic"))

# ±àÁ¤ ´ñ±Û
score_df %>%
  arrange(desc(score)) 

# ºÎÁ¤ ´ñ±Û
score_df %>% 
  arrange(score) 

############### ÀÇ¹Ì¿¬°á¸Á ¸¸µé±â
if(!require("dplyr")){install.packages("dplyr"); library(dplyr)} 
if(!require("stringr")){install.packages("stringr"); library(stringr)} 
if(!require("textclean")){install.packages("textclean"); library(textclean)} 
if(!require("KoNLP")){install.packages("KoNLP"); library(KoNLP)} 
if(!require("readr")){install.packages("readr"); library(readr)} 
if(!require("tidytext")){install.packages("tidytext"); library(tidytext)} 


# ±â»ýÃæ ±â»ç ´ñ±Û ºÒ·¯¿À±â
raw_news_comment <- read_csv("news_comment_parasite.csv")
str(raw_news_comment)

news_comment <- raw_news_comment %>%
  select(reply) %>%
  mutate(reply = str_replace_all(reply, "[^°¡-ÆR]", " "), # ÇÑ±Û ÀÌ¿Ü´Â ºóÄ­
         reply = str_squish(reply), # ¿¬¼Ó°ø¹é Á¦°Å, ¹®Àå Ã³À½, ³¡ °ø¹é Á¦°Å
         id = row_number()) # Çà¸¶´Ù ¹øÈ£ Ãß°¡

comment_pos <- news_comment %>%
  unnest_tokens(input = reply,
                output = word,
                token = SimplePos22,
                drop = F)

comment_pos %>% 
  select(word, reply)

# -------------------------------------------------------------------------
# Ç°»çº°·Î Çà ºÐ¸®
if(!require("tidyr")){install.packages("tidyr"); library(tidyr)} 

comment_pos <- comment_pos %>%
  separate_rows(word, sep = "[+]")

comment_pos %>% 
  select(word, reply)

# -------------------------------------------------------------------------
# ¸í»ç ÃßÃâÇÏ±â
noun <- comment_pos %>%
  filter(str_detect(word, "/n")) %>%
  mutate(word = str_remove(word, "/.*$"))

noun %>%
  select(word, reply)

# -------------------------------------------------------------------------
noun %>%
  count(word, sort = T)

# -------------------------------------------------------------------------
# µ¿»ç, Çü¿ë»ç ÃßÃâÇÏ±â
pvpa <- comment_pos %>%
  filter(str_detect(word, "/pv|/pa")) %>%         # "/pv", "/pa" ÃßÃâ
  mutate(word = str_replace(word, "/.*$", "´Ù"))  # "/"·Î ½ÃÀÛ ¹®ÀÚ¸¦ "´Ù"·Î ¹Ù²Ù±â

pvpa %>%
  select(word, reply)

# -------------------------------------------------------------------------
pvpa %>%
  count(word, sort = T)

# -------------------------------------------------------------------------
# Ç°»ç °áÇÕ
comment <- bind_rows(noun, pvpa) %>%
  filter(str_count(word) >= 2) %>%
  arrange(id)

comment %>%
  select(word, reply)

# -------------------------------------------------------------------------
# ÄÚµå¸¦ ¸ð¾Æ¼­
comment_new <- comment_pos %>%
  separate_rows(word, sep = "[+]") %>%
  filter(str_detect(word, "/n|/pv|/pa")) %>%
  mutate(word = ifelse(str_detect(word, "/pv|/pa"),
                       str_replace(word, "/.*$", "´Ù"),
                       str_remove(word, "/.*$"))) %>%
  filter(str_count(word) >= 2) %>%
  arrange(id)


# -------------------------------------------------------------------------
if(!require("widyr")){install.packages("widyr"); library(widyr)} 

pair <- comment %>%
  pairwise_count(item = word,
                 feature = id,
                 sort = T)
pair

# -------------------------------------------------------------------------
pair %>% filter(item1 == "¿µÈ­")

pair %>% filter(item1 == "ºÀÁØÈ£")


# 05-2 --------------------------------------------------------------------
if(!require("tidygraph")){install.packages("tidygraph"); library(tidygraph)} 

graph_comment <- pair %>%
  filter(n >= 25) %>%
  as_tbl_graph()

graph_comment


# -------------------------------------------------------------------------
if(!require("ggraph")){install.packages("ggraph"); library(ggraph)} 

ggraph(graph_comment) +
  geom_edge_link() +                 # ¿§Áö
  geom_node_point() +                # ³ëµå
  geom_node_text(aes(label = name))  # ÅØ½ºÆ®

# -------------------------------------------------------------------------
if(!require("showtext")){install.packages("showtext"); library(showtext)} 

font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()

# -------------------------------------------------------------------------
set.seed(1234)                              # ³­¼ö °íÁ¤
ggraph(graph_comment, layout = "fr") +      # ·¹ÀÌ¾Æ¿ô
  geom_edge_link(color = "gray50",          # ¿§Áö »ö±ò
                 alpha = 0.5) +             # ¿§Áö ¸í¾Ï
  geom_node_point(color = "lightcoral",     # ³ëµå »ö±ò
                  size = 5) +               # ³ëµå Å©±â
  geom_node_text(aes(label = name),         # ÅØ½ºÆ® Ç¥½Ã
                 repel = T,                 # ³ëµå¹Û Ç¥½Ã
                 size = 5,                  # ÅØ½ºÆ® Å©±â
                 family = "nanumgothic") +  # ÆùÆ®
  theme_graph()                             # ¹è°æ »èÁ¦


# -------------------------------------------------------------------------
# ÇÔ¼ö·Î ¸¸µé¾î »ç¿ëÇØ º¾½Ã´Ù.
word_network <- function(x) {
  ggraph(x, layout = "fr") +
    geom_edge_link(color = "gray50",
                   alpha = 0.5) +
    geom_node_point(color = "lightcoral",
                    size = 5) +
    geom_node_text(aes(label = name),
                   repel = T,
                   size = 5,
                   family = "nanumgothic") +
    theme_graph()
}

# -------------------------------------------------------------------------
set.seed(1234)
word_network(graph_comment)

# -------------------------------------------------------------------------
# À¯ÀÇ¾î Ã³¸®ÇÏ±â
comment <- comment %>%
  mutate(word = ifelse(str_detect(word, "°¨µ¶") &
                         !str_detect(word, "°¨µ¶»ó"), "ºÀÁØÈ£", word), 
         word = ifelse(word == "¿À¸£´Ù", "¿Ã¸®´Ù", word),
         word = ifelse(str_detect(word, "ÃàÇÏ"), "ÃàÇÏ", word))

# ´Ü¾î µ¿½Ã ÃâÇö ºóµµ ±¸ÇÏ±â
pair <- comment %>%
  pairwise_count(item = word,
                 feature = id,
                 sort = T)

# ³×Æ®¿öÅ© ±×·¡ÇÁ µ¥ÀÌÅÍ ¸¸µé±â
graph_comment <- pair %>%
  filter(n >= 25) %>%
  as_tbl_graph()

# ³×Æ®¿öÅ© ±×·¡ÇÁ ¸¸µé±â
set.seed(1234)
word_network(graph_comment)

# -------------------------------------------------------------------------
# ¿¬°áÁß½É¼ºÀ» °è»êÇÏ°í Áý´ÜÀ¸·Î ±¸ºÐÇØ º¾½Ã´Ù.
set.seed(1234)
graph_comment <- pair %>%
  filter(n >= 25) %>%
  as_tbl_graph(directed = F) %>%
  mutate(centrality = centrality_degree(),        # ¿¬°á Áß½É¼º
         group = as.factor(group_infomap()))      # Ä¿¹Â´ÏÆ¼

graph_comment

# -------------------------------------------------------------------------
set.seed(1234)
ggraph(graph_comment, layout = "fr") +      # ·¹ÀÌ¾Æ¿ô
  geom_edge_link(color = "gray50",          # ¿§Áö »ö±ò
                 alpha = 0.5) +             # ¿§Áö ¸í¾Ï
  geom_node_point(aes(size = centrality,    # ³ëµå Å©±â
                      color = group),       # ³ëµå »ö±ò
                  show.legend = F) +        # ¹ü·Ê »èÁ¦
  scale_size(range = c(5, 15)) +            # ³ëµå Å©±â ¹üÀ§
  geom_node_text(aes(label = name),         # ÅØ½ºÆ® Ç¥½Ã
                 repel = T,                 # ³ëµå¹Û Ç¥½Ã
                 size = 5,                  # ÅØ½ºÆ® Å©±â
                 family = "nanumgothic") +  # ÆùÆ®
  theme_graph()                             # ¹è°æ »èÁ¦

# -------------------------------------------------------------------------
graph_comment %>%
  filter(name == "ºÀÁØÈ£")

# -------------------------------------------------------------------------
graph_comment %>%
  filter(group == 4) %>%
  arrange(-centrality) %>%
  data.frame()

graph_comment %>%
  arrange(-centrality)

# -------------------------------------------------------------------------
graph_comment %>%
  filter(group == 2) %>%
  arrange(-centrality) %>%
  data.frame()

# -------------------------------------------------------------------------
# ´Ü¾î°¡ »ç¿ëµÈ ¿ø¹®°ú ÇÔ²² ÀÌÇØÇÏ±â
news_comment %>%
  filter(str_detect(reply, "ºÀÁØÈ£") & str_detect(reply, "´ë¹Ú")) %>%
  select(reply)

news_comment %>%
  filter(str_detect(reply, "¹Ú±ÙÇý") & str_detect(reply, "ºí·¢¸®½ºÆ®")) %>%
  select(reply)

news_comment %>%
  filter(str_detect(reply, "±â»ýÃæ") & str_detect(reply, "Á¶±¹")) %>%
  select(reply)

# --------------------------------------------------------------------
# ÆÄÀÌ°è¼ö·Î ´Ü¾î°£ »ó°ü°ü°è ºÐ¼®
word_cors <- comment %>%
  add_count(word) %>%
  filter(n >= 20) %>%
  pairwise_cor(item = word,
               feature = id,
               sort = T)

word_cors

# -------------------------------------------------------------------------
word_cors %>% 
  filter(item1 == "´ëÇÑ¹Î±¹")

word_cors %>% 
  filter(item1 == "¿ª»ç")

# -------------------------------------------------------------------------
# °ü½É ´Ü¾î ¸ñ·Ï »ý¼º
target <- c("´ëÇÑ¹Î±¹", "¿ª»ç", "¼ö»ó¼Ò°¨", "Á¶±¹", "¹Ú±ÙÇý", "ºí·¢¸®½ºÆ®")

top_cors <- word_cors %>%
  filter(item1 %in% target) %>%
  group_by(item1) %>%
  slice_max(correlation, n = 8)

# -------------------------------------------------------------------------
# Å°¿öµåº°·Î ÆÄÀÌ°è¼ö°¡ ³ôÀº ´Ü¾î ±×¸®±â
if(!require("ggplot2")){install.packages("ggplot2"); library(ggplot2)} 

# ±×·¡ÇÁ ¼ø¼­ Á¤ÇÏ±â
top_cors$item1 <- factor(top_cors$item1, levels = target)

ggplot(top_cors, aes(x = reorder_within(item2, correlation, item1),
                     y = correlation,
                     fill = item1)) +
  geom_col(show.legend = F) +
  facet_wrap(~ item1, scales = "free") +
  coord_flip() +
  scale_x_reordered() +
  labs(x = NULL) +
  theme(text = element_text(family = "nanumgothic"))


# -------------------------------------------------------------------------
set.seed(1234)
graph_cors <- word_cors %>%
  filter(correlation >= 0.15) %>%
  as_tbl_graph(directed = F) %>%
  mutate(centrality = centrality_degree(),
         group = as.factor(group_infomap()))

# -------------------------------------------------------------------------
set.seed(1234)
ggraph(graph_cors, layout = "fr") +
  geom_edge_link(color = "gray50",
                 aes(edge_alpha = correlation,   # ¿§Áö ¸í¾Ï
                     edge_width = correlation),  # ¿§Áö µÎ²²
                 show.legend = F) +              # ¹ü·Ê »èÁ¦
  scale_edge_width(range = c(1, 4)) +            # ¿§Áö µÎ²² ¹üÀ§
  geom_node_point(aes(size = centrality,
                      color = group),
                  show.legend = F) +
  scale_size(range = c(5, 10)) +
  geom_node_text(aes(label = name),
                 repel = T,
                 size = 5,
                 family = "nanumgothic") +
  theme_graph()