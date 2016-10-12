#!/usr/bin/Rscript

################################################################################

# This script calculates the separation rate for forecasting

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

# submit queries to dwh 
suppressMessages(con <- teradataConnect())
headcounts <- dbGetQuery(con, sql1)
separations <- dbGetQuery(con, sql2) 
x <- dbDisconnect(con)
rm(con, sql1, sql2, x)

# dplyr for separation rates
separations %>% 
  spread(key = Sepn_Reason
         , value = HC) %>%
  rename(Snpsht_Dt = Sepn_Mth 
         , Attrition_Sepns = NaturalAttrition
         , Redundancy_Sepns = Redundancy) %>%
  mutate(Total_Sepns = Attrition_Sepns + Redundancy_Sepns) %>%
  mutate(Ongoing_HC = lag(headcounts$HC[2:nrow(headcounts)-1], n = 1, default = 22482)) %>%
  mutate(Monthly_Attrition_Rate = (Attrition_Sepns/Ongoing_HC)*100) %>%
  mutate(Monthly_Redundancy_Rate = (Redundancy_Sepns/Ongoing_HC)*100) %>%
  mutate(Monthly_Ongoing_Rate = (Total_Sepns/Ongoing_HC)*100) %>%
  mutate(R12_Attrition_Rate = rollapply(Monthly_Attrition_Rate, width = 12, FUN = sum, fill = NA, align = c("right"))) %>%
  mutate(R12_Redundancy_Rate = rollapply(Monthly_Redundancy_Rate, width = 12, FUN = sum, fill = NA, align = c("right"))) %>%
  mutate(R12_Ongoing_Rate = rollapply(Monthly_Ongoing_Rate, width = 12, FUN = sum, fill = NA, align = c("right"))) %>%
  slice(12:n()) ->
separations

# print final data
cat(format_csv(separations))