#!/usr/bin/Rscript

################################################################################

# This script extracts Age from dwh for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(readr))      # fast I/O

# Read sql for ATO tenure
sql <- paste(read_lines("forecastAge.sql"), collapse="\n")

# Extract data from dwh
con <- teradataConnect()
age <- dbGetQuery(con, sql)
x   <- dbDisconnect(con)

# Process for time series
age$date2 <- as.Date(age$Snpsht_Dt) #format date
include   <- c("Measure", "date2")
age       <- age[,names(age) %in% include]
age       <- age[with(age, order(age$date2)),]

# Print output
cat(format_csv(age))