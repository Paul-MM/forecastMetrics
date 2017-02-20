#!/usr/bin/Rscript

################################################################################

# This script calculates the redundancy rate for forecasting

################################################################################

suppressMessages(library(atomisc))  # teradataConnect()
suppressMessages(library(dplyr))    # lag
suppressMessages(library(tidyr))    # spread
suppressMessages(library(zoo))      # rollapply
suppressMessages(library(readr))    # fast I/O

# Extract data from dwh ####

# sql for headcounts 
sql1 <- paste(read_lines("forecastSEPN1.sql"), collapse="\n")

# sql for sepns
sql2 <- paste(read_lines("forecastSEPN2.sql"), collapse="\n")

# Submit queries to dwh 
con         <- teradataConnect()
headcounts  <- dbGetQuery(con, sql1)
separations <- dbGetQuery(con, sql2) 
x           <- dbDisconnect(con)

# Calculate rate
separations %>% 
  spread(key     = Sepn_Reason
         , value = HC) %>% 
  mutate(Sepn_Mth  = as.Date(Sepn_Mth)
         , Ong_HC  = lag(headcounts$HC[2:nrow(headcounts)-1], n = 1, default = 22482)
         , Mth_Rt  = (Redundancy / Ong_HC) * 100
         , Measure = rollapply(Mth_Rt, width = 12, FUN = sum, fill = NA, align = c("right"))) %>%
  slice(12:n()) ->
rdncy

# print final data
cat(format_csv(rdncy))