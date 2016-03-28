

# Merging training and test data sets 
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# combine test and train
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Load and Select columns
features <- read.table("UCI HAR Dataset/features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_and_std_features]

# Fix labels and column names
names(x_data) <- features[mean_and_std_features, 2]
names(x_data) <- gsub('-mean', '_Mean', names(x_data))
names(x_data) <- gsub('-std', '_Std', names(x_data))
names(x_data) <- gsub('[-()]', '', names(x_data))
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "Activity"
names(subject_data) <- "Subject"


# Combine all data into tidy 
all_data <- cbind(x_data, y_data, subject_data)


# Create averages for tidy data and write to fil
averages_data <- ddply(all_data, .(Subject, Activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "tidy_data_avg.txt", row.name=FALSE)


