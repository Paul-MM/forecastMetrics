#!/usr/bin/Rscript

################################################################################

# This script extracts Casual HC for forecasting 

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract casual HC data
sql <- paste(read_lines("forecastCasHC.sql"), collapse="\n")

# Submit query to dwh
con   <- teradataConnect()
casHC <- dbGetQuery(con, sql) 
x     <- dbDisconnect(con)

# Process data for time series
casHC$date2 <- as.Date(casHC$Snpsht_Dt) #format date
include     <- c("Measure", "date2")
casHC       <- casHC[,names(casHC) %in% include]
casHC       <- casHC[with(casHC, order(casHC$date2)),]

# Print output
cat(format_csv(casHC))