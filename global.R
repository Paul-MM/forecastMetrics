suppressPackageStartupMessages({
  library(shiny)          # web framework
  library(lubridate)      # date handling
  library(plotly)         # interactive plots
  library(readr)          # fast I/O
  library(dplyr)          # data wrangling 
})

# ggplot Holt Winters function
source("HWplot.R")

# Enable bookmarking for this app
enableBookmarking(store = "url")

# LOAD DATA ----------------------------------------------------------------------------------------

# Set path for data files
dataPath <- "/proj/workforce/data/shinyApps/"

# Load new big df
df <- read_csv(paste0(dataPath,"forecastMetrics/timeSeries.csv"))

# Remove 2nd Snpsht_Dt column
df <- df[, !names(df) %in% "Snpsht_Dt_1"]
