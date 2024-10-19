#### Preamble ####
# Purpose: Clean the data to things that I only need
# Author: Ruiyang Wang
# Date: Oct.18th 2024
# Contact: ruiyang.wang@mail.utoronto.ca
# License: None
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)

# Load the raw data
raw_data <- read.csv("~/STA304 Paper2/data/01-raw_data/raw_data.csv")

# Select relevant columns
relevant_columns <- c("pollscore", "pct",
                      "pollster", 
                      "answer", "end_date", "sample_size",
                      "transparency_score")

# Subset the data to include only the relevant columns and remove NAs
analysis_data <- raw_data[, relevant_columns, drop = FALSE]
analysis_data <- na.omit(analysis_data)

# Save the first CSV
write.csv(analysis_data, "~/STA304 Paper2/data/02-analysis_data/analysis_data_relevant_full.csv", row.names = FALSE)

# Filter data to include only "Morning Consult" pollster
morning_consult_data <- analysis_data[analysis_data$pollster == "Morning Consult", ]

# Remove NAs from the morning_consult_data
morning_consult_data <- na.omit(morning_consult_data)  # Or use drop_na() from tidyverse

# Save the second CSV with only "Morning Consult" data
write.csv(morning_consult_data, "~/STA304 Paper2/data/02-analysis_data/analysis_data_morning_consult.csv", row.names = FALSE)



