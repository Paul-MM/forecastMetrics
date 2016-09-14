#!/bin/bash
set -eou pipefail

####################################################################################################

# This script updates data for forecasting HR metrics

####################################################################################################

# loop through each script to generate metrics to forecast
for script in `ls forecast*.R`
do
  Rscript $script >| "$forecastMetricsData${script/.R/}".csv #removes .R from filename output
  echo running "$script"
done

# #echo $'\n'This process outputs ATOGapminder.html for Workforce Motion chart...
# 
# # generate the motionchart
# #Rscript ATOGapminder.R
# 
# #_____________________________________________________________________________

echo $'\n'FORECAST DATA UPDATE COMPLETE