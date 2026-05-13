library(tidyverse)
library(forecast)
library(feasts)
library(tsibble)
library(patchwork)
library(lubridate)
library(scales)

# =====================================================
# LOAD DATA
# =====================================================

imports <- read.csv("data/IntraEU_Espana.csv")

imports_ts <- ts(
  imports$Imports,
  start = c(2000, 1),
  frequency = 12
)

# =====================================================
# TRAIN / TEST SPLIT
# =====================================================

h <- 12

train_ts <- window(
  imports_ts,
  end = c(2024, 5)
)

test_ts <- window(
  imports_ts,
  start = c(2024, 6)
)

# =====================================================
# ETS MODELS
# =====================================================

fit_ets_auto <- ets(train_ts)

fit_ets_aaa <- ets(
  train_ts,
  model = "AAA"
)

fit_snaive <- snaive(
  train_ts,
  h = h
)

# =====================================================
# FORECASTS
# =====================================================

fc_auto <- forecast(
  fit_ets_auto,
  h = h
)

fc_aaa <- forecast(
  fit_ets_aaa,
  h = h
)

fc_snaive <- forecast(
  fit_snaive,
  h = h
)

# =====================================================
# ACCURACY METRICS
# =====================================================

acc_auto <- accuracy(fc_auto, test_ts)

acc_aaa <- accuracy(fc_aaa, test_ts)

acc_snaive <- accuracy(fc_snaive, test_ts)

comparison_table <- tibble(
  Model = c(
    "ETS Auto",
    "ETS(A,A,A)",
    "Seasonal Naive"
  ),

  RMSE = c(
    acc_auto["Test set", "RMSE"],
    acc_aaa["Test set", "RMSE"],
    acc_snaive["Test set", "RMSE"]
  ),

  MAE = c(
    acc_auto["Test set", "MAE"],
    acc_aaa["Test set", "MAE"],
    acc_snaive["Test set", "MAE"]
  ),

  MAPE = c(
    acc_auto["Test set", "MAPE"],
    acc_aaa["Test set", "MAPE"],
    acc_snaive["Test set", "MAPE"]
  ),

  MPE = c(
    acc_auto["Test set", "MPE"],
    acc_aaa["Test set", "MPE"],
    acc_snaive["Test set", "MPE"]
  )
)

write.csv(
  comparison_table,
  "outputs/tables/model_comparison.csv",
  row.names = FALSE
)

# =====================================================
# ROLLING FORECAST ORIGIN
# =====================================================

initial_window <- 180

horizon <- 12

n <- length(imports_ts)

origins <- n - initial_window - horizon

rolling_results <- tibble()

for(i in 1:origins){

  train <- window(
    imports_ts,
    end = c(
      2000 + ((initial_window + i - 2) %/% 12),
      ((initial_window + i - 2) %% 12) + 1
    )
  )

  test <- window(
    imports_ts,
    start = c(
      2000 + ((initial_window + i - 1) %/% 12),
      ((initial_window + i - 1) %% 12) + 1
    ),
    end = c(
      2000 + ((initial_window + i + horizon - 2) %/% 12),
      ((initial_window + i + horizon - 2) %% 12) + 1
    )
  )

  fit <- ets(
    train,
    model = "AAA"
  )

  fc <- forecast(
    fit,
    h = horizon
  )

  snaive_fc <- snaive(
    train,
    h = horizon
  )

  ets_acc <- accuracy(fc, test)

  snaive_acc <- accuracy(snaive_fc, test)

  rolling_results <- bind_rows(
    rolling_results,

    tibble(
      Origin = i,
      ETS_MAPE = ets_acc["Test set", "MAPE"],
      ETS_RMSE = ets_acc["Test set", "RMSE"],
      ETS_MAE  = ets_acc["Test set", "MAE"],

      SNAIVE_MAPE = snaive_acc["Test set", "MAPE"],
      SNAIVE_RMSE = snaive_acc["Test set", "RMSE"],
      SNAIVE_MAE  = snaive_acc["Test set", "MAE"]
    )
  )
}

write.csv(
  rolling_results,
  "outputs/tables/rolling_origin_metrics.csv",
  row.names = FALSE
)

# =====================================================
# ROLLING ORIGIN PLOT
# =====================================================

plot_data <- rolling_results %>%
  select(
    Origin,
    ETS_MAPE,
    SNAIVE_MAPE
  ) %>%
  pivot_longer(
    -Origin,
    names_to = "Model",
    values_to = "MAPE"
  )

p1 <- ggplot(
  plot_data,
  aes(
    x = Origin,
    y = MAPE,
    color = Model
  )
) +

  geom_line(
    linewidth = 1
  ) +

  labs(
    title = "Rolling Forecast Origin Performance",
    subtitle = "Out-of-sample MAPE comparison",
    x = "Forecast origin",
    y = "MAPE (%)"
  ) +

  theme_minimal(base_size = 13)

ggsave(
  "outputs/figures/rolling_origin_performance.png",
  p1,
  width = 10,
  height = 6,
  dpi = 300
)

# =====================================================
# FINAL FORECAST
# =====================================================

final_model <- ets(
  imports_ts,
  model = "AAA"
)

future_fc <- forecast(
  final_model,
  h = 24
)

png(
  "outputs/figures/ets_forecast.png",
  width = 1400,
  height = 800,
  res = 140
)

autoplot(future_fc) +
  labs(
    title = "Spain-EU Imports Forecast",
    subtitle = "ETS(A,A,A) model",
    x = "",
    y = "Kilotonnes"
  ) +
  theme_minimal(base_size = 14)

dev.off()

# =====================================================
# RESIDUAL DIAGNOSTICS
# =====================================================

residuals_df <- tibble(
  Date = seq.Date(
    from = as.Date("2000-01-01"),
    by = "month",
    length.out = length(residuals(final_model))
  ),

  Residuals = as.numeric(
    residuals(final_model)
  )
)

sd_res <- sd(
  residuals_df$Residuals,
  na.rm = TRUE
)

outliers <- residuals_df %>%
  filter(
    abs(Residuals) > 3 * sd_res
  )

write.csv(
  outliers,
  "outputs/tables/residual_outliers.csv",
  row.names = FALSE
)

p2 <- ggplot(
  residuals_df,
  aes(Date, Residuals)
) +

  geom_line() +

  geom_hline(
    yintercept = c(-3*sd_res, 3*sd_res),
    linetype = "dashed",
    color = "red"
  ) +

  labs(
    title = "Residual Diagnostics",
    subtitle = "ETS(A,A,A)",
    x = "",
    y = "Residuals"
  ) +

  theme_minimal(base_size = 13)

ggsave(
  "outputs/figures/residual_diagnostics.png",
  p2,
  width = 10,
  height = 6,
  dpi = 300
)
