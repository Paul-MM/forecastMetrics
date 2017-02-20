suppressMessages(library(shiny))          # web framework
suppressMessages(library(forecast))       # timeseries
suppressMessages(library(lubridate))      # data handling
suppressMessages(library(plotly))         # interactive plots
suppressMessages(library(readr))          # fast I/O
suppressMessages(library(dplyr))          # data wrangling 

source("HWplot.R")                        # ggplot Holt Winters function

# LOAD DATA ----------------------------------------------------------------------------------------

# Set path for data files
dataPath <- "/proj/workforce/data/shinyApps/"

ts_upl    <- read_csv(paste0(dataPath,"forecastMetrics/forecastUPL.csv"))
ts_pl     <- read_csv(paste0(dataPath,"forecastMetrics/forecastPL.csv"))
ts_ongHC  <- read_csv(paste0(dataPath,"forecastMetrics/forecastOngHC.csv"))
ts_nonHC  <- read_csv(paste0(dataPath,"forecastMetrics/forecastNonHC.csv"))
ts_casHC  <- read_csv(paste0(dataPath,"forecastMetrics/forecastCasHC.csv"))
ts_totHC  <- read_csv(paste0(dataPath,"forecastMetrics/forecastTotHC.csv"))
ts_ongFTE <- read_csv(paste0(dataPath,"forecastMetrics/forecastOngFTE.csv"))
ts_nonFTE <- read_csv(paste0(dataPath,"forecastMetrics/forecastNonFTE.csv"))
ts_casFTE <- read_csv(paste0(dataPath,"forecastMetrics/forecastCasFTE.csv"))
ts_totFTE <- read_csv(paste0(dataPath,"forecastMetrics/forecastTotFTE.csv"))
ts_attr   <- read_csv(paste0(dataPath,"forecastMetrics/forecastAttr.csv"))
ts_rdncy  <- read_csv(paste0(dataPath,"forecastMetrics/forecastRdncy.csv"))
ts_sepn   <- read_csv(paste0(dataPath,"forecastMetrics/forecastSepn.csv"))
ts_age    <- read_csv(paste0(dataPath,"forecastMetrics/forecastAge.csv"))
ts_atoTnr <- read_csv(paste0(dataPath,"forecastMetrics/forecastAtoTnr.csv"))
ts_apsTnr <- read_csv(paste0(dataPath,"forecastMetrics/forecastApsTnr.csv"))
ts_avgSal <- read_csv(paste0(dataPath,"forecastMetrics/forecastAvgSal.csv"))
ts_nesb   <- read_csv(paste0(dataPath,"forecastMetrics/forecastNESB.csv"))
ts_indg   <- read_csv(paste0(dataPath,"forecastMetrics/forecastIndg.csv"))
ts_dsbl   <- read_csv(paste0(dataPath,"forecastMetrics/forecastDsbl.csv"))

# TS OBJECTS ---------------------------------------------------------------------------------------

# Planned and Unplanned leave ####

# Start date manipulation and time series
ts_upl_dt   <- as.data.frame(ts_upl)   # need to coerce tbl.df back to data.frame 
ts_upl_dt   <- as.Date(ts_upl_dt[1,2]) # once back to data.frame can as.Date on ts_upl_dt[1,2]
ts_strt_mth <- month(ts_upl_dt)
ts_strt_yr  <- year(ts_upl_dt)
ts_upl      <- ts(data = ts_upl$R12, start = c(ts_strt_yr, ts_strt_mth), frequency = 12) 

# Start date manipulation and time series
ts_pl_dt    <- as.data.frame(ts_pl)   # need to coerce tbl.df back to data.frame 
ts_pl_dt    <- as.Date(ts_pl_dt[1,2]) # once back to data.frame can as.Date on ts_pl_dt[1,2]
ts_strt_mth <- month(ts_pl_dt)
ts_strt_yr  <- year(ts_pl_dt)
ts_pl       <- ts(data = ts_pl$R12, start = c(ts_strt_yr, ts_strt_mth), frequency = 12)

# Remaining measures ####
ts_ongHC  <- ts(data = ts_ongHC$Measure,  start = c(2007, 7), frequency = 12) 
ts_nonHC  <- ts(data = ts_nonHC$Measure,  start = c(2007, 7), frequency = 12)
ts_casHC  <- ts(data = ts_casHC$Measure,  start = c(2007, 7), frequency = 12) 
ts_totHC  <- ts(data = ts_totHC$Measure,  start = c(2007, 7), frequency = 12) 
ts_ongFTE <- ts(data = ts_ongFTE$Measure, start = c(2014, 3), frequency = 12) 
ts_nonFTE <- ts(data = ts_nonFTE$Measure, start = c(2014, 3), frequency = 12) 
ts_casFTE <- ts(data = ts_casFTE$Measure, start = c(2014, 3), frequency = 12) 
ts_totFTE <- ts(data = ts_totFTE$Measure, start = c(2014, 3), frequency = 12) 
ts_attr   <- ts(data = ts_attr$Measure,   start = c(2008, 7), frequency = 12)
ts_rdncy  <- ts(data = ts_rdncy$Measure,  start = c(2008, 7), frequency = 12) 
ts_sepn   <- ts(data = ts_sepn$Measure,   start = c(2008, 7), frequency = 12)
ts_age    <- ts(data = ts_age$Measure,    start = c(2007, 7), frequency = 12)
ts_atoTnr <- ts(data = ts_atoTnr$Measure, start = c(2007, 7), frequency = 12)
ts_apsTnr <- ts(data = ts_apsTnr$Measure, start = c(2007, 7), frequency = 12) 
ts_avgSal <- ts(data = ts_avgSal$Measure, start = c(2007, 7), frequency = 12)
ts_nesb   <- ts(data = ts_nesb$Measure,   start = c(2013, 7), frequency = 12)
ts_indg   <- ts(data = ts_indg$Measure,   start = c(2013, 7), frequency = 12)
ts_dsbl   <- ts(data = ts_dsbl$Measure,   start = c(2013, 7), frequency = 12)