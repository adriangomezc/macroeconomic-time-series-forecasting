# Macroeconomic Time Series Forecasting: Spain–EU Imports

> An applied forecasting project focused on modelling Spanish imports from European countries using exploratory time series analysis, exponential smoothing (ETS), intervention analysis and rolling-origin validation.

The project reproduces a realistic macroeconomic forecasting workflow used in consulting, supply-chain analytics and economic monitoring environments.

## Business Context

International trade volumes are highly sensitive to:

* Economic cycles
* Industrial production
* Supply-chain disruptions
* Seasonal logistics patterns
* Global shocks and crises

Reliable forecasting of import volumes is valuable for:

* Demand planning
* Logistics optimisation
* Inventory management
* Macroeconomic surveillance
* Risk management

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
│   │   └── ets_forecast.png
│   │
│   └── tables/
│       ├── summary_statistics.csv
│       ├── outlier_dates.csv
│       ├── model_comparison.csv
│       ├── rolling_origin_metrics.csv
│       └── residual_outliers.csv
│
├── scripts/
│   ├── exploratory_analysis.R
│   └── ets_modelling.R
│
├── README.md
└── LICENSE
```

---

# Phase 1 — Exploratory Time Series Analysis

The first stage focused on identifying the structural properties of the series before statistical modelling.

## Main Outputs

| Output                        | Description                              |
| ----------------------------- | ---------------------------------------- |
| `main_series.png`             | Original monthly import series           |
| `annual_trend.png`            | Aggregated annual macroeconomic trend    |
| `seasonality.png`             | Monthly subseries and seasonal structure |
| `classical_decomposition.png` | Trend-seasonal-residual decomposition    |
| `variance_diagnostics.png`    | Mean-variance diagnostics                |
| `outlier_dates.csv`           | Detected extreme events                  |
| `summary_statistics.csv`      | Descriptive statistics                   |

## Main Findings

### Trend Structure

The series follows the European macroeconomic cycle closely:

* Sustained expansion before 2008
* Severe contraction during the financial crisis
* Progressive post-crisis recovery
* Abrupt COVID-19 shock in 2020

### Seasonality

A strong and persistent seasonal pattern is observed:

* August systematically records the lowest import activity.
* March and October consistently present the highest volumes.

This behaviour reflects industrial shutdowns, logistics seasonality and commercial campaign cycles.

### Structural Interventions

Residual analysis identified extreme deviations associated with:

* The 2008 global financial crisis
* Pandemic-related supply-chain disruption

These events motivate the inclusion of intervention variables in later forecasting models.

### Variance Dynamics

Variance diagnostics suggest occasional volatility amplification during periods of exceptionally high import activity, motivating evaluation of alternative modelling specifications during forecasting stages.

---

# Phase 2 — Exponential Smoothing Models (ETS)

The second phase focused on predictive modelling using Exponential Smoothing State Space Models (ETS).

The objective was not only to obtain accurate forecasts, but also to evaluate model robustness under realistic out-of-sample conditions.

---

# Methodology

## Model Candidates

Several forecasting approaches were evaluated:

* Automatic ETS optimisation
* Fixed ETS(A,A,A)
* Seasonal naïve benchmark (`snaive`)
* ETS variants with alternative optimisation strategies

## Rolling-Origin Cross-Validation

Instead of relying only on in-sample fit, models were evaluated through rolling-origin forecasting validation.

This procedure repeatedly simulates historical forecasting exercises using moving training windows and future holdout periods.

Evaluation metrics included:

* RMSE
* MAE
* MAPE
* MPE

This framework provides a more realistic estimate of forecasting performance under production conditions.

---

# ETS Outputs

| Output                           | Description                                            |
| -------------------------------- | ------------------------------------------------------ |
| `model_comparison.csv`           | Forecasting performance comparison across ETS variants |
| `rolling_origin_performance.png` | Cross-validation performance across forecast horizons  |
| `rolling_origin_metrics.csv`     | Detailed rolling-origin metrics                        |
| `residual_diagnostics.png`       | Residual behaviour and model diagnostics               |
| `residual_outliers.csv`          | Extreme residual events                                |
| `ets_forecast.png`               | Final multi-step ETS forecast                          |

---

# Key Results

## Best Performing Model

Automatic ETS optimisation achieved the best overall forecasting performance.

### Final Performance

| Metric | Value |
| ------ | ----- |
| MAPE   | 2.77% |
| MPE    | -2.1% |

The model substantially outperformed:

* Seasonal naïve benchmark
* Manual ETS(A,A,A) specification

This indicates strong predictive capacity and low forecast bias.

---

## Rolling-Origin Validation

Cross-validation results showed that ETS maintained:

* Lower prediction errors
* Greater stability
* Better robustness across forecast horizons

compared with the naïve benchmark.

The performance gap remained consistent across multiple forecasting windows, reducing the risk of overfitting.

---

## Residual Analysis

Residual diagnostics suggest that the ETS model successfully captured:

* Long-term trend
* Seasonal dynamics
* Most systematic temporal structure

Residuals fluctuate approximately around zero with limited autocorrelation.

However, an extreme positive residual was detected in:

* January 2008

This corresponds to a major structural shock associated with the financial crisis and will later be incorporated as an intervention variable within ARIMA modelling.

---

## Forecast Behaviour

The final ETS forecast projects:

* Relative macroeconomic stabilisation
* Persistent seasonal oscillations
* Moderate long-term uncertainty expansion

The model preserves realistic monthly import dynamics, including:

* August seasonal collapses
* Strong campaign-related peaks

Prediction intervals widen progressively as the forecasting horizon increases.

---

# Next Phase

The next stage of the project will extend forecasting capabilities using:

* Seasonal ARIMA models
* Calendar effects (trading days and Easter effects)
* Intervention analysis
* Structural shock correction
* Comparative forecasting evaluation

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

---

# Author

**Adrián Gómez Conde**
MSc Biostatistics Candidate
Statistical Modelling · Forecasting · Applied Data Analysis
