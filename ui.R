shinyUI(function(request){
  
  # Define link and text for forecasting explanation
  link <- "https://en.wikipedia.org/wiki/Exponential_smoothing#Triple_exponential_smoothing"
  text <- "Information on Holt-Winters forecasting"
  
  fluidPage(
    
    # Navbar HTML
    includeHTML("www/navbar.html"),
      
    div(style = "padding-top:50px", titlePanel("HR Time Series Forecasting")),
    
    sidebarLayout(
      
      sidebarPanel(
        
        radioButtons("sel_task"
                     , "Select Task:"
                     , choices = c("Forecast", "Compare")
                     , selected = "Forecast"
                     , inline = TRUE),
        
        uiOutput("HR_metric1"),
        
        # Leave
        conditionalPanel(condition = "input.sel_hrTS == 'Leave (Days per FTE)'",
                         radioButtons("sel_leaveType"
                                      , "Select Leave Type:"
                                      , choices = c("Unplanned Leave", "Planned Leave", 
                                                    "Total Leave")
                                      , selected = "Unplanned Leave")),
        
        # Workforce Headcount
        conditionalPanel(condition = "input.sel_hrTS == 'Workforce (HC)'",
                         radioButtons("sel_hcType"
                                      , "Select Employment Type:"
                                      , choices = c("Ongoing", "Non-Ongoing"
                                                    , "Casual", "Total")
                                      , selected = "Ongoing")),
        
        # Workforce Headcount - By Site, Ongoing employees
        conditionalPanel(condition = "input.sel_hrTS   == 'Workforce (HC)' &&
                                      input.sel_hcType == 'Ongoing'",
                         selectInput("sel_hcSite"
                                     , "Select Site:"
                                     , choices  = c("All sites"
                                                    , "Adelaide"
                                                    , "Albury"
                                                    , "Alice Springs"
                                                    , "Brisbane"
                                                    , "Burnie"
                                                    , "Box Hill"
                                                    , "Canberra"
                                                    , "Chermside"
                                                    , "Dandenong"
                                                    , "Darwin"
                                                    , "Gold Coast"
                                                    , "Geelong"
                                                    , "Hobart"
                                                    , "Melbourne"
                                                    , "Moonee Ponds"
                                                    , "Maroochydore"
                                                    , "Newcastle"
                                                    , "Parramatta"
                                                    , "Penrith"
                                                    , "Perth"
                                                    , "Sydney"
                                                    , "Townsville")
                                     , selected = "All sites")),
                                     
        # Paid FTE
        conditionalPanel(condition = "input.sel_hrTS == 'Workforce (Paid FTE)' || 
                                      input.sel_hrTS == 'Workforce Utilisation (% of Paid FTE/HC)'",
                         radioButtons("sel_employType"
                                      , "Select Employment Type:"
                                      , choices = c("Ongoing", "Non-Ongoing"
                                                    , "Casual", "Total")
                                      , selected = "Ongoing")),
        
        # Separation Rate
        conditionalPanel(condition = "input.sel_hrTS == 'Separation Rate (%)'",
                         radioButtons("sel_sepType"
                                      , "Select Separation Type:"
                                      , choices = c("Overall Ongoing", "Natural Attrition"
                                                    , "Redundancy")
                                      , selected = "Overall Ongoing")),
        
        # Tenure
        conditionalPanel(condition = "input.sel_hrTS == 'Average Tenure (Years)'",
                         radioButtons("sel_agency"
                                      , "Select Agency:"
                                      , choices = c("ATO", "APS")
                                      , selected = "ATO")),

        # Diversity        
        conditionalPanel(condition = "input.sel_hrTS == 'Diversity (%)'",
                         radioButtons("sel_grp"
                                      , "Select Group:"
                                      , choices = c("Non-English Speaking Background"
                                                    , "Indigenous", "Disability")
                                      , selected = "Non-English Speaking Background"),
                         radioButtons("sel_employType2"
                                      , "Select Employment Type:"
                                      , choices = c("Ongoing", "Total")
                                      , selected = "Ongoing")),
        
        # Add choice to display certain metrics as a count, or percentage of total 
        conditionalPanel(condition = "input.sel_hrTS == 'Leave (Days per FTE)' &&
                                      input.sel_leaveType != 'Total Leave' ||
                                      input.sel_hrTS == 'Workforce (HC)' &&
                                      input.sel_hcType != 'Total' ||
                                      input.sel_hrTS == 'Workforce (Paid FTE)' &&
                                      input.sel_employType != 'Total' ||
                                      input.sel_hrTS == 'Separation Rate (%)' &&
                                      input.sel_sepType != 'Overall Ongoing' ||
                                      input.sel_hrTS == 'Diversity (%)'",
                         radioButtons("sel_calc"
                                      , "Select Calculation Type:"
                                      , choices = c("Count", "Percentage of Total")
                                      , selected = "Count")),
        
        # Below are the inputs for the second time series user wants to compare with
        conditionalPanel(condition = "input.sel_task == 'Compare'",
                         
                         # Line to divide HR metric 1 from HR metric 2
                         div(style = "border-bottom: 2px solid #9e9494"),
                         
                         br(),
                         
                         selectInput(inputId    = "sel_hrTS_2"
                                     , label    = "Choose second HR metric:"
                                     , choices  = c("Leave (Days per FTE)"
                                                    , "Workforce (HC)"
                                                    , "Workforce (Paid FTE)"
                                                    , "Workforce Utilisation (% of Paid FTE/HC)"
                                                    , "Separation Rate (%)"
                                                    , "Diversity (%)"
                                                    , "Average Age (Years)"
                                                    , "Average Tenure (Years)"
                                                    , "Average Female Salary (% of Average Male Salary)")
                                     , selected = "Unplanned Leave (Days per FTE)"),
                         
                         # Leave
                         conditionalPanel(condition = "input.sel_hrTS_2 == 'Leave (Days per FTE)'",
                                          radioButtons("sel_leaveType_2"
                                                       , "Select Leave Type:"
                                                       , choices = c("Unplanned Leave"
                                                                     , "Planned Leave"
                                                                     , "Total Leave")
                                                       , selected = "Unplanned Leave")),
                         
                         # Workforce Headcount
                         conditionalPanel(condition = "input.sel_hrTS_2 == 'Workforce (HC)'",
                                          radioButtons("sel_hcType_2"
                                                       , "Select Employment Type:"
                                                       , choices = c("Ongoing", "Non-Ongoing"
                                                                     , "Casual", "Total")
                                                       , selected = "Ongoing")),
                         
                         # Workforce Headcount - By Site, Ongoing employees
                         conditionalPanel(condition = "input.sel_hrTS_2 == 'Workforce (HC)' &&
                                          input.sel_hcType_2 == 'Ongoing'",
                                          selectInput("sel_hcSite_2"
                                                      , "Select Site:"
                                                      , choices  = c("All sites"
                                                                     , "Adelaide"
                                                                     , "Albury"
                                                                     , "Alice Springs"
                                                                     , "Brisbane"
                                                                     , "Burnie"
                                                                     , "Box Hill"
                                                                     , "Canberra"
                                                                     , "Chermside"
                                                                     , "Dandenong"
                                                                     , "Darwin"
                                                                     , "Gold Coast"
                                                                     , "Geelong"
                                                                     , "Hobart"
                                                                     , "Melbourne"
                                                                     , "Moonee Ponds"
                                                                     , "Maroochydore"
                                                                     , "Newcastle"
                                                                     , "Parramatta"
                                                                     , "Penrith"
                                                                     , "Perth"
                                                                     , "Sydney"
                                                                     , "Townsville")
                                                      , selected = "All sites")),
                         
                         # Paid FTE
                         conditionalPanel(condition = "input.sel_hrTS_2 == 'Workforce (Paid FTE)' || 
                                      input.sel_hrTS_2 == 'Workforce Utilisation (% of Paid FTE/HC)'",
                                          radioButtons("sel_employType_2"
                                                       , "Select Employment Type:"
                                                       , choices = c("Ongoing", "Non-Ongoing"
                                                                     , "Casual", "Total")
                                                       , selected = "Ongoing")),
                         
                         # Separation Rate
                         conditionalPanel(condition = "input.sel_hrTS_2 == 'Separation Rate (%)'",
                                          radioButtons("sel_sepType_2"
                                                       , "Select Separation Type:"
                                                       , choices = c("Overall Ongoing"
                                                                     , "Natural Attrition"
                                                                     , "Redundancy")
                                                       , selected = "Overall Ongoing")),
                         
                         # Tenure
                         conditionalPanel(condition = 
                                            "input.sel_hrTS_2 == 'Average Tenure (Years)'",
                                          radioButtons("sel_agency_2"
                                                       , "Select Agency:"
                                                       , choices = c("ATO", "APS")
                                                       , selected = "ATO")),
                         
                         # Diversity        
                         conditionalPanel(condition = "input.sel_hrTS_2 == 'Diversity (%)'",
                                          radioButtons("sel_grp_2"
                                                       , "Select Group:"
                                                       , choices = 
                                                         c("Non-English Speaking Background"
                                                           , "Indigenous"
                                                           , "Disability")
                                                       , selected = 
                                                         "Non-English Speaking Background"),
                                          radioButtons("sel_employType2_2"
                                                       , "Select Employment Type:"
                                                       , choices = c("Ongoing", "Total")
                                                       , selected = "Ongoing")),
                         
                         # Add choice to display certain metrics as a count, or percentage of total 
                         conditionalPanel(condition = "input.sel_hrTS_2 == 'Leave (Days per FTE)' &&
                                      input.sel_leaveType_2 != 'Total Leave' ||
                                      input.sel_hrTS_2 == 'Workforce (HC)' &&
                                      input.sel_hcType_2 != 'Total' ||
                                      input.sel_hrTS_2 == 'Workforce (Paid FTE)' &&
                                      input.sel_employType_2 != 'Total' ||
                                      input.sel_hrTS_2 == 'Separation Rate (%)' &&
                                      input.sel_sepType_2 != 'Overall Ongoing' ||
                                      input.sel_hrTS_2 == 'Diversity (%)'",
                                          radioButtons("sel_calc_2"
                                                       , "Select Calculation Type:"
                                                       , choices = c("Count", "Percentage of Total")
                                                       , selected = "Count")),
                         
                         # Line to divide HR metric 2 from buttons
                         div(style = "border-bottom: 2px solid #9e9494"),
                         
                         br()
                         
                         ),
        
        # Slider input only appears if user wants to forecast
        conditionalPanel(condition = "input.sel_task == 'Forecast'",
                        sliderInput(inputId = "fcast_mnths"
                                      , label = "Choose number of months to forecast:"
                                      , min   = 1
                                      , max   = 12
                                      , step  = 1
                                      , value = 6)),
        
        downloadButton(outputId = 'downloadData'
                       , label  = 'Download Data'
                       , class  = 'btn-primary'),
        
        br(),
        br(),
        
        bookmarkButton(label = "Bookmark"),
        
        br(),
        br(),
        
        uiOutput(outputId = "dt"),
        
        conditionalPanel(condition = "input.sel_task == 'Forecast'"
                         , br()
                         , tags$a(href = link, text, target = "_blank")
                         )
        
      ),
      
      mainPanel(
        
        plotlyOutput(outputId = "forecastPlot"),
        br(),
        conditionalPanel(condition = "input.sel_task == 'Compare'"
                         , plotlyOutput("metric2Plot")
                         , br()
                         , div(style = "text-align: center; border: 1px solid #e3e3e3
                                        ; border-left: 6px solid #337ab7"
                               , uiOutput("correlationScore")
                               , uiOutput("correlationMessage")
                               , em(p("Caution: Correlation does not imply causation."))
                               )
                         ),
        br(),
        dataTableOutput(outputId = "tsTable"),
        
        # Hide error messages
        tags$style(type="text/css",
                   ".shiny-output-error { visibility: hidden; }",
                   ".shiny-output-error:before { visibility: hidden; }"
        )
        
      )
    
    )
  )
})