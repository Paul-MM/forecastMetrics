#!/usr/bin/Rscript

################################################################################

# This script extracts Casual paid FTE for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract non-ongoing HC data
sql <- paste(read_lines("forecastCasFTE.sql"), collapse="\n")

# Submit query to dwh
con    <- teradataConnect()
casFTE <- dbGetQuery(con, sql) 
x      <- dbDisconnect(con)

# Process data for time series
casFTE$date2 <- as.Date(casFTE$Snpsht_Dt) #format date
include      <- c("Measure", "date2")
casFTE       <- casFTE[,names(casFTE) %in% include]
casFTE       <- casFTE[with(casFTE, order(casFTE$date2)),]

# Print output
cat(format_csv(casFTE))