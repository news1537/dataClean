

## Step #1  Merges the training and the test sets to create one data set.
## Step #2 Extracts only the measurements on the mean and standard deviation for each measurement. 
## Step #3  Uses descriptive activity names to name the activities in the data set
## Step #4  Appropriately labels the data set with descriptive variable names. 
## step #5  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Download project dataset and unzip

dsTemp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = dsTemp, method = "curl")
unzip(dsTemp, exdir = "./data")

## Read in test data set

subject_test <- read.csv(file ="/Users/user/R/cleanClassProject/data/dataSet/test/subject_test.txt" , header = FALSE, sep ="")
X_test <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/test/X_test.txt" , header = FALSE, sep ="")
Y_test <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/test/Y_test.txt" , header = FALSE, sep ="")

## Read in train data set

subject_train <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/train/subject_train.txt" , header = FALSE, sep ="")
X_train <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/train/X_train.txt" , header = FALSE, sep ="")
Y_train <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/train/Y_train.txt" , header = FALSE, sep ="")

## Read in features.txt data column names
features <- read.csv(file = "/Users/user/R/cleanClassProject/data/dataSet/features.txt" , header = FALSE, sep ="")


## combine X_test and X_train data - THIS SATISFIES PART 1
TestTrainTemp <- rbind(X_test, X_train)

## Add descriptive column feature names to TestTrainTemp - 
features$V2 <- as.character(features$V2)
colnames <- features[,2]
names(TestTrainTemp) <- colnames

##  combine and Rename subject colnames

## combine subject test/train data and add decriptive column name
subjectTemp <- rbind(subject_test,subject_train)
colnames(subjectTemp)[1] = "subject"


## add subject column to X_test and X_train
TestTrainSubTemp <- cbind(TestTrainTemp, subjectTemp)

## combine Y-Activity datasets
ActivityTemp <- rbind(Y_test,Y_train)

##  Add Activity Column and descriptive column name
TestTrainSubActTemp <- cbind(TestTrainSubTemp, ActivityTemp)
colnames(TestTrainSubActTemp)[563] = "activity"
                   

## Adding descriptive names to activity data
TestTrainSubActTemp$activity <- sub("1","walking",TestTrainSubActTemp$activity)
TestTrainSubActTemp$activity <- sub("2","walking_upstairs",TestTrainSubActTemp$activity)
TestTrainSubActTemp$activity <- sub("3","walking_downstairs",TestTrainSubActTemp$activity)
TestTrainSubActTemp$activity <- sub("4","sitting",TestTrainSubActTemp$activity)
TestTrainSubActTemp$activity <- sub("5","standing",TestTrainSubActTemp$activity)
TestTrainSubActTemp$activity <- sub("6","laying",TestTrainSubActTemp$activity)

## Find columns containing mean() and std() - This satifies Step 2 of the project

XY_mean <- TestTrainSubActTemp[, grep('mean()', colnames(TestTrainSubActTemp))]
XY_std <- TestTrainSubActTemp[, grep('std()', colnames(TestTrainSubActTemp))] 

## Find columns containing subject and activity for column rearrangement

XY_sub <- TestTrainSubActTemp[, grep('subject', colnames(TestTrainSubActTemp))] 
XY_activity <- TestTrainSubActTemp[, grep('activity', colnames(TestTrainSubActTemp))] 


## Reaarange column order and fix column names
XY_DataSetTemp <- cbind(TestTrainSubActTemp$subject, TestTrainSubActTemp$activity, XY_mean, XY_std)
colnames(XY_DataSetTemp)[1] = "subject"
colnames(XY_DataSetTemp)[2] = "activity"

## starting the column name clean-up
cnames <- names(XYDataSetTemp2)

## Removes ()
cnames <- gsub(\\"(\\)","",cnames)
## Removes first t and f
cnames  <- sub('^f',"", cnames)
cnames <- sub('^t',"",cnames)
## changes '-' to '_'
cnames  <- sub('-','_',cnames)

## replaces column names (colnames) with corrected names (cnames)
colnames(XYDataSetTemp2) <- cnames

## This satisfies Part #5
> ddplySubAct <- ddply(XYDataSetTemp2, .(subject, activity), numcolwise(mean))

