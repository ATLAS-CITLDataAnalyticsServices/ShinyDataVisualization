##############################################
# CITL Analytics Winter Project 2016-2017    # 
# Liqun Zeng                                 #
#                                            #
# Data Visualization:                        #
#              Shiny Google Charts           #
#                                            #
# Using Coursera Practice Click Stream Data  #
##############################################


# Install: 
#   install.packages("dplyr")

library(dplyr)

shinyServer(function(input, output, session) {
  
  # Provide explicit colors for statuses, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  # http://andrewgelman.com/2014/09/11/mysterious-shiny-things/
  # 12 colors in total.
  defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", 
                     "#dd4477", "#FFFF00", "#CD853F", "#191970", "#A2B5CD", "#FF82AB")
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(KeyForNewData2.12$Video)
  )
  
  timeData <- reactive({
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.
    secIndex <- findInterval(input$secs,secs.list,rightmost.closed=TRUE)
    df <- data.list[[as.character(secs.list[secIndex])]]
  })
  
  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(timeData()),
      options = list(
        title = sprintf(
          "Duration vs. Video Status, %s",
          input$secs),
        series = series
      )
    )
  })
})
