#!/usr/bin/Rscript

################################################################################

# This script extracts ATO Tenure from dwh for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read sql for ATO tenure
sql <- paste(read_lines("forecastAtoTnr.sql"), collapse="\n")

# Return data from dwh
con    <- teradataConnect()
atoTnr <- dbGetQuery(con, sql)
x      <- dbDisconnect(con)

# Process data for time series
atoTnr$date2 <- as.Date(atoTnr$Snpsht_Dt) #format date
include      <- c("Measure", "date2")
atoTnr       <- atoTnr[,names(atoTnr) %in% include]
atoTnr       <- atoTnr[with(atoTnr, order(atoTnr$date2)),]

# Print output
cat(format_csv(atoTnr))