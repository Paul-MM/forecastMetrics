#!/usr/bin/Rscript

################################################################################

# This script extracts Casual HC for forecasting 

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read SQL to extract casual HC data
sql <- paste(read_lines("forecastCasHC.sql"), collapse="\n")

# Submit query to dwh
suppressMessages(con <- teradataConnect())
casHC <-  dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# print output
cat(format_csv(casHC))