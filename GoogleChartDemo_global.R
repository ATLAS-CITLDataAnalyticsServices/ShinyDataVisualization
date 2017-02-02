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
#   install.packages("stringr")
#   install.packages('plyr')

library(stringr)

setwd("~/Dropbox/RA_CITL/WinterProject/clickStream01")
NewData <- read.csv("NewData.csv")
NewData2 <- NewData[!is.na(NewData$timecode),]
NewData2$video_name <- str_trim(NewData2$video_name, side = "both")

attach(NewData2)

KeyForNewData2 = cbind(aggregate(key=="download_subtitle", by=list(NewData2$illinois_user_id, NewData2$video_name), sum),
                       aggregate(key=="end", by=list(NewData2$illinois_user_id, NewData2$video_name), sum)[,3],
                       aggregate(key=="heartbeat", by=list(NewData2$illinois_user_id, NewData2$video_name), sum)[,3],
                       aggregate(key=="pause", by=list(NewData2$illinois_user_id, NewData2$video_name), sum)[,3],
                       aggregate(key=="play", by=list(NewData2$illinois_user_id, NewData2$video_name), sum)[,3],
                       aggregate(key=="playback_rate_change", by=list(NewData2$illinois_user_id, NewData2$video_name), sum)[,3],
                       aggregate(key=="seek", by=list(NewData2$illinois_user_id, NewData2$video_name), sum)[,3],
                       aggregate(key=="start", by=list(NewData2$illinois_user_id, NewData2$video_name), sum)[,3],
                       aggregate(key=="subtitle_change", by=list(NewData2$illinois_user_id, NewData2$video_name), sum)[,3],
                       aggregate(key=="volume_change", by=list(NewData2$illinois_user_id, NewData2$video_name), sum)[,3],
                       aggregate(key=="wait", by=list(NewData2$illinois_user_id, NewData2$video_name), sum)[,3])

names(KeyForNewData2) = c("UserID","Video", "Delete", "end", "heartbeat","pause","play","playback_rate_change","seek","start",
                             "subtitle_change","volume_change","wait")
detach(NewData2)

KeyForNewData2 = KeyForNewData2[,-3]

KeyForNewData2$Secs = KeyForNewData2$heartbeat * 5

###################################################

## select 12 videos for the example
## and transform the format of the data

# select 12 videos
video.list <- unique(KeyForNewData2$Video)[9:20]

# select observations from the 12 videos
KeyForNewData2.12 <- KeyForNewData2[sapply(KeyForNewData2$Video,function(x) any(video.list==x)),]

# transform the data into datasets for each second:

attach(KeyForNewData2.12)

KeyForNewData2.12 <- KeyForNewData2.12[order(Secs),]
secs.list <- sort(unique(Secs))

transformData <- function(x) {
  click <- as.vector(t(data.matrix(x[,c(3,5:12)])))
  data <- data.frame(user=rep(x$UserID,each=9),
                     #status=rep(c("end","pause","play","playback_rate_change","seek","start",
                     #            "subtitle_change","volume_change","wait"),length(x$Video)),
                     status=rep(1:9,length(x$Video)),
                     click,
                     video=rep(x$Video,each=9))
  data.big <- data.frame(video=video.list)
  data <- merge(data,data.big,by="video",all=TRUE)
  data[,5] <- data[,1]
  data <- data[,2:5]
  data[is.na(data)] <- 0
  names(data) <- c("user","status","click","video")
  return(data)
}

data.list=list()
for(i in 1:length(secs.list)) {
  data.list[[i]] <- KeyForNewData2.12[Secs==secs.list[i],]
  data.list[[i]] <- transformData(data.list[[i]])
  data.list[[i]] <- data.list[[i]][order(as.character(data.list[[i]]$video)),]
}

names(data.list) <- as.character(secs.list)

detach(KeyForNewData2.12)

### Overview of the datasets and variables used in this script:

#names(NewData2)
#[1] "X"                "illinois_user_id" "key"              "timecode"         "video_name" 

#unique(NewData2$key)
#[1] heartbeat            seek                 play                 wait                 pause               
#[6] start                download_subtitle    end                  volume_change        playback_rate_change
#[11] subtitle_change      download_video      
