#!/usr/bin/Rscript

################################################################################

# This script extracts APS Tenure from dwh for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract APS Tenure data
sql <- paste(read_lines("forecastApsTnr.sql"), collapse="\n")

# Submit query to dwh
con    <- teradataConnect()
apsTnr <- dbGetQuery(con, sql) 
x      <- dbDisconnect(con)

# Process data for time series
apsTnr$date2 <- as.Date(apsTnr$Snpsht_Dt) #format date
include      <- c("Measure", "date2")
apsTnr       <- apsTnr[,names(apsTnr) %in% include]
apsTnr       <- apsTnr[with(apsTnr, order(apsTnr$date2)),]

# Print output
cat(format_csv(apsTnr))

