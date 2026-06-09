# ==============================
# 3. MODEL BUILDING - XGBOOST
# ==============================

library(readr)
library(dplyr)
library(xgboost)
library(Metrics)
library(zoo)

# Load dataset
df <- read_csv("cleaned_rainfall_dataset.csv")

# Create lag and rolling features in R
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

# Check columns
colnames(df)

# Forecasting features
features <- c(
  "YEAR",
  "Lag_1",
  "Lag_2",
  "Lag_3",
  "Rolling_3",
  "Rolling_5"
)

# Prepare model dataset
model_df <- df %>%
  select(all_of(features), ANNUAL) %>%
  na.omit()

# Time-based split
train_df <- model_df %>%
  filter(YEAR <= 2010)

test_df <- model_df %>%
  filter(YEAR > 2010)

# Convert to matrix
X_train <- as.matrix(train_df[, features])
y_train <- train_df$ANNUAL

X_test <- as.matrix(test_df[, features])
y_test <- test_df$ANNUAL

# Build XGBoost model
xgb_model <- xgboost(
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

# Predict
y_pred <- predict(xgb_model, X_test)

# Evaluation metrics
mae_value <- mae(y_test, y_pred)
rmse_value <- rmse(y_test, y_pred)
mape_value <- mean(abs((y_test - y_pred) / y_test)) * 100

ss_res <- sum((y_test - y_pred)^2)
ss_tot <- sum((y_test - mean(y_test))^2)
r2_value <- 1 - (ss_res / ss_tot)

cat("MAE:", round(mae_value, 2), "\n")
cat("RMSE:", round(rmse_value, 2), "\n")
cat("R2:", round(r2_value, 4), "\n")
cat("MAPE:", round(mape_value, 2), "%\n")

# Actual vs Predicted plot
result_df <- data.frame(
  Actual = y_test,
  Predicted = y_pred
)

plot(
  result_df$Actual,
  result_df$Predicted,
  main = "Actual vs Predicted Rainfall",
  xlab = "Actual Rainfall",
  ylab = "Predicted Rainfall",
  pch = 19
)

abline(0, 1, col = "red", lwd = 2, lty = 2)

# Feature importance
importance <- xgb.importance(
  feature_names = features,
  model = xgb_model
)

print(importance)

xgb.plot.importance(importance)

# Save output
write_csv(result_df, "r_actual_vs_predicted.csv")
write_csv(df, "final_rainfall_dataset_with_lag.csv")
