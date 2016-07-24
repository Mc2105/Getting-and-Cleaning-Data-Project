# Make sure the data is in the work dir
# Unzip the data
unzip("./getdata%2Fprojectfiles%2FUCI HAR Dataset.zip")

# Read and marge the data
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
x <- rbind(train_x, test_x)

train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
y <- rbind(train_y, test_y)

train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(train_subject, test_subject)

Merged_data <- cbind(subject, y, x)

# Extracts only the measurements on the mean and standard deviation for each measurement
read_feature <- read.table("./UCI HAR Dataset/features.txt")
feature <- as.character(read_feature[,2])
colnames(Merged_data) <- c("subject", "activity", feature)
features_we_need <- grep(("mean\\(\\)|std\\(\\)"), feature)
data <- Merged_data[,c(1, 2, features_we_need + 2)]

# Uses descriptive activity names to name the activities in the data set
# So we will replace activities' labels with activity names
Names <- read.table("./UCI HAR Dataset/activity_labels.txt")
data$activity <- factor(data$activity, Names[,1], Names[,2])

# Appropriately labels the data set with descriptive variable names
# replace "t" by "Time-" and "f" by "Frequence-" and remove "()"
names(data) <- gsub("\\()", "", names(data))
names(data) <- gsub("^t", "Time-", names(data))
names(data) <- gsub("^f", "Frequence-", names(data))

# creates a tidy data set
library(dplyr)
Result <- data %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.table(Result, "Result.txt", row.name=FALSE)