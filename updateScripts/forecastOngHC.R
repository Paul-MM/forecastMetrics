#!/usr/bin/Rscript

################################################################################

# This script extracts Ongoing HC from dwh for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract ongoing HC data
sql <- paste(read_lines("forecastOngHC.sql"), collapse="\n")

# Submit query to dwh
con   <- teradataConnect()
ongHC <- dbGetQuery(con, sql) 
x     <- dbDisconnect(con)

# Process for time series
ongHC$date2 <- as.Date(ongHC$Snpsht_Dt) #format date
include     <- c("Measure", "date2")
ongHC       <- ongHC[,names(ongHC) %in% include]
ongHC       <- ongHC[with(ongHC, order(ongHC$date2)),]

# Print output
cat(format_csv(ongHC))