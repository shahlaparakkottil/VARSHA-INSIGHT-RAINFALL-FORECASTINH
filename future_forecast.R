# ==============================
# 4. FUTURE FORECASTING - XGBOOST
# ==============================

library(readr)
library(dplyr)
library(xgboost)
library(zoo)

# Load dataset
df <- read_csv("cleaned_rainfall_dataset.csv")

# Create lag and rolling features
df <- df %>%
  arrange(SUBDIVISION, YEAR) %>%
  group_by(SUBDIVISION) %>%
  mutate(
    Lag_1 = lag(ANNUAL, 1),
    Lag_2 = lag(ANNUAL, 2),
    Lag_3 = lag(ANNUAL, 3),
    Rolling_3 = rollmean(lag(ANNUAL, 1), k = 3, fill = NA, align = "right"),
    Rolling_5 = rollmean(lag(ANNUAL, 1), k = 5, fill = NA, align = "right")
  ) %>%
  ungroup()

# Features used in the model
features <- c(
  "YEAR",
  "Lag_1",
  "Lag_2",
  "Lag_3",
  "Rolling_3",
  "Rolling_5"
)

# Prepare training data using all historical data
model_df <- df %>%
  select(all_of(features), ANNUAL) %>%
  na.omit()

X_train <- as.matrix(model_df[, features])
y_train <- model_df$ANNUAL

# Train final XGBoost model
final_xgb_model <- xgboost(
  data = X_train,
  label = y_train,
  nrounds = 500,
  eta = 0.05,
  max_depth = 6,
  subsample = 0.8,
  colsample_bytree = 0.8,
  objective = "reg:squarederror",
  verbose = 0
)

# ==============================
# FORECAST 2018 - 2030
# ==============================

forecast_results <- data.frame()

subdivisions <- unique(df$SUBDIVISION)

for (subdivision in subdivisions) {
  
  sub_df <- df %>%
    filter(SUBDIVISION == subdivision) %>%
    arrange(YEAR)
  
  for (year in 2018:2030) {
    
    lag_1 <- tail(sub_df$ANNUAL, 1)
    lag_2 <- tail(sub_df$ANNUAL, 2)[1]
    lag_3 <- tail(sub_df$ANNUAL, 3)[1]
    
    rolling_3 <- mean(tail(sub_df$ANNUAL, 3))
    rolling_5 <- mean(tail(sub_df$ANNUAL, 5))
    
    future_data <- data.frame(
      YEAR = year,
      Lag_1 = lag_1,
      Lag_2 = lag_2,
      Lag_3 = lag_3,
      Rolling_3 = rolling_3,
      Rolling_5 = rolling_5
    )
    
    future_matrix <- as.matrix(future_data[, features])
    
    prediction <- predict(
      final_xgb_model,
      future_matrix
    )
    
    forecast_results <- rbind(
      forecast_results,
      data.frame(
        SUBDIVISION = subdivision,
        YEAR = year,
        FORECAST_RAINFALL = prediction
      )
    )
    
    # Add predicted value for next year's lag calculation
    new_row <- data.frame(
      SUBDIVISION = subdivision,
      YEAR = year,
      ANNUAL = prediction
    )
    
    sub_df <- bind_rows(sub_df, new_row)
  }
}

# View forecast
head(forecast_results, 20)

# Save forecast output
write_csv(
  forecast_results,
  "r_subdivision_forecast_2018_2030.csv"
)

cat("Future forecast saved successfully.\n")

