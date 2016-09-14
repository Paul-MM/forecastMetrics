#!/usr/bin/Rscript

################################################################################

# This script calculates Average Salary for forecasting in wa_dashboard

# Parent script is updateForecastApps.sh
# SQL file is forecastAvgSal.sql 
# Outputs forecastAvgSal.csv for globalPreProcess.R

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(tidyr))      # spread()
suppressMessages(library(readr))      # fast I/O

# read avg sal calcs 
sql <- paste(read_lines("forecastAvgSal.sql"), collapse="\n")

# submit query to dwh
suppressMessages(con <- teradataConnect())
salary <- dbGetQuery(con, sql) 
x      <- dbDisconnect(con)

# data wrangling for avg. salary with part time $$
avgSal          <- subset(salary, salary$Sex_Dcd != 'unknown')
avgSal          <- spread(avgSal, key = Sex_Dcd, value = Slry_Amt)
avgSal[,4]      <- (avgSal$Female / avgSal$Male) * 100
colnames(avgSal)<- c("Snpsht_Dt", 
                     "Avg. Female Salary",
                     "Avg. Male Salary",
                     "Female %")

# print output
cat(format_csv(avgSal))