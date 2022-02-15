library(tidyverse)
library(stringr)
library(readr)

#mudando para diret?rio com o arquivo que cont?m o arquivo de texto
setwd("C:/Users/Eduardo/projects/bible/project_text_mining")
getwd() #checar o diret?rio certo
list.files() #checar se o arquivo est? nesse diret?rio


#Lendo o arquivo com a b?blia em bloco de notas
filename <- "kjvdat.txt"
fullpath <- file.path(getwd(), filename)
file.exists(filename) #existe um arquivo chamado "kjvdat.txt" no path "~/../projects/..."

#teste
read_lines("kjvdat.txt", n_max = 3) #prmeiras linhas

#criando tidy data
bible_delim <- read_delim(filename, "|") %>%
  setNames(c("Book", "Chapter", "Verse", "Text")) #delimita??o de coluna pelo "|" e nomes


bible_delim[which.max(nchar(bible_delim$Text)),1:4] %>% print() #maior versículo em número de caracteres na versão kj 1611

#Achando linhas em que acaba o velho testamento e come?a o novo
bible_delim[which(bible_delim$Book == "Mat")] #erro = na posi??o 1 tem index = 23146
bible_delim[23146,1:4] # primeiro cap de mateus
bible_delim[23145,1:4] # ?ltimo vers?culo de malaquias
nrow(bible_delim) #N?mero de vers?culos da b?blia

#criando coluna com os testamentos

Testament <- c(rep("Old", 23145), rep("New", length = 31102-23145)) %>%
  setNames(c("Testament"))
length(Testament) # 31102 = n?mero de vers?culos da b?blia

#agrupando as colunas da b?blia com o testamento respectivo de cada livro e transformando em fator
bible_w_testament <- bind_cols(bible_delim, as_tibble(Testament)) %>%
  as.data.frame() %>% mutate(Testament = factor(value)) %>% select(1:4,6)

#adicionando uma coluna com a soma do n?mero de palavras por livro
bible_w_testament <- bible_w_testament %>% group_by(Book) %>% mutate(n_words_by_books = sum(str_count(Text) - 1))
# "-1" ? porque o texto tinha um "~" no fim de cada linha

### An?lise de sentimentos
library(SentimentAnalysis)
library(tidytext)

nrc<-get_sentiments("nrc") # l?xico com 10 tipos de sentimento
afinn<-get_sentiments("afinn") # l?xico que pontua entre -5 e +5 cada palavra

#todas as palavras da b?blia sem contar stop_words
#precisa desagrupar por livro porque se n?o o c?digo deixa apenas o livro de G?nesis.
All_bible_words <- bible_w_testament %>% ungroup(Book) %>%
  unnest_tokens(word, Text) %>% filter(!word %in% stop_words$word)

#inner join de todas as palavras da b?blia com as palavras do lexico "afinn"
Bible_afinn <- All_bible_words %>% filter(word %in% afinn$word)

#colagem de coluna de valores do l?xico "afinn"
#n?o consegui fazer tudo com o pipeline (melhorar)
Bible_afinn <- left_join(Bible_afinn, afinn, by = "word") # same as Bible_afinn w the value column

#resumindo pontua??es totais por livro segundo o l?xico "afinn"
book_by_values <- Bible_afinn %>% 
  group_by(Book) %>%
  mutate(All_values = sum(value),
         mean_score = All_values/n_words_by_books*1000) %>%
  arrange(mean_score) %>%
  book_by_values[,c(1,4,5,8:9)] %>% distinct()
#criei uma m?trica na coluna mean_score para que a pontua??o leve em conta a diferen?a de n?mero de palavras entre os livros

#criando um df resumido com as pontua??es de cada livro e a m?dia de pontua??o por cap?tulo (melhorar)
distinct_score_bible_books <- book_by_values[,c(1,4,5,8:9)] %>% distinct()

### Gr?ficos
library(ggplot2)

#plotando um gr?fico de barras com os livros por ordem crescente por pontua??o segundo o l?xico "afinn".
distinct_score_bible_books %>% ungroup(Book) %>%
  mutate(Book = reorder(Book, mean_score)) %>%
  ggplot(aes(label = Book,x=Book, y = mean_score)) +
  theme_minimal(base_size = 8) +
  geom_bar(stat='identity',aes(fill = Testament),width=.7) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  xlab("Books") + ylab('Score') +
  labs(subtitle="A sentiment analisys of the Bible books", 
       title= "AFINN SCORE", x = "Books") +
  scale_y_continuous(limits = c(-10,20), breaks = seq(-10,20,2)) +
  scale_fill_manual(values = c("firebrick", "dodgerblue4")) +
  coord_flip()


##Romans
Romans_analysis_chapter <- Bible_afinn %>% filter(Book == "Rom") %>%
  group_by(Chapter) %>% summarize(All_values = sum(value)) %>%
  mutate(acumulado = cumsum(All_values)) %>%
  arrange(Chapter)


Romans_analysis_chapter %>% group_by(Chapter) %>%
  ggplot(aes(label = Chapter)) +
  geom_line(aes(x = Chapter, y = All_values)) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  xlab("Chapter") + ylab('\"AFINN" SCORE') +
  scale_y_reverse()
  
###B?NUS###
#inner join de todas as palavras da b?blia com as palavras do lexico "afinn"
Bible_nrc <- All_bible_words %>% filter(word %in% nrc$word) %>%
  left_join(nrc, by = "word") #b?blia com tolken e junto com o nrc
head(Bible_nrc,10) %>% select(1:3,6,7)
# nrc ? um l?xico problem?tico pois possui muitos sentimentos associados ? mesma palavra
# E a an?lise precisa levar em conta contexto para ser acertiva quanto ? sem?ntica.


