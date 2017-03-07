shinyUI(function(request){
  
  fluidPage(
    
    # Define link and text for forecasting explanation
    link <- "https://en.wikipedia.org/wiki/Exponential_smoothing#Triple_exponential_smoothing",
    text <- "Information on Holt-Winters forecasting",
      
    # CSS style for navbar html - added padding-top:50px; to .h2,h2 to accommodate navbar
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.css")),
    
    # Navbar HTML
    includeHTML("www/navbar.html"),
      
    titlePanel("HR Time Series Forecasting"),
    
    sidebarLayout(
      
      sidebarPanel(
        
        selectInput(inputId    = "sel_hrTS"
                    , label    = "Choose HR metric to forecast:"
                    , choices  = c("Leave (Days per FTE)"
                                   , "Workforce (HC)"
                                   , "Workforce (Paid FTE)"
                                   , "Separation Rate (%)"
                                   , "Average Age (Years)"
                                   , "Average Tenure (Years)"
                                   , "Diversity (%)"
                                   , "Average Female Salary (% of Average Male Salary)")
                    , selected = "Unplanned Leave (Days per FTE)"),
        
        # Leave
        conditionalPanel(condition = "input.sel_hrTS == 'Leave (Days per FTE)'",
                         radioButtons("sel_leaveType"
                                      , "Select Leave Type:"
                                      , choices = c("Unplanned Leave", "Planned Leave")
                                      , selected = "Unplanned Leave")),
        
        # Workforce HeaCount and Paid FTE
        conditionalPanel(condition = "input.sel_hrTS == 'Workforce (HC)' || input.sel_hrTS == 'Workforce (Paid FTE)'",
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
        
        br(),
        
        sliderInput(inputId = "fcast_mnths"
                    , label = "Choose number of months to forecast:"
                    , min   = 1
                    , max   = 12
                    , step  = 1
                    , value = 6),
        
        tags$a(href = link, text, target = "_blank")
        
      ),
      
      mainPanel(
        
        plotlyOutput(outputId = "forecastPlot"),
        br(),
        downloadButton(outputId = 'downloadData'
                       , label  = 'Download Data'
                       , class  = 'btn-primary'),
        br(),
        br(),
        bookmarkButton(class = 'btn-primary'
                       , label = "Bookmark"),
        br(),
        br(),
        dataTableOutput(outputId = "tsTable")
        
      )
    
    )
  )
})