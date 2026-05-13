required_packages <- c(
  "forecast",
  "tidyverse",
  "ggplot2",
  "lubridate",
  "tseries",
  "tsoutliers",
  "feasts",
  "seasonal"
)

installed <- rownames(installed.packages())

for(pkg in required_packages){
  if(!(pkg %in% installed)){
    install.packages(pkg)
  }
}
