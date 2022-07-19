#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Easy wedding card creator"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          fileInput(inputId = "fileinput1", label = "insert csv file with names here"),
          fileInput(inputId = "image", label = "insert wedding card image"),
          actionButton(inputId = "click1", label = "add test overlay"),
          actionButton(inputId = "download", label = "create all images"),
          downloadButton('downloadImage', 'Download zip file')
          
        ),

        # Show a plot of the generated distribution
        mainPanel(
          tableOutput("contents"),
          imageOutput("image2"),
          imageOutput("image3")
          
        )
    )
))
