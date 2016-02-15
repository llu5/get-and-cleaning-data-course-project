# Code Book for Assignment: Getting and Cleaning Data Course Project
## A Description of steps for creating output and variables in the steps
## Preparation step: Downloading file
###. Create folder named "data"" and download file by using downloader into this folder 
Variables:
1.fileUrl: URL for downloading the source zipped data file.
### unzip the HARdataset.zip file to create a folder named "UCI HAR Dataset"

### Read data from the files into the variables
In this step, variables of data frame type are created by reading files in unzipped folder:
#### In this step, data frame variables of each category are created by reading from files:
1. dataActivityTest: a data frame variable read from activity of test data set.
2. dataActivityTrain: a data frame variable read from activity of training data set.
3. dataFeaturesTest: a data frame variable read from features of test data set
4. dataFeaturesTrain: a data frame variable read from features of test data set
5. dataSubjectTrain: a data frame variable read from subject of training data set. 
6. dataSubjectTest: a data frame variable read from suject of test data set

##1. Merges the training and the test sets to create one data set.

###. Merge the data tables of test and training subsets by rows
#### In this step, variables of combined datasets for subject, activity and features are created:
1. dataSubject: a combined data set containing both training and test data sets for subject. 
2. dataActivity: a combined data set containing both training and test data sets for acticvity.
3. dataFeatures: a combined data set containing both training and test data sets for features.
####  Add column names of subject, activity and feature variable to variables

#### Merge all columns of three data frames of same number of rows into one data frame
1. dataMergeSubjectActivity: a data frame with columns of two data frames of subject and activity.
2. completeData: a data frame with columns of three data frames of subject, activity and features.
##2. Extracts only the measurements on the mean and standard deviation for each measurement.
### Create a subset of feature names with ...Mean), mean() and std
subdataFeaturesNames: a subset of feature names with mean(), Mean) or std() in the column name created by using regular expression
### Create a subset from complete data by seleted feature columns, subject and activity
1. selectedNames: This is a list of column names with all columns and subject and activity columns
2. mean_std_data: This is a dataset with column names as defined in selectedNames variable.
##3. Uses descriptive activity names to name the activities in the data set
### Add charactor factor of activity code to the subset data frame.
1. mean_std_data$activity: In this column, the descriptive  names of activity replaced the number of activity code 

##4. Appropriately labels the data set with descriptive variable names.
names(mean_std_data): The column names are now added with labels to replace less descriptive abbreviations
1  Accelerator for Acc
2. Magnitude for Mag
3. Gyroscope for Gyr
4. time for t
5. frequency for t
##5  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
### In this step: aggregate function of plyr package is used to create means of all measurements by subject and activity and then a file is created as output:
1. tidy_data: a tidy data frame variable created after aggregation with average of measurement by subject and activity.
2. ordered_tidy_data: a final data frame variable ordered by subject and activity
3. ordered_tidydata.csv: an output file created by writing the final data frame 
