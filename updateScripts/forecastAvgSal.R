#!/usr/bin/Rscript

################################################################################

# This script calculates Average Salary for forecasting

################################################################################

suppressMessages(library(atomisc))    # teradataConnect()
suppressMessages(library(tidyr))      # spread()
suppressMessages(library(dplyr))      # data wrangling
suppressMessages(library(readr))      # fast I/O

# Read sql
sql <- paste(read_lines("forecastAvgSal.sql"), collapse="\n")

# submit query to dwh
con    <- teradataConnect()
salary <- dbGetQuery(con, sql) 
x      <- dbDisconnect(con)

# Data wrangling for avg. salary 
salary %>% 
  filter(Sex_Dcd != "unknown") %>% 
  spread(key = Sex_Dcd, value = Slry_Amt) %>% 
  mutate(Slry_Pct = (Female / Male) * 100) %>% 
  select(Snpsht_Dt
         , `Avg. Female Salary` = Female
         , `Avg. Male Salary`   = Male
         , Measure              = Slry_Pct) ->
avgSal

# print output
cat(format_csv(avgSal))