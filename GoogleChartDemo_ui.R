##############################################
# CITL Analytics Winter Project 2016-2017    # 
# Liqun Zeng                                 #
#                                            #
# Data Visualization:                        #
#              Shiny Google Charts           #
#                                            #
# Using Coursera Practice Click Stream Data  #
##############################################

# More info:
#   https://github.com/jcheng5/googleCharts

# Install:
#   install.packages("devtools")
#   devtools::install_github("jcheng5/googleCharts")

library(googleCharts)

# Use global max/min for axes so the view window stays
# constant as the user moves between years
xlim <- list(
  min = 0,
  max = 10
)
ylim <- list(
  min = 0,
  max = 30
)

shinyUI(fluidPage(
  # This line loads the Google Charts JS library
  googleChartsInit(),
  
  # Use the Google webfont "Source Sans Pro"
  tags$link(
    href=paste0("http://fonts.googleapis.com/css?",
                "family=Source+Sans+Pro:300,600,300italic"),
    rel="stylesheet", type="text/css"),
  tags$style(type="text/css",
             "body {font-family: 'Source Sans Pro'}"
  ),
  
  h2("Coursera Click Stream Dynamics Demo"),
  
  googleBubbleChart("chart",
                    width="100%", height = "475px",
                    # Set the default options for this chart; they can be
                    # overridden in server.R on a per-update basis. See
                    # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
                    # for option documentation.
                    options = list(
                      fontName = "Source Sans Pro",
                      fontSize = 13,
                      # Set axis labels and ranges
                      hAxis = list(
                        title = "Status   1: end;   2: pause;   3: play;   4: playback rate change;   5: seek;   6: start;
                           7: subtitle change;    8: volume change;    9: wait",
                        viewWindow = xlim
                      ),
                      vAxis = list(
                        title = "Number of Clicks",
                        viewWindow = ylim
                      ),
                      # The default padding is a little too spaced out
                      chartArea = list(
                        top = 50, left = 75,
                        height = "75%", width = "75%"
                      ),
                      # Allow pan/zoom
                      explorer = list(),
                      # Set bubble visual props
                      bubble = list(
                        opacity = 0.4, stroke = "none",
                        # Hide bubble label
                        textStyle = list(
                          color = "none"
                        )
                      ),
                      # Set fonts
                      titleTextStyle = list(
                        fontSize = 16
                      ),
                      tooltip = list(
                        textStyle = list(
                          fontSize = 12
                        )
                      )
                    )
  ),
  fluidRow(
    shiny::column(4, offset = 4,
                  sliderInput("secs", "Duration of Watching (seconds)",
                              min = min(KeyForNewData2.12$Secs), max = max(KeyForNewData2.12$Secs),
                              value = min(KeyForNewData2.12$Secs), animate = TRUE)
    )
  )
))
