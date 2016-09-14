#!/usr/bin/Rscript

################################################################################

# This script extracts APS Tenure from dwh for forecasting in wa_dashboard

# Parent script is updateForecastApps.sh
# SQL file is forecastApsTnr.sql
# Outputs forecastApsTnr.csv for globalPreProcess.R

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read SQL to extract APS Tenure data
sql <- paste(read_lines("forecastApsTnr.sql"), collapse="\n")

# Submit query to dwh
suppressMessages(con <- teradataConnect())
apsTnr <-  dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# print output
cat(format_csv(apsTnr))

