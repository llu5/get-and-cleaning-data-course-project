## Getting and Cleaning Data Course Project
## The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
## The goal is to prepare tidy data that can be used for later analysis. 
## You will be graded by your peers on a series of yes/no questions related to the project. 
## You will be required to submit: 
##         1) a tidy data set as described below,
##         2) a link to a Github repository with your script for performing the analysis, and
##         3) a code book that describes the variables, the data, 
##            and any transformations or work that you performed to clean up the data 
##            called CodeBook.md. 
## You should also include a README.md in the repo with your scripts. 
## This repo explains how all of the scripts work and how they are connected.
## You should create one R script called run_analysis.R that does the following.

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.

## use dplyr read.table
library(dplyr)

## create folder data and download file by using downloader package
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
require (downloader)

download(fileUrl, "data/HARdataset.zip", mode = "wb") 

## unzip the HARdataset.zip file to create a folder named "UCI HAR Dataset"
unzip(zipfile="./data/HARdataset.zip",exdir="./data")

## get the list of files
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

## The files that will be used to load data are listed as follows:

## test/subject_test.txt
## test/X_test.txt
## test/y_test.txt
## train/subject_train.txt
## train/X_train.txt
## train/y_train.txt

        
##        Values of Varible Activity consist of data from “Y_train.txt” and “Y_test.txt”
##        values of Varible Subject consist of data from “subject_train.txt” and subject_test.txt"
##        Values of Varibles Features consist of data from “X_train.txt” and “X_test.txt”
##        Names of Varibles Features come from “features.txt”
##        levels of Varible Activity come from “activity_labels.txt”
##         So we will use Activity, Subject and Features as part of descriptive variable names for data in data frame.
## 2.Read data from the files into the variables

## 3. Read the activity files into variables

dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

## 4. REad the feature files into variables
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)


### 5. Read the subject files
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

## 6. Merges the training and the test sets to create one data set
## 7. Union  the data tables by rows by using rbind
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

## 8. Add column names of subject, activity and feature variable to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

## 9. Merge all columns of three data frames of same number of rows into one data frame 
dataMergeSubjectActivity <- cbind(dataSubject, dataActivity)
completeData <- cbind(dataFeatures, dataMergeSubjectActivity)

## 10. Extracts only the measurements on the mean and standard deviation for each measurement
## create a subset of Features by measurements on the mean and standard deviation

## take subset of feature names with ...Mean), mean() and std
subdataFeaturesNames<-dataFeaturesNames$V2[grep("Mean\\)$|mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

## create a subset data frame Data from complete data by seleted feature columns, subject and activity
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
mean_std_data<-subset(completeData,select=selectedNames)


## Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

## get charactor of activity code from the mean() and std() subset data
mean_std_data$activity <- as.character(mean_std_data$activity)
mean_std_data$activity[mean_std_data$activity == 1] <- "Walking"
mean_std_data$activity[mean_std_data$activity == 2] <- "Walking Upstairs"
mean_std_data$activity[mean_std_data$activity == 3] <- "Walking Downstairs"
mean_std_data$activity[mean_std_data$activity == 4] <- "Sitting"
mean_std_data$activity[mean_std_data$activity == 5] <- "Standing"
mean_std_data$activity[mean_std_data$activity == 6] <- "Laying"
mean_std_data$activity <- as.factor(mean_std_data$activity)

## Appropriately labels the data set with descriptive variable names.
names(mean_std_data) <- gsub("Acc", "Accelerator", names(mean_std_data))
names(mean_std_data) <- gsub("Mag", "Magnitude", names(mean_std_data))
names(mean_std_data) <- gsub("Gyro", "Gyroscope", names(mean_std_data))
names(mean_std_data) <- gsub("^t", "time", names(mean_std_data))
names(mean_std_data) <- gsub("^f", "frequency", names(mean_std_data))

## a second, independent tidy data set will be created with the average of each variable 
## for each activity and each subject based on the data set in step 4.
library(plyr)
tidy_data <- aggregate(. ~subject + activity, mean_std_data, mean)
ordered_tidy_data <- tidy_data[order(tidy_data$subject,tidy_data$activity),]
write.table(ordered_tidy_data, file = "ordered_tidydata.csv",row.name=FALSE)



