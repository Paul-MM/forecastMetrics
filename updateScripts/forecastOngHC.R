#!/usr/bin/Rscript

################################################################################

# This script extracts Ongoing HC forecasting in wa_dashboard

# Parent script is updateForecastApps.sh
# SQL file is forecastOngHC.sql 
# Outputs forecastOngHC.csv for globalPreProcess.R

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read SQL to extract ongoing HC data
sql <- paste(read_lines("forecastOngHC.sql"), collapse="\n")

# Submit query to dwh
suppressMessages(con <- teradataConnect())
ongHC <-  dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# print output
cat(format_csv(ongHC))