# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(rvest)
library(tidyverse)


# Data Import and Cleaning

sections <- list( #Create list with names and urls
  Business = "https://www.cnbc.com/business/",
  Investing = "https://www.cnbc.com/investing/",
  Tech = "https://www.cnbc.com/technology/",
  Politics = "https://www.cnbc.com/politics/"
)
# Extract names from above list and store for assignment
section_names <- names(sections)

cnbc_list <- list() # Create empty list

for(i in seq_along(sections)) { # Lopp over each section in sections
  url <- sections[[i]] # Extract URL from section
  page <- read_html(url) # Parse page HTML
  headlines <- html_text(html_elements(page, ".Card-title")) # Find all elements with class .Card-title and extracts text
  cnbc_list[[i]] <- tibble( # Create tibble
    headline = headlines,
    length = sapply(strsplit(headlines, "\\s+"), length), #split headlines and count length
    source = section_names[i] # Labels headlines with source
  )
}

cnbc_tbl <- bind_rows(cnbc_list) # Combinds previously created tibbles

# Visualization
cnbc_tbl %>%
  ggplot(aes(source, length)) +
  geom_boxplot() + # Best option for on discrete and once continous variable as it provides the most information.
  labs(title = "Comparison of headline length by section")


# Analysis
anova_model <- aov(length ~ source, data = cnbc_tbl) # Standard ANOVA

# Publication

# "The results of an ANOVA comparing lengths across sources was F(3, 130) = 2.98, p = .03. This test  statistically significant."

aov_sum <- summary(anova_model) # Pull summary 
aov_tbl <- aov_sum[[1]] # Extract table 


# Degrees of freedom already has no decimal displayed no changes needed. Used paste0 to concatenate text and dynamic entries. Used sub to remove leading zeros and ifelse to dynamically select was/was not significant

paste0("The results of an ANOVA comparing lengths across sources was F(", aov_tbl[1, "Df"], ", ", aov_tbl[2, "Df"], ") = ",round(aov_tbl$'F'[1], 2), ", p = ", sub("^0", "", round(aov_tbl$'Pr(>F)'[1], 2)), ". This test ", ifelse(aov_tbl$p.value < 0.05, "was", "was not") ," statistically significant.")
