#### Preamble ####
# Purpose: Replicate simulation code and model code
# Author: Ruiyang Wang
# Date: Oct.18th 2024
# Contact: ruiyang.wang@mail.utoronto.ca
# License: None
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####

install.packages("knitr")
install.packages("kableExtra")
install.packages("readr")
# Load necessary libraries
library(dplyr)
library(ggplot2)
library(readr)
library(knitr)
library(kableExtra)
library(MASS)


#Exploratory data analysis
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




#model of data
# Does sample size affect the support percentage?
# Load the dataset
data <- read_csv("~/STA304 Paper2/data/02-analysis_data/analysis_data_relevant_full.csv")

# Filter data to include only the top 5 candidates
top_5_answers <- data %>%
  count(answer, sort = TRUE) %>%
  top_n(5, n) %>%
  pull(answer)

# Filter data to include only the top 5 candidates
filtered_data <- data %>%
  filter(answer %in% top_5_answers)

# Calculate the average sample size for each candidate
average_sample_size <- filtered_data %>%
  group_by(answer) %>%
  summarise(Average_Sample_Size = mean(sample_size, na.rm = TRUE))

# Use knitr::kable() to create a nicely formatted table
average_sample_size %>%
  kable(col.names = c("Candidate", "Average Sample Size"), 
        caption = "Average Sample Size for Top 5 Candidates")





# SLR for sample size vs. pct
# Load necessary libraries
library(ggplot2)
library(dplyr)
library(MASS)

# Load the dataset
filtered_data <- data %>%
  filter(answer %in% top_5_answers)
# Perform Log transformation for each candidate
for (candidate in unique(filtered_data$answer)) {
  # Filter data for the current candidate
  candidate_data <- filtered_data %>% filter(answer == candidate)
  
  # Apply log transformation to sample_size (adding 1 to avoid log(0))
  candidate_data$log_sample_size <- log(candidate_data$sample_size + 1)
  
  # Fit the simple linear regression model (pct ~ log(sample_size))
  log_model <- lm(pct ~ log_sample_size, data = candidate_data)
  
  # Plot the regression line for log(Sample Size) vs pct
  p <- ggplot(candidate_data, aes(x = log_sample_size, y = pct)) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE, color = "blue") +
    labs(title = paste("Log Transformed SLR for", candidate, "- Log(Sample Size) vs pct"),
         x = "Log(Sample Size)", y = "Support Percentage (%)") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))  # Center the title
  
  # Print the plot for Trump and Harris
  print(p)
  
  # Print the summary of the model with the log-transformed sample size
  print(summary(log_model))
}





#R square value for top 5 candidates
# Filter data to include only the top 5 candidates (assume 'top_5_answers' contains the names of the top 5 candidates)
top_5_answers <- data %>%
  count(answer, sort = TRUE) %>%
  top_n(5, n) %>%
  pull(answer)

# Filter data to include only the top 5 candidates
filtered_data <- data %>%
  filter(answer %in% top_5_answers)

# Initialize a data frame to store R-squared values
r_squared_comparison <- data.frame(
  candidate = character(),
  variable = character(),
  r_squared = numeric(),
  stringsAsFactors = FALSE
)

# Perform SLR with 'sample_size' for each candidate
for (candidate in unique(filtered_data$answer)) {
  # Filter data for the current candidate
  candidate_data <- filtered_data %>% filter(answer == candidate)
  
  #### SLR with sample_size ####
  sample_size_model <- lm(pct ~ sample_size, data = candidate_data)
  
  # Store R-squared value for sample_size
  r_squared_comparison <- r_squared_comparison %>%
    add_row(candidate = candidate, variable = "sample_size", r_squared = summary(sample_size_model)$r.squared)
  
  # Print the summary of the sample_size model
  cat("\nSummary for sample_size model (Candidate:", candidate, ")\n")
  print(summary(sample_size_model))
}

# Compare the R-squared values for sample_size
cat("\nR-squared Comparison for sample_size:\n")
print(r_squared_comparison)

# Plot comparison of R-squared values (sample_size only)
ggplot(r_squared_comparison, aes(x = candidate, y = r_squared, fill = candidate)) +
  geom_bar(stat = "identity") +
  labs(title = "R-squared Values for Sample Size (Top 5 Candidates)", 
       x = "Candidate", 
       y = "R-squared Value") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  # Center the title









#MLR:pct ~ pollscore + log_sample_size + transparency_score for top 5 candidates
# Filter top 5 most frequent candidates in the 'answer' column
top_5_answers <- data %>%
  count(answer, sort = TRUE) %>%
  top_n(5, n) %>%
  pull(answer)

# Filter the data to include only the top 5 candidates
top_data <- data %>%
  filter(answer %in% top_5_answers)

# Log-transform the sample_size variable (adding 1 to avoid log(0))
top_data <- top_data %>%
  mutate(log_sample_size = log(sample_size + 1))

# List to store models
candidate_models <- list()

# Fit a separate linear model for each candidate
for (candidate in top_5_answers) {
  # Filter data for the current candidate
  candidate_data <- top_data %>% filter(answer == candidate)
  
  # Fit the linear model for the current candidate
  candidate_model <- lm(sqrt(pct) ~ pollscore + log_sample_size + transparency_score, data = candidate_data)
  
  # Store the model in the list
  candidate_models[[candidate]] <- candidate_model
  
  # Print the summary of the model
  cat("\n\nSummary for Candidate:", candidate, "\n")
  print(summary(candidate_model))
  
  # Plot Residuals vs Fitted for the current model
  plot(candidate_model, which = 1, main = paste("Residuals vs Fitted -", candidate))
}






# Define a regular expression for MM/DD/YY format (where each part has at most 2 digits)
date_pattern <- "^\\d{1,2}/\\d{1,2}/\\d{1,2}$"

# Filter the rows where 'end_date' matches the MM/DD/YY format
filtered_data <- top_data %>%
  filter(grepl(date_pattern, end_date))

# Convert the 'end_date' to Date format, assuming the year is 2024
filtered_data <- filtered_data %>%
  mutate(end_date = as.Date(paste0(end_date, "24"), format = "%m/%d/%y"))

# Filter out any data before 2024
filtered_data <- filtered_data %>%
  filter(year(end_date) == 2024)

# Generate the date for prediction end (Nov 5th, 2024)
prediction_end_date <- as.Date("2024-11-05")

# Initialize a list to store predictions
candidate_predictions <- list()

# Fit separate linear models for each candidate and make predictions
for (candidate in top_5_answers) {
  # Filter data for the current candidate
  candidate_data <- filtered_data %>% filter(answer == candidate)
  
  # Fit a linear model for the current candidate
  candidate_model <- lm(sqrt(pct) ~ pollscore + log_sample_size + transparency_score + end_date, data = candidate_data)
  
  # Generate predictions for the current candidate
  candidate_data <- candidate_data %>%
    mutate(predicted_pct = (predict(candidate_model))^2)  # Inverse the sqrt transformation for actual support percentage
  
  # Add predictions up to Nov 5th, 2024
  future_prediction <- data.frame(
    end_date = prediction_end_date,
    pollscore = mean(candidate_data$pollscore),  # Example: using the mean of pollscore
    log_sample_size = mean(candidate_data$log_sample_size),  # Example: using the mean of log_sample_size
    transparency_score = mean(candidate_data$transparency_score),  # Example: using the mean of transparency_score
    answer = candidate
  )
  
  future_prediction <- future_prediction %>%
    mutate(predicted_pct = (predict(candidate_model, newdata = future_prediction))^2)
  
  # Combine the current candidate's data with future prediction
  candidate_predictions[[candidate]] <- bind_rows(candidate_data, future_prediction)
}

# Combine all the separate predictions into one dataframe
combined_predictions <- bind_rows(candidate_predictions)

# Find the latest date (including prediction date)
max_date <- max(combined_predictions$end_date)

# Create the final prediction graph (without emphasizing the winner)
ggplot(combined_predictions, aes(x = end_date, y = predicted_pct, color = answer, group = answer)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(title = "Predicted Support Percentage Over Time for Top 5 Candidates", 
       x = "Date", y = "Predicted Support Percentage (%)") +
  scale_x_date(limits = c(as.Date("2024-01-01"), prediction_end_date)) +  # Limit range to 2024
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  # Center the title


#save as RDS

save_path <- "~/STA304 Paper2/models"

# 1. Save the filtered data (top 5 candidates) as RDS
saveRDS(filtered_data, file = file.path(save_path, "filtered_data_top_5.rds"))

# 2. Save the average sample size results as RDS
saveRDS(average_sample_size, file = file.path(save_path, "average_sample_size_top_5.rds"))

# 3. Save the candidate models (Multiple Linear Regression) as RDS
saveRDS(candidate_models, file = file.path(save_path, "candidate_models_top_5.rds"))

# 4. Save the R-squared values comparison as RDS
saveRDS(r_squared_comparison, file = file.path(save_path, "r_squared_comparison_top_5.rds"))

# 5. Save the combined predictions (support percentage over time) as RDS
saveRDS(combined_predictions, file = file.path(save_path, "predicted_support_top_5.rds"))
