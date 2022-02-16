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
This analysis uses the tidy approach elaborated in 'Text Mining with R' exploring the King James Version of the Bible.

### Old and new testament analysis
***
The Bible, a Jewish-Christian collection of books, consistis of the Old and New Testaments.

There is a very common sense about the strucuture of this testaments, for the old testament being a dark narative, fullfilled by war, sadness and sorrows. Otherwise, the new testament is joyfull most of the time.

The sentiment analysis tools of the data science can give us a taste, if not even prove hypotheses like the above.

In this approach, it was used the lexicans of English words rated for valence with an integer between minus five (negative) and plus five (positive). The words have been manually labeled by Finn Årup Nielsen in 2009-2011. Crossing the words from each book of the Bible with the "Afinn" lexican, there is the possibility to measure some kind of positivity of the texts e rank them by the sum of the score by book. In this analysis, the score was divided by the number of words of the respective book, so the lenght of the book shall not be a variable, and multiplied by 1000, to make the notation easier.

![](\sumarize_of_all_books.png "Fig 1")


By the colors spreading of this bar plot, it is intuitive to say that the new testament has books with highter scores than the old. In other words, there is more pleasant texts in the new testament, according to the afinn studies.

Of course, there is no possibility of just mine the text this type of scripture without taking account of the context. The original languages of this books are distant from our modern speech. They have many diferences in structure, number of words, oral tradition, etc...

### Romans analysis
***
In a conversation with a friend of mine some time ago, I listened this sentense: "The Romans epistle have a dramatic curve in its narative!". Dramatic curve is the "level of tension" during any exposion (movies, audios, books).
This argument make me curious about testing it with data mining.

Here some exemplo of a hipothetic dramatic curve:

![](https://magisterwernegren.files.wordpress.com/2017/11/dramatic-curve.jpg "Fig 2")

In this analysis, I used the same lexican of the old and new testament analysis (afinn), supposing that the negativity of the words have strong correlation with the tension of the reader.

Without surprising my friend, I plot a graphic that certainly show a curve:

![](\Romans_plot.png "Fig 3")

There's a climax in the chapters 6 and 7. Reading the text, we can find some words like adulteress, law, dead, death and so on. It is the really tense part of the epistle. If the lexican dispose any of this words, it may add some negative scores to this chapters.


## Final considerations
***
The sentimental analysis is attached with the object of the study. It can be a book, music, or tweets from any database, it will always demand some level of expertise from the data professional to extract the right information.

This simple analysis shows the data science applied in explore in the dramaturgy field.










