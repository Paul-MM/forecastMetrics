suppressMessages(library(shiny))
suppressMessages(library(forecast))       # timeseries
suppressMessages(library(lubridate))      # data handling
suppressMessages(library(plotly))         # interactive plots
suppressMessages(library(readr))          # fast I/O
suppressMessages(library(dplyr))          # data wrangling 

source("data/HWplot.R")# ggplot Holt Winters fn

#__________________________________________________________________________________________________#

# Unplanned leave

# load data
ts_upl <- read_csv("data/ts_upl.csv")

# ts start date manipulation
ts_upl_dt   <- as.data.frame(ts_upl) # need to coerce tbl.df back to data.frame 
ts_upl_dt   <- as.Date(ts_upl_dt[1,2]) # once back to data.frame can as.Date on ts_upl_dt[1,2]
ts_strt_mth <- month(ts_upl_dt)
ts_strt_yr  <- year(ts_upl_dt)

# create time series
ts_upl <- ts(ts_upl$R12, start = c(ts_strt_yr, ts_strt_mth), frequency = 12) 

#__________________________________________________________________________________________________#

# Planned leave

# load data
ts_pl <- read_csv("data/ts_pl.csv")

# ts start date manipulation
ts_pl_dt    <- as.data.frame(ts_pl) # need to coerce tbl.df back to data.frame 
ts_pl_dt    <- as.Date(ts_pl_dt[1,2]) # once back to data.frame can as.Date on ts_pl_dt[1,2]
ts_strt_mth <- month(ts_pl_dt)
ts_strt_yr  <- year(ts_pl_dt)

# create time series
ts_pl <- ts(ts_pl$R12, start = c(ts_strt_yr, ts_strt_mth), frequency = 12)

#__________________________________________________________________________________________________#

# Ongoing hc 
ts_ongHC <- read_csv("data/ts_ongHC.csv")
ts_ongHC <- ts(ts_ongHC$Headcount, start = c(2007, 7), frequency = 12) 

#__________________________________________________________________________________________________#

# Non-ongoing hc 
ts_nonHC <- read_csv("data/ts_nonHC.csv")
ts_nonHC <- ts(ts_nonHC$Headcount, start = c(2007, 7), frequency = 12)

#__________________________________________________________________________________________________#

# Casual hc 
ts_casHC <- read_csv("data/ts_casHC.csv")
ts_casHC <- ts(ts_casHC$Headcount, start = c(2007, 7), frequency = 12) 

#__________________________________________________________________________________________________#

# Attrition 
ts_attr <- read_csv("data/ts_attr.csv")
ts_attr <- ts(ts_attr$R12_Attrition_Rate, start = c(2008, 7), frequency = 12)

#__________________________________________________________________________________________________#

# Redundancy 
ts_rdncy <- read_csv("data/ts_rdncy.csv")
ts_rdncy <- ts(ts_rdncy$R12_Redundancy_Rate, start = c(2008, 7), frequency = 12) 

#__________________________________________________________________________________________________#

# Ongoing sepn 
ts_ong <- read_csv("data/ts_ong.csv")
ts_ong <- ts(ts_ong$R12_Ongoing_Rate, start = c(2008, 7), frequency = 12)

#__________________________________________________________________________________________________#

# Higher Duties

# load data
ts_hd <- read_csv("data/ts_hd.csv")

# ts start date manipulation
ts_hd_dt    <- as.data.frame(ts_hd) # need to coerce tbl.df back to data.frame 
ts_hd_dt    <- as.Date(ts_hd_dt[1,2]) # once back to data.frame can as.Date on ts_hd_dt[1,2]
ts_strt_mth <- month(ts_hd_dt)
ts_strt_yr  <- year(ts_hd_dt)

# create time series
ts_hd <- ts(ts_hd$HD, start = c(ts_strt_yr, ts_strt_mth), frequency = 12) 

#__________________________________________________________________________________________________#

# Vertical mobility 

# load data
ts_vm <- read_csv("data/ts_vm.csv")

# ts start date manipulation
ts_vm_dt    <- as.data.frame(ts_vm) # need to coerce tbl.df back to data.frame 
ts_vm_dt    <- as.Date(ts_vm_dt[1,2]) # once back to data.frame can as.Date on ts_vm_dt[1,2]
ts_strt_mth <- month(ts_vm_dt)
ts_strt_yr  <- year(ts_vm_dt)

# create time series
ts_vm <- ts(ts_vm$VM, start = c(ts_strt_yr, ts_strt_mth), frequency = 12) 

#__________________________________________________________________________________________________#

# Age 
ts_age <- read_csv("data/ts_age.csv")
ts_age <- ts(ts_age$Average_Age, start = c(2007, 7), frequency = 12)

#__________________________________________________________________________________________________#

# AtoTnr
ts_atoTnr <- read_csv("data/ts_atoTnr.csv")
ts_atoTnr <- ts(ts_atoTnr$Average_ATO_Tenure, start = c(2007, 7), frequency = 12)

#__________________________________________________________________________________________________#

# ApsTnr 
ts_apsTnr <- read_csv("data/ts_apsTnr.csv")
ts_apsTnr <- ts(ts_apsTnr$Average_APS_Tenure, start = c(2007, 7), frequency = 12) 

#__________________________________________________________________________________________________#

# Average salary 
ts_avgSal <- read_csv("data/ts_avgSal.csv")
ts_avgSal <- ts(ts_avgSal$`Female %`, start = c(2007, 7), frequency = 12) 