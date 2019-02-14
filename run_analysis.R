# Script for course project "Getting an Cleaning Data"

library(readr)
library(dplyr)
library(stringr)

## 1. Merge the training and the test sets to create one data set
## The resulting dataset is in variables X,y

X_test <- read_table2("UCI HAR Dataset/test/X_test.txt", 
                      col_names = FALSE)
y_test <- read_csv("UCI HAR Dataset/test/y_test.txt", 
                   col_names = FALSE)
X_train <- read_table2("UCI HAR Dataset/train/X_train.txt", 
                      col_names = FALSE)
y_train <- read_csv("UCI HAR Dataset/train/y_train.txt", 
                   col_names = FALSE)
features <- as.vector(read_table2("UCI HAR Dataset/features.txt", 
                        col_names = FALSE, col_types = cols(`1` = col_skip(), 
                                                            X1 = col_skip())))
activity_labels <- read_table2("UCI HAR Dataset/activity_labels.txt", 
                               col_names = FALSE)

X <- rbind(X_test, X_train)
y <- rbind(y_test, y_train)

names(y) <- "activity_code"
names(X) <- features[[1]]
names(features) <- "name"
names(activity_labels) <- c("code", "activity")


## 2. Extract only the measurements on the mean and standard deviation 
## for each measurement
## The resulting dataset is in variable X_subset

features <- mutate(features, mean_std = str_detect(name,"(mean|std)\\(\\)"))

X_subset <- X[,features$mean_std]

## 3. Use descriptive activity names to name the activities in the data set
## The resulting dataset is in variable y_tidy

y_tidy <- left_join(y, activity_labels, by=c("activity_code" = "code") )
y_tidy <- as.data.frame(y_tidy$activity)
names(y_tidy) <- "activity"

## 4. Appropriately label the data set with descriptive variable names

##      This has been done above already

## 5. From the data set in step 4, create a second, independent tidy data set 
## with the average of each variable for each activity and each subject
## The resulting dataset is in variable X_means

X_means <- colMeans(X_subset)
X_means <- data.frame(X_means)
names(X_means) <- "mean"


