##run_Analysis.R

The following script is designed to take a messy collection of data from smartphone devices and transform it into a clean and readable tidy data set. The script adheres to the following guidelines or directives: 

-Merge training and the test datasets. 
-Extract only data related to the mean and standard deviation of each measurement. 
-Use descriptive activity names to name the activities in the data set.
-Label the data set with descriptive variable names. 
-Create a second, independent tidy data set with the average of each variable for each activity and each subject.

The data was collected from smartphones used by 30 volunteers wearing smartphones who were engaged in up to six daily activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). Both acceleration and angular velocity were captured.  The dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.  This exercise combines those datasets into a single dataset.

A full description of the dataset is available from: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data used in this project is available at: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Each record in the dataset includes:
- acceleration data.
- angular velocity data.
- a 561-feature vector with time and frequency domain variables.
- an activity label, and
- an subject ID.

The script associated with this exercise is run_analysis.R
The codebook associated with this exercise is Codebook_run_analysis_R. 

The content in this file is based on course materials and the internet sources listed above.