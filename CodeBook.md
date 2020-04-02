---
title: "CodeBook"
author: "Kevin Neeld"
date: "4/2/2020"
output:
  html_document: default
  pdf_document: default
---

#Code Book

The run_analysis.R script reads in wearable technology data, and then performs 5 steps according to the guidelines of the Getting and Cleaning Data Course Project.   

##Downloading and Reading in Data

- Data was downloaded and unzipped within a folder called 'UCI HAR Dataset'.  

- 'features' <- 'features.txt' (561 obs. of 2 variables)  
	The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and   tGyro-XYZ

- 'labels' <- 'activity_labels.txt' (6 obs. of 2 variables)  
	List of the 6 activities performed during measurement and their code
 
- 'subject_test' <- 'test/subject_test.txt' (2947 obs. of 1 variable)  
	Subject identifying data for the “test” group, 30% (9/30) of observed subjects
- 'x_test' <- 'test/X_test.txt' (2947 obs. of 561 variables)  
	Testing data (i.e. data for “features”) for the test group
- 'y_test' <- 'test/y_test.txt' (2947 obs. of 1 variable)  
	Coded activity identifying data for the test group
- 'subject_train' <- 'train/subject_train.txt' (7352 obs. of 1 variable)  
	Subject identifying data for the “train” group, 70% (21/30) of observed subjects
- 'x_train' <- 'train/X_train.txt' (7352 obs. of 561 variables)  
	Testing data (i.e. data for “features”) for the train group
- 'y_train' <- 'train/y_train.txt' (7352 obs. of 1 variable)  
	Coded activity identifying data for the train group

##Step 1. Merges the training and the test sets to create one data set.

- 'x_data' <- **rbind** of 'x_test' and 'x_train' to create one table with all *x data* (10299 obs. of 561 var.)  
- 'y_data' <- **rbind** of 'y_test' and 'y_train' to create one table with all *y data* (10299 obs. of 1 var.)  
- 'subject_data' <- **rbind** of 'subject_test' and 'subject_train' to create one table with all *subject data* (10299 obs. of 1 var.)  - 'merged' <- **cbind** of 'subject_data', 'y_data', 'x_data' (10299 obs. of 563 var.)  

##Step 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

- 'names' <- names of variables in ‘merged’ dataset  
- 'mean_sd_columns' <- **grep** to find all columns within ‘names’ that contain "subject|activity|[Mm]ean|std"  
- 'mean_sd' <- subset of ‘merged’ that contains columns identified in ‘mean_sd_columns’ (10299 obs. of 88 var.)  

##Step 3. Uses descriptive activity names to name the activities in the data set

- 'mean_sd$activit'y <- reassigns values to ‘activity’ column of ‘mean_sd’ dataset using the 2 column of the ‘labels’ dataset (i.e. the activity labels)  

##Step 4. Appropriately labels the data set with descriptive variable names. 

Uses **gsub()** to make the following changes within all variable names: 
- Names starting with the single character ‘t’ to ‘time’  
- Names starting with the single character ‘f’ to ‘frequency’  
- ‘Acc’ to ‘Accelerometer’  
- ‘Gyro’ to “Gyroscope’  
- ‘Mag’ to ‘Magnitude’  
- ‘BodyBody’ to ‘Body’  
- ‘tBody’ to ‘timeBody’  
- ‘Freq’ to ‘Frequency’  
- ‘gravity’ to ‘Gravity’  
- ‘-mean’ to ‘Mean’  
- ‘-std’ to ‘STD’  
- And remove all punctuation using ‘[[:punct:]]’ to ‘’  

##Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

- 'avg_activity_subject' <- takes the 'mean_sd' data set, groups by 'activity' and 'subject', then summarizes each variable for each group by taking the mean (180 obs. of 88 variables)  

- Exports 'avg_activity_subject' to 'avgdata.txt' file.  
