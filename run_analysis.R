# Script for course project "Getting an Cleaning Data"

library(readr)
library(dplyr)
library(stringr)

## 0. Download original dataset

zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
    download.file(zipUrl, zipFile, mode = "wb")
}

# unzip zip file containing data if data directory doesn't already exist
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
    unzip(zipFile)
}


## 1. Merge the training and the test sets to create one data set
## The resulting dataset is in variable all_data

### Read all necessary data
X_test <- read_table2("UCI HAR Dataset/test/X_test.txt", 
                      col_names = FALSE)
y_test <- read_csv("UCI HAR Dataset/test/y_test.txt", 
                   col_names = FALSE)
subject_test <- read_csv("UCI HAR Dataset/test/subject_test.txt", 
                         col_names = FALSE)
X_train <- read_table2("UCI HAR Dataset/train/X_train.txt", 
                       col_names = FALSE)
y_train <- read_csv("UCI HAR Dataset/train/y_train.txt", 
                    col_names = FALSE)
subject_train <- read_csv("UCI HAR Dataset/train/subject_train.txt", 
                         col_names = FALSE)
features <- as.vector(read_table2("UCI HAR Dataset/features.txt", 
                                  col_names = FALSE, col_types = cols(`1` = col_skip(), 
                                                                      X1 = col_skip())))
activity_labels <- read_table2("UCI HAR Dataset/activity_labels.txt", 
                               col_names = FALSE)

names(activity_labels) <- c("code", "activity")
names(features) <- "name"

### Combine train and test data of each set and name tidily
all_subject <- rbind(subject_train, subject_test)
names(all_subject) <- "subject"

all_y <- rbind(y_train, y_test)
names(all_y) <- "activity_code"

all_X <- rbind(X_train, X_test)
names(all_X) <- features[[1]]

all_data <- cbind(all_subject, all_y, all_X)


## 2. Extract only the measurements on the mean and standard deviation 
## for each measurement
## The resulting dataset is in variable mean_std_data

X_features <- mutate(features, keep_column = str_detect(name,"(mean|std)\\(\\)"))

# add two lines in logical vector to keep columns for subject and activity code 
all_features <- rbind(c("subject", TRUE), c("activity_code", TRUE), X_features)

mean_std_data <- all_data[,as.logical(all_features$keep_column)]

## 3. Use descriptive activity names to name the activities in the data set
## The resulting dataset is in variable tidy_data

tidy_data <- left_join(mean_std_data, activity_labels, by=c("activity_code" = "code") )
tidy_data <- tidy_data[,c(1,69,3:68)]

## 4. Appropriately label the data set with descriptive variable names

##      This has been done above already

## 5. From the data set in step 4, create a second, independent tidy data set 
## with the average of each variable for each activity and each subject
## The resulting dataset is in variable X_means

tidy_average_data <- tidy_data %>% group_by(subject, activity) %>% 
    summarise_all(mean) 

## Write resulting datasets to files
write.table(tidy_average_data, file = "tidy_average_data.txt", row.name=FALSE)
