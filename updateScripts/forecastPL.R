#!/usr/bin/Rscript

################################################################################

# This script extracts Planned Leave for forecasting in wa_dashboard

# Parent script is updateForecastApps.sh
# SQL file is forecastPL.sql 
# Outputs forecastPL.csv for globalPreProcess.R

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read SQL to extract PL R12 data ####
sql <- paste(read_lines("forecastPL.sql"), collapse="\n")
  
# Submit query to dwh ####
suppressMessages(con <- teradataConnect())
pl <-  dbGetQuery(con, sql) 
x <- dbDisconnect(con)
 
# print output
cat(format_csv(pl))  
  