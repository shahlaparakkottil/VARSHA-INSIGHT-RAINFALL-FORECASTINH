# ==============================
# 2. DATA VISUALIZATION
# ==============================

library(ggplot2)
library(dplyr)

# Yearly rainfall trend
year_data <- df %>%
  group_by(YEAR) %>%
  summarise(
    Avg_Rainfall = mean(ANNUAL, na.rm = TRUE)
  )

ggplot(year_data, aes(x = YEAR, y = Avg_Rainfall)) +
  geom_line(color = "blue") +
  geom_point() +
  labs(
    title = "Average Annual Rainfall Trend",
    x = "Year",
    y = "Average Rainfall (mm)"
  )

# Top 10 rainfall subdivisions
region_data <- df %>%
  group_by(SUBDIVISION) %>%
  summarise(
    Avg_Rainfall = mean(ANNUAL, na.rm = TRUE)
  ) %>%
  arrange(desc(Avg_Rainfall))

ggplot(head(region_data, 10),
       aes(
         x = reorder(SUBDIVISION, Avg_Rainfall),
         y = Avg_Rainfall
       )) +
  geom_bar(stat = "identity", fill = "green") +
  coord_flip() +
  labs(
    title = "Top 10 Subdivisions by Average Rainfall",
    x = "Subdivision",
    y = "Average Rainfall (mm)"
  )

# Rainfall category distribution
category_data <- df %>%
  count(Rainfall_Category)

ggplot(category_data,
       aes(x = Rainfall_Category, y = n)) +
  geom_bar(stat = "identity", fill = "orange") +
  labs(
    title = "Rainfall Category Distribution",
    x = "Rainfall Category",
    y = "Count"
  )

# Kerala rainfall history
kerala_data <- df %>%
  filter(SUBDIVISION == "Kerala")

ggplot(kerala_data, aes(x = YEAR, y = ANNUAL)) +
  geom_line(color = "darkblue") +
  geom_point() +
  labs(
    title = "Kerala Annual Rainfall History",
    x = "Year",
    y = "Annual Rainfall (mm)"
  )
