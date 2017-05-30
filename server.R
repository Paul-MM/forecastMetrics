shinyServer(function(input, output, session) {
  
  # UI SWITCH --------------------------------------------------------------------------------------
  
  # Switch data based on ui selection and create time series
  datasetForeCInput <- reactive({
    
    switch(EXPR = input$sel_hrTS
           , "Leave (Days per FTE)" = {
             
             # Filter out dates with no data and calculate time series start date
             df2 <- filter(df, !is.na(df$totR12))
             strt_mth   <- month(df2$Snpsht_Dt[1])
             strt_yr    <- year(df2$Snpsht_Dt[1])
             strt_dt    <- c(strt_yr, strt_mth)
             
             if (input$sel_calc == "Count") {
               if (input$sel_leaveType        == "Unplanned Leave") {
                 ts(data = df2$uplR12, start = strt_dt, frequency = 12)
               } else if (input$sel_leaveType == "Planned Leave") {
                 ts(data = df2$plR12, start = strt_dt, frequency = 12)
               } else if (input$sel_leaveType == "Total Leave") {
                 ts(data = df2$totR12, start = strt_dt, frequency = 12)
               }
             } else if (input$sel_calc == "Percentage of Total") {
               if (input$sel_leaveType        == "Unplanned Leave") {
                 ts(data = (df2$uplR12/df2$totR12)*100, start = strt_dt, frequency = 12)
               } else if (input$sel_leaveType == "Planned Leave") {
                 ts(data = (df2$plR12/df2$totR12)*100, start = strt_dt, frequency = 12)
               } else if (input$sel_leaveType == "Total Leave") {
                 ts(data = df2$totR12, start = strt_dt, frequency = 12)
               }
             }
           }
           , "Workforce (HC)" = {
             if (input$sel_calc == "Count") {
               if (input$sel_employType        == "Ongoing") {
                 ts(data = df$ongHC, start = c(2007, 7), frequency = 12)
               } else if (input$sel_employType == "Non-Ongoing") {
                 ts(data = df$nonHC, start = c(2007, 7), frequency = 12)
               } else if (input$sel_employType == "Casual") {
                 ts(data = df$casHC, start = c(2007, 7), frequency = 12)
               } else if (input$sel_employType == "Total") {
                 ts(data = df$totHC, start = c(2007, 7), frequency = 12)
               }
             } else if (input$sel_calc == "Percentage of Total") {
               if (input$sel_employType        == "Ongoing") {
                 ts(data = (df$ongHC/df$totHC)*100, start = c(2007, 7), frequency = 12)
               } else if (input$sel_employType == "Non-Ongoing") {
                 ts(data = (df$nonHC/df$totHC)*100, start = c(2007, 7), frequency = 12)
               } else if (input$sel_employType == "Casual") {
                 ts(data = (df$casHC/df$totHC)*100, start = c(2007, 7), frequency = 12)
               } else if (input$sel_employType == "Total") {
                 ts(data = df$totHC, start = c(2007, 7), frequency = 12)
               }
             }
           }
           , "Workforce (Paid FTE)" = {
             df2 <- filter(df, df$Snpsht_Dt >= "2014/03/31")
             if (input$sel_calc == "Count") {
               if (input$sel_employType        == "Ongoing") {
                 ts(data = df2$ongFTE, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType == "Non-Ongoing") {
                 ts(data = df2$nonFTE, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType == "Casual") {
                 ts(data = df2$casFTE, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType == "Total") {
                 ts(data = df2$totFTE, start = c(2014, 3), frequency = 12)
               }
             } else if (input$sel_calc == "Percentage of Total") {
               if (input$sel_employType        == "Ongoing") {
                 ts(data = (df2$ongFTE/df2$totFTE)*100, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType == "Non-Ongoing") {
                 ts(data = (df2$nonFTE/df2$totFTE)*100, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType == "Casual") {
                 ts(data = (df2$casFTE/df2$totFTE)*100, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType == "Total") {
                 ts(data = df2$totFTE, start = c(2014, 3), frequency = 12)
               }
             }
           }
           , "Workforce Utilisation (% of Paid FTE/HC)" = {
             df2 <- filter(df, df$Snpsht_Dt >= "2014/03/31")
             if (input$sel_employType        == "Ongoing") {
               ts(data = (df2$ongFTE/df2$ongHC)*100, start = c(2014, 3), frequency = 12)
             } else if (input$sel_employType == "Non-Ongoing") {
               ts(data = (df2$nonFTE/df2$nonHC)*100, start = c(2014, 3), frequency = 12)
             } else if (input$sel_employType == "Casual") {
               ts(data = (df2$casFTE/df2$casHC)*100, start = c(2014, 3), frequency = 12)
             } else if (input$sel_employType == "Total") {
               ts(data = (df2$totFTE/df2$totHC)*100, start = c(2014, 3), frequency = 12)
             }
           }
           # SQL for df does not include separation metrics yet
           # TODO - add separation values once metric is included in df
           , "Separation Rate (%)" = {
             if (input$sel_calc == "Count"){
               if (input$sel_sepType == "Overall Ongoing") {
                 ts(data = ts_sepn$Measure,      start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType == "Natural Attrition") {
                 ts(data = ts_attr$Measure,      start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType == "Redundancy") {
                 ts(data = ts_rdncy$Measure,     start = c(2008, 7), frequency = 12)
               }
             } else if (input$sel_calc == "Percentage of Total"){
               if (input$sel_sepType == "Overall Ongoing") {
                 ts(data = ts_sepn$Measure,      start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType == "Natural Attrition") {
                 ts(data = ts_attrpcnt$Measure,  start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType == "Redundancy") {
                 ts(data = ts_rdncypcnt$Measure, start = c(2008, 7), frequency = 12)
               }
             }
           }
           , "Diversity (%)" = {
             df2 <- filter(df, df$Snpsht_Dt >= "2013/07/31")
             if (input$sel_calc == "Count") {
               if (input$sel_employType2 == "Ongoing") {
                 if (input$sel_grp == "Non-English Speaking Background") {
                   ts(data = df2$ongNESB_HC, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp == "Indigenous") {
                   ts(data = df2$ongIdgn_HC, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp == "Disability") {
                   ts(data = df2$ongDsbl_HC, start = c(2013, 7), frequency = 12)
                 }
               } else if (input$sel_employType2 == "Total") {
                 if (input$sel_grp == "Non-English Speaking Background") {
                   ts(data = df2$totNESB_HC, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp == "Indigenous") {
                   ts(data = df2$totIdgn_HC, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp == "Disability") {
                   ts(data = df2$totDsbl_HC, start = c(2013, 7), frequency = 12)
                 }
               }
             } else if (input$sel_calc == "Percentage of Total") {
               if (input$sel_employType2 == "Ongoing") {
                 if (input$sel_grp == "Non-English Speaking Background") {
                   ts(data = df2$ongNESB_pct, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp == "Indigenous") {
                   ts(data = df2$ongIdgn_pct, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp == "Disability") {
                   ts(data = df2$ongDsbl_pct, start = c(2013, 7), frequency = 12)
                 }
               } else if (input$sel_employType2 == "Total") {
                 if (input$sel_grp == "Non-English Speaking Background") {
                   ts(data = df2$totNESB_pct, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp == "Indigenous") {
                   ts(data = df2$totIdgn_pct, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp == "Disability") {
                   ts(data = df2$totDsbl_pct, start = c(2013, 7), frequency = 12)
                 }
               }
             }
           }
           , "Average Age (Years)" = {
             ts(data = df$age, start = c(2007, 7), frequency = 12)
           }
           , "Average Tenure (Years)" = {
             if (input$sel_agency == "ATO") {
               ts(data = df$atoTnr, start = c(2007, 7), frequency = 12)
             } else if (input$sel_agency == "APS") {
               ts(data = df$apsTnr, start = c(2007, 7), frequency = 12)
             }
           }
           , "Average Female Salary (% of Average Male Salary)" = {
             ts(data = df$Slry_Pct, start = c(2007, 7), frequency = 12)
           }
           )
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
        paste(input$sel_leaveType, "(Days per FTE)")
      } else if (input$sel_hrTS == "Workforce (HC)"){
        paste(input$sel_hrTS, "-", input$sel_employType)
      } else if (input$sel_hrTS == "Workforce (Paid FTE)"){
        paste(input$sel_hrTS, "-", input$sel_employType)
      } else if (input$sel_hrTS == "Workforce Utilisation (% of Paid FTE/HC)"){
        paste(input$sel_hrTS, "-", input$sel_employType)
      } else if (input$sel_hrTS == "Separation Rate (%)"){
        paste(input$sel_hrTS, "-", input$sel_sepType)
      } else if (input$sel_hrTS == "Average Tenure (Years)"){
        paste(input$sel_hrTS, "-", input$sel_agency)
      } else if (input$sel_hrTS == "Diversity (%)"){
        paste(input$sel_hrTS, "-", input$sel_grp, "-", input$sel_employType2)
      } else {
        input$sel_hrTS
      }
      
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