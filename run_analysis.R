## Code to read and tidy the data
library(dplyr)

## Features are read
features <-read.csv("./features.txt",sep="", header=FALSE)

##Data is read and variables named
train<-read.csv("./train/X_train.txt",sep="", header=FALSE)
test<-read.csv("./test/X_test.txt",sep="", header=FALSE)
names(train)<-features[,2]
names(test)<-features[,2]

## An extra column is added to see if it's a test or a train data point
## and both dataframes are merged

train$sort<-"train"
test$sort<-"test"
rawdata <- rbind(train, test)

## Mean and std of measurements are extracted and dataframe is turned
## into a tibble
interest <- c(features[grepl("mean",features[,2])|grepl("std",features[,2]),2],
              "sort")
data <- as_tibble(rawdata[,interest])


