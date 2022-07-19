#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  table.data <- reactive({
    
    inFile <- input$fileinput1

    
    if (is.null(inFile))
      return(NULL)
    df <- read.csv(inFile$datapath)
    return( df)
  
  })
  
  image.data <- reactive({
    inImage <- input$image
    
    
    if (is.null(inImage))
      return(NULL)
    img <- inImage$datapath
    return(img)
  })
  
  output$contents <- renderTable({
    
    if(is.null(input$checkbox)){
      table.data()
    } else{
      df <- table.data()
      
    }
    
  })
  

  
output$image2 <- renderImage({
  
    if(is.null(input$image)){
      return(list(src=""))
    }
  else {
    #if(is.null(data())){
      
      return(list(
        src = image.data(),
        contentType = "image/png",
        alt = "wedding_card", width = "400px"
        
      )
      )
      
  #   }else {
  #   return(list(
  #     src = image.data(),
  #     contentType = "image/png",
  #     alt = "wedding_card", width = "400px"
  # 
  #   ))
  # }
}

}, deleteFile = FALSE)



updated_img <- reactive({
  
  # outfile <-  image_read("qrplot.png") %>% image_rotate(180) %>%
  #   image_crop(geometry_area(dim(qr)[1], dim(qr)[2], 50, 50)) %>% 
  #   image_rotate( 180)
  # image_write(outfile, "temp.png")
  temp_file <- tempfile(fileext = ".png")
  ####
  qr <-  image_read("qrplot.png") %>% image_rotate(180) %>%
    image_crop(geometry_area(dim(qr)[1], dim(qr)[2], 50, 50)) %>% 
    image_rotate( 180)
  qr2 <- qr%>% image_scale(70+70) %>% image_border("white", "5x5")
  
  img2<-image_read(image.data())
  df <- table.data()
  i=1
  df <- df[i,1]
  img2 <- image_annotate(img2, as.character(df), size = 30, color = "black",
                         location = "+260+360", font = "Old English Text MT")
  
  img3 <- image_composite(img2, qr2, offset = "+400+1020")
  image_write(img3, temp_file)
  temp_file
  #}
  
  
  
 
})


 observeEvent(input$click1, {
  
  output$image2 <-renderImage({

   temp_file <- updated_img()
    
   
    
    ####
    
    list(src = temp_file,
         width = "400px",
         
         alt = "This is alternate text")
  }, deleteFile = F)
  
})

# output$image3 <- renderImage({
#   outfile <-  image_read("qrplot.png") %>% image_rotate(180) %>%
#     image_crop(geometry_area(dim(qr)[1], dim(qr)[2], 50, 50)) %>% 
#     image_rotate( 180)
#   image_write(outfile, "temp.png")
#   
#   list(src = "temp.png",
#                  width = 400,
#                  height = 400,
#                  alt = "This is alternate text")
#           }, deleteFile = T)
  
output$downloadImage <- downloadHandler(
  filename = "Modified_image.zip",
  
  content = function(file) {
    
    # Set temporary working directory
    #owd <- setwd( tempdir())
    #on.exit( setwd( owd))
    tempfile <- list()
    ## copy the file from the updated image location to the final download location
    df <- table.data()
    for (i in 1:dim(df)[1]){
      #tempfile <- tempfile(pattern=paste0("update_",i), fileext="png")
      tempfile[[i]] <- paste0("update_",i,".png")
    
    }
    zip( file, as.vector(unlist(tempfile)))
    file.remove("update_1.png")
   # file.copy(tempfile, paste0(file))
  }
)
 
 
#  output$downloadImage <- downloadHandler(
#    filename = "Modified_image.png",
#    contentType = "image/png",
#    content = function(file) {
#      ## copy the file from the updated image location to the final download location
# print(file)
#        file.copy(updated_img(), paste0(file))
#      
#    }
#) 

observeEvent(input$download,{
  
  
  
  
  
  ####
  qr <-  image_read("qrplot.png") %>% image_rotate(180) %>%
    image_crop(geometry_area(dim(qr)[1], dim(qr)[2], 50, 50)) %>% 
    image_rotate( 180)
  qr2 <- qr%>% image_scale(70+70) %>% image_border("white", "5x5")
  
  
  df <- table.data()
  tempfile <- "update_"
for (i in 1:dim(df)[1]){
#  tempfile <- tempfile(pattern=paste0("update_",i), fileext="png")
  
  df2 <- df[i,1]
  img2<-image_read(image.data())
  img2 <- image_annotate(img2, as.character(df2), size = 30, color = "black",
                         location = "+260+360", font = "Old English Text MT")
  
  img3 <- image_composite(img2, qr2, offset = "+400+1020")
  image_write(img3, paste0(tempfile, i, ".png"))

}
  

})



})
