#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Australian 
  #electoral divisions dataset.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


# Load necessary library
library(dplyr)
library(readr)

# Load the dataset
data <- read_csv("~/STA304 Paper2/data/00-simulated_data/simulated_data.csv")

# 1. Count the number of NAs in each column
na_counts <- colSums(is.na(data))
print(na_counts)
#The result is all 0.

# 2. Test for duplicate rows in the dataset
test_duplicate_rows <- any(duplicated(data))
print(paste("Duplicate rows present:", test_duplicate_rows))

# 3. Test for outliers using the IQR method (e.g., 'pct' for support percentage)
Q1 <- quantile(data$pct, 0.25, na.rm = TRUE)
Q3 <- quantile(data$pct, 0.75, na.rm = TRUE)
IQR_value <- Q3 - Q1
test_outliers <- any(data$pct < (Q1 - 1.5 * IQR_value) | data$pct > (Q3 + 1.5 * IQR_value))
print(paste("Outliers present in pct:", test_outliers))

# 4. Test if all values in 'sample_size' are valid(>0)
test_value_range <- all(data$sample_size > 0, na.rm = TRUE)
print(paste("All sample_size values are non-negative:", test_value_range))

# 5. Test for data type consistency (e.g., if all values in 'sample_size' are numeric)
test_data_type <- all(sapply(data$sample_size, is.numeric))
print(paste("All sample_size values are numeric:", test_data_type))

}