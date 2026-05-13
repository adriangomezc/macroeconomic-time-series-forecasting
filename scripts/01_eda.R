
Ahora crea:
`scripts/01_eda.R`

y pega EXACTAMENTE esto.

```r
library(tidyverse)
library(forecast)
library(feasts)
library(tsibble)
library(patchwork)

# =========================
# Load data
# =========================

df <- read.csv("data/intraEU_spain_imports.csv")

imports_ts <- ts(
  df$Imports,
  start = c(2000, 1),
  frequency = 12
)

# =========================
# Create folders
# =========================

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", showWarnings = FALSE)
dir.create("outputs/tables", showWarnings = FALSE)

# =========================
# Main time series plot
# =========================

p1 <- autoplot(imports_ts) +
  labs(
    title = "Monthly Spanish imports from EU countries",
    subtitle = "January 2000 – May 2025",
    x = "",
    y = "Kilotons"
  ) +
  theme_minimal(base_size = 13)

ggsave(
  "outputs/figures/main_series.png",
  p1,
  width = 10,
  height = 6,
  dpi = 300
)

# =========================
# Annual aggregation
# =========================

annual_ts <- aggregate(imports_ts, FUN = sum)

p2 <- autoplot(annual_ts / 1000) +
  labs(
    title = "Annual imports aggregation",
    x = "",
    y = "Thousands of kilotons"
  ) +
  theme_minimal(base_size = 13)

ggsave(
  "outputs/figures/annual_trend.png",
  p2,
  width = 10,
  height = 6,
  dpi = 300
)

# =========================
# Seasonal analysis
# =========================

p3 <- ggsubseriesplot(imports_ts) +
  labs(
    title = "Monthly subseries plot",
    x = "",
    y = "Kilotons"
  ) +
  theme_minimal(base_size = 11)

p4 <- ggseasonplot(
  window(imports_ts, start = c(2019, 1)),
  year.labels = TRUE
) +
  labs(
    title = "Seasonal plot (2019–2025)",
    x = "",
    y = "Kilotons"
  ) +
  theme_minimal(base_size = 11)

seasonal_plot <- p3 / p4

ggsave(
  "outputs/figures/seasonality.png",
  seasonal_plot,
  width = 12,
  height = 10,
  dpi = 300
)

# =========================
# Classical decomposition
# =========================

decomp <- decompose(imports_ts)

png(
  "outputs/figures/classical_decomposition.png",
  width = 1200,
  height = 900,
  res = 150
)

plot(decomp)

dev.off()

# =========================
# Variance diagnostics
# =========================

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
    x = "Annual mean",
    y = "Annual standard deviation"
  ) +
  theme_minimal(base_size = 13)

ggsave(
  "outputs/figures/variance_diagnostics.png",
  p5,
  width = 8,
  height = 6,
  dpi = 300
)

# =========================
# Outlier exploration
# =========================

decomp_mult <- decompose(imports_ts, type = "multiplicative")

residuals_mult <- remainder(decomp_mult)

outlier_threshold <- 3 * sd(residuals_mult, na.rm = TRUE)

outlier_idx <- which(
  abs(residuals_mult - 1) > outlier_threshold
)

dates <- time(imports_ts)

outlier_dates <- dates[outlier_idx]

outlier_table <- data.frame(
  Date = outlier_dates,
  Residual = residuals_mult[outlier_idx]
)

write.csv(
  outlier_table,
  "outputs/tables/outlier_dates.csv",
  row.names = FALSE
)

# =========================
# Summary statistics
# =========================

summary_table <- data.frame(
  Metric = c(
    "Mean",
    "Median",
    "Standard deviation",
    "Minimum",
    "Maximum"
  ),
  Value = c(
    mean(imports_ts),
    median(imports_ts),
    sd(imports_ts),
    min(imports_ts),
    max(imports_ts)
  )
)

write.csv(
  summary_table,
  "outputs/tables/summary_statistics.csv",
  row.names = FALSE
)
