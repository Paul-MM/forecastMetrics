shinyServer(function(input, output, session) {
  
  # UI SWITCH --------------------------------------------------------------------------------------
  
  # Switch data based on ui selection
  datasetForeCInput <- reactive({
    
    switch(EXPR                                                 = input$sel_hrTS
           , "Unplanned Leave (Days per FTE)"                   = ts_upl 
           , "Planned Leave (Days per FTE)"                     = ts_pl
           , "Ongoing Workforce (HC)"                           = ts_ongHC
           , "Non-Ongoing Workforce (HC)"                       = ts_nonHC 
           , "Casual Workforce (HC)"                            = ts_casHC
           , "Total Employed Workforce (HC)"                    = ts_totHC
           , "Ongoing Workforce (Paid FTE)"                     = ts_ongFTE
           , "Non-Ongoing Workforce (Paid FTE)"                 = ts_nonFTE
           , "Casual Workforce (Paid FTE)"                      = ts_casFTE
           , "Total Employed Workforce (Paid FTE)"              = ts_totFTE
           , "Overall Ongoing Separation Rate (%)"              = ts_sepn   
           , "Natural Attrition Separation Rate (%)"            = ts_attr
           , "Redundancy Separation Rate (%)"                   = ts_rdncy
           , "Average Age (Years)"                              = ts_age 
           , "Average ATO Tenure (Years)"                       = ts_atoTnr
           , "Average APS Tenure (Years)"                       = ts_apsTnr
           , "Diversity - Non-English Speaking Background (%)"  = ts_nesb
           , "Diversity - Indigenous (%)"                       = ts_indg
           , "Diversity - Disability (%)"                       = ts_dsbl
           , "Average Female Salary (% of Average Male Salary)" = ts_avgSal)
    
  })
  
  # DATA -------------------------------------------------------------------------------------------
  
  # Data for download and render table
  dataRenderDownload <- reactive({
    
    # Define forecast period
    period <- input$fcast_mnths
    
    # Create columns for table
    hw_object     <- HoltWinters(datasetForeCInput())
    forecast      <- predict(object = hw_object, n.ahead = period, prediction.interval = TRUE,
                             level = 0.95)
    for_values    <- data.frame(time = round(x = time(forecast), digits = 3), 
                                value_forecast = as.data.frame(forecast)$fit, 
                                dev = as.data.frame(forecast)$upr-as.data.frame(forecast)$fit)
    fitted_values <- data.frame(time = round(x = time(hw_object$fitted), digits = 3), 
                                value_fitted = as.data.frame(hw_object$fitted)$xhat)
    actual_values <- data.frame(time = round(x = time(hw_object$x), digits = 3),
                                Actual = c(hw_object$x))
    
    # Merge columns
    graphset        <- merge(x = round(actual_values, 2), y = round(fitted_values, 2), by = 'time',
                             all = TRUE)
    graphset        <- merge(x = graphset, y = for_values, by = 'time', all = TRUE)
    graphset$Fitted <- c(rep(NA, NROW(graphset) - (NROW(for_values) + NROW(fitted_values))), 
                         fitted_values$value_fitted, for_values$value_forecast)
    
    # Date processing for table output
    date         <- date_decimal(decimal = graphset$time)
    date         <- as.Date(x = date)
    date         <- round_date(x = date, unit = "month")
    date         <- substr(x = date, start = 1, stop = 7)
    graphset[,1] <- date
    
    # Drop and rename columns
    include                    <- c("time", "Actual", "Fitted")
    graphset                   <- graphset[, names(graphset) %in% include]
    colnames(graphset)         <- c("Period", "Actual Values", "Forecast Values") # Change colnames
    graphset                   <- graphset[ order(graphset$Period, decreasing = TRUE), ] # Sort DESC
    graphset$`Forecast Values` <- round(x = graphset$`Forecast Values`, digits = 2 )
    graphset
    
  })

  # PLOT -------------------------------------------------------------------------------------------
  
  # Output slot for plotly chart
  output$forecastPlot <- renderPlotly({
    
    # Define forecast period
    period <- input$fcast_mnths
    
    # Initialise progress bar
    withProgress(message = 'Making plot...', value = 0.2, {
      
      # ggplot
      gg <- HWplot(datasetForeCInput(), n.ahead = period, error.ribbon = "red") + 
            scale_x_date(breaks = scales::date_breaks("year")) + # change gridbreaks to yrs
            ylab("") + # remove y labels as they infringe on axis ticks
            xlab("") + # remove x label as it's self explanatory
            ggtitle(input$sel_hrTS) +
            scale_colour_brewer("Legend", palette = "Set1") +
            theme(axis.title.y = element_text(vjust = 2)) +
            theme(axis.title.x = element_text(vjust = -0.5))
        
    incProgress(0.4) # increment progress
    
      # Plotly  
      p                     <- plotly_build(gg)
      p$data[[1]]$hoverinfo <- "none"     # hover options for 'average'
      p$data[[3]]$name      <- "Forecast" # change 'Fitted' to 'Forecast'
      p$layout$xaxis$type   <- "date"     # enable date handling
      p$layout$margin$l     <- 50         # increase left margin to display larger y axis values
        
    incProgress(0.4) # increment progress
        
      plotly_build(p) # build
      
    })
    
  })
  
  # TABLE ------------------------------------------------------------------------------------------

  # Output slot for data table
  output$tsTable <- renderDataTable({
    
    dataRenderDownload()
  
    }, options = list(autoWidth = TRUE, pageLength = 25)
    
  )

  # DOWNLOAD ---------------------------------------------------------------------------------------

  # Output slot for download option
  output$downloadData <- downloadHandler(
    
    filename = function() {
      paste(input$sel_hrTS, '.csv', sep = '')
    },
    content = function(file) {
      write_csv(dataRenderDownload(), file)
    }
    
  )

})