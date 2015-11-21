# Installs and loads data.table and dplyr if they are not already installed and loaded
x <- ls() 
if (length(x) != 0) { 
rm(list=ls())
}

# Installs and loads data.table and dplyr if they are not already installed and loaded
if(!require(data.table)){
  install.packages("data.table")
  library(data.table)
}

if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

# Creates a working directory in which downloaded data and data 
# sets will sit, if it doesn't already exist
data_dir <- "./UCIHARDatasetData"
if(!dir.exists(data_dir)){dir.create(data_dir)}
 
# Download the required zip file if it hasn't already been downloaded 
data_file <- file.path(data_dir, "getdata-projectfiles-UCI HAR Dataset.zip")
if(!file.exists(data_file)){
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(URL, destfile=data_file)
}

# Unzip the file and load files in the specific directory
unzip(data_file,exdir=data_dir)

# load the list of unzipped files in a data table for review, if necessary 
tbl_data_files<-data.table(list.files(data_dir, recursive=TRUE)) 

#MERGE 
# Read the (Y_) the test and training files into dataframes,
# combine those data frames by row,
# and then name the only column in the data frame "Activity"

df_dataActivityTest  <- read.table(file.path(data_dir, "UCI HAR Dataset","test" , "Y_test.txt" ),header = FALSE)
df_dataActivityTrain <- read.table(file.path(data_dir, "UCI HAR Dataset","train", "Y_train.txt"),header = FALSE)
df_Activity <- rbind(df_dataActivityTest, df_dataActivityTrain)
names(df_Activity)<- c("Activity")

#str(df_Activity) # If required, review the structure of df_Activity

# Read the (X_) test and training files into dataframes,
# and combine those data frames by row.

df_dataMeasurementTest  <- read.table(file.path(data_dir, "UCI HAR Dataset","test" , "X_test.txt" ),header = FALSE)
df_dataMeasurementTrain <- read.table(file.path(data_dir, "UCI HAR Dataset","train", "X_train.txt"),header = FALSE)
df_Measurement <- rbind(df_dataMeasurementTest, df_dataMeasurementTrain)

#str(df_Measurement) # If required, review the structure of df_Measurement

# Read the features file into a dataframe,
# and use the list of descriptors as column headings in df_Measurement 
df_FeaturesNames <- read.table(file.path(data_dir, "UCI HAR Dataset","features.txt"),header=FALSE,stringsAsFactor = FALSE)
names(df_Measurement)<- df_FeaturesNames$V2


# Read the (subject_) test and training files into dataframes,
# and combine those data frames by row.
# and then name the only column in the data frame "Subject"
df_dataSubjectTest  <- read.table(file.path(data_dir, "UCI HAR Dataset","test" , "subject_test.txt" ),header = FALSE)
df_dataSubjectTrain <- read.table(file.path(data_dir, "UCI HAR Dataset","train", "subject_train.txt"),header = FALSE)
df_Subject <- rbind(df_dataSubjectTest, df_dataSubjectTrain)
names(df_Subject)<-c("Subject")

# str(df_Subject) # If required, review the structure of df_Subject

# Combine all three data frames: 
# df Measurement, df_Subject, and df_Activity by column 
# into a single data frame 

Data <- cbind(df_Measurement, df_Subject, df_Activity)
#str(Data) # If required, review the structure of Data

# Select only data related to mean and standard 
# deviation for each measurement by matching appropriate character strings in column headings in Data.
df_FeaturesMeanStdOnly<-df_FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", df_FeaturesNames$V2)]
NamesofInterest<-c(as.character(df_FeaturesMeanStdOnly), "Subject", "Activity")
Data<-subset(Data,select=NamesofInterest)

# Replace codes with their activity labels and replace abbreviated column headers 
# with more descriptive activity names 
df_ActivityLabels <- read.table(file.path(data_dir, "UCI HAR Dataset","activity_labels.txt"),header = FALSE)

Data$Activity[Data$Activity == 1] <- as.character(df_ActivityLabels$V2[df_ActivityLabels$V1 == 1])
Data$Activity[Data$Activity == 2] <- as.character(df_ActivityLabels$V2[df_ActivityLabels$V1 == 2])
Data$Activity[Data$Activity == 3] <- as.character(df_ActivityLabels$V2[df_ActivityLabels$V1 == 3])
Data$Activity[Data$Activity == 4] <- as.character(df_ActivityLabels$V2[df_ActivityLabels$V1 == 4])
Data$Activity[Data$Activity == 5] <- as.character(df_ActivityLabels$V2[df_ActivityLabels$V1 == 5])
Data$Activity[Data$Activity == 6] <- as.character(df_ActivityLabels$V2[df_ActivityLabels$V1 == 6])

factor(Data$Activity)

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

# Group Data by Subject and Activity, and then calculate the mean for each group. 
tidy_data <- Data %>%
group_by(Subject, Activity) %>%
summarise_each(funs(mean))

# Write tidy_data to a .txt file and .csv file. 
write.csv(tidy_data, "./UCIHARDatasetData/tidydata.csv", row.names = FALSE)
write.table(tidy_data, "./UCIHARDatasetData/tidydata.txt", row.names = FALSE)





