#!/usr/bin/Rscript

################################################################################

# This script extracts Non-ongoing HCfor forecasting in wa_dashboard

# Parent script is updateForecastApps.sh
# SQL file is forecastNonHC.sql 
# Outputs forecastNonHC.csv for globalPreProcess.R

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read SQL to extract non-ongoing HC data
sql <- paste(read_lines("forecastNonHC.sql"), collapse="\n")

# Submit query to dwh
suppressMessages(con <- teradataConnect())
nonHC <-  dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# print output
cat(format_csv(nonHC))