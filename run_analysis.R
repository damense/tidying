## Code to read and tidy the data
setwd("C:/Users/david/Desktop/R/tidying")
library(dplyr)

## Features are read
features <-read.csv("./features.txt",sep="", header=FALSE)

##Data is read and variables named
train<-read.csv("./X_train.txt",sep="", header=FALSE)
test<-read.csv("./X_test.txt",sep="", header=FALSE)
ytrain<-read.csv("./y_train.txt",sep="", header=FALSE)
ytest<-read.csv("./y_test.txt",sep="", header=FALSE)
subjecttrain<-read.csv("./subject_train.txt",sep="", header=FALSE)
subjecttest<-read.csv("./subject_test.txt",sep="", header=FALSE)
names(train)<-features[,2]
names(test)<-features[,2]

## An extra two columns are added to to reflect the subject and type of activity
## and both dataframes are merged


train$activity<-ytrain[,1]
train$subject <- subjecttrain[,1]
test$activity<-ytest[,1]
test$subject <- subjecttest[,1]
rawdata <- rbind(train, test)

## Mean and std of measurements are extracted and dataframe is turned
## into a tibble
interest <- c(features[grepl("mean\\(",features[,2])|grepl("std",features[,2]),2],
              "activity","subject")
data <- as_tibble(rawdata[,interest])

## Change the names to descriptive activity names to name the activities 
## in the data set and make them tidy
data$activity<-factor(data$activity, levels = c(1, 2, 3, 4, 5, 6), 
       labels = read.csv("./activity_labels.txt",
                         sep=" ", header=FALSE)[,2])
data$activity <- tolower(gsub("_","",data$activity))


## Appropriately label the data variables

goodnames<-gsub("\\(\\)","", interest)
goodnames<-gsub("-","", goodnames)
colnames(data)<-tolower(goodnames)

## Create a second dataset with tidy data  average of each variable 
## for each activity and each subject and save it
data2<-aggregate(. ~activity+subject, data=data, mean, na.rm=TRUE)
write.table(data2,file="submission.txt", row.name=FALSE)

