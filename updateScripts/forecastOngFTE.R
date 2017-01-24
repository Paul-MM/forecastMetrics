#!/usr/bin/Rscript

################################################################################

# This script extracts Ongoing Paid FTE from dwh for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract ongoing paid FTE data
sql <- paste(read_lines("forecastOngFTE.sql"), collapse="\n")

# Submit query to dwh
con    <- teradataConnect()
ongFTE <- dbGetQuery(con, sql) 
x      <- dbDisconnect(con)

# Process data for time series
ongFTE$date2 <- as.Date(ongFTE$Snpsht_Dt) #format date
include      <- c("Measure", "date2")
ongFTE       <- ongFTE[,names(ongFTE) %in% include]
ongFTE       <- ongFTE[with(ongFTE, order(ongFTE$date2)),]

# Print output
cat(format_csv(ongFTE))