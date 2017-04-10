# HWplot.R

library(ggplot2)
library(reshape)

HWplot <- function(ts_object, n.ahead = 4, CI = 0.95, error.ribbon = 'red', line.size = 1){
  
  # Create ts data
  hw_object     <- HoltWinters(ts_object)
  forecast      <- predict(object = hw_object, n.ahead = n.ahead, prediction.interval = TRUE,
                           level = CI)
  for_values    <- data.frame(time = round(x = time(forecast), digits = 4)
                              , value_forecast = as.data.frame(forecast)$fit
                              , dev = as.data.frame(forecast)$upr-as.data.frame(forecast)$fit)
  fitted_values <- data.frame(time = round(x = time(hw_object$fitted), digits = 4)
                              , value_fitted=as.data.frame(hw_object$fitted)$xhat)
  actual_values <- data.frame(time = round(x = time(hw_object$x), digits = 4)
                              , Actual = c(hw_object$x))
  
  # Combine data
  graphset <- merge(x = actual_values, y = fitted_values, by = 'time', all = TRUE)
  graphset <- merge(x = graphset,  y = for_values,  all=TRUE,  by='time')
  
  graphset[is.na(graphset$dev),]$dev <- 0
  
  graphset$Fitted <- c(rep(NA, NROW(graphset) - (NROW(for_values) + NROW(fitted_values))), 
                       fitted_values$value_fitted, for_values$value_forecast)
  graphset.melt   <- melt(data = graphset[, c('time', 'Actual', 'Fitted')], id = 'time')
  
  # Dates decimals to months
  
  # Graphset.melt
  date                    <- date_decimal(decimal = graphset.melt$time)
  date                    <- as.Date(x = date)
  graphset.melt$dateMonth <- date
  
  # Graphset
  date               <- date_decimal(decimal = graphset$time)
  date               <- as.Date(x = date)
  graphset$dateMonth <- date
  
  # Round decimals
  graphset$Actual     <- round(x = graphset$Actual, digits = 2)
  graphset$Fitted     <- round(x = graphset$Fitted, digits = 2)
  graphset.melt$value <- round(x = graphset.melt$value, digits = 2)
  
  # reference for geom_vline # not necessary but left here for future attempts
  #   NonNAindex <- which(!is.na(graphset[,2]))
  #   lastUpdate <- as.Date(date_decimal(tail(graphset$time[NonNAindex], n = 1)))
  # add layer to ggplot geom_vline(aes(xintercept=as.numeric(lastUpdate)),  lty=2) +
  
  # Plot
  
  g <- ggplot(data = graphset.melt,  aes(x = dateMonth,  y = value)) +
       geom_ribbon(data = graphset, 
                   aes(x = dateMonth, y = Fitted, ymin = Fitted - dev, ymax = Fitted + dev),
                   alpha = .2, fill = error.ribbon) +
       geom_line(aes(colour = variable), size = line.size) +
       xlab('Time') + ylab('Value') +
       theme(legend.position = 'bottom') +
       scale_colour_hue('')
  
  return(g)
  
}