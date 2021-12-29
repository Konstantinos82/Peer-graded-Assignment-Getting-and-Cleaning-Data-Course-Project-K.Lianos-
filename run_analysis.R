## 1. Download dataset / create folder to store it

data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./UCI_dataset")){
  dir.create("./UCI_dataset")
}

download.file(data_url, destfile = "./UCI_dataset/data_assignment.zip",
              method = "curl")

## 2. Manually unzip the file

## 3. Read datasets ( training / test )

subject_test <- read.table("./UCI_dataset/data_assignment/UCI HAR Dataset/test/subject_test.txt",
                           col.names = "subject")

X_test <- read.table("./UCI_dataset/data_assignment/UCI HAR Dataset/test/X_test.txt")

y_test <- read.table("./UCI_dataset/data_assignment/UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./UCI_dataset/data_assignment/UCI HAR Dataset/train/subject_train.txt",
                            col.names = "subject")

X_train <- read.table("./UCI_dataset/data_assignment/UCI HAR Dataset/train/X_train.txt")

y_train <- read.table("./UCI_dataset/data_assignment/UCI HAR Dataset/train/y_train.txt")



## 4. str function to inspect each table

str(subject_test)
str(X_test)
str(y_test)
str(subject_train)
str(X_train)
str(y_train)


### 5. Read features.txt / activities.txt files  which contains variable names

features <- read.table("./UCI_dataset/data_assignment/UCI HAR Dataset/features.txt",
                       col.names = c("number","features"))
str(features)

activity_labels <- read.table("./UCI_dataset/data_assignment/UCI HAR Dataset/activity_labels.txt"
                             ,col.names = c("id","activity"))

str(activity_labels)

### 6. Assigning variable names to create a tidy dataset

f_names <- features$features

colnames(X_test) <- f_names
colnames(X_train) <- f_names

colnames(y_train) <- "id"
colnames(y_test) <- "id"

### 7.  STEP 1. Merge the training and the test sets to create one data set

subject <- rbind(subject_test,subject_train)
y <- rbind(y_test, y_train)
x <- rbind(X_test, X_train)

str(subject)
str(y)
str(subject)

Merged_data <- cbind(subject,y,x)
str(Merged_data)

### 8. Step 2: Extracts only the measurements on the mean and standard deviation for each measurement

selected_data <- Merged_data[grep("([M,m]ean|[S,s]td)", names(Merged_data))]

Merged <- cbind(subject,y,selected_data)

rm(selected_data)
rm(Merged_data)

###  9.  Step 3: Uses descriptive activity names to name the activities in the data set


Merged$id <- activity_labels[Merged$id,2]

### 10. Step 4. Appropriately labels the data set with descriptive variable names

# Change variable names, starting with "t" to "Time"

names(Merged) <- gsub("^t", "Time", names(Merged))

# Change variable names, starting with "f" to "Frequency"

names(Merged) <- gsub("^f", "Frequency", names(Merged))

# Change variable name "Acc" to "Accelerometer"

names(Merged) <- gsub("Acc", "Accelerometer", names(Merged))

# Change variable name "Mag" to "Magnitude"

names(Merged) <- gsub("Mag", "Magnitude", names(Merged))

# change variable name "Gyro" to "Gyroscope"

names(Merged) <- gsub("Gyro", "Gyroscope", names(Merged))

# change variable name "BodyBody" to "Body"

names(Merged) <- gsub("BodyBody", "Body", names(Merged))

# change variable name "gravity" to "Gravity"

names(Merged) <- gsub("gravity", "Gravity", names(Merged))

# change variable name "angle" to "Angle"

names(Merged) <- gsub("angle", "Angle", names(Merged))

# change variable name "-freq()" to "Frequency" 

names(Merged) <- gsub("-freq()", "Frequency", names(Merged))

# change variable name "-mean()" to "Mean" 

names(Merged) <- gsub("-mean()", "Mean", names(Merged))

# change variable name "-std()" to "STD"

names(Merged) <- gsub("-std()", "STD", names(Merged))

# remove parentheses and comma symbols from titles

names(Merged) <- gsub("[()]", "", names(Merged))

names(Merged) <- gsub("[,]", "", names(Merged))

# rename second column variable from "id" to "Activity"

names(Merged)[2] <- "Activity"

## 11.	Step 5. From the data set in step 4, creates a second, independent 
##      tidy data set with the average of each variable for each activity 
##      and each subject

library(dplyr)

HumActRecSmart <- Merged %>% group_by(subject,Activity) %>% summarise_all(funs(mean))

## 12. The final tidy dataset 

write.table(HumActRecSmart,"HumActRecSmart.txt",row.names = FALSE)

#############################################################################





