# HWplot.R

library(ggplot2)
library(reshape)

HWplot <- function(ts_object, actual.times, fitted.times, forecast.times, n.ahead = 4, CI = 0.95
                   , error.ribbon = 'red', line.size = 1){
  
  # Create ts data
  hw_object     <- HoltWinters(ts_object)
  forecast      <- predict(object = hw_object, n.ahead = n.ahead, prediction.interval = TRUE,
                           level = CI)
  for_values    <- data.frame(pointInTime = forecast.times
                              , value_forecast = as.data.frame(forecast)$fit
                              , dev = as.data.frame(forecast)$upr-as.data.frame(forecast)$fit)
  fitted_values <- data.frame(pointInTime = fitted.times
                              , value_fitted=as.data.frame(hw_object$fitted)$xhat)
  actual_values <- data.frame(pointInTime = actual.times
                              , Actual = c(hw_object$x))
  
  # Combine data
  graphset <- merge(x = actual_values, y = fitted_values, by = 'pointInTime', all = TRUE)
  graphset <- merge(x = graphset,  y = for_values,  all=TRUE,  by='pointInTime')
  
  graphset[is.na(graphset$dev),]$dev <- 0
  
  graphset$Fitted <- c(rep(NA, NROW(graphset) - (NROW(for_values) + NROW(fitted_values))), 
                       fitted_values$value_fitted, for_values$value_forecast)
  graphset.melt   <- melt(data = graphset[, c('pointInTime', 'Actual', 'Fitted')], id = 'pointInTime')
  
  # Round decimals
  graphset$Actual     <- round(x = graphset$Actual, digits = 2)
  graphset$Fitted     <- round(x = graphset$Fitted, digits = 2)
  graphset.melt$value <- round(x = graphset.melt$value, digits = 2)
  
  # Plot
  
  g <- ggplot(data = graphset.melt,  aes(x = pointInTime,  y = value)) +
       geom_ribbon(data = graphset, 
                   aes(x = pointInTime, y = Fitted, ymin = Fitted - dev, ymax = Fitted + dev),
                   alpha = .2, fill = error.ribbon) +
       geom_line(aes(colour = variable), size = line.size) +
       xlab('Time') + 
       ylab('Value') +
       theme(legend.position = 'bottom') +
       scale_colour_hue('')
  
  return(g)
  
}