#!/usr/bin/Rscript

################################################################################

# This script extracts total HC (excl. Externals) for forecasting 

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read SQL to extract casual HC data
sql <- paste(read_lines("forecastTotHC.sql"), collapse="\n")

# Submit query to dwh
suppressMessages(con <- teradataConnect())
totHC <-  dbGetQuery(con, sql) 
x   <- dbDisconnect(con)

# print output
cat(format_csv(totHC))