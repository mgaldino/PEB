library(readtext)
library(quanteda)
library(dplyr)
library(stringr)
library(ggplot2)
library(rworldmap)
library(RColorBrewer)
library(classInt)
library(vegan)
library(boot)
library(haven)
library(readxl)
library(texreg)
library(tidyverse)
#File path to UNGDC unzipped data archive
DATA_DIR <- "C:\\Users\\mczfe\\Documents\\Pessoal\\DCP\\Corpus UN\\Raw Data\\dataverse_files\\TXT"

ungd_files <- readtext(paste0(DATA_DIR, "/*"), 
                       docvarsfrom = "filenames", 
                       dvsep="_", 
                       docvarnames = c("Country", "Session", "Year"))

#Creating corpus
ungd_corpus <- corpus(ungd_files, text_field = "text") 

ntoken(ungd_corpus, remove_punct = TRUE)
#Creating corpus for 2014, for Wordscore example below
ungdc.2014 <- corpus_subset(ungd_corpus, Year==2014)

# resumindo dados
summarise(group_by(summary(ungd_corpus, n = 7314, verbose = FALSE),Year),
          mean(Types),mean(Tokens),
          mean(Sentences),min(Sentences),max(Sentences))
