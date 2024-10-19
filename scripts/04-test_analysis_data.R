#### Preamble ####
# Purpose: Explore my data
# Author: Ruiyang Wang
# Date: Oct.18th 2024
# Contact: ruiyang.wang@mail.utoronto.ca
# License: None
# Pre-requisites: None
# Any other information needed? None

# Load necessary library
library(dplyr)
library(readr)

# Load the dataset
data <- read_csv("~/STA304 Paper2/data/02-analysis_data/analysis_data_morning_consult.csv")

# 1. Count the number of NAs in each column
na_counts <- colSums(is.na(data))
print(na_counts)
#The result is all 0.

# 2. Test for outliers using the IQR method (e.g., 'pct' for support percentage)
Q1 <- quantile(data$pct, 0.25, na.rm = TRUE)
Q3 <- quantile(data$pct, 0.75, na.rm = TRUE)
IQR_value <- Q3 - Q1
test_outliers <- any(data$pct < (Q1 - 1.5 * IQR_value) | data$pct > (Q3 + 1.5 * IQR_value))
print(paste("Outliers present in pct:", test_outliers))

# 3. Test if all values in 'sample_size' are valid(>0)
test_value_range <- all(data$sample_size > 0, na.rm = TRUE)
print(paste("All sample_size values are non-negative:", test_value_range))

# 4. Test for data type consistency (e.g., if all values in 'sample_size' are numeric)
test_data_type <- all(sapply(data$sample_size, is.numeric))
print(paste("All sample_size values are numeric:", test_data_type))
