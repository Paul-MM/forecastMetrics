#!/usr/bin/Rscript

################################################################################

# This script calculates indigenous rates for forecasting

################################################################################

suppressMessages(library(atomisc))  # teradataConnect()
suppressMessages(library(dplyr))    # data wrangling
suppressMessages(library(readr))    # fast I/O

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

# Calculate disability rates
df %>% 
  select(Snpsht_Dt
         , Indigenous) %>% 
  mutate(Snpsht_Dt = as.Date(Snpsht_Dt)) %>% 
  group_by(Snpsht_Dt) %>% 
  summarise(Indg_HC = sum(Indigenous)) %>%
  left_join(dmgs, by = c("Snpsht_Dt" = "HC_Mth")) %>% 
  mutate(Measure = round((Indg_HC / HC) * 100, 2)) ->
indg

# Print final data
cat(format_csv(indg))