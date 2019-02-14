# Description of original and final data

## Original data

- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment

Each of these data is available for 7352 train cases and 2947 test cases.

For further details execute run_analysis.R which will download the data and descriptions. Then refer to
* /UCI HAR Dataset/README.txt
* /UCI HAR Dataset/features_info.txt

## Resulting data

The resulting data in tidy_average_data.txt consists of 180 rows and 68 columns:
* Columns
  * subject - an integer representing one of 30 subjects taking part in the original experiment
  * activity - labels indicating one of the six activities "LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DONWSTAIRS", "WALKING_UPSTAIRS"
  * selection of 66 features of the original 561-feature vector which represent mean or standard deviations
* Rows
  * All possible combinations of the 30 subjects and 6 activity levels
* Data
  * Averages for the 66 selected features
