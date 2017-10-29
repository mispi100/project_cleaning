#setwd("project_cleaning")
rm(list = ls())
library(dplyr)
library(data.table)
library(reshape2)
####################################################################################
####################################################################################
### Read in feature names and labels!
####################################################################################
####################################################################################
### Read in feature names !
ad <- "UCI HAR Dataset/features.txt"
features <- read.table(ad)
features <- as.character(features[,2])
rm(ad)
### Find feature names with mean or std and clean names
features_select <- features[grepl("mean\\()|std\\()",features)]
features_select <- gsub("mean","Mean",features_select)
features_select <- gsub("std","Std",features_select)
features_select <- gsub("-","",features_select)
features_select <- gsub("\\()","",features_select)
features_nr <- grep("mean\\()|std\\()",features)
rm(features)
### Read activity labels
ad <- "UCI HAR Dataset/activity_labels.txt"
activity_labels <- read.table(ad)
activity_labels <- tolower(as.character(activity_labels[,2]))
####################################################################################
####################################################################################
# Read in training data set
####################################################################################
####################################################################################
ad <- "UCI HAR Dataset/train/X_train.txt"
train <- tbl_df(fread(ad, select = features_nr))
names(train) <- features_select
#### Read in training subject
ad <- "UCI HAR Dataset/train/subject_train.txt"
subject_train <- read.table(ad)
names(subject_train) <- "subject"
#### Read in activity & change values to activity labels
ad <- "UCI HAR Dataset/train/y_train.txt"
activity_train <- read.table(ad)
for (i in 1:6){
  activity_train[activity_train == i] <- activity_labels[i]
}
names(activity_train) <- "activity"
### Combine to one data frame
train <- cbind(subject_train, activity_train, train)
rm(activity_train, subject_train)
####################################################################################
####################################################################################
# Read in testing data set
####################################################################################
####################################################################################
ad <- "UCI HAR Dataset/test/X_test.txt"
test <- tbl_df(fread(ad, select = features_nr))
names(test) <- features_select
#### Read in testing subject
ad <- "UCI HAR Dataset/test/subject_test.txt"
subject_test <- read.table(ad)
names(subject_test) <- "subject"
#### Read in activity & change values to activity labels
ad <- "UCI HAR Dataset/test/y_test.txt"
activity_test <- read.table(ad)
for (i in 1:6){
  activity_test[activity_test == i] <- activity_labels[i]
}
names(activity_test) <- "activity"
### Combine to one data frame
test <- cbind(subject_test, activity_test, test)
rm(activity_test, subject_test)
####################################################################################
####################################################################################
# Clean Environment & Merging data sets 
####################################################################################
####################################################################################
rm(ad,i,activity_labels, features_nr, features_select)
#> dim(test)[1] 2947   68> dim(train)[1] 7352   68
data <- rbind(train,test)
rm(train,test)
####################################################################################
####################################################################################
# Create new tidy data set
####################################################################################
####################################################################################
data_melt <- melt(data, id=c("subject", "activity"))
tidy_data <- dcast(data_melt, subject+activity~variable, mean)
rm(data, data_melt)
write.table(tidy_data,file="tidy_data.txt",row.name=FALSE)
