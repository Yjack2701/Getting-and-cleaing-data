library(data.table)

#get and unzip data
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "getdata_projectfiles_UCI HAR Dataset.zip"))
unzip(zipfile = "getdata_projectfiles_UCI HAR Datasets.zip")

#import and combines test and train X data
temp_1 <- read.table(file.path(path,"UCI HAR Dataset/train/X_train.txt"))
temp_2 <- read.table(file.path(path,"UCI HAR Dataset/test/X_test.txt"))
X_data <- rbind(temp_1, temp_2)

#import and combines test and train Y data
temp_1 <- read.table(file.path(path,"UCI HAR Dataset/train/y_train.txt"))
temp_2 <- read.table(file.path(path,"UCI HAR Dataset/test/y_test.txt"))
Y_data <- rbind(temp_1, temp_2)

#import and combines test and train subject data
temp_1 <- read.table(file.path(path,"UCI HAR Dataset/train/subject_train.txt"))
temp_2 <- read.table(file.path(path,"UCI HAR Dataset/test/subject_test.txt"))
Subject_data <- rbind(temp_1, temp_2)

# Merge into 1 dataset below

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table(file.path(path,"UCI HAR Dataset/features.txt"))
names(X) <- features$V2
index_of_good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X_data <- X_data[, index_of_good_features]

# 3.Uses descriptive activity names to name the activities in the data set.
Y_data$V1[Y_data$V1=='1']<- 'WALKING'
Y_data$V1[Y_data$V1=='2']<- 'WALKING_UPSTAIRS'
Y_data$V1[Y_data$V1=='3']<- 'WALKING_DOWNSTAIRS'
Y_data$V1[Y_data$V1=='4']<- 'SITTING'
Y_data$V1[Y_data$V1=='5']<- 'STANDING'
Y_data$V1[Y_data$V1=='6']<- 'LAYING'
names(Y_data)<- "Activity"


# 4.Appropriately labels the data set with descriptive activity names, Merges the training and the test sets to create one data set

names(Subject_data) <- "subjectID"
clean <- cbind(Subject_data, Y_data, X_data)
write.table(clean, "merged_data.txt")

# 5.Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
DT<-data.table(clean)
tidy<-DT[,lapply(.SD,mean),by="subjectID,Activity"]
write.table(tidy, "tidy_data.txt", row.name=FALSE)
