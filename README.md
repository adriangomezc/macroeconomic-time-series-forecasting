# Macroeconomic Time Series Forecasting: Spain–EU Imports

> A multivariate time series forecasting project focused on modelling Spanish imports from European countries using classical decomposition, exponential smoothing and seasonal ARIMA methodologies.

The project is designed as an applied macroeconomic forecasting workflow combining exploratory analysis, structural interpretation, statistical modelling and out-of-sample validation.

## Business Context

International trade volumes are strongly linked to macroeconomic cycles, industrial activity, logistics networks and external shocks. Understanding the temporal dynamics of imports is essential for:

- Supply chain planning
- Industrial demand estimation
- Logistics forecasting
- Economic monitoring
- Risk assessment during crises

This project analyses monthly Spanish imports from European countries between January 2000 and May 2025 using Eurostat data.

## Dataset

- **Source:** Eurostat
- **Frequency:** Monthly
- **Period:** 2000-01 to 2025-05
- **Variable:** Imports (kilotonnes)

The series contains:
- Long-term economic trend
- Strong annual seasonality
- Structural shocks
- Calendar-related effects
- Extreme macroeconomic interventions

## Exploratory Time Series Analysis

The first stage of the project focuses on identifying the structural properties of the series.

### Main outputs

| Output | Description |
| :--- | :--- |
| `main_series.png` | Original monthly import series |
| `annual_trend.png` | Annual aggregated macroeconomic trend |
| `seasonality.png` | Seasonal and monthly subseries analysis |
| `classical_decomposition.png` | Classical decomposition into trend, seasonal and residual components |
| `variance_diagnostics.png` | Mean-variance relationship diagnostics |
| `outlier_dates.csv` | Extreme events and anomaly dates |
| `summary_statistics.csv` | Descriptive statistics |

## Key Findings

### Trend
The series shows clear macroeconomic cycles:
- Sustained growth before 2008
- Strong contraction during the financial crisis
- Gradual post-crisis recovery
- Abrupt pandemic shock in 2020

### Seasonality
A strong and stable annual seasonal pattern is observed:
- **August** systematically presents the lowest import volumes.
- **March and October** consistently show the highest activity.

This behaviour is coherent with industrial and logistics dynamics in Spain.

### Structural shocks
Several extreme events were identified through residual diagnostics:
- 2008 financial crisis
- COVID-19 supply-chain disruption

These interventions will later be incorporated into forecasting models through intervention variables.

### Variance structure
Variance diagnostics suggest periods of volatility amplification during high-volume import regimes. This motivates further evaluation of variance-stabilising transformations during the modelling stage.

## Repository Structure

```text
macroeconomic-time-series-forecasting/
│
├── data/
├── outputs/
├── scripts/
│   └── exploratory_analysis.R
│
├── README.md
└── LICENSE

```

## Technologies

* R
* tidyverse
* forecast
* ggplot2
* lubridate
* tsibble
* feasts

## Next Steps

The next phase of the project will include:

* ETS modelling
* Seasonal ARIMA
* Intervention analysis
* Calendar effects
* Rolling-origin cross-validation
* Multi-horizon forecasting evaluation

---

## Author

**Adrián Gómez Conde** 
*MSc Biostatistics Candidate* 
Statistical Modelling · Forecasting · Applied Data Analysis
