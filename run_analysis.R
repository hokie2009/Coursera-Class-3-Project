#This script serves to complete the course project.


#grab libraries necessary
library(plyr)

#the data set must be downloaded and unzipped in the working directory
#do not rename anything and leave all files in the folder

setwd("~/UCI HAR Dataset")

#load necessary files into variables
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

#combine training and test data for each
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

#This portoin reads into a table and extracts only items names with std or mean
features <- read.table("features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_and_std_features]
names(x_data) <- features[mean_and_std_features, 2]

#This portion renames the activities to their descriptions provided
activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

#do the same for descriptions of variable names
names(subject_data) <- "subject"

#bind everything together
all_data <- cbind(x_data, y_data, subject_data)

#create a tidy data set
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "data.txt", row.name=FALSE)