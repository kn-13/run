library(dplyr)
library(plyr)
library(knitr)
##Download data and unzip file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/rundata.zip",method="curl")
unzip(zipfile = "./data/rundata.zip", exdir="./data")
dataDownloaded <- date()

##Read in the files
list.files("./data/UCI HAR Dataset/", recursive = TRUE)

features <- read.table("./data/UCI HAR Dataset/features.txt")
labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

#1.	Merge the training and test sets to create one data set
x_data <- rbind(x_test,x_train)
y_data <- rbind(y_test,y_train)
subject_data <- rbind(subject_test, subject_train)

    #Name variables
names(x_data) <- features$V2
names(y_data) <- c("activity")
names(subject_data) <- c("subject")

merged <- cbind(subject_data, y_data, x_data)
names(merged)
str(merged)

#2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
names <- names(merged)
mean_sd_columns <- grep("subject|activity|[Mm]ean|std", names, value=FALSE)
mean_sd <- merged[, mean_sd_columns]
str(mean_sd)

#3.	Uses descriptive activity names to name the activities in the data set
mean_sd$activity <- labels[mean_sd$activity, 2]

#4.	Appropriately labels the data set with descriptive variable names. 
names(mean_sd)
names(mean_sd)<-gsub("^t", "time", names(mean_sd))
names(mean_sd)<-gsub("^f", "frequency", names(mean_sd))
names(mean_sd)<-gsub("Acc", "Accelerometer", names(mean_sd))
names(mean_sd)<-gsub("Gyro", "Gyroscope", names(mean_sd))
names(mean_sd)<-gsub("Mag", "Magnitude", names(mean_sd))
names(mean_sd)<-gsub("BodyBody", "Body", names(mean_sd))
names(mean_sd)<-gsub("tBody", "timeBody", names(mean_sd))
names(mean_sd)<-gsub("Freq", "Frequency", names(mean_sd))
names(mean_sd)<-gsub("gravity", "Gravity", names(mean_sd))
names(mean_sd)<-gsub("-mean", "Mean", names(mean_sd))
names(mean_sd)<-gsub("-std", "STD", names(mean_sd))
names(mean_sd)<-gsub("[[:punct:]]","", names(mean_sd))
names(mean_sd)

#5.	From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.

avg_activity_subject <- mean_sd %>%
    group_by(activity,subject) %>%
    summarize_all(funs(mean))
head(avg_activity_subject)

write.table(avg_activity_subject, file = "avgdata.txt", row.names = FALSE)

knit("CodeBook.Rmd")
knit("README.Rmd")
