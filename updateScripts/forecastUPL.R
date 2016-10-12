#!/usr/bin/Rscript

################################################################################

# This script extracts unplanned leave for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read SQL to extract UPL R12 data
sql <- paste(read_lines("forecastUPL.sql"), collapse="\n")

# Submit query to dwh
suppressMessages(con <- teradataConnect())
upl <-  dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# print output
cat(format_csv(upl))