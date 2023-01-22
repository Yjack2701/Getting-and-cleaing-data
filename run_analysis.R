library(data.table)

path <- getwd()
#import and combines test and train X data
temp_train <- read.table(file.path(path,"UCI HAR Dataset/train/X_train.txt"))
temp_test <- read.table(file.path(path,"UCI HAR Dataset/test/X_test.txt"))
X <- rbind(temp_train, temp_test)

#import and combines test and train Y data
temp_train <- read.table(file.path(path,"UCI HAR Dataset/train/y_train.txt"))
temp_test <- read.table(file.path(path,"UCI HAR Dataset/test/y_test.txt"))
Y <- rbind(temp_train, temp_test)

#import and combines test and train subject data
temp_train <- read.table(file.path(path,"UCI HAR Dataset/train/subject_train.txt"))
temp_test <- read.table(file.path(path,"UCI HAR Dataset/test/subject_test.txt"))
Subject <- rbind(temp_train, temp_test)

# Merge into 1 dataset below

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table(file.path(path,"UCI HAR Dataset/features.txt"))
names(X) <- features$V2
index_of_good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, index_of_good_features]

# 3.Uses descriptive activity names to name the activities in the data set.
Y$V1[Y$V1=='1']<- 'WALKING'
Y$V1[Y$V1=='2']<- 'WALKING_UPSTAIRS'
Y$V1[Y$V1=='3']<- 'WALKING_DOWNSTAIRS'
Y$V1[Y$V1=='4']<- 'SITTING'
Y$V1[Y$V1=='5']<- 'STANDING'
Y$V1[Y$V1=='6']<- 'LAYING'
names(Y)<- "Activity"


# 4.Appropriately labels the data set with descriptive activity names, Merges the training and the test sets to create one data set

names(Subject) <- "subjectID"
clean <- cbind(Subject, Y, X)
write.table(clean, "merged_data.txt")

# 5.Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
DT<-data.table(clean)
tidy<-DT[,lapply(.SD,mean),by="subjectID,Activity"]
write.table(tidy, "tidy_data.txt", row.name=FALSE)
