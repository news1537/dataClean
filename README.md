dataClean
=========

Getting and Cleaning Data


- how I processed the data
- what assumptions I made
- why I did things a certain way
- who and where did I obtain original data

Project Goals

## Step #1  Merges the training and the test sets to create one data set.
## Step #2 Extracts only the measurements on the mean and standard deviation for each measurement. 
## Step #3  Uses descriptive activity names to name the activities in the data set
## Step #4  Appropriately labels the data set with descriptive variable names. 
## step #5  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 



##  DOWNLOAD PROJECT DATASET AND UNZIP

dsTemp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = dsTemp, method = "curl")
unzip(dsTemp, exdir = "./data")

## READ IN TEST DATA SET

subject_test <- read.csv(file ="/Users/user/R/cleanClassProject/data/dataSet/test/subject_test.txt" , header = FALSE, sep ="")
X_test <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/test/X_test.txt" , header = FALSE, sep ="")
Y_test <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/test/Y_test.txt" , header = FALSE, sep ="")

## READ IN TRAIN DATA SET

subject_train <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/train/subject_train.txt" , header = FALSE, sep ="")

X_train <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/train/X_train.txt" , header = FALSE, sep ="")

Y_train <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/train/Y_train.txt" , header = FALSE, sep ="")

## READ IN FEATURES.TXT DATA COLUMN NAMES

features <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/features.txt" , header = FALSE, sep ="")


## COMBINE X_TEST AND X_TRAIN DATA - THIS SATISFIES PART 1

TestTrainTemp <- rbind(X_test, X_train)

## ADD DESCRIPTIVE COLUMN FEATURE NAMES TO TESTTRAINTEMP - PART OF STEP 3

features$V2 <- as.character(features$V2)
colnames <- features[,2]
names(TestTrainTemp) <- colnames

##  COMBINE AND RENAME SUBJECT COLNAMES

## COMBINE SUBJECT TEST/TRAIN DATA AND ADD DESCRIPTIVE COLUMN NAME
## PART OF STEP 3

subjectTemp <- rbind(subject_test,subject_train)
colnames(subjectTemp)[1] = "subject"


## ADD SUBJECT COLUMN TO X_TEST AND X_TRAIN

TestTrainSubTemp <- cbind(TestTrainTemp, subjectTemp)

## COMBINE Y-ACTIVITY DATASETS

ActivityTemp <- rbind(Y_test,Y_train)

##  ADD ACTIVITY COLUMN AND DESCRIPTIVE COLUMN NAME  -Part of Step 3

TestTrainSubActTemp <- cbind(TestTrainSubTemp, ActivityTemp)
colnames(TestTrainSubActTemp)[563] = "activity"
                   

## ADDING DESCRIPTIVE NAMES TO ACTIVITY DATA - SATIFIES PART 4

TestTrainSubActTemp$activity <- sub("1","walking",TestTrainSubActTemp$activity)
TestTrainSubActTemp$activity <- sub("2","walking_upstairs",TestTrainSubActTemp$activity)
TestTrainSubActTemp$activity <- sub("3","walking_downstairs",TestTrainSubActTemp$activity)
TestTrainSubActTemp$activity <- sub("4","sitting",TestTrainSubActTemp$activity)
TestTrainSubActTemp$activity <- sub("5","standing",TestTrainSubActTemp$activity)
TestTrainSubActTemp$activity <- sub("6","laying",TestTrainSubActTemp$activity)

## FIND COLUMNS CONTAINING MEAN() AND STD() - THIS SATIFIES STEP 2 OF THE PROJECT

XY_mean <- TestTrainSubActTemp[, grep('mean()', colnames(TestTrainSubActTemp))]
XY_std <- TestTrainSubActTemp[, grep('std()', colnames(TestTrainSubActTemp))] 

## FIND COLUMNS CONTAINING SUBJECT AND ACTIVITY FOR COLUMN REARRANGEMENT

XY_sub <- TestTrainSubActTemp[, grep('subject', colnames(TestTrainSubActTemp))] 
XY_activity <- TestTrainSubActTemp[, grep('activity', colnames(TestTrainSubActTemp))] 


## REAARANGE COLUMN ORDER AND FIX COLUMN NAMES

XY_DataSetTemp <- cbind(TestTrainSubActTemp$subject, TestTrainSubActTemp$activity, XY_mean, XY_std)
colnames(XY_DataSetTemp)[1] = "subject"
colnames(XY_DataSetTemp)[2] = "activity"

## STARTING THE COLUMN NAME R SYNTAX CLEAN-UP - PART OF STEP 4

cnames <- names(XYDataSetTemp2)

## REMOVES ()

cnames <- gsub(\\"(\\)","",cnames)

## CHANGES '-' TO '_'
cnames  <- sub('-','_',cnames)

## REPLACES COLUMN NAMES (COLNAMES) WITH CORRECTED NAMES (CNAMES)

colnames(XYDataSetTemp2) <- cnames

## THIS SATISFIES PART #5

ddplySubAct <- ddply(XYDataSetTemp2, .(subject, activity), numcolwise(mean))

## CHANGING NAME FOR GITHUB UPLOAD

TidyDataSet2 <-  ddplySubAct 
