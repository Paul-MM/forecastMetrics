shinyServer(function(input, output, session) {
  
  # UI SWITCH --------------------------------------------------------------------------------------
  
  # Switch data based on ui selection
  datasetForeCInput <- reactive({
    
    if (input$sel_hrTS == "Leave (Days per FTE)"){
      switch(EXPR                   = input$sel_leaveType
             , "Unplanned Leave"    = ts_upl
             , "Planned Leave"      = ts_pl)
    }
    else if (input$sel_hrTS == "Workforce (HC)"){
      switch(EXPR                   = input$sel_employType
             , "Ongoing"            = ts_ongHC
             , "Non-Ongoing"        = ts_nonHC
             , "Casual"             = ts_casHC
             , "Total"              = ts_totHC)
    }
    else if (input$sel_hrTS == "Workforce (Paid FTE)"){
      switch(EXPR                   = input$sel_employType
             , "Ongoing"            = ts_ongFTE
             , "Non-Ongoing"        = ts_nonFTE
             , "Casual"             = ts_casFTE
             , "Total"              = ts_totFTE)
    }
    else if (input$sel_hrTS == "Separation Rate (%)"){
      switch(EXPR                   = input$sel_sepType
             , "Overall Ongoing"    = ts_sepn
             , "Natural Attrition"  = ts_attr
             , "Redundancy"         = ts_rdncy)
    }
    else if (input$sel_hrTS == "Average Tenure (Years)"){
      switch(EXPR                   = input$sel_agency
             , "ATO"                = ts_atoTnr
             , "APS"                = ts_apsTnr)
    }
    else if (input$sel_hrTS == "Diversity (%)"){
      if (input$sel_employType2 == "Total"){
        switch(EXPR                                               = input$sel_grp
               , "Non-English Speaking Background"                = ts_nesb
               , "Indigenous"                                     = ts_indg
               , "Disability"                                     = ts_dsbl)
      }
      else if (input$sel_employType2 == "Ongoing"){
        switch(EXPR                                               = input$sel_grp
               , "Non-English Speaking Background"                = ts_ongNesb
               , "Indigenous"                                     = ts_ongIndg
               , "Disability"                                     = ts_ongDsbl)
      }
    }
    else {
      switch(EXPR                                                 = input$sel_hrTS
             , "Average Age (Years)"                              = ts_age 
             , "Average Female Salary (% of Average Male Salary)" = ts_avgSal)
    }
    
    
    
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
    
    # Plot Title
    ttl <- ({
      if (input$sel_hrTS == "Leave (Days per FTE)"){
        plot_title <- paste(input$sel_leaveType, "(Days per FTE)")
      }
      else if (input$sel_hrTS == "Workforce (HC)"){
        plot_title <- paste(input$sel_hrTS, "-", input$sel_employType)
      }
      else if (input$sel_hrTS == "Workforce (Paid FTE)"){
        plot_title <- paste(input$sel_hrTS, "-", input$sel_employType)
      }
      else if (input$sel_hrTS == "Separation Rate (%)"){
        plot_title <- paste(input$sel_hrTS, "-", input$sel_sepType)
      }
      else if (input$sel_hrTS == "Average Tenure (Years)"){
        plot_title <- paste(input$sel_hrTS, "-", input$sel_agency)
      }
      else if (input$sel_hrTS == "Diversity (%)"){
        plot_title <- paste(input$sel_hrTS, "-", input$sel_grp, "-", input$sel_employType2)
      }
      else plot_title <- input$sel_hrTS
      
      plot_title
    })
    
    # Initialise progress bar
    withProgress(message = 'Making plot...', value = 0.2, {
      
      # ggplot
      gg <- HWplot(datasetForeCInput(), n.ahead = period, error.ribbon = "red") + 
            scale_x_date(breaks = scales::date_breaks("year")) + # change gridbreaks to yrs
            ylab("") + # remove y labels as they infringe on axis ticks
            xlab("") + # remove x label as it's self explanatory
            ggtitle(ttl) +
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