#Install the necessary libraries
install.packages("ggplot2")
install.packages("haven")
install.packages("dplyr")

# Loading the necessary libraries
library(haven)
library(ggplot2)
library(dplyr)

#1. Data Loading and Mortality Rate Calculation:

# Loading the dataset from GitHub
url <- "https://raw.githubusercontent.com/reifjulian/driving/main/data/mortality/derived/all.dta"
data <- read_dta(url)

# Filtering the data for 1–24 months above and below MLDA
below_mlda <- data[data$agemo_mda >= -24 & data$agemo_mda <= -1, ]
above_mlda <- data[data$agemo_mda >= 1 & data$agemo_mda <= 24, ]

# Calculating mortality rates (deaths per 100,000 person-years)
below_mlda$mortality_rate <- (below_mlda$cod_any / (below_mlda$pop / 12)) * 100000
above_mlda$mortality_rate <- (above_mlda$cod_any / (above_mlda$pop / 12)) * 100000

# Computing average mortality rates for each group
avg_below <- mean(below_mlda$mortality_rate, na.rm = TRUE)
avg_above <- mean(above_mlda$mortality_rate, na.rm = TRUE)

# Results 
cat("Average Mortality Rate (Below MLDA):", avg_below, "\n")
cat("Average Mortality Rate (Above MLDA):", avg_above, "\n")
cat("Difference in Mortality Rates:", avg_above - avg_below, "\n")

#2. Scatter Plot Creation

# Filtering data for individuals within 2 years of MLDA
filtered_data <- data[data$agemo_mda >= -24 & data$agemo_mda <= 24, ]

# Calculating the mortality rates for any cause and motor vehicle accidents
filtered_data$mortality_rate_any <- (filtered_data$cod_any / (filtered_data$pop / 12)) * 100000
filtered_data$mortality_rate_mva <- (filtered_data$cod_MVA / (filtered_data$pop / 12)) * 100000

# Creating the scatter plot
plot <- ggplot(filtered_data, aes(x = agemo_mda)) +
  # Adding points for any cause of mortality
  geom_point(aes(y = mortality_rate_any), shape = 15, color = "black", size = 3) +
  # Adding points for motor vehicle accident mortality
  geom_point(aes(y = mortality_rate_mva), shape = 16, color = "blue", size = 3) +
  # Adding vertical line at MLDA threshold (cutoff)
  geom_vline(xintercept = 0, linetype = "dashed", color = "red", size = 1) +
  # Labels and theme
  labs(
    title = "Mortality Rates Around MLDA",
    x = "Age in Months Relative to MLDA",
    y = "Mortality Rate (per 100,000 person-years)"
  ) +
  theme_minimal()

print(plot)

#3. Non-Parametric "Donut" RD Analysis

# Calculating mortality rates and treatment indicator
data <- data %>%
  mutate(rate_any_cause = 100000 * cod_any / (pop / 12),
         rate_motor_vehicle = 100000 * cod_MVA / (pop / 12),
         above_mlda = ifelse(agemo_mda > 0, 1, 0))

# Excluding partially treated observations (the "donut hole")
data_donut <- data %>% filter(agemo_mda != 0)

# Defining a function to calculate RD estimates
calculate_rd <- function(data, bandwidth) {
  # Filter data within the given bandwidth
  subset_data <- data %>% filter(abs(agemo_mda) <= bandwidth)
  
  # Linear regression for any cause mortality
  model_any <- lm(rate_any_cause ~ above_mlda, data = subset_data)
  rd_any <- coef(summary(model_any))["above_mlda", ]
  
  # Linear regression for motor vehicle mortality
  model_mva <- lm(rate_motor_vehicle ~ above_mlda, data = subset_data)
  rd_mva <- coef(summary(model_mva))["above_mlda", ]
  
  # Returning RD estimates and standard errors
  list(bandwidth = bandwidth,
       rd_any = rd_any[1],
       se_any = rd_any[2],
       rd_mva = rd_mva[1],
       se_mva = rd_mva[2])
}

# Bandwidths to analyze
bandwidths <- c(48, 24, 12, 6)

# Applying the RD function for all bandwidths
results <- lapply(bandwidths, calculate_rd, data = data_donut)

# Combining results into a data frame
results_df <- do.call(rbind, lapply(results, as.data.frame))
colnames(results_df) <- c("Bandwidth", "RD_All_Cause", "SE_All_Cause", "RD_MVA", "SE_MVA")

# Results
cat("Non-Parametric Donut RD Results (Including Standard Errors):\n")
print(results_df)


#4. Parametric RD Analysis

# Defining a function to calculate parametric RD estimates
calculate_parametric_rd <- function(data, bandwidth) {
  # Filtering data within the bandwidth
  subset_data <- data %>% filter(abs(agemo_mda) <= bandwidth)
  
  # Creating an interaction term for the trend
  subset_data <- subset_data %>%
    mutate(trend = agemo_mda * above_mlda)
  
  # Linear regression for any cause mortality
  model_any <- lm(rate_any_cause ~ above_mlda + agemo_mda + trend, data = subset_data)
  rd_any <- coef(summary(model_any))["above_mlda", ]
  
  # Linear regression for motor vehicle mortality
  model_mva <- lm(rate_motor_vehicle ~ above_mlda + agemo_mda + trend, data = subset_data)
  rd_mva <- coef(summary(model_mva))["above_mlda", ]
  
  # Returning RD estimates and standard errors
  list(bandwidth = bandwidth,
       rd_any = rd_any[1],
       se_any = rd_any[2],
       rd_mva = rd_mva[1],
       se_mva = rd_mva[2])
}

# Bandwidths to analyze
bandwidths <- c(48, 24, 12, 6)

# Applying the parametric RD function for all bandwidths
parametric_results <- lapply(bandwidths, calculate_parametric_rd, data = data_donut)

# Combining results into a data frame
parametric_results_df <- do.call(rbind, lapply(parametric_results, as.data.frame))
colnames(parametric_results_df) <- c("Bandwidth", "RD_All_Cause", "SE_All_Cause", "RD_MVA", "SE_MVA")

# Results
cat("Parametric Donut RD Results (Including Interaction Terms):\n")
print(parametric_results_df)




