#!/usr/bin/Rscript

################################################################################

# This script extracts Casual paid FTE for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read SQL to extract non-ongoing HC data
sql <- paste(read_lines("forecastCasFTE.sql"), collapse="\n")

# Submit query to dwh
suppressMessages(con <- teradataConnect())
casFTE <-  dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# print output
cat(format_csv(casFTE))