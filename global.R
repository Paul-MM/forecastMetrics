suppressPackageStartupMessages({
  library(shiny)          # web framework
  library(lubridate)      # data handling
  library(plotly)         # interactive plots
  library(readr)          # fast I/O
  library(dplyr)          # data wrangling 
})

source("HWplot.R")                        # ggplot Holt Winters function

# Enable bookmarking for this app
enableBookmarking(store = "url")

# LOAD DATA ----------------------------------------------------------------------------------------

# Set path for data files
dataPath <- "/proj/workforce/data/shinyApps/"

# Load new big df
df <- read_csv(paste0(dataPath,"forecastMetrics/TMP_timeSeries.csv"))

# Separation Rate (%)
ts_sepn     <- read_csv(paste0(dataPath,"forecastMetrics/forecastSepn.csv"))
ts_attr     <- read_csv(paste0(dataPath,"forecastMetrics/forecastAttr.csv"))
ts_rdncy    <- read_csv(paste0(dataPath,"forecastMetrics/forecastRdncy.csv"))
ts_attrpcnt <- data.frame(Measure=(ts_attr$Measure/ts_sepn$Measure)*100, Sepn_Mth=ts_sepn$Sepn_Mth)
ts_rdncypcnt<- data.frame(Measure=(ts_rdncy$Measure/ts_sepn$Measure)*100, Sepn_Mth=ts_sepn$Sepn_Mth)
