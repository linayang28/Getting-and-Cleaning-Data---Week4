
## 10/24/2017
## Peer-graded Assignment: Getting and Cleaning Data Course Project
## Course : Getting and Cleaning Data
## Week4 project

## You should create one R script called run_analysis.R that does the following.
## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each 
## measurement.
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names.
## 5.From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

## Pre-requisite
## URL for file is "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## which has been downloaded into local drive already and getwd has been set prior


## Read subject files
  subjectTrain    <-read.table("./train/subject_train.txt", header=FALSE)
  subjectTest     <-read.table("./test/subject_test.txt", header=FALSE)
## Read y_train/y_test files
  labelTrain      <- read.table("./train/y_train.txt",header=FALSE)
  labelTest       <- read.table("./test/y_test.txt",header=FALSE)
## read Data files : x_train/x_test
  dataTrain       <- read.table("./train/X_train.txt",header=FALSE)
  dataTest        <- read.table("./test/X_test.txt",header=FALSE)



## 1.Merges the training and the test sets to create one data set.
  alldataSubject  <-rbind(subjectTrain,subjectTest)
  names(alldataSubject)<-c("subject")
  
  alldataActivity <-rbind(labelTrain,labelTest)
  names(alldataActivity)<- c("activity")

  allData <-rbind(dataTrain,dataTest)
  dataFeaturesNames  <- read.table("./features.txt",header=FALSE)
  names(allData)<- dataFeaturesNames$V2

  dataCombine <- cbind(alldataSubject, alldataActivity)
  dataTable   <- cbind(allData, dataCombine)
  
  
## 2.Extracts only the measurements on the mean and standard deviation for each 
## measurement.
  subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
  selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
  dataTable<-subset(dataTable,select=selectedNames)
  
  
## 3.Uses descriptive activity names to name the activities in the data set  
    activityLabels   <-read.table("./activity_labels.txt",header=FALSE)

    
## 4. Appropriately labels the data set with descriptive variable names.
  
  names(dataTable) <- gsub("Acc", "Acceleration", names(dataTable))
  names(dataTable) <- gsub("^t", "Time", names(dataTable))
  names(dataTable) <- gsub("^f", "Frequency", names(dataTable))
  names(dataTable) <- gsub("BodyBody", "Body", names(dataTable))
  names(dataTable) <- gsub("mean", "Mean", names(dataTable))
  names(dataTable) <- gsub("std", "SD", names(dataTable))
  names(dataTable) <- gsub("Mag", "Magnitude", names(dataTable))
  names(dataTable) <- gsub("Gyro", "Gyroscope", names(dataTable))
  
  ## 5.From the data set in step 4, creates a second, independent tidy data set 
  ## with the average of each variable for each activity and each subject.
  library(plyr);
  dataTable2<-aggregate(. ~subject + activity, dataTable, mean)
  dataTable2<-dataTable2[order(dataTable2$subject,dataTable2$activity),]
  write.table(dataTable2, "newTidyData.txt", row.name=FALSE)
  
  
  
  