# =========================================================
# MACROECONOMIC TIME SERIES FORECASTING
# Seasonal ARIMA Modelling with Calendar Effects
# Adrián Gómez Conde
# =========================================================

# ======================
# Libraries
# ======================

library(tidyverse)
library(forecast)
library(tseries)
library(lubridate)
library(ggplot2)
library(seasonal)
library(tsoutliers)
library(gridExtra)

# ======================
# Load data
# ======================

imports <- read.csv("data/IntraEU_Espana.csv")

imports_ts <- ts(
  imports$Importaciones,
  start = c(2000, 1),
  frequency = 12
)

# ======================
# Preliminary diagnostics
# ======================

png("outputs/figures/seasonal_adjustment.png",
    width = 1400,
    height = 900,
    res = 140)

seas_model <- seas(imports_ts)

plot(seas_model)

dev.off()

# ======================
# Stationarity tests
# ======================

adf_original <- adf.test(imports_ts)
kpss_original <- kpss.test(imports_ts)

ndiffs_result <- ndiffs(imports_ts)
nsdiffs_result <- nsdiffs(imports_ts)

stationarity_table <- data.frame(
  Test = c(
    "ADF p-value",
    "KPSS p-value",
    "Recommended d",
    "Recommended D"
  ),
  Value = c(
    adf_original$p.value,
    kpss_original$p.value,
    ndiffs_result,
    nsdiffs_result
  )
)

write.csv(
  stationarity_table,
  "outputs/tables/seasonal_tests.csv",
  row.names = FALSE
)

# ======================
# Apply only required differencing
# ======================

imports_diff <- diff(imports_ts, differences = ndiffs_result)

# ======================
# Intervention variable
# ======================

intervention <- rep(0, length(imports_ts))

shock_position <- which(
  time(imports_ts) == 2008 + (1 - 1)/12
)

intervention[shock_position] <- 1

# ======================
# Trading days effect
# ======================

days_month <- monthdays(imports_ts)

# ======================
# SARIMA model
# ======================

xreg_matrix <- cbind(
  intervention,
  days_month
)

sarima_model <- auto.arima(
  imports_ts,
  seasonal = TRUE,
  d = ndiffs_result,
  D = nsdiffs_result,
  xreg = xreg_matrix,
  stepwise = FALSE,
  approximation = FALSE
)

summary(sarima_model)

# ======================
# Model coefficients
# ======================

coef_table <- data.frame(
  Parameter = names(coef(sarima_model)),
  Estimate = coef(sarima_model)
)

write.csv(
  coef_table,
  "outputs/tables/intervention_effects.csv",
  row.names = FALSE
)

# ======================
# Residual diagnostics
# ======================

png("outputs/figures/sarima_diagnostics.png",
    width = 1400,
    height = 900,
    res = 140)

checkresiduals(sarima_model)

dev.off()

# ======================
# Residual comparison
# ======================

ets_model <- ets(imports_ts)

ets_res <- residuals(ets_model)
sarima_res <- residuals(sarima_model)

df_residuals <- data.frame(
  Date = seq(as.Date("2000-01-01"),
             by = "month",
             length.out = length(imports_ts)),
  ETS = as.numeric(ets_res),
  SARIMA = as.numeric(sarima_res)
)

p1 <- ggplot(df_residuals,
             aes(Date, ETS)) +
  geom_line() +
  labs(
    title = "ETS residuals",
    y = "Residuals"
  ) +
  theme_minimal()

p2 <- ggplot(df_residuals,
             aes(Date, SARIMA)) +
  geom_line() +
  labs(
    title = "SARIMA residuals",
    y = "Residuals"
  ) +
  theme_minimal()

png("outputs/figures/model_residuals_comparison.png",
    width = 1400,
    height = 900,
    res = 140)

grid.arrange(p1, p2, ncol = 1)

dev.off()

# ======================
# Rolling-origin validation
# ======================

k <- 180
h <- 12

TT <- length(imports_ts)

s <- TT - k - h

rmse_ets <- numeric(s + 1)
rmse_sarima <- numeric(s + 1)

mape_ets <- numeric(s + 1)
mape_sarima <- numeric(s + 1)

for(i in 0:s){

  train <- window(
    imports_ts,
    end = time(imports_ts)[k + i]
  )

  test <- window(
    imports_ts,
    start = time(imports_ts)[k + i + 1],
    end = time(imports_ts)[k + i + h]
  )

  intervention_train <- intervention[1:length(train)]

  intervention_future <- rep(0, h)

  days_train <- monthdays(train)

  future_dates <- seq(
    as.Date("2025-06-01"),
    by = "month",
    length.out = h
  )

  future_days <- days_in_month(future_dates)

  # ETS

  fit_ets <- ets(train)

  fc_ets <- forecast(
    fit_ets,
    h = h
  )

  # SARIMA

  fit_sarima <- auto.arima(
    train,
    seasonal = TRUE,
    d = ndiffs_result,
    D = nsdiffs_result,
    xreg = cbind(intervention_train,
                 days_train)
  )

  fc_sarima <- forecast(
    fit_sarima,
    h = h,
    xreg = cbind(intervention_future,
                 future_days)
  )

  rmse_ets[i + 1] <- sqrt(mean(
    (test - fc_ets$mean)^2
  ))

  rmse_sarima[i + 1] <- sqrt(mean(
    (test - fc_sarima$mean)^2
  ))

  mape_ets[i + 1] <- mean(
    abs((test - fc_ets$mean) / test)
  ) * 100

  mape_sarima[i + 1] <- mean(
    abs((test - fc_sarima$mean) / test)
  ) * 100
}

# ======================
# Final comparison
# ======================

comparison_table <- data.frame(
  Model = c("ETS", "Seasonal ARIMA"),
  RMSE = c(
    mean(rmse_ets),
    mean(rmse_sarima)
  ),
  MAPE = c(
    mean(mape_ets),
    mean(mape_sarima)
  )
)

write.csv(
  comparison_table,
  "outputs/tables/final_model_comparison.csv",
  row.names = FALSE
)

# ======================
# Forecasting
# ======================

future_dates <- seq(
  as.Date("2025-06-01"),
  by = "month",
  length.out = 24
)

future_days <- days_in_month(future_dates)

future_xreg <- cbind(
  rep(0, 24),
  future_days
)

final_forecast <- forecast(
  sarima_model,
  h = 24,
  xreg = future_xreg
)

autoplot(final_forecast) +
  labs(
    title = "Seasonal ARIMA Forecast",
    x = "",
    y = "Kilotonnes"
  ) +
  theme_minimal()

ggsave(
  "outputs/figures/sarima_forecast.png",
  width = 12,
  height = 7
)

# ======================
# Forecast comparison
# ======================

ets_fc <- forecast(ets_model, h = 24)

p_forecast <- autoplot(imports_ts) +
  autolayer(
    ets_fc$mean,
    series = "ETS"
  ) +
  autolayer(
    final_forecast$mean,
    series = "SARIMA"
  ) +
  labs(
    title = "Forecast comparison",
    y = "Kilotonnes"
  ) +
  theme_minimal()

ggsave(
  "outputs/figures/forecast_comparison.png",
  p_forecast,
  width = 12,
  height = 7
)

# ======================
# Final metrics
# ======================

metrics_table <- data.frame(
  Metric = c(
    "AIC",
    "BIC",
    "RMSE",
    "MAE"
  ),
  Value = c(
    AIC(sarima_model),
    BIC(sarima_model),
    accuracy(sarima_model)[2],
    accuracy(sarima_model)[3]
  )
)

write.csv(
  metrics_table,
  "outputs/tables/sarima_metrics.csv",
  row.names = FALSE
)
