#!/usr/bin/Rscript

################################################################################

# This script extracts ATO Tenure from dwh for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# read sql for ATO tenure
sql <- paste(read_lines("forecastAtoTnr.sql"), collapse="\n")

# return data from dwh
suppressMessages(con <- teradataConnect())
atoTnr <- dbGetQuery(con, sql)
x      <- dbDisconnect(con)

# print output
cat(format_csv(atoTnr))