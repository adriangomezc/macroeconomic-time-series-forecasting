# Macroeconomic Time Series Forecasting: Spain–EU Imports

> An end-to-end macroeconomic forecasting project focused on modelling Spanish imports from European countries using exploratory analysis, exponential smoothing (ETS), ARIMA methodologies, intervention analysis and seasonal forecasting with exogenous variables.

The project reproduces a realistic forecasting workflow commonly used in consulting, economic intelligence, supply-chain analytics and industrial planning environments.

---

## Business Context

International trade flows are strongly influenced by:

* Economic cycles
* Industrial production
* Logistics capacity
* Supply-chain disruptions
* Seasonal commercial behaviour
* External macroeconomic shocks

Reliable forecasting of import volumes is valuable for:

* Demand planning
* Inventory optimisation
* Logistics forecasting
* Macroeconomic monitoring
* Risk management
* Capacity planning

This project analyses monthly Spanish imports from European countries between January 2000 and May 2025 using official Eurostat data.

---

# Dataset

* **Source:** Eurostat
* **Frequency:** Monthly
* **Period:** 2000-01 to 2025-05
* **Variable:** Imports (kilotonnes)

The series exhibits:

* Long-term macroeconomic trend
* Strong annual seasonality
* Structural breaks
* Extreme external shocks
* Volatility changes over time
* Calendar-related effects

---

# Key Results

| Task | Best Model | Main Result |
| --- | --- | --- |
| Monthly forecasting | ETS Auto | Out-of-sample MAPE = 7.39% |
| Annual macroeconomic modelling | ARIMA(1,0,0) | MAPE = 4.12% |
| Seasonal structural forecasting | SARIMA + exogenous variables | Captured intervention and calendar effects |
| Final forecasting benchmark | ETS | Outperformed SARIMA on short-term forecasting |

---

# Project Structure

```text
macroeconomic-time-series-forecasting/
│
├── data/
│
├── outputs/
│   ├── figures/
│   │   ├── main_series.png
│   │   ├── annual_trend.png
│   │   ├── seasonality.png
│   │   ├── classical_decomposition.png
│   │   ├── variance_diagnostics.png
│   │   ├── rolling_origin_performance.png
│   │   ├── residual_diagnostics.png
│   │   ├── ets_forecast.png
│   │   ├── annual_series.png
│   │   ├── annual_arima_diagnostics.png
│   │   ├── annual_arima_forecast.png
│   │   ├── ets_vs_arima.png
│   │   ├── seasonal_adjustment.png
│   │   ├── sarima_diagnostics.png
│   │   ├── sarima_forecast.png
│   │   ├── model_residuals_comparison.png
│   │   └── forecast_comparison.png
│   │
│   └── tables/
│       ├── summary_statistics.csv
│       ├── outlier_dates.csv
│       ├── model_comparison.csv
│       ├── rolling_origin_metrics.csv
│       ├── residual_outliers.csv
│       ├── annual_arima_metrics.csv
│       ├── arima_orders.csv
│       ├── annual_model_comparison.csv
│       ├── seasonal_tests.csv
│       ├── intervention_effects.csv
│       ├── sarima_metrics.csv
│       └── final_model_comparison.csv
│
├── scripts/
│   ├── exploratory_analysis.R
│   ├── ets_modelling.R
│   ├── arima_modelling.R
│   └── seasonal_arima_modelling.R
│
├── README.md
├── .gitignore
└── LICENSE

```

---

# Phase 1 — Exploratory Time Series Analysis

The first stage focused on identifying the structural properties of the series before statistical modelling.

## Main Outputs

| Output | Description |
| --- | --- |
| `main_series.png` | Original monthly import series |
| `annual_trend.png` | Aggregated annual macroeconomic trend |
| `seasonality.png` | Monthly subseries and seasonal structure |
| `classical_decomposition.png` | Trend-seasonal-residual decomposition |
| `variance_diagnostics.png` | Mean-variance diagnostics |
| `outlier_dates.csv` | Detected extreme events |
| `summary_statistics.csv` | Descriptive statistics |

## Main Findings

### Trend Structure

The series closely follows the European macroeconomic cycle:

* Sustained expansion before 2008
* Severe contraction during the financial crisis
* Progressive post-crisis recovery
* Abrupt COVID-19 shock in 2020

### Seasonality

A strong and persistent seasonal structure was identified:

* August consistently presents the lowest import volumes
* March and October systematically show the highest activity

This behaviour reflects industrial shutdown periods, logistics seasonality and commercial campaign cycles.

### Structural Interventions

Residual analysis identified extreme deviations associated with:

* The 2008 financial crisis
* Pandemic-related supply-chain disruption

These events motivated the later inclusion of intervention variables in forecasting models.

### Variance Dynamics

Variance diagnostics suggested occasional volatility amplification during exceptionally high import regimes, motivating additional modelling evaluation in later stages and careful consideration of data transformations (e.g., logarithmic scale).

---

# Phase 2 — Exponential Smoothing Models (ETS)

The second phase focused on predictive modelling using Exponential Smoothing State Space Models (ETS).

The objective was not only to obtain accurate forecasts, but also to evaluate predictive robustness under realistic out-of-sample conditions.

---

## Methodology

### Forecasting Models

Several forecasting approaches were evaluated:

* Automatic ETS optimisation
* Manual ETS(A,A,A)
* Seasonal naïve benchmark (`snaive`)
* Alternative ETS optimisation strategies

### Rolling-Origin Cross-Validation

Forecasting performance was evaluated through rolling-origin validation rather than relying exclusively on in-sample fit.

Evaluation metrics included:

* RMSE
* MAE
* MAPE
* MPE

This framework repeatedly simulated historical forecasting exercises under changing training windows and future holdout periods.

---

## ETS Outputs

| Output | Description |
| --- | --- |
| `model_comparison.csv` | Forecasting performance comparison |
| `rolling_origin_performance.png` | Forecast accuracy across horizons |
| `rolling_origin_metrics.csv` | Detailed validation metrics |
| `residual_diagnostics.png` | Residual diagnostics |
| `residual_outliers.csv` | Extreme residual events |
| `ets_forecast.png` | Multi-step ETS forecast |

---

## Main ETS Findings

### Best Performing ETS Model

Automatic ETS optimisation achieved the strongest predictive performance.

| Metric | Value |
| --- | --- |
| In-Sample MAPE | 2.77% |
| Validation MAPE | 7.39% |

*Note: It is critical to distinguish between in-sample fit (2.77%) and true out-of-sample forecasting ability (7.39%), as highly seasonal macroeconomic series are prone to overfitting.*

The ETS framework substantially outperformed both:

* Seasonal naïve benchmark
* Manual ETS(A,A,A)

Cross-validation results demonstrated stable forecasting behaviour across multiple horizons.

### Residual Behaviour

Residual diagnostics indicated that ETS successfully captured:

* Long-term trend
* Seasonal dynamics
* Most systematic temporal structure

An extreme residual event was identified in January 2008, corresponding to the global financial crisis.

### Forecast Behaviour

The ETS forecast projected:

* Relative macroeconomic stabilisation
* Persistent seasonal oscillations
* Gradual uncertainty expansion

---

# Phase 3 — Structural ARIMA Modelling

The third phase focused on modelling the long-term macroeconomic trajectory using non-seasonal ARIMA methodologies.

Instead of modelling the highly seasonal monthly data directly, the series was aggregated annually to isolate long-run structural behaviour.

---

## Methodology

### Annual Aggregation

Monthly imports were aggregated into annual totals to remove high-frequency seasonality and simplify structural modelling.

### Stationarity Analysis

Stationarity diagnostics included:

* KPSS tests
* Augmented Dickey-Fuller tests
* Automatic differencing diagnostics

Results for the short annual series ($N \approx 25$) yielded mixed evidence (KPSS suggested $d=0$, while ADF yielded $p=0.22$). Given the low power of unit root tests on short samples and visual evidence of structural changes, the selection process required careful assessment.

### ARIMA Estimation

Automatic ARIMA optimisation identified the best specification as:

* **ARIMA(1,0,0) with non-zero mean**

This suggests that annual import dynamics are largely explained by persistence from the immediately previous year.

---

## ARIMA Outputs

| Output | Description |
| --- | --- |
| `annual_series.png` | Annual aggregated import series |
| `annual_arima_metrics.csv` | Stationarity diagnostics |
| `arima_orders.csv` | Selected ARIMA orders |
| `annual_arima_diagnostics.png` | Residual diagnostics |
| `annual_model_comparison.csv` | ETS vs ARIMA benchmark |
| `ets_vs_arima.png` | Forecast comparison |
| `annual_arima_forecast.png` | Long-term ARIMA forecast |

---

## Main ARIMA Findings

### Stationarity

The selected model assumed stationarity without differencing ($d=0$), prioritizing a simplified interpretation while acknowledging the presence of unmodelled macroeconomic cycles.

### Selected Model

The optimal model identified was:

* **ARIMA(1,0,0)**

The specification is parsimonious and economically interpretable.

### Benchmark Comparison

| Model | MAPE |
| --- | --- |
| ARIMA | 4.12% |
| ETS | 5.02% |

ARIMA outperformed ETS for long-run macroeconomic behaviour, while ETS remained stronger for highly seasonal short-term forecasting.

---

# Phase 4 — Comparative Seasonal Forecasting Framework

The final stage extended forecasting capabilities using Seasonal ARIMA models combined with intervention analysis and calendar-related exogenous variables.

This phase incorporated seasonal dynamics, structural shocks and trading-day effects into the forecasting framework.

---

## Methodology

### Stationarity and Differencing

Formal stationarity diagnostics were conducted using:

* ADF tests
* KPSS tests
* `ndiffs()`
* `nsdiffs()`

Results showed that the monthly series required:

| Parameter | Value |
| --- | --- |
| Regular differencing (`d`) | 1 |
| Seasonal differencing (`D`) | 0 |

This avoided unnecessary over-differencing and preserved the structural properties of the series.

### Exogenous Variables

Two external effects were incorporated into the SARIMA framework:

#### Intervention Variable

A dummy intervention variable was introduced for the January 2008 financial shock.

#### Calendar Effects

A trading-day adjustment based on the number of days per month (`days_month`) was incorporated to capture calendar-related import fluctuations.

### SARIMA Estimation

Automatic seasonal ARIMA optimisation identified a specification containing:

* Two autoregressive components
* One moving-average component
* One seasonal moving-average component

The final model incorporated both seasonal structure and external regressors.

---

## SARIMA Outputs

| Output | Description |
| --- | --- |
| `seasonal_tests.csv` | Stationarity and differencing diagnostics |
| `seasonal_adjustment.png` | Seasonal adjustment diagnostics |
| `intervention_effects.csv` | Estimated exogenous effects |
| `sarima_metrics.csv` | Final SARIMA metrics |
| `sarima_diagnostics.png` | Residual diagnostics |
| `model_residuals_comparison.png` | ETS vs SARIMA residual comparison |
| `final_model_comparison.csv` | Final forecasting benchmark |
| `sarima_forecast.png` | SARIMA forecast |
| `forecast_comparison.png` | Forecast comparison across models |

---

## Main SARIMA Findings

### Structural Shock Quantification

The intervention analysis quantified the January 2008 shock as:

| Variable | Estimated Effect |
| --- | --- |
| 2008 intervention | +1684.53 kilotonnes |

Rather than representing the macroeconomic contraction of the crisis itself, this coefficient captures an anomalous positive spike (Additive Outlier) immediately preceding the global financial collapse.

### Calendar Effects

The calendar variable returned an unexpected effect:

| Variable | Estimated Effect |
| --- | --- |
| `days_month` | -9.34 kilotonnes/day |

The negative coefficient counterintuitively suggests fewer imports in longer months. This indicates the variable is likely confounding pure trading-day effects with the strong August seasonal drop (a 31-day month with industrial shutdowns), suggesting that future iterations should use "working days" rather than raw month length.

### Model Diagnostics

| Metric | Value |
| --- | --- |
| MAE | 404.04 kilotonnes |

Residual diagnostics indicated that while the SARIMA framework successfully captured the main trend and interventions, the ACF plots revealed some remaining unmodelled seasonal structure at lags 12 and 24, indicating the model residuals are not entirely white noise.

### Final Benchmark Comparison

An important empirical result emerged from the final forecasting benchmark:

| Model | MAPE |
| --- | --- |
| ETS | 7.39% |
| SARIMA | 8.11% |

*(Note: When comparing models, it is crucial to ensure both MAPEs are calculated on the back-transformed original scale if any logarithmic transformation was applied during the ETS modelling phase).*

Despite the greater structural sophistication of SARIMA, ETS remained slightly superior for short-to-medium term forecasting accuracy on this specific monthly series. This highlights the strong adaptive capacity of exponential smoothing methods under highly seasonal macroeconomic environments.

### Forecast Behaviour

Both ETS and SARIMA projected:

* Relative macroeconomic stabilisation
* Persistent seasonal oscillations
* Absence of major structural collapse

However:

* SARIMA generated smoother and more structurally constrained forecasts
* ETS captured short-term seasonal fluctuations more flexibly

---

# Main Statistical Techniques

* Classical time series decomposition
* Exponential smoothing state-space models (ETS)
* ARIMA and SARIMA modelling
* Rolling-origin cross-validation
* Intervention analysis
* Calendar effect modelling
* Residual diagnostics
* Stationarity testing
* Multi-horizon forecasting evaluation
* Forecast benchmarking

---

# Technologies

* R
* tidyverse
* forecast
* ggplot2
* lubridate
* tsibble
* feasts
* tseries
* seasonal
* tsoutliers

---

# Required Packages

forecast
ggplot2
tidyverse
lubridate
tseries
seasonal
tsoutliers
feasts
tsibble

---

# Reproducibility

All analyses were developed in R.

Each project phase is fully reproducible through the scripts contained in the `/scripts` directory. Figures and tables are automatically exported to the `/outputs` folder.

---

# Author

**Adrián Gómez Conde**

MSc Biostatistics Candidate

Statistical Modelling · Forecasting · Applied Data Analysis
