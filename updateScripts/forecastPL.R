#!/usr/bin/Rscript

################################################################################

# This script extracts planned leave for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract PL R12 data 
sql <- paste(read_lines("forecastPL.sql"), collapse="\n")
  
# Submit query to dwh
con <- teradataConnect()
pl  <- dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# Process for time series
pl$date2 <- as.Date(pl$Snpsht_Dt) #format date
include  <- c("R12", "date2")
pl       <- pl[,names(pl) %in% include]
pl       <- pl[with(pl, order(pl$date2)),]

# Print output
cat(format_csv(pl))  
  