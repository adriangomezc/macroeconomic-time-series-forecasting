library(tidyverse)
library(forecast)
library(feasts)
library(tsibble)
library(patchwork)
library(lubridate)

# --------------------------------------------------
# Load data
# --------------------------------------------------

df <- read.csv("data/spain_eu_imports.csv")

df$Date <- as.Date(df$Date)

imports_ts <- ts(
  df$Imports,
  start = c(2000, 1),
  frequency = 12
)

# --------------------------------------------------
# Summary statistics
# --------------------------------------------------

summary_stats <- data.frame(
  Mean = mean(imports_ts),
  SD = sd(imports_ts),
  Min = min(imports_ts),
  Max = max(imports_ts)
)

write.csv(
  summary_stats,
  "outputs/summary_statistics.csv",
  row.names = FALSE
)

# --------------------------------------------------
# Original series
# --------------------------------------------------

p1 <- autoplot(imports_ts) +
  labs(
    title = "Spain-EU monthly imports",
    subtitle = "Monthly imports from European countries (2000–2025)",
    x = "",
    y = "Kilotonnes"
  ) +
  theme_minimal(base_size = 14)

ggsave(
  "outputs/original_series.png",
  p1,
  width = 11,
  height = 6,
  dpi = 300
)

# --------------------------------------------------
# Annual aggregation
# --------------------------------------------------

annual_ts <- aggregate(imports_ts, FUN = sum)

p2 <- autoplot(annual_ts / 1000) +
  labs(
    title = "Annual Spain-EU imports",
    subtitle = "Long-term macroeconomic trend",
    x = "",
    y = "Thousand kilotonnes"
  ) +
  theme_minimal(base_size = 14)

ggsave(
  "outputs/annual_trend.png",
  p2,
  width = 10,
  height = 6,
  dpi = 300
)

# --------------------------------------------------
# Seasonal analysis
# --------------------------------------------------

p3 <- ggsubseriesplot(imports_ts) +
  labs(
    title = "Monthly subseries plot",
    x = "",
    y = "Kilotonnes"
  ) +
  theme_minimal(base_size = 12)

p4 <- ggseasonplot(
  window(imports_ts, start = 2019),
  year.labels = TRUE
) +
  labs(
    title = "Seasonal patterns (2019–2025)",
    x = "",
    y = "Kilotonnes"
  ) +
  theme_minimal(base_size = 12)

season_plot <- p3 / p4

ggsave(
  "outputs/seasonal_patterns.png",
  season_plot,
  width = 12,
  height = 10,
  dpi = 300
)

# --------------------------------------------------
# Classical decomposition
# --------------------------------------------------

decomp <- decompose(imports_ts, type = "additive")

png(
  "outputs/decomposition_plot.png",
  width = 1200,
  height = 900,
  res = 140
)

plot(decomp)

dev.off()

# --------------------------------------------------
# Variance analysis
# --------------------------------------------------

annual_mean <- aggregate(imports_ts, FUN = mean)
annual_sd <- aggregate(imports_ts, FUN = sd)

variance_df <- data.frame(
  Mean = as.numeric(annual_mean),
  SD = as.numeric(annual_sd)
)

p5 <- ggplot(variance_df, aes(x = Mean, y = SD)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Mean-variance relationship",
    subtitle = "Assessing variance stability",
    x = "Annual mean",
    y = "Annual standard deviation"
  ) +
  theme_minimal(base_size = 13)

ggsave(
  "outputs/variance_analysis.png",
  p5,
  width = 8,
  height = 6,
  dpi = 300
)

# --------------------------------------------------
# Shock / intervention detection
# --------------------------------------------------

z_scores <- scale(imports_ts)

shock_idx <- which(abs(z_scores) > 2.5)

shock_dates <- time(imports_ts)[shock_idx]

shock_values <- imports_ts[shock_idx]

interventions <- data.frame(
  Date = as.character(shock_dates),
  Value = as.numeric(shock_values)
)

write.csv(
  interventions,
  "outputs/intervention_points.csv",
  row.names = FALSE
)

print(interventions)
