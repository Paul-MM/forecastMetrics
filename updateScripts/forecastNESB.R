#!/usr/bin/Rscript

################################################################################

# This script calculates nesb rates for forecasting

################################################################################

suppressMessages(library(atomisc))  # teradataConnect()
suppressMessages(library(dplyr))    # data wrangling
suppressMessages(library(readr))    # fast I/O

# FUNCTION -----------------------------------------------------------------------------------------

nesb.flag <- function(x){
  # Assigns row with NESB of 1 when any of the three NESB columns is flagged
  ifelse(df$NESB == 1 | df$NESB1 == 1 | df$NESB2 == 1, 1, 0)
}

# EXTRACT DATA -------------------------------------------------------------------------------------

# SQL for headcounts 
sql1 <- paste(read_lines("forecastDVSTY1.sql"), collapse="\n")

# SQL for diversity data
sql2 <- paste(read_lines("forecastDVSTY2.sql"), collapse="\n")

# Submit queries to dwh
con  <- teradataConnect()
dmgs <- dbGetQuery(con, sql1)
df   <- dbGetQuery(con, sql2)
x    <- dbDisconnect(con)

# CALCULATE RATES ----------------------------------------------------------------------------------

# Iterate over columns to remove NAs
df <- data.frame(lapply(df, function(x) ifelse(is.na(x), 0, x)))

# Formate date for join in headcounts dataframe
dmgs$HC_Mth <- as.Date(dmgs$HC_Mth)

# Calculate diversity rates
df %>% 
  mutate(Snpsht_Date = as.Date(Snpsht_Date)
         , NESB_Sum  = nesb.flag(x)) %>% 
  select(Snpsht_Date
         , NESB_Sum) %>% 
  group_by(Snpsht_Date) %>% 
  summarise(NESB_HC = sum(NESB_Sum)) %>%
  left_join(dmgs, by = c("Snpsht_Date" = "HC_Mth")) %>% 
  mutate(Measure = round((NESB_HC / HC) * 100, 2)) ->
nesb

# print final data
cat(format_csv(nesb))