#!/usr/bin/Rscript

################################################################################

# This script extracts unplanned leave for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract UPL R12 data
sql <- paste(read_lines("forecastUPL.sql"), collapse="\n")

# Submit query to dwh
con <- teradataConnect()
upl <- dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# Process for time series
upl$date2 <- as.Date(upl$Snpsht_Dt) #format date
include   <- c("R12", "date2")
upl       <- upl[,names(upl) %in% include]
upl       <- upl[with(upl, order(upl$date2)),]

# Print output
cat(format_csv(upl))