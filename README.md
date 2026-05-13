# Macroeconomic Time Series Forecasting: Spain–EU Imports

> An applied forecasting project focused on modelling Spanish imports from European countries using exploratory analysis, exponential smoothing (ETS), ARIMA modelling and out-of-sample validation techniques.

The project reproduces a realistic macroeconomic forecasting workflow commonly used in consulting, supply-chain analytics and economic monitoring environments.

---

## Business Context

International trade volumes are highly sensitive to:
- Economic cycles
- Industrial production
- Supply-chain disruptions
- Seasonal logistics patterns
- Global macroeconomic shocks

Reliable forecasting of import volumes is valuable for:
- Demand planning
- Logistics optimisation
- Inventory management
- Macroeconomic surveillance
- Risk management

This project analyses monthly Spanish imports from European countries between January 2000 and May 2025 using official Eurostat data.

---

## Dataset

- **Source:** Eurostat
- **Frequency:** Monthly
- **Period:** 2000-01 to 2025-05
- **Variable:** Imports (kilotonnes)

The series exhibits:
- Long-term macroeconomic trend
- Strong annual seasonality
- Structural breaks
- Extreme external shocks
- Volatility changes over time

---

## Project Structure

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
│   │   └── ets_vs_arima.png
│   │
│   └── tables/
│       ├── summary_statistics.csv
│       ├── outlier_dates.csv
│       ├── model_comparison.csv
│       ├── rolling_origin_metrics.csv
│       ├── residual_outliers.csv
│       ├── annual_arima_metrics.csv
│       ├── arima_orders.csv
│       └── annual_model_comparison.csv
│
├── scripts/
│   ├── exploratory_analysis.R
│   ├── ets_modelling.R
│   └── arima_modelling.R
│
├── README.md
└── LICENSE

```

---

## Phase 1 — Exploratory Time Series Analysis

The first stage focused on identifying the structural properties of the series before statistical modelling.

### Main Outputs

| Output | Description |
| --- | --- |
| `main_series.png` | Original monthly import series |
| `annual_trend.png` | Aggregated annual macroeconomic trend |
| `seasonality.png` | Monthly subseries and seasonal structure |
| `classical_decomposition.png` | Trend-seasonal-residual decomposition |
| `variance_diagnostics.png` | Mean-variance diagnostics |
| `outlier_dates.csv` | Detected extreme events |
| `summary_statistics.csv` | Descriptive statistics |

### Main Findings

**Trend Structure**
The series follows the European macroeconomic cycle closely:

* Sustained expansion before 2008
* Severe contraction during the financial crisis
* Progressive post-crisis recovery
* Abrupt COVID-19 shock in 2020

**Seasonality**
A strong and persistent seasonal pattern is observed:

* August systematically records the lowest import activity.
* March and October consistently present the highest volumes.

This behaviour reflects industrial shutdowns, logistics seasonality and commercial campaign cycles.

**Structural Interventions**
Residual analysis identified extreme deviations associated with:

* The 2008 global financial crisis
* Pandemic-related supply-chain disruption

These events motivate the inclusion of intervention variables in later forecasting models.

**Variance Dynamics**
Variance diagnostics suggest occasional volatility amplification during periods of exceptionally high import activity.

---

## Phase 2 — Exponential Smoothing Models (ETS)

The second phase focused on predictive modelling using Exponential Smoothing State Space Models (ETS). The objective was not only to obtain accurate forecasts, but also to evaluate model robustness under realistic out-of-sample conditions.

### Methodology

**Forecasting Models**
Several forecasting approaches were evaluated:

* Automatic ETS optimisation
* Manual ETS(A,A,A)
* Seasonal naïve benchmark (snaive)
* Alternative ETS optimisation criteria

**Rolling-Origin Cross-Validation**
Models were evaluated using rolling-origin forecasting validation instead of relying exclusively on in-sample fit. This approach repeatedly simulates historical forecasting exercises under changing training windows.
Evaluation metrics included RMSE, MAE, MAPE, and MPE.

### ETS Outputs

| Output | Description |
| --- | --- |
| `model_comparison.csv` | Forecasting performance comparison |
| `rolling_origin_performance.png` | Forecast accuracy across horizons |
| `rolling_origin_metrics.csv` | Detailed validation metrics |
| `residual_diagnostics.png` | Residual diagnostics |
| `residual_outliers.csv` | Extreme residual events |
| `ets_forecast.png` | Multi-step ETS forecast |

### Key Results

**Best Performing ETS Model**
Automatic ETS optimisation achieved the strongest forecasting performance.

| Metric | Value |
| --- | --- |
| MAPE | 2.77% |
| MPE | -2.1% |

The model substantially outperformed both the Seasonal naïve benchmark and the manual ETS(A,A,A) specification. Cross-validation results demonstrated stable forecasting behaviour across prediction horizons, reducing the risk of overfitting.

**Residual Behaviour**
Residual diagnostics indicate that the ETS framework successfully captured the long-term trend, seasonal structure, and most systematic temporal dynamics. An extreme residual event was detected in January 2008, corresponding to the global financial crisis.

**Forecast Behaviour**
The ETS forecast projects relative macroeconomic stabilisation, persistent seasonal oscillations, and gradual uncertainty expansion over longer horizons.

---

## Phase 3 — Structural ARIMA Modelling

The third phase focused on statistical modelling of the long-term macroeconomic trajectory using non-seasonal ARIMA methodologies. Instead of directly modelling the highly seasonal monthly data, the series was aggregated annually in order to isolate the structural economic component and reduce short-term seasonal noise.

### Methodology

**Annual Aggregation**
Monthly imports were aggregated into annual totals to remove high-frequency seasonality, isolate macroeconomic trend behaviour, and simplify long-run structural modelling.

**Stationarity Analysis**
Stationarity diagnostics included KPSS tests, Augmented Dickey-Fuller tests, and automatic differencing diagnostics (`ndiffs()`). Results indicated that the annual series was already stationary in levels.

**ARIMA Estimation**
Model selection was performed using automatic ARIMA optimisation, exhaustive parameter search, and information criteria minimisation. The final specification selected by the algorithm was **ARIMA(1,0,0) with non-zero mean**. This indicates that annual import dynamics are primarily explained by persistence from the immediately previous year.

### ARIMA Outputs

| Output | Description |
| --- | --- |
| `annual_series.png` | Annual aggregated import series |
| `annual_arima_metrics.csv` | Stationarity diagnostics |
| `arima_orders.csv` | Selected ARIMA orders |
| `annual_arima_diagnostics.png` | Residual diagnostics |
| `annual_model_comparison.csv` | ETS vs ARIMA benchmark |
| `ets_vs_arima.png` | Forecast comparison |
| `annual_arima_forecast.png` | Long-term ARIMA forecast |

### Main ARIMA Findings

**Stationarity**
The annual series was found to be stationary without differencing:

| Metric | Result |
| --- | --- |
| Recommended differences (d) | 0 |

This simplified model interpretation and reduced unnecessary transformations.

**Selected Model**
The optimal model identified was **ARIMA(1,0,0)**. The model is parsimonious and economically interpretable, suggesting strong year-to-year persistence in Spanish import volumes.

**Benchmark Comparison**
When evaluated against ETS on annual data:

| Model | MAPE |
| --- | --- |
| ARIMA | 4.12% |
| ETS | 5.02% |

ARIMA achieved superior performance for long-run macroeconomic dynamics, while ETS remained stronger for short-term seasonal forecasting.

**Long-Term Forecast**
The annual ARIMA forecast projects relative macroeconomic stabilisation over the coming years, with volumes remaining approximately around 77,000 kilotonnes annually.

---

## Next Phase

The next stage of the project will extend forecasting capabilities using:

* Seasonal ARIMA (SARIMA)
* Calendar effects (Easter effects, Trading-day corrections)
* Intervention analysis and structural shock modelling
* Advanced residual diagnostics

This phase will move the project closer to real-world economic forecasting systems used in production environments.

---

## Technologies

* R
* tidyverse
* forecast
* ggplot2
* lubridate
* tsibble
* feasts
* tseries

# Author

**Adrián Gómez Conde**
MSc Biostatistics Candidate
Statistical Modelling · Forecasting · Applied Data Analysis
