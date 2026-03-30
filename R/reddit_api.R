# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(RedditExtractoR)
library(tidyverse)
#lib

# Data Import and Cleaning
urls_tbl <- find_thread_urls(
  subreddit = "rstats",
  sort_by = "new",
  period = "month"
)

content <- get_thread_content(urls_tbl$url)

rstats_tbl <- content$threads %>%
  select(post = title, upvotes, comments)

# Visualization

rstats_tbl %>%
  ggplot(aes(upvotes, comments)) +
  geom_point(alpha = 0.3, position = "jitter") +
  geom_smooth(method = "lm") +
  labs(x = "Upvotes", y = "Comments", title = "Relationship Between upvotes and comments")

# Analysis
cor <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)
cor

# Publication
paste0("The correlation between upvotes and comments was r(", cor$parameter, ") = ", cor$estimate, ", p = ", cor$p.value, ". This test ", ifelse(cor$p.value < 0.05, "was", "was not") ," statistically significant.")
