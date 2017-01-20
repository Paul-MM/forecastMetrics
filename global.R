suppressMessages(library(shiny))          # web framework
suppressMessages(library(forecast))       # timeseries
suppressMessages(library(lubridate))      # data handling
suppressMessages(library(plotly))         # interactive plots
suppressMessages(library(readr))          # fast I/O
suppressMessages(library(dplyr))          # data wrangling 

source("data/HWplot.R")                   # ggplot Holt Winters function

# TS OBJECTS ---------------------------------------------------------------------------------------

# Unplanned leave ####

# load data
ts_upl <- read_csv("data/ts_upl.csv")

# ts start date manipulation
ts_upl_dt   <- as.data.frame(ts_upl)   # need to coerce tbl.df back to data.frame 
ts_upl_dt   <- as.Date(ts_upl_dt[1,2]) # once back to data.frame can as.Date on ts_upl_dt[1,2]
ts_strt_mth <- month(ts_upl_dt)
ts_strt_yr  <- year(ts_upl_dt)

# create time series
ts_upl <- ts(data = ts_upl$R12, start = c(ts_strt_yr, ts_strt_mth), frequency = 12) 

# Planned leave ####

# load data
ts_pl <- read_csv("data/ts_pl.csv")

# ts start date manipulation
ts_pl_dt    <- as.data.frame(ts_pl)   # need to coerce tbl.df back to data.frame 
ts_pl_dt    <- as.Date(ts_pl_dt[1,2]) # once back to data.frame can as.Date on ts_pl_dt[1,2]
ts_strt_mth <- month(ts_pl_dt)
ts_strt_yr  <- year(ts_pl_dt)

# create time series
ts_pl <- ts(data = ts_pl$R12, start = c(ts_strt_yr, ts_strt_mth), frequency = 12)

# Ongoing hc ####
ts_ongHC <- read_csv("data/ts_ongHC.csv")
ts_ongHC <- ts(data = ts_ongHC$Measure, start = c(2007, 7), frequency = 12) 

# Non-ongoing hc ####
ts_nonHC <- read_csv("data/ts_nonHC.csv")
ts_nonHC <- ts(data = ts_nonHC$Measure, start = c(2007, 7), frequency = 12)

# Casual hc ####
ts_casHC <- read_csv("data/ts_casHC.csv")
ts_casHC <- ts(data = ts_casHC$Measure, start = c(2007, 7), frequency = 12) 

# Total hc ####
ts_totHC <- read_csv("data/ts_totHC.csv")
ts_totHC <- ts(data = ts_totHC$Measure, start = c(2007, 7), frequency = 12) 

# Ongoing fte ####
ts_ongFTE <- read_csv("data/ts_ongFTE.csv")
ts_ongFTE <- ts(data = ts_ongFTE$Measure, start = c(2014, 3), frequency = 12) 

# Non-ongoing fte ####
ts_nonFTE <- read_csv("data/ts_nonFTE.csv")
ts_nonFTE <- ts(data = ts_nonFTE$Measure, start = c(2014, 3), frequency = 12) 

# Casual fte ####
ts_casFTE <- read_csv("data/ts_casFTE.csv")
ts_casFTE <- ts(data = ts_casFTE$Measure, start = c(2014, 3), frequency = 12) 

# Total fte ####
ts_totFTE <- read_csv("data/ts_totFTE.csv")
ts_totFTE <- ts(data = ts_totFTE$Measure, start = c(2014, 3), frequency = 12) 

# Attrition ####
ts_attr <- read_csv("data/ts_attr.csv")
ts_attr <- ts(data = ts_attr$R12_Attrition_Rate, start = c(2008, 7), frequency = 12)

# Redundancy ####
ts_rdncy <- read_csv("data/ts_rdncy.csv")
ts_rdncy <- ts(ts_rdncy$R12_Redundancy_Rate, start = c(2008, 7), frequency = 12) 

# Ongoing sepn ####
ts_ong <- read_csv("data/ts_ong.csv")
ts_ong <- ts(data = ts_ong$R12_Ongoing_Rate, start = c(2008, 7), frequency = 12)

# Age ####
ts_age <- read_csv("data/ts_age.csv")
ts_age <- ts(data = ts_age$Measure, start = c(2007, 7), frequency = 12)

# AtoTnr ####
ts_atoTnr <- read_csv("data/ts_atoTnr.csv")
ts_atoTnr <- ts(ts_atoTnr$Measure, start = c(2007, 7), frequency = 12)

# ApsTnr ####
ts_apsTnr <- read_csv("data/ts_apsTnr.csv")
ts_apsTnr <- ts(data = ts_apsTnr$Measure, start = c(2007, 7), frequency = 12) 

# Average salary ####
ts_avgSal <- read_csv("data/ts_avgSal.csv")
ts_avgSal <- ts(data = ts_avgSal$`Female %`, start = c(2007, 7), frequency = 12) 

# NESB ####
ts_nesb <- read_csv("data/ts_nesb.csv")
ts_nesb <- ts(data = ts_nesb$NESB_Rate, start = c(2013, 7), frequency = 12)

# Indigenous ####
ts_indg <- read_csv("data/ts_indg.csv")
ts_indg <- ts(data = ts_indg$Indg_Rate, start = c(2013, 7), frequency = 12)

# Disability ####
ts_dsbl <- read_csv("data/ts_dsbl.csv")
ts_dsbl <- ts(data = ts_dsbl$Dsbl_Rate, start = c(2013, 7), frequency = 12)