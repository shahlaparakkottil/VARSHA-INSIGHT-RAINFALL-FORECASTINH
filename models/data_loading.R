# ==============================
# 1. DATA LOADING
# ==============================

library(readr)
library(dplyr)

# Load cleaned dataset
df <- read_csv("cleaned_rainfall_dataset.csv")

# View first rows
head(df)

# Dataset structure
str(df)

# Dataset summary
summary(df)

# Check missing values
colSums(is.na(df))

# Total records
cat("Total Records:", nrow(df), "\n")

# Total subdivisions
cat("Total Subdivisions:", n_distinct(df$SUBDIVISION), "\n")

# Year range
cat("Year Range:", min(df$YEAR), "-", max(df$YEAR), "\n")

# Rainfall category count
category_count <- df %>%
  count(Rainfall_Category)

category_count

