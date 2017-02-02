##############################################
# CITL Analytics Winter Project 2016-2017    # 
# Liqun Zeng                                 #
#                                            #
# Data Visualization:                        #
#              Shiny Interactive Plot        #
#                                            #
# Using Coursera Practice Click Stream Data  #
##############################################


# Install:
#   install.packages("Cairo")
#   install.packages("ggplot2")

library(ggplot2)
library(Cairo)   # For nicer ggplot2 output when deployed on Linux


################### Get the Data Ready ###################

setwd("~/Dropbox/RA_CITL/WinterProject/clickStream02")

KeyForNewData2 <- read.csv("KeyForNewData2.csv")

## select 12 videos for the example
## and transform the format of the data

# select 12 videos
video.list <- unique(KeyForNewData2$Video)[9:20]

# select observations from the 12 videos
KeyForNewData2.12 <- KeyForNewData2[sapply(KeyForNewData2$Video,function(x) any(video.list==x)),]

# transform the data

transformData3 <- function(x) {
  click <- as.vector(t(data.matrix(x[,c(3,5:12)])))
  data <- data.frame(video=rep(x$Video,each=9),
                     status=as.factor(rep(c("end","pause","play","playback_rate_change","seek","start",
                                            "subtitle_change","volume_change","wait"),length(x$Video))),
                     click,
                     secs=rep(x$Secs,each=9))
                    
}

data <- transformData3(KeyForNewData2.12)

#data <- data[data$click < 500, ]
data <- data[data$click < 80, ]

################### Data Prepration Done ###################



ui <- fluidPage(
  fluidRow(
    column(
           plotOutput("plot1", height = 300,
                      click = clickOpts(
                        id = "plot_click"
                      ),
                      brush = brushOpts(
                        id = "plot1_brush"
                      )
           )
    )
  ),
  fluidRow(
    column(
           h4("Points near click"),
           verbatimTextOutput("click_info")
    ),
    column(
           h4("Brushed points"),
           verbatimTextOutput("brush_info")
    )
  )
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(data, aes(secs, click)) + geom_point()
  })
  
  output$click_info <- renderPrint({
    # Because it's a ggplot2, we don't need to supply xvar or yvar; if this
    # were a base graphics plot, we'd need those.
    nearPoints(data, input$plot1_click, addDist = TRUE)
  })
  
  output$brush_info <- renderPrint({
    brushedPoints(data, input$plot1_brush)
  })
}

shinyApp(ui, server)
