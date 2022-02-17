---
output:
  html_document:
    theme: yeti
    toc: yes
    toc_float: yes
  pdf_document: default
  word_document:
    toc: yes
---
## Bible Datamining
***
This analysis uses the tidy approach exploring the King James Version of the Bible by text mining with R.

### Old and new testament analysis
***
The Bible, a Jewish-Christian collection of books, consists of the Old and New Testaments.

There is a very common sense about the strucuture of these testaments - the old testament being a dark narrative, filled with war, sadness and sorrows. The new testament, however, is joyful most of the time.

The sentiment analysis tools of the data science can give us a taste or even prove hypotheses like the above.

In this approach, it was used the lexicans of English words rated for valence with an integer between minus five (negative) and plus five (positive). The words have been manually labeled by Finn Årup Nielsen in 2009-2011. Crossing the words of the Bible with the "Afinn" lexican, it is possible to measure the positivity of the texts and rank them by the sum of the scores from each book. In this analysis, the score was divided by the number of words of the respective book, so the length of the book shall not be a variable, and multiplied by 1000, to make the notation easier.

![](/sumarize_of_all_books.png "Fig 1")


By the color distribution of this bar plot, it is intuitive to say that the new testament has books with higher scores than the old testament. In other words, there are more pleasant texts in the new testament, according to the Afinn studies.

Of course, there is no possibility of just text mining this type of scripture without taking in account the context. The original languages of these books are distant from our modern speech. They have many differences in structure, number of words, oral tradition, etc.

### Romans analysis
***
In a conversation with a friend of mine some time ago, I heard this sentence: > "The Romans epistle has a dramatic curve in its narrative!".
Dramatic curve is the "level of tension" during any plot (movies, audios, books).
This argument made me curious about testing it with text mining.

Here is one example of a hypothetical dramatic curve:

![](https://magisterwernegren.files.wordpress.com/2017/11/dramatic-curve.jpg "Fig 2")

In this analysis, I used the same lexican of the old and new testament analysis - Afinn, supposing that the negativity of the words have strong correlation with the tension of the reader.

As no surprise to my friend, I plotted a graphic that may assure his opinion about the epistle:

![](/Romans_plot.png "Fig 3")

There's a climax around the chapters 6 and 7. Reading the text, we can find some words like adulteress, law, dead, death and so on. It is the most tense part of the epistle. If the lexican contains any of the previously mentioned words, it may have added some negative scores to those chapters.


## Final considerations
***
The sentimental analysis is attached to the object of the study. It can be a book, song, or tweets from any database, it will always demand some level of expertise from the data professional to extract the right information.

This simple analysis shows that data science can also be applied exploring the dramaturgy field.










