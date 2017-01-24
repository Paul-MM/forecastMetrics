#!/usr/bin/Rscript

################################################################################

# This script extracts Non-ongoing paid FTE for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract non-ongoing HC data
sql <- paste(read_lines("forecastNonFTE.sql"), collapse="\n")

# Submit query to dwh
con    <- teradataConnect()
nonFTE <- dbGetQuery(con, sql) 
x      <- dbDisconnect(con)

# Process data for time series
nonFTE$date2 <- as.Date(nonFTE$Snpsht_Dt) #format date
include      <- c("Measure", "date2")
nonFTE       <- nonFTE[,names(nonFTE) %in% include]
nonFTE       <- nonFTE[with(nonFTE, order(nonFTE$date2)),]

# Print output
cat(format_csv(nonFTE))