#!/usr/bin/Rscript

################################################################################

# This script extracts total paid FTE (excl. Externals) for forecasting 

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract casual HC data
sql <- paste(read_lines("forecastTotFTE.sql"), collapse="\n")

# Submit query to dwh
con    <- teradataConnect()
totFTE <- dbGetQuery(con, sql) 
x      <- dbDisconnect(con)

# Process data for time series
totFTE$date2 <- as.Date(totFTE$Snpsht_Dt) #format date
include      <- c("Measure", "date2")
totFTE       <- totFTE[,names(totFTE) %in% include]
totFTE       <- totFTE[with(totFTE, order(totFTE$date2)),]

# Print output
cat(format_csv(totFTE))