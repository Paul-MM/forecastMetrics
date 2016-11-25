#!/usr/bin/Rscript

################################################################################

# This script extracts Non-ongoing paid FTE for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read SQL to extract non-ongoing HC data
sql <- paste(read_lines("forecastNonFTE.sql"), collapse="\n")

# Submit query to dwh
suppressMessages(con <- teradataConnect())
nonFTE <-  dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# print output
cat(format_csv(nonFTE))