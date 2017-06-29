shinyServer(function(input, output, session) {
  
  # DYNAMIC UI  ------------------------------------------------------------------------------------
  
  output$HR_metric1 <- renderUI({
  
    HR_metric1_label <- ifelse(input$sel_task == "Forecast"
                               , "Choose HR metric to forecast:"
                               , "Choose first HR metric:")  
    
    selectInput(inputId    = "sel_hrTS"
                , label    = HR_metric1_label
                , choices  = c("Leave (Days per FTE)"
                               , "Workforce (HC)"
                               , "Workforce (Paid FTE)"
                               , "Workforce Utilisation (% of Paid FTE/HC)"
                               , "Separation Rate (%)"
                               , "Diversity (%)"
                               , "Average Age (Years)"
                               , "Average Tenure (Years)"
                               , "Average Female Salary (% of Average Male Salary)"))
  })
  
  # Date Comment
  output$dt <- renderUI({
    
    snpsht_dt <- format(max(df$Snpsht_Dt), "%d.%m.%Y")
    paste0("Data is as at ", snpsht_dt)
    
  })
  
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
               if (input$sel_hcType == "Ongoing") {
                 switch(input$sel_hcSite
                        , "All sites"     = ts(data = df$ongHC, start = c(2007, 7), frequency = 12)
                        , "Adelaide"      = ts(data = df$ongHC_Adelaide, start = c(2007, 7), frequency = 12)
                        , "Albury"        = ts(data = df$ongHC_Albury, start = c(2007, 7), frequency = 12)
                        , "Alice Springs" = ts(data = df$ongHC_AliceSprings, start = c(2007, 7), frequency = 12)
                        , "Brisbane"      = ts(data = df$ongHC_Brisbane, start = c(2007, 7), frequency = 12)
                        , "Burnie"        = ts(data = df$ongHC_Burnie, start = c(2007, 7), frequency = 12)
                        , "Box Hill"      = ts(data = df$ongHC_BoxHill, start = c(2007, 7), frequency = 12)
                        , "Canberra"      = ts(data = df$ongHC_Canberra, start = c(2007, 7), frequency = 12)
                        , "Chermside"     = ts(data = df$ongHC_Chermside, start = c(2007, 7), frequency = 12)
                        , "Dandenong"     = ts(data = df$ongHC_Dandenong, start = c(2007, 7), frequency = 12)
                        , "Darwin"        = ts(data = df$ongHC_Darwin, start = c(2007, 7), frequency = 12)
                        , "Gold Coast"    = ts(data = df$ongHC_GoldCoast, start = c(2007, 7), frequency = 12)
                        , "Geelong"       = ts(data = df$ongHC_Geelong, start = c(2007, 7), frequency = 12)
                        , "Hobart"        = ts(data = df$ongHC_Hobart, start = c(2007, 7), frequency = 12)
                        , "Melbourne"     = ts(data = df$ongHC_Melbourne, start = c(2007, 7), frequency = 12)
                        , "Moonee Ponds"  = ts(data = df$ongHC_MooneePonds, start = c(2007, 7), frequency = 12)
                        , "Maroochydore"  = ts(data = df$ongHC_Maroochydore, start = c(2007, 7), frequency = 12)
                        , "Newcastle"     = ts(data = df$ongHC_Newcastle, start = c(2007, 7), frequency = 12)
                        , "Parramatta"    = ts(data = df$ongHC_Parramatta, start = c(2007, 7), frequency = 12)
                        , "Penrith"       = ts(data = df$ongHC_Penrith, start = c(2007, 7), frequency = 12)
                        , "Perth"         = ts(data = df$ongHC_Perth, start = c(2007, 7), frequency = 12)
                        , "Sydney"        = ts(data = df$ongHC_Sydney, start = c(2007, 7), frequency = 12)
                        , "Townsville"    = ts(data = df$ongHC_Townsville, start = c(2007, 7), frequency = 12))
               } else if (input$sel_hcType == "Non-Ongoing") {
                 ts(data = df$nonHC, start = c(2007, 7), frequency = 12)
               } else if (input$sel_hcType == "Casual") {
                 ts(data = df$casHC, start = c(2007, 7), frequency = 12)
               } else if (input$sel_hcType == "Total") {
                 ts(data = df$totHC, start = c(2007, 7), frequency = 12)
               }
             } else if (input$sel_calc == "Percentage of Total") {
               if (input$sel_hcType == "Ongoing") {
                 ts(data = (df$ongHC/df$totHC)*100, start = c(2007, 7), frequency = 12)
               } else if (input$sel_hcType == "Non-Ongoing") {
                 ts(data = (df$nonHC/df$totHC)*100, start = c(2007, 7), frequency = 12)
               } else if (input$sel_hcType == "Casual") {
                 ts(data = (df$casHC/df$totHC)*100, start = c(2007, 7), frequency = 12)
               } else if (input$sel_hcType == "Total") {
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
           , "Separation Rate (%)" = {
             df2 <- filter(df, !is.na(df$Tot_Attr_R12))
             if (input$sel_calc == "Count"){
               if (input$sel_sepType == "Overall Ongoing") {
                 ts(data = df2$Tot_Attr_R12, start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType == "Natural Attrition") {
                 ts(data = df2$Nat_Atrr_R12, start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType == "Redundancy") {
                 ts(data = df2$Rdncy_R12,    start = c(2008, 7), frequency = 12)
               }
             } else if (input$sel_calc == "Percentage of Total"){
               if (input$sel_sepType == "Overall Ongoing") {
                 ts(data = df2$Tot_Attr_R12,                     start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType == "Natural Attrition") {
                 ts(data = df2$Nat_Atrr_R12/df2$Tot_Attr_R12*100,start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType == "Redundancy") {
                 ts(data = df2$Rdncy_R12/df2$Tot_Attr_R12*100,   start = c(2008, 7), frequency = 12)
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
  
  # Switch data based on 2nd ui selection
  datasetForeCInput_2 <- reactive({
    
    switch(EXPR = input$sel_hrTS_2
           , "Leave (Days per FTE)" = {
             
             # Filter out dates with no data and calculate time series start date
             df2 <- filter(df, !is.na(df$totR12))
             strt_mth   <- month(df2$Snpsht_Dt[1])
             strt_yr    <- year(df2$Snpsht_Dt[1])
             strt_dt    <- c(strt_yr, strt_mth)
             
             if (input$sel_calc_2 == "Count") {
               if (input$sel_leaveType_2        == "Unplanned Leave") {
                 ts(data = df2$uplR12, start = strt_dt, frequency = 12)
               } else if (input$sel_leaveType_2 == "Planned Leave") {
                 ts(data = df2$plR12, start = strt_dt, frequency = 12)
               } else if (input$sel_leaveType_2 == "Total Leave") {
                 ts(data = df2$totR12, start = strt_dt, frequency = 12)
               }
             } else if (input$sel_calc_2 == "Percentage of Total") {
               if (input$sel_leaveType_2        == "Unplanned Leave") {
                 ts(data = (df2$uplR12/df2$totR12)*100, start = strt_dt, frequency = 12)
               } else if (input$sel_leaveType_2 == "Planned Leave") {
                 ts(data = (df2$plR12/df2$totR12)*100, start = strt_dt, frequency = 12)
               } else if (input$sel_leaveType_2 == "Total Leave") {
                 ts(data = df2$totR12, start = strt_dt, frequency = 12)
               }
             }
           }
           , "Workforce (HC)" = {
             if (input$sel_calc_2 == "Count") {
               if (input$sel_hcType_2        == "Ongoing") {
                 switch(input$sel_hcSite_2
                        , "All sites"     = ts(data = df$ongHC, start = c(2007, 7), frequency = 12)
                        , "Adelaide"      = ts(data = df$ongHC_Adelaide, start = c(2007, 7), frequency = 12)
                        , "Albury"        = ts(data = df$ongHC_Albury, start = c(2007, 7), frequency = 12)
                        , "Alice Springs" = ts(data = df$ongHC_AliceSprings, start = c(2007, 7), frequency = 12)
                        , "Brisbane"      = ts(data = df$ongHC_Brisbane, start = c(2007, 7), frequency = 12)
                        , "Burnie"        = ts(data = df$ongHC_Burnie, start = c(2007, 7), frequency = 12)
                        , "Box Hill"      = ts(data = df$ongHC_BoxHill, start = c(2007, 7), frequency = 12)
                        , "Canberra"      = ts(data = df$ongHC_Canberra, start = c(2007, 7), frequency = 12)
                        , "Chermside"     = ts(data = df$ongHC_Chermside, start = c(2007, 7), frequency = 12)
                        , "Dandenong"     = ts(data = df$ongHC_Dandenong, start = c(2007, 7), frequency = 12)
                        , "Darwin"        = ts(data = df$ongHC_Darwin, start = c(2007, 7), frequency = 12)
                        , "Gold Coast"    = ts(data = df$ongHC_GoldCoast, start = c(2007, 7), frequency = 12)
                        , "Geelong"       = ts(data = df$ongHC_Geelong, start = c(2007, 7), frequency = 12)
                        , "Hobart"        = ts(data = df$ongHC_Hobart, start = c(2007, 7), frequency = 12)
                        , "Melbourne"     = ts(data = df$ongHC_Melbourne, start = c(2007, 7), frequency = 12)
                        , "Moonee Ponds"  = ts(data = df$ongHC_MooneePonds, start = c(2007, 7), frequency = 12)
                        , "Maroochydore"  = ts(data = df$ongHC_Maroochydore, start = c(2007, 7), frequency = 12)
                        , "Newcastle"     = ts(data = df$ongHC_Newcastle, start = c(2007, 7), frequency = 12)
                        , "Parramatta"    = ts(data = df$ongHC_Parramatta, start = c(2007, 7), frequency = 12)
                        , "Penrith"       = ts(data = df$ongHC_Penrith, start = c(2007, 7), frequency = 12)
                        , "Perth"         = ts(data = df$ongHC_Perth, start = c(2007, 7), frequency = 12)
                        , "Sydney"        = ts(data = df$ongHC_Sydney, start = c(2007, 7), frequency = 12)
                        , "Townsville"    = ts(data = df$ongHC_Townsville, start = c(2007, 7), frequency = 12))
               } else if (input$sel_hcType_2 == "Non-Ongoing") {
                 ts(data = df$nonHC, start = c(2007, 7), frequency = 12)
               } else if (input$sel_hcType_2 == "Casual") {
                 ts(data = df$casHC, start = c(2007, 7), frequency = 12)
               } else if (input$sel_hcType_2 == "Total") {
                 ts(data = df$totHC, start = c(2007, 7), frequency = 12)
               }
             } else if (input$sel_calc_2 == "Percentage of Total") {
               if (input$sel_hcType_2        == "Ongoing") {
                 ts(data = (df$ongHC/df$totHC)*100, start = c(2007, 7), frequency = 12)
               } else if (input$sel_hcType_2 == "Non-Ongoing") {
                 ts(data = (df$nonHC/df$totHC)*100, start = c(2007, 7), frequency = 12)
               } else if (input$sel_hcType_2 == "Casual") {
                 ts(data = (df$casHC/df$totHC)*100, start = c(2007, 7), frequency = 12)
               } else if (input$sel_hcType_2 == "Total") {
                 ts(data = df$totHC, start = c(2007, 7), frequency = 12)
               }
             }
           }
           , "Workforce (Paid FTE)" = {
             df2 <- filter(df, df$Snpsht_Dt >= "2014/03/31")
             if (input$sel_calc_2 == "Count") {
               if (input$sel_employType_2        == "Ongoing") {
                 ts(data = df2$ongFTE, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType_2 == "Non-Ongoing") {
                 ts(data = df2$nonFTE, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType_2 == "Casual") {
                 ts(data = df2$casFTE, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType_2 == "Total") {
                 ts(data = df2$totFTE, start = c(2014, 3), frequency = 12)
               }
             } else if (input$sel_calc_2 == "Percentage of Total") {
               if (input$sel_employType_2        == "Ongoing") {
                 ts(data = (df2$ongFTE/df2$totFTE)*100, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType_2 == "Non-Ongoing") {
                 ts(data = (df2$nonFTE/df2$totFTE)*100, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType_2 == "Casual") {
                 ts(data = (df2$casFTE/df2$totFTE)*100, start = c(2014, 3), frequency = 12)
               } else if (input$sel_employType_2 == "Total") {
                 ts(data = df2$totFTE, start = c(2014, 3), frequency = 12)
               }
             }
           }
           , "Workforce Utilisation (% of Paid FTE/HC)" = {
             df2 <- filter(df, df$Snpsht_Dt >= "2014/03/31")
             if (input$sel_employType_2        == "Ongoing") {
               ts(data = (df2$ongFTE/df2$ongHC)*100, start = c(2014, 3), frequency = 12)
             } else if (input$sel_employType_2 == "Non-Ongoing") {
               ts(data = (df2$nonFTE/df2$nonHC)*100, start = c(2014, 3), frequency = 12)
             } else if (input$sel_employType_2 == "Casual") {
               ts(data = (df2$casFTE/df2$casHC)*100, start = c(2014, 3), frequency = 12)
             } else if (input$sel_employType_2 == "Total") {
               ts(data = (df2$totFTE/df2$totHC)*100, start = c(2014, 3), frequency = 12)
             }
           }
           , "Separation Rate (%)" = {
             df2 <- filter(df, !is.na(df$Tot_Attr_R12))
             if (input$sel_calc_2 == "Count"){
               if (input$sel_sepType_2 == "Overall Ongoing") {
                 ts(data = df2$Tot_Attr_R12, start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType_2 == "Natural Attrition") {
                 ts(data = df2$Nat_Atrr_R12, start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType_2 == "Redundancy") {
                 ts(data = df2$Rdncy_R12,    start = c(2008, 7), frequency = 12)
               }
             } else if (input$sel_calc_2 == "Percentage of Total"){
               if (input$sel_sepType_2 == "Overall Ongoing") {
                 ts(data = df2$Tot_Attr_R12,                     start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType_2 == "Natural Attrition") {
                 ts(data = df2$Nat_Atrr_R12/df2$Tot_Attr_R12*100,start = c(2008, 7), frequency = 12)
               } else if (input$sel_sepType_2 == "Redundancy") {
                 ts(data = df2$Rdncy_R12/df2$Tot_Attr_R12*100,   start = c(2008, 7), frequency = 12)
               }
             }
           }
           , "Diversity (%)" = {
             df2 <- filter(df, df$Snpsht_Dt >= "2013/07/31")
             if (input$sel_calc_2 == "Count") {
               if (input$sel_employType2_2 == "Ongoing") {
                 if (input$sel_grp_2 == "Non-English Speaking Background") {
                   ts(data = df2$ongNESB_HC, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp_2 == "Indigenous") {
                   ts(data = df2$ongIdgn_HC, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp_2 == "Disability") {
                   ts(data = df2$ongDsbl_HC, start = c(2013, 7), frequency = 12)
                 }
               } else if (input$sel_employType2_2 == "Total") {
                 if (input$sel_grp_2 == "Non-English Speaking Background") {
                   ts(data = df2$totNESB_HC, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp_2 == "Indigenous") {
                   ts(data = df2$totIdgn_HC, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp_2 == "Disability") {
                   ts(data = df2$totDsbl_HC, start = c(2013, 7), frequency = 12)
                 }
               }
             } else if (input$sel_calc_2 == "Percentage of Total") {
               if (input$sel_employType2_2 == "Ongoing") {
                 if (input$sel_grp_2 == "Non-English Speaking Background") {
                   ts(data = df2$ongNESB_pct, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp_2 == "Indigenous") {
                   ts(data = df2$ongIdgn_pct, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp_2 == "Disability") {
                   ts(data = df2$ongDsbl_pct, start = c(2013, 7), frequency = 12)
                 }
               } else if (input$sel_employType2_2 == "Total") {
                 if (input$sel_grp_2 == "Non-English Speaking Background") {
                   ts(data = df2$totNESB_pct, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp_2 == "Indigenous") {
                   ts(data = df2$totIdgn_pct, start = c(2013, 7), frequency = 12)
                 } else if (input$sel_grp_2 == "Disability") {
                   ts(data = df2$totDsbl_pct, start = c(2013, 7), frequency = 12)
                 }
               }
             }
           }
           , "Average Age (Years)" = {
             ts(data = df$age, start = c(2007, 7), frequency = 12)
           }
           , "Average Tenure (Years)" = {
             if (input$sel_agency_2 == "ATO") {
               ts(data = df$atoTnr, start = c(2007, 7), frequency = 12)
             } else if (input$sel_agency_2 == "APS") {
               ts(data = df$apsTnr, start = c(2007, 7), frequency = 12)
             }
           }
           , "Average Female Salary (% of Average Male Salary)" = {
             ts(data = df$Slry_Pct, start = c(2007, 7), frequency = 12)
           }
    )
    
  })
  
  # CORRELATION ------------------------------------------------------------------------------------
  
  # Correlation Calculation
  ccorr.coefficient <- reactive({

    # Gives common times for both time series and their respective values.
    ts.combined <- ts.intersect(datasetForeCInput(), datasetForeCInput_2())

    # Gives correlation matrix at lag 0
    ccorr.coefficient <- cor(ts.combined)

    # Extracts the correlation coefficient between both time series at lag 0
    ccorr.coefficient <- round(ccorr.coefficient[1,2], 2)

  })

  # Correlation score message
  output$correlationScore <- renderUI({

    strong(paste("Cross-correlation between corresponding times:", ccorr.coefficient()))

  })

  # Correlation significance message
  output$correlationMessage <- renderUI({

    ccorr.relationship <- if (ccorr.coefficient() == -1) {
      "Perfect negative Cross-correlation"
    }
    else if(ccorr.coefficient() > -1 && ccorr.coefficient() <= -0.8) {
      "Very strong negative Cross-correlation"
    }
    else if(ccorr.coefficient() > -0.8 && ccorr.coefficient() <= -0.6) {
      "Strong negative Cross-correlation"
    }
    else if(ccorr.coefficient() > -0.6 && ccorr.coefficient() <= -0.4) {
      "Moderate negative Cross-correlation"
    }
    else if(ccorr.coefficient() > -0.4 && ccorr.coefficient() <= -0.2) {
      "Weak negative Cross-correlation"
    }
    else if(ccorr.coefficient() > -0.2 && ccorr.coefficient() < 0) {
      "Very weak negative Cross-correlation"
    }
    else if(ccorr.coefficient() == 0) {
      "No Cross-correlation"
    }
    else if(ccorr.coefficient() > 0 && ccorr.coefficient() < 0.2) {
      "Very weak positive Cross-correlation"
    }
    else if(ccorr.coefficient() >= 0.2 && ccorr.coefficient() < 0.4) {
      "Weak positive Cross-correlation"
    }
    else if(ccorr.coefficient() >= 0.4 && ccorr.coefficient() < 0.6) {
      "Moderate positive Cross-correlation"
    }
    else if(ccorr.coefficient() >= 0.6 && ccorr.coefficient() < 0.8) {
      "Strong positive Cross-correlation"
    }
    else if(ccorr.coefficient() >= 0.8 && ccorr.coefficient() < 1) {
      "Very strong positive Cross-correlation"
    }
    else if(ccorr.coefficient() == 1) {
      "Perfect positive Cross-correlation"
    }

    strong(paste("Cross-correlation relationship:", ccorr.relationship))
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
    
    if(input$sel_task == "Forecast") {
    
      graphset
    
    }
    
    else if(input$sel_task == "Compare") {
      
      actual_values_2 <- data.frame(time = round(x = time(datasetForeCInput_2()), digits = 3),
                                  Actual = c(round(datasetForeCInput_2(), digits = 2)))
      
      # Date processing for table output
      date_2         <- date_decimal(decimal = as.numeric(actual_values_2$time))
      date_2         <- as.Date(x = date_2)
      date_2         <- round_date(x = date_2, unit = "month")
      date_2         <- substr(x = date_2, start = 1, stop = 7)
      actual_values_2[,1] <- date_2
      
      # Rename columns
      colnames(actual_values_2)  <- c("Period", "HR Metric 2") # Change colnames
      
      # Merge time series 1 values with time series 2 values
      compare_df <- merge(x = graphset[is.na(graphset$`Actual Values`) == F,1:2]
                          , y = actual_values_2
                          , by = 'Period'
                          , all = TRUE)
      colnames(compare_df)[2] <- "HR Metric 1"
      compare_df <- compare_df[ order(compare_df$Period, decreasing = TRUE), ] # Sort DESC
      
      compare_df
    }
    
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
        if (input$sel_hcType == "Ongoing") {
          paste(input$sel_hrTS, "-", input$sel_hcType, "-", input$sel_hcSite)
        } else {
          paste(input$sel_hrTS, "-", input$sel_hcType)
        }
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
    
    if(input$sel_task == "Forecast") {
    
    # Initialise progress bar
    withProgress(message = 'Making plot...', value = 0.2, {
    
    # Determines all the recent Snpsht_Dt dates to match the time series  
    actual.dates <- df$Snpsht_Dt[(length(df$Snpsht_Dt) 
                                - length(datasetForeCInput()) + 1):length(df$Snpsht_Dt)]  
    
    # Determines all the recent Snpsht_Dt dates to match the  fitted time series
    fitted.dates <- df$Snpsht_Dt[(length(df$Snpsht_Dt) 
                                  - length(datasetForeCInput()) + 13):length(df$Snpsht_Dt)]
    
    # Determines all the forecasted dates
    forecast.dates <- seq(max(df$Snpsht_Dt) + 1, by = "month", length.out = period + 1) - 1
    forecast.dates <- forecast.dates[-1]
        
      # ggplot
      gg <- HWplot(datasetForeCInput(), actual.times = actual.dates, fitted.times = fitted.dates
                   , forecast.times = forecast.dates, n.ahead = period, error.ribbon = "#002341") + 
            scale_x_date(breaks = scales::date_breaks("year")) + # change gridbreaks to yrs
            ylab("") + # remove y labels as they infringe on axis ticks
            xlab("") + # remove x label as it's self explanatory
            ggtitle(ttl) +
            scale_color_manual(values = c("#0F979B", "#002341")) +
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
    }
    
    else if(input$sel_task == "Compare") {
      
      # Initialise progress bar
      withProgress(message = 'Making plot...', value = 0.2, {
      
      # Determines all the recent Snpsht_Dt dates to match the time series
      mnth.dates <- df$Snpsht_Dt[(length(df$Snpsht_Dt) 
                                  - length(datasetForeCInput()) + 1):length(df$Snpsht_Dt)]  
      
      # Make a df of selected time series and matched Snpsht dates  
      metric1_values <- data.frame(Date = mnth.dates,
                                   value = c(round(datasetForeCInput(), digits = 2)))
      
      # ggplot
      g <- ggplot(data = metric1_values, aes(x = Date, y = value)) +
        geom_line(col = '#00C8D2', size = 1) +
        ylab("") +
        xlab("") +
        ggtitle(paste('HR Metric 1 -', ttl)) 
      
      incProgress(0.4) # increment progress
      
      # Plotly
      p                    <- plotly_build(g)
      p$layout$margin$l    <- 50
      p$layout$xaxis$type  <- "date"
      
      incProgress(0.4) # increment progress
      
      plotly_build(p) 
      })  
    }
    
  })
  
  output$metric2Plot <- renderPlotly({
    
    ttl <- ({
      if (input$sel_hrTS_2 == "Leave (Days per FTE)"){
        paste(input$sel_leaveType_2, "(Days per FTE)")
      } else if (input$sel_hrTS_2 == "Workforce (HC)"){
        if (input$sel_hcType_2 == "Ongoing") {
          paste(input$sel_hrTS_2, "-", input$sel_hcType_2, "-", input$sel_hcSite_2)
        } else {
          paste(input$sel_hrTS_2, "-", input$sel_hcType_2)
        }
      } else if (input$sel_hrTS_2 == "Workforce (Paid FTE)"){
        paste(input$sel_hrTS_2, "-", input$sel_employType_2)
      } else if (input$sel_hrTS_2 == "Workforce Utilisation (% of Paid FTE/HC)"){
        paste(input$sel_hrTS_2, "-", input$sel_employType_2)
      } else if (input$sel_hrTS_2 == "Separation Rate (%)"){
        paste(input$sel_hrTS_2, "-", input$sel_sepType_2)
      } else if (input$sel_hrTS_2 == "Average Tenure (Years)"){
        paste(input$sel_hrTS_2, "-", input$sel_agency_2)
      } else if (input$sel_hrTS_2 == "Diversity (%)"){
        paste(input$sel_hrTS_2, "-", input$sel_grp_2, "-", input$sel_employType2_2)
      } else {
        input$sel_hrTS_2
      }
      
    })
    
    # Determines all the recent Snpsht_Dt dates to match the time series
    mnth.dates <- df$Snpsht_Dt[(length(df$Snpsht_Dt) 
                                - length(datasetForeCInput_2()) + 1):length(df$Snpsht_Dt)]
    
    # Make a df of selected time series and matched Snpsht dates
    metric2_values <- data.frame(Date = mnth.dates
                                 , value = c(round(datasetForeCInput_2(), digits = 2)))
    
    # ggplot
    g <- ggplot(data = metric2_values, aes(x = Date, y = value)) +
      geom_line(col = '#2B3054', size = 1) +
      ylab("") +
      xlab("") +
      ggtitle(paste('HR Metric 2 - ', ttl)) 
    
    # Plotly
    p                    <- plotly_build(g)
    p$layout$margin$l    <- 50
    p$layout$xaxis$type  <- "date"
    
    plotly_build(p)
    
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