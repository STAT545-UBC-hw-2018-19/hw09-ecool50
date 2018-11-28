#load required libraries
library(tidyverse)

#load in the words text document
words <- readLines("words.txt")

#compute the prefixes
words_pre <- str_sub(words, start = 1, end = 3)

#convert it into a dataframe
prefix_data <- as.tibble(words_pre)

#get the top 30
top_30 <- plyr::count(prefix_data)  %>% top_n(30)

#get the frequencie for all the prefixes
all_freq <- plyr::count(prefix_data)

#write it to a tsv for later visualization
write.table(top_30, file = "top_30_prefixes.tsv", sep = "\t")

#write all the prefixes to a table
write.table(all_freq, file = "All_frequencies.tsv", sep = "\t")
