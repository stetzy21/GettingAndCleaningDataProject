library(dplyr)
library(data.table)

# set working directory
setwd("C:/Users/Hernandez/Desktop/R_Scripts/GettingAndCleaningDataProject")

filename <- "getdata_projectfiles_UCI HAR Dataset.zip"

## Download and unzip the dataset if it doesn't already exist
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

# read in features and only select those with mean() or std()
features <- fread("UCI HAR Dataset/features.txt", colClasses = c("NULL", "character"), col.names = "Feature_Name")
features_filtered <- grep(".*mean\\().*|.*std\\().*", features$Feature_Name)
features <- filter(features, grepl("*mean\\()|*std\\()*", Feature_Name))

# Merge activity labels with y_test to associate ids with activity names
test_activity_names <- merge(fread("UCI HAR Dataset/test/y_test.txt", col.names = "Activity_ID"), 
                             fread("UCI HAR Dataset/activity_labels.txt", col.names = c("Activity_ID", "Activity_Name")), sort = FALSE)

# Merge activity labels with y_train to associate ids with activity names
train_activity_names <- merge(fread("UCI HAR Dataset/train/y_train.txt", col.names = "Activity_ID"), 
                              fread("UCI HAR Dataset/activity_labels.txt", col.names = c("Activity_ID", "Activity_Name")), sort = FALSE)

# read in and merge test set, test labels, and subject information
test_set <- cbind(fread("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject_ID"), test_activity_names[,"Activity_Name"], fread("UCI HAR Dataset/test/X_test.txt")[,..features_filtered])

# read in and merge training set, training labels, and subject information
training_set <- cbind(fread("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject_ID"), train_activity_names[, "Activity_Name"], fread("UCI HAR Dataset/train/X_train.txt")[,..features_filtered])

# merge the test_set and training_set together
merged_set <- rbind(test_set, training_set)


# read in column names and assign to merged data set
colnames(merged_set) <- c("Subject_ID", "Activity_Name", unlist(features))


# select data set to only include columns with mean or std
tidy_set <- merged_set %>% select(Subject_ID, Activity_Name, contains("mean()"), contains("std()"))

# rename columns to be more descriptive
names(tidy_set) <- gsub("Acc", "Accelerometer", names(tidy_set))
names(tidy_set) <- gsub("Gyro", "Gyroscope", names(tidy_set))
names(tidy_set) <- gsub("Mag", "Magnitude", names(tidy_set))
names(tidy_set) <- gsub("tBody", "TimeBody", names(tidy_set))
names(tidy_set) <- gsub("^t", "Time", names(tidy_set))
names(tidy_set) <- gsub("^f", "Frequency", names(tidy_set))
names(tidy_set) <- gsub("-mean\\()", "Mean", names(tidy_set))
names(tidy_set) <- gsub("gravity", "Gravity", names(tidy_set))
names(tidy_set) <- gsub("-std\\()", "STD", names(tidy_set))

# summarize the data by subject and activity
Summarized_set <- tidy_set %>% group_by(Subject_ID, Activity_Name) %>% summarize_all(mean)

# Write the output to a table for class submission
write.table(Summarized_set, file = "tidy_data.txt", sep = "\t", row.name = FALSE)