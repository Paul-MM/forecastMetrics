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
data_path <- "/proj/workforce/data/shinyApps/"

# Load new big df
df <- read_csv(paste0(data_path,"forecastMetrics/timeSeries.csv"))

# Remove 2nd Snpsht_Dt column
df <- df[, !names(df) %in% "Snpsht_Dt_1"]
