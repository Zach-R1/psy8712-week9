# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(rvest)
library(tidyverse)

sections <- list(
  Business = "https://www.cnbc.com/business/",
  Investing = "https://www.cnbc.com/investing/",
  Tech = "https://www.cnbc.com/technology/",
  Politics = "https://www.cnbc.com/politics/"
)

section_names <- names(sections)

cnbc_list <- list()

for(i in seq_along(sections)) {
  url <- sections[[i]]
  page <- read_html(url)
  headlines <- html_text(html_elements(page, ".Card-title"))
  cnbc_list[[i]] <- tibble(
    headline = headlines,
    length = sapply(strsplit(headlines, "\\s+"), length),
    source = section_names[i]
  )
}



#Data Import and Cleaning

# Analysis

# Visualization

# Publication