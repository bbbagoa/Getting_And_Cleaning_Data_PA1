---
title: "Getting and Cleaning Data Assignment"
author: "Brice Baem BAGOA"
date: "May 14, 2018"
output: html_document

subtitle: 'Peer-graded Assignment'
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_knit$set(root.dir = "D:\\Learning\\Data Science Specialization\\Reproducible Research\\UCI HAR Dataset")
```

### Intro : Loading and preprocessing the data

```{r}

library(dplyr)

# Setting the working directory
getwd()
```


Read feature list and activity names

We need tp read the features and activities files by specifiying the columns. We will the read the `features.txt` and `activity_labels.txt`.


```{r}
features_names <- read.table("features.txt", col.names = c("no","features"))
activities_names <- read.table("activity_labels.txt", col.names = c("label", "activity"))
```

Combine the test data into one dataframe called `test_vf`.


```{r}
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features_names$features)
y_test <- read.table("test/Y_test.txt", col.names = "label")
y_test <- merge(y_test, activities_names, by = "label")

test_vf <- cbind(subject_test, y_test, x_test)
```


 Combine the test data into one dataframe called `train_vf`.

```{r}
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features_names$features)
y_train <- read.table("train/Y_train.txt", col.names = "label")
y_train <- merge(y_train, activities_names, by = "label")

train_vf <- cbind(subject_train, y_train, x_train)
```

### 1. Merges the training and the test sets to create one data set.

```{r}
# Our final dataset
dataset_1 <- rbind(test_vf, train_vf)
```

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

We first need to extract the columns names and then use the 

```{r}
columns <- colnames(dataset_1)

mean_std <- (grepl("activityId" , columns) | 
                   grepl("label" , columns) | 
                   grepl("mean.." , columns) | 
                   grepl("std.." , columns) 
)

dataset_2 <- dataset_1[ , mean_std == TRUE]
```


### 3. Uses descriptive activity names to name the activities in the data set

```{r}
dataset_3 <- merge(dataset_2, activities_names,
                              by='label',
                              all.x=TRUE)
```

### 4. Appropriately labels the data set with descriptive variable names.

This has aldredy been done in part 1 and the data set is `dataset_1`.

```{r echo=FALSE }
## Done in Q1. So We will use dataset_1
```

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


```{r}
dataset_4 <- aggregate(. ~subject + label, dataset_1, mean)
dataset_4 <- dataset_4[order(dataset_4$subject, dataset_4$label),]
```

Export our final data set

```{r}
write.table(dataset_4, "final_dataset.txt", row.name=FALSE)
```
