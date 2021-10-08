# load library

library(dplyr)

# read file

datatrainX <-read.csv("UCI HAR Dataset/train/X_train.txt",sep="",header = F)
datatrainY <-read.csv("UCI HAR Dataset/train/Y_train.txt",sep="",header = F)
subjecttrain <- read.csv("UCI HAR Dataset/train/subject_train.txt",sep="",header = F)
datatestX <-read.csv("UCI HAR Dataset/test/X_test.txt",sep="",header = F)
datatestY <-read.csv("UCI HAR Dataset/test/Y_test.txt",sep="",header = F)
subjecttest <- read.csv("UCI HAR Dataset/test/subject_test.txt",sep="",header = F)

# merge train and test

dataX <-rbind(datatrainX,datatestX)
dataY <-rbind(datatrainY,datatestY)
subject <-rbind(subjecttrain,subjecttest)

#labels the data set with descriptive variable names

features <- read.csv("UCI HAR Dataset/features.txt",sep="",header = F) 
dataX <- setNames(dataX,make.names(features$V2,unique=TRUE, allow_ = TRUE))
dataY <- setNames(dataY,"activity")
subject <-setNames(subject,"subject")

# Uses descriptive activity names to name the activities in the data set

activitylabels<- read.csv("UCI HAR Dataset/activity_labels.txt",sep="",header = F) 
dataY[,1] <- data.frame(activitylabels[dataY$activity,2])


# Merges the training and the test sets to create one data set.

mydata <- cbind(dataY,subject,dataX)

# Extracts only the measurements on the mean and standard deviation for each measurement.

dmean <- mydata %>% group_by(activity) %>% summarise(across(everything(), mean)) %>% print
dsd <- mydata %>% group_by(activity) %>% summarise(across(everything(), sd)) %>% print

# creates a second, independent tidy data set with the average of each variable
# for each activity and each subject

mydata2 <- mydata %>% group_by(activity,subject) %>% summarise(across(everything(), mean),.groups='keep')

write.csv(mydata,"mydata.tidy.csv")
write.csv(mydata2,"mydata2.tidy.csv")