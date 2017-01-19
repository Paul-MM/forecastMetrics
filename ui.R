shinyUI(
  fluidPage(
    
  # CSS style for navbar html - added padding-top:50px; to .h2,h2 to accommodate navbar
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.css")),
  
  # Navbar HTML
  includeHTML("www/navbar.html"),
    
  titlePanel("HR Time Series Forecasting"),
  
  sidebarLayout(
    sidebarPanel(selectInput("sel_hrTS", label = ("Choose HR metric to forecast:"),
                             choices = c("Unplanned Leave (Days per FTE)",
                                         "Planned Leave (Days per FTE)",
                                         "Ongoing Workforce (HC)",
                                         "Non-Ongoing Workforce (HC)",
                                         "Casual Workforce (HC)",
                                         "Total Employed Workforce (HC)",
                                         "Ongoing Workforce (Paid FTE)",
                                         "Non-Ongoing Workforce (Paid FTE)",
                                         "Casual Workforce (Paid FTE)",
                                         "Total Employed Workforce (Paid FTE)",
                                         "Overall Ongoing Separation Rate (%)",
                                         "Natural Attrition Separation Rate (%)",
                                         "Redundancy Separation Rate (%)",
                                         "Average Age (Years)",
                                         "Average ATO Tenure (Years)",
                                         "Average APS Tenure (Years)",
                                         "Diversity - Non-English Speaking Background (%)",
                                         "Diversity - Indigenous (%)",
                                         "Diversity - Disability (%)",
                                         "Average Female Salary (% of Average Male Salary)"),
                             selected = "Unplanned Leave (Days per FTE)")
                 , br()
                 , sliderInput("fcast_mnths", label = ("Choose number of months to forecast:"),
                               min = 1, max = 12, step = 1, value = 6)
    ),
    
    mainPanel(
      plotlyOutput('forecastPlot')
      , br()
      , downloadButton('downloadData', 'Download Data', class = 'btn-primary')
      , br(), br()
      , dataTableOutput(outputId="tsTable")
      
    )
   )
  )
)