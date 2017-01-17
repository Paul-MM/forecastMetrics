library(atomisc)

sql <- "sel * from eadppert.uaags_diversity"
con <- teradataConnect()
df  <- dbGetQuery(con, sql)
x   <- dbDisconnect(con)

# FUNCTION -----------------------------------------------------------------------------------------

nesb.total <- function(x){
  # Assigns row with NESB of 1 when any of the three columns is flagged
  if (df$NESB == 1 || df$NESB1 == 1 || df$NESB2 == 1){
    x <- 1
  } else {
    x <- 0
  }
}

# DATA - COUNTS ------------------------------------------------------------------------------------

# Iterate over columns to remove NAs
df <- data.frame(lapply(df, function(x) ifelse(is.na(x), 0, x)))

# Create counts by month
df %>% 
  mutate(NESB_Sum = nesb.total(x)) %>% 
  select(Snpsht_Date
         , NESB_Sum
         , Indigenous
         , Disability) %>% 
  group_by(Snpsht_Date) %>% 
  summarise(NESB_HC   = sum(NESB_Sum)
            , Indg_HC = sum(Indigenous)
            , Dsbl_HC = sum(Disability)) ->
df







