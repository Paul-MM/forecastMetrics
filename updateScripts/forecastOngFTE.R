#!/usr/bin/Rscript

################################################################################

# This script extracts Ongoing Paid FTE from dwh for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read SQL to extract ongoing paid FTE data
sql <- paste(read_lines("forecastOngFTE.sql"), collapse="\n")

# Submit query to dwh
suppressMessages(con <- teradataConnect())
ongFTE <-  dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# print output
cat(format_csv(ongFTE))