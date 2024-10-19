#### Preamble ####
# Purpose: Simulate my US election data
# Author: Ruiyang Wang
# Date: Oct.18th 2024
# Contact: ruiyang.wang@mail.utoronto.ca
# License: None
# Pre-requisites: None
# Any other information needed? None

# Load necessary libraries
library(tidyverse)

# Load the real data (for reference)
data <- read_csv("data/02-analysis_data/analysis_data_morning_consult.csv")

# Set seed for reproducibility
set.seed(853)

# Create a simulated dataset
simulated_data <- tibble(
  poll_id = 1:1000,  # Simulate 1000 polls
  answer = sample(
    unique(data$answer), 
    size = 1000, 
    replace = TRUE
  ),
  pollscore = runif(1000, min = min(data$pollscore, na.rm = TRUE), max = max(data$pollscore, na.rm = TRUE)),
  sample_size = sample(500:3000, size = 1000, replace = TRUE),  # Random sample sizes between 500 and 3000
  pct = runif(1000, min = 40, max = 60),  # Simulated percentage support
  stage = sample(
    unique(data$stage),
    size = 1000,
    replace = TRUE
  ),
  transparency_score = runif(1000, min = min(data$transparency_score, na.rm = TRUE), max = max(data$transparency_score, na.rm = TRUE)),
  numeric_grade = runif(1000, min = min(data$numeric_grade, na.rm = TRUE), max = max(data$numeric_grade, na.rm = TRUE)),
  end_date = sample(
    seq(as.Date("2024-01-01"), as.Date("2024-11-01"), by = "day"),
    size = 1000,
    replace = TRUE
  ),
  ranked_choice_reallocated = sample(c(TRUE, FALSE), size = 1000, replace = TRUE, prob = c(0.1, 0.9))
)

# View the first few rows of the simulated data
head(simulated_data)

# Save the simulated data to a CSV file
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
