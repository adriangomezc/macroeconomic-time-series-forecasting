library(tidyverse)
library(forecast)
library(tseries)
library(ggplot2)
library(gridExtra)

dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

# =========================================================
# LOAD DATA
# =========================================================

imports <- read.csv(
  "data/IntraEU_Espana.csv"
)

imports_ts <- ts(
  imports$Imports,
  start = c(2000, 1),
  frequency = 12
)

# =========================================================
# ANNUAL AGGREGATION
# =========================================================

annual_ts <- aggregate(imports_ts, FUN = sum)

# =========================================================
# VISUALIZATION
# =========================================================

p1 <- autoplot(annual_ts) +
  labs(
    title = "Annual Spain-EU imports",
    x = "",
    y = "Kilotonnes"
  ) +
  theme_minimal()

ggsave(
  "outputs/figures/annual_series.png",
  p1,
  width = 10,
  height = 5
)

# =========================================================
# STATIONARITY TESTS
# =========================================================

kpss_result <- kpss.test(annual_ts)

adf_result <- adf.test(annual_ts)

d_required <- ndiffs(annual_ts)

stationarity_table <- data.frame(
  Test = c("KPSS", "ADF", "Recommended differences"),
  Result = c(
    round(kpss_result$p.value, 4),
    round(adf_result$p.value, 4),
    d_required
  )
)

write.csv(
  stationarity_table,
  "outputs/tables/annual_arima_metrics.csv",
  row.names = FALSE
)

# =========================================================
# ARIMA FIT
# =========================================================

fit_arima <- auto.arima(
  annual_ts,
  seasonal = FALSE,
  stepwise = FALSE,
  approximation = FALSE
)

orders <- arimaorder(fit_arima)

orders_table <- data.frame(
  p = orders[1],
  d = orders[2],
  q = orders[3]
)

write.csv(
  orders_table,
  "outputs/tables/arima_orders.csv",
  row.names = FALSE
)

# =========================================================
# RESIDUAL DIAGNOSTICS
# =========================================================

png(
  "outputs/figures/annual_arima_diagnostics.png",
  width = 1200,
  height = 900
)

par(mfrow = c(2,2))

plot(
  residuals(fit_arima),
  main = "Residuals",
  ylab = ""
)

Acf(
  residuals(fit_arima),
  main = "Residual ACF"
)

hist(
  residuals(fit_arima),
  main = "Residual distribution",
  xlab = ""
)

qqnorm(residuals(fit_arima))
qqline(residuals(fit_arima))

dev.off()

# =========================================================
# FORECAST
# =========================================================

fc_arima <- forecast(
  fit_arima,
  h = 5
)

p2 <- autoplot(fc_arima) +
  labs(
    title = "Annual ARIMA forecast",
    x = "",
    y = "Kilotonnes"
  ) +
  theme_minimal()

ggsave(
  "outputs/figures/annual_arima_forecast.png",
  p2,
  width = 10,
  height = 5
)

# =========================================================
# ETS VS ARIMA COMPARISON
# =========================================================

train <- window(
  annual_ts,
  end = c(2019)
)

test <- window(
  annual_ts,
  start = c(2020)
)

fit_ets <- ets(train)

fit_arima_cv <- auto.arima(
  train,
  seasonal = FALSE
)

fc_ets <- forecast(fit_ets, h = length(test))
fc_arima_cv <- forecast(fit_arima_cv, h = length(test))

acc_ets <- accuracy(fc_ets, test)
acc_arima <- accuracy(fc_arima_cv, test)

comparison <- data.frame(
  Model = c("ETS", "ARIMA"),
  RMSE = c(
    acc_ets["Test set", "RMSE"],
    acc_arima["Test set", "RMSE"]
  ),
  MAE = c(
    acc_ets["Test set", "MAE"],
    acc_arima["Test set", "MAE"]
  ),
  MAPE = c(
    acc_ets["Test set", "MAPE"],
    acc_arima["Test set", "MAPE"]
  )
)

write.csv(
  comparison,
  "outputs/tables/annual_model_comparison.csv",
  row.names = FALSE
)

# =========================================================
# ETS VS ARIMA VISUAL
# =========================================================

autoplot(train) +
  autolayer(fc_ets$mean, series = "ETS") +
  autolayer(fc_arima_cv$mean, series = "ARIMA") +
  autolayer(test, series = "Observed") +
  labs(
    title = "ETS vs ARIMA forecast comparison",
    y = "Kilotonnes",
    x = ""
  ) +
  theme_minimal()

ggsave(
  "outputs/figures/ets_vs_arima.png",
  width = 10,
  height = 5
)
