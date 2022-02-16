library(tidyverse)
library(stringr)
library(readr)

#seting the directory to find the text
setwd("C:/Users/Eduardo/projects/bible/project_text_mining/Bible_Datamining")
getwd() #check the right directory
list.files() #check list


#Reading the text note
filename <- "kjvdat.txt"
fullpath <- file.path(getwd(), filename)
file.exists(filename) #there's a file named "kjvdat.txt" in the path "~/../projects/..."

#test
read_lines("kjvdat.txt", n_max = 3)

#creating tidy data
bible_delim <- read_delim(filename, "|") %>%
  setNames(c("Book", "Chapter", "Verse", "Text")) #separating the columns by the "|" sign


bible_delim[which.max(nchar(bible_delim$Text)),1:4] %>% print() %>% 
  pull() #the biggest verse in the kj 1611 version

#Finding the limit between old and new testement
bible_delim[which(bible_delim$Book == "Mat")] #error in the position index = 23146
bible_delim[23146,1:4] # First Mathew index
bible_delim[23145,1:4] # last Malachi index
nrow(bible_delim) #Length of indexes = number of verses in the bible

#Creating a vector of textament

Testament <- c(rep("Old", 23145), rep("New", length = 31102-23145)) %>%
  setNames(c("Testament"))
length(Testament) # 31102 = number of verses in the bible

#Biding the columns of the testament and the bible
bible_w_testament <- bind_cols(bible_delim, as_tibble(Testament)) %>%
  as.data.frame() %>% mutate(Testament = factor(value)) %>% select(1:4,6)

#adding the collumn with the sum of the words per book
bible_w_testament <- bible_w_testament %>% group_by(Book) %>% mutate(n_words_by_books = sum(str_count(Text) - 1))
# "-1" Because there is a "~" in the end of each verse

### Sentiment Analysis
library(SentimentAnalysis)
library(tidytext)

nrc<-get_sentiments("nrc") # 10 groups os sentiment lexican
afinn<-get_sentiments("afinn") # scores from -5 to +5 lexican

#All the words of the bible, without the stop-words
All_bible_words <- bible_w_testament %>% ungroup(Book) %>%
  unnest_tokens(word, Text) %>% filter(!word %in% stop_words$word)

#inner join between the bible and the afinn dictionary
Bible_afinn <- All_bible_words %>% filter(word %in% afinn$word)

#Column bind (improve)
Bible_afinn <- left_join(Bible_afinn, afinn, by = "word") # same as Bible_afinn with the value column

#summarizing total score per book, with afin lexican
book_by_values <- Bible_afinn %>% 
  group_by(Book) %>%
  mutate(All_values = sum(value),
         mean_score = All_values/n_words_by_books*1000) %>%
  arrange(mean_score)
#Creates a column named mean_score, that takes into account the number of words in each book

#Creating an ordered df that summarize the total score of each book (improve)
distinct_score_bible_books <- book_by_values[,c(1,4,5,8:9)] %>% distinct()

### Graphics
library(ggplot2)

#Plot a bar graphic with the afinn lexican score of each book in the bible, in ascending order
distinct_score_bible_books %>% ungroup(Book) %>%
  mutate(Book = reorder(Book, mean_score)) %>%
  ggplot(aes(label = Book,x=Book, y = mean_score)) +
  theme_minimal(base_size = 8) +
  geom_bar(stat='identity',aes(fill = Testament),width=.7) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  xlab("Books") + ylab('Score') +
  labs(subtitle="A sentiment analysis of the Bible books", 
       title= "AFINN SCORE", x = "Books") +
  scale_y_continuous(limits = c(-10,20), breaks = seq(-10,20,2)) +
  scale_fill_manual(values = c("firebrick", "dodgerblue4")) +
  coord_flip()


##Romans
Romans_analysis_chapter <- Bible_afinn %>% filter(Book == "Rom") %>%
  group_by(Chapter) %>% summarize(All_values = sum(value)) %>%
  arrange(Chapter)


Romans_analysis_chapter %>% group_by(Chapter) %>%
  ggplot(aes(label = Chapter)) +
  geom_smooth(aes(x = Chapter, y = All_values), method="loess", se=F) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  theme_minimal(base_size = 10) +
  labs(subtitle="A sentiment analysis of the Romans epistle", 
       title= "AFINN SCORE", x = "Chapter",y ='Score') +
  scale_y_reverse()
  
###BONUS###
#inner join de todas as palavras da b?blia com as palavras do lexico "afinn"
Bible_nrc <- All_bible_words %>% filter(word %in% nrc$word) %>%
  left_join(nrc, by = "word") #b?blia com tolken e junto com o nrc
head(Bible_nrc,10) %>% select(1:3,6,7)
#nrc is a problematic lexican, there is more than one sentiment associated to the same word
# The analysis might see the context of the words to be more assertive


