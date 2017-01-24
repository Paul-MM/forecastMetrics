#!/usr/bin/Rscript

################################################################################

# This script extracts total HC (excl. Externals) for forecasting 

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read SQL to extract casual HC data
sql <- paste(read_lines("forecastTotHC.sql"), collapse="\n")

# Submit query to dwh
con   <- teradataConnect()
totHC <-  dbGetQuery(con, sql) 
x     <- dbDisconnect(con)

# Process data for time frame
totHC$date2 <- as.Date(totHC$Snpsht_Dt) #format date
include     <- c("Measure", "date2")
totHC       <- totHC[,names(totHC) %in% include]
totHC       <- totHC[with(totHC, order(totHC$date2)),]

# print output
cat(format_csv(totHC))