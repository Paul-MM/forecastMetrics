suppressMessages(library(shiny))          # web framewor
suppressMessages(library(lubridate))      # data handling
suppressMessages(library(plotly))         # interactive plots
suppressMessages(library(readr))          # fast I/O
suppressMessages(library(dplyr))          # data wrangling 

source("HWplot.R")                        # ggplot Holt Winters function

# LOAD DATA ----------------------------------------------------------------------------------------

# Set path for data files
dataPath <- "/proj/workforce/data/shinyApps/"

# Leave (Days per FTE)
ts_upl     <- read_csv(paste0(dataPath,"forecastMetrics/forecastUPL.csv"))
ts_pl      <- read_csv(paste0(dataPath,"forecastMetrics/forecastPL.csv"))
ts_totLv   <- read_csv(paste0(dataPath,"forecastMetrics/forecastTotLv.csv"))
ts_uplpcnt <- data.frame(R12=(ts_upl$R12/ts_totLv$R12)*100, date2=ts_totLv$date2)
ts_plpcnt  <- data.frame(R12=(ts_pl$R12/ts_totLv$R12)*100, date2=ts_totLv$date2)

# Workforce (HC)
ts_ongHC    <- read_csv(paste0(dataPath,"forecastMetrics/forecastOngHC.csv"))
ts_nonHC    <- read_csv(paste0(dataPath,"forecastMetrics/forecastNonHC.csv"))
ts_casHC    <- read_csv(paste0(dataPath,"forecastMetrics/forecastCasHC.csv"))
ts_totHC    <- read_csv(paste0(dataPath,"forecastMetrics/forecastTotHC.csv"))
ts_ongHCpcnt<- data.frame(Measure=(ts_ongHC$Measure/ts_totHC$Measure)*100, date2=ts_totHC$date2)
ts_nonHCpcnt<- data.frame(Measure=(ts_nonHC$Measure/ts_totHC$Measure)*100, date2=ts_totHC$date2)
ts_casHCpcnt<- data.frame(Measure=(ts_casHC$Measure/ts_totHC$Measure)*100, date2=ts_totHC$date2)

# Workforce (Paid FTE)
ts_ongFTE    <- read_csv(paste0(dataPath,"forecastMetrics/forecastOngFTE.csv"))
ts_nonFTE    <- read_csv(paste0(dataPath,"forecastMetrics/forecastNonFTE.csv"))
ts_casFTE    <- read_csv(paste0(dataPath,"forecastMetrics/forecastCasFTE.csv"))
ts_totFTE    <- read_csv(paste0(dataPath,"forecastMetrics/forecastTotFTE.csv"))
ts_ongFTEpcnt<- data.frame(Measure=(ts_ongFTE$Measure/ts_totFTE$Measure)*100, date2=ts_totFTE$date2)
ts_nonFTEpcnt<- data.frame(Measure=(ts_nonFTE$Measure/ts_totFTE$Measure)*100, date2=ts_totFTE$date2)
ts_casFTEpcnt<- data.frame(Measure=(ts_casFTE$Measure/ts_totFTE$Measure)*100, date2=ts_totFTE$date2)
# Workforce Utilisation (% of Paid FTE/HC)
ts_ongUtil <- ts_ongHC[ts_ongHC$date2 >= "2014-03-31",]
ts_ongUtil$Measure <- (ts_ongFTE$Measure/ts_ongUtil$Measure)*100
ts_nonUtil <- ts_nonHC[ts_nonHC$date2 >= "2014-03-31",]
ts_nonUtil$Measure <- (ts_nonFTE$Measure/ts_nonUtil$Measure)*100
ts_casUtil <- ts_casHC[ts_casHC$date2 >= "2014-03-31",]
ts_casUtil$Measure <- (ts_casFTE$Measure/ts_casUtil$Measure)*100
ts_totUtil <- ts_totHC[ts_totHC$date2 >= "2014-03-31",]
ts_totUtil$Measure <- (ts_totFTE$Measure/ts_totUtil$Measure)*100
# Separation Rate (%)
ts_sepn     <- read_csv(paste0(dataPath,"forecastMetrics/forecastSepn.csv"))
ts_attr     <- read_csv(paste0(dataPath,"forecastMetrics/forecastAttr.csv"))
ts_rdncy    <- read_csv(paste0(dataPath,"forecastMetrics/forecastRdncy.csv"))
ts_attrpcnt <- data.frame(Measure=(ts_attr$Measure/ts_sepn$Measure)*100, Sepn_Mth=ts_sepn$Sepn_Mth)
ts_rdncypcnt<- data.frame(Measure=(ts_rdncy$Measure/ts_sepn$Measure)*100, Sepn_Mth=ts_sepn$Sepn_Mth)
# Average Age (Years)
ts_age     <- read_csv(paste0(dataPath,"forecastMetrics/forecastAge.csv"))
# Average Tenure (Years)
ts_atoTnr  <- read_csv(paste0(dataPath,"forecastMetrics/forecastAtoTnr.csv"))
ts_apsTnr  <- read_csv(paste0(dataPath,"forecastMetrics/forecastApsTnr.csv"))
# Diversity (%)
ts_nesb    <- read_csv(paste0(dataPath,"forecastMetrics/forecastNESB.csv"))
ts_ongNesb <- read_csv(paste0(dataPath,"forecastMetrics/forecastNESBOng.csv"))
ts_indg    <- read_csv(paste0(dataPath,"forecastMetrics/forecastIndg.csv"))
ts_ongIndg <- read_csv(paste0(dataPath,"forecastMetrics/forecastIndgOng.csv"))
ts_dsbl    <- read_csv(paste0(dataPath,"forecastMetrics/forecastDsbl.csv"))
ts_ongDsbl <- read_csv(paste0(dataPath,"forecastMetrics/forecastDsblOng.csv"))
# Average Female Salary (% of Average Male Salary)
ts_avgSal  <- read_csv(paste0(dataPath,"forecastMetrics/forecastAvgSal.csv"))

# TS OBJECTS ---------------------------------------------------------------------------------------

# Planned and Unplanned leave ####

# Start date manipulation and time series - unplanned leave
ts_upl_dt     <- as.data.frame(ts_upl)   # need to coerce tbl.df back to data.frame 
ts_upl_dt     <- as.Date(ts_upl_dt[1,2]) # once back to data.frame can as.Date on ts_upl_dt[1,2]
ts_strt_mth   <- month(ts_upl_dt)
ts_strt_yr    <- year(ts_upl_dt)
ts_upl        <- ts(data = ts_upl$R12, start = c(ts_strt_yr, ts_strt_mth), frequency = 12) 

# Start date manipulation and time series - planned leave
ts_pl_dt      <- as.data.frame(ts_pl)   # need to coerce tbl.df back to data.frame 
ts_pl_dt      <- as.Date(ts_pl_dt[1,2]) # once back to data.frame can as.Date on ts_pl_dt[1,2]
ts_strt_mth   <- month(ts_pl_dt)
ts_strt_yr    <- year(ts_pl_dt)
ts_pl         <- ts(data = ts_pl$R12, start = c(ts_strt_yr, ts_strt_mth), frequency = 12)

# Start date manipulation and time series - total leave
ts_totLv_dt   <- as.data.frame(ts_totLv)   # need to coerce tbl.df back to data.frame
ts_totLv_dt   <- as.Date(ts_totLv_dt[1,2]) # once back to data.frame can as.Date on ts_pl_dt[1,2]
ts_strt_mth   <- month(ts_totLv_dt)
ts_strt_yr    <- year(ts_totLv_dt)
ts_totLv      <- ts(data = ts_totLv$R12, start = c(ts_strt_yr, ts_strt_mth), frequency = 12)

# Start date manipulation and time series - unplanned leave as percentage of total leave
ts_uplpcnt_dt <- as.data.frame(ts_uplpcnt)   # need to coerce tbl.df back to data.frame
ts_uplpcnt_dt <- as.Date(ts_uplpcnt_dt[1,2]) # once back to data.frame can as.Date on ts_pl_dt[1,2]
ts_strt_mth   <- month(ts_uplpcnt_dt)
ts_strt_yr    <- year(ts_uplpcnt_dt)
ts_uplpcnt    <- ts(data = ts_uplpcnt$R12, start = c(ts_strt_yr,ts_strt_mth), frequency = 12)

# Start date manipulation and time series - planned leave as percentage of total leave
ts_plpcnt_dt  <- as.data.frame(ts_plpcnt)   # need to coerce tbl.df back to data.frame
ts_plpcnt_dt  <- as.Date(ts_plpcnt_dt[1,2]) # once back to data.frame can as.Date on ts_pl_dt[1,2]
ts_strt_mth   <- month(ts_plpcnt_dt)
ts_strt_yr    <- year(ts_plpcnt_dt)
ts_plpcnt     <- ts(data = ts_plpcnt$R12, start = c(ts_strt_yr,ts_strt_mth), frequency = 12)

# Remaining measures ####
ts_ongHC      <- ts(data = ts_ongHC$Measure,     start = c(2007, 7), frequency = 12) 
ts_nonHC      <- ts(data = ts_nonHC$Measure,     start = c(2007, 7), frequency = 12)
ts_casHC      <- ts(data = ts_casHC$Measure,     start = c(2007, 7), frequency = 12) 
ts_totHC      <- ts(data = ts_totHC$Measure,     start = c(2007, 7), frequency = 12) 
ts_ongHCpcnt  <- ts(data = ts_ongHCpcnt$Measure, start = c(2007, 7), frequency = 12)
ts_nonHCpcnt  <- ts(data = ts_nonHCpcnt$Measure, start = c(2007, 7), frequency = 12)
ts_casHCpcnt  <- ts(data = ts_casHCpcnt$Measure, start = c(2007, 7), frequency = 12)
ts_ongFTE     <- ts(data = ts_ongFTE$Measure,    start = c(2014, 3), frequency = 12) 
ts_nonFTE     <- ts(data = ts_nonFTE$Measure,    start = c(2014, 3), frequency = 12) 
ts_casFTE     <- ts(data = ts_casFTE$Measure,    start = c(2014, 3), frequency = 12) 
ts_totFTE     <- ts(data = ts_totFTE$Measure,    start = c(2014, 3), frequency = 12) 
ts_ongFTEpcnt <- ts(data = ts_ongFTEpcnt$Measure,start = c(2014, 3), frequency = 12)
ts_nonFTEpcnt <- ts(data = ts_nonFTEpcnt$Measure,start = c(2014, 3), frequency = 12)
ts_casFTEpcnt <- ts(data = ts_casFTEpcnt$Measure,start = c(2014, 3), frequency = 12)
ts_ongUtil    <- ts(data = ts_ongUtil$Measure,   start = c(2014, 3), frequency = 12)
ts_nonUtil    <- ts(data = ts_nonUtil$Measure,   start = c(2014, 3), frequency = 12)
ts_casUtil    <- ts(data = ts_casUtil$Measure,   start = c(2014, 3), frequency = 12)
ts_totUtil    <- ts(data = ts_totUtil$Measure,   start = c(2014, 3), frequency = 12)
ts_sepn       <- ts(data = ts_sepn$Measure,      start = c(2008, 7), frequency = 12)
ts_attr       <- ts(data = ts_attr$Measure,      start = c(2008, 7), frequency = 12)
ts_rdncy      <- ts(data = ts_rdncy$Measure,     start = c(2008, 7), frequency = 12) 
ts_attrpcnt   <- ts(data = ts_attrpcnt$Measure,  start = c(2008, 7), frequency = 12)
ts_rdncypcnt  <- ts(data = ts_rdncypcnt$Measure, start = c(2008, 7), frequency = 12)
ts_age        <- ts(data = ts_age$Measure,       start = c(2007, 7), frequency = 12)
ts_atoTnr     <- ts(data = ts_atoTnr$Measure,    start = c(2007, 7), frequency = 12)
ts_apsTnr     <- ts(data = ts_apsTnr$Measure,    start = c(2007, 7), frequency = 12) 
ts_nesb       <- ts(data = ts_nesb$Measure,      start = c(2013, 7), frequency = 12)
ts_ongNesb    <- ts(data = ts_ongNesb$Measure,   start = c(2013, 7), frequency = 12)
ts_indg       <- ts(data = ts_indg$Measure,      start = c(2013, 7), frequency = 12)
ts_ongIndg    <- ts(data = ts_ongIndg$Measure,   start = c(2013, 7), frequency = 12)
ts_dsbl       <- ts(data = ts_dsbl$Measure,      start = c(2013, 7), frequency = 12)
ts_ongDsbl    <- ts(data = ts_ongDsbl$Measure,   start = c(2013, 7), frequency = 12)
ts_avgSal     <- ts(data = ts_avgSal$Measure,    start = c(2007, 7), frequency = 12)

# Enable bookmarking for this app
enableBookmarking(store = "url")