#!/usr/bin/Rscript

################################################################################

# This script extracts Non-ongoing HC for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract non-ongoing HC data
sql <- paste(read_lines("forecastNonHC.sql"), collapse="\n")

# Submit query to dwh
con   <- teradataConnect()
nonHC <- dbGetQuery(con, sql) 
x     <- dbDisconnect(con)

# Process data for time series
nonHC$date2 <- as.Date(nonHC$Snpsht_Dt) #format date
include     <- c("Measure", "date2")
nonHC       <- nonHC[,names(nonHC) %in% include]
nonHC       <- nonHC[with(nonHC, order(nonHC$date2)),]

# print output
cat(format_csv(nonHC))