# Codebook for course project "Getting an Cleaning Data"
This file explains step-by-step the procedure and the variables in the script run_analysis.R.
The steps 1-5 follow directly the instructions of the project - also found in the README.md under "Work Steps"

## Load necessary Libraries
    library(readr)    # reading files into R
    library(dplyr)    # manipulating dataframes
    library(stringr)  # manipulte strings

## 1. Merge the training and the test sets to create one data set
The necessary datasets X_test, y_test, X_train, y_train are read into R dataframes. features are the variable (column names for all X-data, activity labels are descriptive labels of 1-6 codes in y-Data.
The rbind command does the merging and finally, for tidiness, names are assigned to the dataframes
**The resulting dataset for this task is in variables X,y**

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
As features holds all variable names, by stringr::mutate we can indicate only those matching "mean" or "std".
We do tis by adding a logical column. We use this logical array then to subset X accordingly.
**The resulting dataset is in variable X_subset**

    features <- mutate(features, mean_std = str_detect(name,"(mean|std)\\(\\)"))
    
    X_subset <- X[,features$mean_std]

## 3. Use descriptive activity names to name the activities in the data set
We add a column of the descriptive labels to y by the left_join command and delete the original column.
**The resulting dataset is in variable y_tidy**

    y_tidy <- left_join(y, activity_labels, by=c("activity_code" = "code") )
    y_tidy <- as.data.frame(y_tidy$activity)
    names(y_tidy) <- "activity"

## 4. Appropriately label the data set with descriptive variable names

This step is here omitted since it has already been done under step 1 (when reading data into R)

## 5. From the data set in step 4, create a second, independent tidy data set 
## with the average of each variable for each activity and each subject
We calculate the means by colMeans and store the result into a dataframe.
**The resulting dataset is in variable X_means**

    X_means <- colMeans(X_subset)
    X_means <- data.frame(X_means)
    names(X_means) <- "mean"
    
## Write resulting datasets to files
    write.table(X, file = "X.txt", row.name=FALSE)
    write.table(y_tidy, file = "y.txt", row.name=FALSE)
    write.table(X_means, file = "X_means.txt", row.name=FALSE)