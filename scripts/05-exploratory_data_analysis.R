#### Preamble ####
# Purpose: Explore my data
# Author: Ruiyang Wang
# Date: Oct.18th 2024
# Contact: ruiyang.wang@mail.utoronto.ca
# License: None
# Pre-requisites: None
# Any other information needed? None

install.packages("knitr")
install.packages("kableExtra")
install.packages("readr")
# Load necessary libraries
library(dplyr)
library(ggplot2)
library(readr)
library(knitr)
library(kableExtra)

# Load your data (update with your actual file path)
df_morning_consult <- read_csv("~/STA304 Paper2/data/02-analysis_data/analysis_data_relevant_full.csv")

# Bar plot for average support percentage by candidate (answer)
ggplot(df_morning_consult, aes(x = reorder(answer, pct), y = pct)) +
  stat_summary(fun = "mean", geom = "bar", fill = "skyblue") +  # Replace fun.y with fun
  labs(title = "Average Support Percentage by Candidate (answer)",
       x = "Candidate", y = "Average Support (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))  # Center the title

# Count the number of polls conducted for each candidate
poll_count_per_candidate <- df_morning_consult %>%
  count(answer, name = "Poll Count")

# Bar plot for the number of polls conducted for each candidate
ggplot(poll_count_per_candidate, aes(x = reorder(answer, -`Poll Count`), y = `Poll Count`)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Number of Polls Conducted by Candidate (answer)",
       x = "Candidate", y = "Number of Polls") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))  # Center the title