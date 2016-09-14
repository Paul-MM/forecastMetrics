#!/usr/bin/Rscript

################################################################################

# This script extracts Age from dwh for forecasting in wa_dashboard

# Parent script is updateForecastApps.sh
# SQL file is forecastAge.sql 
# Outputs forecastAge.csv for globalPreProcess.R

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read sql for ATO tenure
sql <- paste(read_lines("forecastAge.sql"), collapse="\n")

# get data from dwh
suppressMessages(con <- teradataConnect())
age <- dbGetQuery(con, sql)
x   <- dbDisconnect(con)

# print output
cat(format_csv(age))