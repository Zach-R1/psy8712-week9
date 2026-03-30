# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(RedditExtractoR)
library(tidyverse)

# Data Import and Cleaning

# Sent Get request via RedditExtractor for urls with required parameters. Sent Get for content and I believe I lost some data, but after trying multiple other ways I went with the suboptimal but working code. Selected requested metadata and renamed title to post

urls_tbl <- find_thread_urls(
  subreddit = "rstats",
  sort_by = "new",
  period = "month"
)

content <- get_thread_content(urls_tbl$url)

rstats_tbl <- content$threads %>%
  select(post = title, upvotes, comments)

# Visualization

# Plotted upvotes and comments. Added transparency and jitter which helped a little with overlap, but given the nature of the data clustering in the bottom left is to be expected. Added regression line to show relationship, default CI maintained due to personal preference.
rstats_tbl %>%
  ggplot(aes(upvotes, comments)) +
  geom_point(alpha = 0.3, position = "jitter") +
  geom_smooth(method = "lm") +
  labs(x = "Upvotes", y = "Comments", title = "Relationship Between upvotes and comments")

# Analysis

#Not much to say here. Used cor.test to calculate desired stats
cor <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)
cor

# Publication
#"The correlation between upvotes and comments was r(298) = .49, p = . This test was statistically significant."

# Followed display rules regardless of values as instructed, but for the p-value I really don't like it becuase it's small enough that nothing winds up displayed under these rules. Degrees of freedom already has no decimal displayed no changes needed. Used paste0 to concatenate text and dynamic entries. Used sub to remove leading zeros and ifelse to dynamically select was/was not significant
paste0("The correlation between upvotes and comments was r(", cor$parameter, ") = ", sub("^0", "", round(cor$estimate, 2)), ", p = ", sub("^0", "", round(cor$p.value, 2)), ". This test ", ifelse(cor$p.value < 0.05, "was", "was not") ," statistically significant.")
