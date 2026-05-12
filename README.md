# Macroeconomic Time Series Forecasting: Spain-EU Imports

This project analyses monthly Spanish imports from European countries using advanced time series analysis techniques in R.

The dataset covers the period from January 2000 to May 2025 and reflects major macroeconomic dynamics, including:

- Long-term economic growth
- Seasonal trading patterns
- Financial crisis disruptions
- COVID-19 shock effects
- Structural variability in international trade

---

# Project goals

The objective is to build a professional forecasting pipeline capable of:

- Understanding macroeconomic trade dynamics
- Identifying seasonal structures
- Detecting intervention points and external shocks
- Evaluating variance stability
- Preparing the series for advanced forecasting models

Future stages of the project will include:

- ETS modelling
- SARIMA modelling
- Calendar effects
- Rolling-origin cross-validation
- Forecast evaluation
- Multi-model comparison

---

# Exploratory analysis

The first stage of the project focuses on exploratory time series analysis.

Main analyses include:

- Long-term trend exploration
- Seasonal decomposition
- Monthly subseries analysis
- Mean-variance relationship assessment
- Intervention point detection

---

# Main findings

Key characteristics identified in the series:

- Strong yearly seasonality
- Persistent macroeconomic trend
- Abrupt structural shocks during 2008–2009 and 2020
- Lower import activity during August
- Higher trading activity around March and October

---

# Outputs

| File | Description |
|---|---|
| `original_series.png` | Monthly import series |
| `annual_trend.png` | Aggregated annual trend |
| `seasonal_patterns.png` | Seasonal diagnostics |
| `decomposition_plot.png` | Classical decomposition |
| `variance_analysis.png` | Mean-variance relationship |
| `intervention_points.csv` | Detected shock periods |

---

# Technologies

- R
- tidyverse
- forecast
- ggplot2
- feasts
- tsibble
- patchwork

---

# Author

Adrián Gómez Conde

MSc Biostatistics candidate  
Statistical modelling and applied data analysis
