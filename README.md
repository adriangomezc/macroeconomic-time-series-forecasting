# Macroeconomic Time Series Forecasting: Spain–EU Imports

> An applied forecasting pipeline for modelling Spanish imports from European countries using exploratory time series analysis, exponential smoothing, rolling-origin validation and structural macroeconomic interpretation.

The project combines statistical forecasting, out-of-sample evaluation and economic interpretation to simulate a real-world macroeconomic analytics workflow.

---

# Business Context

International trade volumes are highly sensitive to:

* Macroeconomic cycles
* Industrial demand
* Supply-chain disruptions
* External geopolitical shocks
* Logistics bottlenecks
* Calendar and seasonal effects

Reliable import forecasting is valuable for:

* Supply chain optimisation
* Industrial production planning
* Logistics capacity management
* Economic monitoring
* Risk management during crises

This project analyses monthly Spanish imports from European countries between January 2000 and May 2025 using Eurostat data.

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
* Extreme interventions
* Volatility clustering
* Calendar-related distortions

---

# Phase 1 — Exploratory Time Series Analysis

The first phase focused on identifying the structural components of the series and detecting major macroeconomic interventions.

## Main Outputs

| Output                        | Description                                                   |
| ----------------------------- | ------------------------------------------------------------- |
| `main_series.png`             | Original monthly import series                                |
| `annual_trend.png`            | Aggregated annual macroeconomic trend                         |
| `seasonality.png`             | Seasonal subseries and yearly seasonality plots               |
| `classical_decomposition.png` | Classical decomposition into trend, seasonality and residuals |
| `variance_diagnostics.png`    | Mean-variance diagnostics                                     |
| `outlier_dates.csv`           | Detected anomaly dates                                        |
| `summary_statistics.csv`      | Descriptive statistics                                        |

## Key Findings

### Trend structure

The series reflects several major macroeconomic phases:

* Sustained expansion before 2008
* Severe contraction during the global financial crisis
* Gradual post-crisis recovery
* Abrupt pandemic-related disruption in 2020

### Seasonality

A strong and persistent annual seasonal pattern is observed:

* August systematically presents the lowest import levels.
* March and October consistently show peak activity.

This behaviour is coherent with Spanish industrial and logistics seasonality.

### Structural interventions

Residual diagnostics identified major outlier periods linked to:

* The 2008 financial crisis
* COVID-19 supply-chain disruption

These interventions become critical inputs for later forecasting models.

### Variance structure

Variance diagnostics suggest periods of volatility amplification during high-volume regimes, motivating additional modelling evaluation during forecasting stages.

---

# Phase 2 — Exponential Smoothing & Forecasting

The second phase focused on predictive modelling using Exponential Smoothing State Space Models (ETS).

The objective was not only to optimise in-sample fit, but to evaluate genuine forecasting performance under rolling-origin validation.

---

## Forecasting Methodology

Several forecasting approaches were evaluated:

* Automatic ETS selection
* Manual ETS(A,A,A)
* Seasonal naïve benchmark (`snaive`)

Model performance was assessed through:

* Rolling-origin cross-validation
* Multi-horizon forecasting evaluation
* Out-of-sample error comparison

Evaluation metrics included:

* RMSE
* MAE
* MAPE

---

# Phase 2 Outputs

| Output                           | Description                                               |
| -------------------------------- | --------------------------------------------------------- |
| `model_comparison.csv`           | Comparative performance metrics across forecasting models |
| `rolling_origin_performance.png` | Rolling-origin forecasting performance                    |
| `rolling_origin_metrics.csv`     | Detailed rolling validation errors                        |
| `ets_forecast.png`               | Final ETS multi-step forecast                             |
| `residual_diagnostics.png`       | Residual diagnostics and autocorrelation analysis         |
| `residual_outliers.csv`          | Extreme residual events detected after ETS modelling      |

---

# Key Forecasting Findings

## ETS performance

Exponential smoothing models substantially outperformed the seasonal naïve benchmark.

The best-performing ETS specification achieved:

* Lower forecasting error
* More stable multi-horizon predictions
* Better adaptation to structural level changes

This demonstrates that statistical modelling captures relevant market dynamics beyond simple seasonal repetition.

---

## Rolling-origin validation

Rather than relying exclusively on in-sample fit, the models were evaluated using rolling forecasting origin validation.

This approach simulates real operational forecasting conditions by repeatedly:

1. Training on historical data
2. Forecasting unseen future observations
3. Measuring forecasting error

The ETS framework consistently maintained lower prediction error across multiple horizons compared with naïve forecasting.

---

## Forecast dynamics

The final ETS forecast preserves:

* Stable long-term trend
* Strong annual seasonality
* Increasing uncertainty over time

Prediction intervals widen progressively, reflecting realistic forecasting uncertainty in macroeconomic systems.

---

## Residual diagnostics

Residual analysis indicates that most systematic structure was successfully captured by the ETS model.

However, several residual spikes remain associated with exceptional macroeconomic events, particularly:

* January 2008
* Pandemic-related disruptions

These events motivate the inclusion of intervention variables and calendar effects in later SARIMA modelling.

---

# Repository Structure

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
│   │   ├── ets_forecast.png
│   │   └── residual_diagnostics.png
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
│   └── ets_forecasting.R
│
├── README.md
└── LICENSE
```

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
* gridExtra

---

# Next Steps

The next modelling stage will extend the pipeline using:

* Seasonal ARIMA (SARIMA)
* Intervention analysis
* Trading-day effects
* Easter effects
* Automatic seasonal adjustment
* Calendar-aware forecasting
* Advanced residual diagnostics
* Comparative model selection

---

# Author

**Adrián Gómez Conde**
MSc Biostatistics Candidate
Statistical Modelling · Forecasting · Applied Data Analysis
