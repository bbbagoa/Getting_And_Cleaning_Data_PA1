# Data Science Specialization - Getting and Cleaning Data Course Project
# Brice Baem BAGOA: Peer graded Assignment

library(dplyr)

# Setting the working directory
setwd("D:\\Learning\\Data Science Specialization\\Reproducible Research\\UCI HAR Dataset")

# 1. Merges the training and the test sets to create one data set.
# ---------------------------------------------------------------

# Read feature list and activity names
features_names <- read.table("features.txt", col.names = c("no","features"))
activities_names <- read.table("activity_labels.txt", col.names = c("label", "activity"))


# Combine the test data into one dataframe called test_vf
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features_names$features)
y_test <- read.table("test/Y_test.txt", col.names = "label")
y_test <- merge(y_test, activities_names, by = "label")

test_vf <- cbind(subject_test, y_test, x_test)


# Combine the test data into one dataframe called train_vf
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features_names$features)
y_train <- read.table("train/Y_train.txt", col.names = "label")
y_train <- merge(y_train, activities_names, by = "label")

train_vf <- cbind(subject_train, y_train, x_train)

# Our final dataset
dataset_1 <- rbind(test_vf, train_vf)


# 2. Extracts only the measurements on the mean and standard 
# deviation for each measurement.
# --------------------------------------------------------------------

# Extract mean and standard deviation

columns <- colnames(dataset_1)

mean_std <- (grepl("activityId" , columns) | 
                   grepl("label" , columns) | 
                   grepl("mean.." , columns) | 
                   grepl("std.." , columns) 
)

dataset_2 <- dataset_1[ , mean_std == TRUE]

# 3. Uses descriptive activity names to name the activities in the data set
# --------------------------------------------------------------------

dataset_3 <- merge(dataset_2, activities_names,
                              by='label',
                              all.x=TRUE)

# 4. Appropriately labels the data set with descriptive variable names.
# ----------------------------------------------------------------------

names(dataset_1)  ## Done in Q1

# 5. From the data set in step 4, creates a second, independent tidy 
# data set with the average of each variable for each activity and each subject.
# ----------------------------------------------------------------------

dataset_4 <- aggregate(. ~subject + label, dataset_1, mean)
dataset_4 <- dataset_4[order(dataset_4$subject, dataset_4$label),]

write.table(dataset_4, "final_dataset.txt", row.name=FALSE)
