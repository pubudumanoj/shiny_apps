#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Easy grouping of your data"),
  fileInput(inputId = "fileinput1", label = "insert csv file here"),
  uiOutput("checkbox"),
  tableOutput("contents"),
  verbatimTextOutput("dynamic_value")
  
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  table.data <- reactive({
    
    inFile <- input$fileinput1
    
    if (is.null(inFile))
      return(NULL)
    df <- read.csv(inFile$datapath)
    return( df)
  })
  
  output$contents <- renderTable({

    if(is.null(input$checkbox)){
    table.data()
    } else{
    df <- table.data()
    df <- dplyr::group_by_at(df, as.character(input$checkbox)) %>% summarise(Count=n())
    }
    
  })
  output$checkbox <- renderUI({
    cols <- colnames(table.data())
    checkboxGroupInput("checkbox","Select Columns", choices = cols, )
  })
  
  output$dynamic_value <- renderPrint({
    as.character(input$checkbox)
  })
  

  
}

# Run the application 
shinyApp(ui = ui, server = server)



